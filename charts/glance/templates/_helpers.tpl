{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper glance api image name
*/}}
{{- define "glance.api.image" -}}
{{ $repository := "ubuntu-source-glance-api" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the glance.cluster.endpoints
*/}}
{{- define "glance.cluster.endpoint" -}}
{{ printf "http://%s.%s.svc.%s:9292" "glance-api" .Release.Namespace .Values.cluster_domain_suffix }}
{{- end }}