#!/bin/bash -ex

sudo apt update
sudo apt install -y awscli ca-certificates curl gnupg \
  lsb-release ruby wget
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo sh -c 'echo \
"deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose redis \
  docker-compose-plugin postgresql-client-common postgresql-11 postgresql-client-11
sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker $USER
sudo newgrp docker
exit
