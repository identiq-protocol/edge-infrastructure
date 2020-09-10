#!/usr/bin/env bash
yum install docker -y
systemctl enable docker
systemctl start docker
#mkfs -t xfs /dev/nvme1n1
mkdir /data
#mount /dev/nvme1n1 /data
mkdir -p /data/output/tmp
mkdir -p /data/output/log
