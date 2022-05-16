{{- define "common.manifests.serviceApi" -}}
{{ $envAll := index . "envAll" }}
{{ $serviceName := index . "serviceName" }}
{{ $servicePort := index . "servicePort" }}
apiVersion: v1
kind: Service
metadata:
  name: {{ printf "%s-api" $serviceName | quote }}
  namespace: {{ $envAll.Release.Namespace | quote }}
  labels: {{- include "common.labels.standard" $envAll | nindent 4 }}
spec:
  type: ClusterIP
  ports:
    - name: {{ printf "%s-api" $serviceName | quote }}
      port: {{ $servicePort }}
      protocol: TCP
      targetPort: {{ $servicePort }}
  selector: {{- include "common.labels.matchLabels" $envAll | nindent 4 }}
    app.kubernetes.io/component: {{ printf "%s-api" $serviceName | quote }}
{{- end -}}
