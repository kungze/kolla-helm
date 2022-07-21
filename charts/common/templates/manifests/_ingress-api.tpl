{{- define "common.manifests.ingressApi" -}}
{{ $envAll := index . "envAll" }}
{{ $serviceName := index . "serviceName" }}
{{ $servicePort := index . "servicePort" }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $envAll.Release.Name }}
  namespace: {{ $envAll.Release.Namespace | quote }}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
spec:
  ingressClassName: {{ $envAll.Values.ingress.ingressClass }}
  rules:
    - http:
        paths:
          - path: {{ printf "/%s(/|$)(.*)" $envAll.Values.ingress.path }}
            pathType: Prefix
            backend:
              service:
                name: {{ printf "%s-api" $serviceName }}
                port:
                  number: {{ $servicePort }}
{{- end -}}
