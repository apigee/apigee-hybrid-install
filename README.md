# Google's formal Documentation

## Hybrid Installation
Follow this [Installation Guide](https://cloud.google.com/apigee/docs/hybrid/preview/new-install-user-guide)

# 
---



# Customizations and Updates that have been submitted through PRs to Google
[Forward Proxy updates](#forward-proxy-updates)
[Add gitignore](#gitignore)

---
## Forward Proxy updates {#forward-proxy-updates}
A forward proxy server may be configured for connecting to the Control Plane and/or for sounthbound calls from the runtime to a target API.

[Related Pull Request](https://github.com/apigee/apigee-hybrid-install/pull/16)


### `Control Plane`

#### Available in:

 - `overlays/controllers/apigee-controller`
 - `overlays/instances/{INSTANCE_NAME}/datastore`
 - `overlays/instances/{INSTANCE_NAME}/environments/{ENV_NAME}`
 - `overlays/instances/{INSTANCE_NAME}/organization`
 - `overlays/instances/{INSTANCE_NAME}/telemetry`

#### Enabling:
Uncomment the component reference "`- ./components/control-plane-http-proxy/`" in the respective `kustomization.yaml` files in each folder.

### `Runtime -> Target`

#### Available in:

 - `overlays/instances/{INSTANCE_NAME}/environments/{ENV_NAME}`

#### Enabling:
Uncomment the component reference "`- ./components/runtime-egress-http-proxy/`" in `apigee-environment.yaml`.


### Modifications to be made:
Pay close attention to each patch file. Not all components accept the same mix of parameters currently. Additionally, the password may need to be base64 encoded.

Example patch file:
- components/control-plane-http-proxy/patch.yaml
   -     `scheme`: *REQUIRED* One of `HTTP` or `HTTPS`
   -     `host`: *REQUIRED* The Host address of your proxy
   -     `port`: *REQUIRED* The port number
   -     `username`: *OPTIONAL* The username associated with your proxy
   -     `password`: *OPTIONAL* The password for accessing the proxy

### Usage:

1. If you have not yet installed Apigee Hybrid, you can continue with the installation steps and these changes will get applied in the process
1. If you already have Apigee Hybrid installed, you will need to apply these new changes using:

```
kubectl apply -k overlays/controllers/apigee-controller
kubectl apply -k overlays/instances/{INSTANCE_NAME}
```

---
## Add gitignore {#gitignore}
Added .gitignore ignoring:
 - /service-accounts **Note:** This may need to be changed if using a Pipeline where the service account keys need to be committed (**not recommended**)

