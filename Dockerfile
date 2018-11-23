FROM jenkins/jenkins:lts

LABEL maintainer="Harvey Chow <harvey@hcdesigns.nl>"

ENV DEBIAN_FRONTEND=noninteractive

# if we want to install via apt
USER root

RUN apt-get update && \
    apt-get install -y \
        curl \
        locales \
        software-properties-common \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        git \
        zip \
        vim \
        nano

#####################################
# Install python (required for several npm builds)
#####################################
RUN apt-get install -y python

#####################################
# Set locales and set timezone
#####################################
# RUN locale-gen en_US.UTF-8

# ENV LANGUAGE=en_US.UTF-8
# ENV LC_ALL=en_US.UTF-8
# ENV LC_CTYPE=en_US.UTF-8
# ENV LANG=en_US.UTF-8
# ENV TERM xterm

# RUN ln -snf /usr/share/zoneinfo/CEST /etc/localtime && echo CEST > /etc/timezone

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

#####################################
# PHP 7.1
#####################################
# Add the "PHP 7" ppa (after locales setting)
RUN apt-get install -y ca-certificates apt-transport-https
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list
RUN apt-get update

# Install "PHP Extentions", "libraries", "Software's"
RUN apt-get install -y \
        php7.1-cli \
        php7.1-common \
        php7.1-curl \
        php7.1-intl \
        php7.1-json \
        php7.1-xml \
        php7.1-mbstring \
        php7.1-mcrypt \
        php7.1-mysql \
        php7.1-zip \
        php7.1-bcmath \
        php7.1-gd \
        php7.1-dev \
        php7.1-xdebug

#####################################
# JENKINS PLUGINS
#####################################
RUN mkdir -p /tmp/WEB-INF/plugins

# Install required jenkins plugins.
RUN curl -L https://updates.jenkins-ci.org/latest/checkstyle.hpi -o /tmp/WEB-INF/plugins/checkstyle.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/cloverphp.hpi -o /tmp/WEB-INF/plugins/cloverphp.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/crap4j.hpi -o /tmp/WEB-INF/plugins/crap4j.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/dry.hpi -o /tmp/WEB-INF/plugins/dry.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/htmlpublisher.hpi -o /tmp/WEB-INF/plugins/htmlpublisher.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/jdepend.hpi -o /tmp/WEB-INF/plugins/jdepend.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/plot.hpi -o /tmp/WEB-INF/plugins/plot.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/pmd.hpi -o /tmp/WEB-INF/plugins/pmd.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/violations.hpi -o /tmp/WEB-INF/plugins/violations.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/xunit.hpi -o /tmp/WEB-INF/plugins/xunit.hpi

# Add all to the war file.
RUN cd /tmp; \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/checkstyle.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/cloverphp.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/crap4j.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/dry.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/htmlpublisher.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/jdepend.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/plot.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/pmd.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/violations.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/xunit.hpi

#####################################
# Composer:
#####################################
# Install composer and add its bin to the PATH.
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');" && \
    chown -R jenkins:jenkins ~/.composer/

#####################################
# Python, NodeJS, yarn
#####################################
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - &&\
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y nodejs yarn

# drop back to the regular jenkins user - good practice
USER jenkins

RUN composer global config minimum-stability dev && \
    composer global config prefer-stable true

WORKDIR /var/jenkins_home