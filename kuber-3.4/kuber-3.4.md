# Домашнее задание к занятию «Обновление приложений»

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment).
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/).

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

```
Выбираю стратегию обновления Rolling update — постепенное обновление.
Данная стратегия постепенно, один за другим заменяет поды со старой версией приложения
на поды с новой версией без простоя кластера. И если что-то пойдет не так, можно будет быстро откатиться к предыдущему состоянию.

```

### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.

Конфиг: [deployment.yaml](deployment.yaml)

Конфиг: [svc.yaml](svc.yaml)

```
microk8s kubectl apply -f deployment.yaml
deployment.apps/deployment created
microk8s kubectl apply -f svc.yaml
service/svc created

microk8s kubectl get pod
NAME                          READY   STATUS    RESTARTS   AGE
deployment-695c4cbf56-lqdcn   2/2     Running   0          110s
deployment-695c4cbf56-9lrcj   2/2     Running   0          110s
deployment-695c4cbf56-mjr8j   2/2     Running   0          110s
deployment-695c4cbf56-4dlc9   2/2     Running   0          110s
deployment-695c4cbf56-zfdvq   2/2     Running   0          110s


```
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.

```
Обновляем. Меняем в deployment.yaml параметр image: nginx:1.19 на 1.20.

А также добавляем стартегию:
strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1

microk8s kubectl apply -f deployment.yaml
deployment.apps/deployment configured

 microk8s kubectl get pod -o wide
NAME                          READY   STATUS              RESTARTS   AGE     IP           NODE         NOMINATED NODE   READINESS GATES
deployment-695c4cbf56-4dlc9   2/2     Running             0          6m44s   10.1.45.83   ubuntutest   <none>           <none>
deployment-749d54bdb8-htsll   2/2     Running             0          43s     10.1.45.84   ubuntutest   <none>           <none>
deployment-749d54bdb8-v2rmq   2/2     Running             0          40s     10.1.45.86   ubuntutest   <none>           <none>
deployment-749d54bdb8-t996t   0/2     ContainerCreating   0          13s     <none>       ubuntutest   <none>           <none>
deployment-749d54bdb8-825jx   2/2     Running             0          16s     10.1.45.89   ubuntutest   <none>           <none>
deployment-695c4cbf56-mjr8j   2/2     Terminating         0          6m44s   10.1.45.82   ubuntutest   <none>           <none>

Прошло время и все поды обновились.

microk8s kubectl get pod -o wide
NAME                          READY   STATUS    RESTARTS   AGE     IP           NODE         NOMINATED NODE   READINESS GATES
deployment-749d54bdb8-htsll   2/2     Running   0          3m11s   10.1.45.84   ubuntutest   <none>           <none>
deployment-749d54bdb8-v2rmq   2/2     Running   0          3m8s    10.1.45.86   ubuntutest   <none>           <none>
deployment-749d54bdb8-825jx   2/2     Running   0          2m44s   10.1.45.89   ubuntutest   <none>           <none>
deployment-749d54bdb8-t996t   2/2     Running   0          2m41s   10.1.45.91   ubuntutest   <none>           <none>
deployment-749d54bdb8-jwssx   2/2     Running   0          2m28s   10.1.45.88   ubuntutest   <none>           <none>

kubectl describe deployment deployment
Name:                   deployment
Namespace:              app
CreationTimestamp:      Sat, 02 Sep 2023 04:25:11 +0000
Labels:                 app=main
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=main
Replicas:               5 desired | 5 updated | 5 total | 5 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
Pod Template:
  Labels:  app=main
  Containers:
   nginx:
    Image:        nginx:1.20
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
   network-multitool:
    Image:       wbitt/network-multitool
    Ports:       8080/TCP, 11443/TCP
    Host Ports:  0/TCP, 0/TCP
    Limits:
      cpu:     10m
      memory:  20Mi
    Requests:
      cpu:     1m
      memory:  20Mi
    Environment:
      HTTP_PORT:   8080
      HTTPS_PORT:  11443
    Mounts:        <none>
  Volumes:         <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  deployment-695c4cbf56 (0/0 replicas created)
NewReplicaSet:   deployment-749d54bdb8 (5/5 replicas created)
Events:
  Type    Reason             Age                    From                   Message
  ----    ------             ----                   ----                   -------
  Normal  ScalingReplicaSet  4m29s                  deployment-controller  Scaled up replica set deployment-749d54bdb8 to 1
  Normal  ScalingReplicaSet  4m29s                  deployment-controller  Scaled down replica set deployment-695c4cbf56 to 4 from 5
  Normal  ScalingReplicaSet  4m26s                  deployment-controller  Scaled up replica set deployment-749d54bdb8 to 2 from 1
  Normal  ScalingReplicaSet  4m2s                   deployment-controller  Scaled down replica set deployment-695c4cbf56 to 3 from 4
  Normal  ScalingReplicaSet  4m2s                   deployment-controller  Scaled up replica set deployment-749d54bdb8 to 3 from 2
  Normal  ScalingReplicaSet  4m                     deployment-controller  Scaled down replica set deployment-695c4cbf56 to 2 from 3
  Normal  ScalingReplicaSet  3m59s                  deployment-controller  Scaled up replica set deployment-749d54bdb8 to 4 from 3
  Normal  ScalingReplicaSet  3m46s                  deployment-controller  Scaled down replica set deployment-695c4cbf56 to 1 from 2
  Normal  ScalingReplicaSet  3m44s (x2 over 3m46s)  deployment-controller  (combined from similar events): Scaled down replica set deployment-695c4cbf56 to 0 from 1

```

3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.


```
Меняем в deployment.yaml параметр image: nginx:1.20 на 1.28.

microk8s kubectl apply -f deployment.yaml
deployment.apps/deployment configured

microk8s kubectl get pod
NAME                          READY   STATUS             RESTARTS   AGE
deployment-749d54bdb8-v2rmq   2/2     Running            0          8m33s
deployment-749d54bdb8-825jx   2/2     Running            0          8m9s
deployment-749d54bdb8-t996t   2/2     Running            0          8m6s
deployment-749d54bdb8-jwssx   2/2     Running            0          7m53s
deployment-59c448484d-bswt7   1/2     ImagePullBackOff   0          73s
deployment-59c448484d-rgp74   1/2     ImagePullBackOff   0          75s

Видно, что-то пошло не так.

```

4. Откатиться после неудачного обновления.

```
microk8s kubectl rollout undo deployment deployment
deployment.apps/deployment rolled back

 microk8s kubectl get pod
NAME                          READY   STATUS    RESTARTS   AGE
deployment-749d54bdb8-v2rmq   2/2     Running   0          11m
deployment-749d54bdb8-825jx   2/2     Running   0          10m
deployment-749d54bdb8-t996t   2/2     Running   0          10m
deployment-749d54bdb8-jwssx   2/2     Running   0          10m
deployment-749d54bdb8-jg6cs   2/2     Running   0          53s

```

## Дополнительные задания — со звёздочкой*

Задания дополнительные, необязательные к выполнению, они не повлияют на получение зачёта по домашнему заданию. **Но мы настоятельно рекомендуем вам выполнять все задания со звёздочкой.** Это поможет лучше разобраться в материале.   

### Задание 3*. Создать Canary deployment

1. Создать два deployment'а приложения nginx.
2. При помощи разных ConfigMap сделать две версии приложения — веб-страницы.
3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
