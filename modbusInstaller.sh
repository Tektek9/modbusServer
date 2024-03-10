#!/bin/bash

invenFile="inventory.ini"
currUser=$(cat secret.txt | sed -n '1p' | sed -e 's/usr=//g' -e 's/"//g')
passwd=$(cat secret.txt | sed -n '2p' | sed -e 's/pwd=//g' -e 's/"//g')
mds="modbusServer"
mts="Modbus TCP Server"
dpkgconf=$(sudo dpkg --configure -a 2> /dev/null)
ans=$(ansible --version 2> /dev/null)
modServer="$mds.yml"
rmodServer="run$mds.yml"
smodServer="stop$mds.yml"
req="requirements.txt"
dc="docker"
com="docker-compose.yml"
df="Dockerfile"
image="oitc/modbus-server"
docbin="docker-17.03.0-ce.tgz"
readme="Readme"
f="modbus"
mb="Membuat"
runans="ansible-playbook -i $invenFile $f/"
nm="ansible"
Fi="file inventory"
p="playbook"
osINFO=$(python3 -m distro)
host=$(cat secret.txt | sed -n '3p' | sed -e 's/host=//g' -e 's/"//g')
modport=$(cat secret.txt | sed -n '4p' | sed -e 's/mport=//g' -e 's/"//g')
newport=$(cat secret.txt | sed -n '5p' | sed -e 's/nport=//g' -e 's/"//g')

centosDocker() {
  sudo yum install -y yum-utils &> /dev/null
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &> /dev/null
  sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
  ps aux | grep docker | awk '{ print $2 }' | xargs -I % sudo kill -9 % &> /dev/null
  echo "Menjalankan docker daemon"
  sudo systemctl start docker &> /dev/null
}

debianDocker() {
  sudo apt-get update -qq
  sudo apt-get install -y -qq ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -qq
  ps aux | grep docker | awk '{ print $2 }' | xargs -I % sudo kill -9 % &> /dev/null
  echo "Membuat docker daemon"
  echo -e "[Unit]\nDescription=Docker Application Container Engine\nDocumentation=https://docs.docker.com\nAfter=network-online.target docker.socket firewalld.service containerd.service time-set.target\nWants=network-online.target containerd.service\nRequires=docker.socket\n\n[Service]\nType=notify\nExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock\nExecReload=/bin/kill -s HUP $MAINPID\nTimeoutStartSec=0\nRestartSec=2\nRestart=always\nStartLimitBurst=3\nStartLimitInterval=60s\nLimitNPROC=infinity\nLimitCORE=infinity\nTasksMax=infinity\nDelegate=yes\nKillMode=process\nOOMScoreAdjust=-500\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/docker.service
  echo -e "[Unit]\nDescription=Docker Socket for the API\nPartOf=docker.service\n\n[Socket]\nListenStream=/var/run/docker.sock\nSocketMode=0660\nSocketUser=root\nSocketGroup=docker\n\n[Install]\nWantedBy=sockets.target" > /usr/lib/systemd/system/docker.socket
  sudo systemctl enable docker &> /dev/null
  sudo systemctl daemon-reload &> /dev/null
  echo "Menjalankan docker daemon"
  systemctl start docker.socket &> /dev/null
  sudo systemctl restart docker &> /dev/null
}

fedoraDocker() {
  sudo dnf -y install dnf-plugins-core &> /dev/null
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &> /dev/null
  sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
  ps aux | grep docker | awk '{ print $2 }' | xargs -I % sudo kill -9 % &> /dev/null
  echo "Menjalankan docker daemon"
  sudo systemctl start docker &> /dev/null
}

rhelDocker() {
  sudo yum install -y yum-utils &> /dev/null
  sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo &> /dev/null
  sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
  ps aux | grep docker | awk '{ print $2 }' | xargs -I % sudo kill -9 % &> /dev/null
  echo "Menjalankan docker daemon"
  sudo systemctl start docker &> /dev/null
}

slesDocker() {
  sudo apt-get update &> /dev/null
  sudo zypper addrepo https://download.docker.com/linux/sles/docker-ce.repo &> /dev/null
  sudo zypper install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
  ps aux | grep docker | awk '{ print $2 }' | xargs -I % sudo kill -9 % &> /dev/null
  echo "Menjalankan docker daemon"
  sudo systemctl start docker &> /dev/null
}

