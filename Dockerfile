FROM centos:7
LABEL author=ljm email=ljmict@163.com
RUN yum install epel-release -y \
    && yum install libxml2-devel bzip2-devel libmcrypt-devel gcc gcc-c++- make openssl-devel libsqlite3x-devel oniguruma-devel -y \
    && yum clean all
ENV PHP_VERSION=7.4.0 NGINX_VERSION=1.17.6
ADD php-${PHP_VERSION}.tar.xz /tmp
ADD docker-entrypoint.sh /usr/local/bin
WORKDIR /tmp/php-${PHP_VERSION}
RUN ./configure \
    --prefix=/apps/php-${PHP_VERSION} --enable-mysqlnd \
    --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
    --with-openssl --with-freetype-dir --with-jpeg-dir \
    --with-png-dir --with-zlib --with-libxml-dir=/usr \
    --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d \
    --enable-mbstring --enable-xml --enable-sockets --enable-fpm \
    --enable-maintainer-zts --disable-fileinfo \
    && make && make install && make clean \
    && ln -s /apps/php-${PHP_VERSION}/sbin/php-fpm /usr/local/bin/php-fpm \
    && cp php.ini-production /etc/php.ini && cd /tmp && rm -rf php-${PHP_VERSION} 
WORKDIR /apps/php-${PHP_VERSION}
EXPOSE 9000/tcp
CMD ["php-fpm", "-F"]
ENTRYPOINT ["docker-entrypoint.sh"]
