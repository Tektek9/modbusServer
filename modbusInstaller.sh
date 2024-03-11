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

image="$pkg1"
docbin="$pkg2"
osINFO=$(eval "$check1")
dpkgconf=$(eval "$check2")
ans=$(eval "$check3")
dcom=$(eval "$check4")
cekdoc=$(eval "$check5")
dpsa=$(eval "$check6")
distro=$(eval "$check7")
psaux=$(eval "$check8")
psdocker=$(eval "$check9")
finish=$(eval "$check10")
df="$file1"
com="$file2"
req="$file3"
invenFile="$file4"
mServeryml="$file5"
mServersh="$file9"
rmodServer="$file6"
smodServer="$file7"
mServerpy="$file8"
rcmodServer="$file10"
scmodServer="$file11"
modIns="$file12"
currUser="$user"
passwd="$passwd"
host="$ip"
modport="$mport"
newport="$nport"
locpy="$pyloc"

if [[ "$#" -lt 1 ]]; then
    echo -e "\nUntuk bantuan\n\n  ./$modIns -h\n  atau\n  ./$modIns --help" 2>/dev/null
elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-c" ]] || [[ "$1" == "--clear" ]] || [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    installerHelp "$modIns"
  elif [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
    echo ""$'\n'Menjalankan Setup
    echo "$distro"
    if [ -z "$dpkgconf" ]; then
      echo "Pengecekan Ansible"
    else
      echo "$dpkgconf"
    fi
    if [ -z "$ans" ]; then
      echo Ansible belum terinstal'$\n'Melakukan instal Ansible $nm
      ansibleInstall "$nm"
      echo "Ansible berhasil diinstal"
      echo "Menginstal Docker"
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
          cd .. && echo "Docker berhasil diinstal" && echo "$dpsa"
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
        binaryDocker "$docbin"
        dock=$(echo "$cekdoc")
        if [ -z "$dock" ]; then
          binaryDocker "$docbin"
        else
          echo "Docker berhasil diinstal"
        fi
      fi
    else
      echo "Docker sudah terinstal"
    fi
    if [ -e "$f" ]; then
      echo "Folder $f sudah ada"
      cd $f
    else
      echo "$mb folder $f"
      mkdir $f
      echo "Folder $f berhasil dibuat"
      cd $f
    fi
    if [ -e "$mServeryml" ]; then
      echo "File $mServeryml sudah ada"
    else
      echo "Membuat file $mServeryml"
      modbusCreate "$mServeryml" "$mServerpy" "$mb" "$mts" "$host" "$modport" "$f"
      echo "$mServeryml berhasil dibuat"
    fi
    if [ -e "$rmodServer" ]; then
      echo "File $rmodServer sudah ada"
    else
      echo "Membuat file $rmodServer"
      runmodCreate "$rmodServer" "$mts" "$df" "$com"
      echo "$rmodServer berhasil dibuat"
    fi
    if [ -e "$mServersh" ]; then
      echo "File $mServersh sudah ada"
    else
      echo "$mb file $mServersh"
      cd ..
      assistCreate "$mServersh" "$invenFile" "$mServeryml" "$rcmodServer" "$rmodServer" "$smodServer"
      chmod +x $mServersh
      echo "$mServersh berhasil dibuat"
      cd modbus
    fi
    if [ -e "$invenFile" ]; then
      echo "$Fi $nm sudah ada, silahkan cek pada $invenFile"
    else
      cd ..
      if [ "$currUser" == "root" ]; then
        becomeUsr="some_user"
        invenCreate "$mb" "$Fi" "$invenFile" "$mds" "$becomeUsr" "$passwd" "$locpy"
        echo "$invenFile berhasil dibuat"
      else 
        becomeUsr="root"
        invenCreate "$mb" "$Fi" "$invenFile" "$mds" "$becomeUsr" "$passwd" "$locpy"
        echo "$invenFile berhasil dibuat"
      fi
      cd modbus
    fi
    if [ -e "$smodServer" ]; then
      echo "File $smodServer sudah ada"
    else
      echo "$mb $p $smodServer"
      stopmodCreate "$smodServer" "$mts" "$currUser" "$mServerpy"
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
      echo "$mb $req untuk docker"
      reqCreate "$req"
      echo "$req berhasil dibuat"
    fi
    if [ -e "$df" ]; then
      echo "File $df sudah ada"
    else
      echo "$mb $df"
      dockerfileCreate "$df" "$req" "$mServerpy"
      echo "$df berhasil dibuat"
    fi
    if [ -e "$com" ]; then
      echo "File $com sudah ada"
    else
      echo "$mb $com"
      composeCreate "$com" "$newport"
      echo "$com berhasil dibuat"
    fi
    if [[ "$dcom" =~ "version" ]]; then
      echo "Docker Compose sudah terinstal"
    else
      echo "Menginstal Docker Compose"
      dockerCompose
      echo "Instal Docker Compose selesai"
    fi
    psdoc=$(echo "$psdocker")
    if [[ "$psdoc" =~ "docker" ]]; then
      echo "$psaux"
      dockerDaemon "$image" "$df"
    else
      echo "Menjalankan docker daemon"
      dockerDaemon "$image" "$df"
    fi
    if [ -z "$ans" ] && [ -e "$invenFile" ] && [ -e "$rmodServer" ] && [ -e "$smodServer" ]; then
      echo Terjadi kesalahan instalasi$'\n'Proses instal ulang
      cd ..
      install="./$modIns -i"
      eval "$install"
    else
      echo "$dpsa"
      echo Instalasi selesai$'\n\n'Berikut struktur file
      cd ..
      echo "$finish"
      tree
    fi
  elif [[ "$1" -eq "-c" ]] || [[ "$1" -eq "--clear" ]]; then
    if [ -e "$invenFile" ] && [ -e "$mServersh" ] && [ -e "$f" ] && [ -e "$dc" ] && [ -e "$docbin" ]; then
      echo "Terjadi kesalahan ketika menghapus, mohon jalankan ulang program"
      clear="./$modIns -c"
      eval "$clear"
    else
      echo $invenFile$'\n'$mServersh$'\n'$f$'\n'$dc$'\n'$docbin | grep -Ev "Installer" | xargs -I % rm -rf %
      echo ''$'\n'Berkas berhasil dihapus
    fi
  fi
fi