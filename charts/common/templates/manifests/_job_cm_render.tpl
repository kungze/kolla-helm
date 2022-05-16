{{- define "common.manifests.job_cm_render" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $dependencyJobs := index . "dependencyJobs" -}}
{{- $podEnvVars := index . "podEnvVars" | default false -}}
{{- $configMapBin := index . "configMapBin" | default (printf "%s-%s" $serviceName "bin") -}}
{{- $configMapEtc := index . "configMapEtc" | default (printf "%s-%s" $serviceName "etc") -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "%s-%s" $serviceName "cm-render" | quote }}
  namespace: {{ $envAll.Release.Namespace | quote }}
spec:
  template:
    spec:
      containers:
        - name: {{ printf "%s-%s" $serviceName "cm-render" | quote }}
          image: {{ include "common.images.kolla-toolbox" $envAll | quote }}
          imagePullPolicy: {{ $envAll.Values.pullPolicy }}
          command:
            - /bin/sh
            - -c
            - python3 /tmp/configmap-render.py
          env:
            - name: KUBERNETES_NAMESPACE
              value: {{ $envAll.Release.Namespace }}
            - name: CONFIG_MAP_NAME
              value: {{ printf "%s-%s" $serviceName "etc" | quote }}
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: {{ printf "%s-database-password" $serviceName | quote }}
                  name: {{ $envAll.Values.passwordRelease | quote }}
            - name: RABBITMQ_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: "rabbitmq-password"
                  name: {{ $envAll.Values.passwordRelease | quote }}
            - name: DATABASE_ENDPOINT
              valueFrom:
                secretKeyRef:
                  key: DATABASE
                  name: {{ $envAll.Values.openstackDepRelease | quote }}
            - name: RABBITMQ_ENDPOINT
              valueFrom:
                secretKeyRef:
                  key: RABBITMQ
                  name: {{ $envAll.Values.openstackDepRelease | quote }}
            - name: MEMCACHE_ENDPOINT
              valueFrom:
                secretKeyRef:
                  key: MEMCACHE
                  name: {{ $envAll.Values.openstackDepRelease | quote }}
            {{- if $envAll.Values.keystoneRelease }}
            - name: OS_REGION
              valueFrom:
                secretKeyRef:
                  key: OS_REGION_NAME
                  name: {{ $envAll.Values.keystoneRelease | quote }}
            - name: KEYSTONE_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: {{ printf "%s-keystone-password" $serviceName | quote }}
                  name: {{ $envAll.Values.passwordRelease | quote }}
            - name: KEYSTONE_ENDPOINT
              valueFrom:
                secretKeyRef:
                  key: KEYSTONE_INTERNAL_ENDPOINT
                  name: {{ $envAll.Values.openstackDepRelease | quote }}
            {{- end -}}
{{- if $podEnvVars }}
{{ $podEnvVars | toYaml | indent 12 }}
{{- end }}
          volumeMounts:
            - mountPath: /tmp
              name: pod-tmp
            - mountPath: /tmp/configmap-render.py
              name: {{ $configMapBin | quote }}
              subPath: configmap-render.py
            - mountPath: /etc/sudoers.d/kolla_ansible_sudoers
              name: {{ $configMapEtc | quote }}
              subPath: kolla-toolbox-sudoer
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
      - configMap:
          defaultMode: 0755
          name: {{ $configMapBin | quote }}
        name: {{ $configMapBin | quote }}
      - configMap:
          defaultMode: 0644
          name: {{ $configMapEtc | quote }}
        name: {{ $configMapEtc | quote }}
{{- end }}
