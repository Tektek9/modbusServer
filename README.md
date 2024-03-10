# modbusServer
Project Modbus Server dengan Ansible & Docker

Struktur folder setelah diinstall
```
.
├── docker
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── requirements.txt
├── inventory.ini
├── modbus
│   ├── modbusServer.py
│   ├── runmodbusServer.yml
│   └── stopmodbusServer.yml
├── modbusInstaller.sh
├── modbusServer.sh
├── Readme
└── secret.txt
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
