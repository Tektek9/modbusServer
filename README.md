# modbusServer
Project Modbus Server
- Ansible
- Docker
- Desktop Monitoring

Note: ONPROGRESS

Struktur folder setelah diinstall
```
.
├── config.ini
├── app
|   ├── __pycache__
│   |   ├── controller.cpython-311.pyc
│   |   └── view.cpython-311.pyc
|   ├── controller.py
|   └── view.py
├── docker
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── requirements.txt
├── funct.conf
├── inventory.ini
├── main.py
├── modbus
│   ├── modbusServer.yml
│   ├── runmodbusServer.yml
│   └── stopmodbusServer.yml
├── modbusInstaller.sh
├── modbusServer.sh
├── README.md
├── requirements.txt
└── secret.txt
```
<br />

Server Side
=


Untuk installasi
```
chmod +x modbusInstaller.sh
```
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
<br />

Client Side
=


Install requirement
```
pip install -r requirements.txt
```

Jalankan Program
```
python main.py
```
<br />
<p align="center">Prototype Desain Program</p>
<br />
<p align="center">
  <img src="https://github.com/Tektek9/modbusServer/assets/40711562/4900091a-0991-4832-9b58-ecb267ee50e1" alt="Sublime's custom image"/>
</p>



