#!/usr/bin/env bash

set -eo pipefail

################################################################################
#                           User modifiable variables
################################################################################

APIGEE_NAMESPACE="apigee"                           # The kubernetes namespace name where Apigee components will be created
APIGEE_API_ENDPOINT="https://apigee.googleapis.com" # API endpoint to be used to Apigee API calls
GCP_SERVICE_ACCOUNT_NAME="apigee-all-sa"            # Name of the service account that will be created

ORGANIZATION_NAME="${ORGANIZATION_NAME:-""}"                   # --org
ENVIRONMENT_NAME="${ENVIRONMENT_NAME:-""}"                     # --env
ENVIRONMENT_GROUP_NAME="${ENVIRONMENT_GROUP_NAME:-""}"         # --envgroup
ENVIRONMENT_GROUP_HOSTNAME="${ENVIRONMENT_GROUP_HOSTNAME:-""}" # --ingress-domain
CLUSTER_NAME="${CLUSTER_NAME:-""}"                             # --cluster-name
CLUSTER_REGION="${CLUSTER_REGION:-""}"                         # --cluster-region
GCP_PROJECT_ID="${GCP_PROJECT_ID:-""}"                         # --gcp-project-id
# X~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~X END X~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~X

# The following variables control individual actions performed by the script.
SHOULD_CREATE_SERVICE_ACCOUNT_AND_SECRETS="0" # --create-gcp-sa-and-secrets
SHOULD_RENAME_DIRECTORIES="0"                 # --rename-directories
SHOULD_CREATE_INGRESS_TLS_CERTS="0"           # --create-ingress-tls-certs
SHOULD_FILL_VALUES="0"                        # --fill-values
SHOULD_APPLY_CONFIGURATION="0"                # --apply-configuration

VERBOSE="0" # --verbose

HAS_TS="0"
AGCLOUD=""
AKUBECTL=""

SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
ROOT_DIR="${SCRIPT_DIR}/.."
INSTANCE_DIR=""

# shellcheck disable=SC1090
source "${SCRIPT_DIR}/common.sh" || exit 1

REL_PATH_CREATE_SERVICE_ACCOUNT="${SCRIPT_DIR}/create-service-account.sh"
SERVICE_ACCOUNT_OUTPUT_DIR="${ROOT_DIR}/service-accounts"

DEFAULT_ENV_DIR_NAME="test"               # Default name of the environment directory.
DEFAULT_ENVGROUP_DIR_NAME="test-envgroup" # Default name of the environment group directory.
DEFAULT_INSTANCE_DIR_NAME="instance1"

################################################################################
# `main` is the ENTRYPOINT for the shell script.
################################################################################
main() {
    init
    parse_args "${@}"

    check_prerequisites

    configure_defaults

    validate_vars

    if [[ "${SHOULD_CREATE_SERVICE_ACCOUNT_AND_SECRETS}" == "1" ]]; then
        create_service_accounts
    fi

    if [[ "${SHOULD_RENAME_DIRECTORIES}" == "1" ]]; then
        rename_directories
    fi

    if [[ "${SHOULD_CREATE_INGRESS_TLS_CERTS}" == "1" ]]; then
        create_ingress_tls_certs
    fi

    if [[ "${SHOULD_FILL_VALUES}" == "1" ]]; then
        fill_values_in_yamls
    fi

    if [[ "${SHOULD_APPLY_CONFIGURATION}" == "1" ]]; then
        create_kubernetes_resources
    fi

    banner_info "SUCCESS"
}

