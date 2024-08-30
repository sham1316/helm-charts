{{- /*
pick a name
*/ -}}
{{- define "kub-lib.name" -}}
{{- if .canaryversion }}
{{- printf "%s-%s" .Release.Name ( .canaryversion | toString ) }}
{{- else if .customsuffix }}
{{- printf "%s-%s" .Release.Name ( .customsuffix | toString ) }}
{{- else if .use_https }}
{{- $.Release.Name }}-ssl
{{- else }}
{{- $.Release.Name }}
{{- end }}
{{- end }}

{{- /*
kub-lib.annotations.common prints the common Helm and wide chart annotations.
*/ -}}
{{- define "kub-lib.annotations.common" -}}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
helm.sh/chart: {{ include "kub-lib.chart" . }}
{{- end -}}

{{- /*
kub-lib.labels.common prints the common Helm labels and global chart extraLabels.
The common labels are frequently used in metadata.
*/ -}}
{{- define "kub-lib.labels.common" -}}
helm.sh/chart: {{ include "kub-lib.chart" . }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
{{ include "kub-lib.labels.matchLabels" . }}
{{- if .Values.extraLabels }}
{{ toYaml .Values.extraLabels }}
{{- end }}
{{- end -}}

{{- define "kub-lib.labels.matchLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .canaryversion }}
canaryversion: {{ .canaryversion }}
{{- end }}
{{- end -}}

{{- /*
kub-lib.metadata creates a metadata header.
It creates a 'metadata:' section with name and labels.
*/ -}}
{{- define "kub-lib.metadata" -}}
metadata:
  annotations:
{{ include "kub-lib.annotations.common" . | indent 4 }}
{{- if .annotations -}}
{{ include "kub-lib.quoteValues" .annotations | indent 4 }}
{{- end }}
  name: {{ include "kub-lib.name" . }}
  namespace: {{ .Release.Namespace }}
  labels:
{{ include "kub-lib.labels.common" . | indent 4 }}
{{- if .labels }}
{{ toYaml .labels | indent 4 }}
{{- end }}
{{- end -}}

{{- /*
kub-lib.metadata creates a metadata header.
It creates a 'metadata:' section with name (optional argument) and labels.
*/ -}}
{{- define "kub-lib.metadata.namearg" -}}
{{- $contextArg := index . 0 }}
{{- $args := dict }}
  {{- if ge (len .) 2 }}{{ $args = index . 1 }}{{ end -}}
metadata:
  annotations:
{{ include "kub-lib.annotations.common" $contextArg | indent 4 }}
{{- if $contextArg.annotations -}}
{{ include "kub-lib.quoteValues" $contextArg.annotations | indent 4 }}
{{- end }}
  name: {{ get $args "name" | default (include "kub-lib.name" $contextArg) }}
  namespace: {{ $contextArg.Release.Namespace }}
  labels:
{{ include "kub-lib.labels.common" $contextArg | indent 4 }}
{{- if $contextArg.labels }}
{{ toYaml $contextArg.labels | indent 4 }}
{{- end }}
{{- end -}}
1`11`