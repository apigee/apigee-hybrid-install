#!/usr/bin/env bash

APIGEE_HYBRID_VERSION="1.8.0"   # Apigee hybrid version that will be installed.

################################################################################
# Functions for logging error and info.
################################################################################

log_error(){
    printf "\\n[ERROR]: %b\\n\\n" "$*"
    exit 1
}

log_info(){
    printf "\\n[INFO]: %b\\n" "$*"
}

################################################################################
# Checks for the existence of a second argument and exit if it does not exist.
################################################################################
arg_required() {
    if [[ ! "${2:-}" || "${2:0:1}" = '-' ]]; then
        fatal "Option ${1} requires an argument."
    fi
}