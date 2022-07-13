#!/bin/bash
set -ex
vgremove -y {{ .Values.lvm.vg_name }}
pvremove {{ .Values.lvm.loop_device_name }} --force --force
{{- if .Values.lvm.create_loop_device }}
losetup -d {{ .Values.lvm.loop_device_name }}
{{- end }}
