FROM ubuntu:18.04

ENV PHPIZE_DEPS \
		autoconf \
		dpkg-dev \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pkg-config \
		re2c

# persistent / runtime deps
RUN apt-get update && apt-get install -y \
		$PHPIZE_DEPS \
		ca-certificates \
		curl \
		xz-utils \
    apache2 \
	--no-install-recommends

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
RUN mkdir $APACHE_RUN_DIR

# Apache + PHP requires preforking Apache for best results
RUN a2dismod mpm_event && a2enmod mpm_prefork
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y php mysql-client mysql-server unzip php7.2-mysql

RUN curl -O https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.zip && unzip phpMyAdmin-4.9.0.1-all-languages.zip && ls && mv phpMyAdmin-4.9.0.1-all-languages /var/www/html/
COPY docker-php.conf /etc/apache2/conf-available/

RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && usermod -d /var/lib/mysql/ mysql

EXPOSE 80
ENTRYPOINT ["apache2", "-DFOREGROUND"]
