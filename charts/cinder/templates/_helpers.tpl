{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper cinder api image name
*/}}
{{- define "cinder.api.image" -}}
{{ $repository := "ubuntu-source-cinder-api" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper cinder volume image name
*/}}
{{- define "cinder.volume.image" -}}
{{ $repository := "ubuntu-source-cinder-volume" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper cinder scheduler image name
*/}}
{{- define "cinder.scheduler.image" -}}
{{ $repository := "ubuntu-source-cinder-scheduler" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper cinder backup image name
*/}}
{{- define "cinder.backup.image" -}}
{{ $repository := "ubuntu-source-cinder-backup" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper tgtd image name
*/}}
{{- define "kolla.tgtd.image" -}}
{{ $repository := "ubuntu-source-tgtd" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper cinder loop image name
*/}}
{{- define "cinder.loop.image" -}}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" "loop" "tag" "latest") }}
{{- end -}}

{{/*
Return the cinder.cluster.endpoints
*/}}
{{- define "cinder.cluster.endpoint" -}}
{{ printf "http://%s.%s.svc.%s:8776/v3/%s" "cinder-api" .Release.Namespace .Values.cluster_domain_suffix "%(tenant_id)s" }}
{{- end }}
