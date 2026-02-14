{{/*
Expand the name of the chart.
*/}}
{{- define "trmnl.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "trmnl.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "trmnl.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "trmnl.labels" -}}
helm.sh/chart: {{ include "trmnl.chart" . }}
{{ include "trmnl.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "trmnl.selectorLabels" -}}
app.kubernetes.io/name: {{ include "trmnl.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "trmnl.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "trmnl.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the TRMNL secret name
*/}}
{{- define "trmnl.secretName" -}}
{{- if .Values.terminus.existingSecret }}
{{- .Values.terminus.existingSecret }}
{{- else }}
{{- include "trmnl.fullname" . }}
{{- end }}
{{- end }}

{{/*
Return the TRMNL configmap name
*/}}
{{- define "trmnl.configmapName" -}}
{{- include "trmnl.fullname" . }}
{{- end }}

{{/*
Return the TRMNL image name
*/}}
{{- define "trmnl.image" -}}
{{- $registry := .Values.image.registry -}}
{{- $repository := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if $registry }}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- else }}
{{- printf "%s:%s" $repository $tag }}
{{- end }}
{{- end }}

{{/*
Return the PostgreSQL fully qualified name (subchart)
*/}}
{{- define "trmnl.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the DATABASE_URL for the application
*/}}
{{- define "trmnl.databaseUrl" -}}
{{- if .Values.db.internal.enabled }}
{{- printf "postgres://%s:%s@%s:5432/%s" .Values.postgresql.auth.username .Values.postgresql.auth.password (include "trmnl.postgresql.fullname" .) .Values.postgresql.auth.database }}
{{- else }}
{{- .Values.db.external.url }}
{{- end }}
{{- end }}

{{/*
Return the Valkey fully qualified name (subchart)
*/}}
{{- define "trmnl.valkey.fullname" -}}
{{- printf "%s-%s" .Release.Name "valkey" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the KEYVALUE_URL for the application
*/}}
{{- define "trmnl.valkeyUrl" -}}
{{- if .Values.valkey.enabled }}
{{- printf "redis://%s-master:6379" (include "trmnl.valkey.fullname" .) }}
{{- else }}
{{- "" }}
{{- end }}
{{- end }}
