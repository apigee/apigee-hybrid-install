# API Reference

## Packages
- [apigee.cloud.google.com/v1](#apigeecloudgooglecomv1)
- [apigee.cloud.google.com/v1alpha1](#apigeecloudgooglecomv1alpha1)
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




#### ComponentRelease



ComponentRelease provides information on the release configuration overrides for a component.

_Appears in:_
- [Component](#component)
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
- [Component](#component)

| Field | Description |
| --- | --- |
| `containerSettings` _[ContainerSetting](#containersetting) array_ | Used for the container settings of a component. |


#### ComponentStatus



ComponentStatus provides information on the status of a controller component. For example, ApigeeRuntime is a component of ApigeeEnvironment.

_Appears in:_
- [DatastoreComponentStatus](#datastorecomponentstatus)
- [EnvComponentStatus](#envcomponentstatus)
- [OrgComponentStatus](#orgcomponentstatus)
- [RedisComponentStatus](#rediscomponentstatus)
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




#### KeySelector



KeySelector selects a key from either the config map key reference, or the secret key reference.

_Appears in:_
- [EnvSource](#envsource)



#### PersistentVolumeClaim



PersistentVolumeClaim defines a user request to claim a persistent volume.

_Appears in:_
- [Component](#component)
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
- [ApigeeDatastoreStatus](#apigeedatastorestatus)
- [ApigeeRedisStatus](#apigeeredisstatus)
- [ApigeeRouteStatus](#apigeeroutestatus)
- [CassandraDataReplicationDetails](#cassandradatareplicationdetails)
- [CassandraDataReplicationStatus](#cassandradatareplicationstatus)
- [ComponentStatus](#componentstatus)
- [RebuildDetails](#rebuilddetails)



#### Storage



Storage defines the override properties for the storage configuration.

_Appears in:_
- [Component](#component)
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
- [Component](#component)




## apigee.cloud.google.com/v1alpha1

Package v1alpha1 contains API Schema definitions for the apigee v1alpha1 API group

### Resource Types
- [ApigeeDatastore](#apigeedatastore)
- [ApigeeDatastoreList](#apigeedatastorelist)
- [ApigeeRedis](#apigeeredis)
- [ApigeeRedisList](#apigeeredislist)
- [ApigeeRoute](#apigeeroute)
- [ApigeeRouteConfig](#apigeerouteconfig)
- [ApigeeRouteConfigList](#apigeerouteconfiglist)
- [ApigeeRouteList](#apigeeroutelist)
- [CassandraDataReplication](#cassandradatareplication)
- [CassandraDataReplicationList](#cassandradatareplicationlist)





#### ApigeeDatastore



ApigeeDatastore represents the schema for apigeedatastores API.

_Appears in:_
- [ApigeeDatastoreList](#apigeedatastorelist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha1`
| `kind` _string_ | `ApigeeDatastore`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[ApigeeDatastoreSpec](#apigeedatastorespec)_ |  |
| `release` _[ApigeeDatastoreRelease](#apigeedatastorerelease)_ |  |


#### ApigeeDatastoreList



ApigeeDatastoreList represents a list of ApigeeDatastore objects.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha1`
| `kind` _string_ | `ApigeeDatastoreList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[ApigeeDatastore](#apigeedatastore) array_ |  |


#### ApigeeDatastoreRelease



ApigeeDatastoreRelease stores information related to the ApigeeDatastore release.

_Appears in:_
- [ApigeeDatastore](#apigeedatastore)

| Field | Description |
| --- | --- |
| `forceUpdateMultiRegionSeedHost` _boolean_ | *(Optional)* If true, will set to bypass multiRegionSeedHost validation in validating webhook; false, otherwise. |


#### ApigeeDatastoreSpec



ApigeeDatastoreSpec defines the desired state of an ApigeeDatastore object.

_Appears in:_
- [ApigeeDatastore](#apigeedatastore)

| Field | Description |
| --- | --- |
| `version` _string_ | Version of the Apigee Datastore. |
| `components` _[DatastoreComponents](#datastorecomponents)_ | *(Optional)* |
| `imagePullSecrets` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core) array_ | *(Optional)* A list of references referring to the namespace secrets that is used to pull images used by this PodSpec. If specified, these secrets will be passed to individual puller implementations to use. For example, in the case of Docker, only DockerConfig type secrets are honored. For more information, see: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod |
| `legacy` _boolean_ | Indicates support for on-prem hybrid Cassandra wherein the Cassandra resource names do not include the Datastore name prefix. |
| `replicas` _integer_ | *(Default value: 1 pod)* A replica for Cassandra statefulset. |
| `credentialRef` _string_ | Specifies the secret object for Cassandra credential. |
| `backupPolicy` _string_ | A Google Cloud Disk snapshot resource policy for taking backups. |
| `gcpProjectID` _string_ | The Google Cloud project ID associated with the Apigee instance. |
| `httpForwardProxy` _[HTTPForwardProxy](#httpforwardproxy)_ | *(Optional)* Specifies the HTTP forward proxy details. |
| `forceDelete` _boolean_ | *(Optional)* If true, forcibly deletes any Datastore CR. Note that this might lead to a non-graceful deletion of Cassandra. |






#### ApigeeRedis



ApigeeRedis represents the schema for the ApigeeRedis APIs.

_Appears in:_
- [ApigeeRedisList](#apigeeredislist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha1`
| `kind` _string_ | `ApigeeRedis`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[ApigeeRedisSpec](#apigeeredisspec)_ |  |
| `release` _[ApigeeRedisRelease](#apigeeredisrelease)_ |  |


#### ApigeeRedisList



ApigeeRedisList contains a list of ApigeeRedis objects.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha1`
| `kind` _string_ | `ApigeeRedisList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[ApigeeRedis](#apigeeredis) array_ |  |


#### ApigeeRedisRelease



ApigeeRedisRelease stores information related to ApigeeRedis releases.

_Appears in:_
- [ApigeeRedis](#apigeeredis)

| Field | Description |
| --- | --- |
| `forceUpdate` _boolean_ | *(Optional)* If true, ApigeeRedis is forcefully updated by bypassing the webhook validations. It is used to apply changes that are necessary to handle rollback. This flag is automatically set to false after the update is applied. |


#### ApigeeRedisSpec



ApigeeRedisSpec defines the desired state of an Apigee Redis object.

_Appears in:_
- [ApigeeRedis](#apigeeredis)

| Field | Description |
| --- | --- |
| `name` _string_ | Name of the Redis. |
| `version` _string_ | Version of the Apigee Redis object. |
| `credentialRef` _string_ | The secret object for Redis credential. |
| `components` _[RedisComponents](#rediscomponents)_ | *(Optional)* |
| `imagePullSecrets` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core) array_ | *(Optional)* A list of references referring to secrets in the same namespace that are used for pulling the images used by this PodSpec. If specified, these secrets will be passed to individual puller implementations to use. For example, For Docker, only DockerConfig type secrets are honored. For more information, see: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod |




#### ApigeeRoute



ApigeeRoute represents the schema for the apigeeroute APIs.

_Appears in:_
- [ApigeeRouteList](#apigeeroutelist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha1`
| `kind` _string_ | `ApigeeRoute`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[ApigeeRouteSpec](#apigeeroutespec)_ |  |


#### ApigeeRouteConfig



ApigeeRouteConfig represents the schema for ApigeeRouteConfig APIs.

_Appears in:_
- [ApigeeRouteConfigList](#apigeerouteconfiglist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha1`
| `kind` _string_ | `ApigeeRouteConfig`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[ApigeeRouteConfigSpec](#apigeerouteconfigspec)_ |  |


#### ApigeeRouteConfigList



ApigeeRouteConfigList contains a list of ApigeeRouteConfig objects.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha1`
| `kind` _string_ | `ApigeeRouteConfigList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[ApigeeRouteConfig](#apigeerouteconfig) array_ |  |


#### ApigeeRouteConfigSpec



ApigeeRouteConfigSpec defines the desired state of an ApigeeRouteConfig object.

_Appears in:_
- [ApigeeRouteConfig](#apigeerouteconfig)

| Field | Description |
| --- | --- |
| `selector` _object (keys:string, values:string)_ | *(Optional)* Defines labels of the Ingress k8s pod which run the Ingress config. |
| `enableNonSniClient` _boolean_ | *(Optional)* Determine if the "*" character should be included in the Istio Gateway. |
| `additionalGateways` _string array_ | Adds more gateways to the list of gateways in VirtualService. |
| `connectTimeout` _integer_ | *(Optional)* Indicates the connection timeout (in seconds). |
| `tls` _[TLS](#tls)_ |  |


#### ApigeeRouteList



ApigeeRouteList contains a list of ApigeeRoute objects.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha1`
| `kind` _string_ | `ApigeeRouteList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[ApigeeRoute](#apigeeroute) array_ |  |


#### ApigeeRouteSpec



ApigeeRouteSpec defines the desired state of an ApigeeRoute object.

_Appears in:_
- [ApigeeRoute](#apigeeroute)

| Field | Description |
| --- | --- |
| `hostnames` _string array_ | A list of hostnames. For example, api.foo.com. |
| `ports` _[Port](#port) array_ | A list of ports. |
| `selector` _object (keys:string, values:string)_ | Labels of the Ingress k8s pod that run the ingress config. |
| `rules` _[RoutePolicy](#routepolicy)_ | The configurations affecting the traffic routing between Ingress and the application. |
| `enableNonSniClient` _boolean_ | Determines if the "*" character is included in the Istio Gateway. |
| `additionalGateways` _string array_ | Adds more gateways to the list of gateways in VirtualService. |




#### CassandraDataReplication



CassandraDataReplication represents the schema for Cassandra expansion APIs.

_Appears in:_
- [CassandraDataReplicationList](#cassandradatareplicationlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha1`
| `kind` _string_ | `CassandraDataReplication`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[CassandraDataReplicationSpec](#cassandradatareplicationspec)_ |  |


#### CassandraDataReplicationDetails



CassandraDataReplicationDetails provides a detailed status of the Cassandra replication jobs.

_Appears in:_
- [ApigeeDatastoreStatus](#apigeedatastorestatus)

| Field | Description |
| --- | --- |
| `state` _State_ | Defines the state of a Data Replication object. For example, `running`, `complete`, `error`, and so on. This is a read-only field. |
| `updated` _integer_ | Last updated (epoch) time of this object. This is a read-only field. |
| `rebuildDetails` _object (keys:string, values:[RebuildDetails](#rebuilddetails))_ | Rebuild details for each cassandra nodes. A key in the map represents the node ID in Cassandra. This is a read-only field. |


#### CassandraDataReplicationList



CassandraDataReplicationList represents a list of CassandraDataReplication objects.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `apigee.cloud.google.com/v1alpha1`
| `kind` _string_ | `CassandraDataReplicationList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[CassandraDataReplication](#cassandradatareplication) array_ |  |


#### CassandraDataReplicationSpec



CassandraDataReplicationSpec defines the desired state of a CassandraDataReplication object.

_Appears in:_
- [CassandraDataReplication](#cassandradatareplication)

| Field | Description |
| --- | --- |
| `organizationRef` _string_ | Name of the organization. |
| `datastoreRef` _string_ | A required reference of the Apigee Datastore object. |
| `source` _[Source](#source)_ | The source object. |
| `force` _boolean_ | If true, runs the rebuild operation again regardless of any previously running rebuild; false, otherwise. |




#### CassandraScaling



CassandraScaling stores the final Cassandra state details when scaling is started or is in-progress.

_Appears in:_
- [ApigeeDatastoreStatus](#apigeedatastorestatus)

| Field | Description |
| --- | --- |
| `operation` _Scaling_ | Stores the operations that are currently in-progress. |
| `inProgress` _boolean_ | To track if the current state is downscaling. This is done to avoid applying any new spec changes until downscaling is complete. |
| `requestedReplicas` _integer_ | Stores the number of pods that are required for downscaling. This is used to avoid any race conditions that might occur. |


#### Component



Component defines spec overrides of each Apigee Edge component like MP, Synchronizer and so on. NOTE: Currently, for components that use ApigeeDeployment (AD) we save fields from this struct   (as an annotation on the AD.Spec.Template.Annotations) that would cause an AD release if   those field values are changed.   If you add a new field to this struct, consider if the new field is such a field. If not, check the   MergeComponentFieldsThatWouldCauseRelease() function in common/common.go and consider adding that field   to the list of fields excluded from being saved on the annotation mentioned above.

_Appears in:_
- [DatastoreComponents](#datastorecomponents)
- [EnvComponents](#envcomponents)
- [OrgComponents](#orgcomponents)
- [RedisComponents](#rediscomponents)
- [TelemetryComponents](#telemetrycomponents)

| Field | Description |
| --- | --- |
| `name` _string_ |  |
| `properties` _[Properties](#properties)_ |  |
| `storage` _[Storage](#storage)_ |  |
| `annotations` _object (keys:string, values:string)_ |  |
| `sslCertSecretRef` _string_ |  |
| `sslKeySecretRef` _string_ |  |
| `podServiceAccountName` _string_ | PodServiceAccountName is the Service Account to use to run pods for this component. |
| `appServiceAccountSecretName` _string_ | AppServiceAccountSecretName is the name of the Secret used when loading a JSON service account key for this component. |
| `initContainers` _[Container](#container) array_ |  |
| `containers` _[Container](#container) array_ |  |
| `volumes` _[Volume](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#volume-v1-core) array_ |  |
| `configOverride` _object (keys:string, values:string)_ |  |
| `lifecycle` _[Lifecycle](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#lifecycle-v1-core)_ |  |
| `securityContext` _[SecurityContext](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#securitycontext-v1-core)_ |  |
| `nodeAffinityLabels` _object (keys:string, values:string)_ | Deprecated: +optional |
| `nodeAffinityRequired` _boolean_ |  |
| `nodeAffinity` _[NodeAffinity](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#nodeaffinity-v1-core)_ |  |
| `tolerations` _[Toleration](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#toleration-v1-core) array_ |  |
| `version` _string_ |  |
| `autoScaler` _[HorizontalPodAutoscalerSpec](#horizontalpodautoscalerspec)_ |  |
| `terminationGracePeriodSeconds` _integer_ |  |
| `automountServiceAccountToken` _boolean_ |  |
| `dnsPolicy` _[DNSPolicy](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#dnspolicy-v1-core)_ | Set DNS policy for the pod. Defaults to "ClusterFirst". Valid values are 'ClusterFirstWithHostNet', 'ClusterFirst', 'Default' or 'None'. DNS parameters given in DNSConfig will be merged with the policy selected with DNSPolicy. To have DNS options set along with hostNetwork, you have to specify DNS policy explicitly to 'ClusterFirstWithHostNet'. |
| `hostNetwork` _boolean_ | Host networking requested for this pod. Use the host's network namespace. If this option is set, the ports that will be used must be specified. Default to false. |
| `trafficPolicy` _TrafficPolicy_ |  |
| `release` _[ComponentRelease](#componentrelease)_ | Release is used to override the default release configuration of a component. |
| `settings` _ComponentSetting_ | Settings contains the allowed overrides for the component. |
| `replicas` _integer_ | Replicas state the desired number of replicas for a component using a statefulset. |
| `workloadResource` _WorkloadResource_ | Type of workload resource that will be created. |
| `volumeClaimTemplates` _[PersistentVolumeClaim](#persistentvolumeclaim) array_ | Persistent Volume to be created if WorkloadResource is StatefulSet. |
| `serviceSpec` _ServiceSpecOverrides_ | Service spec for underlying apigee deployment created by this component. |






#### DatastoreComponentStatus



DatastoreComponentStatus stores the status of all the components managed by the ApigeeDatastore controller.

_Appears in:_
- [ApigeeDatastoreStatus](#apigeedatastorestatus)

| Field | Description |
| --- | --- |
| `cassandra` _[ComponentStatus](#componentstatus)_ | Status of the Cassandra component: StatefulSet. |


#### DatastoreComponents



DatastoreComponents represents the organization level components.

_Appears in:_
- [ApigeeDatastoreSpec](#apigeedatastorespec)

| Field | Description |
| --- | --- |
| `cassandra` _[Component](#component)_ | Defines the hybrid service that manages the runtime data repository. |
| `removeDc` _[Component](#component)_ |  |


#### DeprecatedHTTPMatch



DeprecatedHTTPMatch specifies a set of criterion to be met in order for the rule to be applied to the HTTP request.

_Appears in:_
- [DeprecatedHTTPRoute](#deprecatedhttproute)

| Field | Description |
| --- | --- |
| `uri` _[URI](#uri)_ | URI defines match rule based on uri. |


#### DeprecatedHTTPRoute



DeprecatedHTTPRoute is an ordered list of route rules for HTTP traffic.

_Appears in:_
- [DeprecatedRoutePolicy](#deprecatedroutepolicy)

| Field | Description |
| --- | --- |
| `match` _[DeprecatedHTTPMatch](#deprecatedhttpmatch) array_ | Matches defines a list of HTTP filters for ingress. |
| `headers` _[Headers](#headers)_ | Header manipulation rules. |
| `rewrite` _[HTTPRewrite](#httprewrite)_ | Rewrite can be used to rewrite specific parts of a HTTP request before forwarding the request to the destination. |
| `timeout` _integer_ | Timeout for HTTP requests. In seconds. |
| `destinationPort` _integer_ | DestinationPort points to one of the port in the deployment. |




#### DeprecatedTCPRoutes



DeprecatedTCPRoutes is an ordered list of route rule for opaque TCP traffic. TCP routes will be applied to any port that is not a HTTP or TLS port. The first rule matching an incoming request is used. https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/#TCPRoute

_Appears in:_
- [DeprecatedRoutePolicy](#deprecatedroutepolicy)

| Field | Description |
| --- | --- |
| `match` _[TCPMatch](#tcpmatch) array_ | Matches is L4 match criterion to be met in order for the rule to be applied to request. |
| `destinationPort` _integer_ | DestinationPort points to one of the port in the deployment. |


#### DeprecatedTLSRoutes



DeprecatedTLSRoutes is an ordered list of route rule for non-terminated TLS & HTTPS traffic. Routing is typically performed using the SNI value presented by the ClientHello message. https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/#TLSRoute

_Appears in:_
- [DeprecatedRoutePolicy](#deprecatedroutepolicy)

| Field | Description |
| --- | --- |
| `match` _[TLSMatch](#tlsmatch) array_ | Matches is L4 match criterion to be met in order for the rule to be applied to request. |
| `destinationPort` _integer_ | DestinationPort points to one of the port in the deployment. |


#### Destination



Destination for the request.

_Appears in:_
- [HTTPRoute](#httproute)
- [TCPRoutes](#tcproutes)
- [TLSRoutes](#tlsroutes)

| Field | Description |
| --- | --- |
| `name` _string_ | Name of the destination resource. |
| `namespace` _string_ | Namespace of the destination resource, if not passed, namespace of the ApigeeRoute is considered. |
| `kind` _string_ | Kind of the destination resource, if not passed, ApigeeDeployment is considered. |
| `port` _integer_ | Port is the destination port. |






#### ErrorStatus



ErrorStatus defines the error object reported in the status.

_Appears in:_
- [ApigeeRouteStatus](#apigeeroutestatus)

| Field | Description |
| --- | --- |
| `generation` _integer_ | Generation ID of the object for which error was observed. |
| `message` _string_ | The error message reported to the management plane. |


#### HTTPForwardProxy



HTTPForwardProxy defines a spec of HTTP forward proxy.

_Appears in:_
- [ApigeeDatastoreSpec](#apigeedatastorespec)

| Field | Description |
| --- | --- |
| `scheme` _[HTTPScheme](#httpscheme)_ |  |
| `host` _string_ |  |
| `port` _integer_ |  |
| `username` _string_ |  |
| `password` _string_ |  |


#### HTTPMatch



HTTPMatch specifies a set of criterion to be met in order for the rule to be applied to the HTTP request.

_Appears in:_
- [HTTPRoute](#httproute)

| Field | Description |
| --- | --- |
| `uri` _[StringMatch](#stringmatch)_ | Defines match rules based on URI. |
| `headers` _[map[string]StringMatch](#map[string]stringmatch)_ | Matches headers of the request. |


#### HTTPRetry



HTTPRetry represents the policy to use when a HTTP request fails.

_Appears in:_
- [HTTPRoute](#httproute)

| Field | Description |
| --- | --- |
| `attempts` _integer_ | The number of retries to be allowed for a given request. The interval between retries will be determined automatically (25ms+). |
| `perTryTimeout` _[Duration](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#duration-v1-meta)_ | The timeout per retry attempt for a given request. Format: 1h/1m/1s/1ms. Note that the minimum timeout must be 1ms. Default is same value as request timeout of the HTTP route, |
| `retryOn` _string_ | Specifies the conditions under which retry takes place. One or more policies can be specified using a ',' delimited list. See Retry Policies or gRPC Retry Policies for more details. |


#### HTTPRewrite



HTTPRewrite are used to rewrite specific parts of a HTTP request before forwarding the request to the destination.

_Appears in:_
- [DeprecatedHTTPRoute](#deprecatedhttproute)
- [HTTPRoute](#httproute)

| Field | Description |
| --- | --- |
| `uri` _string_ | Rewrites the path (or the prefix) portion of the URI with this value. If the original URI was matched based on prefix, the value provided in this field will replace the corresponding matched prefix. |
| `authority` _string_ | Overwrites the Authority or Host portion of the URL with this value. |


#### HTTPRoute



HTTPRoute represents an ordered list of route rules for HTTP traffic.

_Appears in:_
- [RoutePolicy](#routepolicy)

| Field | Description |
| --- | --- |
| `match` _[HTTPMatch](#httpmatch) array_ | Defines a list of HTTP filters for Ingress. |
| `headers` _[Headers](#headers)_ | Indicates the manipulation rules. |
| `rewrite` _[HTTPRewrite](#httprewrite)_ | Rewrites specific parts of a HTTP request before forwarding the request to the destination. |
| `timeout` _integer_ | Timeout for HTTP requests (in seconds). |
| `retries` _[HTTPRetry](#httpretry)_ | A policy that is used when a HTTP request fails. |
| `destination` _[Destination](#destination)_ | Destination for the request. |


#### HTTPScheme

_Underlying type:_ `string`

HTTPScheme defines scheme types.

_Appears in:_
- [HTTPForwardProxy](#httpforwardproxy)



#### HeaderOperations



HeaderOperations describes the Header manipulations to apply.

_Appears in:_
- [Headers](#headers)

| Field | Description |
| --- | --- |
| `set` _object (keys:string, values:string)_ | Overwrites the headers specified by key with the given values. |
| `add` _object (keys:string, values:string)_ | Appends the given values to the headers specified by keys (creates a comma-separated list of values). |
| `remove` _string array_ | Removes the specified headers. |


#### Headers



Headers describe the Headers manipulation rules.

_Appears in:_
- [DeprecatedHTTPRoute](#deprecatedhttproute)
- [HTTPRoute](#httproute)

| Field | Description |
| --- | --- |
| `request` _[HeaderOperations](#headeroperations)_ | A Header manipulation rule to apply before forwarding a request to the destination service. |
| `response` _[HeaderOperations](#headeroperations)_ | A Header manipulation rule to apply before returning a response to the caller. |


#### HorizontalPodAutoscalerSpec



HorizontalPodAutoscalerSpec automatically scales the number of pods in a replica set based on observed CPU utilization (or, with custom metrics support, on some other application-provided metrics) https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale

_Appears in:_
- [Component](#component)

| Field | Description |
| --- | --- |
| `minReplicas` _integer_ | MinReplicas is the lower limit for the number of replicas to which the autoscaler can scale down. It defaults to 1 pod. |
| `maxReplicas` _integer_ | MaxReplicas is the upper limit for the number of replicas to which the autoscaler can scale up. It cannot be less that minReplicas. |
| `metrics` _[MetricSpec](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#metricspec-v2beta1-autoscaling) array_ | Metrics contains the specifications for which to use to calculate the desired replica count (the maximum replica count across all metrics will be used).  The desired replica count is calculated multiplying the ratio between the target value and the current value by the current number of pods.  Ergo, metrics used must decrease as the pod count is increased, and vice-versa.  See the individual metric source types for more information about how each type of metric must respond. If not set, the default metric will be set to 80% average CPU utilization. |
| `behavior` _[HorizontalPodAutoscalerBehavior](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#horizontalpodautoscalerbehavior-v2beta2-autoscaling)_ | Behavior configures the scaling behavior of the target in both Up and Down directions (scaleUp and scaleDown fields respectively). If not set, the default HPAScalingRules for scale up and scale down are used. |






#### NestedState

_Underlying type:_ `string`

NestedState defines the sub task being proceed in a given state.

_Appears in:_
- [ApigeeDatastoreStatus](#apigeedatastorestatus)
- [ApigeeRedisStatus](#apigeeredisstatus)







#### Port



Port defines all the port related details such as, port number, TLS, and so on.

_Appears in:_
- [ApigeeRouteSpec](#apigeeroutespec)
- [Host](#host)

| Field | Description |
| --- | --- |
| `number` _integer_ | The port number. |
| `protocol` _string_ | The traffic protocol in the port. For example, HTTP, HTTP2, GRPC, MONGO, REDIS, MYSQL, or TCP. |
| `tls` _[TLSServer](#tlsserver)_ | Contains the options that govern the server's behavior. These options are used to control all HTTP-to-HTTPS redirects, and the TLS modes. |


#### RebuildDetails



RebuildDetails defines the Cassandra node rebuild task details.

_Appears in:_
- [CassandraDataReplicationDetails](#cassandradatareplicationdetails)

| Field | Description |
| --- | --- |
| `state` _State_ | Defines the state of rebuild details for a cassandra node. For example, `running`, `complete`, `error`, and so on. This is a read-only field. |
| `message` _string_ | Any message related to rebuild process. This is a read-only field. |
| `updated` _integer_ | Last updated (epoch) time of this object. This is a read-only field. |


#### RedisComponentStatus



RedisComponentStatus stores the status of components that are managed by the ApigeeRedis controller.

_Appears in:_
- [ApigeeRedisStatus](#apigeeredisstatus)

| Field | Description |
| --- | --- |
| `redis` _[ComponentStatus](#componentstatus)_ | Status of the Redis component (StatefulSet). |
| `redisEnvoy` _[ComponentStatus](#componentstatus)_ | Status of the RedisEnvoy component. |


#### RedisComponents



RedisComponents represents the components related to an Apigee Redis object.

_Appears in:_
- [ApigeeRedisSpec](#apigeeredisspec)

| Field | Description |
| --- | --- |
| `redis` _[Component](#component)_ |  |
| `redisEnvoy` _[Component](#component)_ |  |


#### RoutePolicy



RoutePolicy represents the configurations affecting the traffic routing between Ingress and the application.

_Appears in:_
- [ApigeeRouteSpec](#apigeeroutespec)

| Field | Description |
| --- | --- |
| `http` _[HTTPRoute](#httproute) array_ | An ordered list of route rules for HTTP traffic. HTTP routes will be applied to platform service ports named 'http-'/'http2-'/'grpc-*', gateway ports with protocol HTTP/HTTP2/GRPC/TLS-terminated-HTTPS, and service entry ports using HTTP/HTTP2/GRPC protocols. The first rule matching an incoming request is used. |
| `tls` _[TLSRoutes](#tlsroutes) array_ | An ordered list of route rules for non-terminated TLS and HTTPS traffic. Routing is typically performed using the SNI value presented by the ClientHello message. TLS routes will be applied to platform service ports named 'https-', 'tls-', unterminated gateway ports using HTTPS/TLS protocols (that is with "passthrough" TLS mode), and service entry ports using HTTPS/TLS protocols. The first rule matching an incoming request is used. NOTE: Traffic 'https-' or 'tls-' ports without associated virtual service will be treated as opaque TCP traffic. |
| `tcp` _[TCPRoutes](#tcproutes) array_ | An ordered list of route rules for opaque TCP traffic. TCP routes will be applied to any port that is not a HTTP or TLS port. The first rule matching an incoming request is used. |


#### Source



Source defines the source Cassandra details that the local Cassandra nodes use for fetching data.

_Appears in:_
- [CassandraDataReplicationSpec](#cassandradatareplicationspec)

| Field | Description |
| --- | --- |
| `region` _string_ | Region name for the source Cassandra cluster. |




#### StorageStatus



StorageStatus stores the Apigee Datastore Status storage details.

_Appears in:_
- [ApigeeDatastoreStatus](#apigeedatastorestatus)

| Field | Description |
| --- | --- |
| `size` _string_ | Stores the current storage of PVC and statefulset in the cluster. |


#### StringMatch



StringMatch describes how to match a given string.

_Appears in:_
- [HTTPMatch](#httpmatch)

| Field | Description |
| --- | --- |
| `prefix` _string_ | Performs prefix-based match. |
| `exact` _string_ | Performs exact string match. |
| `regex` _string_ | Performs ECMA script style regex-based match. |
| `prefixPattern` _string_ | Performs prefix-based match by converting the string to re2(https://github.com/google/re2) style regex, if a segment of the basepath is * it is treated as wildcard. For example, /v1/*      -> /v1/[^/]+(/[^/]+)*/?     /v1/*/*bar -> /v1/[^/]+/[*]bar(/[^/]+)*/? |


#### TCPMatch



TCPMatch represents the L4 match criterion to be met in order for the rule to be applied to the request.

_Appears in:_
- [DeprecatedTCPRoutes](#deprecatedtcproutes)
- [TCPRoutes](#tcproutes)

| Field | Description |
| --- | --- |
| `port` _integer_ | The port on the host that is being addressed. |


#### TCPRoutes



TCPRoutes represents an ordered list of route rules for opaque TCP traffic. TCP routes will be applied to any port that is not a HTTP or TLS port. The first rule matching an incoming request is used. For more information, see: https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/#TCPRoute

_Appears in:_
- [RoutePolicy](#routepolicy)

| Field | Description |
| --- | --- |
| `match` _[TCPMatch](#tcpmatch) array_ | The L4 match criterion to be met in order for the rule to be applied to request. |
| `destination` _[Destination](#destination)_ | Destination for the request. |


#### TLS



TLS consists of options that govern the server behavior. These options are used to control HTTP-to-HTTP redirects and TLS modes.

_Appears in:_
- [ApigeeRouteConfigSpec](#apigeerouteconfigspec)

| Field | Description |
| --- | --- |
| `httpsRedirect` _boolean_ | *(Optional)* If true, the load balancer sends a 301 redirect code response to all the HTTP connections, indicating the clients to use HTTPS. |
| `mode` _string_ | *(Optional)* Indicates if connections to this port should be secured using TLS. The value of this field determines how TLS is enforced. For more information, see: https://istio.io/docs/reference/config/networking/v1alpha3/gateway/#Server-TLSOptions |
| `secretNameRef` _string_ | The secret object containing the cert details. By default, this secret object is in the istio-system namespace. If istio is installed in any other namespace, then provide the value as namespace/secret-name. |
| `minProtocolVersion` _string_ | *(Optional)* The minimum TLS protocol version. |
| `maxProtocolVersion` _string_ | *(Optional)* The maximum TLS protocol version. |


#### TLSMatch



TLSMatch represents the TLS connection match attributes.

_Appears in:_
- [DeprecatedTLSRoutes](#deprecatedtlsroutes)
- [TLSRoutes](#tlsroutes)

| Field | Description |
| --- | --- |
| `sniHosts` _string array_ | SNI (server name indicator) to match on. Wildcard prefixes can be used in the SNI value, For example,  *.com will match foo.example.com as well as example.com. Note that an SNI value must be a subset (fall within the domain) of the corresponding virtual services hosts. |
| `port` _integer_ | The port on the host that is being addressed. |


#### TLSRoutes



TLSRoutes represents an ordered list of route rules for non-terminated TLS & HTTPS traffic. Routing is typically performed using the SNI value presented by the ClientHello message. For more information, see: https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/#TLSRoute

_Appears in:_
- [RoutePolicy](#routepolicy)

| Field | Description |
| --- | --- |
| `match` _[TLSMatch](#tlsmatch) array_ | The L4 match criterion to be met in order for the rule to be applied to request. |
| `destination` _[Destination](#destination)_ | Destination for the request. |


#### TLSServer



TLSServer contains the options that govern the server's behavior. These options are used to control all HTTP-to-HTTPS redirects, and the TLS modes.

_Appears in:_
- [Port](#port)

| Field | Description |
| --- | --- |
| `httpsRedirect` _boolean_ | If true, the load balancer sends a 301 redirect response code to all HTTP connections, indicating the clients to use HTTPS. |
| `mode` _string_ | Indicates if the connections to this port should be secured using TLS. The value of this field determines how TLS is enforced. For more information, see: https://istio.io/docs/reference/config/networking/v1alpha3/gateway/#Server-TLSOptions |
| `serverCertificate` _string_ | The file path containing the server-side TLS certificate. Required if mode is set to `SIMPLE` or `MUTUAL`. |
| `privateKey` _string_ | The file path containing the server private key. Required if mode is set to `SIMPLE` or `MUTUAL`. |
| `caCertificates` _string_ | The file path containing Certificate Authority (CA) certificates to use in verifying a presented client side certificate. Required if mode is set to `MUTUAL`. |
| `credentialName` _string_ | A unique identifier that is used to identify the serverCertificate and the privateKey. |
| `subjectAltNames` _string array_ | A list of alternate names that is used to verify the subject identity in the certificate presented by the client. |
| `minProtocolVersion` _string_ | The minimum TLS protocol version. |
| `maxProtocolVersion` _string_ | The maximum TLS protocol version. |
| `cipherSuites` _string array_ | If specified, supports only the specified Cipher list. If not specified, uses the default Cipher list supported by Envoy. |






#### URI



URI defines match rule based on uri.

_Appears in:_
- [DeprecatedHTTPMatch](#deprecatedhttpmatch)

| Field | Description |
| --- | --- |
| `prefix` _string_ | Prefix helps defines a filter based on HTTP headers using prefix path. |



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


#### TCPKeepalive



TCPKeepalive represents a message sent to check or prevent a TCP connection from breaking.

_Appears in:_
- [TCPSettings](#tcpsettings)



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
- [Component](#component)

| Field | Description |
| --- | --- |
| `tls` _[TLSSettings](#tlssettings)_ | TLS related settings for connections to the upstream service. |
| `portLevelSettings` _[PortTrafficPolicy](#porttrafficpolicy) array_ | The traffic policies specific to individual ports. |
| `connectionPool` _[ConnectionPool](#connectionpool)_ | The connection pool settings for an upstream host. |

## Default Value Tables

<h3 ><a href="#datastorecomponents">DatastoreComponent</a>: removeDc</h3>
<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
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
      - name: "apigee-cassandra-remove-dc"
        imagePullPolicy: "IfNotPresent"
</pre>
</td>
    </tr>
</tbody>
</table>

<h3 ><a href="#datastorecomponents">DatastoreComponent</a>: cassandra</h3>
<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td><code>storage</code> <em><a href="#storage">Storage</a></em></td>
<td>
<pre>
        storageSize: 10Gi
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
        capabilities:
          add:
          - IPC_LOCK
          - SYS_RESOURCE
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
              - apigee-data
          weight: 100
</pre>
</td>
</tr>
<tr>
<td><code>properties</code> <em><a href="#properties">Properties</a></em></td>
<td>
<pre>
        clusterName: apigeecluster
        datacenter: dc-1
        rack: ra-1
</pre>
</td>
</tr>
  <tr>
            <td><code>hostNetwork</code> <em>boolean</em></td>
<td>
<pre>
false
</pre>
</td>
</tr>
<tr>
<td><code>containers</code> <em><a href="#container">Container</a> array</em></td>
<td>
<pre>
      - name: "apigee-cassandra"
        imagePullPolicy: "IfNotPresent"
        readinessProbe:
          exec:
            command:
            - /bin/bash
            - -c
            - /opt/apigee/ready-probe.sh
          initialDelaySeconds: 0
          periodSeconds: 10
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 2
        resources:
          requests:
            cpu: 500m
            memory: 1Gi
        env:
        - name: MAX_HEAP_SIZE
          value: 512M
        - name: HEAP_NEWSIZE
          value: 100M
</pre>
</td>
</tr>
</tbody>
</table>

<h3 ><a href="#rediscomponents">RedisComponent</a>: redis</h3>

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
<td><code>replicas</code> <em>integer</em></td><td>
<pre>
2
</pre>
</td>
</tr>
<tr>
<td><code>containers</code> <em><a href="#container">Container</a> array</em></td>
<td>
<pre>
      - name: apigee-redis
        imagePullPolicy: "IfNotPresent"
        livenessProbe:
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 12
        readinessProbe:
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 2
        resources:
          requests:
            cpu: 500m
</pre>
</td>
</tr>
</tbody>
</table>

<h3 ><a href="#rediscomponents">RedisComponent</a>: redisEnvoy</h3>

<table>
<thead> <tr> <th>Field</th> <th>Default Value</th> </tr> </thead>
<tbody>
<tr>
<td><code>securityContext</code> <em><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#securitycontext-v1-core">SecurityContext</a></em></td>
<td>
<pre>
        runAsNonRoot: true
        runAsUser: 101
        runAsGroup: 101
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
            <td><code>autoScaler</code> <em>HorizontalPodAutoscalerSpec</em></td>
<td>
<pre>
        minReplicas: 1
        maxReplicas: 1
        metrics:
        - type: Resource
          resource:
            name: cpu
            targetAverageUtilization: 75
</pre>
</td>
</tr>
<tr>
<td><code>containers</code> <em><a href="#container">Container</a> array</em></td>
<td>
<pre>
      - name: "apigee-redis-envoy"
        imagePullPolicy: "IfNotPresent"
        livenessProbe:
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 12
        readinessProbe:
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 2
        resources:
          requests:
            cpu: 500m
</pre>
</td>
</tr>
</tbody>
</table>

