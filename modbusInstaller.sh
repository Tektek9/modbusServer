#!/bin/bash

mds="modbusServer"
mts="Modbus TCP Server"
dc="docker"
f="modbus"
mb="Membuat"
nm="ansible"
Fi="file inventory"
p="playbook"

source func.ini

image=$(cat config.ini | grep pkg1= | grep -o '"[^"]*"' | sed 's/"//g')
docbin=$(cat config.ini | grep pkg2= | grep -o '"[^"]*"' | sed 's/"//g')
osINFO=$(cat config.ini | grep check1= | grep -o '"[^"]*"' | sed 's/"//g')
dpkgconf=$(cat config.ini | grep check2= | grep -o '"[^"]*"' | sed 's/"//g')
ans=$(cat config.ini | grep check3= | grep -o '"[^"]*"' | sed 's/"//g')
dcom=$(cat config.ini | grep check4= | grep -o '"[^"]*"' | sed 's/"//g')
cekdoc=$(cat config.ini | grep check5= | grep -o '"[^"]*"' | sed 's/"//g')
df=$(cat config.ini | grep file1= | grep -o '"[^"]*"' | sed 's/"//g')
com=$(cat config.ini | grep file2= | grep -o '"[^"]*"' | sed 's/"//g')
req=$(cat config.ini | grep file3= | grep -o '"[^"]*"' | sed 's/"//g')
invenFile=$(cat config.ini | grep file4= | grep -o '"[^"]*"' | sed 's/"//g')
modServer=$(cat config.ini | grep file5= | grep -o '"[^"]*"' | sed 's/"//g')
rmodServer=$(cat config.ini | grep file6= | grep -o '"[^"]*"' | sed 's/"//g')
smodServer=$(cat config.ini | grep file7= | grep -o '"[^"]*"' | sed 's/"//g')
currUser=$(cat secret.txt | sed -n '1p' | sed -e 's/usr=//g' -e 's/"//g')
passwd=$(cat secret.txt | sed -n '2p' | sed -e 's/pwd=//g' -e 's/"//g')
host=$(cat secret.txt | sed -n '3p' | sed -e 's/host=//g' -e 's/"//g')
modport=$(cat secret.txt | sed -n '4p' | sed -e 's/mport=//g' -e 's/"//g')
newport=$(cat secret.txt | sed -n '5p' | sed -e 's/nport=//g' -e 's/"//g')

if [[ -z "$1" ]]; then
    echo ''$'\n'Untuk bantuan$'\n'  ./modbusInstaller.sh -h$'\n'  atau$'\n'  ./modbusInstaller.sh --help
elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-c" ]] || [[ "$1" == "--clear" ]] || [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo ""
    echo "Info:"
    echo "  [ -i / --install ] - Menginstal Modbus Server"
    echo "  [ -c / --clear ]   - Menghapus Berkas Modbus Server"
    echo "  [ -h / --help ]    - Bantuan"
    echo ""
    echo "Penggunaan:"
    echo "  ./modbusInstaller.sh [-i/--install]"
    echo "  ./modbusInstaller.sh [-c/--clear]"
    echo "  ./modbusInstaller.sh [-h/--help]"
    echo ""
  elif [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
    echo ""$'\n'Menjalankan Setup
    pip install distro &> /dev/null
    if [ -z "$dpkgconf" ]; then
    echo "Pengecekan Ansible"
    else
      sudo dpkg --configure -a
    fi
    if [ -z "$ans" ]; then
      echo Ansible belum terinstal'$\n'Melakukan instal Ansible $nm && sudo apt-get update && sudo apt-get install -y $nm && echo "Ansible berhasil diinstal" && echo "Menginstal Docker"
    else
      echo "Ansible terinstal"
    fi
    if [[ -z $dc ]]; then
      echo "Menginstal Docker"
      if [[ "$osINFO" =~ "CentOS" ]]; then
        centosDocker
        dock=$(echo "$cekdoc")
        if [ -z "$dock" ]; then
          centosDocker
        else
          cd .. && echo "Docker berhasil diinstal" && docker ps -a | awk '{ print $1 }' | sed -n '1!p' | xargs -I % docker rm -f %
        fi
      elif [[ "$osINFO" =~ "Debian" ]]; then
        debianDocker
        dock=$(echo "$cekdoc")
        if [ -z "$dock" ]; then
          debianDocker
        else
          cd .. && echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Fedora" ]]; then
        fedoraDocker
        dock=$(echo "$cekdoc")
        if [ -z "$dock" ]; then
          fedoraDocker
        else
          cd .. && echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Red Hat" ]]; then
        rhelDocker
        dock=$(echo "$cekdoc")
        if [ -z "$dock" ]; then
          rhelDocker
        else
          cd .. && echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "SUSE" ]] || [[ "$osINFO" =~ "openSUSE" ]]; then
        slesDocker
        dock=$(echo "$cekdoc")
        if [ -z "$dock" ]; then
          slesDocker
        else
          cd .. && echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Ubuntu" ]]; then
        ubuntuDocker
        dock=$(echo "$cekdoc")
        if [ -z "$dock" ]; then
          ubuntuDocker
        else
          cd .. && echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Raspbian" ]]; then
        raspiDocker
        dock=$(echo "$cekdoc")
        if [ -z "$dock" ]; then
          raspiDocker
        else
          echo "Docker berhasil diinstal"
        fi
      else
        binaryDocker
        dock=$(echo "$cekdoc")
        if [ -z "$dock" ]; then
          binaryDocker
        else
          echo "Docker berhasil diinstal"
        fi
      fi
    else
      echo "Docker sudah terinstal"
    fi
    if [ -e "$f" ]; then
      echo "Folder $f sudah ada" && cd $f
    else
      echo "$mb folder $f" && mkdir $f && echo "Folder $f berhasil dibuat" && cd $f
    fi
    if [ -e "$mds.yml" ]; then
      echo "File $mds.yml sudah ada"
    else
    echo "Membuat file $mds.yml"
    cat <<EOL > "$mds.yml"
---
- name: Membuat $mds.py
  hosts: local
  become: no
  become_user: "{{ ansible_user }}"

  tasks:
    - name: Menginstal paket yang dibutuhkan
      apt:
        name: "{{ item }}"
        state: present
      
      loop:
        - python3
        - python3-pip

    - name: $mb script untuk $mts
      copy:
        content: |
          from pyModbusTCP.server import ModbusServer, DataBank
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
        dest: "{{ lookup('env', 'PWD') }}/$f/$mds.py"
        mode: 0755
EOL
    echo "$mds.yml berhasil dibuat"
    fi
    if [ -e "$rmodServer" ]; then
      echo "File $rmodServer sudah ada"
    else
    echo "Membuat file $rmodServer"
    cat <<EOL > $rmodServer
---
- name: Menjalankan $mts
  hosts: local
  become: no
  become_user: "{{ ansible_user }}"

  tasks:
    - name: Build Docker Image
      ansible.builtin.docker_image:
        build:
          path: "{{ lookup('env', 'PWD') }}/docker/dockerfile"
        name: modbus-server:latest
        pull: yes
    - name: Menjalankan Docker Compose
      community.docker.docker_compose:
        project_src: "{{ lookup('env', 'PWD') }}/docker/docker-compose-yml"
        state: present
EOL
    echo "$rmodServer berhasil dibuat"
    fi
    if [ -e "$mds.sh" ]; then
      echo "File $mds.sh sudah ada"
    else
      echo "$mb file $mds.sh"
      cd ..
      cat <<EOL > $mds".sh"
if [[ -z "\$1" ]]; then
  echo ''$'\n'Untuk bantuan:$'\n'  ./$mds.sh -h$'\n'  atau$'\n'  ./$mds.sh --help$'\n'
