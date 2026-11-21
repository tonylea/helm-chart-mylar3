{{- define "mylar3.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mylar3.labels" -}}
{{ include "mylar3.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end }}

{{/* Without the chart's version, so a release that changes only the chart doesn't restart Mylar3. */}}
{{- define "mylar3.podLabels" -}}
{{ include "mylar3.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "mylar3.claimName" -}}
{{- $root := index . 0 }}
{{- $name := index . 1 }}
{{- (index $root.Values.persistence $name).existingClaim | default (printf "%s-%s" $root.Release.Name $name) }}
{{- end }}
