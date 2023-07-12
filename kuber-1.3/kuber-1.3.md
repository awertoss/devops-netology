# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
```
touch deployment1.yaml
chmod +x deployment1.yaml
```
Конфиг: [deployment1.yaml](deployment1.yaml)

```
root@promitey:~/kuber3# microk8s kubectl apply -f deployment1.yaml
deployment.apps/deployment created
deployment.apps/multitool created
service/service-nginx created

root@promitey:~/kuber3# microk8s kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
multitool    0/1     1            0           98m
deployment   0/1     1            0           98m



```
   
2. После запуска увеличить количество реплик работающего приложения до 2.

```
Изменил replicas: 2.
root@promitey:~/kuber3# microk8s kubectl apply -f deployment.yaml
deployment.apps/deployment configured
deployment.apps/multitool unchanged
service/service-nginx unchanged


```

3. Продемонстрировать количество подов до и после масштабирования.

```
До
root@promitey:~/kuber3# microk8s kubectl get pods
NAME                          READY   STATUS              RESTARTS   AGE
multitool-7b7cbff84c-j2qhs    0/1     Pending             0          111m
deployment-7955d8f4b5-qzlzr   0/1     Pending             0          111m

После
root@promitey:~/kuber3# microk8s kubectl get pods
NAME                          READY   STATUS              RESTARTS   AGE
multitool-7b7cbff84c-j2qhs    0/1     Pending             0          113m
deployment-7955d8f4b5-qzlzr   0/1     Pending             0          113m
deployment-7955d8f4b5-7lcrn   0/1     Pending             0          9s

```

4. Создать Service, который обеспечит доступ до реплик приложений из п.1.

```
root@promitey:~/kuber3# microk8s kubectl get svc
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes      ClusterIP   10.152.183.1     <none>        443/TCP   14d
service-nginx   ClusterIP   10.152.183.26    <none>        80/TCP    114m
```
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

```

root@promitey:~/kuber3# kubectl run multitool --image=wbitt/network-multitool
pod/multitool created

microk8s kubectl exec multitool-7b7cbff84c-glld6 n -- curl 10.152.183.26

```

------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------
