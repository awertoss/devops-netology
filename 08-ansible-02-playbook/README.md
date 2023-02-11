# Домашнее задание к занятию "2. Работа с Playbook"

Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги

```
Playbook устанавливает Clickhouse и Vector, а также производит настройку на указанных серверах, которые указаны в файле inventory/prod.yml.

Install Clickhouse - указывается handler для перезапуска сервиса  
Get clickhouse distrib - скачиваются необходимые пакеты.
Install clickhouse packages - устанавливаются скачанные пакеты  
Start clickhouse-server - стартует server.
Create database - Создаётся БД logs.


Install Vector - указывается handler для перезапуска сервиса
Get vector distrib - скачиваются необходимые пакеты.
Install vector package -  устанавливаются скачанные пакеты , оповещается handler для перезапуска сервиса 

```
