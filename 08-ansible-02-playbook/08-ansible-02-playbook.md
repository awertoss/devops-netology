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
Подготовил виртуальную машину centos 7 на базе docker.

```
Файл prod.yml добавил IP-адрес и конфиг:
vector:
  hosts:
    vector-01:
      ansible_host: 172.18.0.2

В файл site.yml добавлен новый play.
- name: Install Vector
  hosts: vector
  handlers:
  - name: Start Vector service
    become: true
    ansible.builtin.service:
      name: vector
      state: restarted

  tasks:
    - name: Get Vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/0.21.1/vector-0.21.1-1.{{ ansible_architecture }}.rpm"
        dest: "./vector-0.21.1-1.{{ ansible_architecture }}.rpm"

    - name: Install Vector packages
      become: true
      ansible.builtin.yum:
        name: vector-0.21.1-1.{{ ansible_architecture }}.rpm
      notify: Start Vector service

    - name: Deploy config Vector
      template:
        src: vector.j2
        dest: /etc/vector/vector.toml
        mode: 0755
      notify: Start Vector service


```
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
root@ubuntu:~/0802/playbook# ansible-lint site.yml
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
6. Попробуйте запустить playbook на этом окружении с флагом `--check`
```
Зпустил playbook. Завершился с ошибкой.
root@ubuntu:~/0802/playbook# ansible-playbook site.yml -i inventory/prod.yml --check

PLAY [Install Vector] ****************************************************************************

TASK [Gathering Facts] ***************************************************************************
fatal: [vector-01]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via s                           sh: ssh: connect to host 192.168.200.2 port 22: Connection timed out", "unreachable": true}

PLAY RECAP ***************************************************************************************
vector-01                  : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescue                           d=0    ignored=0


```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. </br>Ссылка на readme файл
[https://github.com/awertoss/devops-netology/blob/main/08-ansible-02-playbook/README.md]
---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
