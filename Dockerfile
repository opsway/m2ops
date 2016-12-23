FROM opsway/mage2php

ARG MAGENTO_KEY
ARG MAGENTO_SECRET
ARG GITHUB_AUTH

ENV XDEBUG_VERSION XDEBUG_2_4_1

RUN docker-php-source extract \
    && cd /tmp && curl -L -o /tmp/xdebug.tar.gz "https://github.com/xdebug/xdebug/archive/$XDEBUG_VERSION.tar.gz" \
    && tar xfz /tmp/xdebug.tar.gz \
    && rm -r /tmp/xdebug.tar.gz \
    && ( \
           cd "/tmp/xdebug-$XDEBUG_VERSION" \
           && phpize \
           && ./configure \
           && make -j$(nproc) \
           && make install \
       ) \
    && docker-php-ext-enable xdebug \
    && rm -Rf "/tmp/xdebug-$XDEBUG_VERSION" \
&& docker-php-source delete

RUN curl -O https://files.magerun.net/n98-magerun2.phar
RUN chmod +x ./n98-magerun2.phar
RUN cp ./n98-magerun2.phar /usr/local/bin/

WORKDIR /var/www/html
ADD . .

COPY docker-entrypoint.sh /entrypoint.sh
ENV TERM="xterm"
RUN ["chmod", "a+x", "/entrypoint.sh"]
CMD ["true"]
ENTRYPOINT ["/entrypoint.sh"]

RUN chown -R www-data:www-data /var/www
USER www-data

RUN composer config -g http-basic.repo.magento.com $MAGENTO_KEY $MAGENTO_SECRET
RUN composer config -g github-oauth.github.com $GITHUB_AUTH
RUN composer install -n

RUN chmod +x ./bin/magento
VOLUME /var/www/html