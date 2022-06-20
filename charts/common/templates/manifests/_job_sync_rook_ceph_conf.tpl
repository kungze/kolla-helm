{{/*
Sync ceph auth info (ceph monitor endpoints and ceph user secret) from rook
ceph cluster namespace to current namespace, in order to openstack project
related pod mount.
*/}}
{{- define "common.manifests.job_sync_rook_ceph_conf" -}}
{{ $envAll := index . "envAll" }}
{{ $serviceName := index . "serviceName" }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ printf "ceph-%s" $envAll.Values.ceph.cephClientName | quote }}
  namespace: {{ $envAll.Release.Namespace }}
type: Opaque
data:
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "sync-rook-ceph-conf-for-%s" $serviceName | quote }}
  namespace: {{ $envAll.Release.Namespace | quote }}
  labels: {{- include "common.labels.standard" $envAll | nindent 4 }}
spec:
  template:
    spec:
      activeDeadlineSeconds: 100
      containers:
        - name: {{ printf "sync-rook-ceph-conf-for-%s" $serviceName | quote }}
          image: {{ include "common.images.kolla-toolbox" $envAll | quote }}
          imagePullPolicy: {{ $envAll.Values.pullPolicy }}
          command:
            - /bin/sh
            - -c
            - python /tmp/sync-ceph-cm-secrets.py
          env:
            - name: KUBERNETES_NAMESPACE
              value: {{ $envAll.Release.Namespace | quote }}
            - name: ROOK_CEPH_CLUSTER_NAMESPACE
              value: {{ $envAll.Values.ceph.cephClusterNamespace | quote }}
            - name: ROOK_CEPH_MON_ENDPOINTS_CONFIGMAP
              value: {{ printf "%s-mon-endpoints" $envAll.Values.ceph.cephClusterName }}
            - name: ROOK_CEPH_CLIENT_SECRET
              value: {{ printf "%s-client-%s" $envAll.Values.ceph.cephClusterName $envAll.Values.ceph.cephClientName | quote }}
            - name: OS_CEPH_MON_CONFIGMAP
              value: "ceph-monitor-endpoints"
            - name: OS_CEPH_CLIENT_SECRET
              value: {{ printf "ceph-%s" $envAll.Values.ceph.cephClientName | quote }}
          volumeMounts:
          - mountPath: /tmp
            name: pod-tmp
          - mountPath: /tmp/sync-ceph-cm-secrets.py
            name: {{ printf "%s-bin" $serviceName | quote }}
            subPath: sync-ceph-cm-secrets.py
      restartPolicy: OnFailure
      serviceAccount: {{ $envAll.Values.serviceAccountName}}
      serviceAccountName: {{ $envAll.Values.serviceAccountName}}
      volumes:
        - emptyDir: {}
          name: pod-tmp
        - name: {{ printf "%s-bin" $serviceName | quote }}
          configMap:
            defaultMode: 0755
            name: {{ printf "%s-bin" $serviceName | quote }}
{{- end -}}
