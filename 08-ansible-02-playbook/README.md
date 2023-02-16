## Playbook install `clickhouse` and `vector`.

Playbook устанавливает clichouse и vector на две виртуальные машины Centos7 docker, собранные с помощью docker-compose файла, запускает службу `clichouse-server` и `vector`, а также создает базу `logs` в `clichouse`. 

### Variables
В каталоге group_vars задаются необходимые версии дистрибутивов.

|clickhouse_version|версия clickhous| 
|-|--------|
|vector_version|версия vector|

    
 ### Install Clickhouse
 Скачиваются rpm пакеты, устанавливается Clickhouse, создается база logs. 
 
### Install vector
Скачиваются пакеты, устанавливается vector. Запуск службы.

### Tags

    clickhouse производит полную конфигурацию сервера clickhouse-01;
    clickhouse_db производит конфигурацию базы данных и таблицы;
    vector производит полную конфигурацию сервера vector-01;
    vector_config производит изменение в конфиге приложения vector;
    drop_clickhouse_database_logs удаляет базу данных (по умолчанию не выполняется);

</br></br>Для работы playbook необходимо:
 - собрать и запустить из `docker-compose.yml` файла две виртуальные машины.
```shell
docker-compose up

Проверить, что docker-контейнеры запущены
docker ps
```
 - запустить `ansible-playbook`:
```shell
ansible-playbook -i inventory/prod.yml site.yml
```
