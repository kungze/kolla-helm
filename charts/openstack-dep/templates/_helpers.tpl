{{/*
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name for RabbitMQ subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openstack.rabbitmq.fullname" -}}
{{- if .Values.rabbitmq.fullnameOverride -}}
{{- .Values.rabbitmq.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "rabbitmq" .Values.rabbitmq.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ host
*/}}
{{- define "openstack.rabbitmqHost" -}}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomainSuffix }}
    {{- printf "%s.%s.svc.%s" (include "openstack.rabbitmq.fullname" .) $releaseNamespace $clusterDomain -}}
{{- end -}}

{{/*
Return the RabbitMQ port
*/}}
{{- define "openstack.rabbitmqPort" -}}
    {{- printf "%d" (.Values.rabbitmq.service.port | int ) -}}
{{- end -}}

{{/*
Return the proper Keystone image name
*/}}
{{- define "rabbitmq.connInfo" -}}
    {{- $rabbitmqHost := include "openstack.rabbitmqHost" . }}
    {{- $rabbitmqPort := (include "openstack.rabbitmqPort" . | int) }}
    {{- printf "%s:%d" $rabbitmqHost $rabbitmqPort }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openstack.database.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the Database host
*/}}
{{- define "openstack.databaseHost" -}}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomainSuffix }}
    {{- printf "%s.%s.svc.%s" (include "openstack.database.fullname" .) $releaseNamespace $clusterDomain -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "openstack.databasePort" -}}
    {{- printf "3306" -}}
{{- end -}}

{{/*
Return the database connInfo
*/}}
{{- define "database.connInfo" -}}
    {{- $databaseHost := include "openstack.databaseHost" . }}
    {{- $databasePort := (include "openstack.databasePort" . | int) }}
    {{- printf "%s:%d" $databaseHost $databasePort }}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openstack.memcached.fullname" -}}
{{- printf "%s-%s" .Release.Name "memcached" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the Memcached Hostname
*/}}
{{- define "openstack.cacheHost" -}}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomainSuffix }}
    {{- printf "%s.%s.svc.%s" (include "openstack.memcached.fullname" .) $releaseNamespace $clusterDomain -}}
{{- end -}}

{{/*
Return the Memcached Port
*/}}
{{- define "openstack.cachePort" -}}
    {{- printf "11211" -}}
{{- end -}}

{{/*
Return the memcached connInfo
*/}}
{{- define "memcached.connInfo" -}}
    {{- $memcachedHost := include "openstack.cacheHost" . }}
    {{- $memcachedPort := (include "openstack.cachePort" . | int) }}
    {{- printf "%s:%d" $memcachedHost $memcachedPort }}
{{- end -}}
