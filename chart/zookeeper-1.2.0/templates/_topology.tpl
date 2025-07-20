{{/*设置组件label中的key*/}}
{{- define "middleware.key" -}}
app
{{- end }}


{{/*设置组件label中的name*/}}
{{- define "middleware.name" -}}
{{ template "zookeeper.fullname" . }}
{{- end }}

{{- define "middlware.whenUnsatisfiable" }}
{{- if eq .Values.podAntiAffinity "hard"}}
  whenUnsatisfiable: DoNotSchedule
{{- else if eq .Values.podAntiAffinity "soft"}}
  whenUnsatisfiable: ScheduleAnyway
{{- end }}
{{- end }}


{{- define "middlware.tolerations" }}
{{- with .Values.pod.tolerations }}
tolerations:
{{- toYaml .| nindent 0  }}
{{- end }}
{{- end }}

{{/*zookeeper拓扑设置*/}}
{{- define "middlware.topologySpreadConstraints" }}
{{- if eq (semverCompare ">= 1.19-0" .Capabilities.KubeVersion.Version) true }}
topologySpreadConstraints:
{{- if ne .Values.podAntiAffinityTopologKey "kubernetes.io/hostname"}}
- maxSkew: 1
  topologyKey: {{ .Values.podAntiAffinityTopologKey | default "" }}
  {{- include "middlware.whenUnsatisfiable" . }}
  labelSelector:
    matchLabels:
      {{ include "middleware.key" . }}: {{ include "middleware.name" . }}
{{- end }}
- maxSkew: 1
  topologyKey: "kubernetes.io/hostname"
  {{- include "middlware.whenUnsatisfiable" . }}
  labelSelector:
    matchLabels:
      {{ include "middleware.key" . }}: {{ include "middleware.name" . }}
{{- if .Values.nodeAffinity }}
affinity:
  {{- with .Values.nodeAffinity }}
  nodeAffinity:
  {{- toYaml . | nindent 8 }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*zookeeper亲和性设置*/}}
{{- define "middlware.affinity" }}
{{- if eq (semverCompare ">= 1.19-0" .Capabilities.KubeVersion.Version) false }}
affinity:
  {{- if eq .Values.podAntiAffinity "hard"}}
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - topologyKey: {{ .Values.podAntiAffinityTopologKey }}
      labelSelector:
        matchExpressions:
        - key: {{ include "middleware.key" . }}
          operator: In
          values:
          - {{ include "middleware.name" . }}
  {{- else if eq .Values.podAntiAffinity "soft"}}
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        topologyKey: {{ .Values.podAntiAffinityTopologKey }}
        labelSelector:
          matchExpressions:
          - key: {{ include "middleware.key" . }}
            operator: In
            values:
            - {{ include "middleware.name" . }}
  {{- end }}
  {{- with .Values.nodeAffinity }}
  nodeAffinity:
  {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
{{- end }}

{{/*zookeeper组件拓扑分布*/}}
{{- define "middlware.topologyDistribution" }}
{{- include "middlware.tolerations" . -}}
{{- include "middlware.topologySpreadConstraints" . -}}
{{- include "middlware.affinity" . -}}
{{- end }}










