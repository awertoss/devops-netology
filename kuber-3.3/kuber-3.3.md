# Домашнее задание к занятию «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

#### Решение

Создаем namespace

```
microk8s kubectl create namespace app
namespace/app created
```

Создаем deployment и сервисы к ним.

```
 microk8s kubectl apply -f frontend.yaml
deployment.apps/frontend created

microk8s kubectl apply -f backend.yaml
deployment.apps/backend created

 microk8s kubectl apply -f svc-frontend.yaml
service/frontend created

microk8s kubectl apply -f svc-backend.yaml
service/backend created

microk8s kubectl apply -f cache.yaml
deployment.apps/cache created

 microk8s kubectl apply -f svc-cache.yaml
service/cache created

 microk8s kubectl get -n app deployments
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
cache      1/1     1            1           2m34s
frontend   1/1     1            1           3m34s
backend    1/1     1            1           3m2s

microk8s kubectl config set-context --current --namespace=app
Context "microk8s" modified.

microk8s kubectl get pod -o wide
NAME                       READY   STATUS    RESTARTS   AGE     IP           NODE         NOMINATED NODE   READINESS GATES
cache-5cd6c7468-2bm25      1/1     Running   0          4m25s   10.1.45.69   ubuntutest   <none>           <none>
frontend-7ddf66cbb-gxtpx   1/1     Running   0          5m25s   10.1.45.67   ubuntutest   <none>           <none>
backend-5c496f8f74-dl98f   1/1     Running   0          4m54s   10.1.45.68   ubuntutest   <none>           <none>
```

Создаем сетевые политики.

```

```

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
