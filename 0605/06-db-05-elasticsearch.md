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

```
ссылку на образ в репозитории dockerhub https://hub.docker.com/repository/docker/awertoss/devops-opensearch

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

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
