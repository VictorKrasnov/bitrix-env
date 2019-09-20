# Установка docker для MacOS

1.  Ставим doker:
    - Инструкция (на английском): https://docs.docker.com/docker-for-mac/install/
1.  Можно также поставить Kinematic или https://dockstation.io для визуального управления контейнерами.
1.  Если гит еще не был установлен (может понадобиться в инструкции по установке Bitrix Environment ниже), тогда делаем:
    ```bash
    xcode-select --install
    ```

# Установка Bitrix Environment под Docker

Ставим этот образ: https://hub.docker.com/r/webslon/bitrix-env (шаги описаны ниже):

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
1.  Запускаем контейнер:
    ```bash
    docker-compose up -d
    ```
1.  Заходим в контейнер:
    ```bash
    docker-compose exec webslon-bitrix-env bash --login
    ```
    Произойдет запуск установки Bitrix Environment. Процесс может занимать от 10 до 20 минут.
    Повторный запуск этой же команды приведет к залогиниванию в контейнер и запуску меню Bitrix Environment (повторной установки не произойдет).

# Источники
1. [Денис Бондарь. PhpStorm + Docker + Xdebug](https://blog.denisbondar.com/post/phpstorm_docker_xdebug)
1. [Документация по Docker. Инструкция по установке Centos](https://docs.docker.com/samples/library/centos/)
1. [Infoservice. Аналогичный образ в Docker](https://bitbucket.org/Infoservice_web/bitrix-env7-docker/)
1. [Документация 1С-Битрикс. Подключение IDE](https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=37&LESSON_ID=8901&LESSON_PATH=3908.8809.8877.8901)
