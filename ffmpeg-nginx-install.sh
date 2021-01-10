#!/bin/bash
#Update Server
	sudo apt update -y
	sudo apt upgrade -y

#Time and Date update and Network Tools 
	sudo timedatectl set-timezone Asia/Kolkata
	sudo apt install net-tools -y

#Install Dependency to Run Streaming
	sudo apt install -y git wget vim build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev

#Install FFmpeg
	sudo mkdir -p /opt/ffmpeg
	cd /opt/ffmpeg
	sudo wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz

#Extract the static build from the archive.
	sudo tar xvf ffmpeg*.xz
	cd ffmpeg-*-static
	ls

#Install the binaries globally.
	sudo ln -s "${PWD}/ffmpeg" /usr/local/bin/
	sudo ln -s "${PWD}/ffprobe" /usr/local/bin/

#=======================================================================================

#Install Nginx 
	sudo mkdir -p /opt/nginx
	cd /opt/nginx
	sudo wget http://nginx.org/download/nginx-1.19.6.zip
	sudo unzip nginx-rtmp.zip
	sudo wget https://github.com/pankajthakur888/streaming/raw/main/nginx-rtmp.zip
	sudo unzip nginx-rtmp.zip
	cd nginx*
	sudo ./configure --prefix=/usr/local/nginx --with-http_ssl_module --add-module=../nginx-rtmp-module
	sudo make
	sudo make install