elif [[ "\$1" == "run" ]] && [[ "\$2" == "--port" || "\$2" == "-p" ]]; then
  if [[ "\$#" -lt 3 ]]; then
    echo -e "\nSilahkan masukan port\n\nUntuk bantuan:\n  ./modbusServer.sh -h\n  atau\n  ./modbusServer.sh --help"
  elif [[ "\$#" -eq 3 ]]; then
    py="ansible-playbook -i inventory.ini modbus/$mds.yml"
    cp modbus/runmodbusServer.yml modbus/rcusmodbusServer.yml
    sed -i "s/port=502/port=\$3/" modbus/rcusmodbusServer.yml
    rcustom="ansible-playbook -i inventory.ini modbus/rcusmodbusServer.yml"
    [[ "\$USER" == "root" ]] && rcustom+=" -K" && py+=" -K"
    eval "\$py" && eval "\$rcustom"
  fi
elif [[ "\$1" == "run" ]]; then
  py="ansible-playbook -i inventory.ini modbus/$mds.yml"
  runstd="ansible-playbook -i inventory.ini modbus/runmodbusServer.yml"
  [[ "\$USER" == "root" ]] && runstd+=" -K" && py+=" -K"
  eval "\$py" && eval "\$runstd"
elif [[ "\$1" == "stop" ]] && [[ "\$2" == "--port" || "\$2" == "-p" ]]; then
  if [[ "\$#" -lt 3 ]]; then
    echo -e "\nSilahkan masukan port\n\nUntuk bantuan:\n  ./modbusServer.sh -h\n  atau\n  ./modbusServer.sh --help"
  elif [[ "\$#" -eq 3 ]]; then
    cp modbus/stopmodbusServer.yml modbus/scusmodbusServer.yml
    sed -i "s/port=502/port=\$3/" modbus/scusmodbusServer.yml
    scustom="ansible-playbook -i inventory.ini modbus/scusmodbusServer.yml"
    [[ "\$USER" == "root" ]] && scustom+=" -K"
    eval "\$scustom"
  fi
elif [[ "\$1" == "stop" ]]; then
  stopstd="ansible-playbook -i inventory.ini modbus/stopmodbusServer.yml"
  [[ "\$USER" == "root" ]] && runstd+=" -K"
  eval "\$stopstd"
elif [[ "\$1" == "--help" ]] || [[ "\$1" == "-h" ]]; then
  echo -e"\n Info:"
  echo "  [run] - Untuk run modserver"
  echo "  [run] [-p/--port] [port] - Untuk menjalankan pada port tertentu"
  echo "  [stop] - Untuk stop modserver"
  echo -e "\n\nPenggunaan:"
  echo "  $mds.sh run"
  echo "  $mds.sh run -p 80"
  echo "  $mds.sh run --port 999"
  echo -e "  $mds.sh stop\n"
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
      if [ "$currUser" == "root" ]; then
        becomeUsr="some_user"
        pasangInven=$(echo "$mb $Fi" && echo "# Modbus Server Inventory" > "$invenFile" && echo "" >> "$invenFile" && echo "[local]" >> "$invenFile" && echo "localhost ansible_connection=local" >> "$invenFile" && echo -e "\n[$mds]" >> "$invenFile" && echo "localhost ansible_user=$becomeUsr ansible_ssh_pass=$passwd" >> "$invenFile" && echo "" >> "$invenFile" && echo "[all:vars]" >> "$invenFile" && echo "ansible_python_interpreter=/usr/bin/python3" >> "$invenFile" && echo "" >> "$invenFile")
        echo "$pasangInven" && echo "$invenFile berhasil dibuat"
      else 
        becomeUsr="root";
        pasangInven=$(echo "$mb $Fi" && echo "# Modbus Server Inventory" > "$invenFile" && echo "" >> "$invenFile" && echo "[local]" >> "$invenFile" && echo "localhost ansible_connection=local" >> "$invenFile" && echo -e "\n[$mds]" >> "$invenFile" && echo "localhost ansible_user=$becomeUsr ansible_ssh_pass=$passwd" >> "$invenFile" && echo "" >> "$invenFile" && echo "[all:vars]" >> "$invenFile" && echo "ansible_python_interpreter=/usr/bin/python3" >> "$invenFile" && echo "" >> "$invenFile")
        echo "$pasangInven" && echo "$invenFile berhasil dibuat"
      fi
      cd modbus
    fi
    if [ -e "$smodServer" ]; then
      echo "File $smodServer sudah ada"
    else
      echo "$mb $p $smodServer"
      cat <<EOL > $smodServer
