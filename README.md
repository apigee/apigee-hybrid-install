# Hybrid Installation

## Prerequisites
* `kpt`([download](https://kpt.dev/installation/))
    * **NOTE:** KPT versions `v0.39` and below are not supported. Download kpt from the link mentioned above (`v1.0+`) to ensure that its working.
* `jq`([download](https://stedolan.github.io/jq/download/))
* envsubst
    * **NOTE** `envsubst` should be available in most GNU based systems. For macos and other systems, follow  instructions in this [repo](https://github.com/a8m/envsubst).
* `gcloud`
* `kubectl`
* `curl`

## Usage
The shell script offers various options. To see a list of all the supported
flags, you can use the help flag
```shell
./tools/apigee-hybrid-setup.sh --help
```

You can execute individual tasks or execute all the tasks to perform a complete
installation.

* Example command for complete installation:
    ```shell
    ./tools/apigee-hybrid-setup.sh --cluster-name <CLUSTER_NAME> --cluster-region <CLUSTER_REGION> --setup-all
    ```
* Example command for performing an individual action:
    ```shell
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


