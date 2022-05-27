{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Keystone image name
*/}}
{{- define "keystone.image" -}}
{{ $repository := "ubuntu-source-keystone" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the keystone.cluster.endpoints
*/}}
{{- define "keystone.cluster.endpoint" -}}
{{ printf "http://%s.%s.svc.%s:5000/v3" "keystone-api" .Release.Namespace .Values.cluster_domain_suffix }}
{{- end }}
