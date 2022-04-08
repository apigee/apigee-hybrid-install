# Hybrid Installation

## Prerequisites
1. You need to have the following utilities installed in your system:
    * `kpt`([download](https://kpt.dev/installation/))
        * **NOTE:** KPT versions `v0.39` and below are not supported. Download kpt from the link mentioned above (`v1.0+`) to ensure that its working.
    * `jq`([download](https://stedolan.github.io/jq/download/))
    * envsubst
        * **NOTE** `envsubst` should be available in most GNU based systems. For macos and other systems, follow  instructions in this [repo](https://github.com/a8m/envsubst).
    * `gcloud`
    * `kubectl` version >= `1.18` ([download](https://kubernetes.io/docs/tasks/tools/#kubectl))
    * `curl`
2. Ensure that you are logged in using gcloud. If not, run:
    ```bash
    gcloud auth login
    ```
    Optionally, ensure that you have the correct project setup in gcloud:
    ```bash
    gcloud config set project ${ORGANIZATION_NAME}
    ```
    (you can also use the `--org ${ORGANIZATION_NAME}`) flag in the shell script to explicitly pass the Apigee organization name.
3. The project by default uses the `prod` APIs. If you are using an `autopush` or `staging` org, make sure to change the `apigeeEndpoint` and `apigeeConnectEndpoint` fields in [apigee-organization.yaml](overlays/instances/instance1/organization/apigee-organization.yaml)
    * staging endpoints:
    ```yaml
    apigeeEndpoint: "https://staging-apigee.sandbox.googleapis.com"
    apigeeConnectEndpoint: "staging-apigeeconnect.sandbox.googleapis.com:443"
    ```
    * autopush endpoints:
    ```yaml
    apigeeEndpoint: "https://autopush-apigee.sandbox.googleapis.com"
    apigeeConnectEndpoint: "autopush-apigeeconnect.sandbox.googleapis.com:443"
    ```
4. Also, depending on whether your org is `autopush` or `staging`, you will explicitly need to set the correct Apigee endpoint in `gcloud` (No actions required for `prod` organization):
    * staging endpoints:
    ```bash
    gcloud config set api_endpoint_overrides/apigee https://staging-apigee.sandbox.googleapis.com/
    ```
    * autopush endpoints:
    ```bash
    gcloud config set api_endpoint_overrides/apigee https://autopush-apigee.sandbox.googleapis.com/
    ```
    Run
    ```bash
    gcloud config list
    ```
    to check the configuration.
6. If you are using a fresh cluster to perform the installation, you'll need to install [cert-manager](https://cert-manager.io/docs/reference/api-docs/):
    ```bash
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml
    ```
7. For easing internal testing, the script currently uses images from the [`us.gcr.io/apigee-demo-gauravkg/new-hybrid-install`](https://us.gcr.io/apigee-demo-gauravkg/new-hybrid-install). Your project might not have the permission to pull images from this repo in which case you have the following options:
    1. You can try to temporarily give your projects service account "`<YOUR_PROJECT_NUMBER>-compute@developer.gserviceaccount.com`" the `Storage Object Viewer` role within the `apigee-demo-gauravkg` project. This permission will only last untill Latchkey resets those permissions.
    2. To make the above arrangement permanent, modify the `iam_policy.yaml` file for the project [here](http://google3/configs/cloud/gong/org_hierarchy/google.com/teams/apigee-teams/shared/hybrid/project.apigee-demo-gauravkg/iam_policy.yaml) by adding the following lines:
        ```yaml
        # ...
        - members:
            # ...
            - serviceAccount:<YOUR_PROJECT_NUMBER>-compute@developer.gserviceaccount.com
            # ...
            role: roles/storage.objectViewer
        # ...
        ```
    3. You can try pulling the images from the above mentioned [repo](https://us.gcr.io/apigee-demo-gauravkg/new-hybrid-install) and add them to your project. (Steps left as an exercise for the reader :) ). Then you need to make the controller point to this new image hub in your project by modifying [bases/controllers/apigee-controller/apigee-controller-deployment.yaml](bases/controllers/apigee-controller/apigee-controller-deployment.yaml):
        ```yaml
        # --image-repository-hub=us.gcr.io/apigee-demo-gauravkg/new-hybrid-install
        --image-repository-hub=<YOUR_IMAGEHUB_PATH>
        ```
        and change the controllers image itself:
        ```yaml
        # image: us.gcr.io/apigee-demo-gauravkg/apigee-controller:gauravkg
        image: <YOUR_IMAGEHUB_PATH>/apigee-operators:<TAGGED_VERSION>
        ```


## How to use [`apigee-hybrid-setup.sh`](tools/apigee-hybrid-setup.sh)?
The shell script offers various options. To see a list of all the supported
flags, you can use the help flag
```bash
./tools/apigee-hybrid-setup.sh --help
```

You can execute individual tasks or execute all the tasks to perform a complete
installation.

* Example command for complete installation:
    ```bash
    ./tools/apigee-hybrid-setup.sh --cluster-name <CLUSTER_NAME> --cluster-region <CLUSTER_REGION> --setup-all
    ```
* Example command for performing an individual action:
    ```bash
    ./tools/apigee-hybrid-setup.sh --cluster-name <CLUSTER_NAME> --cluster-region <CLUSTER_REGION> --apply-configuration
    ```

The script will use the currently configured project in gcloud as your Apigee
Organization. If that is not the one that you want, you can specify the correct
one using `--org` flag (or by exporting the ${ORGANIZATION_NAME} environment
variable.) All the values that the installation script will use are printed
under the heading **`Configuring default values...`** - if some value was
identified incorrectly, you can stop the script mid way, and then rerun with the
appropriate flag.

### Debugging
In case of errors, one can use the `--verbose` flag to print debugging
information