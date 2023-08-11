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
done (30s)
id: ef3ug8t6n989j1bnpp2b
folder_id: b1gd02p4ii36h57v2h14
created_at: "2023-08-10T06:46:24Z"
name: masterk8s
zone_id: ru-central1-c
platform_id: standard-v2
resources:
  memory: "2147483648"
  cores: "2"
  core_fraction: "100"
status: RUNNING
metadata_options:
  gce_http_endpoint: ENABLED
  aws_v1_http_endpoint: ENABLED
  gce_http_token: ENABLED
  aws_v1_http_token: DISABLED
boot_disk:
  mode: READ_WRITE
  device_name: ef3q4gujbjbosud1cac7
  auto_delete: true
  disk_id: ef3q4gujbjbosud1cac7
network_interfaces:
  - index: "0"
    mac_address: d0:0d:1e:82:3a:6b
    subnet_id: b0cj69jp8s8jmpripti0
    primary_v4_address:
      address: 10.1.2.32
      one_to_one_nat:
        address: 51.250.37.34
        ip_version: IPV4
gpu_settings: {}
fqdn: masterk8s.ru-central1.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}

done (27s)
id: ef312ojbpotkuptqorin
folder_id: b1gd02p4ii36h57v2h14
created_at: "2023-08-10T06:46:56Z"
name: worker1
zone_id: ru-central1-c
platform_id: standard-v2
resources:
  memory: "2147483648"
  cores: "2"
  core_fraction: "100"
status: RUNNING
metadata_options:
  gce_http_endpoint: ENABLED
  aws_v1_http_endpoint: ENABLED
  gce_http_token: ENABLED
  aws_v1_http_token: DISABLED
boot_disk:
  mode: READ_WRITE
  device_name: ef3drqdloc6k3vm6k41r
  auto_delete: true
  disk_id: ef3drqdloc6k3vm6k41r
network_interfaces:
  - index: "0"
    mac_address: d0:0d:11:62:6b:ce
    subnet_id: b0cj69jp8s8jmpripti0
    primary_v4_address:
      address: 10.1.2.30
      one_to_one_nat:
        address: 51.250.42.226
        ip_version: IPV4
gpu_settings: {}
fqdn: worker1.ru-central1.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}

done (23s)
id: ef3k041lq1jt1jf2dr8k
folder_id: b1gd02p4ii36h57v2h14
created_at: "2023-08-10T06:47:25Z"
name: worker2
zone_id: ru-central1-c
platform_id: standard-v2
resources:
  memory: "2147483648"
  cores: "2"
  core_fraction: "100"
status: RUNNING
metadata_options:
  gce_http_endpoint: ENABLED
  aws_v1_http_endpoint: ENABLED
  gce_http_token: ENABLED
  aws_v1_http_token: DISABLED
boot_disk:
  mode: READ_WRITE
  device_name: ef389blerf28j3m3o32s
  auto_delete: true
  disk_id: ef389blerf28j3m3o32s
network_interfaces:
  - index: "0"
    mac_address: d0:0d:14:01:03:5d
    subnet_id: b0cj69jp8s8jmpripti0
    primary_v4_address:
      address: 10.1.2.20
      one_to_one_nat:
        address: 84.201.144.73
        ip_version: IPV4
gpu_settings: {}
fqdn: worker2.ru-central1.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}

done (37s)
id: ef3c4sqelhraunitnu0r
folder_id: b1gd02p4ii36h57v2h14
created_at: "2023-08-10T06:47:50Z"
name: worker3
zone_id: ru-central1-c
platform_id: standard-v2
resources:
  memory: "2147483648"
  cores: "2"
  core_fraction: "100"
status: RUNNING
metadata_options:
  gce_http_endpoint: ENABLED
  aws_v1_http_endpoint: ENABLED
  gce_http_token: ENABLED
  aws_v1_http_token: DISABLED
boot_disk:
  mode: READ_WRITE
  device_name: ef3godtic3uin5052fgq
  auto_delete: true
  disk_id: ef3godtic3uin5052fgq
