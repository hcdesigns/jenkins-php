# Jenkins with PHP support for Docker

Installed PHP version: 7.0. Based on required modules: http://jenkins-php.org/installation.html.<br>
Inspired by https://github.com/naxhh/jenkins-php-docker.

## Installation
`docker run -d -p {HOST_PORT}:8080 -v {HOST_PATH}:/var/jenkins_home hcdesigns/jenkins-php`
i.e:
`docker run -d -p 9090:8080 -v /opt/jenkins_home:/var/jenkins_home hcdesigns/jenkins-php`