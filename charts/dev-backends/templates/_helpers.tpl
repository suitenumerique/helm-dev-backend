{{/*
Expand the namespace of the release.
Allows overriding it for multi-namespace deployments in combined charts.
*/}}
{{- define "dev-backends.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}


{{/*
Create postgres name and version as used by the chart label.
Truncated at 52 chars because StatefulSet label 'controller-revision-hash' is limited
to 63 chars and it includes 10 chars of hash and a separating '-'.
*/}}
{{- define "dev-backends.postgres.fullname" -}}
{{- printf "%s-%s" (include "dev-backends.fullname" .) .Values.postgres.name | trunc 52 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create redis name and version as used by the chart label.
Truncated at 52 chars because StatefulSet label 'controller-revision-hash' is limited
to 63 chars and it includes 10 chars of hash and a separating '-'.
*/}}
{{- define "dev-backends.redis.fullname" -}}
{{- printf "%s-%s" (include "dev-backends.fullname" .) .Values.redis.name | trunc 52 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create minio name and version as used by the chart label.
Truncated at 52 chars because StatefulSet label 'controller-revision-hash' is limited
to 63 chars and it includes 10 chars of hash and a separating '-'.
*/}}
{{- define "dev-backends.minio.fullname" -}}
{{- printf "%s-%s" (include "dev-backends.fullname" .) .Values.minio.name | trunc 52 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create keycloak name and version as used by the chart label.
Truncated at 52 chars because StatefulSet label 'controller-revision-hash' is limited
to 63 chars and it includes 10 chars of hash and a separating '-'.
*/}}
{{- define "dev-backends.keycloak.fullname" -}}
{{- printf "%s-%s" (include "dev-backends.fullname" .) .Values.keycloak.name | trunc 52 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create dsproxy name and version as used by the chart label.
Truncated at 52 chars because StatefulSet label 'controller-revision-hash' is limited
to 63 chars and it includes 10 chars of hash and a separating '-'.
*/}}
{{- define "dev-backends.dsproxy.fullname" -}}
{{- printf "%s-%s" (include "dev-backends.fullname" .) .Values.dsproxy.name | trunc 52 | trimSuffix "-" -}}
{{- end -}}

{{/*
transform dictionnary of environment variables
Usage : {{ include "dev-backends.env.transformDict" .Values.envVars }}

Example:
envVars:
  # Using simple strings as env vars
  ENV_VAR_NAME: "envVar value"
  # Using a value from a configMap
  ENV_VAR_FROM_CM:
    configMapKeyRef:
      name: cm-name
      key: "key_in_cm"
  # Using a value from a secret
  ENV_VAR_FROM_SECRET:
    secretKeyRef:
      name: secret-name
      key: "key_in_secret"
*/}}
{{- define "dev-backends.env.transformDict" -}}
{{- range $key, $value := . }}
- name: {{ $key | quote }}
{{- if $value | kindIs "map" }}
  valueFrom: {{ $value | toYaml | nindent 4 }}
{{- else }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
dev-backends env vars
*/}}
{{- define "dev-backends.common.env" -}}
{{- $topLevelScope := index . 0 -}}
{{- $workerScope := index . 1 -}}
{{- include "dev-backends.env.transformDict" $workerScope.envVars -}}
{{- end }}