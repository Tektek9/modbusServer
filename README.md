# modbusServer
Project Modbus Server
- Ansible
- Docker
- Desktop Monitoring

Note: ONPROGRESS

Struktur folder setelah diinstall
```
.
├── docker
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── requirements.txt
├── inventory.ini
├── modbus
│   ├── modbusServer.yml
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


Prototype Desain Program
![image](https://github.com/Tektek9/modbusServer/assets/40711562/d9a2f9a9-ae1e-4d03-b479-6f886bafadf7)