################################################################################
# Tries to configure the default values of unset variables.
################################################################################
configure_defaults() {
    banner_info "Configuring default values..."

    # Configure the Apigee API endpoint to be used for making API calls.
    local APIGEE_API_ENDPOINT_OVERRIDES
    APIGEE_API_ENDPOINT_OVERRIDES="$(gcloud config get-value api_endpoint_overrides/apigee)"
    if [[ "${APIGEE_API_ENDPOINT_OVERRIDES}" != "(unset)" && "${APIGEE_API_ENDPOINT_OVERRIDES}" != "" ]]; then
        APIGEE_API_ENDPOINT="${APIGEE_API_ENDPOINT_OVERRIDES::-1}"
    fi
    readonly APIGEE_API_ENDPOINT
    info "APIGEE_API_ENDPOINT='${APIGEE_API_ENDPOINT}'"

    # Configure organization name
    if [[ -z "${ORGANIZATION_NAME}" ]]; then
        ORGANIZATION_NAME="$(gcloud config get-value project)"
    fi
    readonly ORGANIZATION_NAME
    info "ORGANIZATION_NAME='${ORGANIZATION_NAME}'"

    # Configure environment name
    if [[ -z "${ENVIRONMENT_NAME}" ]]; then
        local ENVIRONMENTS_LIST NUMBER_OF_ENVIRONMENTS

        ENVIRONMENTS_LIST="$(gcloud beta apigee environments list --organization="${ORGANIZATION_NAME}" --format='value(.)')"
        NUMBER_OF_ENVIRONMENTS=$(echo "${ENVIRONMENTS_LIST}" | wc -l)
        if ((NUMBER_OF_ENVIRONMENTS < 1)); then
            fatal "No environment exists in organization '${ORGANIZATION_NAME}'. Please create an environment and try again."
        elif ((NUMBER_OF_ENVIRONMENTS > 1)); then
            printf "Environments found:\n%s\n" "${ENVIRONMENTS_LIST}"
            fatal "Multiple environments found. Select one explicitly using --env and try again."
        fi

        ENVIRONMENT_NAME="$(echo "${ENVIRONMENTS_LIST}" | head --lines 1)"
    fi
    readonly ENVIRONMENT_NAME
    info "ENVIRONMENT_NAME='${ENVIRONMENT_NAME}'"

    # Configure environment group name and hostname.
    #
    # Will only be executed when both envgroup and hostname are not set. Thus
    # the user is expected to either input both, or none of them.
    if [[ -z "${ENVIRONMENT_GROUP_NAME}" && -z "${ENVIRONMENT_GROUP_HOSTNAME}" ]]; then
        local RESPONSE
        RESPONSE="$(
            run curl --fail --show-error --silent "${APIGEE_API_ENDPOINT}/v1/organizations/${ORGANIZATION_NAME}/envgroups/" \
                -K <(auth_header)
        )"

        local ENVIRONMENT_GROUPS_LIST NUMBER_OF_ENVIRONMENT_GROUPS
        NUMBER_OF_ENVIRONMENT_GROUPS=0
        if [[ "${RESPONSE}" != "{}" ]]; then
            ENVIRONMENT_GROUPS_LIST="$(echo "${RESPONSE}" | jq -r '.environmentGroups[].name')"
            NUMBER_OF_ENVIRONMENT_GROUPS=$(echo "${ENVIRONMENT_GROUPS_LIST}" | wc -l)
        fi
        if ((NUMBER_OF_ENVIRONMENT_GROUPS < 1)); then
            fatal "No environment group exists in organization '${ORGANIZATION_NAME}'. Please create an environment group and try again."
        elif ((NUMBER_OF_ENVIRONMENT_GROUPS > 1)); then
            printf "Environments groups found:\n%s\n" "${ENVIRONMENT_GROUPS_LIST}"
            fatal "Multiple environment groups found. Select one explicitly using --envgroup and try again."
        fi

        ENVIRONMENT_GROUP_NAME="$(echo "${RESPONSE}" | jq -r '.environmentGroups[0].name')"
        ENVIRONMENT_GROUP_HOSTNAME="$(echo "${RESPONSE}" | jq -r '.environmentGroups[0].hostnames[0]')"
    fi
    readonly ENVIRONMENT_GROUP_NAME ENVIRONMENT_GROUP_HOSTNAME
    info "ENVIRONMENT_GROUP_NAME='${ENVIRONMENT_GROUP_NAME}'"
    info "ENVIRONMENT_GROUP_HOSTNAME='${ENVIRONMENT_GROUP_HOSTNAME}'"

    # Configure GCP Project ID name
    if [[ -z "${GCP_PROJECT_ID}" ]]; then
        GCP_PROJECT_ID="${ORGANIZATION_NAME}"
    fi
    readonly GCP_PROJECT_ID
    info "GCP_PROJECT_ID='${GCP_PROJECT_ID}'"

    INSTANCE_DIR="${ROOT_DIR}/overlays/instances/${CLUSTER_NAME}-${CLUSTER_REGION}"
    readonly INSTANCE_DIR
}

