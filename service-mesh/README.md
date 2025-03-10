# K8s


- **Service Mesh**  
A service mesh is a dedicated infrastructure layer for managing service-to-service communication in microservices architectures. It provides traffic management, security, observability, and resilience without modifying application code.
//Kubernetes uses service-to-service communication using its native networking model. Implementing Istio or another service mesh is beneficial when you need:

- **Enhanced Security:** Automatic mTLS for encrypting service-to-service traffic.
- **Advanced Traffic Management:** Fine-grained routing, retries, circuit breaking, and load balancing. (provides Canary Deployments, A/B testing and Fault Injection) 
- **Observability:** Detailed telemetry, logging, and tracing to monitor and debug microservices.
- **Policy Enforcement:** Centralized control over access and communication between services.


Popular Service Mesh Solutions:
Istio – Most popular, built on top of "Envoy" proxy.
Linkerd – Lightweight and Kubernetes-native.
Consul – Focuses on multi-platform service networking.
Kuma – Built on Envoy, simpler than Istio.

How Istio works:
- it deploys sidecar container for each microservice in your cluster

Project based on: https://www.youtube.com/watch?v=H4YIKwAQMKk


# Project:
- initialize eks cluster
- install helm repo (helm.sh file)
- install istio via terraform files in this repo (alternatively use helm commands in terraform files)
Check if istio was installed on cluster: 
$ kubectl get crds | grep 'istio.io'
$ kubectl get po -n istio-system
- deploy example-1 resources...
// those resources presents functionality of istio to manage traffic routing to application - virtual-service defines how much % of traffic goes to which service (via destination-rule setup)
- deploy example-2 resources ...
// those resources presents functionality of istio to inject istio sidecar into our deployment.In short, manually injecting the sidecar gives you the flexibility to include Istio’s features even in namespaces where automatic injection isn’t enabled.

... Further project ideas:
- Expose application using Istio Gateway
- use 'PodMonitor'