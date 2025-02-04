{{- define "kub-app-lib.env.SERVICE_PORT" -}}
- name: SERVICE_PORT
  value: "{{ .Values.service.port }}"
{{- end -}}

{{- define "kub-app-lib.env.MONITORING_PORT" -}}
- name: MONITORING_PORT
  value: "{{ .Values.monitoring.port}}"
{{- end -}}

{{- define "kub-app-lib.env.MONITORING_EXP" -}}
- name: MONITORING_EXP
  value: "{{ .Values.monitoring.exp}}"
{{- end -}}

{{- define "kub-app-lib.env.MONGO_URL" -}}
- name: MONGO_URL
  valueFrom:
    configMapKeyRef:
      name: {{ template "kub-app.fullname" $ }}
      key: MONGO_URL
{{- end -}}

{{- define "kub-app-lib.env.SWAGGER_BASE_URL" -}}
- name: SWAGGER_BASE_URL
  valueFrom:
    configMapKeyRef:
      name: {{ template "kub-app.fullname" $ }}
      key: SWAGGER_BASE_URL
{{- end -}}

{{- define "kub-app-lib.env.POSTGRES" -}}
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
  value: ${_DB_URL}&ApplicationName={{ include  "kub-app.name" . }}
{{- end -}}
