# management node for mysql cluster
#
# version 0.0.1
FROM ubuntu:12.04
MAINTAINER Tim Schindler tim@catalyst-zero.com

# Define the environment.
ENV MYSQL_VERSION 7.3.5
ENV MYSQL_SHORT_VERSION 7.3

RUN mkdir /usr/src/mysql-mgm

# Install system requirements to install mysql from source.
RUN apt-get update
RUN apt-get install -y libaio1 libaio-dev libfile-basedir-perl

# Install mysql.
ADD http://cdn.mysql.com/Downloads/MySQL-Cluster-${MYSQL_SHORT_VERSION}/mysql-cluster-gpl-${MYSQL_VERSION}-linux-glibc2.5-x86_64.tar.gz /
RUN tar -xzvf mysql-cluster-gpl-${MYSQL_VERSION}-linux-glibc2.5-x86_64.tar.gz
RUN mv mysql-cluster-gpl-${MYSQL_VERSION}-linux-glibc2.5-x86_64 /usr/local/mysql

# Cleanup
RUN rm -f mysql-cluster-gpl-${MYSQL_VERSION}-linux-glibc2.5-x86_64.tar.gz
RUN apt-get -f install && apt-get autoremove && apt-get -y autoclean && apt-get -y clean

# Add cluster config
RUN mkdir -p /var/lib/mysql-cluster/
ADD ./config.ini /var/lib/mysql-cluster/

RUN echo "ndb_mgmd -f /var/lib/mysql-cluster/config.ini --configdir=/var/lib/mysql-cluster/" > /etc/init.d/ndb_mgmd
RUN chmod 755 /etc/init.d/ndb_mgmd

# Expose the mysql port.
EXPOSE 3306
