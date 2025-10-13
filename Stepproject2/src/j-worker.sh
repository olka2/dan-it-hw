#!/bin/bash

JENKINS_AGENT_USER="jenkins"
AGENT_WORKDIR="/home/jenkins"
PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILotVUzbT89xft7UwZSoRALU2ZvLQuC7grurS223hhUt"

# Docker install:
echo "[master] Docker install"
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker
sudo apt-get install -y openjdk-17-jre-headless

echo "[worker] Create jenkins user (system)"
if ! id -u "${JENKINS_AGENT_USER}" >/dev/null 2>&1; then
  sudo useradd -m -d "${AGENT_WORKDIR}" -s /bin/bash "${JENKINS_AGENT_USER}"
fi

echo "[worker] Add jenkins user to docker group"
sudo usermod -aG docker "${JENKINS_AGENT_USER}"

sudo -u jenkins mkdir -p /home/jenkins/.ssh
sudo chmod 700 /home/jenkins/.ssh
sudo echo "${PUBLIC_KEY}" >> /home/jenkins/.ssh/authorized_keys
sudo chmod 600 /home/jenkins/.ssh/authorized_keys
sudo chown -R jenkins:jenkins /home/jenkins/.ssh