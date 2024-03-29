# Домашнее задание к занятию «Компоненты Kubernetes»

### Цель задания

Рассчитать требования к кластеру под проект

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания:

- [Considerations for large clusters](https://kubernetes.io/docs/setup/best-practices/cluster-large/),
- [Architecting Kubernetes clusters — choosing a worker node size](https://learnk8s.io/kubernetes-node-size).

------

### Задание. Необходимо определить требуемые ресурсы
Известно, что проекту нужны база данных, система кеширования, а само приложение состоит из бекенда и фронтенда. Опишите, какие ресурсы нужны, если известно:

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. База данных должна быть отказоустойчивой. Потребляет 4 ГБ ОЗУ в работе, 1 ядро. 3 копии. 
3. Кеш должен быть отказоустойчивый. Потребляет 4 ГБ ОЗУ в работе, 1 ядро. 3 копии. 
4. Фронтенд обрабатывает внешние запросы быстро, отдавая статику. Потребляет не более 50 МБ ОЗУ на каждый экземпляр, 0.2 ядра. 5 копий. 
5. Бекенд потребляет 600 МБ ОЗУ и по 1 ядру на копию. 10 копий.

----


### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Сначала сделайте расчёт всех необходимых ресурсов.
3. Затем прикиньте количество рабочих нод, которые справятся с такой нагрузкой.
4. Добавьте к полученным цифрам запас, который учитывает выход из строя как минимум одной ноды.
5. Добавьте служебные ресурсы к нодам. Помните, что для разных типов нод требовния к ресурсам разные.
6. В результате должно быть указано количество нод и их параметры.

#### Ответ
```

Расчет необходимых ресурсов.

    База данных: 4 ГБ ОЗУ и 1 ядро * 3 копии = 12 ГБ ОЗУ, 3 ядра.  
    Кеш: 4 ГБ ОЗУ и 1 ядро * 3 копии = 12 ГБ ОЗУ, 3 ядра.  
    Фронтенд: 50 МБ ОЗУ и 0.2 ядра * 5 копий = 250 МБ ОЗУ, 1 ядро.  
    Бекенд: 600 МБ ОЗУ и 1 ядро * 10 копий = 6 ГБ ОЗУ, 10 ядер.  
    Хранилище чартов: 2гб и 0.5 ядра * 2 копии = 4 ГБ ОЗУ, 1 ядро.  
    CI\CD: 6 ГБ ОЗУ, 3 Ядра * 1 копия = 6 Гб ОЗУ, 3 ядра.  

Итого: 
    Оперативная память: 12 + 12 + 0.25 + 6 + 4 + 6 = 40.25 ГБ ОЗУ  
    Процессор: 3 + 3  + 1  + 10 + 4 = 21 ядер.

Расчет серверов.

Для воркер нод с 12 ядрами и 32 ГБ оперативной памяти, и для мастер нод с 2 ядрами и 2 ГБ оперативной памяти.  
Рабочие worker ноды: Округлим вверх суммарные ресурсы / ресурсы на одной воркер ноде.  

Минимальное кол-во рабочих воркер нод для работы приложений =   
ОЗУ 40.25/32=1,2578125 - округляем вверх = 2  
CPU 21/16=1,3125 - Округляем и получаем = 2  
Добавим одну воркер ноду для высокой доступности в случае сбоя одной из нод и распределение ресурсов.  
И получаем 3 worker ноды 12 ядер и 32гб каждая.  

Master ноды с учетом малого кол-ва подов и нод в целом выберем 3 сервера с 2 ядрами и 4 ГБ ОЗУ.  

Итого для серверов: 3 рабочие воркер ноды с 12 ядрами и 32 ГБ ОЗУ, и 3 мастер ноды с 2 ядрами и 4 ГБ ОЗУ.  
 
```
