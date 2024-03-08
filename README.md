# modbusServer
TCP Server dengan Ansible

Struktur setelah folder setelah diinstall
```
.
├── inventory.ini
├── modbus
│   ├── modbusServer.py
│   ├── modbusServer.yml
│   └── stopmodbusServer.yml
├── modbusInstaller.sh
├── modbusServer.sh
└── Readme
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
