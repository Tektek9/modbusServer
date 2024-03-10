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
├── README.md
├── secret.txt
├── app.py
└── requirement.txt
```

Untuk panduan biasa baca Readme
```
cat README.md
```


SIsi Server

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


Sisi Client

```
pip install -r requirements.txt
```

```
python app.py
```


Prototype Desain Program
![image](https://github.com/Tektek9/modbusServer/assets/40711562/8aa396c0-1574-4734-bb5f-aff68c1eb5e8)




