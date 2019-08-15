#!/bin/sh

# Error out if anything fails.
set -e

# Make sure script is run as root.
if [ "$(id -u)" != "0" ]; then
  echo "Você precisa de permissão de administrador! Tente: sudo ./install.sh"
  exit 1
fi

echo "Instalando dependências..."
echo "=========================="
apt update && apt -y install git build-essential python3-dev python3 python3-pip python3-pygame supervisor omxplayer

echo "Instalando Codec..."
echo "========================="
git clone https://github.com/jopdev/hellopi.git
cd hellopi
./rebuild.sh
cd hello_video
make install
cd ../..
rm -rf hellopi

echo "Instalando Player..."
echo "=================================="
mkdir -p /mnt/usbdrive0 # This is very important if you put your system in readonly after
pip3 install setuptools
python3 setup.py install --force
cp video_looper.ini /boot/video_looper.ini

echo "Configurando Player para iniciar automaticamente..."
echo "==========================================="
cp video_looper.conf /etc/supervisor/conf.d/
service supervisor restart

echo "Finalizado!"
