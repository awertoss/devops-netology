# Домашнее задание к занятию "3. Использование Yandex Cloud"

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

Ссылка на репозиторий LightHouse: https://github.com/VKCOM/lighthouse

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
4. Приготовьте свой собственный inventory файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

Ответ.
Мой репозиторий [https://github.com/awertoss/devops-netology/tree/main/08-ansible-03-yandex/playbook]

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
Дописал.

4. Приготовьте свой собственный inventory файл `prod.yml`.
Подготовил. Смотреть мой репозиторий.

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```
Ошибок было много, исправил.

root@promitey:/home/srg/0803# ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
root@promitey:/home/srg/0803#

```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```
Завершился с ошибкой.
root@promitey:/home/srg/0803# ansible-playbook site.yml -i inventory/prod.yml --check
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details

PLAY [Install Clickhouse] **********************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
The authenticity of host '158.160.42.130 (158.160.42.130)' can't be established.
ED25519 key fingerprint is SHA256:FTdYOjBDlNe/IYQKTbAxu2RaKtN8mnHeqVwZkCZpnas.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
fatal: [clickhouse-01]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Warning: Permanently added '158.160.42.130' (ED25519) to the list of known hosts.\r\nConnection closed by 158.160.42.130 port 22", "unreachable": true}

PLAY RECAP *************************************************************************************************************************************************************
clickhouse-01              : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0

root@promitey:/home/srg/0803#

```
7. Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.




### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
