{{- define "kub-app-lib.env.TEMPLATE_SERVICE_PORT" -}}
- name: SERVICE_PORT
  value: "{{ .Values.service.port }}"
{{- end -}}

{{- define "kub-app-lib.env.TEMPLATE_MONITORING_PORT" -}}
- name: MONITORING_PORT
  value: "{{ .Values.monitoring.port }}"
{{- end -}}

{{- define "kub-app-lib.env.TEMPLATE_MONITORING_EXP" -}}
- name: MONITORING_EXP
  value: "{{ .Values.monitoring.exp}}"
{{- end -}}

{{- define "kub-app-lib.env.TEMPLATE_HAZELCAST" -}}
{{ $hazelcast_val := .Values.hazelcastEnv }}
{{- range $i, $v := $hazelcast_val }}
- name: {{ $v }}
  valueFrom:
    configMapKeyRef:
      name: {{ template "kub-app.fullname" $ }}
      key: {{ $v }}
{{- end }}
{{- end }}

{{- define "kub-app-lib.env.inline" -}}
{{- range $key, $val := . }}
- name: {{ $key }}
  value: {{ $val | quote}}
{{- end -}}
{{- end -}}

{{- define "kub-app-lib.env" }}
{{- range  .Values.env -}}
{{- if eq ( . | typeOf) "map[string]interface {}" -}}
{{- include "kub-app-lib.env.inline" . }}
{{- else if contains "TEMPLATE" . }}
{{- $envName := print "kub-app-lib.env." . }}
{{ include $envName $ }}
{{- else }}
- name: {{ . }}
  valueFrom:
    configMapKeyRef:
      name: {{ template "kub-app.fullname" $ }}
      key: {{ . }}
{{- end }}
{{- end }}
{{- end }}

{{- define "kub-app-lib.env.secrets" }}
{{- $eternalSecretName := .Values.externalSecretName }}
{{- range  .Values.secretEnv }}
- name: {{ . }}
  valueFrom:
    secretKeyRef:
      name: {{ $eternalSecretName }}
      key: {{ . }}
{{- end }}
{{- end }}

{{- define "kub-app-lib.env.TEMPLATE_POSTGRES" -}}
{{- $postgresExternalSecretName := .Values.postgresExternalSecretName -}}
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: {{ $postgresExternalSecretName }}
      key: USER
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ $postgresExternalSecretName }}
      key: PASS
- name: _DB_URL
  valueFrom:
    secretKeyRef:
      name: {{ $postgresExternalSecretName }}
      key: URL
- name: DB_URL
  value: ${_DB_URL}&ApplicationName={{ include  "kub-app.nameNamespace" . }}
- name: _URLR2DB
  valueFrom:
    secretKeyRef:
      name: {{ $postgresExternalSecretName }}
      key: URLR2db
- name: R2DB_URL
  value: ${_URLR2DB}&ApplicationName={{ include  "kub-app.nameNamespace" . }}
{{- end -}}
