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
root@promitey:~/kuber3# kubectl apply -f deployment1.yaml
deployment.apps/deployment created


root@promitey:~/kuber3# microk8s kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
deployment   1/1     1            1           18h

```
   
2. После запуска увеличить количество реплик работающего приложения до 2.

```
Изменил replicas: 2.
root@promitey:~/kuber3# microk8s kubectl apply -f deployment1.yaml
deployment.apps/deployment configured

```

3. Продемонстрировать количество подов до и после масштабирования.

```
До
root@promitey:~/kuber3# microk8s kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-7b5655b98b-52xv2   2/2     Running   0          5m42s

После
root@promitey:~/kuber3# microk8s kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-7b5655b98b-52xv2   2/2     Running   0          13m
deployment-7b5655b98b-p8c57   2/2     Running   0          13s

```

4. Создать Service, который обеспечит доступ до реплик приложений из п.1.

```
touch service.yaml
chmod +x service.yaml
```

Конфиг: [service.yaml](service.yaml)

```
microk8s kubectl apply -f service.yaml
service/nginx-svc created

root@promitey:~/kuber3# microk8s kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP   2d18h
nginx-svc    ClusterIP   10.152.183.238   <none>        80/TCP    28s

```
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

```

root@promitey:~/kuber3# microk8s kubectl run multitool --image=wbitt/network-multitool
pod/multitool created

 microk8s kubectl exec multitool -- curl 10.152.183.238
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0  12134      0 --:--:-- --:--:-- --:--:-- 12489
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>


```

------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.

```
touch deployment2.yaml
chmod +x deployment2.yaml
```

Конфиг: [deployment2.yaml](deployment2.yaml)

```
microk8s kubectl apply -f deployment2.yaml
pod/myapp-pod created

```
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.

```
microk8s kubectl logs myapp-pod
Defaulted container "myapp-container" out of: myapp-container, init-myservice (init)

```
3. Создать и запустить Service. Убедиться, что Init запустился.

```
touch service2.yaml
chmod +x service2.yaml
```

Конфиг: [service2.yaml](service2.yaml)

```
microk8s kubectl apply -f service2.yaml
service/nginx-svc2 created

```
4. Продемонстрировать состояние пода до и после запуска сервиса.

```
До
microk8s kubectl get pods
NAME                          READY   STATUS     RESTARTS   AGE
myapp-pod                     0/1     Init:0/1   0          85s

После
 microk8s kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
myapp-pod                     1/1     Running   0          2m46s

```

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------
