# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

```
Буду устанавливать k8s c помощью Kubespray — набор ansible-ролей для установки и конфигурации Kubernetes.

Вначале скопирую репозиторий.
git clone https://github.com/kubernetes-sigs/kubespray

Далее установим yc.

curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
Downloading yc 0.108.1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  100M  100  100M    0     0  10.2M      0  0:00:09  0:00:09 --:--:-- 10.4M
Yandex Cloud CLI 0.108.1 linux/amd64

 yc -v
Yandex Cloud CLI 0.108.1 linux/amd64

yc init
Welcome! This command will take you through the configuration process.
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb in order to obtain OAuth token.

Создадим в yc необходимое количество виртуальных машин

yc vpc network create  --name net --labels my-label=netology --description "net yc"
id: enpvfd7s3qaeh1tre4t0
folder_id: b1gd02p4ii36h57v2h14
created_at: "2023-08-10T06:16:31Z"
name: net
description: net yc
labels:
  my-label: netology

yc vpc subnet create  --name my-subnet --zone ru-central1-c --range 10.1.2.0/24 --network-name net --description "subnet yc"
id: b0cj69jp8s8jmpripti0
folder_id: b1gd02p4ii36h57v2h14
created_at: "2023-08-10T06:17:26Z"
name: my-subnet
description: subnet yc
network_id: enpvfd7s3qaeh1tre4t0
zone_id: ru-central1-c
v4_cidr_blocks:
  - 10.1.2.0/24

Запусти bash скрипт создания виртуальных машин.
bash createvm.bash

```
<p align="center">
  <img width="1200" src="createvm1.jpg">
</p>


## Дополнительные задания (со звёздочкой)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой необязательные к выполнению и не повлияют на получение зачёта по этому домашнему заданию. 

------
### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl get nodes`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
