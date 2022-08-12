{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper neutron server image name
*/}}
{{- define "neutron.server.image" -}}
{{ $repository := "ubuntu-source-neutron-server" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper neutron dhcp image name
*/}}
{{- define "neutron.dhcp.image" -}}
{{ $repository := "ubuntu-source-neutron-dhcp-agent" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper neutron linuxbridge image name
*/}}
{{- define "neutron.linuxbridge.image" -}}
{{ $repository := "ubuntu-source-neutron-linuxbridge-agent" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper neutron openvswitch agent init image name
*/}}
{{- define "neutron.openvswitch-agent-init.image" -}}
{{ $repository := "ubuntu-source-kolla-toolbox" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper neutron openvswitch agent image name
*/}}
{{- define "neutron.openvswitch-agent.image" -}}
{{ $repository := "ubuntu-source-neutron-openvswitch-agent" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper neutron openvswitch db image name
*/}}
{{- define "neutron.openvswitch-db.image" -}}
{{ $repository := "ubuntu-source-openvswitch-db-server" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper neutron openvswitch vswitchd image name
*/}}
{{- define "neutron.openvswitch-vswitchd.image" -}}
{{ $repository := "ubuntu-source-openvswitch-vswitchd" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper neutron l3 agent image name
*/}}
{{- define "neutron.l3-agent.image" -}}
{{ $repository := "ubuntu-source-neutron-l3-agent" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the proper neutron metadata agent image name
*/}}
{{- define "neutron.metadata-agent.image" -}}
{{ $repository := "ubuntu-source-neutron-metadata-agent" }}
{{- include "common.images.image" (dict "registry" .Values.imageRegistry "namespace" .Values.imageNamespace "repository" $repository "tag" .Values.openstackTag) }}
{{- end -}}

{{/*
Return the neutron.cluster.endpoints
*/}}
{{- define "neutron.cluster.endpoint" -}}
{{ printf "http://%s.%s.svc.%s:9696" "neutron-api" .Release.Namespace .Values.cluster_domain_suffix }}
{{- end }}
