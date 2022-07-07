{{- define "common.manifests.job_db_init" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $dependencyJobs := index . "dependencyJobs" -}}
{{- $configMapBin := index . "configMapBin" | default (printf "%s-%s" $serviceName "bin" ) -}}
{{- $configMapEtc := index . "configMapEtc" | default (printf "%s-%s" $serviceName "etc" ) -}}
{{- $dbNames := list "" }}
{{- if hasKey . "dbNames" }}
{{- $dbNames = index . "dbNames" }}
{{- else }}
{{- $dbNames = list $serviceName }}
{{- end -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "%s-%s" $serviceName "db-init" | quote }}
  namespace: {{ $envAll.Release.Namespace | quote }}
spec:
  template:
    spec:
      activeDeadlineSeconds: 100
      containers:
        {{- range $dbNames }}
        - name: {{ printf "%s-%s" .  "db-init" | replace "_" "-" | quote }}
          image: {{ include "common.images.kolla-toolbox" $envAll | quote }}
          imagePullPolicy: {{ $envAll.Values.pullPolicy }}
          command:
            - /bin/sh
            - -c
            - /tmp/db-init.sh
          env:
            - name: KOLLA_CONFIG_STRATEGY
              value: "COPY_ALWAYS"
            - name: ANSIBLE_LIBRARY
              value: /usr/share/ansible
            - name: KOLLA_SERVICE_NAME
              value: "kolla-toolbox"
            - name: PATH
              value: "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            - name: KOLLA_BASE_DISTRO
              value: "ubuntu"
            - name: KOLLA_DISTRO_PYTHON_VERSION
              value: "3.8"
            - name: KOLLA_BASE_ARCH
              value: "x86_64"
            - name: SETUPTOOLS_USE_DISTUTILS
              value: "stdlib"
            - name: DB_NAME
              value: {{ . }}
            - name: DB_USER
              value: {{ $envAll.Values.db_username | quote }}
            - name: DBATBASE_ENDPOINT
              valueFrom:
                secretKeyRef:
                  key: DATABASE
                  name: {{ $envAll.Values.openstackDepRelease | quote }}
            - name: DB_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: "mariadb-root-password"
                  name: {{ $envAll.Values.passwordRelease | quote }}
            - name: DB_USER_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: {{ printf "%s-database-password" $serviceName | quote }}
                  name: {{ $envAll.Values.passwordRelease | quote }}
          volumeMounts:
            - mountPath: /tmp
              name: pod-tmp
            - mountPath: /tmp/db-init.sh
              name: {{ $configMapBin | quote }}
              subPath: db-init.sh
            - mountPath: /etc/sudoers.d/kolla_ansible_sudoers
              name: {{ $configMapEtc | quote }}
              subPath: kolla-toolbox-sudoer
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
      - configMap:
          defaultMode: 0755
          name: {{ $configMapBin | quote }}
        name: {{ $configMapBin | quote }}
      - configMap:
          defaultMode: 0644
          name: {{ $configMapEtc | quote }}
        name: {{ $configMapEtc | quote }}
{{- end -}}
