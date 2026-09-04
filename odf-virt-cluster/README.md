# Configure "Full Stack" logging for OpenShift Virtualization

1. see ../odf-cluster/README.md on which this configuration is based

2. odf-virt-cluster builds on odf-cluster config by adding a logging input
   for VM applicaions.  This allows VM logging agents to forward logs into
   OpenShift Logging, allowing OpenShift Logging to manage the forwarding and
   distribution tp final destination logging solutions.   

## Actions

first configure object storage secret in ../odf-cluster and correct object 
storage class name for your cluster

```
oc apply -k .
```

