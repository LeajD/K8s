# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# helm install my-istio-base-release -n istio-system --create-namespace istio/base --set global.istioNamespace=istio-system
resource "helm_release" "istio_base" {
  name = "my-istio-base-release"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base" #helm repository on your k8s cluster
  namespace        = "istio-system" #ns to deploy resources
  create_namespace = true
  version          = "1.17.1"
    # to override the default values in the chart:
  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }
}