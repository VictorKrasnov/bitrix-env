# install Bitrix-env
if [[ ! -d "/opt/webdir" ]]; then
    echo "Installing Bitrix Environment..."
    bash -c /opt/bitrix-env.sh
fi

# configure XDebug
if [[ -e /etc/php.d/15-xdebug.ini.disabled ]]; then
    echo "zend_extension=xdebug.so"         > /etc/php.d/15-xdebug.ini
    echo "xdebug.remote_autostart=on"       >> /etc/php.d/15-xdebug.ini
    echo "xdebug.remote_enable=on"          >> /etc/php.d/15-xdebug.ini
    echo "xdebug.remote_connect_back=on"    >> /etc/php.d/15-xdebug.ini
    echo "xdebug.idekey=PHPSTORM"           >> /etc/php.d/15-xdebug.ini
    rm /etc/php.d/15-xdebug.ini.disabled
    echo "XDebug enabled"
fi

# configure ru_RU.UTF-8 locale
if [[ -z $( localectl status | grep ru) ]]; then
     if [[ -z $(localectl list-locales | grep ru) ]]; then
        localedef -c -f UTF-8 -i ru_RU ru_RU.UTF-8
        localectl set-locale LANG=$(localectl list-locales | grep ru)
     fi
fi

# start Bitrix Environment menu
bash -c /root/menu.sh
