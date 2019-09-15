# install Bitrix-env
if [[ ! -d "/opt/webdir" ]]; then
  echo "Installing Bitrix Environment..."
  bash -c /opt/bitrix-env.sh
fi

# configure XDebug
if [[ -e /etc/php.d/15-xdebug.ini.disabled ]]; then
  echo "zend_extension=xdebug.so" >/etc/php.d/15-xdebug.ini
  # echo "xdebug.remote_autostart=0" >>/etc/php.d/15-xdebug.ini
  # echo "xdebug.remote_enable=1" >>/etc/php.d/15-xdebug.ini
  # echo "xdebug.remote_connect_back=0" >>/etc/php.d/15-xdebug.ini
  # echo "xdebug.idekey=PHPSTORM" >>/etc/php.d/15-xdebug.ini
  rm /etc/php.d/15-xdebug.ini.disabled
  echo "XDebug enabled"
fi

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

# start Bitrix Environment menu
bash -c /root/menu.sh
