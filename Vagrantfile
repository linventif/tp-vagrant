Vagrant.configure("2") do |config|
  # La boîte à utiliser pour créer la machine virtuelle
  config.vm.box = "debian/bookworm64"

  # Configuration de la mémoire et du nombre de CPU
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  # Envoi du fichier daemon.json
  config.vm.provision "file", source: "daemon.json", destination: "/home/vagrant/daemon.json"

  # Exécution du script provision.sh
  config.vm.provision "shell", path: "provision.sh"

  # Partage du répertoire de l'utilisateur
  config.vm.synced_folder "#{ENV['HOME']}", "/iut_home"

  # Définition du nom des machines virtuelles

  # VM1
  config.vm.define "vm1" do |vm1|
    vm1.vm.network "private_network", ip: "192.168.56.10"
    vm1.vm.hostname = "vm1"
    vm1.vm.provision "shell", path: "provision-vm1.sh"
    vm1.vm.network "forwarded_port", guest: 80, host: 8081
    vm1.vm.provision "shell", inline: <<-SHELL
      ip route add 255.255.255.0 via 192.168.56.0/24 dev eth1
      echo "192.168.56.11 vm2" >> /etc/hosts
    SHELL
  end

  # VM2
  config.vm.define "vm2" do |vm2|
    vm2.vm.network "private_network", ip: "192.168.56.11"
    vm2.vm.network "private_network", ip: "192.168.57.11"
    vm2.vm.hostname = "vm2"
    vm2.vm.provision "shell", path: "provision-vm2.sh"
    vm2.vm.network "forwarded_port", guest: 80, host: 8082
    vm2.vm.provision "shell", inline: <<-SHELL
      ip route add 255.255.255.0 via 192.168.57.0/24 dev eth1
      ip route add 255.255.255.0 via 192.168.56.0/24 dev eth1
      echo "192.168.56.10 vm1" >> /etc/hosts
      echo "192.168.57.12 vm3" >> /etc/hosts
      echo "1" > /proc/sys/net/ipv4/ip_forward
    SHELL
  end

  # VM3
  config.vm.define "vm3" do |vm3|
    vm3.vm.network "private_network", ip: "192.168.57.12"
    vm3.vm.hostname = "vm3"
    vm3.vm.provision "shell", path: "provision-vm3.sh"
    vm3.vm.network "forwarded_port", guest: 80, host: 8083
    vm3.vm.provision "shell", inline: <<-SHELL
      ip route add 255.255.255.0 via 192.168.57.0/24 dev eth1
      echo "192.168.57.11 vm2" >> /etc/hosts
    SHELL
  end
end

<<EOF
# TP - 02

## Exercice 1 : Utilisation d’un réseau privé

1. Créer un projet vagrant dont la VM se situe dans le réseau privé 192.168.62.0/24 (choisissez une ip, autre que .1)
```shell
config.vm.network "private_network", ip: "xxx.xxx.xxx.xxx"
```
2. Quelles sont les réseaux actifs sur la VM ?
```shell
ip a
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
#     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
#     inet 127.0.0.1/8 scope host lo
#        valid_lft forever preferred_lft forever
#     inet6 ::1/128 scope host noprefixroute 
#        valid_lft forever preferred_lft forever
# 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
#     link/ether 08:00:27:8d:c0:4d brd ff:ff:ff:ff:ff:ff
#     altname enp0s3
#     inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
#        valid_lft 85967sec preferred_lft 85967sec
#     inet6 fe80::a00:27ff:fe8d:c04d/64 scope link 
#        valid_lft forever preferred_lft forever
# 3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
#     link/ether 08:00:27:dd:61:b0 brd ff:ff:ff:ff:ff:ff
#     altname enp0s8
#     inet 192.168.62.10/24 brd 192.168.62.255 scope global eth1
#        valid_lft forever preferred_lft forever
#     inet6 fe80::a00:27ff:fedd:61b0/64 scope link 
#        valid_lft forever preferred_lft forever
# 5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
#     link/ether 02:42:4d:d0:c2:d8 brd ff:ff:ff:ff:ff:ff
#     inet 172.20.0.1/24 brd 172.20.0.255 scope global docker0
#        valid_lft forever preferred_lft forever
```
3. Votre VM a t’elle accès à un extérieur ?
```shell
ping google.com
# oui
```
4. Quel est l’état de sa table de routage ?
```shell
ip route show
# default via 10.0.2.2 dev eth0
# 10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
# 172.20.0.0/24 dev docker0 proto kernel scope link src 172.20.0.1 linkdown
# 192.168.62.0/24 dev eth1 proto kernel scope link src 192.168.62.10
```
5. Que pouvez vous en conclure sur la façon dont Vagrant gère le réseau dans le cas du provider VirtualBox ?
On peut conclure que Vagrant gère le réseau dans le cas du provider VirtualBox en créant une interface réseau privée (eth1) sur la VM.

