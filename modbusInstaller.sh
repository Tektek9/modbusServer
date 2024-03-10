#!/bin/bash

source funct.conf
source config.ini
source secret.txt

mds="modbusServer"
mts="Modbus TCP Server"
dc="docker"
f="modbus"
mb="Membuat"
nm="ansible"
Fi="file inventory"
p="playbook"

image=$pkg1
docbin=$pkg2
osINFO=$check1
dpkgconf=$check2
ans=$check3
dcom=$check4
cekdoc=$check5
df=$file1
com=$file2
req=$file3
invenFile=$file4
modServer=$file5
rmodServer=$file6
smodServer=$file7
currUser=$usr
passwd=$pwd
host=$hosts
modport=$mport
newport=$nport
locpy=$pyloc

if [[ -z "$1" ]]; then
    echo ''$'\n'Untuk bantuan$'\n'  ./$file12 -h$'\n'  atau$'\n'  ./$file12 --help
elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-c" ]] || [[ "$1" == "--clear" ]] || [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    installerHelp
  elif [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
    echo ""$'\n'Menjalankan Setup
    echo "$check7"
    if [ -z "$dpkgconf" ]; then
    echo "Pengecekan Ansible"
    else
      echo "$check2"
    fi
    if [ -z "$ans" ]; then
      echo Ansible belum terinstal'$\n'Melakukan instal Ansible $nm && ansibleInstall && echo "Ansible berhasil diinstal" && echo "Menginstal Docker"
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
          cd .. && echo "Docker berhasil diinstal" && echo "$check6"
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
    if [ -e "$file5" ]; then
      echo "File $file5 sudah ada"
    else
    echo "Membuat file $file5"
    
    echo "$file5 berhasil dibuat"
    fi
    if [ -e "$rmodServer" ]; then
      echo "File $rmodServer sudah ada"
    else
    echo "Membuat file $rmodServer"
    runmodCreate
    echo "$rmodServer berhasil dibuat"
    fi
    if [ -e "$file9" ]; then
      echo "File $file9 sudah ada"
    else
      echo "$mb file $file9"
      cd ..
      assistCreate
      chmod +x $file9
      echo "$file9 berhasil dibuat"
      cd modbus
    fi
    if [ -e "$invenFile" ]; then
      echo "$Fi $nm sudah ada, silahkan cek pada $invenFile"
    else
      cd ..
      if [ "$currUser" == "root" ]; then
        becomeUsr="some_user"
        invenCreate && echo "$invenFile berhasil dibuat"
      else 
        becomeUsr="root"
        invenCreate && echo "$invenFile berhasil dibuat"
      fi
      cd modbus
    fi
    if [ -e "$smodServer" ]; then
      echo "File $smodServer sudah ada"
    else
      echo "$mb $p $smodServer"
      stopmodCreate
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
      echo "$mb $req untuk docker" && reqCreate && echo "$req berhasil dibuat"
    fi
    if [ -e "$df" ]; then
      echo "File $df sudah ada"
    else
      echo "$mb $df"
      dockerfileCreate
    echo "$df berhasil dibuat"
    fi
    if [ -e "$com" ]; then
      echo "File $com sudah ada"
    else
      echo "$mb $com"
      composeCreate
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
      echo "$check8"
      dockerDaemon
    else
      echo "Menjalankan docker daemon"
      dockerDaemon
    fi
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$rmodServer" ] && [ -e "$smodServer" ]; then
      echo Terjadi kesalahan instalasi$'\n'Proses instal ulang && cd .. && ./$file12 -i
    else
      docker ps -a | sed -n '1!p' | awk '{ print $1 }' | xargs -I % docker rm -f % &> /dev/null
      echo Instalasi selesai$'\n\n'Berikut struktur file && cd .. && ls | grep .tgz | xargs -I % rm -rf % && tree
    fi
  elif [[ "$1" -eq "-c" ]] || [[ "$1" -eq "--clear" ]]; then
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$rmodServer" ] && [ -e "$smodServer" ]; then
      echo "Terjadi kesalahan ketika menghapus, mohon jalankan ulang program"
    else
      echo $invenFile$'\n'$file9$'\n'$f$'\n'$dc$'\n'$docbin | grep -Ev "Installer" | xargs -I % rm -rf % && echo ''$'\n'Berkas berhasil dihapus
    fi
  fi
fi