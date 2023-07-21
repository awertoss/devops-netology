# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

Конфиг: [deployment1.yaml](deployment1.yaml)

```
mkdir /my

microk8s kubectl apply -f deployment1.yaml
deployment.apps/deployment created

microk8s kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
deployment   1/1     1            1           11s

microk8s kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-7bd9c887c4-5jjsh   2/2     Running   0          55s

Проверка.
microk8s kubectl exec deployment-7bd9c887c4-5jjsh -c multitool  -- tail -n 10 /my/output.txt
Fri Jul 21 06:34:34 UTC 2023
Every 5.0s: date                                            2023-07-21 06:34:39

Fri Jul 21 06:34:39 UTC 2023
Every 5.0s: date                                            2023-07-21 06:34:44

Fri Jul 21 06:34:44 UTC 2023
Every 5.0s: date                                            2023-07-21 06:34:49

Fri Jul 21 06:34:49 UTC 2023


microk8s kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-7bd9c887c4-5jjsh   2/2     Running   0          27m
daemonset-qgsxc               1/1     Running   0          14m


```
------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

Конфиг: [deployment2.yaml](deployment2.yaml)

```
microk8s kubectl apply -f deployment2.yaml
daemonset.apps/daemonset created

microk8s kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-7bd9c887c4-5jjsh   2/2     Running   0          40m
daemonset-n6bv7               1/1     Running   0          3m14s

Проверка.
root@ubuntutest:~/kuber21# microk8s kubectl exec daemonset-n6bv7 -it -- sh
/ # tail -n 10 /var/log/syslog
Jul 21 07:12:46 ubuntutest systemd[1]: run-containerd-runc-k8s.io-cc365ff569b92e5885153a5cef7338bcdb020af40877ff3399ed5fd08fa2a88e-runc.jjPeW0.mount: Deactivated successfully.
Jul 21 07:13:39 ubuntutest microk8s.daemon-containerd[948]: time="2023-07-21T07:13:39.693972368Z" level=info msg="Container exec \"78084531a76d55b9858fea8c535a207a2c6e2b68a42812c41b9bb80530a9ff94\" stdin closed"
Jul 21 07:13:39 ubuntutest systemd[1]: snap.microk8s.microk8s.f75ed491-c517-4606-9d43-327bd1e81b8c.scope: Deactivated successfully.
Jul 21 07:13:44 ubuntutest systemd[1]: Started snap.microk8s.microk8s.ae592550-0201-40e2-bf86-7f6006b77897.scope.
Jul 21 07:13:44 ubuntutest systemd[1]: snap.microk8s.microk8s.ae592550-0201-40e2-bf86-7f6006b77897.scope: Deactivated successfully.
Jul 21 07:13:56 ubuntutest systemd[1]: run-containerd-runc-k8s.io-cc365ff569b92e5885153a5cef7338bcdb020af40877ff3399ed5fd08fa2a88e-runc.mhbiLx.mount: Deactivated successfully.
Jul 21 07:14:01 ubuntutest systemd[1]: run-containerd-runc-k8s.io-2185c0a78636765196054f89e28bb1efcb4ee49337acaf3a94a77027a772d7b7-runc.NL0UGu.mount: Deactivated successfully.
Jul 21 07:14:10 ubuntutest systemd[1]: Started snap.microk8s.microk8s.dff99e93-a955-4d27-b4c0-f614a6e1c42d.scope.
Jul 21 07:14:11 ubuntutest systemd[1]: run-containerd-runc-k8s.io-cc365ff569b92e5885153a5cef7338bcdb020af40877ff3399ed5fd08fa2a88e-runc.A1H9dw.mount: Deactivated successfully.
Jul 21 07:14:16 ubuntutest systemd[1]: run-containerd-runc-k8s.io-cc365ff569b92e5885153a5cef7338bcdb020af40877ff3399ed5fd08fa2a88e-runc.RkwZal.mount: Deactivated successfully.

```

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
