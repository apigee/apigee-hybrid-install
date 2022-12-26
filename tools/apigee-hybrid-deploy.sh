#!/usr/bin/env bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eo pipefail

if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
    cat <<EOF >&2
WARNING: bash ${BASH_VERSION} does not support several modern safety features.
This script was written with the latest POSIX standard in mind, and was only
tested with modern shell standards. This script may not perform correctly in
this environment.
EOF
    sleep 1
else
    set -u
fi

################################################################################
#                           User modifiable variables
################################################################################

ORGANIZATION_NAME="${ORGANIZATION_NAME:-""}"                   # --org
APIGEE_NAMESPACE="${APIGEE_NAMESPACE:-"apigee"}"               # --namespace, The kubernetes namespace name where Apigee components will be created
CLUSTER_NAME="${CLUSTER_NAME:-""}"                             # --cluster-name
CLUSTER_REGION="${CLUSTER_REGION:-""}"                         # --cluster-region
# X~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~X END X~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~X

# The following variables control individual actions performed by the script.
CMD_APPLY="0" # [command:apply]
CMD_DELETE="0" # [command:delete]
CMD_GET="0" # [command:get]
INVOKE_ALL="0" # --all
DEPLOY_SERVICE_ACCOUNT_AND_SECRETS="0" # --gcp-sa-and-secrets
DEPLOY_RUNTIME_COMPONENTS="0"          # --runtime-components

VERBOSE="0" # --verbose
DIAGNOSTIC="0" # --diagnostic

HAS_TS="0"
AKUBECTL=""

SCRIPT_NAME="${0##*/}"
SCRIPT_PATH=$(realpath -s "${BASH_SOURCE[0]}")
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
INSTANCE_DIR=""
SERVICE_ACCOUNT_OUTPUT_DIR="${ROOT_DIR}/service-accounts"

# shellcheck disable=SC1090
source "${SCRIPT_DIR}/common.sh" || exit 1


################################################################################
# `main` is the ENTRYPOINT for the shell script.
################################################################################
main() {
    init
    parse_args "${@}"
    check_prerequisites
    resolve_flags
    validate_args
    configure_vars

    if [[ "${DIAGNOSTIC}" == "1" ]]; then
        print_diagnostics
    fi



    if [[ "${CMD_APPLY}" == "1" ]]; then
        if [[ "${DEPLOY_SERVICE_ACCOUNT_AND_SECRETS}" == "1" ]]; then
            deploy_service_accounts
        fi

        if [[ "${DEPLOY_RUNTIME_COMPONENTS}" == "1" ]]; then
            deploy_components
        fi
    fi

    if [[ "${CMD_DELETE}" == "1" ]]; then
        delete_all_apigee_components
    fi

    if [[ "${CMD_GET}" == "1" ]]; then
        list_all_apigee_components
    fi

    banner_info "SUCCESS"
}



################################################################################
# prints internal variable information
################################################################################
print_diagnostics() {

    info ""
    info "Provided and calculated values..."
    info "ORGANIZATION_NAME='${ORGANIZATION_NAME}'"
    info "APIGEE_NAMESPACE='${APIGEE_NAMESPACE}'"
    info "CLUSTER_NAME='${CLUSTER_NAME}'"
    info "CLUSTER_REGION='${CLUSTER_REGION}'"
    info "GCP_PROJECT_ID='${GCP_PROJECT_ID}'"
    info "INSTANCE_DIR='${INSTANCE_DIR}'"
    info ""
    info "Commands..."
    info "CMD_APPLY='${CMD_APPLY}'"
    info "CMD_DELETE='${CMD_DELETE}'"
    info "CMD_GET='${CMD_GET}'"
    info "INVOKE_ALL='${INVOKE_ALL}'"
    info "DEPLOY_SERVICE_ACCOUNT_AND_SECRETS='${DEPLOY_SERVICE_ACCOUNT_AND_SECRETS}'"
    info "DEPLOY_RUNTIME_COMPONENTS='${DEPLOY_RUNTIME_COMPONENTS}'"
    info ""
    info "Flags..."
    info "VERBOSE='${VERBOSE}'"
    info "DIAGNOSTIC='${DIAGNOSTIC}'"
    info ""
    info "Script locations..."
    info "SCRIPT_NAME='${SCRIPT_NAME}'"
    info "SCRIPT_PATH='${SCRIPT_PATH}'"
    info "SCRIPT_DIR='${SCRIPT_DIR}'"
    info "ROOT_DIR='${ROOT_DIR}'"
}