################################################################################
# Checks whether the required variables have been populated depending on the
# flags.
################################################################################
validate_vars() {
    local VALIDATION_FAILED="0"

    if [[ "${SHOULD_FILL_VALUES}" == "1" ]]; then
        if [[ -z "${CLUSTER_NAME}" ]]; then
            VALIDATION_FAILED="1"
            warn "CLUSTER_NAME should be specified"
        fi
        if [[ -z "${CLUSTER_REGION}" ]]; then
            VALIDATION_FAILED="1"
            warn "CLUSTER_REGION should be specified"
        fi
    fi

    if [[ "${VALIDATION_FAILED}" == "1" ]]; then
        fatal "One or more validations failed. Exiting."
    fi

    info "CLUSTER_NAME='${CLUSTER_NAME}'"
    info "CLUSTER_REGION='${CLUSTER_REGION}'"
}

################################################################################
# Create GCP service accounts and corresponding kubernetes secrets.
#
# Utilizes the tools/create-service-account shell script for creating GCP SAs.
################################################################################
create_service_accounts() {
    # Unset the PROJECT_ID variable because the `create-service-account` script
    # errors out if both the flag `--project-id` and environment variable are
    # set.
    unset PROJECT_ID

    banner_info "Creating GCP service account..."
    run "${REL_PATH_CREATE_SERVICE_ACCOUNT}" \
        --project-id "${ORGANIZATION_NAME}" \
        --env "non-prod" \
        --name "${GCP_SERVICE_ACCOUNT_NAME}" \
        --dir "${SERVICE_ACCOUNT_OUTPUT_DIR}" <<<"y"

    # Remove the json extension from downloaded service account key to prevent
    # kpt from trying to configure it and erroring out.
    mv "${SERVICE_ACCOUNT_OUTPUT_DIR}/${ORGANIZATION_NAME}-${GCP_SERVICE_ACCOUNT_NAME}.json" \
        "${SERVICE_ACCOUNT_OUTPUT_DIR}/${ORGANIZATION_NAME}-${GCP_SERVICE_ACCOUNT_NAME}.key"

    info "Calling setSyncAuthoriation API..."
    local JSON_DATA
    JSON_DATA="$(
        curl --fail --show-error --silent "${APIGEE_API_ENDPOINT}/v1/organizations/${ORGANIZATION_NAME}:getSyncAuthorization" \
            -K <(auth_header) |
            jq '.identities += ["serviceAccount:'"${GCP_SERVICE_ACCOUNT_NAME}"'@'"${ORGANIZATION_NAME}"'.iam.gserviceaccount.com"] | .identities'
    )"
    run curl --fail --show-error --silent "${APIGEE_API_ENDPOINT}/v1/organizations/${ORGANIZATION_NAME}:setSyncAuthorization" \
        -X POST -H "Content-Type:application/json" \
        -d '{"identities":'"${JSON_DATA}"'}' \
        -K <(auth_header)

    banner_info "Creating kubernetes secrets containing the service account keys..."
    kubectl apply -f "${ROOT_DIR}/overlays/initialization/namespace.yaml"

    while read -r k8s_sa_name; do
        kubectl create secret generic "${k8s_sa_name}" \
            --from-file="client_secret.json=${SERVICE_ACCOUNT_OUTPUT_DIR}/${ORGANIZATION_NAME}-${GCP_SERVICE_ACCOUNT_NAME}.key" \
            -n "${APIGEE_NAMESPACE}" \
            --dry-run=client -o yaml | kubectl apply -f -
    done <<EOF
apigee-synchronizer-svc-account-${ORGANIZATION_NAME}-${ENVIRONMENT_NAME}
apigee-udca-svc-account-${ORGANIZATION_NAME}-${ENVIRONMENT_NAME}
apigee-runtime-svc-account-${ORGANIZATION_NAME}-${ENVIRONMENT_NAME}
apigee-watcher-svc-account-${ORGANIZATION_NAME}
apigee-connect-agent-svc-account-${ORGANIZATION_NAME}
apigee-mart-svc-account-${ORGANIZATION_NAME}
apigee-udca-svc-account-${ORGANIZATION_NAME}
apigee-metrics-svc-account
apigee-logger-svc-account
EOF
}

