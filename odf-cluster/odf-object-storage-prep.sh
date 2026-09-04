###############################################################################
#  Used to generate Object Storage and the associated Secret using ODF 
###############################################################################
set -e

OBJ_STORAGE=loki-object-storage

# Create the S3 Object Storage using an ObjectBucketClaim ---------------------
oc apply -f - <<EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: openshift-logging
---
apiVersion: objectbucket.io/v1alpha1
kind: ObjectBucketClaim
metadata:
  name: ${OBJ_STORAGE}
  namespace: openshift-logging
spec:
  generateBucketName: ${OBJ_STORAGE}
  storageClassName: openshift-storage.noobaa.io
EOF

# Querry the values required to construct the secret --------------------------
echo pause a few seconds before looking up the newly created storage bucket ....
sleep 2

BUCKET_HOST=$(oc get -n openshift-logging configmap ${OBJ_STORAGE} -o jsonpath='{.data.BUCKET_HOST}')
BUCKET_NAME=$(oc get -n openshift-logging configmap ${OBJ_STORAGE} -o jsonpath='{.data.BUCKET_NAME}')
BUCKET_PORT=$(oc get -n openshift-logging configmap ${OBJ_STORAGE} -o jsonpath='{.data.BUCKET_PORT}')
ACCESS_KEY_ID=$(oc get -n openshift-logging secret ${OBJ_STORAGE} -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 -d)
SECRET_ACCESS_KEY=$(oc get -n openshift-logging secret ${OBJ_STORAGE} -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 -d)


# Output the secret yaml
cat << EOF > ${OBJ_STORAGE}.yaml
apiVersion: v1
kind: Secret
metadata:
  name: loki-object-stroage
stringData:
  access_key_id: "${ACCESS_KEY_ID}"
  access_key_secret: ${SECRET_ACCESS_KEY}"
  bucketnames: ${BUCKET_NAME}"
  endpoint: "https://${BUCKET_HOST}:${BUCKET_PORT}"
EOF

echo add the ${OBJ_STORAGE}-secret.yaml to your kustomize configuration

# Alternately create the secret directly rather then generating yaml.  
# This option requires removing the reference from the kustomization.yaml file

#oc create secret generic ${OBJ_STORAGE} -n openshift-logging \
#   --from-literal=access_key_id=${ACCESS_KEY_ID} \
#   --from-literal=access_key_secret=${SECRET_ACCESS_KEY} \
#   --from-literal=bucketnames=${BUCKET_NAME} \
#   --from-literal=endpoint=https://${BUCKET_HOST}:${BUCKET_PORT}
