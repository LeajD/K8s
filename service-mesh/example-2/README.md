# Files explaination
The files demonstrate how to enable Istio's sidecar injection and observability features for an application deployed in a namespace where automatic injection is not enabled:

ns.yaml:
Creates a "dev" namespace without the istio-injection label. This means that by default, pods in this namespace won't get an Istio sidecar automatically.

dp.yaml:
Deploys "myapp-v1" in the "dev" namespace. It includes the annotation sidecar.istio.io/inject: "true" in its pod metadata, which forces Istio to inject the Envoy sidecar into the pod. This allows the application to benefit from Istio features (such as traffic management, security, and observability) even though the namespace isn’t automatically enabling sidecar injection.

Together, these files show how you can explicitly request Istio sidecar injection for applications, giving you fine-grained control over which workloads participate in the service mesh.

In short, manually injecting the sidecar gives you the flexibility to include Istio’s features even in namespaces where automatic injection isn’t enabled.

to manually inject istio sidecar you can also not specify labels but run:
$ istioctl kube-inject -f $DP_FILE.yaml | kubectl apply -f -


