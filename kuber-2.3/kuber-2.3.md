# Домашнее задание к занятию «Конфигурация приложений»

### Цель задания

В тестовой среде Kubernetes необходимо создать конфигурацию и продемонстрировать работу приложения.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8s).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым GitHub-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/configuration/secret/) Secret.
2. [Описание](https://kubernetes.io/docs/concepts/configuration/configmap/) ConfigMap.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.

Конфиг: [deployment1.yaml](deployment1.yaml)

```
microk8s kubectl apply -f deployment1.yaml
deployment.apps/deployment created
```

2. Решить возникшую проблему с помощью ConfigMap.

Конфиг: [configmap.yaml](configmap.yaml)

```
microk8s kubectl apply -f configmap.yaml
configmap/indexname created

```
3. Продемонстрировать, что pod стартовал и оба конейнера работают.

```
microk8s kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-5cd95d6d79-5xxt7   2/2     Running   0          3m36s

```
4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.

Конфиг: [service.yaml](service.yaml)
```
microk8s kubectl apply -f service.yaml
service/servicename created

microk8s kubectl get svc
NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes    ClusterIP   10.152.183.1     <none>        443/TCP        23d
servicename   NodePort    10.152.183.224   <none>        80:30000/TCP   8m11s

curl 10.100.0.195:30000
<html>
<h1>Hello</h1>
</br>
<h1>I know how it works. </h1>
</html>


```
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

```
Смотреть выше.
```

------

### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.
2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
3. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.
4. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём GitHub-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