################################################################################
# Rename directories according to their actual names.
################################################################################
rename_directories() {
    banner_info "Renaming directories..."

    if [[ ! -d "${INSTANCE_DIR}" ]]; then
        info "Renaming default instance '${DEFAULT_INSTANCE_DIR_NAME}' to '${CLUSTER_NAME}-${CLUSTER_REGION}'..."
        run mv "${ROOT_DIR}/overlays/instances/${DEFAULT_INSTANCE_DIR_NAME}" "${INSTANCE_DIR}"
    fi

    if [[ ! -d "${INSTANCE_DIR}/environments/${ENVIRONMENT_NAME}" ]]; then
        info "Renaming default environment '${DEFAULT_ENV_DIR_NAME}' to '${ENVIRONMENT_NAME}'..."
        run mv "${INSTANCE_DIR}/environments/${DEFAULT_ENV_DIR_NAME}" \
            "${INSTANCE_DIR}/environments/${ENVIRONMENT_NAME}"
    fi

    if [[ ! -d "${INSTANCE_DIR}/route-config/${ENVIRONMENT_GROUP_NAME}" ]]; then
        info "Renaming default envgroup '${DEFAULT_ENVGROUP_DIR_NAME}' to '${ENVIRONMENT_GROUP_NAME}'..."
        run mv "${INSTANCE_DIR}/route-config/${DEFAULT_ENVGROUP_DIR_NAME}" \
            "${INSTANCE_DIR}/route-config/${ENVIRONMENT_GROUP_NAME}"
    fi
}

################################################################################
# Create kubernetes Certificate which will generate a self signed cert/key pair
# to be used to ingress TLS communication
################################################################################
create_ingress_tls_certs() {
    banner_info "Creating ingress Certificate..."

    export ORGANIZATION_NAME ENVIRONMENT_GROUP_NAME ENVIRONMENT_GROUP_HOSTNAME
    kubectl apply -f <(envsubst <"${ROOT_DIR}/templates/ingress-certificate.yaml")
}

################################################################################
# Replace appropriate values like org, env, envgroup name in the yamls.
################################################################################
fill_values_in_yamls() {
    banner_info "Filling values in YAMLs..."

    run kpt fn eval "${ROOT_DIR}/overlays/" \
        --image gcr.io/kpt-fn/apply-setters:v0.2.0 -- \
        APIGEE_NAMESPACE="${APIGEE_NAMESPACE}" \
        CLUSTER_NAME="${CLUSTER_NAME}" \
        CLUSTER_REGION="${CLUSTER_REGION}" \
        ENVIRONMENT_NAME="${ENVIRONMENT_NAME}" \
        ENVIRONMENT_GROUP_NAME="${ENVIRONMENT_GROUP_NAME}" \
        GCP_PROJECT_ID="${GCP_PROJECT_ID}" \
        ORGANIZATION_NAME_UPPER="$(echo "${ORGANIZATION_NAME}" | tr 'a-z' 'A-Z')" \
        ORGANIZATION_NAME="${ORGANIZATION_NAME}"

    # Replace correct namespace in istio discoveryAddress which cannot be done
    # with kpt.
    sed -i -E -e "s/(discoveryAddress: apigee-istiod\.).*(\.svc:15012)/\1${APIGEE_NAMESPACE}\2/" "${ROOT_DIR}/overlays/controllers/apigee-embedded-ingress-controller/apigee-istio-mesh-config.yaml"
}

