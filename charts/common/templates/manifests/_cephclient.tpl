{{- define "common.utils.joinCephProfile" -}}
{{- $local := dict "first" true -}}
{{- range $index, $element := . -}}
  {{- if not $local.first -}}{{- ", " -}}{{- end -}}
  {{- "profile" -}}
  {{- if $element.readOnly -}}{{- " rbd-read-only " -}}{{- else -}}{{- " rbd " -}}{{- end -}}
  {{- "pool=" -}}{{- $element.poolName -}}
  {{- $_ := set $local "first" false -}}
{{- end -}}
{{- end -}}

{{- define "common.manifests.cephclient" -}}
{{- $cephClusterNamespace := index . "cephClusterNamespace" -}}
{{- $cephUserName := index . "cephUserName" -}}
{{- $prvileges := index . "prvileges" -}}
apiVersion: ceph.rook.io/v1
kind: CephClient
metadata:
  name: {{ $cephUserName | quote }}
  namespace: {{ $cephClusterNamespace | quote }}
spec:
  caps:
    mon: "profile rbd"
    osd: {{ $prvileges | include "common.utils.joinCephProfile" | quote }}
{{- end -}}
