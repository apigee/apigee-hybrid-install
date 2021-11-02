#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1117
# The intent of this script is to enable:
# 1. Creation of service accounts
# 2. Download keys for service accounts
# 3. Bind policies required for Apigee components to the service accounts.

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

# shellcheck disable=SC1090
source "${PWD}/common.sh" || exit 1

# List of supported profiles. Unfortunately since maps are not natively supported in all versions of bash,
# we have to resort to using an array of supported profiles and a set of variables with their profiles.
#
# NOTE: When adding new profiles ensure that SUPPORTED_PROFILES and the appropriate _ROLES are added.
# the format is <profile>_ROLES, where profile is uppercase and replace '-' with '_'.
SUPPORTED_PROFILES=("apigee-logger" "apigee-metrics" "apigee-cassandra" "apigee-udca" "apigee-synchronizer" "apigee-mart" "apigee-watcher" "apigee-runtime")
# Roles for each of the supported profiles.
APIGEE_LOGGER_ROLES="roles/logging.logWriter"
APIGEE_METRICS_ROLES="roles/monitoring.metricWriter"
APIGEE_CASSANDRA_ROLES="roles/storage.objectAdmin"
APIGEE_UDCA_ROLES="roles/apigee.analyticsAgent"
APIGEE_SYNCHRONIZER_ROLES="roles/apigee.synchronizerManager"
APIGEE_MART_ROLES="roles/apigeeconnect.Agent"
APIGEE_WATCHER_ROLES="roles/apigee.runtimeAgent"
APIGEE_RUNTIME_ROLES=" "

# List of supported environments
SUPPORTED_ENVS=("prod" "non-prod")

#**
# @brief    Displays usage details.
#
usage() {
    printf "%b" "\nUsage: $(basename "$0")\n" \
        "Flags:          -e / --env          \t Environment. prod/non-prod. \n" \
        "                -p / --profile      \t Profile name. Should be accompanied by --env prod.\n" \
        "                -d / --dir          \t Target directory for service account.\n" \
        "                -i / --project-id   \t GCP project ID. Defaults to the project ID configured in gcloud.\n" \
        "                -n / --name         \t Name of the service account.\n" \
        "                -h / --help         \t Help menu.\n" \
        "List of Supported profiles: \n\t\t ${SUPPORTED_PROFILES[*]} \n"
}

#**
# @brief    Displays usage details and error message. Exits with non-zero status.
#
exit_with_usage() {
  usage
  log_error "$*"
}

#**
# @brief    Obtains GCP project ID from gcloud configuration and updates global variable PROJECT_ID.
#
get_project(){
    local project_id ret
    local msg="Provide GCP Project ID via --project-id flag or update gcloud config using 'gcloud config set project <project_id>'"

    project_id=$(gcloud config list core/project --format='value(core.project)'); ret=$?
    [[ ${ret} -ne 0 || -z "${project_id}" ]] && \
        exit_with_usage "Failed to get project ID from gcloud config.\n${msg}"

    log_info "gcloud configured project ID is ${project_id}.\n" \
        "Enter: y to proceed with creating service account in project: ${project_id}\n" \
        "Enter: n to abort."
    read -r prompt
    if [[ "${prompt}" != "y" ]]; then
        exit_with_usage "Aborting.\n${msg}"
    fi
    PROJECT_ID="${project_id}"
}

#**
# @brief    Checks if a service account already exists. If it does not exist creates it.
#           If it fails to create service account, it exists the script.
# @return 0 Successfully creates service account.
# @return 1 Service account already exists.
#
check_and_create_service_account(){
    local sa_name=$1
    local sa_email=$2
    local project_id=$3
    local ret

    log_info "Checking if service account already exists"
    gcloud iam service-accounts describe "${sa_email}" --project="${project_id}" -q > /dev/null 2>&1 ; ret=$?
    if [[ ${ret} -eq 0 ]]; then
        log_info "Service account ${sa_email} already exists."
        return 1
    fi

    log_info "Service account does not exist. Creating..."
    gcloud iam service-accounts --format='value(email)' create "${sa_name}" --project="${project_id}"  \
        --display-name="${sa_name}" || log_error "Failed to create service account ${sa_email}"

    log_info "Successfully created service account ${sa_email}"
    return 0
}