ubuntuDocker() {
  sudo apt-get update -qq
  sudo apt-get install -y -qq ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -qq
  ps aux | grep docker | awk '{ print $2 }' | xargs -I % sudo kill -9 % &> /dev/null
  echo "Membuat docker daemon"
  echo -e "[Unit]\nDescription=Docker Application Container Engine\nDocumentation=https://docs.docker.com\nAfter=network-online.target docker.socket firewalld.service containerd.service time-set.target\nWants=network-online.target containerd.service\nRequires=docker.socket\n\n[Service]\nType=notify\nExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock\nExecReload=/bin/kill -s HUP $MAINPID\nTimeoutStartSec=0\nRestartSec=2\nRestart=always\nStartLimitBurst=3\nStartLimitInterval=60s\nLimitNPROC=infinity\nLimitCORE=infinity\nTasksMax=infinity\nDelegate=yes\nKillMode=process\nOOMScoreAdjust=-500\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/docker.service
  echo -e "[Unit]\nDescription=Docker Socket for the API\nPartOf=docker.service\n\n[Socket]\nListenStream=/var/run/docker.sock\nSocketMode=0660\nSocketUser=root\nSocketGroup=docker\n\n[Install]\nWantedBy=sockets.target" > /usr/lib/systemd/system/docker.socket
  sudo systemctl enable docker &> /dev/null
  sudo systemctl daemon-reload &> /dev/null
  echo "Menjalankan docker daemon"
  systemctl start docker.socket &> /dev/null
  sudo systemctl restart docker &> /dev/null
}

raspiDocker() {
  sudo apt-get update -qq
  sudo apt-get install -y -qq ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/raspbian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/raspbian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -qq
  ps aux | grep docker | awk '{ print $2 }' | xargs -I % sudo kill -9 % &> /dev/null
  echo "Membuat docker daemon"
  echo -e "[Unit]\nDescription=Docker Application Container Engine\nDocumentation=https://docs.docker.com\nAfter=network-online.target docker.socket firewalld.service containerd.service time-set.target\nWants=network-online.target containerd.service\nRequires=docker.socket\n\n[Service]\nType=notify\nExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock\nExecReload=/bin/kill -s HUP $MAINPID\nTimeoutStartSec=0\nRestartSec=2\nRestart=always\nStartLimitBurst=3\nStartLimitInterval=60s\nLimitNPROC=infinity\nLimitCORE=infinity\nTasksMax=infinity\nDelegate=yes\nKillMode=process\nOOMScoreAdjust=-500\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/docker.service
  echo -e "[Unit]\nDescription=Docker Socket for the API\nPartOf=docker.service\n\n[Socket]\nListenStream=/var/run/docker.sock\nSocketMode=0660\nSocketUser=root\nSocketGroup=docker\n\n[Install]\nWantedBy=sockets.target" > /usr/lib/systemd/system/docker.socket
  sudo systemctl enable docker &> /dev/null
  sudo systemctl daemon-reload &> /dev/null
  echo "Menjalankan docker daemon"
  systemctl start docker.socket &> /dev/null
  sudo systemctl restart docker &> /dev/null
}

