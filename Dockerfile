FROM centos:7
MAINTAINER Viktor Krasnov <krasnovvy@gmail.com>

# Centos Installation: https://docs.docker.com/samples/library/centos/
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# volumes
VOLUME ["/home/bitrix/www"]
VOLUME ["/home/bitrix/ext_www"]
VOLUME ["/etc/nginx"]
VOLUME ["/etc/httpd"]
VOLUME ["/var/lib/mysql"]
VOLUME ["/root/docker-backup"]

# install packets & env variables
RUN yum install initscripts wget mc nano ethtool bind-utils php-soap php-bcmath zip unzip composer telnet -y
RUN echo "export LC_ALL=en_US.UTF-8" >> /etc/profile
RUN export LC_ALL=en_US.UTF-8

# download bitrix-env
ADD http://repos.1c-bitrix.ru/yum/bitrix-env.sh /opt/
RUN chmod +x /opt/bitrix-env.sh

# Add scripts for auto-install bitrix-env at login with --login flag
ADD https://raw.githubusercontent.com/VictorKrasnov/bitrix-env/master/bitrix_entrypoint.sh /opt/bitrix_entrypoint.sh
RUN chmod +x /opt/bitrix_entrypoint.sh

RUN mv /root/.bash_profile /root/.bash_profile.disabled
ADD https://raw.githubusercontent.com/VictorKrasnov/bitrix-env/master/.bash_profile /root/.bash_profile
RUN chown -R root /root/.bash_profile

# start systemd
CMD ["/usr/sbin/init"]
