# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/blob/virt-11/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

```
docker pull mysql/mysql-server:8.0
docker run --name=mysql0603 -e MYSQL_ROOT_PASSWORD=vagrant -e MYSQL_DATABASE=my_db -p 3306:3306 -v $PWD/backup:/media/mysql/backup -v $PWD/config/conf.d:/etc/mysql/conf.d -v my_data:/var/lib/mysql -d mysql/mysql-server:8.0
root@vagrant:/home/vagrant# cd backup
wget https://github.com/netology-code/virt-homeworks/blob/virt-11/06-db-03-mysql/test_data/test_dump.sql
root@vagrant:/home/vagrant/backup# docker exec -it mysql0603 bash
mysql -u root -p my_db < /media/mysql/backup/test_dump.sql
bash-4.4# mysql -u root -p

mysql> \s
--------------
mysql  Ver 8.0.31 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          2834
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.31 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/lib/mysql/mysql.sock
Binary data as:         Hexadecimal
Uptime:                 23 hours 28 min 41 sec

mysql> USE my_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
```
CREATE USER 'test'@'localhost' 
    IDENTIFIED WITH mysql_native_password BY 'test-pass'
    WITH MAX_CONNECTIONS_PER_HOUR 100
    PASSWORD EXPIRE INTERVAL 180 DAY
    FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
    ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';
GRANT SELECT ON my_db.* TO test@localhost;
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test';
+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.01 sec)

```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
```
SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE();
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| my_db        | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.00 sec)
SET profiling = 1;

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.03 sec)
Records: 5  Duplicates: 0  Warnings: 0


mysql> SHOW PROFILES;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.02636700 | ALTER TABLE orders ENGINE = MyISAM |
|        2 | 0.02885750 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+
2 rows in set, 1 warning (0.00 sec)

```
## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.
```
У меня my.cnf находится в другой директории. /etc/my.cnf.
В докере нет никакого редактора, поэтому я скопировал файл.
cp /etc/my.cnf /media/mysql/backup/

# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
innodb_flush_log_at_trx_commit = 0
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 2G
innodb_log_file_size = 100M
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid



```
---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