################################################################################
# Applies all the yamls in the correct order to the cluster.
################################################################################
create_kubernetes_resources() {
    banner_info "Creating kubernetes resources..."

    check_if_cert_manager_exists

    if is_open_shift; then
        info "Creating SecurityContextConstraints for OpenShift..."
        kubectl apply -k "${ROOT_DIR}/overlays/initialization/openshift"
        kubectl apply -f "${INSTANCE_DIR}/datastore/components/openshift-scc/scc.yaml"
        kubectl apply -f "${INSTANCE_DIR}/telemetry/components/openshift-scc/scc.yaml"
    fi

    info "Creating apigee initialization kubernetes resources..."
    kubectl apply -f "${ROOT_DIR}/overlays/initialization/namespace.yaml"
    kubectl apply -k "${ROOT_DIR}/overlays/initialization/certificates"
    kubectl apply --server-side --force-conflicts -k "${ROOT_DIR}/overlays/initialization/crds"
    kubectl apply -k "${ROOT_DIR}/overlays/initialization/webhooks"
    kubectl apply -k "${ROOT_DIR}/overlays/initialization/rbac"
    kubectl apply -k "${ROOT_DIR}/overlays/initialization/ingress"

    info "Creating controllers..."
    kubectl apply -k "${ROOT_DIR}/overlays/controllers"

    info "Waiting for controllers to be available..."
    kubectl wait deployment/apigee-controller-manager deployment/apigee-istiod -n "${APIGEE_NAMESPACE}" --for=condition=available --timeout=2m

    info "Creating apigee kubernetes resources..."
    # Create the datastore and redis secrets first and the rest of the secrets.
    kubectl apply -f "${INSTANCE_DIR}/datastore/secrets.yaml"
    kubectl apply -f "${INSTANCE_DIR}/redis/secrets.yaml"
    kubectl apply -f "${INSTANCE_DIR}/environments/${ENVIRONMENT_NAME}/secrets.yaml"
    kubectl apply -f "${INSTANCE_DIR}/organization/secrets.yaml"
    # Create the remainder of the resources.
    kubectl apply -k "${INSTANCE_DIR}"

    # Resources having been successfully created. Now wait for them to start.
    banner_info "Resources have been created. Waiting for them to be ready..."
    kubectl wait "apigeedatastore/default" \
        "apigeeredis/default" \
        "apigeeenvironment/${ORGANIZATION_NAME}-${ENVIRONMENT_NAME}" \
        "apigeeorganization/${ORGANIZATION_NAME}" \
        "apigeetelemetry/apigee-telemetry" \
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

    AGCLOUD="$(which gcloud)"
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
curl
jq
kpt
envsubst
sed
$AGCLOUD
$AKUBECTL
EOF

    if [[ "${NOTFOUND}" == "1" ]]; then
        fatal "One or more prerequisites are not installed."
    fi
}

################################################################################
# Checks for the existence of a second argument and exit if it does not exist.
################################################################################
arg_required() {
    if [[ ! "${2:-}" || "${2:0:1}" = '-' ]]; then
        fatal "Option ${1} requires an argument."
    fi
}

################################################################################
# Parse command line arguments.
################################################################################
parse_args() {
    while [[ $# != 0 ]]; do
        case "${1}" in
        --org)
            arg_required "${@}"
            ORGANIZATION_NAME="${2}"
            shift 2
            ;;
        --env)
            arg_required "${@}"
            ENVIRONMENT_NAME="${2}"
            shift 2
            ;;
        --envgroup)
            arg_required "${@}"
            ENVIRONMENT_GROUP_NAME="${2}"
            shift 2
            ;;
        --ingress-domain)
            arg_required "${@}"
            ENVIRONMENT_GROUP_HOSTNAME="${2}"
            shift 2
            ;;
        --namespace)
            arg_required "${@}"
            APIGEE_NAMESPACE="${2}"
            shift 2
            ;;
        --cluster-name)
            arg_required "${@}"
            CLUSTER_NAME="${2}"
            shift 2
            ;;
        --cluster-region)
            arg_required "${@}"
            CLUSTER_REGION="${2}"
            shift 2
            ;;
        --gcp-project-id)
            arg_required "${@}"
            GCP_PROJECT_ID="${2}"
            shift 2
            ;;
        --create-gcp-sa-and-secrets)
            SHOULD_CREATE_SERVICE_ACCOUNT_AND_SECRETS="1"
            shift 1
            ;;
        --rename-directories)
            SHOULD_RENAME_DIRECTORIES="1"
            shift 1
            ;;
        --create-ingress-tls-certs)
            SHOULD_CREATE_INGRESS_TLS_CERTS="1"
            shift 1
            ;;
        --fill-values)
            SHOULD_FILL_VALUES="1"
            shift 1
            ;;
        --apply-configuration)
            SHOULD_APPLY_CONFIGURATION="1"
            shift 1
            ;;
        --setup-all)
            SHOULD_CREATE_SERVICE_ACCOUNT_AND_SECRETS="1"
            SHOULD_RENAME_DIRECTORIES="1"
            SHOULD_CREATE_INGRESS_TLS_CERTS="1"
            SHOULD_FILL_VALUES="1"
            SHOULD_APPLY_CONFIGURATION="1"
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

    if [[ "${SHOULD_CREATE_SERVICE_ACCOUNT_AND_SECRETS}" != "1" &&
        "${SHOULD_RENAME_DIRECTORIES}" != "1" &&
        "${SHOULD_CREATE_INGRESS_TLS_CERTS}" != "1" &&
        "${SHOULD_FILL_VALUES}" != "1" &&
        "${SHOULD_APPLY_CONFIGURATION}" != "1" ]]; then
        usage
        exit
    fi

}

