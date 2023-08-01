# RKE2 Kubernetes Installation 
This tutorial's steps are as follows:
1. Prerequisites
2. All servers configuration
3. First control plane node configuration
4. Additional nodes configuration
6. Run RKE2 server/agent services
7. Check RKE2 cluster status

## Prerequisites
* RedHat 8+
* CentOS 8+

## All servers configuration

### Obtain the RKE2 binary
For each of the nodes, either download the RKE2 binary or use the following command to download and install the latest version of RKE2:
```bash
yum install -y wget
wget https://github.com/rancher/rke2/releases/download/v1.27.4%2Brke2r1/rke2.linux-amd64
mv rke2.linux-amd64 /usr/bin/rke2
chmod +x /usr/bin/rke2
mkdir -p /etc/rancher/rke2
```

### Configure image registry credentials
Configure the image registry credentials using the following command:
```bash
cat <<EOF > /etc/rancher/rke2/registries.yaml
configs:
  identiq-docker.jfrog.io:
    auth:
      username: <username>
      password: <password>
EOF
```

### Configure the RKE2 service unit files
Configure the following service unit files for `rke2-server` and `rke2-agent`:
```bash
cat <<EOF > /etc/systemd/system/rke2-agent.service
[Unit]
Description=Rancher Kubernetes Engine (RKE2) Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/etc/rancher/rke2
ExecStart=/usr/bin/rke2 agent
Restart=always

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/systemd/system/rke2-server.service
[Unit]
Description=Rancher Kubernetes Engine (RKE2) Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/etc/rancher/rke2
ExecStart=/usr/bin/rke2 server
Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

## First control plane node configuration
On the first node, configure the RKE2 files using the following command:
```bash
cat <<EOF > /etc/rancher/rke2/config.yaml
token: Identiq123
system-default-registry: identiq-docker.jfrog.io
disable:
  - rke2-ingress-nginx
  - rke2-metrics-server
EOF
```

## Additional nodes configuration
For each of the additional control plane nodes, configure the RKE2 files using the following command:
```bash
cat <<EOF > /etc/rancher/rke2/config.yaml
token: Identiq123
server: https://<first-node-ip>:9345
system-default-registry: identiq-docker.jfrog.io
disable:
  - rke2-ingress-nginx
  - rke2-metrics-server
EOF
```

## Run RKE2 server/agent
For each of the kubernetes control plane nodes run the following:
```bash
systemctl enable rke2-server.service
systemctl start rke2-server.service
```

For each of the kubernetes agents/worker nodes run the following:
```bash
systemctl enable rke2-agent.service
systemctl start rke2-agent.service
```

