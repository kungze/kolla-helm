{{/* vim: set filetype=mustache: */}}
{{/*
Return the proper image name
{{ include "common.images.image" ( dict "registry" .Values.registry "namespace" .Values.namespace "repository" "kolla-toolbox" "tag" .Values.openstackTag) }}
*/}}
{{- define "common.images.image" -}}
{{- $registry := index . "registry" -}}
{{- $namespace := index . "namespace" -}}
{{- $repository := index . "repository" -}}
{{- $tag := index . "tag" -}}
{{ printf "%s/%s/%s:%s" $registry $namespace $repository $tag }}
{{- end -}}

{{- define "common.images.kolla-toolbox" -}}
{{- $repository := "ubuntu-source-kolla-toolbox" -}}
{{ include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}


{{- define "common.images.kubernetes-entrypoint" -}}
{{- $repository := "kubernetes-entrypoint" -}}
{{- $registry := index . "registry" | default "registry.aliyuncs.com" -}}
{{- $namespace := index . "namespace" | default "kungze" -}}
{{- $tag := "v1.0.0" -}}
{{ include "common.images.image" (dict "registry" $registry "namespace" $namespace "repository" $repository "tag" $tag) }}
{{- end -}}
