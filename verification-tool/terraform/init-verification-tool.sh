#!/usr/bin/env bash
# To verify if these steps execute correctly, you can check /var/log/cloud-init-output.log in the instances
# Cloud init doesn't log anymore, so we log to user-data log and syslog

# UserData script which installs docker and bootstrap ephemeral drives if available in  AL2

set -e
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1


# Install Docker and docker-compose
function install_docker() {
    yum update -y
    sudo amazon-linux-extras install docker -y
    systemctl enable docker
    systemctl start docker
    usermod -a -G docker ec2-user
    curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    runuser -l ec2-user -c  'curl -s https://static.identiq.com/get-freud.sh | sh'
}
# Use the ephemeral storage for docker so we don't run out of space
function setup_docker_ephemeral() {
  ephemeral_count=$(nvme list | grep -c "Amazon EC2 NVMe Instance Storage")
  if [ "$ephemeral_count" = 0 ]; then
      echo "No ephemeral disk detected. exiting"
      exit 0
  fi
  if mountpoint -q -- /mnt; then
    echo "Using /mnt/docker for docker storage"
    systemctl stop docker
    mkdir -p /mnt/docker
    mount -o bind /mnt/docker/ /var/lib/docker/
    systemctl start docker
  fi
}

# Setup instance NVME drives to raid0 and mount
function setup_ephemeral_raid() {
    yum install nvme-cli -y
    drives=""
    ephemeral_count=$(nvme list | grep -c "Amazon EC2 NVMe Instance Storage")
    if [ "$ephemeral_count" = 0 ]; then
        echo "No ephemeral disk detected. exiting"
        exit 0
    fi
    ephemerals=$(nvme list | grep "Amazon EC2 NVMe Instance Storage"| awk '{print $1}')
    for e in $ephemerals; do
      echo "Detected ephemeral disk: $e"
      drives="$drives $e"
    done

    mdadm --create --verbose --level=0 /dev/md0 --name=DATA --raid-devices=$ephemeral_count $drives
    mkfs.xfs /dev/md0
    mdadm --detail --scan >> /etc/mdadm.conf
    dracut -H -f /boot/initramfs-$(uname -r).img $(uname -r)
    echo /dev/md0  /mnt xfs  defaults  0  0 >> /etc/fstab
    mount -a
}

# Add your custom initialization code below
install_docker
install_freud
setup_ephemeral_raid
setup_docker_ephemeral

mkdir /data
mkdir -p /data/output/tmp
mkdir -p /data/output/log
echo "UserData initialization is done"