---
- name: Menghentikan $mts
  hosts: local
  become: no
  become_user: "{{ ansible_user }}"

  tasks:
    - name: Menghentikan Docker Compose
      community.docker.docker_compose:
        project_src: "/$currUser/docker"
        state: absent
        files:
          - docker-compose.yml

    - name: Menghapus File $mds.py
      command: "rm -rf /$currUser/modbus/$mds.py"
EOL
    echo "$smodServer berhasil dibuat"
    fi
    cd ..
    if [  -e "docker" ]; then
      cd docker/
    else
      mkdir docker && cd docker/
    fi
    if [ -e "$req" ]; then
      echo "File $req sudah ada"
    else
      echo "$mb $req untuk docker" && echo "pyModbusTCP" > $req && echo "$req berhasil dibuat"
    fi
    if [ -e "$df" ]; then
      echo "File $df sudah ada"
    else
      echo "$mb $df"
      cat <<EOL > $df
FROM python:3.10-slim-bullseye

WORKDIR /app

COPY $req .
RUN pip install --no-cache-dir -r $req

COPY modbus/$mds.py .
EXPOSE 502

CMD ["python", "$mds.py"]
EOL
    echo "$df berhasil dibuat"
    fi
    if [ -e "$com" ]; then
      echo "File $com sudah ada"
    else
      echo "$mb $com"
      cat <<EOL > $com
version: '3'

services:
  modbus-server:
    build: .
    ports:
      - "$newport:502"
    restart: always
EOL
    echo "$com berhasil dibuat"
    fi
    if [[ "$dcom" =~ "version" ]]; then
      echo "Docker Compose sudah terinstal"
    else
      echo "Menginstal Docker Compose"
      dockerCompose
      echo "Instal Docker Compose selesai"
    fi
    psdoc=$(ps aux | grep -Ev "auto" | grep docker)
    if [[ "$psdoc" =~ "docker" ]]; then
      ps aux | grep docker | awk '{ print $2 }' | xargs -I % sudo kill -9 % &> /dev/null
      dockerDaemon
    else
      echo "Menjalankan docker daemon"
      dockerDaemon
    fi
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$rmodServer" ] && [ -e "$smodServer" ]; then
      echo Terjadi kesalahan instalasi$'\n'Proses instal ulang && cd .. && ./modbusInstaller.sh -i
    else
      docker ps -a | sed -n '1!p' | awk '{ print $1 }' | xargs -I % docker rm -f % &> /dev/null
      echo Instalasi selesai$'\n\n'Berikut struktur file && cd .. && ls | grep .tgz | xargs -I % rm -rf % && tree
    fi
  elif [[ "$1" -eq "-c" ]] || [[ "$1" -eq "--clear" ]]; then
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$rmodServer" ] && [ -e "$smodServer" ]; then
      echo "Terjadi kesalahan ketika menghapus, mohon jalankan ulang program"
    else
      echo $invenFile$'\n'$mds.sh$'\n'$f$'\n'$dc$'\n'$docbin | grep -Ev "Installer" | xargs -I % rm -rf % && echo ''$'\n'Berkas berhasil dihapus
    fi
  fi
fi