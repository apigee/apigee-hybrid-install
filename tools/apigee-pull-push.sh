#!/usr/bin/env bash

# Exit immediately if sequence of one or more commands returns a non-zero status.
set -eo pipefail

# shellcheck disable=SC1090
source "${PWD}/common.sh" || exit 1

HELP=0
REPO="us.gcr.io"
PROJECT_ID=""
TAG="${APIGEE_HYBRID_VERSION}" 

APIGEE_COMPONENTS=("apigee-mart-server" "apigee-synchronizer" "apigee-runtime" "apigee-hybrid-cassandra-client" "apigee-hybrid-cassandra" "apigee-cassandra-backup-utility" "apigee-udca" "apigee-connect-agent" "apigee-watcher" "apigee-operators" "apigee-installer" "apigee-redis" "apigee-diagnostics-collector" "apigee-diagnostics-runner")
THIRD_PARTY_COMPONENTS=("apigee-stackdriver-logging-agent:1.8.9" "apigee-prom-prometheus:v2.25.0" "apigee-stackdriver-prometheus-sidecar:0.9.0" "apigee-kube-rbac-proxy:v0.8.0" "apigee-envoy:v1.16-latest" "apigee-prometheus-adapter:v0.9.1")

main() {
    # Validate prerequisite.
    validate_prerequisite

    # Parse arguments.
    parse_args "${@}"

    # Configure defaults.
    configure_defaults

    # Validate arguments.
    validate_args

    if [[ "${HELP}" -eq 1 ]]; then
        usage
        exit 0
    fi

    echo "$(basename $0) will push images to $REPO:$PROJECT_ID"

    docker_exe "pull" "google" "${TAG}"
    docker_tag "google" "${REPO}" "${TAG}"
    docker_exe "push" "${REPO}" "${TAG}"
}

################################################################################
# Displays apigee pull push script usage details, when --help flag is specified.
################################################################################
usage() {
    echo "Usage: $(basename \"$0\") [repo where you want to push the images]" \
        "Note: if the repo is not provided. It will be pushed to us.gcr.io/<PROJECT_ID>.\\n" \
        "      Please make sure you have gcloud and docker installed.\\n\\n" \
        "example: $(basename "$0") [foo.docker.com]"
}

################################################################################
# Validate prerequisite.
################################################################################
validate_prerequisite() {
    # Check gcloud is installed and on the $PATH.
    if ! which gcloud > /dev/null 2>&1; then
        echo "gcloud is not installed or not on PATH."
        exit 0
    fi

    # Check docker is installed and on the $PATH.
    if ! which docker > /dev/null 2>&1; then
        echo "docker is not installed or not on PATH."
        exit 0
    fi
}

################################################################################
# Parse command line arguments.
################################################################################
arg_required() {
    if [[ ! "${2:-}" || "${2:0:1}" = '-' ]]; then
        fatal "Option ${1} requires an argument."
    fi
}

parse_args() {
    while [[ $# != 0 ]]; do
        case "${1}" in
        --help)
            HELP="1"
            shift 1
            ;;
        --repo)
            arg_required "${@}"
            REPO="${2}"
            shift 2
            ;;
        --project-id)   
            arg_required "${@}"
            PROJECT_ID="${2}"
            shift 2
            ;;
        *)
            fatal "Unknown option ${1}"
            ;;
        esac
    done
}

################################################################################
# Tries to configure the default values of unset variables.
################################################################################
configure_defaults() {
    # Configure project id.
    if [[ -z "${PROJECT_ID}" ]]; then
        PROJECT_ID="$(gcloud config get-value project)"
    fi
    readonly PROJECT_ID
}


################################################################################
# Validate command line arguments.
################################################################################
validate_args() {
    if [[ "${HELP}" -eq 1 ]]; then
        return
    fi

    if [[ -z "${REPO}" ]]; then
        echo "Repository is empty, it can not be empty."
        exit 0
    fi

    if [[ -z "${PROJECT_ID}" ]]; then
        echo "Project id is empty, it can not be empty."
        exit 0
    fi

    if [[ -z "${TAG}" ]]; then
        echo "Tag is empty, it can not be empty."
        exit 0
    fi
}

################################################################################
# Docker helper functions.
################################################################################
docker_exe() {
    local action=$1
    local repo=$2
    local tag=$3

    for i in "${APIGEE_COMPONENTS[@]}"
    do
        docker "${action}" "${repo}/$i:${tag}"
    done

    for i in "${THIRD_PARTY_COMPONENTS[@]}"
    do
        docker "${action}" "${repo}/$i"
    done
}

docker_tag() {
    local source=$1
    local dest=$2
    local tag=$3

    for i in "${APIGEE_COMPONENTS[@]}"
    do
        docker tag "${source}/$i:${tag}" "${dest}/$i:${tag}"
    done

    for i in "${THIRD_PARTY_COMPONENTS[@]}"
    do
        docker tag "${source}/$i" "${dest}/$i"
    done
}

main "$@"