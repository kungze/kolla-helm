{{- define "common.manifests.job_db_sync" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $dependencyJobs := index . "dependencyJobs" -}}
{{- $image := index . "image" -}}
{{- $podVolMounts := index . "podVolMounts" | default false -}}
{{- $configMapBin := index . "configMapBin" | default (printf "%s-%s" $serviceName "bin" ) -}}
{{- $configMapEtc := index . "configMapEtc" | default (printf "%s-%s" $serviceName "etc" ) -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "%s-%s" $serviceName "db-sync" | quote }}
  namespace: {{ $envAll.Release.Namespace | quote }}
spec:
  template:
    spec:
      activeDeadlineSeconds: 200
      containers:
        - name: {{ printf "%s-%s" $serviceName "db-sync" | quote }}
          image: {{ $image | quote }}
          imagePullPolicy: {{ $envAll.Values.pullPolicy }}
          env:
            - name: KOLLA_CONFIG_STRATEGY
              value: "COPY_ALWAYS"
            - name: KOLLA_SERVICE_NAME
              value: "db-sync"
            - name: KOLLA_BOOTSTRAP
              value: ""
          volumeMounts:
            - mountPath: /tmp
              name: pod-tmp
            - mountPath: /var/lib/kolla/config_files
              name: configdir
            - mountPath: {{ printf "%s-%s" "/var/log/kolla/" $serviceName | quote }}
              name: logdir
            - mountPath: /var/lib/kolla/config_files/config.json
              name: {{ $configMapEtc | quote }}
              subPath: db-sync.json
            - mountPath: /tmp/db-sync.sh
              name: {{ $configMapBin | quote }}
              subPath: db-sync.sh
{{- if $podVolMounts }}
{{ $podVolMounts | toYaml | indent 12 }}
{{- end }}
      initContainers:
        - name: init
          image: {{ include "common.images.kubernetes-entrypoint" (dict "registry" $envAll.Values.imageRegistry "namespace" $envAll.Values.imageNamespace) | quote }}
          imagePullPolicy: {{ $envAll.Values.pullPolicy }}
          command:
            - kubernetes-entrypoint
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.name
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.namespace
            - name: PATH
              value: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/
            - name: DEPENDENCY_JOBS
              value: {{ include "common.utils.joinListWithComma" $dependencyJobs }}
      restartPolicy: OnFailure
      serviceAccount: {{ $envAll.Values.serviceAccountName }}
      serviceAccountName: {{ $envAll.Values.serviceAccountName }}
      volumes:
      - emptyDir: {}
        name: pod-tmp
      - emptyDir: {}
        name: configdir
      - emptyDir: {}
        name: logdir
      - configMap:
          defaultMode: 0755
          name: {{ $configMapBin | quote }}
        name: {{ $configMapBin | quote }}
      - configMap:
          defaultMode: 0644
          name: {{ $configMapEtc | quote }}
        name: {{ $configMapEtc | quote }}
{{- end }}
