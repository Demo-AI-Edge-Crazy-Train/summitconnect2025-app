# CI/CD pipelines

For more information on how those pipelines are working, see [Build multi-architecture container images with OpenShift, Buildah and Tekton on AWS](https://www.itix.fr/blog/build-multi-architecture-container-images-with-kubernetes-buildah-tekton-aws/).

## Authentication to the registry

```sh
oc create secret docker-registry quay-authentication --docker-email=nmasse@redhat.com --docker-username=nmasse --docker-password=REDACTED --docker-server=quay.io
oc annotate secret/quay-authentication tekton.dev/docker-0=https://quay.io
```

## Share RHEL SCA entitlement with Tekton Pipelines

```sh
oc create -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: etc-pki-entitlement
type: Opaque
data:
  aarch64.pem: $(base64 -w0 /etc/pki/entitlement/XXX.pem)
  aarch64-key.pem: $(base64 -w0 /etc/pki/entitlement/XXX-key.pem)
EOF
```

## Authentication to Flightctl

```sh
oc create secret generic flightctl-config --from-file=client.yaml=$HOME/.config/flightctl/client.yaml
```
