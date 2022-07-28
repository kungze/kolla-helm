{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper glance api image name
*/}}
{{- define "horizon.image" -}}
{{ $repository := "ubuntu-binary-horizon" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}