################################################################################
# Deploy GCP service accounts into corresponding kubernetes secrets.
#
################################################################################
deploy_service_accounts() {

    banner_info "Creating kubernetes secrets containing the GCP service account keys..."
    kubectl apply -k "${ROOT_DIR}/overlays/initialization/namespace"


    if [[ -f "${SERVICE_ACCOUNT_OUTPUT_DIR}/${ORGANIZATION_NAME}-apigee-mart.json" ]]; then
        while read -r k8s_sa_name; do
            kubectl create secret generic "${k8s_sa_name}-gcp-sa-key" \
                --from-file="client_secret.json=${SERVICE_ACCOUNT_OUTPUT_DIR}/${ORGANIZATION_NAME}-${k8s_sa_name}.json" \
                -n "${APIGEE_NAMESPACE}" \
                --dry-run=client -o yaml | kubectl apply -f -
        done <<EOF
apigee-logger
apigee-metrics
apigee-cassandra
apigee-udca
apigee-synchronizer
apigee-mart
apigee-watcher
apigee-runtime
EOF


    elif [[ -f "${SERVICE_ACCOUNT_OUTPUT_DIR}/${ORGANIZATION_NAME}-apigee-non-prod.json" ]]; then
        while read -r k8s_sa_name; do
            kubectl create secret generic "${k8s_sa_name}-gcp-sa-key" \
                --from-file="client_secret.json=${SERVICE_ACCOUNT_OUTPUT_DIR}/${ORGANIZATION_NAME}-apigee-non-prod.json" \
                -n "${APIGEE_NAMESPACE}" \
                --dry-run=client -o yaml | kubectl apply -f -
        done <<EOF
apigee-logger
apigee-metrics
apigee-cassandra
apigee-udca
apigee-synchronizer
apigee-mart
apigee-watcher
apigee-runtime
EOF


    else
        info ""
        info "Unable to locate service accounts in ${ROOT_DIR}/service-accounts/"
        info "If these have not been created yet. Please use /tools/create-service-account.sh"
        info ""
        info "If the service accounts have been created and keys downloaded, please confirm the name(s)"
        info "follow the format: {organization-name}-{account-purpose}.json"
        info "Example: {ORGANIZATION_NAME}-apigee-mart.json"
        info ""
        fatal "Unable deploy service account secrets"
    fi


}


