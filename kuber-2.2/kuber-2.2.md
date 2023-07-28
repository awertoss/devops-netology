# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.

Конфиг: [deployment1.yaml](deployment1.yaml)
```
microk8s kubectl apply -f deployment1.yaml
deployment.apps/deployment created
```
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.

Конфиг: [pvc.yaml](pvc.yaml)
Конфиг: [pv.yaml](pv.yaml)

```
microk8s kubectl apply -f pv.yaml
persistentvolume/pv created

microk8s kubectl apply -f pvc.yaml
persistentvolumeclaim/pvc created

microk8s kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
deployment   1/1     1            1           2m54s


microk8s kubectl get pv
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM         STORAGECLASS   REASON   AGE
pv     1Gi        RWO            Delete           Bound    default/pvc                           84s

microk8s kubectl get pvc
NAME   STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc    Bound    pv       1Gi        RWO                           100s

```

3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории.

```
 microk8s kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
deployment-c57b49d9d-4pss8   2/2     Running   0          4m4s


microk8s kubectl exec deployment-c57b49d9d-4pss8 -c multitool  -- tail -n 10 /my/output.txt
Fri Jul 28 08:02:21 UTC 2023
Every 5.0s: date                                            2023-07-28 08:02:26

Fri Jul 28 08:02:26 UTC 2023
Every 5.0s: date                                            2023-07-28 08:02:31

Fri Jul 28 08:02:31 UTC 2023
Every 5.0s: date                                            2023-07-28 08:02:36

Fri Jul 28 08:02:36 UTC 2023



``` 
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.

```
microk8s kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
deployment   1/1     1            1           5m24s


microk8s kubectl delete deployments deployment
deployment.apps "deployment" deleted

microk8s kubectl get pvc
NAME   STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc    Bound    pv       1Gi        RWO                           3m48s


microk8s kubectl delete pvc pvc
persistentvolumeclaim "pvc" deleted

kubectl get pv
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM         STORAGECLASS   REASON   AGE
pv     1Gi        RWO            Delete           Failed   default/pvc                           4m50s

В конфиге pv, есть строчка persistentVolumeReclaimPolicy: Delete.
После удаления pvc, удаляется pv. Если этой строчки не было, то pv бы не удалялся.

```
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.

```

ls /my/pv/output.txt
/my/pv/output.txt

microk8s kubectl delete pv pv
persistentvolume "pv" deleted

ls /my/pv/output.txt
/my/pv/output.txt


```

6. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

```
Смотреть выше.
```

------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.

[Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs).



2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.

Конфиг: [deployment2.yaml](deployment2.yaml)

Конфиг: [pvc2.yaml](pvc2.yaml)

Конфиг: [sc-nfs.yaml](sc-nfs.yaml)
```
microk8s kubectl apply -f deployment2.yaml
deployment.apps/multitool created

microk8s kubectl apply -f - < sc-nfs.yaml
storageclass.storage.k8s.io/nfs-csi created

microk8s kubectl apply -f - < pvc-nfs.yaml
persistentvolumeclaim/my-pvc created

microk8s kubectl describe pvc my-pvc
Name:          my-pvc
Namespace:     default
StorageClass:  nfs-csi
Status:        Bound
Volume:        pvc-aae5d498-e93d-4f88-b442-dbd33e4fde7f
Labels:        <none>
Annotations:   pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
               volume.beta.kubernetes.io/storage-provisioner: nfs.csi.k8s.io
               volume.kubernetes.io/storage-provisioner: nfs.csi.k8s.io
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      1Gi
Access Modes:  RWO
VolumeMode:    Filesystem
Used By:       <none>
Events:
  Type     Reason              Age                   From                                                            Message
  ----     ------              ----                  ----                                                            -------
  Warning  ProvisioningFailed  108s (x7 over 2m51s)  nfs.csi.k8s.io_ubuntutest_e49bf63b-989e-4996-8955-3b9f9b75ce36  failed to provision volume with StorageClass "nfs-csi": rpc error: code = Internal desc = failed to mount nfs server: rpc error: code = Internal desc = mount failed: exit status 32
Mounting command: mount
Mounting arguments: -t nfs -o hard,nfsvers=4.1 10.100.0.195:/srv/nfs /tmp/pvc-aae5d498-e93d-4f88-b442-dbd33e4fde7f
Output: mount.nfs: access denied by server while mounting 10.100.0.195:/srv/nfs
  Normal  ExternalProvisioning   49s (x11 over 2m51s)  persistentvolume-controller                                     waiting for a volume to be created, either by external provisioner "nfs.csi.k8s.io" or manually created by system administrator
  Normal  Provisioning           44s (x8 over 2m51s)   nfs.csi.k8s.io_ubuntutest_e49bf63b-989e-4996-8955-3b9f9b75ce36  External provisioner is provisioning volume for claim "default/my-pvc"
  Normal  ProvisioningSucceeded  43s                   nfs.csi.k8s.io_ubuntutest_e49bf63b-989e-4996-8955-3b9f9b75ce36  Successfully provisioned volume pvc-aae5d498-e93d-4f88-b442-dbd33e4fde7f


```
3. Продемонстрировать возможность чтения и записи файла изнутри пода.

```
microk8s kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
multitool-75f7ccd67-w8dn4   2/2     Running   0          2m3s

root@ubuntutest:~/kuber22# microk8s kubectl exec multitool-75f7ccd67-w8dn4 -c multitool  -- tail -n 10 /my/output.txt
Fri Jul 28 13:29:22 UTC 2023
Every 5.0s: date                                            2023-07-28 13:29:27

Fri Jul 28 13:29:27 UTC 2023
Every 5.0s: date                                            2023-07-28 13:29:32

Fri Jul 28 13:29:32 UTC 2023
Every 5.0s: date                                            2023-07-28 13:29:37

Fri Jul 28 13:29:37 UTC 2023



```

 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

```
Смотреть выше.
```

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
