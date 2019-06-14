from drupal:8.7-apache
run apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install apt-file apt-utils && \
    apt-get -y install openssh-server openssh-client systemd dbus rsyslog rsync mariadb-client memcached libmemcached-dev curl vim zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
run mkdir -p /usr/src/php/ext
run curl -L https://github.com/php-memcached-dev/php-memcached/archive/v3.1.3.tar.gz | tar -C /usr/src/php/ext -xzf -
run mv /usr/src/php/ext/php-memcached-3.1.3 /usr/src/php/ext/memcached
run docker-php-ext-configure /usr/src/php/ext/memcached
run docker-php-ext-install /usr/src/php/ext/memcached
RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/systemd-update-utmp*
run sed -i 's|/var/www/html|/var/www/drupal/public_html|g' /etc/apache2/sites-enabled/000-default.conf
run systemctl enable ssh apache2 rsyslog memcached
run ln -s /lib/systemd/system/systemd-user-sessions.service /etc/systemd/system/multi-user.target.wants/systemd-user-sessions.service
run rm -f /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log
run mkdir /run/sshd
run useradd -g www-data --system -d /var/www/drupal -s /bin/bash -m drupal
run mkdir /var/www/drupal/.ssh
run ln -s site/docroot /var/www/drupal/public_html
copy authorized_keys /var/www/drupal/.ssh/authorized_keys
run chown drupal:www-data -R /var/www/drupal
run chmod og-rwx -R /var/www/drupal/.ssh
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/lib/systemd/systemd"]
