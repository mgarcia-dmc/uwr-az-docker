# Add Docker's official GPG key:
echo "--------------------------------------------------"
echo "> Instalando AZCLI"
echo "--------------------------------------------------"

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
echo "--------------------------------------------------"
echo "> Instalando Docker"
echo "--------------------------------------------------"
sudo apt-get update -qq
sudo apt-get install -y -qq ca-certificates curl git
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -qq
sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "--------------------------------------------------"
echo "> Configurando Docker"
echo "--------------------------------------------------"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

echo "--------------------------------------------------"
echo "> Probando Docker"
echo "--------------------------------------------------"
docker run hello-world
