# Deploying K8s Cluster Guideline using Kubeadm:

Documentation:
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/control-plane-flags/


# Requirements:
- Linux compatible host + 2GB RAM + 2 CPU + network connectivity between machines (public or private network)
Check system configureation:
- Unique hostname, MAC address, and product_uuid for every node
$ ifconfig -a
$ cat /sys/class/dmi/id/product_uuid
- Ports open on machines: 
https://kubernetes.io/docs/reference/networking/ports-and-protocols/
Example command:
$ nc 127.0.0.1 6443 -v
- swap should either be disabled or tolerated by kubelet (to tolerate swap add failSwapOn: false to kubelet configuration)
$ setenforce 0
$ sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
- install container runtime (software that runs container images on a node)
https://kubernetes.io/docs/setup/production-environment/container-runtimes/
- enable IPv4 packet forwarding:
$ cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
$ sysctl --system
$ sysctl net.ipv4.ip_forward
- check "cgroup driver" setting (cgroupfs or systemd, by default it's cgroupfs, it's used to enforce resource management for pods and containers and set resources such as cpu/memory requests and limtis ). 
//The cgroupfs driver is not recommended when systemd is the init system because systemd expects a single cgroup manager on the system. Additionally, if you use cgroup v2, use the systemd cgroup driver instead of cgroupfs
//If you configure systemd as the cgroup driver for the kubelet, you must also configure systemd as the cgroup driver for the container runtime
Containerd installation: (you can use apt/yum for that, but for detailed guideline what containerd has 'under the hood' to install (tools like containerd,runc and cni plugins) check following github instruction)
https://github.com/containerd/containerd/blob/main/docs/getting-started.md
- install kubeadm (command to bootstrap the cluster), kubelet (runs on each machine in cluster and does things like starting pods and containers), kubectl (command line utility to talk to your cluster) (ensure they match the version of the Kubernetes control plane you want kubeadm to install for you)
... add kubernetes yum repository to install following packages (check https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/ )
$ yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
$ systemctl enable --now kubelet

# Cluster installation (control-plane)

//(Recommended) If you have plans to upgrade this single control-plane kubeadm cluster to high availability you should specify the --control-plane-endpoint to set the shared endpoint for all control-plane nodes. Such an endpoint can be either a DNS name or an IP address of a load-balancer.
//Choose a Pod network add-on, and verify whether it requires any arguments to be passed to kubeadm init. Depending on which third-party provider you choose, you might need to set the --pod-network-cidr to a provider-specific value
Example kubeadm init command:
$ kubeadm init \
  --apiserver-advertise-address=<CONTROL_PLANE_IP> \
  --pod-network-cidr=10.244.0.0/16 \
  --control-plane-endpoint=<LOAD_BALANCER_DNS_OR_IP>:6443 \
  --kubernetes-version v1.32.0
// --control-plane-endpoint is not required

When this commands executes successfully you get commands "mkdir, cp and chown" for "$HOME/.kube/config" -> run them in order to have kubectl access to cluster
Also you get "kubeadm join" command printed out that you can use to join other cluster nodes (you can later generate such command using "kubeadm create token --print-join-command" command)

Deploy Container Network Interface (CNI) based Pod network add-on so that your pdos can communicate with each other. Cluster DNS (coreDNS) will not start beore a network is installed.
//By default, kubeadm sets up your cluster to use and enforce use of RBAC (role based access control). Make sure that your Pod network plugin supports RBAC, and so do any manifests that you use to deploy it. Most used CNI are calico, flannel and weave. To deploy calico:
$ kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
//By default, your cluster will not schedule Pods on the control plane nodes for security reasons

(Optionally) you can also install kubernetes Metrics API
$ kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
$ kubectl top pods && kubectl top nodes

Cluster is ready using basic, default configuration:
$ kubectl get nodes && kubectl get pods

# Customize cluster components:
Refer to /etc/kubernetes/ and /etc/kubernetes/manifests files for flags and arguments passed to components such as  "api-server", "controller-manager", "scheduler", "kubelet" and "etcd".

# Upgrade procedures:
https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/

# Certificate Management:
https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/

# HA (Highly Available) Topology options:
- With stacked control plane nodes, where etcd nodes are colocated with control plane nodes
- With external etcd nodes, where etcd runs on separate nodes from the control plane
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/