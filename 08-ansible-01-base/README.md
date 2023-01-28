# Домашнее задание к занятию "1. Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

```
root@ubuntu:~/awertoss# ansible --version
ansible [core 2.14.1]
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.10/dist-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.10.7 (main, Nov 24 2022, 19:45:47) [GCC 12.2.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True

```

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
```
root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base/playbook# ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] *************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************
ok: [localhost]

TASK [Print OS] *******************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************************
fatal: [localhost]: FAILED! => {"msg": "The task includes an option with an undefined variable. The error was: 'some_fact' is undef                  ined. 'some_fact' is undefined\n\nThe error appears to be in '/root/awertoss/devops-netology/08-ansible-01-base/playbook/site.yml':                   line 8, column 9, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\                  n          msg: \"{{ ansible_distribution }}\"\n      - name: Print fact\n        ^ here\n"}

PLAY RECAP ************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
```
root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base/playbook# cat group_vars/all/examp.yml
---
  some_fact: 12
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
```
docker-compose.yml

version: '3'
services:
  centos7:
    image: centos:7
    container_name: centos7
    restart: unless-stopped
    entrypoint: "sleep infinity"

  ubuntu:
    image: ubuntu
    container_name: ubuntu
    restart: unless-stopped
    entrypoint: "sleep infinity"




root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base# docker ps
CONTAINER ID   IMAGE      COMMAND            CREATED         STATUS          PORTS     NAMES
43fbc00af89d   centos:7   "sleep infinity"   4 minutes ago   Up 17 seconds             centos7
ab168c499e8a   ubuntu     "sleep infinity"   4 minutes ago   Up 3 seconds              ubuntu

```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
```
root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base# ansible-playbook -i playbook/inventory/prod.yml -v playbook/site.yml 

TASK [Gathering Facts] *******************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *******************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
```
root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base# cat playbook/group_vars/deb/examp.yml ;echo ""
---
  some_fact: "deb"

root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base# cat playbook/group_vars/el/examp.yml ;echo ""
---
  some_fact: "el"


```
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
```
root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base# ansible-playbook -i playbook/inventory/prod.yml -v playbook/site.yml

PLAY [Print os facts] ********************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *******************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
```
root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base# ansible-vault encrypt playbook/group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful

root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base# ansible-vault encrypt playbook/group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful

```
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
```
root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base# ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml

PLAY [Print os facts] ********************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found

Пароль не спросил. Требуется указать ключ ask-vault-pass.

root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base# ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *******************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
```
ansible-doc -t connection -l 

Выбираю плагин local
```
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
```
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```
root@ubuntu:~/awertoss/devops-netology/08-ansible-01-base# ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
```
Готово
```

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
