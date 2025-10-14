#!/bin/bash

set -Eeuo pipefail

if [ ! -f /etc/default/bootstrap-microshift ]; then
    echo "/etc/default/bootstrap-microshift not found, exiting"
    exit 1
fi

TEMP_DIR=$(mktemp -d /tmp/gitops.XXXXXX)
trap 'rm -rf ${TEMP_DIR}' EXIT

. /etc/default/bootstrap-microshift

git clone "${GIT_REPO_URL}" -b "${GIT_BRANCH:-main}" ${TEMP_DIR}

declare -a HELM_VALUES_ARGS=()
while IFS= read -r line; do
    if [[ "$line" =~ ^#.*$ ]]; then
        continue
    fi
    if [[ -n "$line" ]]; then
        HELM_VALUES_ARGS+=("--set" "$line")
    fi
done <<< "${HELM_VALUES}"

helm dependency build ${TEMP_DIR}/deployment
helm template train ${TEMP_DIR}/deployment "${HELM_VALUES_ARGS[@]}" --set namespace=train > /etc/microshift/manifests.d/crazy-train/payload.yaml
cat > /etc/microshift/manifests.d/crazy-train/namespace.yaml <<"EOF"
apiVersion: v1
kind: Namespace
metadata:
  name: train
EOF
cat > /etc/microshift/manifests.d/crazy-train/kustomization.yaml <<"EOF"
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: train
resources:
- payload.yaml
- namespace.yaml
EOF
