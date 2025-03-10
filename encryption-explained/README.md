# K8s

- **encryption-explained/**  
  Provides documentation and examples detailing encryption techniques and configurations.

Sealed Secrets

# Issue with K8s Secrets
They are base64-encoded, not encrypteed so anyone with access to manifests/k8s endpoint can read them.

# What problem does SealedSecrets solve:
Storing secrets in git repository (as a public place)

# What problem does SealedSecrets not solve:
Storing 'secrets' k8s resources in base64-encoded format so anyone with K8s API access can still read them after secrets are decrypted from SealedSecrets resource.

# SealedSecrets components:
1. Operator -> ensures decryption/encryption of secrets (manages public and private keys)
2. Kubeseal -> CLI Tool to encrypt secrets
3. CRD "SealedSecrets" - custom resource that stores secrets in encrypted format (by using private key) -> those resources can be securely stored in git repository for gitops ArgoCD approach


# How to use SealedSecrets:
1. Install SealedSecrets via 'helm.sh' commands (https://artifacthub.io/packages/helm/bitnami-labs/sealed-secrets)
2. Install kubeseal (https://github.com/bitnami-labs/sealed-secrets)

Check public cert used for encryption:
$ kubeseal --fetch-cert --controller-name my-release-sealed-secrets --controller-namespace default 
Generate k8s secret:
kubectl create secret generic database -n default --from-literal=DB_PASSWORD=pass123 --dry-run=client -o yaml > secret.yaml
Generate SealedSecrets:
$ kubeseal --controller-name my-release-sealed-secrets --controller-namespace default --format yaml < secret.yaml > sealed-secret.yaml
//we get encrypted secret