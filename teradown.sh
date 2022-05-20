ROOT=$(dirname "${BASH_SOURCE[0]}")

help() {
  echo "./teardown.sh INSTANCE_NAME"
}

INSTANCE_NAME=$(cat "${ROOT}"/.instance)
export INSTANCE_NAME
if [ -z "$INSTANCE_NAME" ] ; then
  help
  exit 1
fi

"$ROOT"/scripts/delete_resources.sh
"$ROOT"/scripts/delete_instance.sh