## Exercice 2 : Utilisation de plusieurs machines virtuelles

Créer un projet vagrant définissant 2 machines virtuelles respectant les contraintes suivantes

1. Toutes les VM doivent être dans le réseau privé 192.168.62.0/24
2. Le nom d’hôte des deux VM doivent être respectivement vm1 et vm2 Pour vérifier que vous avez utilisé la bonne configuration, le prompt du shell sur vm1 doit être
3. À l’aide d’un provisionnement de type de type shell, configurer le fichier /etc/hosts de la machine virtuelle de façon à ce que les VM puissent se joindre (tester avec la commande ping) à l’aide de leur nom (et pas seulement de leur adresse IP)
# Provisioning the /etc/hosts and routing
config.vm.provision "shell", inline: <<-SHELL
  # Provisioning the /etc/hosts
  echo "192.168.62.10 vm1" >> /etc/hosts
  echo "192.168.62.11 vm2" >> /etc/hosts
  # Provisioning the routing
  ip route add 255.255.255.0 via 192.168.62.0/24 dev eth1
SHELL
4.Sur la première machine virtuelle, installer (à l’aide d’un provisionnement) un serveur web apache. Sur la deuxième, installer (toujours avec un provisionnement), le serveur web nginx. Attention, vous devez utiliser un provisionnement différent sur chacune des VM. Le serveur apache et le serveur nginx doivent être accessibles à l’aide d’une connexion sur la machine physique (redirection de ports)
# Provisioning the VM1
```shell
apt-get update
apt-get install -y apache2
```

# Provisioning the VM2
```shell
apt-get update
apt-get install -y nginx
```

## Exercice 3 :Utilisation de plusieurs machines sur plusieurs réseaux

1. Créer un projet vagrant constitué de 3 VM et de 2 réseaux privés selon la répartition suivante:
    Réseau A: 192.168.56.0/24
    Réseau B: 192.168.57.0/24
    VM1 doit appartenir au réseau A
    VM2 doit appartenir au réseau A et au réseau B
    VM3 doit appartenir au réseau B
2. Comme précédemment, ajouter un provisionnement pour que toutes les machines puissent se joindre en utilisant leur nom (vm1, vm2, vm3 dans le fichier /etc/hosts). Les noms d’hôte des trois machines doivent être respectivement vm1, vm2, vm3. Le nom vm2 doit résoudre avec l’adresse IP du routeur dans le réseau correspondant. C’est à dire:
    sur vm1, le nom vm2 pointe sur 192.168.56.xx
    sur vm3, le nom vm2 pointe sur 192.168.57.xx
    sur vm2, le nom vm2 pointe arbitrairement sur l’une ou l’autre des adresses
3. Ajouter le provisionnement nécessaire de façon à ce que la VM2 agisse comme un routeur permettant à la VM1 et la VM3 de communiquer (souvenez vous de R3.06)
4. Tester votre configuration à l’aide de la commande traceroute, s’assurer que le routeur utilisé est bien VM2
5. Redémarrer les machines à l’aide vagrant reload et tester à nouveau la configuration du routage avec traceroute. Que se passe-t’il ?

6. Corriger le provisionnement de façon à ce que la configuration de routage soit appliquée à chaque démarrage des VM

EOF