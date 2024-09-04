# Update
apt-get update
# Install Tools
apt-get install -y curl vim net-tools dnsutils
# Install Docker
apt-get install -y docker.io docker-compose
usermod -aG docker vagrant
mv /home/vagrant/daemon.json /etc/docker/daemon.json