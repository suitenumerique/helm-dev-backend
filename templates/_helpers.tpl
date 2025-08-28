{{/*
Expand the namespace of the release.
Allows overriding it for multi-namespace deployments in combined charts.
*/}}
{{- define "dev-backends.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}


{{/*
Create controller name and version as used by the chart label.
Truncated at 52 chars because StatefulSet label 'controller-revision-hash' is limited
to 63 chars and it includes 10 chars of hash and a separating '-'.
*/}}
{{- define "dev-backends.postgres.fullname" -}}
{{- printf "%s-%s" (include "dev-backends.fullname" .) .Values.postgres.name | trunc 52 | trimSuffix "-" -}}
{{- end -}}
