FROM centos:7
LABEL author=ljm email=ljmict@163.com
ENV PHP_VERSION=7.4.0 \
    PHPFPM_USER=nginx \
    PHPFPM_GROUP=nginx
RUN yum install epel-release -y \
    && yum install libxml2-devel bzip2-devel libmcrypt-devel gcc gcc-c++- make openssl-devel libsqlite3x-devel oniguruma-devel -y \
    && yum clean all
RUN curl https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz -o /tmp/php-${PHP_VERSION}.tar.xz
WORKDIR /tmp
RUN tar xf php-${PHP_VERSION}.tar.xz && rm -f php-${PHP_VERSION}.tar.xz
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
RUN mv etc/php-fpm.conf.default etc/php-fpm.conf \
    && mv etc/php-fpm.d/www.conf.default /apps/php-${PHP_VERSION}/etc/php-fpm.d/www.conf \
    && sed -i 's#127.0.0.1:9000#0.0.0.0:9000#g' /apps/php-${PHP_VERSION}/etc/php-fpm.d/www.conf \
    && sed -i "s#user = nobody#user = ${PHPFPM_USER}#g" /apps/php-${PHP_VERSION}/etc/php-fpm.d/www.conf \
    && sed -i "s#group = nobody#user = ${PHPFPM_GROUP}#g" /apps/php-${PHP_VERSION}/etc/php-fpm.d/www.conf 
EXPOSE 9000/tcp
ENTRYPOINT ["php-fpm", "-F"]
