## Установка `clickhouse` и `vector`

Playbook устанавливает `clichouse` и `vector` на контейнер `CentOS7` поднятые при помощи `docker-файла`, запускает службу `clichouse-server` и `vector`, а также создает базу `logs` в `clichouse`. 

В каталоге `group_vars` задаются необходимые версии дистрибутивов.

Для работы playbook необходимо:
 - собрать `docker-образ`
```shell
docker-compose up
```
 - запустить `ansible-playbook`:
```shell
ansible-playbook -i inventory/prod.yml site.yml
```