################################################################################
# Print help text.
################################################################################
usage() {
    local FLAGS_1 FLAGS_2

    # Flags that require an argument
    FLAGS_1="$(
        cat <<EOF
    --org             <ORGANIZATION_NAME>           Set the Apigee Organization.
                                                    If not set, the project configured
                                                    in gcloud will be used.
    --env             <ENVIRONMENT_NAME>            Set the Apigee Environment.
                                                    If not set, a random environment
                                                    within the organization will be
                                                    selected.
    --envgroup        <ENVIRONMENT_GROUP_NAME>      Set the Apigee Environment Group.
                                                    If not set, a random environment
                                                    group within the organization
                                                    will be selected.
    --ingress-domain  <ENVIRONMENT_GROUP_HOSTNAME>  Set the hostname. This will be
                                                    used to generate self signed
                                                    certificates.
    --namespace       <APIGEE_NAMESPACE>            The name of the namespace where
                                                    apigee components will be installed.
                                                    Defaults to "apigee".
    --cluster-name    <CLUSTER_NAME>                The Kubernetes cluster name.
    --cluster-region  <CLUSTER_REGION>              The region in which the
                                                    Kubernetes cluster resides.
    --gcp-project-id  <GCP_PROJECT_ID>              The GCP Project ID where the
                                                    Kubernetes cluster exists.
                                                    This can be different from
                                                    the Apigee Organization name.
EOF
    )"

    # Flags that DON'T require an argument
    FLAGS_2="$(
        cat <<EOF
    --create-gcp-sa-and-secrets  Create GCP service account and corresponding 
                                 secret containing the keys in the kubernetes cluster.
    --rename-directories         Rename the instnce, environment and environment group
                                 to their correct names.
    --create-ingress-tls-certs   Create Certificate resource which will generate
                                 a self signed TLS cert for the ENVIRONMENT_GROUP_HOSTNAME
    --fill-values                Replace the values for organization, environment, etc.
                                 in the kubernetes yaml files.
    --apply-configuration        Create the kubernetes resources in their correct order.
    --setup-all                  Used to execute all the tasks that can be performed
                                 by the script.
    --verbose                    Show detailed output for debugging.
    --version                    Display version of apigee hybrid setup.
    --help                       Display usage information.
EOF
    )"

    cat <<EOF
${SCRIPT_NAME}
USAGE: ${SCRIPT_NAME} --cluster-name <CLUSTER_NAME> --cluster-region <CLUSTER_REGION> [FLAGS]...

Helps with the installation of Apigee Hybrid. Can be used to either automate the
complete installation, or execute individual tasks

FLAGS that expect an argument:

$FLAGS_1

FLAGS without argument:

$FLAGS_2

EXAMPLES:

    Setup everything:
        
        $ ./apigee-hybrid-setup.sh --cluster-name apigee-hybrid-cluster --cluster-region us-west1 --setup-all
        
    Only apply configuration and enable verbose logging:

        $ ./apigee-hybrid-setup.sh --cluster-name apigee-hybrid-cluster --cluster-region us-west1 --verbose --apply-configuration

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
gcloud() {
    run "${AGCLOUD}" "${@}"
}

kubectl() {
    run "${AKUBECTL}" "${@}"
}

################################################################################
# Returns the authorization header to be used with curl commands.
# This when used in conjunction with the -K flag keeps the token from printing
# if this script is run with --verbose
################################################################################
auth_header() {
    local TOKEN
    TOKEN="$(gcloud --project="${ORGANIZATION_NAME}" auth print-access-token)"
    echo "--header \"Authorization: Bearer ${TOKEN}\""
}

# Checks if the current cluster is uses openshift
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
