# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.
Docker файл:
```
FROM centos:7

EXPOSE 9200 9600

USER 0

RUN export ES_HOME="/var/lib/opensearch" && \
yum update -y && \
yum install -y mc && \
yum install -y wget && \
wget https://artifacts.opensearch.org/releases/bundle/opensearch/2.5.0/opensearch-2.5.0-linux-x64.tar.gz && \
tar -xvf opensearch-2.5.0-linux-x64.tar.gz && \
rm -f opensearch-2.5.0-linux-x64.tar.gz && \
mv opensearch-2.5.0 ${ES_HOME} && \

#swapoff -a \ &&
#echo "vm.max_map_count=262144" > /etc/sysctl.conf && \
useradd -m -u 1000 opensearch && \
chown opensearch:opensearch -R ${ES_HOME}

COPY --chown=opensearch:opensearch config/opensearch.yml /var/lib/opensearch/config/

USER 1000
ENV ES_HOME="/var/lib/opensearch"
WORKDIR ${ES_HOME}

#RUN su - opensearch && \
#RUN /var/lib/opensearch/opensearch-tar-install.sh

CMD ["sh", "-c", "/var/lib/opensearch/opensearch-tar-install.sh"]

```
```
docker build . -t awertoss/devops-opensearch:2.5.0
docker login -u "awertoss" -p "***" docker.io
$ docker push awertoss/devops-opensearch:2.5.0
```
Cсылка на образ в репозиторий dockerhub [https://hub.docker.com/repository/docker/awertoss/devops-opensearch](https://hub.docker.com/repository/docker/awertoss/devops-opensearch)
```


docker run --rm -d --name elastic -p 9200:9200 -p 9600:9600 -e "discovery.type=single-node" awertoss/devops-opensearch:2.5.0

ответ `opensearch` на запрос пути `/` в json виде

curl https://localhost:9200 -ku 'admin:admin'
{
  "name" : "netology_test",
  "cluster_name" : "opensearch",
  "cluster_uuid" : "gqmcn8sxSsma7vOzQL3y7Q",
  "version" : {
    "distribution" : "opensearch",
    "number" : "2.5.0",
    "build_type" : "tar",
    "build_hash" : "b8a8b6c4d7fc7a7e32eb2cb68ecad8057a4636ad",
    "build_date" : "2023-01-18T23:48:48.981786100Z",
    "build_snapshot" : false,
    "lucene_version" : "9.4.2",
    "minimum_wire_compatibility_version" : "7.10.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "The OpenSearch Project: https://opensearch.org/"
}

```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
curl -X PUT https://localhost:9200/ind-1 -ku 'admin:admin' -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'


curl -X PUT https://localhost:9200/ind-2 -ku 'admin:admin' -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 1
  }
}
'


curl -X PUT https://localhost:9200/ind-3 -ku 'admin:admin' -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 4,
    "number_of_replicas": 2
  }
}
'

```
Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```
root@promitey:/home/srg/0605# curl https://localhost:9200/_cat/indices?v -ku 'admin:admin'
health status index                        uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   security-auditlog-2023.02.02 52UrIO7mRyOoMyXSDvUBCA   1   1         10            0      142kb          142kb
green  open   ind-1                        ecfIH5pqTx2zWO2RrswPAQ   1   0          0            0       208b           208b
green  open   .opendistro_security         Ow-QMc-gRxavig1nLjp5-A   1   0         10            0     71.7kb         71.7kb
yellow open   ind-3                        JnjwFPJaTiSlVcmnX4uMfg   4   2          0            0       832b           832b
yellow open   ind-2                        olxU7qo0QFGeAhFVq96dKA   2   1          0            0       416b           416b

```

Получите состояние кластера `elasticsearch`, используя API.
```
root@promitey:/home/srg/0605# curl https://localhost:9200/_cluster/health?pretty -ku 'admin:admin'
{
  "cluster_name" : "opensearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "discovered_master" : true,
  "discovered_cluster_manager" : true,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 11,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 45.0
}

```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
```
Из документации:
Overview

Yellow status indicates that one or more of the replica shards on the Elasticsearch cluster are not allocated to a node. 
No need to panic! There are several reasons why a yellow status can be perfectly normal, and in many cases Elasticsearch will recover to green by itself, 
so the worst thing you can do is start tweaking things without knowing exactly what the cause is. While status is yellow, search and index operations are 
still available.

--
Желтый статус указывает на то, что один или несколько сегментов реплики в кластере Elasticsearch не выделены узлу. 
```
Удалите все индексы.
```
root@promitey:/home/srg/0605# curl -X DELETE https://localhost:9200/ind-1?pretty -ku 'admin:admin'
{
  "acknowledged" : true
}

root@promitey:/home/srg/0605# curl -X DELETE https://localhost:9200/ind-2?pretty -ku 'admin:admin'
{
  "acknowledged" : true
}

root@promitey:/home/srg/0605# curl -X DELETE https://localhost:9200/ind-3?pretty -ku 'admin:admin'
{
  "acknowledged" : true
}


```


**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.
```
docker exec -it 7848641d940f /bin/bash

