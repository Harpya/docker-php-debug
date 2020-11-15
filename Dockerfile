FROM harpya/php72-fpm-xdebug:latest

WORKDIR /var/www/html

ARG CACHEBUST=1

COPY  xdebug.ini /usr/local/etc/php/conf.d
COPY  run_fpm.sh /root
COPY  phalcon.ini /usr/local/etc/php/conf.d/phalcon.ini 
COPY  zephir.phar /usr/bin/zephir
COPY  test.sh /root

RUN chmod 755 /root/run_fpm.sh
RUN chmod +x /usr/bin/zephir

RUN rm -rf /usr/local/etc/php/conf.d/zz-docker.conf

ENV XDEBUG_CONFIG "remote_connect_back=0"
#ENV PHP_IDE_CONFIG="serverName="


RUN cd && git clone https://github.com/jbboehr/php-psr.git \
    && cd php-psr \
    && phpize \
    && ./configure \
    && make \ 
    && make install

RUN cd && git clone git://github.com/phalcon/php-zephir-parser.git \
    && cd php-zephir-parser \
    && phpize \ 
    && ./configure \ 
    && make \ 
    && make install 


RUN cd && git clone https://github.com/phalcon/cphalcon \
    && cd cphalcon/ \
    && git checkout tags/v4.1.0 ./ \
    && zephir fullclean \
    && echo "memory_limit=400M" > /usr/local/etc/php/conf.d/temp.ini \
    && zephir build \ 
    && cp /root/cphalcon/ext/modules/phalcon.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/phalcon.so \
    && rm -rf /root/cphalcon /root/php-psr /root/php-zephir-parser /root/xdebug-2.6.1 /var/lib/apt/lists/*  /usr/local/etc/php/conf.d/temp.ini

RUN docker-php-ext-install pdo_pgsql sockets

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/bin/composer

RUN chmod +x /root/test.sh && bash /root/test.sh
