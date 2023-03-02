## Playbook

Playbook устанавливает clichouse, vector и lighthouse на три подготовленные заранее хосты, запускает службу `clichouse-server` и `vector`, создает базу `logs` в `clichouse`. В lighthouse-01 устанавливает веб-север nginx, настраивает конфиги, и стартует. Устанавливает git. 

### Variables
В каталоге group_vars задаются необходимые версии дистрибутивов.

|clickhouse_version|версия clickhous| 
|-|--------|
|vector_version|версия vector|
|lighthouse_vcs|ссылка на репозиторий git lighthouse|
|nginx_user_name|от какого пользователя запускать веб-сервер nginx|
    
 ### Install Clickhouse
 Скачиваются rpm пакеты, устанавливается Clickhouse, создается база logs. 
 
### Install vector
Скачиваются пакеты, устанавливается vector. Запуск службы.

### Install lighthouse
Устанавливается веб-сервер nginx. Настраивается конфиги веб-сервера. Добавляется сервис nginx в автозагрузку. Устанавливается git. Создается директория /var/www/lighthouse
Клонируется lighthouse.

### Tags
|clickhouse|производит полную конфигурацию сервера clickhouse-01| 
|-|--------|
|vector|производит полную конфигурацию сервера vector-01|
|vector|производит полную конфигурацию сервера lighthouse-01|
   
