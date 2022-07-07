{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper nova api image name
*/}}
{{- define "nova.api.image" -}}
{{ $repository := "ubuntu-source-nova-api" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper nova conductor image name
*/}}
{{- define "nova.conductor.image" -}}
{{ $repository := "ubuntu-source-nova-conductor" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper nova scheduler image name
*/}}
{{- define "nova.scheduler.image" -}}
{{ $repository := "ubuntu-source-nova-scheduler" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper nova libvirt image name
*/}}
{{- define "nova.libvirt.image" -}}
{{ $repository := "ubuntu-source-nova-libvirt" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper nova compute image name
*/}}
{{- define "nova.compute.image" -}}
{{ $repository := "ubuntu-source-nova-compute" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the nova.cluster.endpoints
*/}}
{{- define "nova.cluster.endpoint" -}}
{{ printf "http://%s.%s.svc.%s:8774/v2.1/%s" "nova-api" .Release.Namespace .Values.cluster_domain_suffix "%(tenant_id)s" }}
{{- end }}
