# Jenkins with PHP support for Docker

Installed PHP version: 7.0. Based on required modules: http://jenkins-php.org/installation.html.<br>
Inspired by https://github.com/naxhh/jenkins-php-docker and https://github.com/gustavoapolinario/jenkins-docker.

## Installation
`docker run -d -p 8080:8080 -v /opt/jenkins_home:/var/jenkins_home --restart unless-stopped hcdesigns/jenkins-php`

## Run with Docker support in Jenkins
Requires Docker installed and running on host machine
`docker run -d -p 8080:8080 -v /opt/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped hcdesigns/jenkins-php`