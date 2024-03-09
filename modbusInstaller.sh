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
dc="docker"
docbin="docker-17.03.0-ce.tgz"
readme="Readme"
f="modbus"
mb="Membuat"
runans="ansible-playbook -i $invenFile $f/"
runansroot="ansible-playbook -i $invenFile -K $f/"
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
  sudo systemctl start docker &> /dev/null
}

debianDocker() {
  sudo apt-get update &> /dev/null
  sudo apt-get install ca-certificates curl &> /dev/null
  sudo install -m 0755 -d /etc/apt/keyrings &> /dev/null
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc &> /dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.asc &> /dev/null
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update &> /dev/null
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
}

fedoraDocker() {
  sudo dnf -y install dnf-plugins-core &> /dev/null
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &> /dev/null
  sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
  sudo systemctl start docker &> /dev/null
}

rhelDocker() {
  sudo yum install -y yum-utils &> /dev/null
  sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo &> /dev/null
  sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
  sudo systemctl start docker &> /dev/null
}

slesDocker() {
  sudo apt-get update &> /dev/null
  sudo zypper addrepo https://download.docker.com/linux/sles/docker-ce.repo &> /dev/null
  sudo zypper install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
  sudo systemctl start docker &> /dev/null
}

ubuntuDocker() {
  sudo apt-get update &> /dev/null
  sudo apt-get install ca-certificates curl &> /dev/null
  sudo install -m 0755 -d /etc/apt/keyrings &> /dev/null
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &> /dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.asc &> /dev/null
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update &> /dev/null
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
}

raspiDocker() {
  sudo apt-get update &> /dev/null
  sudo apt-get install -y ca-certificates curl &> /dev/null
  sudo install -m 0755 -d /etc/apt/keyrings &> /dev/null
  sudo curl -fsSL https://download.docker.com/linux/raspbian/gpg -o /etc/apt/keyrings/docker.asc &> /dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.asc &> /dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/raspbian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update &> /dev/null
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
}

binaryDocker() {
  wget https://download.docker.com/linux/static/stable/x86_64/$docbin &> /dev/null
  tar xzvf docker-17.03.0-ce.tgz &> /dev/null
  sudo cp docker/* /usr/bin/
  sudo dockerd &
}

if [[ -z "$1" ]]; then
    bantuan=$(echo ''$'\n'Untuk bantuan$'\n'  ./modbusInstaller.sh -h$'\n'  atau$'\n'  ./modbusInstaller.sh --help)
    echo "$bantuan" 2> /dev/null
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
    pip install distro &> /dev/null
    if [ -z "$dpkgconf" ]; then
    echo "Pengecekan Ansible"
    else
      sudo dpkg --configure -a
    fi
    if [ -z "$ans" ]; then
      echo Ansible belum terinstal'$\n'Melakukan instal Ansible $nm && sudo apt-get update && sudo apt-get install -y $nm && echo "Ansible berhasil diinstal" && echo "Menginstall Docker" && mkdir docker && cd docker
    else
      echo "Ansible terinstal" && echo "Menginstall Docker" && mkdir docker && cd docker
    fi
    if [[ "$osINFO" =~ "CentOS" ]]; then
      centosDocker
      dock=$(sudo docker run hello-world)
      if [ -z "$dock" ]; then
        centosDocker
      else
        echo "Docker berhasil diinstall"
      fi
    elif [[ "$osINFO" =~ "Debian" ]]; then
      debianDocker
      dock=$(sudo docker run hello-world)
      if [ -z "$dock" ]; then
        debianDocker
      else
        echo "Docker berhasil diinstall"
      fi
    elif [[ "$osINFO" =~ "Fedora" ]]; then
      fedoraDocker
      dock=$(sudo docker run hello-world)
      if [ -z "$dock" ]; then
        fedoraDocker
      else
        echo "Docker berhasil diinstall"
      fi
    elif [[ "$osINFO" =~ "Red Hat" ]]; then
      rhelDocker
      dock=$(sudo docker run hello-world)
      if [ -z "$dock" ]; then
        rhelDocker
      else
        echo "Docker berhasil diinstall"
      fi
    elif [[ "$osINFO" =~ "SUSE" ]] || [[ "$osINFO" =~ "openSUSE" ]]; then
      slesDocker
      dock=$(sudo docker run hello-world)
      if [ -z "$dock" ]; then
        slesDocker
      else
        echo "Docker berhasil diinstall"
      fi
    elif [[ "$osINFO" =~ "Ubuntu" ]]; then
      ubuntuDocker
      dock=$(sudo docker run hello-world)
      if [ -z "$dock" ]; then
        ubuntuDocker
      else
        echo "Docker berhasil diinstall"
      fi
    elif [[ "$osINFO" =~ "Raspbian" ]]; then
      raspiDocker
      dock=$(sudo docker run hello-world)
      if [ -z "$dock" ]; then
        raspiDocker
      else
        echo "Docker berhasil diinstall"
      fi
    else
      binaryDocker
      dock=$(sudo docker run hello-world)
      if [ -z "$dock" ]; then
        binaryDocker
      else
        echo "Docker berhasil diinstall"
      fi
    fi
    echo "User saat ini: $currUser"
    if [ -e "$f" ]; then
      echo "Folder $f sudah ada" && cd $f && echo "$mb $p $rmodServer"
    else
      echo "Proses $mb folder $f" && mkdir $f && cd $f && echo "$mb $p $rmodServer"
    fi
    if [ -e "$rmodServer" ]; then
      echo "File $rmodServer sudah ada"
    else
    cat <<EOL > $rmodServer
---
- name: Menginstal dan menjalankan $mts
  hosts: $mds 
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

    - name: Menginstal pymodbus library
      pip:
        name: "{{ item }}"
        executable: pip3

      loop:
        - pyModbusTCP

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

    - name: Menjalankan modbus server
      shell: "nohup python3 {{ lookup('env', 'PWD') }}/$f/$mds.py > /dev/null 2>&1 &"
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
  elif [[ "\$1" == "run" ]]; then
    if [[ "$currUser" == "ROOT" ]]; then
        $runansroot$rmodServer
    else
        $runans$rmodServer
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
  hosts: $mds 
  become: no
  become_user: "{{ ansible_user }}"

  tasks:
    - name: Mencari dan mematikan $mts
      shell: "ps aux | grep \"{{ lookup('env', 'PWD') }}/$f/modbusServer.py\" | grep -Ev 'auto' | awk '{ print \$2 }' | xargs -I % sudo kill -9 % > /dev/null 2>&1 || true"
      ignore_errors: true
EOL
    echo "$smodServer berhasil dibuat"
    fi
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$rmodServer" ] && [ -e "$smodServer" ]; then
      echo Terjadi kesalahan instalasi$'\n'Proses instal ulang && cd .. && ./modbusInstaller.sh -i
    else
      echo Instalasi selesai$'\n\n'Berikut struktur file && cd .. && echo "" >> $readme && echo "Untuk Menjalankan:" >> $readme && echo "  ./modbusServer.sh -h" >> $readme && echo "" >> $readme && tree
    fi
  elif [[ "$1" -eq "-c" ]] || [[ "$1" -eq "--clear" ]]; then
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$rmodServer" ] && [ -e "$smodServer" ]; then
      echo "Terjadi kesalahan ketika menghapus, mohon jalankan ulang program"
    else
      echo $invenFile$'\n'$mds.sh$'\n'$f$'\n'$readme$'\n'$dc$'\n'$docbin | grep -Ev "Installer" | xargs -I % rm -rf % && echo ''$'\n'Berkas berhasil dihapus
    fi  
  fi
fi