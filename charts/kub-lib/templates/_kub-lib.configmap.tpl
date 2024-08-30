{{- define "kub-lib.configmap" -}}

{{- if .Values.configMap.enabled }}

{{- $root := . -}}
{{- $relname := .Release.Name -}}
{{- $relns := .Release.Namespace -}}
{{- /*
realisation of canary releases
in this loop config map values and configmap from canary merged
*/}}
{{- range $version, $config := .Values.canary }}
{{- $root := merge  (dict "canaryversion" $version) $root  }}
{{- $configMap := merge $config.configMap $root.Values.configMap  }}
apiVersion: v1
kind: ConfigMap
{{- /*
check for annotations key in merged config map dict (values + canary)
merge annotations with root scope and pass it no metadata template for custom annotations support
remove annotations key from configmap
*/}}
{{- if $configMap.annotations }}
{{- $configMapAnnotations := $configMap.annotations }}
{{- $_ := unset $configMap "annotations" }}
{{ include "kub-lib.metadata" (merge (dict "annotations" $configMapAnnotations) $root) }}
{{- else }}
{{ include "kub-lib.metadata" $root -}}
{{- end }}
{{- if $configMap }}
data:
{{- /*
loop over configmap (canary + values)
each key in configmap become a separate file
because of that we remove "enabled" and "annoation" keys from configmap early
*/}}
{{- $_ := unset $configMap "enabled" }}
{{- range $filename, $content := $configMap }}
  {{ $filename }}: |
{{ tpl $content $ | indent 4 }}
{{- end }}
{{- end }}
{{- end }}

---
{{- end }}
{{- end }}
