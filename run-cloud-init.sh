rm seed.img disk.qcow2
cp debian-12-genericcloud-amd64.qcow2 disk.qcow2
cloud-localds seed.img user-data.yaml
ssh-keygen -f '/home/linventif/.ssh/known_hosts' -R '[localhost]:2222'
kvm -m 1024 -device virtio-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2222-:22 -hda disk.qcow2 -drive file=seed.img,format=raw
echo "Run 'ssh -p 2222 debian@localhost' to connect to the VM"