# K8s

Simple project that showcases CRD and custom operator functionalities for k8s

---
# crd.yaml (overview of our CRD resource)
- The CRD defines a custom resource called TLSCertificate with a group name example.com and a plural name tlscertificates.
- The resource is namespaced and contains three fields in its spec: commonName, dnsNames, and expirationDate.
- The commonName and expirationDate are required fields.
- This CRD is versioned, and the v1 version is served and stored in etcd.
- The schema uses OpenAPI validation to ensure the data is well-structured when the resource is created or modified.
- This CRD enables you to create, update, and manage TLS certificates as Kubernetes resources, which is useful in scenarios like managing SSL/TLS certificates for applications running in Kubernetes.
$ kubectl create -f ./crd.yaml

# object.yaml
- representation of our CRD
$ kubectl create -f ./object.yaml

# Controllers
controllers are control loops that manage the state of various resources within a cluster. Controllers ensure that the desired state of resources matches the actual state by constantly monitoring and reconciling resources. There are controllers for deployments, replicasets, jobs etc.

What Do Controllers Do?
1. Watch: Controllers watch the Kubernetes API server for changes to resources they manage (such as Pods, Deployments, Services, etc.).
2. Reconcile: Based on the current state of the system and the desired state defined by the user, controllers take necessary actions to bring the system into the desired state (e.g., creating or deleting resources, updating configurations).

# Operators
Operators: Operators are a special type of custom controller that manage the lifecycle of custom resources. So when you write your 'own controller' it is 'operator'. There are operators for cert-manager/horizontal pod autoscaler/prometheus operators etc. 

shell-operators examples:
https://github.com/flant/shell-operator/tree/main/examples

Structure of shell-operators are simple:
- Dockerfile that defines environemnt (e.g. python) and hooks file (that is triggered when something happens to our custom resource -> we defined those actions inside hooks script file)
- hooks/00-hook.py ()
- shell-operator-pod.yaml (pod containing our Docker image)
To build shell-operator:
$ docker build -t "registry.mycompany.com/shell-operator:startup-python" .
$ docker push registry.mycompany.com/shell-operator:startup-python
$ kubectl create -f ./shell-operator-pod.yaml
... you might also need to create Role and RoleBinding and ServiceAccount for you operator to have sufficent permissions to execute it's code against k8s

when we have our 1) CRD and 2)operator running in k8s cluster when we create new object representation of CRD operator will be triggered and run specified hook script code (our python script code will just print some info that we can see via command 'kubectl logs') -> this finalizes our project.


# K8s frameworks for building k8s controllers;
Kubebuilder is a framework for building Kubernetes APIs and controllers using Go. It simplifies writing Custom Resource Definitions (CRDs) and their associated operators by providing scaffolding, best practices, and integration with Kubernetes tools.  ... this tool is specialized and streamlined for Go-based Kubernetes operators
Operator-SDK is also another way to approach this topic. Use Operator SDK if you want to write operators in multiple languages (Go, Ansible, Helm, Java). You want to leverage existing Helm charts or Ansible playbooks for Kubernetes automation without writing custom Go code. This tool is a broader toolset for writing operators in various languages and using tools like Helm or Ansible.
Shell-operator is another tool that you can use to create custom controllers using e.g. shell
