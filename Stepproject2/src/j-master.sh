#!/bin/bash

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

# Setup Docker container:
echo "[master] Prepare persistent volume for Jenkins"
sudo docker volume create jenkins_home >/dev/null

echo "[master] Run Jenkins controller in Docker"
if ! sudo docker ps --format '{{.Names}}' | grep -q '^jenkins$'; then
  sudo docker run -d --name jenkins \
    -p 8080:8080 \
    -v jenkins_home:/var/jenkins_home \
    --restart unless-stopped \
    jenkins/jenkins:lts
fi

echo "[master] Waiting Jenkins to initialize (first run may take ~1-2 min)"
for i in {1..60}; do
  if sudo docker exec jenkins test -f /var/jenkins_home/secrets/initialAdminPassword; then
    break
  fi
  sleep 2
done

# Show pass:
if sudo docker exec jenkins test -f /var/jenkins_home/secrets/initialAdminPassword; then
  echo "-----------------------------------------------------------------"
  echo "[master] Initial admin password:"
  sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
  echo
  echo "Open:  http://localhost:8080  (або IP VM)  -> розблокуйте Jenkins"
  echo "Ports: 8080 (UI), 50000 (JNLP агенти)"
  echo "-----------------------------------------------------------------"
else
  echo "[master] initialAdminPassword поки не з’явився. Перевірте статус контейнера:"
  echo "  sudo docker logs -f jenkins"
fi