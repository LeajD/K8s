# Files explaination:

These files combine to demonstrate a typical Istio setup with advanced traffic management and routing:

client.yaml:
Defines a namespace ("backend") with Istio sidecar injection enabled and creates a pod (using a Curl image) used for testing or generating requests within the mesh.

virtual-service.yaml:
Configures a VirtualService that routes requests for the service "first-app". It splits traffic between two versions (subsets) defined via a DestinationRule. In this example, 100% of the traffic is routed to the v2 subset, enabling controlled deployment or A/B testing scenarios.

svc.yaml:
Declares a Kubernetes Service in the "staging" namespace for "first-app", which acts as a stable endpoint that the VirtualService directs traffic to.

ns.yaml:
Creates a namespace ("example-1") with labels enabling Prometheus monitoring and Istio sidecar injection. This ensures that pods deployed in this namespace automatically become part of the service mesh.

dp.yaml and dp2.yaml:
These are Deployments for "first-app" representing two different versions (v1 and v2). They include labels (e.g., version: v1/v2) that match the subsets defined in the DestinationRule. This mechanism allows Istio to distinguish between versions for routing purposes.

destination-rule.yaml:
Defines the DestinationRule for "first-app", declaring subsets corresponding to each app version (v1 and v2). These subsets facilitate granular traffic routing (e.g., directing different percentages of traffic to each version) based on the labels assigned in the deployments.

Together, these files illustrate how Istio manages service-to-service communication by automatically injecting sidecars, routing traffic based on defined rules, and enabling canary deployments or A/B testing—all without modifying the application code.