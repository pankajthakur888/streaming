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

##Extract the static build from the archive.
	sudo tar xvf ffmpeg*.xz
	cd ffmpeg-*-static
	ls

##Install the binaries globally.
	sudo ln -s "${PWD}/ffmpeg" /usr/local/bin/
	sudo ln -s "${PWD}/ffprobe" /usr/local/bin/

#=====================================================================================================#
#Create NGINX system group and user:
	sudo adduser --system --home /nonexistent --shell /bin/false --no-create-home --disabled-login --disabled-password --gecos "nginx user" --group nginx

#Install Nginx with RTMP Module.
	sudo mkdir -p /opt/nginx
	cd /opt/nginx
	
##Download nginx-1.19.6
	sudo wget https://github.com/pankajthakur888/streaming/raw/main/nginx-1.19.6.zip
	sudo unzip nginx-1.19.6.zip
	
##Download nginx-rtmp module
	sudo wget https://github.com/pankajthakur888/streaming/raw/main/nginx-rtmp.zip
	sudo unzip nginx-rtmp.zip

#Download the mandatory NGINX dependencies' source code and extract them:
	## PCRE version 8.42
	wget https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz && tar xzvf pcre-8.42.tar.gz

	## zlib version 1.2.11
	wget https://www.zlib.net/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz

	## OpenSSL version 1.1.0h
	wget https://www.openssl.org/source/openssl-1.1.0h.tar.gz && tar xzvf openssl-1.1.0h.tar.gz
	
#Install optional NGINX dependencies:
	sudo add-apt-repository -y ppa:maxmind/ppa
	sudo apt update && sudo apt upgrade -y 
	sudo apt install -y perl libperl-dev libgd3 libgd-dev libgeoip1 libgeoip-dev geoip-bin libxml2 libxml2-dev libxslt1.1 libxslt1-dev
	
#Clean up all .tar.gz files. We don't need them anymore:
	rm -rf *.tar.gz
	
#Copy NGINX manual page to /usr/share/man/man8/ directory:
	sudo cp ~/nginx-1.15.0/man/nginx.8 /usr/share/man/man8
	sudo cat /usr/share/man/man8/nginx.8
	ls /usr/share/man/man8/ | grep nginx.8.gz
	# Check that Man page for NGINX is working:
	man nginx

#Compile with Nginx with RTMP Module
	cd nginx-1.19.0
	
	#sudo ./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_secure_link_module --add-module=../nginx-rtmp-module
#./configure --prefix=/usr/local/nginx \
#	--sbin-path=/usr/local/nginx/sbin/nginx \
#	--conf-path=/usr/local/nginx/conf/nginx.conf \
#	--pid-path=/usr/local/nginx/pid/nginx.pid \
#	--with-mail_ssl_module \
#	--with-stream=dynamic \
#	--with-stream_ssl_module \
#	--with-stream_geoip_module=dynamic \
#	--with-stream_ssl_preread_module \
#	--with-compat \
#	--with-http_ssl_module \
#	--with-pcre=../pcre-8.42 \
#	--with-pcre-jit \
#	--with-zlib=../zlib-1.2.11 \
#	--with-openssl=../openssl-1.1.0h \
#	--without-http_empty_gif_module \
#	--with-openssl-opt=no-nextprotoneg \
#	--with-http_secure_link_module \
#	--add-module=../nginx-rtmp-module
	
##WITH USER
./configure --prefix=/usr/local/nginx \
	--sbin-path=/usr/local/nginx/sbin/nginx \
	--conf-path=/usr/local/nginx/conf/nginx.conf \
	--pid-path=/usr/local/nginx/pid/nginx.pid \
        --user=nginx \
	--group=nginx \
	--build=Ubuntu \
	--with-mail_ssl_module \
	--with-stream=dynamic \
	--with-stream_ssl_module \
	--with-stream_realip_module \
	--with-stream_geoip_module=dynamic \
	--with-stream_ssl_preread_module \
	--with-compat \
	--with-http_ssl_module \
	--with-pcre=../pcre-8.42 \
	--with-pcre-jit \
	--with-zlib=../zlib-1.2.11 \
	--with-openssl=../openssl-1.1.0h \
	--without-http_empty_gif_module \
	--with-openssl-opt=no-nextprotoneg \
	--with-http_secure_link_module \
	--add-module=../nginx-rtmp-module
	
