#!/bin/sh

#INstall Dokcer
sudo apt update -y
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#Install GNS3
sudo apt update -y
sudo apt install -y python3-pip python3-pyqt5 python3-pyqt5.qtsvg \
python3-pyqt5.qtwebsockets pipx \
qemu-kvm qemu-utils libvirt-clients libvirt-daemon-system virtinst \
 xtightvncviewer apt-transport-https \
ca-certificates curl gnupg2 software-properties-common
pipx install gns3-server
pipx install gns3-gui
pipx inject gns3-gui gns3-server PyQt5
echo "export PATH=$PATH:/home/$(whoami)/.local/bin:/root/.local/bin" >> ~/.bashrc
source ~/.bashrc

sudo apt install -y wireshark

#install xterm to be able to use console
sudo apt-get -y install xterm

#Install ubridge
sudo apt install -y git build-essential pcaputils  libpcap-dev
git clone https://github.com/GNS3/ubridge.git
cd ubridge && make && sudo make install


#Install dynamips
sudo apt install -y libelf-dev libpcap-dev cmake
git clone https://github.com/GNS3/dynamips.git
mkdir dynamips/build
cd ./dynamips/build && cmake .. && sudo make install

#Add user to group
sudo usermod -a -G docker $(whoami)
sudo usermod -a -G libvirt $(whoami)
sudo usermod -a -G kvm $(whoami)
sudo usermod -a -G wireshark $(whoami)
sudo usermod -a -G root $(whoami)
sudo usermod -a -G sudo $(USER)
sudo usermod -a -G vboxsf $(USER)

for i in ubridge docker wireshark; do
 sudo usermod -aG $i $USER
done

#Pull images
docker pull frrouting/frr
docker pull alpine


sudo reboot now