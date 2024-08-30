{{/*
container image
*/}}
{{- define "kub-lib.image" -}}
{{- if .usebuilder }}
{{- $image := index .builder.images .name -}}
image: {{ (split "/" .registry)._0 }}/{{ $image.path }}:{{ $image.release_tag }}
{{- else }}
image: {{ .registry }}/{{ .repository }}:{{ .tag }}
{{- end }}
imagePullPolicy: {{ .pullPolicy }}
{{- end -}}

{{/*
container environment variables
*/}}
{{ define "kub-lib.env" }}
{{- if .env -}}
env:
{{- range $name, $envmap := .env }}
  - name: {{ $name }}
  {{- toYaml $envmap | nindent 4 }}
{{- end }}
{{- end -}}
{{ end }}

{{/*
Renders a value that contains template.
Usage:
{{ include "kub-lib.tplValue" .Values }}
*/}}
{{- define "kub-lib.tplValue" -}}
        {{- . | toYaml  }}
{{- end -}}

{{/*
Qute array values
*/}}
{{- define "kub-lib.quoteValues" -}}
{{- range $k, $v := . }}
{{ $k }}: {{ $v | quote }}
{{- end -}}
{{- end -}}

{{/*
Qute array
*/}}
{{- define "kub-lib.quote" -}}
{{- range $k, $v := . }}
{{ $k | quote }}: {{ $v | quote }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kub-lib.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
    dump variables
    example: {{- template "magda.var_dump" $var }}
*/}}
{{- define "magda.var_dump" -}}
{{- . | mustToPrettyJson | printf "\nThe JSON output of the dumped var is: \n%s" | fail }}
{{- end -}}