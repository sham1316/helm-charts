{{- define "kub-lib.secret.body" }}
{{- $ := index . 0 }}
{{/*{{- $relname := .Release.Name -}}*/}}
{{/*{{- $relns := .Release.Namespace -}}*/}}

{{- $root := . -}}
{{- $secret := index . 1 }}
{{- if not (or $secret.data $secret.stringData) }}
{{ fail "data or stringData must be defined for secret" }}
{{- end }}
{{- if and $secret.data $secret.stringData }}
{{ fail "you must define only data or stringData nor both of them" }}
{{- end }}
---
apiVersion: v1
kind: Secret
type: {{ $secret.type | default "Opaque" }}
metadata:
  name: {{ $.Release.Name }}
  namespace: {{ $.Release.Namespace }}
  labels:
  {{- include "kub-lib.labels.common" $ | nindent 4 }}
  {{- if $secret.labels -}}
    {{- include "kub-lib.quoteValues" $secret.labels | indent 4 }}
  {{- end }}
  annotations:
  {{- include "kub-lib.annotations.common" $ | nindent 4 }}
  {{- if $secret.annotations -}}
    {{- include "kub-lib.quoteValues" $secret.annotations | indent 4 }}
  {{- end }}
  {{- if $secret.stringData }}
stringData:
    {{- toYaml $secret.stringData | nindent 2 }}
  {{- end }}
  {{- if $secret.data }}
data:
    {{- toYaml $secret.data | nindent 2 }}
  {{- end -}}
  {{- if eq $secret.immutable true }}
immutable: true
  {{- end }}
{{ end -}}

{{- define "kub-lib.secret" -}}
  {{- if .Values.secret -}}
    {{- if kindIs "slice" .Values.secret }}
      {{- range $secret := .Values.secret }}
        {{- include "kub-lib.secret.body" (list $ $secret) }} 
      {{- end }}
    {{- else }}
      {{ include "kub-lib.secret.body" (list $ .Values.secret) }} 
    {{- end }}
  {{- end }}
{{- end }}
