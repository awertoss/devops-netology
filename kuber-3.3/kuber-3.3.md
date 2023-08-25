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

Конфиг: [frontend.yaml](frontend.yaml)

Конфиг: [backend.yaml](backend.yaml)

Конфиг: [cache.yaml](cache.yaml)

Конфиг: [svc-frontend.yaml](svc-frontend.yaml)

Конфиг: [svc-backend.yaml](svc-backend.yaml)

Конфиг: [svc-cache.yaml](svc-cache.yaml)
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

Конфиг: [np-zapret.yaml](np-zapret.yaml)

Конфиг: [np-frontend.yaml](np-frontend.yaml)

Конфиг: [np-backend.yaml](np-backend.yaml)

Конфиг: [np-cache.yaml](np-cache.yaml)

```
Вначале делаем полный запрет.

microk8s kubectl apply -f np-zapret.yaml
networkpolicy.networking.k8s.io/default-deny-ingress created

Проверка запрета.
microk8s kubectl get pod -o wide
NAME                       READY   STATUS    RESTARTS   AGE   IP           NODE         NOMINATED NODE   READINESS GATES
cache-5cd6c7468-2bm25      1/1     Running   0          22m   10.1.45.69   ubuntutest   <none>           <none>
frontend-7ddf66cbb-gxtpx   1/1     Running   0          23m   10.1.45.67   ubuntutest   <none>           <none>
backend-5c496f8f74-dl98f   1/1     Running   0          23m   10.1.45.68   ubuntutest   <none>           <none>

microk8s kubectl exec frontend-7ddf66cbb-gxtpx -- curl cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:02:10 --:--:--     0
curl: (28) Failed to connect to cache port 80 after 130418 ms: Operation timed out
command terminated with exit code 28

Разрешающие правила

microk8s kubectl apply -f np-frontend.yaml
networkpolicy.networking.k8s.io/frontend created
microk8s kubectl apply -f np-cache.yaml
networkpolicy.networking.k8s.io/cache created
root@ubuntutest:/home/srg/kuber33# microk8s kubectl apply -f np-backend.yaml
networkpolicy.networking.k8s.io/backend created

Проверка.
 microk8s kubectl exec frontend-7ddf66cbb-gxtpx -- curl --max-time 10 backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0Praqma Network MultiTool (with NGINX) - backend-5c496f8f74-dl98f - 10.1.45.68
100    78  100    78    0     0   3746      0 --:--:-- --:--:-- --:--:--  3900

microk8s kubectl exec backend-5c496f8f74-dl98f -- curl --max-time 10 cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    75  100    75    0     0   1399      0 --:--:-- --:--:-- --:--:--  1415
Praqma Network MultiTool (with NGINX) - cache-5cd6c7468-2bm25 - 10.1.45.69

microk8s kubectl exec cache-5cd6c7468-2bm25 -- curl --max-time 10 backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0
curl: (28) Connection timed out after 10000 milliseconds
command terminated with exit code 28

microk8s kubectl exec cache-5cd6c7468-2bm25 -- curl --max-time 10 frontend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0
curl: (28) Connection timed out after 10001 milliseconds
command terminated with exit code 28



```

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
