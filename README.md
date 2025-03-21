# K8s

- **cert-manager/**  
  Provides documentation and examples about deploying custom load balancer on AWS with custom certificate provided by cert-manager.

- **crd/**  
  Simple project that showcases CRD and custom operator functionalities for k8s.

- **encryption-explained/**  
  Provides documentation and examples detailing encryption techniques and configurations.

- **helm-charts/**  
  Holds Helm chart packages for deploying applications and services into Kubernetes clusters.

- **k8s-from-scratch/**  
  Features examples and tutorials for building and understanding Kubernetes components from the ground up.

- **service-mesh/**  
  Features demonstrating Istio as a service mesh on a Kubernetes cluster using Terraform and Helm.

- **k8s-Project/**  
  Contains raw Kubernetes YAML manifests for deploying monitoring, logging, securing and CI/CD systems for a k8s PoC cluster for Log Management solution with diagrams:
  
  - **GRAFANA/**  
    Includes configuration files for Grafana dashboards and datasources, such as [grafana.yml](manifests/GRAFANA/grafana.yml) and [monitor-grafana-datasource-cm.yml](manifests/GRAFANA/monitor-grafana-datasource-cm.yml).
    
  - **JENKINS/**  
    Contains the Jenkins deployment and service definitions, for example [jenkins.yml](manifests/JENKINS/jenkins.yml).
    
  - **MONITORING/**  
    Provides resources for monitoring, including Prometheus configuration ([prometheus-cm.yaml](manifests/MONITORING/prometheus-cm.yaml)), deployment ([prometheus-dp.yaml](manifests/MONITORING/prometheus-dp.yaml)), service definitions ([prometheus-svc.yaml](manifests/MONITORING/prometheus-svc.yaml)), and other monitoring tools such as Alertmanager and kube-state-metrics.
    
  - **TELK/**  
    Contains manifests for Elasticsearch, Logstash, and Kibana deployments, including service and deployment files like [elastic-0-dp.yaml](manifests/TELK/elastic-0-dp.yaml) and [elastic-0-svc.yaml](manifests/TELK/elastic-0-svc.yaml).

- **k8s-project** 

![k8s-project](k8s-project/kubernetes.jpg)

- **k8s-project-monitoring** 
![k8s-monitoring](k8s-project/monitoring.png)
- **k8s-project-security/** 
![k8s-security](k8s-project/security.png)
