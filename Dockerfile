FROM ubuntu:18.04


ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV HOME /usr/src/app
ENV DEBIAN_FRONTEND noninteractive
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
    php \
    mysql-client \
    mysql-server \
    unzip \
    php7.2-mysql \
	--no-install-recommends && \
  rm -r /var/lib/apt/lists/*

# Apache + PHP requires preforking Apache for best results
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOG_DIR && \
    a2dismod mpm_event && a2enmod mpm_prefork && \
    curl -O https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.zip && \
    unzip phpMyAdmin-4.9.0.1-all-languages.zip && \
    mv phpMyAdmin-4.9.0.1-all-languages /var/www/html/phpMyAdmin && \
    rm phpMyAdmin-4.9.0.1-all-languages.zip

COPY php/docker-php.conf /etc/apache2/conf-available/
COPY mysql/create-user.sql $HOME/create-user.sql
COPY entrypoint.sh $HOME/entrypoint.sh
WORKDIR $HOME

EXPOSE 80
ENTRYPOINT ["./entrypoint.sh"]
