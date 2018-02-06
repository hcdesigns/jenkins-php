FROM jenkins/jenkins:lts

LABEL maintainer="Harvey Chow <harvey@hcdesigns.nl>"

ENV DEBIAN_FRONTEND noninteractive

# if we want to install via apt
USER root

RUN apt-get update

RUN apt-get install -y vim nano openssl curl wget build-essential software-properties-common git

# RUN add-apt-repository ppa:ondrej/php && \
#     apt-get update

RUN apt-get install -y \
    php \
    php-dev \
    php-cli \
    php-common \
    php-xdebug \
    php-xsl \
    php-dom \
    php-intl \
    php-zip \
    php-mbstring \
    php-mcrypt \
    php-curl \
    php-gd \
    php-zip \
    php-xml \
    php-mysql

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');" && \
    chown -R jenkins:jenkins ~/.composer/

# drop back to the regular jenkins user - good practice
USER jenkins

RUN composer global config minimum-stability dev && \
    composer global config prefer-stable true

WORKDIR /var/jenkins_home