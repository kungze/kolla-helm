{{- define "common.manifests.job_register" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $dependencySvcs := index . "dependencySvcs" -}}
{{- $podCommands := index . "podCommands" | default false -}}
{{- $keystoneRelease := $envAll.Values.keystoneRelease | default $envAll.Release.Name -}}
{{- $podEnvVars := index . "podEnvVars" | default false -}}
{{- $podVolMounts := index . "podVolMounts" | default false -}}
{{- $configMapBin := index . "configMapBin" | default (printf "%s-%s" $serviceName "bin" ) -}}
{{- $configMapEtc := index . "configMapEtc" | default (printf "%s-%s" $serviceName "etc" ) -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "%s-%s" $serviceName "register" | quote }}
  namespace: {{ $envAll.Release.Namespace | quote }}
spec:
  template:
    spec:
      activeDeadlineSeconds: 200
      containers:
        - name: {{ printf "%s-%s" $serviceName "register" | quote }}
          image: {{ include "common.images.kolla-toolbox" $envAll | quote }}
          imagePullPolicy: {{ $envAll.Values.pullPolicy }}
          securityContext:
            runAsUser: 0
          command:
{{- if $podCommands }}
{{ $podCommands | toYaml | indent 12 }}
{{- end }}
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
            - name: OS_USERNAME
              valueFrom:
                secretKeyRef:
                  key: OS_USERNAME
                  name: {{ $keystoneRelease }}
            - name: OS_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: keystone-admin-password
                  name: {{ $envAll.Values.passwordRelease }}
            - name: OS_AUTH_URL
              valueFrom:
                secretKeyRef:
                  key: OS_CLUSTER_URL
                  name: {{ $keystoneRelease }}
            - name: OS_REGION_NAME
              valueFrom:
                secretKeyRef:
                  key: OS_REGION_NAME
                  name: {{ $keystoneRelease }}
            - name: OS_PROJECT_DOMAIN_NAME
              valueFrom:
                secretKeyRef:
                  key: OS_PROJECT_DOMAIN_NAME
                  name: {{ $keystoneRelease }}
            - name: OS_PROJECT_NAME
              valueFrom:
                secretKeyRef:
                  key: OS_PROJECT_NAME
                  name: {{ $keystoneRelease }}
            - name: OS_USER_DOMAIN_NAME
              valueFrom:
                secretKeyRef:
                  key: OS_USER_DOMAIN_NAME
                  name: {{ $keystoneRelease }}
            - name: OS_DEFAULT_DOMAIN
              valueFrom:
                secretKeyRef:
                  key: OS_DEFAULT_DOMAIN
                  name: {{ $keystoneRelease }}
{{- if $podEnvVars }}
{{ $podEnvVars | toYaml | indent 12 }}
{{- end }}
          volumeMounts:
            - mountPath: /tmp
              name: pod-tmp
            - mountPath: /etc/sudoers.d/kolla_ansible_sudoers
              name: {{ $configMapEtc }}
              subPath: kolla-toolbox-sudoer
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
            - name: INTERFACE_NAME
              value: eth0
            - name: PATH
              value: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/
            - name: DEPENDENCY_SERVICE
              value: {{ include "common.utils.joinListWithComma" $dependencySvcs | quote }}
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
