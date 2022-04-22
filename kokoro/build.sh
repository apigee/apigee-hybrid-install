#!/bin/bash
# Kokoro blocks logging of keystore secrets. If set -x is set, we might leak the
# keystore secret. So, explicitly resetting the 'x' flag.
set +x
# Exit immediately if sequence of one or more commands returns a non-zero status.
set -e

# Read credentials for artifactory
artifactory_pwd=$(cat "${KOKORO_KEYSTORE_DIR}"/72809_prod_artifactory_password)

export APPLICATION=apigee-hybrid-install
BUILDROOT=${BUILDROOT:-git/$APPLICATION}
CUR_DIR=$(pwd)

# Please add build and package and test logic below
