ROOT=$(dirname "${BASH_SOURCE[0]}")
# shellcheck disable=SC1090
source "${ROOT}"/scripts/constants.sh

help() {
  echo "./validate.sh INSTANCE_NAME"
}

if [ -z "$CLUSTER_ZONE" ]; then
  echo "Make sure that compute/zone is set in gcloud config"
  exit 1
fi

INSTANCE_NAME=$(cat "${ROOT}"/.instance)
export INSTANCE_NAME
if [ -z "$INSTANCE_NAME" ] ; then
  help
  exit 1
fi

if ! gcloud sql instances describe "$INSTANCE_NAME" > /dev/null; then
  echo "FAIL: Cloud SQL instance does not exist"
else
  echo "Cloud SQL instance exists"
fi

if ! gcloud container clusters describe \
      "$CLUSTER_NAME" --zone "$CLUSTER_ZONE" > /dev/null; then
  echo "FAIL: GKE cluster does not exist"
else
  echo "GKE cluster exists"
fi

# You can look for Kubernetes objects in a variety of ways.
# This method involves giving the 'get' command the same manifest used to
# create the object. It will find an object matching
# the description in the manifest
if ! kubectl --namespace default get -f "$ROOT"/manifests/pgadmin-deployment.yaml > /dev/null; then
  echo "FAIL: pgAdmin4 Deployment object does not exist"
else
  echo "pgAdmin4 Deployment object exists"
fi