################################################################################
# Applies all the yamls in the correct order to the cluster.
################################################################################
deploy_components() {
    banner_info "Creating kubernetes resources..."

    check_if_cert_manager_exists

    if is_open_shift; then
        run kubectl apply -k "${ROOT_DIR}/overlays/initialization/openshift"
    fi

    info "Creating apigee initialization kubernetes resources..."
    run kubectl apply --server-side --force-conflicts -k "${ROOT_DIR}/overlays/initialization"
    # run kubectl apply -f "${ROOT_DIR}/overlays/initialization/namespace.yaml"
    # run kubectl apply -k "${ROOT_DIR}/overlays/initialization/certificates"
    # run kubectl apply --server-side --force-conflicts -k "${ROOT_DIR}/overlays/initialization/crds"
    # run kubectl apply -k "${ROOT_DIR}/overlays/initialization/webhooks"
    # run kubectl apply -k "${ROOT_DIR}/overlays/initialization/rbac"
    # run kubectl apply -k "${ROOT_DIR}/overlays/initialization/ingress"

    info "Creating controllers..."
    run kubectl apply -k "${ROOT_DIR}/overlays/controllers"

    info "Waiting for controllers to be available..."
    run kubectl wait deployment/apigee-controller-manager deployment/apigee-ingressgateway-manager -n "${APIGEE_NAMESPACE}" --for=condition=available --timeout=2m

    info "Creating apigee kubernetes secrets..."
    # Create the datastore and redis secrets first and the rest of the secrets.
# TODO: !!! may need to add bases. Check: datastore
    run find "${INSTANCE_DIR}" -name *secrets.yaml | xargs -n 1 kubectl apply -f

    info "Creating apigee ingress certificates..."
    # Create the datastore and redis secrets first and the rest of the secrets.
    run find "${INSTANCE_DIR}" -name *ingress-certificate.yaml | xargs -n 1 kubectl apply -f

    info "Creating all remaining Apigee resources..."
    # Create the remainder of the resources.
    run kubectl kustomize "${INSTANCE_DIR}" --reorder none | kubectl apply -f -

    # Resources having been successfully created. Now wait for them to start.
    banner_info "Resources have been created. Waiting for them to be ready..."
    run kubectl wait "apigeedatastore/default" \
        "apigeeredis/default" \
        "apigeeorganization/${ORGANIZATION_NAME}" \
        "apigeetelemetry/apigee-telemetry" \
        -n "${APIGEE_NAMESPACE}" --for="jsonpath=.status.state=running" --timeout=15m

    run kubectl wait "apigeeenvironment" --all \
        -n "${APIGEE_NAMESPACE}" --for="jsonpath=.status.state=running" --timeout=15m


}

check_if_cert_manager_exists() {
    local EXITCODE

    EXITCODE="0"
    kubectl get namespaces cert-manager &>/dev/null || EXITCODE="$?"
    if [[ "${EXITCODE}" != "0" ]]; then
        fatal "cert-manager namespace does not exist"
    fi

    EXITCODE="0"
    kubectl get crd clusterissuers.cert-manager.io &>/dev/null || EXITCODE="$?"
    if [[ "${EXITCODE}" != "0" ]]; then
        fatal "clusterissuers CRD does not exist"
    fi
}


