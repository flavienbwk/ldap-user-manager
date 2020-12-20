FROM php:7.0-apache

RUN apt-get update && apt-get install -y --no-install-recommends libldb-dev libldap2-dev && rm -rf /var/lib/apt/lists/* && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
&& ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so
RUN docker-php-source extract && docker-php-ext-install -j$(nproc) ldap && docker-php-source delete

ADD https://github.com/PHPMailer/PHPMailer/archive/v6.2.0.tar.gz /tmp

RUN a2enmod rewrite ssl
RUN a2dissite 000-default default-ssl

EXPOSE 80
EXPOSE 443

COPY www/ /opt/ldap_user_manager
RUN tar -xzf /tmp/v6.2.0.tar.gz -C /opt && mv /opt/PHPMailer-6.2.0 /opt/PHPMailer

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/local/bin/entrypoint.sh

CMD ["apache2-foreground"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
