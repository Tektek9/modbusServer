#!/bin/bash

source config/var.conf

if [[ "$#" -lt 1 ]]; then
    echo -e "\nUntuk bantuan\n\n  ./$modIns -h\n  atau\n  ./$modIns --help"
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
        if [ -z "$(echo "$cekdoc")" ]; then
          centosDocker
        else
          echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Debian" ]]; then
        debianDocker
        if [ -z "$(echo "$cekdoc")" ]; then
          debianDocker
        else
          echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Fedora" ]]; then
        fedoraDocker
        if [ -z "$(echo "$cekdoc")" ]; then
          fedoraDocker
        else
          echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Red Hat" ]]; then
        rhelDocker
        if [ -z "$(echo "$cekdoc")k" ]; then
          rhelDocker
        else
          echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "SUSE" ]] || [[ "$osINFO" =~ "openSUSE" ]]; then
        slesDocker
        if [ -z "$(echo "$cekdoc")" ]; then
          slesDocker
        else
          echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Ubuntu" ]]; then
        ubuntuDocker
        if [ -z "$(echo "$cekdoc")" ]; then
          ubuntuDocker
        else
          echo "Docker berhasil diinstal"
        fi
      elif [[ "$osINFO" =~ "Raspbian" ]]; then
        raspiDocker
        if [ -z "$(echo "$cekdoc")" ]; then
          raspiDocker
        else
          echo "Docker berhasil diinstal"
        fi
      else
        binaryDocker "$docbin"
        if [ -z "$(echo "$cekdoc")" ]; then
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
        becomeUsr="root"
        invenCreate "$mb" "$Fi" "$invenFile" "$mds" "$becomeUsr" "$passwd" "$locpy"
        echo "$invenFile berhasil dibuat"
      else 
        becomeUsr="some_user"
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
    cek=$(echo "$psdocker")
    if [[ "$cek" =~ "docker" ]]; then
      eval "$psaux"
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
      eval "$dpsa"
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