#**
# @brief    Invokes gcloud command to download json keys.
#
download_keys(){
    local sa_name=$1
    local sa_email=$2
    local output_dir=$3
    local project_id=$4
    gcloud iam service-accounts keys create "${output_dir}/${project_id}-${sa_name}.json" \
        --iam-account="${sa_email}" || \
            log_error "Failed to download keys for service account ${sa_name}"
    log_info "JSON Key ${sa_name} was successfully download to directory $PWD."
}

#**
# @brief    Returns GCP IAM roles that are associated to a profile.
#
get_roles(){
    local profile=$1
    local role_name

    # Convert profile to upper case and '-' to '_'.
    role_name="$(echo "${profile}_ROLES" | tr '[:lower:]' '[:upper:]')"
    role_name="${role_name//-/_}"

    # Return value stored in global variable <profile>_ROLES.
    echo "${!role_name}"
}

#**
# @brief    Binds profile specific policy roles to service account.
#
bind_policy(){
    local sa_email=$1
    local roles=$2

    # shellcheck disable=SC2068
    for role in ${roles[@]}; do
        # add the IAM policy binding for the defined project and service account
        gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
            --member serviceAccount:"${sa_email}" \
            --role "${role}" > /dev/null || \
                log_error "Failed to attach role ${role} to service account ${sa_email}"
    done

    # Display updated policy for the service account.
    gcloud projects get-iam-policy "${PROJECT_ID}"  \
        --flatten="bindings[].members" \
        --format='table(bindings.role)' \
        --filter="bindings.members:${sa_email}"
    log_info "Successfully updated roles for ${sa_email}"
}

#**
# @brief    Creates an SA and binds roles passed in as params.
#
create_sa_and_bind_roles() {
    local sa_name=$1
    local output_dir=$2
    local project_id=$3
    local roles=$4
    local sa_email ret

    sa_email="${sa_name}@${project_id}.iam.gserviceaccount.com"
    if [[ "${project_id}" == "google.com:"* ]]; then
        sa_email="${sa_name}@${project_id#"google.com:"}.google.com.iam.gserviceaccount.com"
    fi

    log_info "Creating service account ${sa_email} with roles ${roles[*]} in directory ${output_dir}"
    download_key_file="y"
    # check_and_create_service_account returns non-zero if the SA already exists.
    # if SA exists, prompt customer asking if new keys should be generated.
    check_and_create_service_account "${sa_name}" "${sa_email}" "${project_id}" ; ret=$?
    if [[ ${ret} -ne 0 ]]; then
        log_info "The service account might have keys associated with it. It is recommended to use existing keys.\n" \
            "Enter: y to generate new keys.(this does not de-activate existing keys)\n" \
            "Enter: n to skip generating new keys."
        read -r download_key_file
    fi

    if [[ "${download_key_file}" == "y" ]]; then
      log_info "Downloading service accounts in directory ${output_dir}"
      download_keys "${sa_name}" "${sa_email}" "${output_dir}" "${project_id}"  || exit 1
    fi

    bind_policy "${sa_email}" "${roles[@]}"

}

### Start of mainline code ###

