# modbusServer
Project Modbus Server dengan Ansible & Docker

Struktur folder setelah diinstall
```
.
├── docker
│   ├── docker
│   ├── docker-containerd
│   ├── docker-containerd-ctr
│   ├── docker-containerd-shim
│   ├── dockerd
│   ├── docker-init
│   ├── docker-proxy
│   └── docker-runc
├── inventory.ini
├── modbus
│   ├── runmodbusServer.yml
│   └── stopmodbusServer.yml
├── modbusInstaller.sh
├── modbusServer.sh
├── Readme
└── secret.txt

3 directories, 15 files
```

Untuk panduan biasa baca Readme
```
cat Readme
```


Untuk installasi
```
./modbusInstaller -i
```
atau
```
./modbusInstaller --install
```


Untuk menghapus berkas installer
```
./modbusInstaller -c
```
atau
```
./modbusInstaller --clear
```


Untuk mengaktifkan server
```
./modbusServer.sh run
```


Untuk mematikan server
```
./modbusServer.sh stop
```
