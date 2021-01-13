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

#Install Nginx with RTMP Module.
	sudo mkdir -p /opt/nginx
	cd /opt/nginx
	
##Download nginx-1.19.6
	sudo wget https://github.com/pankajthakur888/streaming/raw/main/nginx-1.19.6.zip
	sudo unzip nginx-1.19.6.zip
	
##Download nginx-rtmp module
	sudo wget https://github.com/pankajthakur888/streaming/raw/main/nginx-rtmp.zip
	sudo unzip nginx-rtmp.zip
	
##Compile with Nginx with RTMP Module
	cd nginx-1.19.6
	#sudo ./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_secure_link_module --add-module=../nginx-rtmp-module
  ./configure --prefix=/etc/nginx \ 
            --sbin-path=/usr/sbin/nginx \ 
            --modules-path=/usr/lib/nginx/modules \ 
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=nginx \
            --group=nginx \
            --build=Ubuntu \
            --builddir=nginx-1.15.0 \
            --with-select_module \
            --with-poll_module \
            --with-threads \
            --with-file-aio \
            --with-http_ssl_module \
            --with-http_v2_module \
            --with-http_realip_module \
            --with-http_addition_module \
            --with-http_xslt_module=dynamic \
            --with-http_image_filter_module=dynamic \
            --with-http_geoip_module=dynamic \
            --with-http_sub_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_mp4_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_auth_request_module \
            --with-http_random_index_module \
            --with-http_secure_link_module \
            --with-http_degradation_module \
            --with-http_slice_module \
            --with-http_stub_status_module \
            --with-http_perl_module=dynamic \
            --with-perl_modules_path=/usr/share/perl/5.26.1 \
            --with-perl=/usr/bin/perl \
            --http-log-path=/var/log/nginx/access.log \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-mail=dynamic \
            --with-mail_ssl_module \
            --with-stream=dynamic \
            --with-stream_ssl_module \
            --with-stream_realip_module \
            --with-stream_geoip_module=dynamic \
            --with-stream_ssl_preread_module \
            --with-compat \
            --with-pcre=../pcre-8.42 \
            --with-pcre-jit \
            --with-zlib=../zlib-1.2.11 \
            --with-openssl=../openssl-1.1.0h \
            --with-openssl-opt=no-nextprotoneg \
            --with-debug

	sudo make
	sudo make install
	ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
	
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
	
	
