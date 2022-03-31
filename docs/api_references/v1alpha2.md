# API Reference

## Packages
- [apigee.cloud.google.com/v1](#apigeecloudgooglecomv1)
- [apigee.cloud.google.com/v1alpha2](#apigeecloudgooglecomv1alpha2)
- [apigee.cloud.google.com/v1beta1](#apigeecloudgooglecomv1beta1)


## apigee.cloud.google.com/v1

Package v1 holds versioned core types that are used across different versions of Apigee CRDs.



#### CassandraProperties



CassandraProperties stores the Casssandra properties.

_Appears in:_
- [Properties](#properties)

| Field | Description |
| --- | --- |
| `clusterName` _string_ | *(Optional)* |
| `datacenter` _string_ | *(Optional)* |
| `rack` _string_ | *(Optional)* |
| `externalSeedHost` _string_ | *(Optional)* |
| `multiRegionSeedHost` _string_ | *(Optional)* |
| `port` _integer_ | *(Optional)* |
| `enableSysctlInitContainer` _boolean_ | *(Optional)* |
| `disableCassandraPDB` _boolean_ | *(Optional)* |


#### Component



Component defines the spec overrides of each Apigee Edge component such as, Message Processor, Synchronizer, and so on.

_Appears in:_
- [EnvComponents](#envcomponents)
- [OrgComponents](#orgcomponents)
- [TelemetryComponents](#telemetrycomponents)

| Field | Description |
| --- | --- |
| `name` _string_ | Name of the component. |
| `properties` _[Properties](#properties)_ | *(Optional)* |
| `storage` _[Storage](#storage)_ | *(Optional)* |
| `annotations` _object (keys:string, values:string)_ | *(Optional)* |
| `sslCertSecretRef` _string_ | *(Optional)* |
| `sslKeySecretRef` _string_ | *(Optional)* |
| `podServiceAccountName` _string_ | The service account name that is used to run pods for this component. |
| `appServiceAccountSecretName` _string_ | The secret name of the service account that is used when loading a JSON service account key for this component. |
| `initContainers` _[Container](#container) array_ | *(Optional)* |
| `containers` _[Container](#container) array_ | *(Optional)* |
| `volumes` _[Volume](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#volume-v1-core) array_ | *(Optional)* |
| `configOverride` _object (keys:string, values:string)_ | *(Optional)* |
| `lifecycle` _[Lifecycle](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#lifecycle-v1-core)_ | *(Optional)* |
| `securityContext` _[SecurityContext](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#securitycontext-v1-core)_ | *(Optional)* |
| `minReplicas` _integer_ | *(Deprecated)* Use an Autoscaler object for defining the minimum replica count. |
| `maxReplicas` _integer_ | *(Deprecated)* Use an Autoscaler object for defining the maximum replica count. |
| `nodeAffinityLabels` _object (keys:string, values:string)_ | *(Deprecated. Optional)* |
| `nodeAffinityRequired` _boolean_ | *(Optional)* |
| `nodeAffinity` _[NodeAffinity](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core)_ | *(Optional)* |
| `tolerations` _[Toleration](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#toleration-v1-core) array_ | *(Optional)* |
| `version` _string_ | *(Optional)* |
| `autoScaler` _HorizontalPodAutoscalerSpec_ | *(Optional)* |
| `terminationGracePeriodSeconds` _integer_ | *(Optional)* |
| `automountServiceAccountToken` _boolean_ | *(Optional)* |
| `dnsPolicy` _[DNSPolicy](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#dnspolicy-v1-core)_ | *(Optional)* Sets the DNS policy for the pod. The DNS parameters provided in the DNSConfig file will merge with the DNSPolicy selected. The DNS options can be set along with the hostNetwork by explicitly specifying the DNS policy to 'ClusterFirstWithHostNet'. Default Value: "ClusterFirst". Other valid values include: 'ClusterFirstWithHostNet', 'ClusterFirst', 'Default', and 'None'. |
| `hostNetwork` _boolean_ | *(Optional)* If true, the ports using the host network must be specified. Default Value. "false". |
| `trafficPolicy` _TrafficPolicy_ | *(Optional)* |
| `release` _[ComponentRelease](#componentrelease)_ | *(Optional)* To override the default release configuration of a component. |
| `settings` _[ComponentSetting](#componentsetting)_ | *(Optional)* Contains the allowed overrides for a component. |
| `replicas` _integer_ | *(Optional)* The desired number of replicas for a component using a statefulset. |
| `workloadResource` _[WorkloadResource](#workloadresource)_ | Type of workload resource that will be created. |
| `volumeClaimTemplates` _[PersistentVolumeClaim](#persistentvolumeclaim) array_ | Persistent volume to be created if WorkloadResource is StatefulSet. |
| `serviceSpec` _[ServiceSpecOverrides](#servicespecoverrides)_ | Spec for the underlying ApigeeDeployment created by this component. |


#### ComponentRelease



ComponentRelease provides information on the release configuration overrides for a component.

_Appears in:_
- [Component](#component)

| Field | Description |
| --- | --- |
| `strategy` _[ReleaseStrategy](#releasestrategy)_ | Represents the strategy used for the release. |
| `stages` _[ReleaseStage](#releasestage)_ | Represents the multiple phases of a release process. Stages provide more control over automatic canary analysis during a release, it identifies failures in new a version without major traffic impact, and requires manual approval after certain phase. |
| `disableCanaryAnalysis` _boolean_ | If true, the canary analysis for the entire release is disabled; false, otherwise. |
| `maxCanaryEvaluationDuration` _[Duration](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#duration-v1-meta)_ | An indicator for canary evaluation. Returns NONE if a verdict is not determined in the given duration. |
| `passOnNoneVerdict` _boolean_ | If true, the canary analysis is considered PASS although the verdict is NONE. This can happen due to insufficient data for canary analysis. |


#### ComponentSetting



ComponentSetting contains the settings for the component.

_Appears in:_
- [Component](#component)

| Field | Description |
| --- | --- |
| `containerSettings` _[ContainerSetting](#containersetting) array_ | Used for the container settings of a component. |


#### ComponentStatus



ComponentStatus provides information on the status of a controller component. For example, ApigeeRuntime is a component of ApigeeEnvironment.

_Appears in:_
- [EnvComponentStatus](#envcomponentstatus)
- [OrgComponentStatus](#orgcomponentstatus)
- [TelemetryComponentStatus](#telemetrycomponentstatus)

| Field | Description |
| --- | --- |
| `state` _State_ | Defines the overall state of a component. |
| `currentStage` _[ReleaseStage](#releasestage)_ | Indicates the current stage of the release process. This is a read-only field. |
| `lastSuccessfullyReleasedVersion` _[ReleaseVersion](#releaseversion)_ | The latest version of this component that was successfully released. |
| `releaseHistory` _[ReleaseHistory](#releasehistory) array_ | Stores the release history of this component. |
| `latestBinaryRelease` _[ReleaseHistory](#releasehistory)_ | Stores the most recent binary changes related activity. |
| `latestConfigRelease` _[ReleaseHistory](#releasehistory)_ | Stores the most recent config changes related activity. |
| `replicas` _[ReplicaStatus](#replicastatus)_ | Returns the most recently observed replica status in the replica set. |
| `lastReleasedComponentOverrides` _string_ | Stores the component override fields that would cause an AD release when those fields are changed. This value is updated after every successful release and is used during rollback. This is a read-only field. |
| `rolledBackOnLatestRelease` _boolean_ | If true, It indicates that the component overrides was rolled back for the latest release of this component; false, otherwise. This ensures that only the component overrides are rolled back once for a particular rollback entry in the release history. This is a read-only field. |
| `configOverrideRefs` _string array_ | A list of unique config override references maintained by the controller. Reference Format: "{component}-{project_name}-{unique_identifier}" |
| `configAttemptFailure` _[ReleaseHistory](#releasehistory)_ | Not NIL, if the previous config update attempt failed. |


#### ConnectAgentProperties



ConnectAgentProperties stores the apigeeconnect properties.

_Appears in:_
- [Properties](#properties)

| Field | Description |
| --- | --- |
| `logLevel` _string_ | *(Optional)* |


#### Container



Container defines the override properties for individual containers.

_Appears in:_
- [Component](#component)

| Field | Description |
| --- | --- |
| `name` _[ContainerName](#containername)_ | Name of the container. |
| `image` _string_ | *(Optional)* |
| `imagePullPolicy` _[PullPolicy](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#pullpolicy-v1-core)_ | *(Optional)* |
| `resources` _[ResourceRequirements](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#resourcerequirements-v1-core)_ | *(Optional)* The compute resources required by this container. Note that these resources cannot be updated. For more information, see: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/ |
| `readinessProbe` _[Probe](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#probe-v1-core)_ | *(Optional)* |
| `livenessProbe` _[Probe](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#probe-v1-core)_ | *(Optional)* |
| `env` _[EnvVar](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#envvar-v1-core) array_ | *(Optional)* |
| `command` _string array_ | *(Optional)* The entrypoint array which does not get executed within a shell. A docker image entrypoint is used if this is not provided. Variable references (example: $(VAR_NAME)) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. For more information, see: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell |
| `volumeMounts` _[VolumeMount](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#volumemount-v1-core) array_ | *(Optional)* |


#### ContainerName

_Underlying type:_ `string`

ContainerName defines the name of the main containers such as, Cassandra, Apigee Connect Agent, MART, and so on. Values include: `apigee-cassandra`, `apigee-connect-agent`, `apigee-mart`, and more.

_Appears in:_
- [Container](#container)



#### ContainerSetting



ContainerSetting contains all the settings for a container.

_Appears in:_
- [ComponentSetting](#componentsetting)

| Field | Description |
| --- | --- |
| `name` _string_ | Name of the container. |
| `settings` _[Setting](#setting) array_ |  |


#### EnvSource



EnvSource represents the env source for the provided value.

_Appears in:_
- [Setting](#setting)

| Field | Description |
| --- | --- |
| `secretKeyRef` _[KeySelector](#keyselector)_ | A key from the secret key reference. |
| `configMapKeyRef` _[KeySelector](#keyselector)_ | A key from the config map key reference. |


#### EnvoyAdapterProperties



EnvoyAdapterProperties stores the Envoy Adapter properties.

_Appears in:_
- [Properties](#properties)

| Field | Description |
| --- | --- |
| `arcConfigURI` _string_ | The resource location to download the Apigee Runtime Control(ARC) config (also known as Envoy Adapter config). It stores both the previous and the latest config locations. |
| `adapterLogLevel` _string_ | Sets the log level of the Adapter. |
| `adapterMPLogLevel` _string_ | Sets the log level of the Message Processor. |


#### EnvoyGatewayProperties



EnvoyGatewayProperties stores the EnvoyGateway properties.

_Appears in:_
- [Properties](#properties)

| Field | Description |
| --- | --- |
| `gatewayConfigURI` _string_ | The resource location to download the Envoy Gateway config. |
| `enableSidecarAdapter` _boolean_ | EnableSidecarAdapter creates an envoy adapter as sidecar to envoy gateway. |
| `sidecarARCConfigURI` _string_ | SidecarARCConfigURI points to the resource location to download the Apigee Runtime Control(ARC) config aka Envoy Adapter config, It stores both previous and latest config location with "," separated values. |
| `sidecarAdapterLogLevel` _string_ | SidecarAdapterLogLevel is used to set the log level of adapter. |


#### GatewayType

_Underlying type:_ `string`

GatewayType determines the runtime type of an environment. For example. Envoy Gateway or Message Processor.

_Appears in:_
- [ApigeeEnvironmentSpec](#apigeeenvironmentspec)



#### HTTPForwardProxy



HTTPForwardProxy defines a spec for the HTTP forward proxy.

_Appears in:_
- [ApigeeOrganizationSpec](#apigeeorganizationspec)
- [ApigeeTelemetrySpec](#apigeetelemetryspec)

| Field | Description |
| --- | --- |
| `scheme` _[HTTPScheme](#httpscheme)_ | The HTTP scheme for the HTTP forward proxy. |
| `host` _string_ | The host for the HTTP forward proxy. |
| `port` _integer_ | The port for the HTTP forward proxy. |
| `username` _string_ |  |
| `password` _string_ |  |


#### HTTPScheme

_Underlying type:_ `string`

HTTPScheme defines scheme types.

_Appears in:_
- [HTTPForwardProxy](#httpforwardproxy)





#### PersistentVolumeClaim



PersistentVolumeClaim defines a user request to claim a persistent volume.

_Appears in:_
- [Component](#component)

| Field | Description |
| --- | --- |
| `name` _string_ | Name of the persistent volume claim. |
| `annotations` _object (keys:string, values:string)_ | An unstructured key value map used to define Kubernetes. |
| `accessModes` _[PersistentVolumeAccessMode](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#persistentvolumeaccessmode-v1-core) array_ | *(Optional)* The desired access modes of the persistent volume. For more information, see: https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes-1 |
| `selector` _[LabelSelector](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#labelselector-v1-meta)_ | *(Optional)* A label query over volumes. This is considered for binding. |
| `resources` _[ResourceRequirements](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#resourcerequirements-v1-core)_ | *(Optional)* The minimum resources for a volume. For more information, see: https://kubernetes.io/docs/concepts/storage/persistent-volumes#resources |
| `volumeName` _string_ | *(Optional)* A binding reference to the persistent volume of this claim. |
| `storageClassName` _string_ | *(Optional)* Name of the StorageClass required by this claim. For more information, see: https://kubernetes.io/docs/concepts/storage/persistent-volumes#class-1 |
| `volumeMode` _[PersistentVolumeMode](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#persistentvolumemode-v1-core)_ | *(Optional. Beta feature)* Volume type required by the claim. The value of the Filesystem is implied when not included in the claim spec. |


#### Properties



Properties contain the properties of a Component.

_Appears in:_
- [Component](#component)

| Field | Description |
| --- | --- |
| `CassandraProperties` _[CassandraProperties](#cassandraproperties)_ | *(Optional)* |
| `ConnectAgentProperties` _[ConnectAgentProperties](#connectagentproperties)_ | *(Optional)* |
| `WatcherProperties` _[WatcherProperties](#watcherproperties)_ | *(Optional)* |
| `SynchronizerProperties` _[SynchronizerProperties](#synchronizerproperties)_ | *(Optional)* |
| `EnvoyGatewayProperties` _[EnvoyGatewayProperties](#envoygatewayproperties)_ | *(Optional)* |
| `EnvoyAdapterProperties` _[EnvoyAdapterProperties](#envoyadapterproperties)_ | *(Optional)* |
| `configID` _string_ | *(Optional)* The config ID loaded by the component. The component status displays this ID which helps in tracking config change completion. It is recommended to use user-readable values for the config ID. |


#### ReleaseError

_Underlying type:_ `string`

ReleaseError indicates the error type displayed during a release. Values include: `manualRollback`, `canaryVerdictFail`, `canaryVerdictNone`, and `rollbackDueToForceUpdate`.

_Appears in:_
- [ReleaseHistory](#releasehistory)



#### ReleaseHistory



ReleaseHistory represents the release history of a component.

_Appears in:_
- [ComponentStatus](#componentstatus)

| Field | Description |
| --- | --- |
| `fromVersion` _[ReleaseVersion](#releaseversion)_ | The current release version of the component. |
| `toVersion` _[ReleaseVersion](#releaseversion)_ | The final release version of the component after the release. |
| `state` _[ReleaseState](#releasestate)_ | Current state of the release. |
| `startTime` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ | The start time of the release. |
| `endTime` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ | The end time of the release. |
| `errorType` _[ReleaseError](#releaseerror)_ | The error type displayed during the release. |
| `error` _string_ | If the release fails, it displays the cause of the failure. If the release succeeds, it displays the release metadata. |


#### ReleaseStage



ReleaseStage defines the behavior of a particular phase of the release process.

_Appears in:_
- [ComponentRelease](#componentrelease)
- [ComponentStatus](#componentstatus)

| Field | Description |
| --- | --- |
| `name` _string_ | Name of the release stage. |
| `trafficPercentage` _integer_ | Percentage of traffic sent to the new version of the application. |
| `minWaitSeconds` _integer_ | The minimum wait time (in seconds) for a stage. |
| `manualApprovalNeeded` _boolean_ | If true, a manual approval is required to pass a stage; false otherwise. |
| `disableCanaryAnalysis` _boolean_ | If true, the canary analysis for a stage is disabled; false otherwise. |


#### ReleaseState

_Underlying type:_ `string`

ReleaseState indicates the user-facing state of the release based on its history object. Values include: `in-progress`, `succeeded`, and `rolled-back`.

_Appears in:_
- [ReleaseHistory](#releasehistory)



#### ReleaseStrategy

_Underlying type:_ `string`

ReleaseStrategy defines the release strategy for ApigeeDeployment, Release.Strategy uses this value. Values include: `rolling`, `none`, and `scale-down-first`.

_Appears in:_
- [ComponentRelease](#componentrelease)



#### ReleaseVersion



ReleaseVersion stores the release version and revision of the ApigeeDeployment.

_Appears in:_
- [ComponentStatus](#componentstatus)
- [ReleaseHistory](#releasehistory)

| Field | Description |
| --- | --- |
| `version` _string_ | Version of the ApigeeDeployment Spec. |
| `revision` _string_ | Revision of the ApigeeDeployment for a given version. |
| `configID` _string_ | ID of the current config that loaded this revision. |
| `podTemplateSpecHash` _string_ | The hash value used for a given release of the ApigeeDeployment. |


#### ReplicaStatus



ReplicaStatus defines the replica status of the most recently observed replica set.

_Appears in:_
- [ComponentStatus](#componentstatus)

| Field | Description |
| --- | --- |
| `total` _integer_ | The total number of non-terminated pods targeted by a deployment that have their labels match the selector. This is a read-only field. |
| `updated` _integer_ | The total number of non-terminated pods targeted by a deployment that have the desired template spec. This is a read-only field. |
| `ready` _integer_ | The total number of ready pods targeted by a deployment. This is a read-only field. |
| `available` _integer_ | The total number of available pods targeted by a deployment that are ready for a minimum of minReadySeconds. This is a read-only field. |
| `unavailable` _integer_ | The total number of unavailable pods targeted by a deployment. These include the pods that are still required for the deployment to have 100 percent available capacity. Unavailable pods can either be pods that are running but not yet available, or pods that are not created. This is a read-only field. |


#### ServiceSpecOverrides



ServiceSpecOverrides defines the overridable properties for the underlying service generated by ApigeeDeployment.

_Appears in:_
- [Component](#component)

| Field | Description |
| --- | --- |
| `annotations` _object (keys:string, values:string)_ | *(Optional)* An unstructured key value map which is stored with a resource. External tools can set the map to store and retrieve arbitrary metadata. Annotations are not queryable and should be preserved when modifying objects. For more information, see: http://kubernetes.io/docs/user-guide/annotations |
| `ports` _[ServicePort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#serviceport-v1-core) array_ | The list of ports that are exposed by this service. For more information, see: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies |
| `clusterIP` _string_ | *(Optional)* An IP address of the service which is assigned randomly by the master. If an IP address is specified manually, but is not in use by others, then it will be allocated to the service. Note that this field cannot be changed through updates. For more information, see: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies |
| `type` _[ServiceType](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#servicetype-v1-core)_ | *(Optional)* Determines how the Service is exposed. Defaults to ClusterIP. For more information, see: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| `externalIPs` _string array_ | *(Optional)* A list of external IP addresses with traffic acceptable by the nodes in the cluster. These IP addresses are not managed by Kubernetes.  Note that the user is responsible for ensuring that the traffic arrives at a node with this IP address. For example, external load-balancers that are not part of the Kubernetes system. |
| `sessionAffinity` _[ServiceAffinity](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#serviceaffinity-v1-core)_ | *(Optional)* Maintains session affinity. Defaults to None. For more information, see: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies |
| `loadBalancerIP` _string_ | *(Optional)* The IP address used when creating a Load Balancer. Applies to Service Type: LoadBalancer Note that this feature depends on whether the underlying cloud-provider supports specifying the loadBalancerIP when a load balancer is created. |
| `loadBalancerSourceRanges` _string array_ | *(Optional)* Restricts traffic through the load-balancer to only the specified client IP addresses. Note that this field will be ignored if the cloud-provider does not support the feature." For more information, see: https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/ |
| `externalName` _string_ | *(Optional)* The external reference that kubedns or equivalent will return as a CNAME record for this service. No proxying involved. Must be a valid RFC-1123 hostname (https://tools.ietf.org/html/rfc1123) and requires Type to be ExternalName. |
| `externalTrafficPolicy` _[ServiceExternalTrafficPolicyType](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#serviceexternaltrafficpolicytype-v1-core)_ | *(Optional)* Indicates if the service routes external traffic to node-local or cluster-wide endpoints. |
| `healthCheckNodePort` _integer_ | *(Optional)* The healthcheck nodePort for the service. If not specified, HealthCheckNodePort is created by the service API backend with the allocated nodePort. If specified, Uses the user-specified nodePort value. Only effects when Type is set to LoadBalancer and ExternalTrafficPolicy is set to Local. |
| `sessionAffinityConfig` _[SessionAffinityConfig](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#sessionaffinityconfig-v1-core)_ | *(Optional)* The configurations of session affinity. |


#### Setting



Setting stores the overrides setting key and value.

_Appears in:_
- [ContainerSetting](#containersetting)

| Field | Description |
| --- | --- |
| `type` _[SettingType](#settingtype)_ | The setting type. |
| `key` _string_ | The setting key. |
| `value` _string_ | The setting value. |
| `valueFrom` _[EnvSource](#envsource)_ | Source of the environment variable value. |


#### SettingType

_Underlying type:_ `string`

SettingType indicates the setting type. Values include: `SETTINGS_TYPE_UNSPECIFIED`, `CONFIG_PROPERTY`, `ENV_VAR`, `CMD_ARG`.

_Appears in:_
- [Setting](#setting)



#### State

_Underlying type:_ `string`

State defines the overall state of an Apigee object. Values include: `creating`, `running`, `releasing`, `scaling`, and `deleting`.

_Appears in:_
- [ApigeeEnvironmentStatus](#apigeeenvironmentstatus)
- [ApigeeOrganizationStatus](#apigeeorganizationstatus)
- [ApigeeTelemetryStatus](#apigeetelemetrystatus)
- [ComponentStatus](#componentstatus)



#### Storage



Storage defines the override properties for the storage configuration.

_Appears in:_
- [Component](#component)

| Field | Description |
| --- | --- |
| `storageClass` _string_ | *(Optional)* |
| `storageSize` _string_ | *(Optional)* |


#### SynchronizerProperties



SynchronizerProperties stores the Synchronizer properties.

_Appears in:_
- [Properties](#properties)

| Field | Description |
| --- | --- |
| `pollInterval` _integer_ | *(Optional)* |


#### WatcherProperties



WatcherProperties stores the Watcher properties.

_Appears in:_
- [Properties](#properties)

| Field | Description |
| --- | --- |
| `ingressPollInterval` _string_ | *(Optional)* |
| `watcherLogLevel` _string_ | *(Optional)* |
| `ingressCertSecretName` _string_ | *(Optional)* |
| `mintRecurringJobImage` _string_ | Deprecated. |
| `enableMaintenance` _boolean_ | *(Optional)* |
| `enableImmutableGateway` _boolean_ | *(Optional)* |
| `runtimeConfigPollIntervalSeconds` _integer_ | *(Optional)* |
| `immutableGatewayK8sSecret` _string_ | *(Optional)* |
| `immutableGatewayWorkloadIdentity` _string_ | *(Optional)* |
| `immutableGatewayContainerRegistryPath` _string_ | *(Optional)* |
| `kanikoJobImage` _string_ | *(Optional)* |
| `envoyGatewayContractPollInterval` _integer_ | *(Optional)* |


#### WorkloadResource

_Underlying type:_ `string`

WorkloadResource defines workload resource types.

_Appears in:_
- [Component](#component)




## apigee.cloud.google.com/v1alpha2

Package v1alpha2 contains API Schema definitions for the apigee v1alpha2 API group

### Resource Types
- [ApigeeEnvironment](#apigeeenvironment)
- [ApigeeEnvironmentList](#apigeeenvironmentlist)
- [ApigeeOrganization](#apigeeorganization)
- [ApigeeOrganizationList](#apigeeorganizationlist)
- [ApigeeTelemetry](#apigeetelemetry)
- [ApigeeTelemetryList](#apigeetelemetrylist)



#### AccessLogsExport



AccessLogsExport stores configuration for access log exports to a Cloud Storage bucket.

_Appears in:_
- [ApigeeTelemetrySpec](#apigeetelemetryspec)

| Field | Description |
| --- | --- |
| `enabled` _boolean_ | *(Optional)* If true, turns on the access log export. |
| `gcsBucket` _string_ | *(Optional)* Specifies the Cloud Storage bucket where logs will be exported. |
| `frequency` _string_ | *(Optional)* Frequency of upload to Cloud Storage bucket. |


#### ApigeeEnvironment



ApigeeEnvironment represents the schema for the ApigeeEnvironments API.

_Appears in:_
- [ApigeeEnvironmentList](#apigeeenvironmentlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha2`
| `kind` _string_ | `ApigeeEnvironment`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[ApigeeEnvironmentSpec](#apigeeenvironmentspec)_ |  |
| `release` _[ApigeeEnvironmentRelease](#apigeeenvironmentrelease)_ |  |


#### ApigeeEnvironmentList



ApigeeEnvironmentList contains a list of ApigeeEnvironment objects.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha2`
| `kind` _string_ | `ApigeeEnvironmentList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[ApigeeEnvironment](#apigeeenvironment) array_ |  |


#### ApigeeEnvironmentRelease



ApigeeEnvironmentRelease stores information related to ApigeeEnvironment releases.

_Appears in:_
- [ApigeeEnvironment](#apigeeenvironment)

| Field | Description |
| --- | --- |
| `forceUpdate` _boolean_ | *(Optional)* If true, ApigeeEnvironment is forcefully updated by bypassing the webhook validations. It is used to apply changes that are necessary to handle rollback. This flag is automatically set to false after the update is applied. |
| `expediteRelease` _boolean_ | *(Optional)* If true, the update is expedited by bypassing the canary stages. This flag is automatically set to false after AE is successfully reconciled. |


#### ApigeeEnvironmentSpec



ApigeeEnvironmentSpec defines the desired state of an ApigeeEnvironment object.

_Appears in:_
- [ApigeeEnvironment](#apigeeenvironment)

| Field | Description |
| --- | --- |
| `name` _string_ | Name of the Apigee Environment. |
| `version` _string_ | Version of the Apigee Environment object. |
| `gatewayType` _GatewayType_ | Determines the runtime type of the environment. For example, Envoy or Message Processor. |
| `organizationRef` _string_ | The organization under which this environment belongs. |
| `components` _[EnvComponents](#envcomponents)_ | *(Optional)* |
| `imagePullSecrets` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core) array_ | *(Optional)* A list of references referring to secrets in the same namespace that are used for pulling the images used by this PodSpec. If specified, these secrets will be passed to individual puller implementations to use. For example, For Docker, only DockerConfig type secrets are honored. For more information, see: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod |




#### ApigeeMonetizationAddon



ApigeeMonetizationAddon stores information related to the ApigeeMonetization add-on feature.

_Appears in:_
- [ApigeeOrganizationSpec](#apigeeorganizationspec)

| Field | Description |
| --- | --- |
| `enabled` _boolean_ | *(Optional)* If true, installs monetization related components in the cluster to start with orgScopedUDCA and cronJob. Apigee-watcher can update this value to trigger changes when monetization add-on value changes. |


#### ApigeeOrganization



ApigeeOrganization is the schema for the ApigeeOrganization APIs.

_Appears in:_
- [ApigeeOrganizationList](#apigeeorganizationlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha2`
| `kind` _string_ | `ApigeeOrganization`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[ApigeeOrganizationSpec](#apigeeorganizationspec)_ |  |
| `release` _[ApigeeOrganizationRelease](#apigeeorganizationrelease)_ |  |


#### ApigeeOrganizationList



ApigeeOrganizationList contains a list of ApigeeOrganization objects.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha2`
| `kind` _string_ | `ApigeeOrganizationList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[ApigeeOrganization](#apigeeorganization) array_ |  |


#### ApigeeOrganizationRelease



ApigeeOrganizationRelease stores information related to ApigeeOrganization releases.

_Appears in:_
- [ApigeeOrganization](#apigeeorganization)

| Field | Description |
| --- | --- |
| `forceUpdate` _boolean_ | *(Optional)* If true, ApigeeOrganization is forcefully updated by bypassing the webhook validations. It is used to apply changes that are necessary to handle rollback. This flag is automatically set to false after the update is applied. |


#### ApigeeOrganizationSpec



ApigeeOrganizationSpec defines the desired state of an ApigeeOrganization object.

_Appears in:_
- [ApigeeOrganization](#apigeeorganization)

| Field | Description |
| --- | --- |
| `name` _string_ | Name of the Apigee Organization. |
| `version` _string_ | Version of the Apigee Organization. |
| `datastoreRef` _string_ | A required reference of the Apigee datastore object. |
| `datastoreCredentialRef` _string_ | Specifies the secret object for loading the Cassandra credentials that are configured for use with the cluster. |
| `redisRef` _string_ | A required reference of the Apigee Redis object. |
| `apigeeEndpoint` _string_ | The control plane URL. |
| `apigeeConnectEndpoint` _string_ | The Apigee Connect server URL. |
| `gcpProjectID` _string_ | The Google Cloud project ID associated with the Apigee instance. This is used when obtaining Apigee Connect connections. |
| `instanceID` _string_ | ID of the Apigee instance. This is used when reporting status to the management plane. |
| `clusterName` _string_ | The k8s cluster name. |
| `clusterRegion` _string_ | The region for the k8s cluster. |
| `dataEncryptionRef` _string_ | Specifies the secret object used for encrypting application data. |
| `axHashingSaltRef` _string_ | Specifies the secret object used for obfuscating analytics data. |
| `databaseTenantID` _string_ | TenantID for Cassandra. This is primarily used for migrating data over from Edge or CGSaaS. |
| `components` _[OrgComponents](#orgcomponents)_ | *(Optional)* |
| `httpForwardProxy` _HTTPForwardProxy_ | (*Optional)* Specifies the HTTP forward proxy details. |
| `enabledCassandraSchemaSetup` _boolean_ | Enabled by default. |
| `imagePullSecrets` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core) array_ | *(Optional)* A list of references referring to secrets in the same namespace that are used for pulling the images used by this PodSpec. If specified, these secrets will be passed to individual puller implementations to use. For example, For Docker, only DockerConfig type secrets are honored. For more information, see: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod |
| `apigeeMonetizationAddon` _[ApigeeMonetizationAddon](#apigeemonetizationaddon)_ | Indicates if Monetization feature is enabled or not for the organization. |
| `udcaEnabled` _boolean_ | If true, enables org-scoped UDCA deployment rather than one-udca-per-environment model. |




#### ApigeeTelemetry



ApigeeTelemetry is the schema for the ApigeeTelemetry APIs.

_Appears in:_
- [ApigeeTelemetryList](#apigeetelemetrylist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha2`
| `kind` _string_ | `ApigeeTelemetry`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[ApigeeTelemetrySpec](#apigeetelemetryspec)_ |  |
| `release` _[ApigeeTelemetryRelease](#apigeetelemetryrelease)_ |  |


#### ApigeeTelemetryList



ApigeeTelemetryList contains a list of ApigeeTelemetry objects.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha2`
| `kind` _string_ | `ApigeeTelemetryList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[ApigeeTelemetry](#apigeetelemetry) array_ |  |


#### ApigeeTelemetryRelease



ApigeeTelemetryRelease stores information related to ApigeeTelemetry releases.

_Appears in:_
- [ApigeeTelemetry](#apigeetelemetry)

| Field | Description |
| --- | --- |
| `forceUpdate` _boolean_ | *(Optional)* If true, ApigeeTelemetry is forcefully updated by bypassing the webhook validations. It is used to apply changes that are necessary to handle rollback. This flag is automatically set to false after the update is applied. |


#### ApigeeTelemetrySpec



ApigeeTelemetrySpec defines the desired state of an ApigeeTelemetry object.

_Appears in:_
- [ApigeeTelemetry](#apigeetelemetry)

| Field | Description |
| --- | --- |
| `version` _string_ | Version of the Apigee Telemetry. |
| `instanceID` _string_ | ID of the Apigee instance. This is used as a label when reporting metrics back to the management plane. |
| `clusterName` _string_ | The k8s cluster name. |
| `clusterRegion` _string_ | The region for the k8s cluster. |
| `gcpProjectID` _string_ | *(Optional)* The Google Cloud project ID associated with the Apigee instance. This is used in cloud-only deployments when uploading access logs to identify where the logs originated. |
| `components` _[TelemetryComponents](#telemetrycomponents)_ | *(Optional)* Stores configuration overrides for telemetry components. |
| `metricsExport` _[MetricsExport](#metricsexport)_ | Stores configurations for metrics collection and export. |
| `containerLogsExport` _[ContainerLogsExport](#containerlogsexport)_ | Stores configuration for exporting all Apigee access logs to Stackdriver. Note that this is supported for Hybrid runtime types only. |
| `containerOSLogsExport` _[ContainerOSLogsExport](#containeroslogsexport)_ | Stores configuration for exporting node level logs to Stackdriver. |
| `accessLogsExport` _[AccessLogsExport](#accesslogsexport)_ | Stores configuration for exporting only HTTP access logs to a Cloud Storage bucket. Note that this is supported for Cloud runtime types only. |
| `httpForwardProxy` _[HTTPForwardProxy](#httpforwardproxy)_ | *(Optional)* Specifies the HTTP forward proxy details. |
| `imagePullSecrets` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core) array_ | *(Optional)* A list of references referring to secrets in the same namespace that are used for pulling the images used by this PodSpec. If specified, these secrets will be passed to individual puller implementations to use. For example, For Docker, only DockerConfig type secrets are honored. For more information, see: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod |
| `prioritizeTelemetryDaemons` _boolean_ | *(Optional)* If true, assigns elevated priorities to telemetry daemonset pods. False by default. |




#### ContainerLogsExport



ContainerLogsExport stores configurations for all container log exports to Stackdriver.

_Appears in:_
- [ApigeeTelemetrySpec](#apigeetelemetryspec)

| Field | Description |
| --- | --- |
| `enabled` _boolean_ | *(Optional)* If true, turns on the container log export. |
| `projectID` _string_ | *(Optional)* The project ID where logs are exported. |


#### ContainerOSLogsExport



ContainerOSLogsExport stores configurations for node log exports to Stackdriver.

_Appears in:_
- [ApigeeTelemetrySpec](#apigeetelemetryspec)

| Field | Description |
| --- | --- |
| `enabled` _boolean_ | *(Optional)* If true, turns on the container OS log export. |


#### EnvComponentStatus



EnvComponentStatus stores the status of components that are managed by the Apigee Environment controller.

_Appears in:_
- [ApigeeEnvironmentStatus](#apigeeenvironmentstatus)

| Field | Description |
| --- | --- |
| `runtime` _[ComponentStatus](#componentstatus)_ | The release status of Message Processor. |
| `udca` _[ComponentStatus](#componentstatus)_ | The release status of UDCA. |
| `synchronizer` _[ComponentStatus](#componentstatus)_ | The release status of Synchronizer. |
| `envoyGateway` _[ComponentStatus](#componentstatus)_ | The status of Envoy Gateway. |
| `envoyAdapter` _[ComponentStatus](#componentstatus)_ | The status of Envoy Adapter. |


#### EnvComponents



EnvComponents represents the env level components.

_Appears in:_
- [ApigeeEnvironmentSpec](#apigeeenvironmentspec)

| Field | Description |
| --- | --- |
| `runtime` _[Component](#component)_  |  |
| `synchronizer` _[Component](#component)_ |  |
| `udca` _[Component](#component)_ |  |
| `envoyGateway` _[Component](#component)_ |  |
| `envoyAdapter` _[Component](#component)_ |  |




#### MetricsExport



MetricsExport stores configurations for metrics collection and export.

_Appears in:_
- [ApigeeTelemetrySpec](#apigeetelemetryspec)

| Field | Description |
| --- | --- |
| `enabled` _boolean_ | *(Optional)* If true, turns on metrics component. |
| `defaultMetricsProjectID` _string_ | *(Optional)* The project ID where both proxy and app metrics will be exported. |
| `appMetricsProjectID` _string_ | *(Optional)* Overrides AppMetricsProjectID for app metrics. |
| `proxyMetricsProjectID` _string_ | *(Optional)* Overrides ProxyMetricsProjectID for proxy metrics. |
| `stackdriverAPIEndpoint` _string_ | *(Optional)* Overrides the API endpoint value used when writing metrics. |


#### OrgComponentStatus



OrgComponentStatus stores the release status of components managed by the Apigee Organization controller.

_Appears in:_
- [ApigeeOrganizationStatus](#apigeeorganizationstatus)

| Field | Description |
| --- | --- |
| `mart` _[ComponentStatus](#componentstatus)_ | The release status of MART (Management API For Runtime Plane). |
| `connectAgent` _[ComponentStatus](#componentstatus)_ | The release status of ConnectAgent. |
| `udca` _[ComponentStatus](#componentstatus)_ | The release status of UDCA. |
| `watcher` _[ComponentStatus](#componentstatus)_ | The release status of Watcher. |
| `primaryImporter` _[ComponentStatus](#componentstatus)_ | The migration status from PrimaryImporter. |
| `deltaHandler` _[ComponentStatus](#componentstatus)_ | The migration status from DeltaHandler. |
| `ingressGateways` _object (keys:string, values:[ComponentStatus](#componentstatus))_ | The release status for Ingress Gateway deployments. |
| `runtimeProxy` _[ComponentStatus](#componentstatus)_ | The release status of RuntimeProxy. |


#### OrgComponents



OrgComponents represents the organization level components.

_Appears in:_
- [ApigeeOrganizationSpec](#apigeeorganizationspec)

| Field | Description |
| --- | --- |
| `cassandraUserSetup` _[Component](#component)_ | Provides Component details for configuring Cassandra datastore users. |
| `cassandraSchemaSetup` _[Component](#component)_ | Provides Component details for configuring Cassandra datastore schema. |
| `mart` _[Component](#component)_ |  |
| `connectAgent` _[Component](#component)_ |  |
| `udca` _[Component](#component)_ |  |
| `watcher` _[Component](#component)_ |  |
| `primaryImporter` _[Component](#component)_ |  |
| `deltaHandler` _[Component](#component)_ |  |
| `mintTaskScheduler` _[Component](#component)_ |  |
| `ingressGateways` _[Component](#component)_ |  |
| `runtimeProxy` _[Component](#component)_ |  |




#### RouteRule



RouteRule defines the traffic split weight for a version.

_Appears in:_
- [Route](#route)

| Field | Description |
| --- | --- |
| `version` _string_ | Version of the deployment. |
| `weight` _integer_ | Weight of traffic split. |


#### TelemetryComponentStatus



TelemetryComponentStatus stores the release status of components managed by the Apigee Telemetry controller.

_Appears in:_
- [ApigeeTelemetryStatus](#apigeetelemetrystatus)

| Field | Description |
| --- | --- |
| `applicationMetrics` _[ComponentStatus](#componentstatus)_ | Represents the release status of Application Metrics (if enabled). |
| `proxyMetrics` _[ComponentStatus](#componentstatus)_ | Represents the release status of Proxy Metrics (if enabled). |
| `adapterMetrics` _[ComponentStatus](#componentstatus)_ | Represents the release status of MetricsAdapter component (if enabled). |
| `accessLogs` _[ComponentStatus](#componentstatus)_ | Represents the release status of AccessLogs component (if enabled). |
| `containerLogs` _[ComponentStatus](#componentstatus)_ | Represents the release status of ContainerLogs component (if enabled). |
| `containerOSLogs` _[ComponentStatus](#componentstatus)_ | Represents the release status of ContainerOSLogs component (if enabled). |


#### TelemetryComponents



TelemetryComponents represents the telemetry level components.

_Appears in:_
- [ApigeeTelemetrySpec](#apigeetelemetryspec)

| Field | Description |
| --- | --- |
| `metricsApp` _[Component](#component)_ |  |
| `metricsProxy` _[Component](#component)_ |  |
| `metricsAdapter` _[Component](#component)_ |  |
| `accessLogs` _[Component](#component)_ |  |
| `containerLogs` _[Component](#component)_ |  |
| `containerOSLogs` _[Component](#component)_ |  |



## apigee.cloud.google.com/v1beta1

Package v1beta1 holds versioned core types that are used across different
versions of Apigee CRDs.



#### ConnectionPool



ConnectionPool represents the settings controlling the volume of connections to an upstream service.

_Appears in:_
- [PortTrafficPolicy](#porttrafficpolicy)
- [TrafficPolicy](#trafficpolicy)

| Field | Description |
| --- | --- |
| `http` _[HTTPSettings](#httpsettings)_ | Http connection pool settings. |
| `tcp` _[TCPSettings](#tcpsettings)_ | The connection pool settings common to both HTTP and TCP upstream connections. |


#### HTTPSettings



HTTPSettings represents the Http connection pool settings.

_Appears in:_
- [ConnectionPool](#connectionpool)

| Field | Description |
| --- | --- |
| `http1MaxPendingRequests` _integer_ | *(Default value: 2^32-1)* The maximum number of pending HTTP requests to a destination. |
| `http2MaxRequests` _integer_ | *(Default value: 2^32-1)* The maximum number of HTTP requests to a backend. |
| `maxRequestsPerConnection` _integer_ | *(Default value: 0)* The maximum number of HTTP requests per connection to a backend. Setting this parameter to 1 disables Keep-Alive. |
| `maxRetries` _integer_ | *(Default value: 2^32-1)* The maximum number of retries that can be outstanding to all hosts in a cluster at a given time. |
| `idleTimeout` _[Duration](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#duration-v1-meta)_ | The timeout period for upstream connection pool connections. Note that for request based timeouts, the HTTP/2 PINGs will not keep the connections alive. Applies to both HTTP1.1 and HTTP2 connections. |
| `h2UpgradePolicy` _string_ | Specifies if http1.1 connections should be upgraded to http2 for the associated destinations. |


#### HorizontalPodAutoscalerSpec



HorizontalPodAutoscalerSpec automatically scales the number of pods in a replica set based on the observed CPU utilization. For more information, see: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale

_Appears in:_
- [Component](#component)

| Field | Description |
| --- | --- |
| `minReplicas` _integer_ | *(Default value: 1)* The minimum number of replicas to which the autoscaler can scale down. |
| `maxReplicas` _integer_ | The maximum number of replicas to which the autoscaler can scale up. Note that this value cannot be lower than MinReplicas. |
| `metrics` _[MetricSpec](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#metricspec-v2beta2-autoscaling) array_ | The specifications that are used to calculate the desired replica count Metrics used must decrease as the pod count is increased, and vice-versa.  See the individual metric source types for more information about how each type of metric must respond. If not set, the default metric will be set to 80 percent average CPU utilization. |
| `behavior` _[HorizontalPodAutoscalerBehavior](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#horizontalpodautoscalerbehavior-v2beta2-autoscaling)_ | *(Optional)* The scaling behavior of a target for both Up and Down directions (scaleUp and scaleDown). If not set, the default HPAScalingRules for scale up and scale down are used. |


#### PortSelectorNumber



PortSelectorNumber represents the number used to identify a port.

_Appears in:_
- [PortTrafficPolicy](#porttrafficpolicy)

| Field | Description |
| --- | --- |
| `number` _integer_ | The port number. |


#### PortTrafficPolicy



PortTrafficPolicy represents the traffic policy specific to individual ports.

_Appears in:_
- [TrafficPolicy](#trafficpolicy)

| Field | Description |
| --- | --- |
| `port` _[PortSelectorNumber](#portselectornumber)_ | The destination service port number on which this policy is applied. |
| `tls` _[TLSSettings](#tlssettings)_ | TLS related settings for connections to the upstream service. |
| `connectionPool` _[ConnectionPool](#connectionpool)_ | The settings controlling the volume of connections to an upstream service. |




#### TCPSettings



TCPSettings represents the connection pool settings common to both HTTP and TCP upstream connections.

_Appears in:_
- [ConnectionPool](#connectionpool)

| Field | Description |
| --- | --- |
| `maxConnections` _integer_ | *(Default value: 2^32-1)* The maximum number of HTTP1 or TCP connections to a destination host. |
| `connectTimeout` _[Duration](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#duration-v1-meta)_ | TCP connection timeout. |
| `tcpKeepalive` _[TCPKeepalive](#tcpkeepalive)_ | Sets SO_KEEPALIVE on the socket to enable TCP Keep-Alives. |


#### TLSSettings



TLSSettings represents the TLS related settings for connections to the upstream service.

_Appears in:_
- [PortTrafficPolicy](#porttrafficpolicy)
- [TrafficPolicy](#trafficpolicy)

| Field | Description |
| --- | --- |
| `mode` _string_ | Determines how TLS is enforced. |
| `clientCertificate` _string_ | The file path containing the client-side TLS certificate. This field is required if the mode is set to `MUTUAL`. It must be empty if the mode is set to `ISTIO_MUTUAL`. |
| `privateKey` _string_ | The file path containing the client private key. This field is required if the mode is set to `MUTUAL`. It must be empty if the mode is set to `ISTIO_MUTUAL`. |
| `caCertificates` _string_ | The file path containing Certificate Authority (CA) certificates for verifying a presented server certificate. This field is required to allow the proxy to verify the server certificate. It must be empty if the mode is set to `ISTIO_MUTUAL`. |
| `subjectAltNames` _string array_ | A list of alternate names to verify the subject identity in the certificate. If specified, this list overrides the value of subject_alt_names from ServiceEntry. |
| `sni` _string_ | Presented to the server during the TLS handshake. |


#### TrafficPolicy



TrafficPolicy defines the Istio traffic policy. For more information, see: https://istio.io/docs/reference/config/networking/v1alpha3/destination-rule/#TrafficPolicy

_Appears in:_
- [Component](#component)

| Field | Description |
| --- | --- |
| `tls` _[TLSSettings](#tlssettings)_ | TLS related settings for connections to the upstream service. |
| `portLevelSettings` _[PortTrafficPolicy](#porttrafficpolicy) array_ | The traffic policies specific to individual ports. |
| `connectionPool` _[ConnectionPool](#connectionpool)_ | The connection pool settings for an upstream host. |

## Default Value Tables

<h3> <a href="#envcomponents">EnvComponent</a>: runtime</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-runtime-svc-account-${ORGANIZATION_NAME}-${ENVIRONMENT_NAME}"
</pre>
</td>
</tr>
<tr>
<td> <code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em> </td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
          weight: 100
</pre>
</td>
</tr>
<tr>
<td> <code>autoScaler</code> <em>HorizontalPodAutoscalerSpec</em> </td>
<td>
<pre>
        minReplicas: 1
        maxReplicas: 1
        behavior:
          scaleDown:
            policies:
            - periodSeconds: 60
              type: Percent
              value: 20
            - periodSeconds: 60
              type: Pods
              value: 2
            selectPolicy: Min
            stabilizationWindowSeconds: 120
          scaleUp:
            policies:
            - periodSeconds: 60
              type: Percent
              value: 20
            - periodSeconds: 60
              type: Pods
              value: 4
            selectPolicy: Max
            stabilizationWindowSeconds: 30
        metrics:
        - type: Pods
          pods:
            metric:
              name: server_main_task_wait_time
            target:
              averageValue:  400M
              type: AverageValue
        - type: Pods
          pods:
            metric:
              name: server_nio_task_wait_time
            target:
              averageValue: 400M
              type: AverageValue
        - type: Resource
          resource:
            name: cpu
            target:
              type: "Utilization"
              averageUtilization: 75
</pre>
</td>
</tr>
<tr>
<td><code>initContainers</code> <em><a href="#container">Container</a> array</em></td>
<td>
<pre>
      - name: "apigee-cassandra-schema-readiness"
        imagePullPolicy: "IfNotPresent"
      - name: "apigee-redis-envoy-readiness"
        imagePullPolicy: "IfNotPresent"
</pre>
</td>
</tr>
<tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: apigee-runtime
        imagePullPolicy: "IfNotPresent"
        env:
        - name: "${ORGANIZATION_NAME_UPPER}_KMS_ENCRYPTION_KEY"
          valueFrom:
            secretKeyRef:
              name: "env-encryption-keys"
              key: kmsEncryptionKey
        - name: "${ORGANIZATION_NAME_UPPER}_TEST_CACHE_ENCRYPTION_KEY"
          valueFrom:
            secretKeyRef:
              name: "env-encryption-keys"
              key: cacheEncryptionKey
        - name: "${ORGANIZATION_NAME_UPPER}_TEST_KVM_ENCRYPTION_KEY"
          valueFrom:
            secretKeyRef:
              name: "env-encryption-keys"
              key: envKvmEncryptionKey
        - name: "${ORGANIZATION_NAME_UPPER}_KVM_ENCRYPTION_KEY"
          valueFrom:
            secretKeyRef:
              name: "env-encryption-keys"
              key: kvmEncryptionKey
        livenessProbe:
          httpGet:
            path: "/v1/probes/live"
            scheme: HTTPS
            port: 8843
          initialDelaySeconds: 15
          periodSeconds: 10
          timeoutSeconds: 30
          successThreshold: 1
          failureThreshold: 6
        readinessProbe:
          httpGet:
            path: /v1/probes/ready
            scheme: HTTPS
            port: 8843
          initialDelaySeconds: 15
          periodSeconds: 10
          timeoutSeconds: 30
          successThreshold: 1
          failureThreshold: 2
        resources:
          requests:
            cpu: 500m
            memory: 1Gi
</pre>
</td>
</tr>
</tbody>
</table>

<h3><a href="#envcomponents">EnvComponent</a>: synchronizer</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-synchronizer-svc-account-${ORGANIZATION_NAME}-${ENVIRONMENT_NAME}"
</pre>
</td>
</tr>
<tr>
<td><code>securityContext</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#securitycontext-v1-core">SecurityContext</a></em></td>
<td>
<pre>
        runAsNonRoot: true
        runAsUser: 999
        runAsGroup: 998
        privileged: false
</pre>
</td>
</tr>
<tr>
<td> <code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em> </td>
<td>
<pre>
        - preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
          weight: 100
</pre>
</td>
</tr>
<tr>
<td> <code>autoScaler</code> <em>HorizontalPodAutoscalerSpec</em> </td>
<td>
<pre>
        minReplicas: 1
        maxReplicas: 1
        metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: "Utilization"
              averageUtilization: 75
</pre>
</td>
</tr>
<tr>
<td><code>initContainers</code> <em><a href="#container">Container</a> array</em></td>
<td>
<pre>
      - name: apigee-cassandra-schema-readiness
        imagePullPolicy: "IfNotPresent"
</pre>
</td>
</tr>
<tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-synchronizer"
        imagePullPolicy: "IfNotPresent"
        livenessProbe:
          httpGet:
            path: /v1/probes/live
            scheme: HTTPS
            port: 8843
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 12
        readinessProbe:
          httpGet:
            path: /v1/probes/ready
            scheme: HTTPS
            port: 8843
          initialDelaySeconds: 0
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 2
        resources:
          requests:
            cpu: 100m
            memory: 512Mi
</pre>
</td>
</tr>
</tbody>
</table>

<h3> <a href="#envcomponents">EnvComponent</a>: udca</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-udca-svc-account-${ORGANIZATION_NAME}-${ENVIRONMENT_NAME}"
</pre>
</td>
</tr>
<tr>
<td><code>securityContext</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#securitycontext-v1-core">SecurityContext</a></em></td>
<td>
<pre>
        runAsNonRoot: true
        runAsUser: 999
        runAsGroup: 998
        privileged: false
</pre>
</td>
</tr>
<tr>
<td> <code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em> </td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
          weight: 100
</pre>
</td>
</tr>
<tr>
<td> <code>autoScaler</code> <em>HorizontalPodAutoscalerSpec</em> </td>
<td>
<pre>
        minReplicas: 1
        maxReplicas: 1
        metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: "Utilization"
              averageUtilization: 75
</pre>
</td>
</tr>
<tr>
<td><code>initContainers</code> <em><a href="#container">Container</a> array</em></td>
<td>
<pre>
      - name: "apigee-tls-readiness"
        imagePullPolicy: "IfNotPresent"
</pre>
</td>
</tr>
<tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-udca"
        imagePullPolicy: "IfNotPresent"
        livenessProbe:
          httpGet:
            path: /v1/probes/live
            port: 7070
            scheme: HTTPS
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 12
        resources:
          requests:
            cpu: 500m
            memory: 1Gi
      - name: "apigee-fluentd"
        imagePullPolicy: "IfNotPresent"
        resources:
          limits:
            memory: 512Mi
          requests:
            cpu: 500m
            memory: 250Mi
</pre>
</td>
</tr>
</tbody>
</table>
<h3 ><a href="#orgcomponents">OrgComponent</a>: cassandraUserSetup</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
            <td><code>securityContext</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#securitycontext-v1-core">SecurityContext</a></em></td>
<td>
<pre>
        runAsNonRoot: true
        runAsUser: 999
        runAsGroup: 998
        privileged: false
</pre>
</td>
</tr>
<tr>
            <td><code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em></td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
          weight: 100
</pre>
</td>
</tr>
<tr>
            <td><code>initContainers</code> <em><a href="#container">Container</a> array</em></td>
<td>
<pre>
      - name: "apigee-cassandra-readiness"
        imagePullPolicy: "IfNotPresent"
</pre>            
</td>
</tr>
<tr>
            <td><code>containers</code> <em><a href="#container">Container</a> array</em></td>
<td>
<pre>
      - name: "apigee-cassandra-user-setup"
        imagePullPolicy: "IfNotPresent"
</pre>            
</td>
</tr>
</tbody>
</table>

<h3> <a href="#orgcomponents">OrgComponent</a>: cassandraSchemaSetup</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
            <td><code>securityContext</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#securitycontext-v1-core">SecurityContext</a></em></td>
<td>
<pre>
      securityContext:
        runAsNonRoot: true
        runAsUser: 999
        runAsGroup: 998
        privileged: false
</pre>
</td>
</tr>
<tr>
            <td><code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em></td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
          weight: 100
</pre>
</td>
</tr>
<tr>
            <td><code>initContainers</code> <em><a href="#container">Container</a> array</em></td>
<td>
<pre>
      - name: "apigee-cassandra-user-readiness"
        imagePullPolicy: "IfNotPresent"
</pre>            
</td>
</tr>
<tr>
            <td><code>containers</code> <em><a href="#container">Container</a> array</em></td>
<td>
<pre>
      - name: "apigee-cassandra-schema-setup"
        imagePullPolicy: "IfNotPresent"
</pre>            
</td>
</tr>
</tbody>
</table>

<h3> <a href="#orgcomponents">OrgComponent</a>: mart</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-mart-svc-account-${ORGANIZATION_NAME}"
</pre>
</td>
</tr>
  <tr>
            <td><code>securityContext</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#securitycontext-v1-core">SecurityContext</a></em></td>
<td>
<pre>
        runAsNonRoot: true
        runAsUser: 999
        runAsGroup: 998
        privileged: false
</pre>
</td>
</tr>
<tr>
<td> <code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em> </td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
          weight: 100
</pre>            
</td>
</tr>
<tr>
<td> <code>autoScaler</code> <em>HorizontalPodAutoscalerSpec</em> </td>
<td>
<pre>
        minReplicas: 1
        maxReplicas: 1
        metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: "Utilization"
              averageUtilization: 75
</pre>           
</td>
</tr>
  <tr>
<td> <code>initContainers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-cassandra-schema-readiness"
        imagePullPolicy: "IfNotPresent"
</pre>
</td>
</tr>
<tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-mart"
        imagePullPolicy: "IfNotPresent"
        livenessProbe:
          httpGet:
            path: /v1/probes/live
            scheme: HTTPS
            port: 8843
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 12
        readinessProbe:
          httpGet:
            path: /v1/probes/ready
            scheme: HTTPS
            port: 8843
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 2
        resources:
          requests:
            cpu: 500m
            memory: 512Mi
        env:
        - name: "${ORGANIZATION_NAME_UPPER}_KMS_ENCRYPTION_KEY"
          valueFrom:
            secretKeyRef:
              name: "org-encryption-keys"
              key: kmsEncryptionKey
</pre>            
</td>
</tr>
</tbody>
</table>

<h3> <a href="#orgcomponents">OrgComponent</a>: connectAgent</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-connect-agent-svc-account-${ORGANIZATION_NAME}"
</pre>
</td>
</tr>
<td> <code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em> </td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
          weight: 100
</pre>            
</td>
<tr>
<td> <code>autoScaler</code> <em>HorizontalPodAutoscalerSpec</em> </td>
<td>
<pre>
        minReplicas: 1
        maxReplicas: 1
        metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: "Utilization"
              averageUtilization: 75
</pre>           
</td>
</tr>
<tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-connect-agent"
        imagePullPolicy: "IfNotPresent"
        resources:
          requests:
            cpu: 200m
            memory: 128Mi
        env:
        - name: GRPC_GO_LOG_SEVERITY_LEVEL
          value: "ERROR"
        - name: LOG_VERBOSITY_LEVEL
          value: "0"
</pre>            
</td>
</tr>
<tr>
</tbody>
</table>


<h3> <a href="#orgcomponents">OrgComponent</a>: udca</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-udca-svc-account-${ORGANIZATION_NAME}"
</pre>
</td>
</tr>
  <tr>
            <td><code>securityContext</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#securitycontext-v1-core">SecurityContext</a></em></td>
<td>
<pre>
        runAsNonRoot: true
        runAsUser: 999
        runAsGroup: 998
        privileged: false
</pre>
</td>
</tr>
<tr>
<td> <code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em> </td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
          weight: 100
</pre>            
</td>
</tr>
<tr>
<td> <code>autoScaler</code> <em>HorizontalPodAutoscalerSpec</em> </td>
<td>
<pre>
        minReplicas: 1
        maxReplicas: 1
        metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: "Utilization"
              averageUtilization: 75
</pre>           
</td>
</tr>
  <tr>
<td> <code>initContainers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-tls-readiness"
        imagePullPolicy: "IfNotPresent"
</pre>
</td>
</tr>
<tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-udca"
        imagePullPolicy: "IfNotPresent"
        livenessProbe:
          httpGet:
            path: /v1/probes/live
            port: 7070
            scheme: HTTPS
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 12
        resources:
          requests:
            cpu: 500m
            memory: 1Gi
      - name: "apigee-fluentd"
        imagePullPolicy: "IfNotPresent"
        resources:
          requests:
            cpu: 500m
            memory: 250Mi
          limits:
            memory: 512Mi
</pre>            
</td>
</tr>
</tbody>
</table>

<h3> <a href="#orgcomponents">OrgComponent</a>: watcher</h3>

<p>Description</p>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-watcher-svc-account-${ORGANIZATION_NAME}"
</pre>
</td>
</tr>
<tr>
<td> <code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em> </td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
          weight: 100
</pre>            
</td>
</tr>
<tr>
<td> <code>autoScaler</code> <em>HorizontalPodAutoscalerSpec</em> </td>
<td>
<pre>
        minReplicas: 1
        maxReplicas: 1
</pre>           
</td>
</tr>
  <tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-watcher"
        imagePullPolicy: "IfNotPresent"
        resources:
          requests:
            cpu: 200m
            memory: 128Mi
</pre>            
</td>
</tr>
</tbody>
</table>

<h3> <a href="#telemetrycomponents">TelemetryComponent</a>: metricsApp</h3>


<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-metrics-svc-account"
</pre>
</td>
</tr>
<tr>
<td> <code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em> </td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
          weight: 100
</pre>            
</td>
</tr>
<tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-prometheus-app"
        imagePullPolicy: "IfNotPresent"
        readinessProbe:
          httpGet:
            path: /-/ready
            port: 9090
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 120
        livenessProbe:
          httpGet:
            path: /-/healthy
            port: 9090
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 6
      - name: "apigee-stackdriver-exporter"
        image: "gcr.io/apigee-release/hybrid/apigee-stackdriver-prometheus-sidecar:0.9.0"
        imagePullPolicy: "IfNotPresent"
        resources:
          limits:
            cpu: 500m
            memory: 1Gi
          requests:
            cpu: 128m
            memory: 512Mi
</pre>            
</td>
</tr>
</tbody>
</table>

<h3> <a href="#telemetrycomponents">TelemetryComponent</a>: metricsProxy</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-metrics-svc-account"
</pre>
</td>
</tr>
<tr>
<td> <code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em> </td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
</pre>            
</td>
</tr>
<tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-stackdriver-exporter"
        imagePullPolicy: "IfNotPresent"
        resources:
          limits:
            cpu: 500m
            memory: 1Gi
          requests:
            cpu: 128m
            memory: 512Mi
      - name: "apigee-prometheus-proxy"
        imagePullPolicy: "IfNotPresent"
      - name: "apigee-prometheus-agg"
        imagePullPolicy: "IfNotPresent"
</pre>            
</td>
</tr>
</tbody>
</table>

<h3> <a href="#telemetrycomponents">TelemetryComponent</a>: metricsAdapter</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-metrics-svc-account"
</pre>
</td>
</tr>
<tr>
<td> <code>nodeAffinity</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core">NodeAffinity</a></em> </td>
<td>
<pre>
        preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          preference:
            matchExpressions:
            - key: cloud.google.com/gke-nodepool
              operator: In
              values:
              - apigee-runtime
</pre>            
</td>
</tr>
<tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-prometheus-adapter"
        imagePullPolicy: "IfNotPresent"
        readinessProbe:
          httpGet:
            path: /healthz
            port: 6443
            scheme: HTTPS
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 10
        livenessProbe:
          httpGet:
            path: /healthz
            port: 6443
            scheme: HTTPS
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 5
</pre>            
</td>
</tr>
</tbody>
</table>

<h3> <a href="#telemetrycomponents">TelemetryComponent</a>: containerLogs</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td> <code>appServiceAccountSecretName</code> <em>string</em> </td>
<td>
<pre>
"apigee-logger-svc-account"
</pre>
</td>
</tr>
<tr>
<td><code>version</code> <em>string</em></td><td>
<pre>
"170rc1"
</pre>            
</td>
</tr>
<tr>
<td> <code>containers</code> <em><a href="#container">Container</a> array</em> </td>
<td>
<pre>
      - name: "apigee-logger"
        image: "gcr.io/apigee-release/hybrid/apigee-fluent-bit:1.8.10"
        imagePullPolicy: IfNotPresent
        resources:
          limits:
            cpu: 200m
            memory: 500Mi
          requests:
            cpu: 100m
            memory: 250Mi
</pre>            
</td>
</tr>
</tbody>
</table>
