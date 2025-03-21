# K8s

# How does cert-manager work:
- Issuers & ClusterIssuers: Define certificate authorities (e.g., Let's Encrypt) to request certificates
// if we want to use 'self-sign' or 'Let's Encrypt' we specify it in cluster-issuer resource
//For self-signed certificates (via the ca issuer), cert-manager uses Go's crypto libraries to create and sign the certificate. It does not invoke openssl. cert-manager requests a domain validation challenge (such as HTTP-01 or DNS-01) to prove domain ownership.
//For ACME certificates (e.g., Let's Encrypt), cert-manager uses the ACME protocol to request certificates from a CA, such as Let's Encrypt. It does not use openssl for the certificate generation process.
- Certificate Requests: When a Certificate resource is created, cert-manager requests a TLS certificate from the configured Issuer
- Challenges: If using ACME (e.g., Let's Encrypt), cert-manager performs domain validation via HTTP-01 (temporary pod) or DNS-01 (TXT record in DNS)
- Certificate Issuance: Once validated, the CA issues the certificate, which cert-manager stores as a Kubernetes Secret (and we can use it as a mounted secret for our web-servers)
- Renewal: cert-manager automatically renews certificates before expiration

Based on Cert-manager tutorial for Let's Ecnrypt and EKS on AWS:
https://cert-manager.io/docs/tutorials/getting-started-aws-letsencrypt/


# AWS Part:
Set the default output format and region:
$ aws configure

Create eks cluster:
//run eksctl.sh file

Install cert-manager:
//run helm.sh file 

Create test ClusterIssuer and a Certificate:
//create your first certificate. This will be a self-signed certificate but later we'll replace it with a Let's Encrypt signed certificate:

Deploy 'certificate' and 'cluster-issuer'
//create certificate.yaml and cluster-issuer.yaml via kubectl
//make sure to change "$DOMAIN_NAME"

When successfull we get "Secret" resource called "www-tls"
$ kubectl get secret www-tls

Check certificate status
$ kubectl get certificate www

Deploy web-server:
//create dp.yaml via kubectl

At this moment we get 443 access via our load balancer and we can see generated custom certificate, but it's not trusted.

$ curl --insecure -v $LOAD_BALANCER_DNS
//You should see that the certificate has the expected DNS names and that it is self-signed


# Trusted certificate via Let's Ecnrypt for TLS production certificate:
https://cert-manager.io/docs/tutorials/getting-started-aws-letsencrypt/