PARAMS=""
while (( "$#" )); do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -e|--env)
            # Checks $2 is not empty and is not another flag by checking for "-".
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                [[ -n "${ENV}" ]] && log_error "More than one $1 is entered"
                ENV=$2
                shift 2
                continue
            fi
            log_error "Argument for $1 is missing" >&2
            ;;
        -d|--dir)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                [[ -n "${OUTPUT_DIR}" ]] && log_error "More than one $1 is entered"
                OUTPUT_DIR=$2
                shift 2
                continue
            fi
            log_error "Argument for $1 is missing" >&2
            ;;
        -p|--profile)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                [[ -n "${PROFILE}" ]] && log_error "More than one $1 is entered"
                PROFILE=$2
                shift 2
                continue
            fi
            log_error "Argument for $1 is missing"
            ;;
        -i|--project-id)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                [[ -n "${PROJECT_ID}" ]] && log_error "More than one $1 is entered"
                PROJECT_ID=$2
                shift 2
                continue
            fi
            log_error "Argument for $1 is missing"
            ;;
        -n|--name)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                [[ -n "${SA_NAME}" ]] && log_error "More than one $1 is entered"
                SA_NAME=$2
                shift 2
                continue
            fi
            log_error "Argument for $1 is missing"
            ;;
        -*)
            exit_with_usage "Unsupported flag $1" >&2
            exit 1
            ;;
        *)  # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
    esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"

if [[ -z "${ENV}" ]]; then
    log_info "For production environments, create separate service accounts for each hybrid component. \n" \
            "For demo or test environments, create a single service account with all roles.\n" \
            "Enter: prod for production environments.\n" \
            "Enter: non-prod for demo/test environments."
    read -r ENV
fi
# shellcheck disable=SC2199,SC2076
[[ -z "${ENV}" || ! " ${SUPPORTED_ENVS[@]} " =~ " ${ENV} " ]] && exit_with_usage "Env not provided or is not supported."

# shellcheck disable=SC2199,SC2076
if [[ -n "${PROFILE}" ]]; then
    [[ "${ENV}" == "non-prod" ]] && exit_with_usage "--profile should be accompanied with --env prod."
    [[ ! " ${SUPPORTED_PROFILES[@]} " =~ " ${PROFILE} " ]] && exit_with_usage "Profile ${PROFILE} is not supported."
fi

# Service accounts are downloaded to the OUTPUT_DIR.
# Defaults to "service-accounts" folder.
OUTPUT_DIR=${OUTPUT_DIR:-"${PWD}/service-accounts"}
mkdir -p "${OUTPUT_DIR}" || exit_with_usage "Unable to create directory, please check permissions and try again"

# Check gcloud is installed and on the $PATH.
if ! which gcloud > /dev/null 2>&1; then
    log_error "gcloud is not installed or not on PATH."
fi

# If GCP project ID is not passed in as command line arguments. Check gcloud config for project ID.
[[ -z "${PROJECT_ID}" ]] && get_project

# SA_NAME can be overridden only if the env is non-prod or if the profile flag is passed.
[[ -n "${SA_NAME}" && ( "${ENV}" != "non-prod" && -z "${PROFILE}" ) ]] && exit_with_usage "--name flag should be accompanied by --env non-prod flag or --env prod with --profile flag."

# If --profile is passed, create service account just for that profile.
# If --env is set to prod and --profile is not set, create a separate service account for each of the SUPPORTED_PROFILES.
# If --env is set to non-prod, create a single service account with roles for all supported profiles.
if [[ -n "${PROFILE}" ]]; then
    SA_NAME=${SA_NAME:-$PROFILE}
    ROLES=$(get_roles "${PROFILE}")
    create_sa_and_bind_roles "${SA_NAME}" "${OUTPUT_DIR}" "${PROJECT_ID}" "${ROLES[@]}"
elif [[ "${ENV}" == "prod" ]]; then
    for PROF in "${SUPPORTED_PROFILES[@]}"; do
        ROLES=$(get_roles "${PROF}")
        create_sa_and_bind_roles "${PROF}" "${OUTPUT_DIR}" "${PROJECT_ID}" "${ROLES[@]}"
    done
else
    # SA_NAME defaults to apigee-non-prod if --env is set to non-prod.
    SA_NAME=${SA_NAME:-"apigee-non-prod"}
    for PROF in "${SUPPORTED_PROFILES[@]}"; do
        r=$(get_roles "${PROF}")
        ROLES+=("${r}")
    done
    create_sa_and_bind_roles "${SA_NAME}" "${OUTPUT_DIR}" "${PROJECT_ID}" "${ROLES[*]}"
fi

