{{/* vim: set filetype=mustache: */}}
{{/*
This helper function takes a parameter and returns the value of `.Values.components.$PARAMETER.git.url`
*/}}
{{- define "gitUrl" -}}
{{- (get .Values.components .name).git.url -}}
{{- end -}}
{{/*
This helper function takes a parameter and returns the value of `.Values.components.$PARAMETER.git.revision`
*/}}
{{- define "gitRevision" -}}
{{- (get .Values.components .name).git.revision -}}
{{- end -}}
{{/*
This helper function takes the component name and returns the image name + tag for this component.
*/}}
{{- define "image" -}}
{{- if (hasKey (get .Values.components .name).image "name") -}}
{{- (get .Values.components .name).image.name -}}:{{- (get .Values.components .name).image.tag -}}
{{- else -}}
{{- $mapping := (dict "intelligentTrain" "intelligent-train" "captureApp" "capture-app" "monitoringApp" "monitoring-app" "ceqApp" "ceq-app" "trainController" "train-controller" "bootcImage" "bootc-image") -}}
image-registry.openshift-image-registry.svc:5000/{{- .Values.namespace -}}/{{- (get $mapping .name) -}}:{{- (get .Values.components .name).image.tag -}}
{{- end -}}
{{- end -}}
{{/*
This helper function takes a parameter and returns the value of `.Values.components.$PARAMETER.git.contextDir`
*/}}
{{- define "gitContextDir" -}}
{{- (get .Values.components .name).git.contextDir -}}
{{- end -}}
{{/*
This helper function prints the tekton workspace to push to a registry
*/}}
{{- define "imageRegistryWorkspace" -}}
{{- if (hasKey (get .Values.components .name).image "secretName") -}}
- name: registry-token
  secret:
    secretName: {{ (get .Values.components .name).image.secretName | quote }}
{{- end -}}
{{- end -}}
