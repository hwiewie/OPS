curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
#kubectl version --client
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl kubeadm kubelet
systemctl enable --now kubelet
#master node
kubeadm init --pod-network-cidr=10.122.0.0/16 --service-cidr=10.10.0.0/16
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
#kubectl get pod --all-namespaces
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
#master node
firewall-cmd --zone=public --permanent --add-port={6443,2379,2380,10250,10251,10252}/tcp
firewall-cmd --permanent --add-port=53/udp
#work node
firewall-cmd --zone=public --permanent --add-port={10250,30000-32767}/tcp
#all node
firewall-cmd --add-masquerade --permanent
firewall-cmd --reload
