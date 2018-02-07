FROM jenkins/jenkins:lts

LABEL maintainer="Harvey Chow <harvey@hcdesigns.nl>"

ENV DEBIAN_FRONTEND noninteractive

# if we want to install via apt
USER root

RUN apt-get update

RUN apt-get install -y vim nano openssl curl wget build-essential software-properties-common git zip

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