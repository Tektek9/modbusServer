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
![image](https://github.com/Tektek9/modbusServer/assets/40711562/b971315b-0b13-4e9a-9cbd-61fc53c3c747)