network_interfaces:
  - index: "0"
    mac_address: d0:0d:c2:73:4e:ac
    subnet_id: b0cj69jp8s8jmpripti0
    primary_v4_address:
      address: 10.1.2.7
      one_to_one_nat:
        address: 51.250.39.241
        ip_version: IPV4
gpu_settings: {}
fqdn: worker3.ru-central1.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}

done (31s)
id: ef3go25b5k47bnc2cv5b
folder_id: b1gd02p4ii36h57v2h14
created_at: "2023-08-10T06:48:29Z"
name: worker4
zone_id: ru-central1-c
platform_id: standard-v2
resources:
  memory: "2147483648"
  cores: "2"
  core_fraction: "100"
status: RUNNING
metadata_options:
  gce_http_endpoint: ENABLED
  aws_v1_http_endpoint: ENABLED
  gce_http_token: ENABLED
  aws_v1_http_token: DISABLED
boot_disk:
  mode: READ_WRITE
  device_name: ef3hmhs7sojr79n6nlbr
  auto_delete: true
  disk_id: ef3hmhs7sojr79n6nlbr
network_interfaces:
  - index: "0"
    mac_address: d0:0d:10:c0:8a:b2
    subnet_id: b0cj69jp8s8jmpripti0
    primary_v4_address:
      address: 10.1.2.18
      one_to_one_nat:
        address: 51.250.38.203
        ip_version: IPV4
gpu_settings: {}
fqdn: worker4.ru-central1.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}


```
<p align="center">
  <img width="1200" src="createvm1.jpg">
</p>

```
Репозиторий
Подключаемся к виртуальной машине
ssh yc-user@84.201.148.2
The authenticity of host '84.201.148.2 (84.201.148.2)' can't be established.
ED25519 key fingerprint is SHA256:dOcDQa5fVAJKq8QMar3xu9cjGZYdlOex07PO8h2/wts.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '84.201.148.2' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-155-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.





Копируем репозиторий.
apt install git
git clone https://github.com/kubernetes-sigs/kubespray


Установка зависимостей
apt install python3-pip не работает
curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

python3.10 -m pip --version
pip 23.2.1 from /usr/local/lib/python3.10/dist-packages/pip (python 3.10)

pip install -r requirements.txt
Collecting ansible==7.6.0 (from -r requirements.txt (line 1))
  Obtaining dependency information for ansible==7.6.0 from https://files.pythonhosted.org/packages/9a/54/ceba345e4f42ea9d4b8c6f24a51c5edd382ead93acd8f170ce5150e4885d/ansible-7.6.0-py3-none-any.whl.metadata
  Downloading ansible-7.6.0-py3-none-any.whl.metadata (7.9 kB)
Collecting ansible-core==2.14.6 (from -r requirements.txt (line 2))
  Obtaining dependency information for ansible-core==2.14.6 from https://files.pythonhosted.org/packages/88/ea/8a53180f8ca275543eab6a8f032bbe4e91f622c985cb9dd8a3ebb0c305ec/ansible_core-2.14.6-py3-none-any.whl.metadata
  Downloading ansible_core-2.14.6-py3-none-any.whl.metadata (7.4 kB)
Collecting cryptography==41.0.1 (from -r requirements.txt (line 3))
  Obtaining dependency information for cryptography==41.0.1 from https://files.pythonhosted.org/packages/49/35/80c346e1a9509210defa857a05e9b7931093719aab25665d4d54f9b3ba83/cryptography-41.0.1-cp37-abi3-manylinux_2_28_x86_64.whl.metadata
  Downloading cryptography-41.0.1-cp37-abi3-manylinux_2_28_x86_64.whl.metadata (5.2 kB)
Collecting jinja2==3.1.2 (from -r requirements.txt (line 4))
  Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 1.3 MB/s eta 0:00:00
Collecting jmespath==1.0.1 (from -r requirements.txt (line 5))
  Downloading jmespath-1.0.1-py3-none-any.whl (20 kB)
Collecting MarkupSafe==2.1.3 (from -r requirements.txt (line 6))
  Obtaining dependency information for MarkupSafe==2.1.3 from https://files.pythonhosted.org/packages/12/b3/d9ed2c0971e1435b8a62354b18d3060b66c8cb1d368399ec0b9baa7c0ee5/MarkupSafe-2.1.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata
  Downloading MarkupSafe-2.1.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (3.0 kB)
