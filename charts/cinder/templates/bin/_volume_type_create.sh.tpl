#!/bin/bash
set -ex
{{- if .Values.ceph.enabled }}
openstack volume type create {{ .Values.ceph.volume_type }}
openstack volume type set --property volume_backend_name='{{ .Values.ceph.volume_type }}' {{ .Values.ceph.volume_type }}
{{- end }}

{{- if .Values.lvm.enabled }}
openstack volume type create {{ .Values.lvm.volume_type }}
openstack volume type set --property volume_backend_name='{{ .Values.lvm.volume_type }}' {{ .Values.lvm.volume_type }}
{{- end }}
