# Apigee Hybrid

## Overview

The new Apigee hybrid installation experience lets you install Apigee
components using the Kubernetes command-line tool, [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl). The enhanced
validations and visibility of the components being installed provides better
debuggability and improves the overall installation experience.

An install script, *apigee-hybrid-setup.sh*, provides an easy tool for basic
installation. You can use this script to create your hybrid installation and then
modify it to fit your needs with [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl). Alternatively, you can also create
your hybrid installation from scratch using [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl). For more information about *apigee-hybrid-setup.sh*, see Apigee Hybrid Installation and Administration User Guide.

All Apigee hybrid configuration properties are stored in YAML files, one for
each major component. This allows granular control of your hybrid
installation on your Kubernetes environment.

## Audience

The target audience of this project are Apigee operator persona (users who
install, manage, or administer Apigee Hybrid installations).

## Repository structure

This repository has the following files and directories:

*   **bases/**: Contains the Kubernetes manifests of the Apigee components.
*   **overlays/**: Contains the `kustomize` component templates for any additional  configurations.
*   **templates/**: Contains the templates for generating Kubernetes manifests.
*   **tools/**: Contains supporting utilities for the project.
*   **docs/**: Contains the project user guide and API reference files.
*   **CONTRIBUTING.md**: Contribution guidelines for the project.
*   **LICENSE**: Copyright and license information of the project.
*   **README.md**: Public-facing README file.

## General prerequisites

Ensure that you have the following utilities installed in your system.

1.  kpt [[download here](https://kpt.dev/installation/)]  
**Note:** Download kpt version v1.0 or higher. kpt versions v0.39 and lower are not supported.
2.  jq [[download here](https://stedolan.github.io/jq/download/)]
3.  envsubst  
**Note:** envsubst must be available in most of the GNU based systems. For macos and other systems, follow instructions in this [repo](https://github.com/a8m/envsubst).
4.  Google cloud (gcloud)  
Ensure that you are logged in using gcloud. If not, run the following:  
`gcloud auth login`  
Optionally, ensure that you have the correct project setup in gcloud:  
`gcloud config set project ${ORGANIZATION_NAME}`  
Use the `--org ${ORGANIZATION_NAME}` flag in the shell script to explicitly pass the Apigee organization name.
5.  Kubernetes command-line tool (kubectl) [[download here](https://kubernetes.io/docs/tasks/tools/#kubectl)]  
**Note:** Download kubectl version v1.18 or higher.
6.  curl
7.  If you are using a fresh cluster to perform the installation, install [cert-manager](https://cert-manager.io/docs/reference/api-docs/) by running the following:  
`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml`

## Using the [`apigee-hybrid-setup.sh`](tools/apigee-hybrid-setup.sh) install script

The *apigee-hybrid-setup.sh* script, provides an easy tool for basic
installation. You can use this script to create your hybrid installation and then
modify it to fit your needs with [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl). 

The shell script offers various options. To see a list of all the supported
flags, use the help following flag:
`./tools/apigee-hybrid-setup.sh --help`

You can execute individual tasks or execute all the tasks to perform a complete
installation.

*   Example command for complete installation:  
`./tools/apigee-hybrid-setup.sh --cluster-name <CLUSTER_NAME> --cluster-region <CLUSTER_REGION> --setup-all`
*   Example command for performing an individual action:  
`./tools/apigee-hybrid-setup.sh --cluster-name <CLUSTER_NAME> --cluster-region <CLUSTER_REGION> --apply-configuration`

The script uses the currently configured project in gcloud as your Apigee
organization. You can change this by one using the `--org` flag (or by exporting
the `${ORGANIZATION_NAME}` environment variable).  
All the values that the installation script will use are printed under the heading "**Configuring
default values...**".  
If some values are identified incorrectly, you can stop the script mid way, and then rerun with the appropriate flag.

## Debugging

Use the `--verbose` flag to print debugging information.

## Documentation

*   Apigee Hybrid Installation and Administration User Guide.
*   API Reference Documents.
