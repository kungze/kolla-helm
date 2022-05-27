#!/bin/bash
set -ex
pvcreate {{ .Values.lvm.loop_device_name }}
vgcreate {{ .Values.lvm.vg_name }} {{ .Values.lvm.loop_device_name }}
