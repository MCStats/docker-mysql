FROM ubuntu
MAINTAINER Tyler Blair <hidendra@mcstats.org>

RUN apt-get update
RUN apt-get install -y python-software-properties software-properties-common
RUN apt-get -y upgrade

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
    echo 'deb http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main' >> /etc/apt/sources.list && \
    echo 'deb-src http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y mariadb-server pwgen && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#change bind address to 0.0.0.0
RUN sed -i -r 's/bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/my.cnf

ADD my.cnf /etc/mysql/my.cnf
ADD create_mariadb_admin_user.sh /create_mariadb_admin_user.sh
ADD run.sh /run.sh
RUN chmod 775 /*.sh

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

#Added to avoid in container connection to the database with mysql client error message "TERM environment variable not set"
ENV TERM dumb

EXPOSE 3306
CMD ["/bin/bash", "/run.sh"]
