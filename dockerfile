FROM centos

RUN yum -y update; yum clean all 
RUN yum -y install epel-release tar ; yum clean all 
RUN yum -y install gcc make wget vim git openssl openssl-devel PCRE zlib zlib-devel ; yum clean all

WORKDIR /root
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz
RUN tar -xzf GeoLite2-City.mmdb.gz
RUN tar -xzf GeoLite2-Country.mmdb.gz
RUN git clone https://github.com/leev/ngx_http_geoip2_module.git
RUN wget http://nginx.org/download/nginx-1.15.12.tar.gz
RUN tar -xzf nginx-1.15.12.tar.gz
RUN wget https://github.com/maxmind/libmaxminddb/releases/download/1.3.2/libmaxminddb-1.3.2.tar.gz
RUN tar -xzf libmaxminddb-1.3.2.tar.gz

WORKDIR /root/libmaxminddb-1.3.2
RUN ./configure && make && make install && ldconfig
RUN sh -c "echo /usr/local/lib  >> /etc/ld.so.conf.d/local.conf" && ldconfig

WORKDIR /root/nginx-1.15.12
RUN ./configure --add-module=/root/ngx_http_geoip2_module --with-http_ssl_module --with-http_secure_link_module --without-http_rewrite_module \
&& make && make install

COPY /root/nginx/nginx.conf /usr/local/nginx/conf/nginx.conf

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
