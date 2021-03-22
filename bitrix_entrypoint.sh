# functions
function mkdirBitrixFolder {
  if [ ! -d "$1" ]; then
    mkdir "$1"
    chmod 755 "$1"
    chown bitrix:bitrix "$1"
  fi
}

# install Bitrix-env
if [[ ! -f "/opt/webdir/bin/bitrix_utils.sh" ]]; then
  echo "Installing Bitrix Environment..."

  if [[ -f /root/docker-backup/.my.cnf ]]; then
    cp /root/docker-backup/.my.cnf /root/.my.cnf
  fi

  bash -c /opt/bitrix-env.sh

  # creating sessions paths
  mkdirBitrixFolder /tmp/php_sessions
  mkdirBitrixFolder /tmp/php_sessions/ext_www

  CONFIG_FILE_NAMES=$(ls /etc/httpd/bx/conf | grep bx_ext | cut -c 8- | rev | cut -c 6- | rev)
  for FILE_NAME in $CONFIG_FILE_NAMES
  do
    mkdirBitrixFolder "/tmp/php_sessions/ext_www/$FILE_NAME"
  done

  echo "Setting file permissions for /home/bitrix folder..."
  chown -R bitrix:bitrix /home/bitrix
fi

# configure XDebug
echo "zend_extension=xdebug.so" >/etc/php.d/15-xdebug.ini
echo "xdebug.remote_autostart=1" >>/etc/php.d/15-xdebug.ini
echo "xdebug.remote_enable=1" >>/etc/php.d/15-xdebug.ini
echo "xdebug.remote_connect_back=0" >>/etc/php.d/15-xdebug.ini
echo "xdebug.idekey=PHPSTORM" >>/etc/php.d/15-xdebug.ini
echo "xdebug.remote_host= ${DOCKER_HOST_IP} " >>/etc/php.d/15-xdebug.ini
echo "xdebug.remote_port=9001" >>/etc/php.d/15-xdebug.ini
echo "xdebug.remote_log=\"/var/log/xdebug.log\"" >>/etc/php.d/15-xdebug.ini
if [[ -e /etc/php.d/15-xdebug.ini.disabled ]]; then
    rm /etc/php.d/15-xdebug.ini.disabled
fi
echo "XDebug enabled"
service httpd restart

# configure ru_RU.UTF-8 locale
if [[ -z $(localectl status | grep ru) ]]; then
  if [[ -z $(localectl list-locales | grep ru) ]]; then
    localedef -c -f UTF-8 -i ru_RU ru_RU.UTF-8
    localectl set-locale LANG=$(localectl list-locales | grep ru)
  fi
fi

# configure DNS
if [[ -z $(cat /etc/resolv.conf | grep 8.8.8.8) ]]; then
  echo "nameserver 8.8.8.8" >>/etc/resolv.conf
fi
if [[ -z $(cat /etc/resolv.conf | grep 8.8.4.4) ]]; then
  echo "nameserver 8.8.4.4" >>/etc/resolv.conf
fi

# make copy of /root/.my.cnf
mkdir -p /root/docker-backup
if [[ ! -f /root/docker-backup/.my.cnf ]]; then
  cp /root/.my.cnf /root/docker-backup/.my.cnf
fi

# start Bitrix Environment menu
bash -c /root/menu.sh
