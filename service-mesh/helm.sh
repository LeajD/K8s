$ helm repo add istio https://istio-release.storage.googleapis.com/charts
$ helm search repo istio/base 
$ helm show values istio/base --version 1.17.1 > istio-base-default.yaml
$ helm show values istio/istiod --version 1.17.1 > istiod-default.yaml
#$ helm show values istio/gateways --version 1.17.1 > gateways-default.yaml #gateway not used in this project, but can be used to expose services outside the mesh