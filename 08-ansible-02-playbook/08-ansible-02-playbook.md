# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

Ответ.

Мой репозиторий (https://github.com/awertoss/devops-netology/tree/main/08-ansible-02-playbook/playbook)
Подготовил docker-compose.yml файл, который создает две виртуальные машину centos 7 на базе docker.

1. Приготовьте свой собственный inventory файл `prod.yml`.

```
Мой prod.yml
[https://github.com/awertoss/devops-netology/blob/main/08-ansible-02-playbook/playbook/inventory/prod.yml]
```
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
```
Дописал playbok
[https://github.com/awertoss/devops-netology/blob/main/08-ansible-02-playbook/playbook/site.yml]

```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
root@promitey:/home/srg/0802# ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
WARNING  Listing 6 violation(s) that are fatal
risky-file-permissions: File permissions unset or incorrect.
site.yml:12 Task/Handler: Get Vector distrib

fqcn-builtins: Use FQCN for builtin actions.
site.yml:23 Task/Handler: Deploy config Vector

unnamed-task: All tasks should be named.
site.yml:38 Task/Handler: block/always/rescue

risky-file-permissions: File permissions unset or incorrect.
site.yml:39 Task/Handler: Get clickhouse distrib

risky-file-permissions: File permissions unset or incorrect.
site.yml:45 Task/Handler: Get clickhouse distrib

fqcn-builtins: Use FQCN for builtin actions.
site.yml:57 Task/Handler: Flush handlers

You can skip specific rules or tags by adding them to your configuration file:
# .config/ansible-lint.yml
warn_list:  # or 'skip_list' to silence them completely
  - experimental  # all rules tagged as experimental
  - fqcn-builtins  # Use FQCN for builtin actions.
  - unnamed-task  # All tasks should be named.

Finished with 3 failure(s), 3 warning(s) on 1 files.

```
```
Исправил ошибки.

root@promitey:/home/srg/0802# ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
root@promitey:/home/srg/0802#

```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`
```
Зпустил playbook. Завершился с ошибкой.
root@promitey:/home/srg/0802# ansible-playbook site.yml -i inventory/prod.yml --check

PLAY [Install Vector] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get Vector distrib] *******************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install Vector packages] **************************************************************************************************************************************************************************************************************
fatal: [vector-01]: FAILED! => {"changed": false, "module_stderr": "/bin/sh: sudo: command not found\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 127}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
vector-01                  : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

root@promitey:/home/srg/0802#


```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```
root@promitey:/home/srg/0802# ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] **********************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install vector] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *******************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] **************************************************************************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
Проверил изменения в докере.
```
root@promitey:/home/srg/0802# docker exec -it e9fab923ec72 /bin/bash
[root@e9fab923ec72 /]# cat /vector-0.2
cat: /vector-0.2: No such file or directory
[root@e9fab923ec72 /]# cat /etc/vector/vector.toml
#                                    __   __  __
#                                    \ \ / / / /
#                                     \ V / / /
#                                      \_/  \/
#
#                                    V E C T O R
#                                   Configuration
#
# ------------------------------------------------------------------------------
# Website: https://vector.dev
# Docs: https://vector.dev/docs
# Chat: https://chat.vector.dev
# ------------------------------------------------------------------------------

# Change this to use a non-default directory for Vector data storage:
# data_dir = "/var/lib/vector"

# Random Syslog-formatted logs
[sources.dummy_logs]
type = "demo_logs"
format = "syslog"
interval = 1

# Parse Syslog logs
# See the Vector Remap Language reference for more info: https://vrl.dev
[transforms.parse_logs]
type = "remap"
inputs = ["dummy_logs"]
source = '''
. = parse_syslog!(string!(.message))
'''

# Print parsed logs to stdout
[sinks.print]
type = "console"
inputs = ["parse_logs"]
encoding.codec = "json"

# Vector's GraphQL API (disabled by default)
# Uncomment to try it out with the `vector top` command or
# in your browser at http://localhost:8686
#[api]
#enabled = true
#address = "127.0.0.1:8686"

```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
root@promitey:/home/srg/0802# ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] ******************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] *********************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install vector] **********************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] ******************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] *************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP *********************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```


9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. </br>Ссылка на readme файл
[https://github.com/awertoss/devops-netology/blob/main/08-ansible-02-playbook/README.md]


---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
