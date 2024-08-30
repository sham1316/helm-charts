{{- define "kub-lib.serviceaccount" -}}
{{- if .Values.serviceaccount.enabled -}}
{{- $root := . -}}
{{- $serviceaccount := .Values.serviceaccount -}}
apiVersion: v1
kind: ServiceAccount
{{-   if .Values.serviceaccount.imagepullsecrets }}
imagePullSecrets:
  - name: {{ .Values.serviceaccount.imagepullsecrets }}
{{-   end }}
{{ include "kub-lib.metadata" (merge (dict "annotations" $serviceaccount.annotations ) $root) }}
{{- end -}}
{{- end -}}
