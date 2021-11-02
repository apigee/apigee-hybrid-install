#!/usr/bin/env bash

log_error(){
    printf "\\n[ERROR]: %b\\n" "$*"
    exit 1
}

log_info(){
    printf "\\n[INFO]: %b\\n" "$*"
}
