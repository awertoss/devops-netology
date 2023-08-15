# Домашнее задание к занятию «Управление доступом»

### Цель задания

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.

------

### Чеклист готовности к домашнему заданию

1. Установлено k8s-решение, например MicroK8S.
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым github-репозиторием.

------

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.

```
root@promitey:/home/srg/kuber24# openssl genrsa -out awertoss.key 2048
root@promitey:/home/srg/kuber24# openssl req -new -key awertoss.key -out awertoss.csr -subj "/CN=awertoss/O=group1"
root@promitey:/home/srg/kuber24# openssl x509 -req -in awertoss.csr -CA /var/snap/microk8s/4595/certs/ca.crt -CAkey /var/snap/microk8s/4595/certs/ca.key -CAcreateserial -out awertoss.crt -days 500
Certificate request self-signature ok
subject=CN = awertoss, O = group1
Could not open file or uri for loading CA certificate from /var/snap/microk8s/4595/certs/ca.crt
4067EBAD807F0000:error:16000069:STORE routines:ossl_store_get0_loader_int:unregistered scheme:../crypto/store/store_register.c:237:scheme=file
4067EBAD807F0000:error:80000002:system library:file_open:No such file or directory:../providers/implementations/storemgmt/file_store.c:267:calling stat(/var/snap/microk8s/4595/certs/ca.crt)
Unable to load CA certificate

```
2. Настройте конфигурационный файл kubectl для подключения.

```
Настраиваем конфигурационный файл. Добавляем юзера, добавляем контекст и проверяем конфигурацию.
root@promitey:/home/srg/kuber24# kubectl config set-credentials awertoss --client-certificate=cert/awertoss.crt --client-key=cert/awertoss.key

kubectl config set-context awertoss-context --cluster=microk8s-cluster --user=awertoss
Context "awertoss-context" created.

Смотрим конфиг.
kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://10.100.1.189:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: awertoss
  name: awertoss-context
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: REDACTED
- name: awertoss
  user:
    client-certificate: /home/srg/kuber24/cert/awertoss.crt
    client-key: /home/srg/kuber24/cert/awertoss.key


```
3. Создайте роли и все необходимые настройки для пользователя.
```
 kubectl apply -f role_binding.yaml
rolebinding.rbac.authorization.k8s.io/pod-reader created

kubectl apply -f role.yaml
role.rbac.authorization.k8s.io/pod-desc-logs created
```

4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).

```
Добавляем в роль verbs: где ["watch", "list"]

 kubectl get role pod-desc-logs -o yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"rbac.authorization.k8s.io/v1","kind":"Role","metadata":{"annotations":{},"name":"pod-desc-logs","namespace":"default"},"rules":[{"apiGroups":[""],"resources":["pods","pods/log"],"verbs":["watch","list","get"]}]}
  creationTimestamp: "2023-08-14T06:17:18Z"
  name: pod-desc-logs
  namespace: default
  resourceVersion: "5233519"
  uid: 0298e69a-700d-405d-a009-f58d0ea6d873
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - pods/log
  verbs:
  - watch
  - list
  - get



``` 


5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

Конфиг: [role.yaml](role.yaml)

Конфиг: [role_binding.yaml](role_binding.yaml)


------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
