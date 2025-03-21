# K8s

- **helm-charts/**  
  Holds Helm chart packages for deploying applications and services into Kubernetes clusters.



helm allows for easy deployment of complex configurations.
A Chart is a collection of files to deploy an application

Example repo to search current charts avaialable there:
$  helm search hub database

Add custom repo:
$  helm repo add ealenn https://ealenn.github.io/charts
$ helm repo update

Deploy example chart:
$ helm upgrade -i tester ealenn/echo-server --debug

//downloaded charts goes into compressed tarball under user's home directory "$HOME/.cache/helm/repository/..."

Check running charts:
$ helm list






# Custom Helm Chart:
Create a Helm chart that deploys a simple NGINX web server on Kubernetes. The Helm chart will allow configuration of different parameters (such as the number of replicas, image version, and service type) to demonstrate the flexibility and power of Helm.





1. Set Up Helm
Before you begin, ensure that you have Helm installed on your local machine and that it’s configured to interact with your Kubernetes cluster.


# Install Helm (if not installed)
# Add Helm chart repositories (optional, for extra charts)

$ helm repo add stable https://charts.helm.sh/stable
$ helm repo update

2. Create a New Helm Chart
Use the Helm CLI to create a new chart.

$ helm create nginx-webapp

This will create a new Helm chart directory structure:


nginx-webapp/
  ├── Chart.yaml
  ├── charts/
  ├── templates/
  ├── values.yaml
  └── charts/


3. Customize the Helm Chart
You will now customize this Helm chart to deploy an NGINX web server.

3.1. Modify values.yaml
This file will contain the configurable parameters for your chart. Here’s an example values.yaml for the NGINX deployment:
# values.yaml
```

replicaCount: 1
image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: ""

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  create: true
  annotations: {}
  name: ""

podAnnotations: {}
podSecurityContext: {}
securityContext: {}

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  className: ""
  annotations: {}
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: []

resources: {}

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80

nodeSelector: {}
tolerations: []
affinity: {}
```

3.2. Modify deployment.yaml (Template)
You will customize the Deployment template to use the values from values.yaml. Update the nginx-webapp/templates/deployment.yaml file:

# nginx-webapp/templates/deployment.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "nginx-webapp.fullname" . }}
  labels:
    {{- include "nginx-webapp.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "nginx-webapp.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "nginx-webapp.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "nginx-webapp.serviceAccountName" . }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
```

3.3. Modify service.yaml (Template)
Customize the Service template to use values from values.yaml for configuring the service type and port.

# nginx-webapp/templates/service.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: {{ include "nginx-webapp.fullname" . }}
  labels:
    {{- include "nginx-webapp.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "nginx-webapp.selectorLabels" . | nindent 4 }}
```

4. Install the Helm Chart
Now that the Helm chart is ready, you can deploy it to your Kubernetes cluster. First, make sure your cluster is set up and accessible.

# Install the Helm chart (with default values)
$ helm install nginx-webapp ./nginx-webapp

You can also pass values during installation to customize the deployment, such as the number of replicas or the image tag:
$ helm install nginx-webapp ./nginx-webapp --set replicaCount=3 --set image.tag=stable


6. Create an Ingress Resource
If you want to enable external access to your app, you can create an Ingress resource.

# nginx-webapp/templates/ingress.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "nginx-webapp.fullname" . }}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
    - host: {{ .Values.ingress.hosts[0].host }}
      http:
        paths:
          - path: {{ .Values.ingress.hosts[0].paths[0] }}
            pathType: Prefix
            backend:
              service:
                name: {{ include "nginx-webapp.fullname" . }}
                port:
                  number: 80
```

Enable ingress in values.yaml:
```
ingress:
  enabled: true
  hosts:
    - host: nginx.local
      paths:
        - /
```

7. Package the Helm Chart
Once you're satisfied with your Helm chart, you can package it for reuse or distribution:

$ helm package ./nginx-webapp

This will create a .tgz file that you can share with others or upload to a Helm repository.


8. Advanced Features (Optional)
You can extend the chart with the following advanced features:

ConfigMaps/Secrets: Use Helm to manage application configuration via ConfigMap or Secret.
Helm Hooks: Add hooks to manage resources during the deployment lifecycle (e.g., for database migrations).
Chart Dependencies: Use dependencies to include other charts like a Redis or PostgreSQL chart.
CI/CD Integration: Integrate Helm chart deployment into a CI/CD pipeline (e.g., Jenkins, GitLab CI).
Project Deliverables
Helm Chart: A reusable Helm chart that deploys a simple NGINX web application.
Deployment Customization: Demonstrates the ability to customize the application with different values (replicas, image tags, etc.).
Ingress Support: Optionally include ingress support for external access.
Packaging: Package the Helm chart for reuse or sharing.
CI/CD Integration: (Optional) Add Helm chart deployment into a CI/CD pipeline.
This project demonstrates your ability to work with Helm charts to manage Kubernetes resources and provides flexibility for the deployment and configuration of applications.