binaryDocker() {
  wget https://download.docker.com/linux/static/stable/x86_64/$docbin &> /dev/null
  tar xzvf $docbin &> /dev/null
  sudo cp docker/* /usr/bin/
  rm -rf docker/*
  ps aux | grep docker | awk '{ print $2 }' | xargs -I % sudo kill -9 % &> /dev/null
  echo "Membuat docker daemon"
  echo -e "[Unit]\nDescription=Docker Application Container Engine\nDocumentation=https://docs.docker.com\nAfter=network-online.target docker.socket firewalld.service containerd.service time-set.target\nWants=network-online.target containerd.service\nRequires=docker.socket\n\n[Service]\nType=notify\nExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock\nExecReload=/bin/kill -s HUP $MAINPID\nTimeoutStartSec=0\nRestartSec=2\nRestart=always\nStartLimitBurst=3\nStartLimitInterval=60s\nLimitNPROC=infinity\nLimitCORE=infinity\nTasksMax=infinity\nDelegate=yes\nKillMode=process\nOOMScoreAdjust=-500\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/docker.service
  echo -e "[Unit]\nDescription=Docker Socket for the API\nPartOf=docker.service\n\n[Socket]\nListenStream=/var/run/docker.sock\nSocketMode=0660\nSocketUser=root\nSocketGroup=docker\n\n[Install]\nWantedBy=sockets.target" > /usr/lib/systemd/system/docker.socket
  sudo systemctl enable docker &> /dev/null
  sudo systemctl daemon-reload &> /dev/null
  echo "Menjalankan docker daemon"
  systemctl start docker.socket &> /dev/null
  sudo systemctl restart docker &> /dev/null
}

if [[ -z "$1" ]]; then
    echo ''$'\n'Untuk bantuan$'\n'  ./modbusInstaller.sh -h$'\n'  atau$'\n'  ./modbusInstaller.sh --help
elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-c" ]] || [[ "$1" == "--clear" ]] || [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo ""
    echo "Info:"
    echo "  [ -i / --install ] - Menginstal Modbus Server"
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
        mkdir docker && cd docker
        centosDocker
        dock=$(sudo docker run hello-world &> /dev/null)
        if [ -z "$dock" ]; then
          centosDocker
        else
          cd .. && echo "Docker berhasil diinstal" && docker ps -a | awk '{ print $1 }' | sed -n '1!p' | xargs -I % docker rm -f %
        fi
      elif [[ "$osINFO" =~ "Debian" ]]; then
        mkdir docker && cd docker
        debianDocker
        dock=$(sudo docker run hello-world &> /dev/null)
        if [ -z "$dock" ]; then
          debianDocker
        else
          cd .. && echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Fedora" ]]; then
        mkdir docker && cd docker
        fedoraDocker
        dock=$(sudo docker run hello-world &> /dev/null)
        if [ -z "$dock" ]; then
          fedoraDocker
        else
          cd .. && echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Red Hat" ]]; then
        mkdir docker && cd docker
        rhelDocker
        dock=$(sudo docker run hello-world &> /dev/null)
        if [ -z "$dock" ]; then
          rhelDocker
        else
          cd .. && echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "SUSE" ]] || [[ "$osINFO" =~ "openSUSE" ]]; then
        mkdir docker && cd docker
        slesDocker
        dock=$(sudo docker run hello-world &> /dev/null)
        if [ -z "$dock" ]; then
          slesDocker
        else
          cd .. && echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Ubuntu" ]]; then
        mkdir docker && cd docker
        ubuntuDocker
        dock=$(sudo docker run hello-world &> /dev/null)
        if [ -z "$dock" ]; then
          ubuntuDocker
        else
          cd .. && echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Raspbian" ]]; then
        raspiDocker
        dock=$(sudo docker run hello-world &> /dev/null)
        if [ -z "$dock" ]; then
          raspiDocker
        else
          echo "Docker berhasil diinstal"
        fi
      else
        binaryDocker
        dock=$(sudo docker run hello-world &> /dev/null)
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
    - name: Menjalankan Docker Compose untuk $mts
      shell: "docker {{ lookup('env', 'PWD') }}/docker/docker-compose up -d"
      async: 0
      poll: 0
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
    cp modbus/runmodbusServer.yml modbus/rcusmodbusServer.yml
    sed -i "s/port=502/port=\$3/" modbus/rcusmodbusServer.yml
    rcustom="ansible-playbook -i inventory.ini modbus/rcusmodbusServer.yml"
    [[ "\$USER" == "root" ]] && rcustom+=" -K"
    eval "\$rcustom"
  fi
elif [[ "\$1" == "run" ]]; then
  runstd="ansible-playbook -i inventory.ini modbus/runmodbusServer.yml"
  [[ "\$USER" == "root" ]] && runstd+=" -K"
  eval "\$runstd"
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
    - name: Menghentikan Docker Compose untuk $mts
      shell: "docker {{ lookup('env', 'PWD') }}/docker/docker-compose down -d"
      ignore_errors: true
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
      - "$nport:502"
    restart: always
EOL
    echo "$com berhasil dibuat"
    fi
    psdoc=$(ps aux | grep -Ev "auto" | grep docker)
    if [[ "$psdoc" =~ "docker" ]]; then
      ps aux | grep docker | awk '{ print $2 }' | xargs -I % sudo kill -9 % &> /dev/null
      nohup sudo dockerd > /dev/null 2>&1 &
      docker pull $image &> /dev/null
      echo "Proses Build Image"
      docker build -t $image -f Dockerfile . &> /dev/null
    else
      echo "Menjalankan docker daemon"
      nohup sudo dockerd > /dev/null 2>&1 &
      docker pull $image &> /dev/null
      echo "Proses Build Image"
      docker build -t $image -f Dockerfile . &> /dev/null
    fi
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$rmodServer" ] && [ -e "$smodServer" ]; then
      echo Terjadi kesalahan instalasi$'\n'Proses instal ulang && cd .. && ./modbusInstaller.sh -i
    else
      docker ps -a | sed -n '1!p' | awk '{ print $1 }' | xargs -I % docker rm -f % &> /dev/null
      echo Instalasi selesai$'\n\n'Berikut struktur file && cd .. && echo "" >> $readme && echo "Untuk Menjalankan:" >> $readme && echo "  ./modbusServer.sh -h" >> $readme && echo "" >> $readme && ls | grep .tgz | xargs -I % rm -rf % && tree
    fi
  elif [[ "$1" -eq "-c" ]] || [[ "$1" -eq "--clear" ]]; then
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$rmodServer" ] && [ -e "$smodServer" ]; then
      echo "Terjadi kesalahan ketika menghapus, mohon jalankan ulang program"
    else
      echo $invenFile$'\n'$mds.sh$'\n'$f$'\n'$readme$'\n'$dc$'\n'$docbin | grep -Ev "Installer" | xargs -I % rm -rf % && echo ''$'\n'Berkas berhasil dihapus
    fi
  fi
fi