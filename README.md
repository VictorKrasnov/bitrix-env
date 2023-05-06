# Deprecated

> **Важно!** Проект устарел. Пользуйтесь этим: https://gitlab.com/bitrix-docker/server

---

# Установка docker для MacOS

1.  Ставим doker:
    - Инструкция (на английском): https://docs.docker.com/docker-for-mac/install/
1.  Можно также поставить Kinematic или https://dockstation.io для визуального управления контейнерами.
1.  Если гит еще не был установлен (может понадобиться в инструкции по установке Bitrix Environment ниже), тогда делаем:
    ```bash
    xcode-select --install
    ```

# Установка Bitrix Environment под Docker

1.  Создаем папку для docker-compose и переходим в нее, например:
    ```bash
    mkdir ~/Work/bitrix && cd ~/Work/bitrix
    ```
    В дальнейшем все проекты будут располагаться в папке ~/Work/bitrix/ext_www.
1.  Скачиваем git-репозиторий:
    ```bash
    git clone git@github.com:VictorKrasnov/bitrix-env.git .
    ```
1.  Останавливаем штатный апач. При запуске докер-контейнера потребуется 80-й порт (мы не хотим использовать нестандартные порты, так как может вызывать неудобства при работе Bitrix), так что он должен быть свободен.
    ```bash
    # Для MacOS:
    sudo apachectl stop
    ```
1.  Настраиваем файл окружения.
    ```bash
    cp .env.dist .env
    ```
    Далее редактируем файл .env, указываем там IP-адрес хост-машины в локальной сети, обычно начинается на 192 или 10, найти адрес можно или в настройках сетевой карты в интерфейсе настройки сети в ОС, или выполнив команду `ifconfig | grep 192` или `ifconfig | grep 10`.
1.  Запускаем контейнер:
    ```bash
    docker-compose up -d
    ```
1.  Заходим в контейнер:
    ```bash
    docker-compose exec webslon-bitrix-env bash --login
    ```
    Произойдет запуск установки Bitrix Environment. Процесс может занимать от 10 до 20 минут. Повторный запуск этой же команды приведет к залогиниванию в контейнер и запуску меню Bitrix Environment (повторной установки не произойдет).

# Полезное

## Как быстро развернуть сайт из архива, созданного с помощью резервного копирования Bitrix

1.  Скачать архив в корень сайта. Быстрее всего с помощью команды `wget`.
1.  Записать (запомнить) логин / пароль / имя базы данных (посмотреть можно в bitrix/.settings или bitrix/php_interface/dbconn.php)
1.  Перейти в папку сайта и выполнить:
    ```bash
    cat *.tar.* | tar xzpvf -
    ```
1.  После распаковки архива запустить restore.php и там выбрать "Архив уже распакован". На этапе восстановления БД ввести настройки, записанные в начале этого руководства.

## Подключение x-debug

1. Убедиться, что в контейнере в файле /etc/php.d/15-xdebug.ini в строке xdebug.remote_host указан IP-адрес локальной сети хост-машины (вашего компьютера). Например, адрес WiFi или LAN в настройках сети. Этот же адрес если правильно настроили файл .env должен выводиться командой в контейнере:
   ```bash
   echo ${DOCKER_HOST_IP}
   ```
1. В настройках PhpStorm
    1. **Preferences | Languages & Frameworks | PHP**: указываем CLI Interpreter PHP 7.
    1. **Preferences | Languages & Frameworks | PHP | Debug**: в секции XDebug указываем XDebug port = **9001** и ставим все галочки. 
    1. **Preferences | Languages & Frameworks | PHP | Debug | DBGp Proxy**: IDE Key: **PHPSTORM**, Host: **Ваш IP-адрес локальной сети хост-машины**, Port: **9001**.
    1. **Preferences | Languages & Frameworks | PHP | Servers**: добавляем сервер, Host указываем Ваш IP-адрес локальной сети хост-машины, ставим галочку Use path mappings и настраиваем пути.

# Источники
1. [Денис Бондарь. PhpStorm + Docker + Xdebug](https://blog.denisbondar.com/post/phpstorm_docker_xdebug)
1. [Документация по Docker. Инструкция по установке Centos](https://docs.docker.com/samples/library/centos/)
1. [Infoservice. Аналогичный образ в Docker](https://bitbucket.org/Infoservice_web/bitrix-env7-docker/)
1. [Документация 1С-Битрикс. Подключение IDE](https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=37&LESSON_ID=8901&LESSON_PATH=3908.8809.8877.8901)
