#!/usr/bin/env bash

APIGEE_HYBRID_VERSION="1.8.0"   # Apigee hybrid version that will be installed.

log_error(){
    printf "\\n[ERROR]: %b\\n" "$*"
    exit 1
}

log_info(){
    printf "\\n[INFO]: %b\\n" "$*"
}
