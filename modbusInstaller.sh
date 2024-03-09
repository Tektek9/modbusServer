#!/bin/bash

invenFile="inventory.ini"
currUser=$(cat secret.txt | sed -n '1p' | sed -e 's/usr=//g' -e 's/"//g')
passwd=$(cat secret.txt | sed -n '2p' | sed -e 's/pwd=//g' -e 's/"//g')
mds="modbusServer"
mts="Modbus TCP Server"
dpkgconf=$(sudo dpkg --configure -a 2> /dev/null)
ans=$(ansible --version 2> /dev/null)
modServer="$mds.yml"
smodServer="stop$mds.yml"
f="modbus"
runans="ansible-playbook -i $invenFile modbus/"
runansroot="ansible-playbook -i $invenFile -K modbus/"
nm="ansible"
Fi="file inventory"
p="playbook"
host=$(cat secret.txt | sed -n '3p' | sed -e 's/host=//g' -e 's/"//g')
modport=$(cat secret.txt | sed -n '4p' | sed -e 's/modport=//g' -e 's/"//g')
newport=$(cat secret.txt | sed -n '5p' | sed -e 's/newport=//g' -e 's/"//g')

if [[ -z "$1" ]]; then
  echo ''$'\n'Untuk bantuan$'\n'  ./modbusInstaller.sh -h$'\n'  atau$'\n'  ./modbusInstaller.sh --help
elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-c" ]] || [[ "$1" == "--clear" ]] || [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo ""
    echo "Info:"
    echo "  [ -i / --install ] - Menginstall Modbus Server"
    echo "  [ -c / --clear ]   - Menghapus Installer"
    echo "  [ -h / --help ]    - Bantuan"
    echo "" 
    echo "Penggunaan:"
    echo "  ./modbusInstaller.sh [-i/--install]"
    echo "  ./modbusInstaller.sh [-c/--clear]"
    echo "  ./modbusInstaller.sh [-h/--help]"
    echo ""
  elif [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
    echo ""$'\n'Menjalankan Setup
    if [ -z "$dpkgconf" ]; then
    echo "Pengecekan Ansible"
    else
      sudo dpkg --configure -a
    fi
    if [ -z "$ans" ]; then
      echo Ansible belum terinstal'$\n'Melakukan instal Ansible $nm && sudo apt-get update && sudo apt-get install -y $nm && echo "Ansible berhasil diinstal"
    else
      echo "Ansible terinstal"
    fi
    echo "User saat ini: $currUser"
    if [ -e "$f" ]; then
      echo "Folder $f sudah ada" && cd $f && echo "Membuat $p $modServer"
    else
      echo "Proses Membuat folder $f" && mkdir $f && cd $f && echo "Membuat $p $modServer" && echo "$modServer berhasil dibuat"
    fi
    if [ -e "$modServer" ]; then
      echo "File $modServer sudah ada"
    else
    cat <<EOL > $modServer
---
- name: Menginstal dan menjalankan $mts
  hosts: $mds 
  become: yes
  become_user: "{{ ansible_user }}"

  tasks:
    - name: Menginstal paket yang dibutuhkan
      apt:
        name: "{{ item }}"
        state: present
      
      loop:
        - python3
        - python3-pip

    - name: Menginstal pymodbus library
      pip:
        name: "{{ item }}"
        executable: pip3

      loop:
        - pyModbusTCP

    - name: Membuat script untuk $mts
      copy:
        content: |
          from pyModbusTCP.server immodport ModbusServer, DataBank
          from random import uniform
          from time import sleep

          def main():
              server = ModbusServer(host='$host', port=$modport, no_block=True)
              try:
                  print("Menjalankan server")
                  server.start()
                  print("Server sedang berjalan pada $host:$modport")
                  dataLama = DataBank.get_words(0, 1)
                  while True:
                      DataBank.set_words(0, [int(uniform(0, 100))])
                      dataSekarang = DataBank.get_words(0, 1)
                      if dataSekarang != dataLama:
                          dataLama = dataSekarang
                          print("Data register terganti ke "+str(dataSekarang))
                      sleep(0.5)
              except Exception as e:
                  print(f"Server berhenti karena {e}")
                  server.stop()
                  print("Server berhasil diberhentikan")

          if __name__ == "__main__":
              main()
        dest: "{{ lookup('env', 'PWD') }}/modbus/$mds.py"
        mode: 0755

    - name: Menjalankan modbus server
      shell: "nohup python3 {{ lookup('env', 'PWD') }}/modbus/$mds.py > /dev/null 2>&1 &"
      async: 0
      poll: 0
EOL
    echo "$modServer berhasil dibuat"
    fi
    if [ -e "$mds.sh" ]; then
      echo "File $mds.sh sudah ada"
    else
      echo "Membuat file $mds.sh"
      cd ..
      cat <<EOL > $mds".sh"
  if [[ -z "\$1" ]]; then
    echo ''$'\n'Untuk bantuan:$'\n'  ./$mds.sh -h$'\n'  atau$'\n'  ./$mds.sh --help$'\n'
  elif [[ "\$1" == "run" ]]; then
    if [[ "$currUser" == "ROOT" ]]; then
        $runansroot$modServer
    else
        $runans$modServer
    fi
  elif [[ "\$1" == "stop" ]]; then
    if [[ "$currUser" == "ROOT" ]]; then
        $runansroot$smodServer
    else
        $runans$smodServer
    fi
  elif [[ "\$1" == "--help" ]] || [[ "\$1" == "-h" ]]; then
    echo ''$'\n'Untuk penggunaan:$'\n'  $mds.sh run [Untuk run modserver]$'\n'  $mds.sh stop [Untuk stop modserver]$'\n'
  fi
EOL
      chmod +x $mds.sh
      echo "$mds.sh berhasil dibuat"
      cd modbus
    fi
    if [ -e "$invenFile" ]; then
      echo "$Fi $nm sudah ada, silahkan cek pada $invenFile"
    else
      cd ..
      if [ "$currUser" == "ROOT" ]; then 
        becomeUsr="some_user"
        pasangInven=$(echo "Membuat $Fi" && echo "# Modbus Server Inventory" > "$invenFile" && echo "" >> "$invenFile" && echo "[local]" >> "$invenFile" && echo "localhost ansible_connection=local" >> "$invenFile" && echo -e "\n[$mds]" >> "$invenFile" && echo localhost ansible_user=$becomeUsr$'\n'ansible_ssh_pass=$passwd >> "$invenFile" && echo "" >> "$invenFile" && echo "[all:vars]" >> "$invenFile" && echo "ansible_python_interpreter=/usr/bin/python3" >> "$invenFile" && echo "" >> "$invenFile")
        echo "$pasangInven" && echo "$invenFile berhasil dibuat"
      else 
        becomeUsr="root"; 
        pasangInven=$(echo "Membuat $Fi" && echo "# Modbus Server Inventory" > "$invenFile" && echo "" >> "$invenFile" && echo "[local]" >> "$invenFile" && echo "localhost ansible_connection=local" >> "$invenFile" && echo -e "\n[$mds]" >> "$invenFile" && echo localhost ansible_user=$becomeUsr$'\n'ansible_ssh_pass=$passwd >> "$invenFile" && echo "" >> "$invenFile" && echo "[all:vars]" >> "$invenFile" && echo "ansible_python_interpreter=/usr/bin/python3" >> "$invenFile" && echo "" >> "$invenFile")
        echo "$pasangInven" && echo "$invenFile berhasil dibuat"
      fi
      cd modbus
    fi
    if [ -e "$smodServer" ]; then
      echo "File $smodServer sudah ada"
    else
      echo "Membuat $p $smodServer"
      cat <<EOL > $smodServer
---
- name: Menghentikan $mts
  hosts: $mds 
  become: yes 
  become_user: "{{ ansible_user }}"

  tasks:
    - name: Mencari dan mematikan $mts
      shell: "ps aux | grep \"{{ lookup('env', 'PWD') }}/modbus/modbusServer.py\" | grep -Ev 'auto' | awk '{ print \$2 }' | xargs -I % sudo kill -9 % > /dev/null 2>&1 || true"
      ignore_errors: true
EOL
    echo "$smodServer berhasil dibuat"
    fi
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$modServer" ] && [ -e "$smodServer" ]; then
      echo Terjadi kesalahan instalasi$'\n'Proses instal ulang && cd .. && ./modbusInstaller.sh -i
    else
      echo Instalasi selesai$'\n\n'Berikut struktur file && cd .. && echo "" >> Readme && echo "Untuk Menjalankan:" >> Readme && echo "  ./modbusServer.sh -h" >> Readme && echo "" >> Readme && tree
    fi
  elif [[ "$1" -eq "-c" ]] || [[ "$1" -eq "--clear" ]]; then
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$modServer" ] && [ -e "$smodServer" ]; then
      echo "Terjadi kesalahan ketika menghapus, mohon jalankan ulang program"
    else
      echo $invenFile$'\n'$mds.sh$'\n'modbus$'\n'Readme | grep -Ev "Installer" | xargs -I % rm -rf % && echo ''$'\n'Berkas berhasil dihapus
    fi  
  fi
fi
