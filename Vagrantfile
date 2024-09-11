Vagrant.configure("2") do |config|
  # Définition du nom de la machine virtuelle et de son alias
  config.vm.hostname = "vag-debian"
  config.vm.define "vag-debian"

  # La boîte à utiliser pour créer la machine virtuelle
  config.vm.box = "debian/bookworm64"

  # Configuration de la mémoire et du nombre de CPU
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  # Configuration du réseau
  config.vm.network "private_network", ip: "192.168.62.10"

  # Envoi du fichier daemon.json
  config.vm.provision "file", source: "daemon.json", destination: "/home/vagrant/daemon.json"

  # Exécution du script provision.sh
  config.vm.provision "shell", path: "provision.sh"

  # Partage du répertoire de l'utilisateur
  config.vm.synced_folder "#{ENV['HOME']}", "/iut_home"
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
```shell
vagrant@vm1:~$
```
3. À l’aide d’un provisionnement de type de type shell, configurer le fichier /etc/hosts de la machine virtuelle de façon à ce que les VM puissent se joindre (tester avec la commande ping) à l’aide de leur nom (et pas seulement de leur adresse IP)
4.Sur la première machine virtuelle, installer (à l’aide d’un provisionnement) un serveur web apache. Sur la deuxième, installer (toujours avec un provisionnement), le serveur web nginx. Attention, vous devez utiliser un provisionnement différent sur chacune des VM. Le serveur apache et le serveur nginx doivent être accessibles à l’aide d’une connexion sur la machine physique (redirection de ports)


EOF