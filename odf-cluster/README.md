# configure logging and observability with Loki

1. You must define the storage class used by Loki for creating PVs.
   It would probably make sense to set this in the `base` config; here, we are
   setting the value as an overlay in the `odf-cluster`, but that is primarily
   because we want to call attention to the configuration

2. Loki Logging Requires Object Storage (think s3 bucket) for Logs
   This `odf-cluster` example contains a shell script to generate the object storage
   along with the corresponding secret used by Loki to connect to the storage.
   The secret will be dropped as a yaml file which is expected by the kustomization.yaml.

   The shell script is specifically designed against a cluster running OpenShift Data Foundation (ODF)

   A general article on setting up object storage can be found here:
   https://access.redhat.com/articles/7006275

## Actions to deploy configuration

### Prerequisites 
Install Operators: 
- Red Hat OpenShift Logging Operator
- LokiStack
- Cluster Observability Operator

### Shell commands
```
oc login ...
sh odf-object-storage-prep.sh
oc apply -k .
oc delete -k .
```