delete_all_apigee_components() {

    run ls -1 -d ${ROOT_DIR}/overlays/instances/* | xargs -n 1 kubectl delete -k || true
    run kubectl delete -k ${ROOT_DIR}/overlays/initialization/ingress || true
    run kubectl delete -k ${ROOT_DIR}/overlays/initialization/rbac || true
    run kubectl delete -k ${ROOT_DIR}/overlays/initialization/webhooks || true
    run kubectl delete -k ${ROOT_DIR}/overlays/initialization/crds || true
    run kubectl delete -k ${ROOT_DIR}/overlays/initialization/certificates || true

    run kubectl delete all --all -n ${APIGEE_NAMESPACE} || true
    run kubectl delete jobs --all -n ${APIGEE_NAMESPACE} || true
    run kubectl delete serviceaccounts --all -n ${APIGEE_NAMESPACE} || true
    run kubectl delete configmaps --all -n ${APIGEE_NAMESPACE} || true

    run kubectl delete certificaterequests.cert-manager.io --all -n ${APIGEE_NAMESPACE} || true
    run kubectl delete certificates.cert-manager.io --all -n ${APIGEE_NAMESPACE} || true
    run kubectl delete leases.coordination.k8s.io --all -n ${APIGEE_NAMESPACE} || true

    run kubectl delete secrets --all -n ${APIGEE_NAMESPACE} || true

    run kubectl delete namespace ${APIGEE_NAMESPACE} || true

}


list_all_apigee_components() {

    for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
        echo "Resource:" $i
        kubectl -n ${APIGEE_NAMESPACE} get --ignore-not-found ${i}
    done

}



################################################################################
#   _   _      _                   _____                 _   _
#  | | | | ___| |_ __   ___ _ __  |  ___|   _ _ __   ___| |_(_) ___  _ __  ___
#  | |_| |/ _ \ | '_ \ / _ \ '__| | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#  |  _  |  __/ | |_) |  __/ |    |  _|| |_| | | | | (__| |_| | (_) | | | \__ \
#  |_| |_|\___|_| .__/ \___|_|    |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#               |_|
################################################################################

init() {
    if hash ts 2>/dev/null; then
        HAS_TS="1"
    fi
    readonly HAS_TS

    AKUBECTL="$(which kubectl)"
}

################################################################################
# Check if all the commands that we depend on are installed.
################################################################################
check_prerequisites() {
    local NOTFOUND
    NOTFOUND="0"

    info "Checking prerequisite commands..."
    while read -r dependency; do
        if ! command -v "${dependency}" &>/dev/null; then
            NOTFOUND="1"
            warn "Command '${dependency}' not found."
        fi
    done <<EOF
$AKUBECTL
EOF

    if [[ "${NOTFOUND}" == "1" ]]; then
        fatal "One or more prerequisites are not installed."
    fi
}

################################################################################
# Checks whether the required variables have been populated depending on the
# flags.
################################################################################
validate_args() {

    local VALIDATION_FAILED="0"

    if [[ "${CMD_GET}" == "1" ]]; then
        if [[ "${INVOKE_ALL}" != "1" ]]; then
            VALIDATION_FAILED="1"
            warn "--all Flag REQUIRED with command:get"
        fi
        if [[ -z "${APIGEE_NAMESPACE}" ]]; then
            VALIDATION_FAILED="1"
            warn "--namespace REQUIRED for command:get"
        fi
    fi


    if [[ "${CMD_DELETE}" == "1" ]]; then
        if [[ "${INVOKE_ALL}" != "1" ]]; then
            VALIDATION_FAILED="1"
            warn "--all Flag must be used with command:delete"
        fi
        if [[ -z "${APIGEE_NAMESPACE}" ]]; then
            VALIDATION_FAILED="1"
            warn "--namespace REQUIRED for command:delete"
        fi
    fi


    if [[ "${CMD_APPLY}" == "1" ]]; then
        if [[ -z "${APIGEE_NAMESPACE}" ]]; then
            VALIDATION_FAILED="1"
            warn "--namespace REQUIRED for command:apply"
        fi

        if [[ "${DEPLOY_SERVICE_ACCOUNT_AND_SECRETS}" == "1" ]]; then
            if [[ -z "${ORGANIZATION_NAME}" ]]; then
                VALIDATION_FAILED="1"
                warn "--org REQUIRED to deploy service accounts"
            fi
        fi

        if [[ "${DEPLOY_RUNTIME_COMPONENTS}" == "1" ]]; then
            if [[ -z "${CLUSTER_NAME}" ]]; then
                VALIDATION_FAILED="1"
                warn "--cluster-name REQUIRED to deploy runtime components"
            fi
            if [[ -z "${CLUSTER_REGION}" ]]; then
                VALIDATION_FAILED="1"
                warn "--cluster-region REQUIRED to deploy runtime components"
            fi
        fi

    fi


    if [[ "${VALIDATION_FAILED}" == "1" ]]; then
        info ""
        info "Attributes:"
        info "ORGANIZATION_NAME='${ORGANIZATION_NAME}'"
        info "CLUSTER_NAME='${CLUSTER_NAME}'"
        info "CLUSTER_REGION='${CLUSTER_REGION}'"
        info "APIGEE_NAMESPACE='${APIGEE_NAMESPACE}'"
        fatal "One or more validations failed. Exiting."
    fi


}


################################################################################
# Resolves flags such as --all
################################################################################
resolve_flags() {
    banner_info "Resolving Flags..."

    if [[ "${INVOKE_ALL}" == "1" ]]; then
        DEPLOY_SERVICE_ACCOUNT_AND_SECRETS="1"
        DEPLOY_RUNTIME_COMPONENTS="1"
        readonly DEPLOY_SERVICE_ACCOUNT_AND_SECRETS
        readonly DEPLOY_RUNTIME_COMPONENTS
    fi

}



################################################################################
# Tries to configure the default values of unset variables.
################################################################################
configure_vars() {
    banner_info "Configuring default values..."

    INSTANCE_DIR="${ROOT_DIR}/overlays/instances/${CLUSTER_NAME}-${CLUSTER_REGION}"
    readonly INSTANCE_DIR

}

################################################################################
# Parse command line arguments.
################################################################################
parse_args() {
    while [[ $# != 0 ]]; do
        case "${1}" in
        apply)
            CMD_APPLY="1"
            readonly CMD_APPLY
            shift 1
            ;;
        delete)
            CMD_DELETE="1"
            readonly CMD_DELETE
            shift 1
            ;;
        get)
            CMD_GET="1"
            readonly CMD_GET
            shift 1
            ;;
        --org)
            arg_required "${@}"
            ORGANIZATION_NAME="${2}"
            readonly ORGANIZATION_NAME
            shift 2
            ;;
        --namespace)
            arg_required "${@}"
            APIGEE_NAMESPACE="${2}"
            readonly APIGEE_NAMESPACE
            shift 2
            ;;
        --cluster-name)
            arg_required "${@}"
            CLUSTER_NAME="${2}"
            readonly CLUSTER_NAME
            shift 2
            ;;
        --cluster-region)
            arg_required "${@}"
            CLUSTER_REGION="${2}"
            readonly CLUSTER_REGION
            shift 2
            ;;
        --gcp-sa-and-secrets)
            DEPLOY_SERVICE_ACCOUNT_AND_SECRETS="1"
            readonly DEPLOY_SERVICE_ACCOUNT_AND_SECRETS
            shift 1
            ;;
        --runtime-components)
            DEPLOY_RUNTIME_COMPONENTS="1"
            readonly DEPLOY_RUNTIME_COMPONENTS
            shift 1
            ;;
        --all)
            INVOKE_ALL="1"
            readonly INVOKE_ALL
            shift 1
            ;;
        --diagnostic)
            DIAGNOSTIC="1"
            readonly DIAGNOSTIC
            shift 1
            ;;
        --verbose)
            VERBOSE="1"
            readonly VERBOSE
            shift 1
            ;;
        --help)
            usage
            exit
            ;;
        --version)
            echo "Apigee Hybrid Setup Version: ${APIGEE_HYBRID_VERSION}"
            exit
            ;;
        *)
            fatal "Unknown option '${1}'"
            ;;
        esac
    done

}

################################################################################
# Print help text.
################################################################################
usage() {
    local COMMANDS_0 ATTRIB_1 TYPES_2 FLAGS_3

    # Available commands
    COMMANDS_0="$(
        cat <<EOF
    apply             one of REQUIRED               Specifies that a deployment operation 
                                                    will be performed
    delete            one of REQUIRED               Deletes Apigee Hybrid from the Cluster 
                                                    Note 1: Only "--all" is supported
                                                    Note 2: Known Issue, Apigee:Iss12
                                                    namespace sometimes does not delete
    get               one of REQUIRED               Dumps a full list of everything in
                                                    the namespace
EOF
    )"

    # The attributes that define the org
    ATTRIB_1="$(
        cat <<EOF
    --org             <ORGANIZATION_NAME>           Set the Apigee Organization.
    --namespace       <APIGEE_NAMESPACE>            The name of the namespace where
                                                    apigee components will be installed.
                                                    Defaults to "apigee".
    --cluster-name    <CLUSTER_NAME>                The Kubernetes cluster name.
    --cluster-region  <CLUSTER_REGION>              The region in which the
                                                    Kubernetes cluster resides.
EOF
    )"

    # Types of resources that can be deployed
    TYPES_2="$(
        cat <<EOF
    --gcp-sa-and-secrets   (apply)              Deploy GCP service account(s) into 
                                                corresponding secret(s) containing 
                                                the keys in the kubernetes cluster.
    --runtime-components   (apply)              Deploy all Apigee components and 
                                                resources in the correct order.
    --all                  (apply|delete|get)   Used to execute all the tasks that 
                                                can be performed for the Command selected.
EOF
    )"

    # OPTIONAL flags
    FLAGS_3="$(
        cat <<EOF
    --verbose                    Show detailed output for debugging.
    --version                    Display version of Apigee Hybrid that will be deployed.
                                 NOTE: install script does not support setting 
                                 or changing the install version.
    --help                       Display usage information.
EOF
    )"




    cat <<EOF

${SCRIPT_NAME}

USAGE: 
${SCRIPT_NAME} [command] [attributes] [types] [flags]

Provides a prescriptive approach to installing Apigee. Use this script
in combination with apigee-hybrid-setup.sh. The setup script is used
to pre-configure the runtimes for the Organization. This deployment script
will deploy a configured runtime into kubernetes.

Available commands:

$COMMANDS_0

REQUIRED attributes (varies by Command):

$ATTRIB_1

Specifies the resource types to be acted upon (at least one is REQUIRED):

$TYPES_2

Optional flags:

$FLAGS_3

EXAMPLES:

Apply everything:
    
./apigee-hybrid-deploy.sh apply \\
    --org business-org \\
    --env development \\
    --envgroup external-consumers \\
    --namespace apigee \\
    --cluster-name apigee-hybrid-west \\
    --cluster-region us-west1 \\
    --all
    
Only Apply service accounts and enable verbose logging:

./apigee-hybrid-deploy.sh apply \\
    --org business-org \\
    --env development \\
    --envgroup external-consumers \\
    --namespace apigee \\
    --cluster-name apigee-hybrid-west \\
    --cluster-region us-west1 \\
    --gcp-sa-and-secrets \\
    --verbose


EOF
}

################################################################################
# run takes a list of arguments that represents a command.
# If VERBOSE is enabled, it will print and run the command.
################################################################################
run() {
    if [[ "${VERBOSE}" -eq 0 ]]; then
        "${@}" 2>/dev/null
        return "$?"
    fi

    info "Running: '${*}'"
    local RETVAL
    {
        "${@}"
        RETVAL="$?"
    } || true
    return $RETVAL
}

################################################################################
# Wrapper functions
#
# These functions wrap other utilities with the `run` function for supporting
# --verbose
################################################################################
kubectl() {
    run "${AKUBECTL}" "${@}"
}

# Checks if the current cluster uses openshift
is_open_shift() {
    if [[ "$(kubectl api-resources --api-group security.openshift.io -o name || true)" == *"securitycontextconstraints.security.openshift.io"* ]]; then
        return 0
    else
        return 1
    fi
}

warn() {
    info "[WARNING]: ${1}" >&2
}

fatal() {
    error "${1}"
    exit 2
}

error() {
    info "[ERROR]: ${1}" >&2
}

banner_info() {
    echo ""
    info "********************************************"
    info "${1}"
    info "********************************************"
}

info() {
    if [[ "${VERBOSE}" -eq 1 && "${HAS_TS}" -eq 1 ]]; then
        echo "${SCRIPT_NAME}: ${1}" | TZ=utc ts '%Y-%m-%dT%.T' >&2
    else
        echo "${SCRIPT_NAME}: ${1}" >&2
    fi
}

exit_handler() {
    if (($? != 0)); then
        banner_info "FAILED."
        info "Please try again and possibly use '--verbose' flag to debug if error persists."
        exit 1
    fi
}

trap exit_handler EXIT

main "${@}"
