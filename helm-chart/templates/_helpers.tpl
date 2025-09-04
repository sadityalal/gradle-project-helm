{{/* Define the full name for the app */}}
{{- define "gradle-app.fullname" -}}
{{- printf "%s" .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "myimage" -}}
{{ .Values.image.repository }}/{{ .Values.image.name }}:{{ .Values.image.tag }}
{{- end -}}

{{- define "mylabels" -}}
{{ .Values.labels | toYaml }}
{{- end -}}

{{- define "servicePorts" -}}
{{- range .Values.service.ports }}
- port: {{ .port }}
  targetPort: {{ .targetPort }}
  protocol: {{ .protocol | default "TCP" }}
  {{- if .nodePort }}
  nodePort: {{ .nodePort }}
  {{- end }}
{{- end }}
{{- end }}


{{- define "envsecret" -}}
{{- if .Values.secrets.enabled }}
{{- range $key, $value := .Values.secrets.env }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Values.secrets.name }}
      key: {{ $value }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "servicedns" -}}
{{ .Values.labels.app }}-svc.{{ .Values.namespace }}.svc.cluster.local
{{- end -}}