bash-4.2$ mkdir $ES_HOME/snapshots

Добавим в конфиг строчку path.repo: /var/lib/opensearch/snapshots

mcedit config/opensearch.yml


```

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

```
curl -X PUT 'https://localhost:9200/_snapshot/netology_backup?pretty' -ku 'admin:admin' -H 'Content-Type: application/json' -d'{"type": "fs", "settings": {"location":"/var/lib/opensearch/snapshots" }}'

```

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```
curl -X PUT https://localhost:9200/test -ku 'admin:admin' -H 'Content-Type: application/json' -d'

{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}




' 


root@promitey:/home/srg/0605# curl -X GET 'https://localhost:9200/_cat/indices?v&pretty' -ku 'admin:admin'

health status index                        uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   security-auditlog-2023.02.03 1AEkp1UCSRWe7-I7nazi_g   1   1          6            0     86.3kb         86.3kb
yellow open   security-auditlog-2023.02.02 52UrIO7mRyOoMyXSDvUBCA   1   1         22            0     94.2kb         94.2kb
green  open   test                         SC-D6uEAQPWfZHphlS_Gsg   1   0          0            0       208b           208b
green  open   .opendistro_security         Ow-QMc-gRxavig1nLjp5-A   1   0         10            0     71.7kb         71.7kb


```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

```
root@promitey:/home/srg/0605# curl -X PUT 'https://localhost:9200/_snapshot/netology_backup/my_snapshot?pretty' -ku 'admin:admin'
{
  "accepted" : true
}

```

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```
root@promitey:/home/srg/0605# docker exec -it 7848641d940f /bin/bash
[opensearch@7848641d940f ~]$ ls -l snapshots/
total 20
-rw-rw-r-- 1 opensearch opensearch 1213 Feb  3 09:36 index-0
-rw-rw-r-- 1 opensearch opensearch    8 Feb  3 09:36 index.latest
drwxrwxr-x 6 opensearch opensearch 4096 Feb  3 09:36 indices
-rw-rw-r-- 1 opensearch opensearch  372 Feb  3 09:36 meta-DedCJ1GyT4OHuCXJNwsIGg.dat
-rw-rw-r-- 1 opensearch opensearch  347 Feb  3 09:36 snap-DedCJ1GyT4OHuCXJNwsIGg.dat


```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```
curl -X DELETE 'https://localhost:9200/test' -ku 'admin:admin'

root@promitey:/home/srg/0605# curl -X PUT https://localhost:9200/test-2 -ku 'admin:admin' -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_shards": 1,
>     "number_of_replicas": 0
>   }
> }
> '
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"}root@promitey:/home/srg/0605#

Спискок индексов:

root@promitey:/home/srg/0605# curl  https://localhost:9200/_cat/indices -ku 'admin:admin'
green  open test-2                       flHeH3eJTReCpyquzG4UZw 1 0  0 0    208b    208b
yellow open security-auditlog-2023.02.03 1AEkp1UCSRWe7-I7nazi_g 1 1  8 0 116.8kb 116.8kb
yellow open security-auditlog-2023.02.02 52UrIO7mRyOoMyXSDvUBCA 1 1 22 0  94.2kb  94.2kb
green  open .opendistro_security         Ow-QMc-gRxavig1nLjp5-A 1 0 10 0  71.7kb  71.7kb


```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

```
Вначале смотрим спискок снапшотов.
root@promitey:/home/srg/0605# curl -X GET  'https://localhost:9200/_snapshot/netology_backup/_all/' -ku 'admin:admin'
{"snapshots":[{"snapshot":"my_snapshot","uuid":"DedCJ1GyT4OHuCXJNwsIGg","version_id":136267827,"version":"2.5.0","indices":[".opendistro_security","security-auditlog-2023.02.03","test","security-auditlog-2023.02.02"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2023-02-03T09:36:38.349Z","start_time_in_millis":1675416998349,"end_time":"2023-02-03T09:36:41.160Z","end_time_in_millis":1675417001160,"duration_in_millis":2811,"failures":[],"shards":{"total":4,"failed":0


curl -X POST  'https://localhost:9200/_snapshot/netology_backup/my_snapshot/_restore?pretty' -ku 'admin:admin' -H 'Content-Type: application/json' -d'{"include_global_state":true}'

curl -X GET 'https://localhost:9200/_cat/indices?v&pretty' -ku 'admin:admin'

green  open test                         SC-D6uEAQPWfZHphlS_Gsg 1 0  0 0    208b    208b
green  open test-2                       flHeH3eJTReCpyquzG4UZw 1 0  0 0    208b    208b
yellow open security-auditlog-2023.02.03 1AEkp1UCSRWe7-I7nazi_g 1 1  8 0 116.8kb 116.8kb
yellow open security-auditlog-2023.02.02 52UrIO7mRyOoMyXSDvUBCA 1 1 22 0  94.2kb  94.2kb
green  open .opendistro_security         Ow-QMc-gRxavig1nLjp5-A 1 0 10 0  71.7kb  71.7kb






```

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
