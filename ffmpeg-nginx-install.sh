#!/bin/bash
#Update Server
	sudo apt update -y
	sudo apt upgrade -y

#Time and Date update and Network Tools 
	sudo timedatectl set-timezone Asia/Kolkata
	sudo apt install net-tools -y

#Install Dependency to Run Streaming
	sudo apt install -y git wget vim build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev unzip

#Install FFmpeg
	sudo mkdir -p /opt/ffmpeg
	cd /opt/ffmpeg
	sudo wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz

##Extract the static build from the archive.
	sudo tar xvf ffmpeg*.xz
	cd ffmpeg-*-static
	ls

##Install the binaries globally.
	sudo ln -s "${PWD}/ffmpeg" /usr/local/bin/
	sudo ln -s "${PWD}/ffprobe" /usr/local/bin/

#=====================================================================================================#

#Install Nginx with RTMP Module.
	sudo mkdir -p /opt/nginx
	cd /opt/nginx
	sudo chown ubuntu:ubuntu
	
##Download nginx-1.19.0
	wget https://github.com/pankajthakur888/streaming/blob/main/nginx-1.19.0.tar.gz
	#wget https://nginx.org/download/nginx-1.19.0.tar.gz
	tar zxf nginx-1.19.0.tar.gz
	
##Download nginx-rtmp module
	wget https://github.com/pankajthakur888/streaming/raw/main/nginx-rtmp.zip
	unzip nginx-rtmp.zip
	
##Download nginx-ts-module module
	git clone https://github.com/arut/nginx-ts-module.git
	
##Compile with Nginx with RTMP Module
	cd nginx-1.19.0
	#sudo ./configure --prefix=/usr/local/nginx --with-http_ssl_module --add-module=../nginx-rtmp-module
	sudo ./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_secure_link_module --add-module=../nginx-rtmp-module
	sudo make
	sudo make install
	ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
	
##Configuration with Nginx
	sudo mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf-old
	cd /usr/local/nginx/conf/
	sudo wget https://github.com/pankajthakur888/streaming/raw/main/nginx.conf
	
##Creating Dir for DASH AND HLS Chunks
	sudo mkdir -p /mnt/sd
	sudo mdkir -p /mnt/hd

##Check Stop and Start Nginx
	sudo /usr/local/nginx/sbin/nginx -t
	sudo /usr/local/nginx/sbin/nginx -s stop
	sudo /usr/local/nginx/sbin/nginx
	
#sudo rm -f -R /usr/local/nginx && rm -f /usr/local/sbin/nginx

	
