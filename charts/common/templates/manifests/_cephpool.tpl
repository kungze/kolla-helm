{{- define "common.manifests.cephpool" -}}
{{- $poolName := index . "poolName" -}}
{{- $cephClusterNamespace := index . "cephClusterNamespace" -}}
{{- $replicated := index . "replicated" -}}
{{- $failureDomain := index . "failureDomain" -}}

apiVersion: ceph.rook.io/v1
kind: CephBlockPool
metadata:
  name: {{ $poolName | quote }}
  namespace: {{ $cephClusterNamespace | quote }}
spec:
  # The failure domain will spread the replicas of the data across different failure zones
  failureDomain: {{ $failureDomain | quote }}
  # For a pool based on raw copies, specify the number of copies. A size of 1 indicates no redundancy.
  replicated:
    size: {{ $replicated }}
    # Disallow setting pool with replica 1, this could lead to data loss without recovery.
    # Make sure you're *ABSOLUTELY CERTAIN* that is what you want
    requireSafeReplicaSize: false
{{- end -}}