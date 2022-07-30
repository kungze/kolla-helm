{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper placement server image name
*/}}
{{- define "placement.placement-api.image" -}}
{{ $repository := "ubuntu-source-placement-api" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the placement.cluster.endpoints
*/}}
{{- define "placement.cluster.endpoint" -}}
{{ printf "http://%s.%s.svc.%s:8778" "placement-api" .Release.Namespace .Values.cluster_domain_suffix }}
{{- end }}