#./configure --prefix=/usr/local/nginx \
#	--sbin-path=/usr/local/nginx/sbin/nginx \
#	--conf-path=/usr/local/nginx/conf/nginx.conf \
#	--pid-path=/usr/local/nginx/pid/nginx.pid \
#	--user=nginx \
#	--group=nginx \
#	--build=Ubuntu \
#	--builddir=nginx-1.19.0 \
#	--with-poll_module \
#	--with-threads \
#	--with-file-aio \
#	--with-http_ssl_module \
#	--with-http_v2_module \
#	--with-http_realip_module \
#	--with-http_addition_module \
#	--with-http_xslt_module=dynamic \
#	--with-http_image_filter_module=dynamic \
#	--with-http_geoip_module=dynamic \
#	--with-http_dav_module \
#	--with-http_flv_module \
#	--with-http_mp4_module \
#	--with-http_gunzip_module \
#	--with-http_gzip_static_module \
#	--with-http_auth_request_module \
#	--with-http_random_index_module \
#	--with-http_secure_link_module \
#	--with-http_degradation_module \
#	--with-http_slice_module \
#	--with-http_stub_status_module \
#	--with-http_perl_module=dynamic \
#	--with-perl_modules_path=/usr/share/perl/5.26.1 \
#	--with-perl=/usr/bin/perl \
#	--http-log-path=/var/log/nginx/access.log \
#	--http-client-body-temp-path=/var/cache/nginx/client_temp \
#	--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
#	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
#	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
#	--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
#	--with-mail=dynamic \
#	--with-mail_ssl_module \
#	--with-stream=dynamic \
#	--with-stream_ssl_module \
#	--with-stream_realip_module \
#	--with-stream_geoip_module=dynamic \
#	--with-stream_ssl_preread_module \
#	--with-compat \
#	--with-pcre=../pcre-8.42 \
#	--with-pcre-jit \
#	--with-zlib=../zlib-1.2.11 \
#	--with-openssl=../openssl-1.1.0h \
#	--with-openssl-opt=no-nextprotoneg \
#	--with-debug \
#	--add-module=../nginx-rtmp-module

	make
	sudo make install

##After building NGINX, navigate to home (~) directory:
	cd ~

##Symlink /usr/lib/nginx/modules to /usr/local/nginx/modules directory. /usr/local/nginx/modules is a standard place for NGINX modules:
	sudo ln -s /usr/lib/nginx/modules /usr/local/nginx/modules
	#
	sudo ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
	
##Configuration with Nginx
	sudo mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf-old
	sudo cd /usr/local/nginx/conf/
	sudo wget https://github.com/pankajthakur888/streaming/raw/main/nginx.conf
	
##Creating Dir for DASH AND HLS Chunks
	sudo mkdir -p /mnt/sd
	sudo mdkir -p /mnt/hd

##Check Stop and Start Nginx
	sudo /usr/local/nginx/sbin/nginx -t
	sudo /usr/local/nginx/sbin/nginx -s stop
	sudo /usr/local/nginx/sbin/nginx
	
##Print the NGINX version, compiler version, and configure script parameters:
	sudo nginx -V
	
##Check NGINX syntax and potential errors:
	sudo nginx -t
	# Will throw this error -> nginx: [emerg] mkdir() "/var/cache/nginx/client_temp" failed (2: No such file or directory)

	# Create NGINX cache directories and set proper permissions
	sudo mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/proxy_temp /var/cache/nginx/scgi_temp /var/cache/nginx/uwsgi_temp
	sudo chmod 700 /var/cache/nginx/*
	sudo chown nginx:root /var/cache/nginx/*

	# Re-check syntax and potential errors.
	sudo nginx -t

##Remove all downloaded files from home directory:
	sudo cd /opt/nginx/
	rm -rf nginx-1.15.0/ openssl-1.1.0h/ pcre-8.42/ zlib-1.2.11/