Collecting netaddr==0.8.0 (from -r requirements.txt (line 7))
  Downloading netaddr-0.8.0-py2.py3-none-any.whl (1.9 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.9/1.9 MB 11.7 MB/s eta 0:00:00
Collecting pbr==5.11.1 (from -r requirements.txt (line 8))
  Downloading pbr-5.11.1-py2.py3-none-any.whl (112 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 112.7/112.7 kB 20.6 MB/s eta 0:00:00
Collecting ruamel.yaml==0.17.31 (from -r requirements.txt (line 9))
  Obtaining dependency information for ruamel.yaml==0.17.31 from https://files.pythonhosted.org/packages/9c/9c/e69fc06169ac6e757c66004885e0dfcc6c2b5c1a331a5dc70b890b6b4bf8/ruamel.yaml-0.17.31-py3-none-any.whl.metadata
  Downloading ruamel.yaml-0.17.31-py3-none-any.whl.metadata (17 kB)
Collecting ruamel.yaml.clib==0.2.7 (from -r requirements.txt (line 10))
  Downloading ruamel.yaml.clib-0.2.7-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl (485 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 485.6/485.6 kB 35.5 MB/s eta 0:00:00
Requirement already satisfied: PyYAML>=5.1 in /usr/lib/python3/dist-packages (from ansible-core==2.14.6->-r requirements.txt (line 2)) (5.4.1)
Collecting packaging (from ansible-core==2.14.6->-r requirements.txt (line 2))
  Downloading packaging-23.1-py3-none-any.whl (48 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 48.9/48.9 kB 6.9 MB/s eta 0:00:00
Collecting resolvelib<0.9.0,>=0.5.3 (from ansible-core==2.14.6->-r requirements.txt (line 2))
  Downloading resolvelib-0.8.1-py2.py3-none-any.whl (16 kB)
Collecting cffi>=1.12 (from cryptography==41.0.1->-r requirements.txt (line 3))
  Downloading cffi-1.15.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (441 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 441.8/441.8 kB 44.1 MB/s eta 0:00:00
Collecting pycparser (from cffi>=1.12->cryptography==41.0.1->-r requirements.txt (line 3))
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 118.7/118.7 kB 11.8 MB/s eta 0:00:00
Downloading ansible-7.6.0-py3-none-any.whl (43.8 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 43.8/43.8 MB 4.9 MB/s eta 0:00:00
Downloading ansible_core-2.14.6-py3-none-any.whl (2.2 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.2/2.2 MB 25.1 MB/s eta 0:00:00
Downloading cryptography-41.0.1-cp37-abi3-manylinux_2_28_x86_64.whl (4.3 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.3/4.3 MB 18.3 MB/s eta 0:00:00
Downloading MarkupSafe-2.1.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Downloading ruamel.yaml-0.17.31-py3-none-any.whl (112 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 112.1/112.1 kB 8.3 MB/s eta 0:00:00
DEPRECATION: distro-info 1.1build1 has a non-standard version number. pip 23.3 will enforce this behaviour change. A possible replacement is to upgrade to a newer version of distro-info or contact the author to suggest that they release a version with a conforming version number. Discussion can be found at https://github.com/pypa/pip/issues/12063
Installing collected packages: resolvelib, netaddr, ruamel.yaml.clib, pycparser, pbr, packaging, MarkupSafe, jmespath, ruamel.yaml, jinja2, cffi, cryptography, ansible-core, ansible
  Attempting uninstall: MarkupSafe
    Found existing installation: MarkupSafe 2.0.1
    Uninstalling MarkupSafe-2.0.1:
      Successfully uninstalled MarkupSafe-2.0.1
  Attempting uninstall: jinja2
    Found existing installation: Jinja2 3.0.3
    Uninstalling Jinja2-3.0.3:
      Successfully uninstalled Jinja2-3.0.3
  Attempting uninstall: cryptography
    Found existing installation: cryptography 3.4.8
    Uninstalling cryptography-3.4.8:
      Successfully uninstalled cryptography-3.4.8
Successfully installed MarkupSafe-2.1.3 ansible-7.6.0 ansible-core-2.14.6 cffi-1.15.1 cryptography-41.0.1 jinja2-3.1.2 jmespath-1.0.1 netaddr-0.8.0 packaging-23.1 pbr-5.11.1 pycparser-2.21 resolvelib-0.8.1 ruamel.yaml-0.17.31 ruamel.yaml.clib-0.2.7
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

```
Подготовка файлa host.yaml

```
cp -rfp inventory/sample inventory/mycluster
declare -a IPS=(10.1.2.16 10.1.2.30 10.1.2.32 10.1.2.22 10.1.2.34)

CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
DEBUG: Adding group all
DEBUG: Adding group kube_control_plane
DEBUG: Adding group kube_node
DEBUG: Adding group etcd
DEBUG: Adding group k8s_cluster
DEBUG: Adding group calico_rr
DEBUG: adding host node1 to group all
DEBUG: adding host node2 to group all
DEBUG: adding host node3 to group all
DEBUG: adding host node4 to group all
DEBUG: adding host node5 to group all
DEBUG: adding host node1 to group etcd
DEBUG: adding host node2 to group etcd
DEBUG: adding host node3 to group etcd
DEBUG: adding host node1 to group kube_control_plane
DEBUG: adding host node2 to group kube_control_plane
DEBUG: adding host node1 to group kube_node
DEBUG: adding host node2 to group kube_node
DEBUG: adding host node3 to group kube_node
DEBUG: adding host node4 to group kube_node
DEBUG: adding host node5 to group kube_node

Редактируем файл hosts.yaml руками. В частности добавим ansible_user: yc-user.
cat kubespray/inventory/mycluster/hosts.yaml
all:
  hosts:
    masterk8s:
      ansible_host: 10.1.2.16
      ip: 10.1.2.16
      access_ip: 10.1.2.16
      ansible_user: yc-user
    worker1:
      ansible_host: 10.1.2.30
      ip: 10.1.2.30
      access_ip: 10.1.2.30
      ansible_user: yc-user
    worker2:
      ansible_host: 10.1.2.32
      ip: 10.1.2.32
      access_ip: 10.1.2.32
      ansible_user: yc-user
    worker3:
      ansible_host: 10.1.2.22
      ip: 10.1.2.22
      access_ip: 10.1.2.22
      ansible_user: yc-user
    worker4:
      ansible_host: 10.1.2.34
      ip: 10.1.2.34
      access_ip: 10.1.2.34
      ansible_user: yc-user
  children:
    kube_control_plane:
      hosts:
        masterk8s:
    kube_node:
      hosts:
        worker1:
        worker2:
        worker3:
        worker4:
    etcd:
      hosts:
        masterk8s:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}




```

Добавим PRIVATE KEY на master чтобы ansible имел возможность подключаться к worker

```
cat  .ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
NhAAAAAwEAAQAAAYEAol2GT4lV1KpYtL+QFnJYUohVTK5FY4Jt/FkHiDWXhKufWL6Eulsm
e8ZEJghzdwn7ZSrrdZYIAFPYhc+6Att8p6T1ZRSJ02axqiynaJPEoBVZxeZp+LzlM43iRj
HhS5ChWuE+rAtAc+8TIYCl7BtZgW8Xy4VeO8Li2fEvGmYU20Mii8S6gwH1YDOfEG5Iyi6b
jnM4W49jvfBO/dK9loqvXeeLlP1/NVdiGURHNjzRn27FNAO51ln0JT67xPxJfwqQhDI1ty
pbDPPcfzaK6coAU93m3y4TTIMpbzV4uUB1da34vmipD4fNrLOPYDbhhlNbm/ukXwg4aM06
V7G/V4Gpgdwb67QIhJAQ1qgh8RJKw5AxohQQW1C0cvBYva1Qupt9FrPUPa+NrRkpH/2Lt9
jqsHNFmxfePBZlg+XJBkN2gFesL70UU+vGVFUVz2GWXV/ewudVZvYFPX2FANdMdLVPx0NX
HxfMdrwmB85KKJf6Zu13xq9bqui0Mw7ExwukDB6rAAAFiDJkYfoyZGH6AAAAB3NzaC1yc2
EAAAGBAKJdhk+JVdSqWLS/kBZyWFKIVUyuRWOCbfxZB4g1l4Srn1i+hLpbJnvGRCYIc3cJ
+2Uq63WWCABT2IXPugLbfKek9WUUidNmsaosp2iTxKAVWcXmafi85TON4kYx4U
...
```

Запуск playbook

```
ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v

Очень долгий playbook оказался.

PLAY RECAP **************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
masterk8s                  : ok=739  changed=146  unreachable=0    failed=0    skipped=1266 rescued=0    ignored=8
worker1                    : ok=512  changed=91   unreachable=0    failed=0    skipped=777  rescued=0    ignored=1
worker2                    : ok=512  changed=91   unreachable=0    failed=0    skipped=776  rescued=0    ignored=1
worker3                    : ok=512  changed=91   unreachable=0    failed=0    skipped=776  rescued=0    ignored=1
worker4                    : ok=512  changed=91   unreachable=0    failed=0    skipped=776  rescued=0    ignored=1

Friday 11 August 2023  13:58:30 +0000 (0:00:00.330)       0:32:34.652 *********
===============================================================================
download : Download_file | Download item ------------------------------------------------------------------------------------------------------------------------------------ 80.16s
container-engine/nerdctl : Download_file | Download item -------------------------------------------------------------------------------------------------------------------- 51.18s
container-engine/containerd : Download_file | Download item ----------------------------------------------------------------------------------------------------------------- 46.25s
container-engine/crictl : Download_file | Download item --------------------------------------------------------------------------------------------------------------------- 45.11s
container-engine/runc : Download_file | Download item ----------------------------------------------------------------------------------------------------------------------- 45.01s
network_plugin/calico : Wait for calico kubeconfig to be created ------------------------------------------------------------------------------------------------------------ 43.73s
download : Download_container | Download image if required ------------------------------------------------------------------------------------------------------------------ 38.87s
download : Download_file | Download item ------------------------------------------------------------------------------------------------------------------------------------ 35.50s
container-engine/crictl : Extract_file | Unpacking archive ------------------------------------------------------------------------------------------------------------------ 31.60s
container-engine/nerdctl : Extract_file | Unpacking archive ----------------------------------------------------------------------------------------------------------------- 31.42s
download : Download_container | Download image if required ------------------------------------------------------------------------------------------------------------------ 27.84s
download : Download_container | Download image if required ------------------------------------------------------------------------------------------------------------------ 27.41s
download : Download_file | Download item ------------------------------------------------------------------------------------------------------------------------------------ 27.20s
kubernetes/control-plane : Kubeadm | Initialize first master ---------------------------------------------------------------------------------------------------------------- 26.82s
container-engine/containerd : Download_file | Validate mirrors -------------------------------------------------------------------------------------------------------------- 24.32s
container-engine/runc : Download_file | Validate mirrors -------------------------------------------------------------------------------------------------------------------- 23.64s
container-engine/crictl : Download_file | Validate mirrors ------------------------------------------------------------------------------------------------------------------ 23.45s
container-engine/nerdctl : Download_file | Validate mirrors ----------------------------------------------------------------------------------------------------------------- 23.37s
kubernetes/kubeadm : Join to cluster ---------------------------------------------------------------------------------------------------------------------------------------- 22.59s
kubernetes/preinstall : Update package management cache (APT) --------------------------------------------------------------------------------------------------------------- 21.78s
```

Готово.Проверка.


```
exit
yc-user@masterk8s:~/kubespray$ kubectl get nodes
NAME        STATUS   ROLES           AGE   VERSION
masterk8s   Ready    control-plane   84m   v1.26.7
worker1     Ready    <none>          83m   v1.26.7
worker2     Ready    <none>          83m   v1.26.7
worker3     Ready    <none>          83m   v1.26.7
worker4     Ready    <none>          83m   v1.26.7

```
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
