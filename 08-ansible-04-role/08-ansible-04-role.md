# Домашнее задание к занятию "4. Работа с roles"

## Подготовка к выполнению
1. (Необязательно) Познакомтесь с [lighthouse](https://youtu.be/ymlrNlaHzIY?t=929)
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю в github.

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```
Готово.</br>
2. При помощи `ansible-galaxy` скачать себе эту роль.
```
root@promitey:/home/srg/0804/playbook# ansible-galaxy install -r requirements.yml
Starting galaxy role install process
- extracting clickhouse to /root/.ansible/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
root@promitey:/home/srg/0804/playbook#

```

3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
```
root@promitey:/home/srg/0804/playbook# ansible-galaxy role init vector-role
- Role vector-role was created successfully
root@promitey:/home/srg/0804/playbook#

root@promitey:/home/srg/0804/playbook# ansible-galaxy role init lighthouse-role
- Role lighthouse-role was created successfully

root@promitey:/home/srg/0804/playbook# ansible-galaxy role init clickhouse-role
- Role clickhouse-role was created successfully


```

4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
```
Готово
```

5. Перенести нужные шаблоны конфигов в `templates`.
```
Готово
```

6. Описать в `README.md` обе роли и их параметры.

7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.
</br>
[https://github.com/awertoss/devops-netology/blob/main/08-ansible-04-role/playbook/requirements.yml] </br>
9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

[https://github.com/awertoss/devops-netology/blob/main/08-ansible-04-role/playbook] </br>

[https://github.com/awertoss/lighthouse-role] </br>

[https://github.com/awertoss/clickhouse-role]</br>

[https://github.com/awertoss/vector-role]



---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
