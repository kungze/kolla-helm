{{- define "common.manifests.job_db_sync" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $dependencyJobs := index . "dependencyJobs" -}}
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
      containers:
        - name: {{ printf "%s-%s" $serviceName "db-sync" | quote }}
          image: {{ include "keystone.image" $envAll | quote }}
          imagePullPolicy: {{ $envAll.Values.pullPolicy }}
          livenessProbe:
            exec:
              command:
                - /bin/sh
                - -c
                - kolla_start
            initialDelaySeconds: 10
            periodSeconds: 5
            failureThreshold: 1
          env:
            - name: KOLLA_CONFIG_STRATEGY
              value: "COPY_ALWAYS"
            - name: KOLLA_SERVICE_NAME
              value: "db-sync"
            - name: KOLLA_BOOTSTRAP
              value: ""
            - name: PATH
              value: "/var/lib/kolla/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            - name: LANG
              value: "en_US.UTF-8"
            - name: KOLLA_BASE_DISTRO
              value: "ubuntu"
            - name: KOLLA_DISTRO_PYTHON_VERSION
              value: "3.8"
            - name: KOLLA_BASE_ARCH
              value: "x86_64"
            - name: SETUPTOOLS_USE_DISTUTILS
              value: "stdlib"
            - name: PS1
              value: "$(tput bold)($(printenv KOLLA_SERVICE_NAME))$(tput sgr0)[$(id -un)@$(hostname -s) $(pwd)]$ "
            - name: DEBIAN_FRONTEND
              value: "noninteractive"
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
