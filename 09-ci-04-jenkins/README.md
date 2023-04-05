# Домашнее задание к занятию 10 «Jenkins»

## Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.
2. Установить Jenkins при помощи playbook.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.
```
srg@promitey:~/0904/infrastructure$ ansible-playbook site.yml -i inventory/cicd/hosts.yml
[WARNING]: Collection ansible.posix does not support Ansible version 2.14.3

PLAY [Preapre all hosts] ***********************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [jenkins-agent-01]
ok: [jenkins-master-01]

TASK [Create group] ****************************************************************************************************************************************************
changed: [jenkins-master-01]
changed: [jenkins-agent-01]

TASK [Create user] *****************************************************************************************************************************************************
changed: [jenkins-master-01]
changed: [jenkins-agent-01]

TASK [Install JDK] *****************************************************************************************************************************************************
changed: [jenkins-agent-01]
changed: [jenkins-master-01]

PLAY [Get Jenkins master installed] ************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [jenkins-master-01]

TASK [Get repo Jenkins] ************************************************************************************************************************************************
changed: [jenkins-master-01]

TASK [Add Jenkins key] *************************************************************************************************************************************************
changed: [jenkins-master-01]

TASK [Install epel-release] ********************************************************************************************************************************************
changed: [jenkins-master-01]

TASK [Install Jenkins and requirements] ********************************************************************************************************************************
changed: [jenkins-master-01]

TASK [Ensure jenkins agents are present in known_hosts file] ***********************************************************************************************************
# 158.160.17.138:22 SSH-2.0-OpenSSH_7.4
# 158.160.17.138:22 SSH-2.0-OpenSSH_7.4
# 158.160.17.138:22 SSH-2.0-OpenSSH_7.4
# 158.160.17.138:22 SSH-2.0-OpenSSH_7.4
# 158.160.17.138:22 SSH-2.0-OpenSSH_7.4
changed: [jenkins-master-01] => (item=jenkins-agent-01)
[WARNING]: Module remote_tmp /home/jenkins/.ansible/tmp did not exist and was created with a mode of 0700, this may cause issues when running as another user. To avoid
this, create the remote_tmp dir with the correct permissions manually

TASK [Start Jenkins] ***************************************************************************************************************************************************
changed: [jenkins-master-01]

PLAY [Prepare jenkins agent] *******************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [jenkins-agent-01]

TASK [Add master publickey into authorized_key] ************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Create agent_dir] ************************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Add docker repo] *************************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Install some required] *******************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Update pip] ******************************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Install Ansible] *************************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Reinstall Selinux] ***********************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Add local to PATH] ***********************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Create docker group] *********************************************************************************************************************************************
ok: [jenkins-agent-01]

TASK [Add jenkinsuser to dockergroup] **********************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Restart docker] **************************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Install agent.jar] ***********************************************************************************************************************************************
changed: [jenkins-agent-01]

PLAY RECAP *************************************************************************************************************************************************************
jenkins-agent-01           : ok=17   changed=14   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
jenkins-master-01          : ok=11   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

srg@promitey:~/0904/infrastructure$

```
## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

Были ошибки подключения к github. В агенте изменил файл known_hosts

```
su - jenkins
ssh-keyscan github.com >> ~/.ssh/known_hosts
```
Были ошибки в molecule "Unsupported parametrs".
```
Обновил python.

jenkins@promitey:~$ python3 -V
Python 3.10.6


```

```
jenkins@promitey:~$ ansible --version
ansible [core 2.14.4]
  config file = None
  configured module search path = ['/home/jenkins/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/jenkins/.local/lib/python3.10/site-packages/ansible
  ansible collection location = /home/jenkins/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/jenkins/.local/bin/ansible
  python version = 3.10.6 (main, Mar 10 2023, 10:55:28) [GCC 11.3.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True

```

Переустановил виртуальные машины мастера и агента.

<p>
Шаги сборки:
</p>

```
pip3 install "molecule==3.5.2" "molecule_docker"
#python pip install molecule==3.5.2 molecule_docker
molecule --version
#docker pull aragast/netology:latest
pwd
ls -l
#molecule init scenario --driver-name docker
molecule test -s centos
```

<details><summary>Logs</summary>
 
```
Started by user srg
Running as SYSTEM
Building remotely on agent2 (linux2) in workspace /opt/jenkins_agent/workspace/Freestyle
The recommended git tool is: NONE
using credential 7b188317-b12a-4e64-9c1f-933df2cedf29
 > git rev-parse --resolve-git-dir /opt/jenkins_agent/workspace/Freestyle/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url git@github.com:awertoss/vector-role.git # timeout=10
Fetching upstream changes from git@github.com:awertoss/vector-role.git
 > git --version # timeout=10
 > git --version # 'git version 2.34.1'
using GIT_SSH to set credentials 
Verifying host key using known hosts file
 > git fetch --tags --force --progress -- git@github.com:awertoss/vector-role.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision beff809904acf042c48489d055526fda0e2005fb (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f beff809904acf042c48489d055526fda0e2005fb # timeout=10
Commit message: "Create Jenkinsfile"
 > git rev-list --no-walk beff809904acf042c48489d055526fda0e2005fb # timeout=10
[Freestyle] $ /bin/sh -xe /tmp/jenkins1690886110135707391.sh
+ whoami
jenkins
+ ansible --version
ansible [core 2.14.4]
  config file = None
  configured module search path = ['/home/jenkins/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/jenkins/.local/lib/python3.10/site-packages/ansible
  ansible collection location = /home/jenkins/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.10.6 (main, Mar 10 2023, 10:55:28) [GCC 11.3.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True
+ pip3 install molecule==3.5.2 molecule_docker
Requirement already satisfied: molecule==3.5.2 in /usr/local/lib/python3.10/dist-packages (3.5.2)
Requirement already satisfied: molecule_docker in /usr/local/lib/python3.10/dist-packages (1.1.0)
Requirement already satisfied: cerberus!=1.3.3,!=1.3.4,>=1.3.1 in /usr/local/lib/python3.10/dist-packages (from molecule==3.5.2) (1.3.2)
Requirement already satisfied: pluggy<2.0,>=0.7.1 in /usr/local/lib/python3.10/dist-packages (from molecule==3.5.2) (1.0.0)
Requirement already satisfied: paramiko<3,>=2.5.0 in /usr/local/lib/python3.10/dist-packages (from molecule==3.5.2) (2.12.0)
Requirement already satisfied: selinux in /usr/lib/python3/dist-packages (from molecule==3.5.2) (3.3)
Requirement already satisfied: Jinja2>=2.11.3 in /usr/lib/python3/dist-packages (from molecule==3.5.2) (3.0.3)
Requirement already satisfied: subprocess-tee>=0.3.5 in /usr/local/lib/python3.10/dist-packages (from molecule==3.5.2) (0.4.1)
Requirement already satisfied: click<9,>=8.0 in /usr/local/lib/python3.10/dist-packages (from molecule==3.5.2) (8.1.3)
Requirement already satisfied: ansible-compat>=0.5.0 in /usr/local/lib/python3.10/dist-packages (from molecule==3.5.2) (3.0.1)
Requirement already satisfied: PyYAML<6,>=5.1 in /usr/lib/python3/dist-packages (from molecule==3.5.2) (5.4.1)
Requirement already satisfied: cookiecutter>=1.7.3 in /usr/local/lib/python3.10/dist-packages (from molecule==3.5.2) (2.1.1)
Requirement already satisfied: click-help-colors>=0.9 in /usr/local/lib/python3.10/dist-packages (from molecule==3.5.2) (0.9.1)
Requirement already satisfied: enrich>=1.2.5 in /usr/local/lib/python3.10/dist-packages (from molecule==3.5.2) (1.2.7)
Requirement already satisfied: packaging in /usr/local/lib/python3.10/dist-packages (from molecule==3.5.2) (23.0)
Requirement already satisfied: rich>=9.5.1 in /usr/lib/python3/dist-packages (from molecule==3.5.2) (11.2.0)
Requirement already satisfied: docker>=4.3.1 in /usr/local/lib/python3.10/dist-packages (from molecule_docker) (6.0.1)
Requirement already satisfied: requests in /usr/local/lib/python3.10/dist-packages (from molecule_docker) (2.28.2)
Requirement already satisfied: ansible-core>=2.12 in /home/jenkins/.local/lib/python3.10/site-packages (from ansible-compat>=0.5.0->molecule==3.5.2) (2.14.4)
Requirement already satisfied: jsonschema>=4.6.0 in /usr/local/lib/python3.10/dist-packages (from ansible-compat>=0.5.0->molecule==3.5.2) (4.17.3)
Requirement already satisfied: setuptools in /usr/lib/python3/dist-packages (from cerberus!=1.3.3,!=1.3.4,>=1.3.1->molecule==3.5.2) (59.6.0)
Requirement already satisfied: python-slugify>=4.0.0 in /usr/local/lib/python3.10/dist-packages (from cookiecutter>=1.7.3->molecule==3.5.2) (8.0.1)
Requirement already satisfied: binaryornot>=0.4.4 in /usr/local/lib/python3.10/dist-packages (from cookiecutter>=1.7.3->molecule==3.5.2) (0.4.4)
Requirement already satisfied: jinja2-time>=0.2.0 in /usr/local/lib/python3.10/dist-packages (from cookiecutter>=1.7.3->molecule==3.5.2) (0.2.0)
Requirement already satisfied: urllib3>=1.26.0 in /usr/lib/python3/dist-packages (from docker>=4.3.1->molecule_docker) (1.26.5)
Requirement already satisfied: websocket-client>=0.32.0 in /usr/local/lib/python3.10/dist-packages (from docker>=4.3.1->molecule_docker) (1.5.1)
Requirement already satisfied: bcrypt>=3.1.3 in /usr/lib/python3/dist-packages (from paramiko<3,>=2.5.0->molecule==3.5.2) (3.2.0)
Requirement already satisfied: pynacl>=1.0.1 in /usr/local/lib/python3.10/dist-packages (from paramiko<3,>=2.5.0->molecule==3.5.2) (1.5.0)
Requirement already satisfied: cryptography>=2.5 in /usr/lib/python3/dist-packages (from paramiko<3,>=2.5.0->molecule==3.5.2) (3.4.8)
Requirement already satisfied: six in /usr/lib/python3/dist-packages (from paramiko<3,>=2.5.0->molecule==3.5.2) (1.16.0)
Requirement already satisfied: charset-normalizer<4,>=2 in /usr/local/lib/python3.10/dist-packages (from requests->molecule_docker) (3.0.1)
Requirement already satisfied: idna<4,>=2.5 in /usr/lib/python3/dist-packages (from requests->molecule_docker) (3.3)
Requirement already satisfied: certifi>=2017.4.17 in /usr/lib/python3/dist-packages (from requests->molecule_docker) (2020.6.20)
Requirement already satisfied: colorama<0.5.0,>=0.4.0 in /usr/local/lib/python3.10/dist-packages (from rich>=9.5.1->molecule==3.5.2) (0.4.6)
Requirement already satisfied: pygments<3.0.0,>=2.6.0 in /usr/lib/python3/dist-packages (from rich>=9.5.1->molecule==3.5.2) (2.11.2)
Requirement already satisfied: commonmark<0.10.0,>=0.9.0 in /usr/lib/python3/dist-packages (from rich>=9.5.1->molecule==3.5.2) (0.9.1)
Requirement already satisfied: resolvelib<0.9.0,>=0.5.3 in /usr/local/lib/python3.10/dist-packages (from ansible-core>=2.12->ansible-compat>=0.5.0->molecule==3.5.2) (0.8.1)
Requirement already satisfied: chardet>=3.0.2 in /usr/local/lib/python3.10/dist-packages (from binaryornot>=0.4.4->cookiecutter>=1.7.3->molecule==3.5.2) (5.1.0)
Requirement already satisfied: arrow in /usr/local/lib/python3.10/dist-packages (from jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule==3.5.2) (1.2.3)
Requirement already satisfied: attrs>=17.4.0 in /usr/lib/python3/dist-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule==3.5.2) (21.2.0)
Requirement already satisfied: pyrsistent!=0.17.0,!=0.17.1,!=0.17.2,>=0.14.0 in /usr/lib/python3/dist-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule==3.5.2) (0.18.1)
Requirement already satisfied: cffi>=1.4.1 in /usr/local/lib/python3.10/dist-packages (from pynacl>=1.0.1->paramiko<3,>=2.5.0->molecule==3.5.2) (1.15.1)
Requirement already satisfied: text-unidecode>=1.3 in /usr/local/lib/python3.10/dist-packages (from python-slugify>=4.0.0->cookiecutter>=1.7.3->molecule==3.5.2) (1.3)
Requirement already satisfied: pycparser in /usr/local/lib/python3.10/dist-packages (from cffi>=1.4.1->pynacl>=1.0.1->paramiko<3,>=2.5.0->molecule==3.5.2) (2.21)
Requirement already satisfied: python-dateutil>=2.7.0 in /usr/local/lib/python3.10/dist-packages (from arrow->jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule==3.5.2) (2.8.2)
+ molecule --version
molecule 3.5.2 using python 3.10 
    ansible:2.14.4
    delegated:3.5.2 from molecule
    docker:1.1.0 from molecule_docker requiring collections: community.docker>=1.9.1
+ molecule test -s centos
INFO     centos scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/jenkins/.cache/ansible-compat/d13231/modules:/home/jenkins/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/jenkins/.cache/ansible-compat/d13231/collections:/home/jenkins/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/jenkins/.cache/ansible-compat/d13231/roles:/home/jenkins/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running centos > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running centos > lint
INFO     Lint is disabled.
INFO     Running centos > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
failed: [localhost] (item=instance) => {"ansible_job_id": "107679263264.3311", "ansible_loop_var": "item", "attempts": 1, "changed": false, "finished": 1, "item": {"ansible_job_id": "107679263264.3311", "ansible_loop_var": "item", "changed": true, "failed": 0, "finished": 0, "item": {"image": "docker.io/pycontribs/centos:7", "name": "instance", "pre_build_image": true}, "results_file": "/home/jenkins/.ansible_async/107679263264.3311", "started": 1}, "msg": "could not find job", "results_file": "/home/jenkins/.ansible_async/107679263264.3311", "started": 1, "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/home/jenkins/.cache/molecule/Freestyle/centos/inventory', '--skip-tags', 'molecule-notest,notest', '/usr/local/lib/python3.10/dist-packages/molecule_docker/playbooks/destroy.yml']
WARNING  An error occurred during the test sequence action: 'destroy'. Cleaning up.
INFO     Running centos > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
failed: [localhost] (item=instance) => {"ansible_job_id": "620509806375.3371", "ansible_loop_var": "item", "attempts": 1, "changed": false, "finished": 1, "item": {"ansible_job_id": "620509806375.3371", "ansible_loop_var": "item", "changed": true, "failed": 0, "finished": 0, "item": {"image": "docker.io/pycontribs/centos:7", "name": "instance", "pre_build_image": true}, "results_file": "/home/jenkins/.ansible_async/620509806375.3371", "started": 1}, "msg": "could not find job", "results_file": "/home/jenkins/.ansible_async/620509806375.3371", "started": 1, "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/home/jenkins/.cache/molecule/Freestyle/centos/inventory', '--skip-tags', 'molecule-notest,notest', '/usr/local/lib/python3.10/dist-packages/molecule_docker/playbooks/destroy.yml']
Build step 'Execute shell' marked build as failure
Finished: FAILURE

```
 
 </details>
 
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
 <p>
  Cкрипт:
  </p>
 
 ```
 pipeline {
    agent {
        label 'linux'
    }
    stages {
        stage('Git') {
            steps{
                git branch: 'main', credentialsId: '7b188317-b12a-4e64-9c1f-933df2cedf29', url: 'git@github.com:awertoss/vector-role.git'
            }
        }
        stage('Molecule install') {
            steps{
                sh 'pip3 install molecule==3.5.2'
                sh 'pip3 install "ansible-lint<6.0.0"'
                sh 'pip3 install molecule_docker'
            }
        }
        stage('Molecule test'){
            steps{
                sh 'molecule test -s centos'
                cleanWs()
            }
        }
    }
}
 ```
 <p>
  Тест завершился с ошибкой.
  </p>
<details>
 
 ```
 Started by user srg
[Pipeline] Start of Pipeline
[Pipeline] node
Running on agent in /opt/jenkins_agent/workspace/Declarative Pipeline
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Git)
[Pipeline] git
The recommended git tool is: NONE
using credential 7b188317-b12a-4e64-9c1f-933df2cedf29
Fetching changes from the remote Git repository
 > git rev-parse --resolve-git-dir /opt/jenkins_agent/workspace/Declarative Pipeline/.git # timeout=10
 > git config remote.origin.url git@github.com:awertoss/vector-role.git # timeout=10
Fetching upstream changes from git@github.com:awertoss/vector-role.git
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
using GIT_SSH to set credentials 
[INFO] Currently running in a labeled security context
[INFO] Currently SELinux is 'enforcing' on the host
 > /usr/bin/chcon --type=ssh_home_t /opt/jenkins_agent/workspace/Declarative Pipeline@tmp/jenkins-gitclient-ssh16627504821266965998.key
Verifying host key using known hosts file
 > git fetch --tags --progress git@github.com:awertoss/vector-role.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Checking out Revision beff809904acf042c48489d055526fda0e2005fb (refs/remotes/origin/main)
Commit message: "Create Jenkinsfile"
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f beff809904acf042c48489d055526fda0e2005fb # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git branch -D main # timeout=10
 > git checkout -b main beff809904acf042c48489d055526fda0e2005fb # timeout=10
 > git rev-list --no-walk beff809904acf042c48489d055526fda0e2005fb # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Molecule install)
[Pipeline] sh
+ pip3 install molecule==3.5.2
Requirement already satisfied: molecule==3.5.2 in /usr/local/lib/python3.9/site-packages (3.5.2)
Requirement already satisfied: enrich>=1.2.5 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (1.2.7)
Requirement already satisfied: rich>=9.5.1 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (13.3.3)
Requirement already satisfied: click<9,>=8.0 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (8.1.3)
Requirement already satisfied: cerberus!=1.3.3,!=1.3.4,>=1.3.1 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (1.3.2)
Requirement already satisfied: ansible-compat>=0.5.0 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (3.0.1)
Requirement already satisfied: click-help-colors>=0.9 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (0.9.1)
Requirement already satisfied: packaging in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (23.0)
Requirement already satisfied: paramiko<3,>=2.5.0 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (2.12.0)
Requirement already satisfied: subprocess-tee>=0.3.5 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (0.4.1)
Requirement already satisfied: cookiecutter>=1.7.3 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (2.1.1)
Requirement already satisfied: PyYAML<6,>=5.1 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (5.4.1)
Requirement already satisfied: selinux in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (0.3.0)
Requirement already satisfied: Jinja2>=2.11.3 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (3.1.2)
Requirement already satisfied: pluggy<2.0,>=0.7.1 in /usr/local/lib/python3.9/site-packages (from molecule==3.5.2) (1.0.0)
Requirement already satisfied: jsonschema>=4.6.0 in /usr/local/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule==3.5.2) (4.17.3)
Requirement already satisfied: ansible-core>=2.12 in /usr/local/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule==3.5.2) (2.14.4)
Requirement already satisfied: setuptools in /usr/local/lib/python3.9/site-packages (from cerberus!=1.3.3,!=1.3.4,>=1.3.1->molecule==3.5.2) (58.1.0)
Requirement already satisfied: binaryornot>=0.4.4 in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.5.2) (0.4.4)
Requirement already satisfied: jinja2-time>=0.2.0 in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.5.2) (0.2.0)
Requirement already satisfied: requests>=2.23.0 in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.5.2) (2.28.2)
Requirement already satisfied: python-slugify>=4.0.0 in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.5.2) (8.0.1)
Requirement already satisfied: MarkupSafe>=2.0 in /usr/local/lib/python3.9/site-packages (from Jinja2>=2.11.3->molecule==3.5.2) (2.1.2)
Requirement already satisfied: cryptography>=2.5 in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.5.2) (40.0.1)
Requirement already satisfied: bcrypt>=3.1.3 in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.5.2) (4.0.1)
Requirement already satisfied: six in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.5.2) (1.16.0)
Requirement already satisfied: pynacl>=1.0.1 in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.5.2) (1.5.0)
Requirement already satisfied: markdown-it-py<3.0.0,>=2.2.0 in /usr/local/lib/python3.9/site-packages (from rich>=9.5.1->molecule==3.5.2) (2.2.0)
Requirement already satisfied: pygments<3.0.0,>=2.13.0 in /usr/local/lib/python3.9/site-packages (from rich>=9.5.1->molecule==3.5.2) (2.14.0)
Requirement already satisfied: distro>=1.3.0 in /usr/local/lib/python3.9/site-packages (from selinux->molecule==3.5.2) (1.8.0)
Requirement already satisfied: resolvelib<0.9.0,>=0.5.3 in /usr/local/lib/python3.9/site-packages (from ansible-core>=2.12->ansible-compat>=0.5.0->molecule==3.5.2) (0.8.1)
Requirement already satisfied: chardet>=3.0.2 in /usr/local/lib/python3.9/site-packages (from binaryornot>=0.4.4->cookiecutter>=1.7.3->molecule==3.5.2) (5.1.0)
Requirement already satisfied: cffi>=1.12 in /usr/local/lib/python3.9/site-packages (from cryptography>=2.5->paramiko<3,>=2.5.0->molecule==3.5.2) (1.15.1)
Requirement already satisfied: arrow in /usr/local/lib/python3.9/site-packages (from jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule==3.5.2) (1.2.3)
Requirement already satisfied: attrs>=17.4.0 in /usr/local/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule==3.5.2) (22.2.0)
Requirement already satisfied: pyrsistent!=0.17.0,!=0.17.1,!=0.17.2,>=0.14.0 in /usr/local/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule==3.5.2) (0.19.3)
Requirement already satisfied: mdurl~=0.1 in /usr/local/lib/python3.9/site-packages (from markdown-it-py<3.0.0,>=2.2.0->rich>=9.5.1->molecule==3.5.2) (0.1.2)
Requirement already satisfied: text-unidecode>=1.3 in /usr/local/lib/python3.9/site-packages (from python-slugify>=4.0.0->cookiecutter>=1.7.3->molecule==3.5.2) (1.3)
Requirement already satisfied: charset-normalizer<4,>=2 in /usr/local/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.5.2) (3.1.0)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/local/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.5.2) (1.26.15)
Requirement already satisfied: idna<4,>=2.5 in /usr/local/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.5.2) (3.4)
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.5.2) (2022.12.7)
Requirement already satisfied: pycparser in /usr/local/lib/python3.9/site-packages (from cffi>=1.12->cryptography>=2.5->paramiko<3,>=2.5.0->molecule==3.5.2) (2.21)
Requirement already satisfied: python-dateutil>=2.7.0 in /usr/local/lib/python3.9/site-packages (from arrow->jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule==3.5.2) (2.8.2)
[Pipeline] sh
+ pip3 install 'ansible-lint<6.0.0'
Requirement already satisfied: ansible-lint<6.0.0 in /usr/local/lib/python3.9/site-packages (5.4.0)
Requirement already satisfied: ruamel.yaml<1,>=0.15.37 in /usr/local/lib/python3.9/site-packages (from ansible-lint<6.0.0) (0.17.21)
Requirement already satisfied: tenacity in /usr/local/lib/python3.9/site-packages (from ansible-lint<6.0.0) (8.2.2)
Requirement already satisfied: packaging in /usr/local/lib/python3.9/site-packages (from ansible-lint<6.0.0) (23.0)
Requirement already satisfied: rich>=9.5.1 in /usr/local/lib/python3.9/site-packages (from ansible-lint<6.0.0) (13.3.3)
Requirement already satisfied: enrich>=1.2.6 in /usr/local/lib/python3.9/site-packages (from ansible-lint<6.0.0) (1.2.7)
Requirement already satisfied: wcmatch>=7.0 in /usr/local/lib/python3.9/site-packages (from ansible-lint<6.0.0) (8.4.1)
Requirement already satisfied: pyyaml in /usr/local/lib/python3.9/site-packages (from ansible-lint<6.0.0) (5.4.1)
Requirement already satisfied: markdown-it-py<3.0.0,>=2.2.0 in /usr/local/lib/python3.9/site-packages (from rich>=9.5.1->ansible-lint<6.0.0) (2.2.0)
Requirement already satisfied: pygments<3.0.0,>=2.13.0 in /usr/local/lib/python3.9/site-packages (from rich>=9.5.1->ansible-lint<6.0.0) (2.14.0)
Requirement already satisfied: ruamel.yaml.clib>=0.2.6 in /usr/local/lib/python3.9/site-packages (from ruamel.yaml<1,>=0.15.37->ansible-lint<6.0.0) (0.2.7)
Requirement already satisfied: bracex>=2.1.1 in /usr/local/lib/python3.9/site-packages (from wcmatch>=7.0->ansible-lint<6.0.0) (2.3.post1)
Requirement already satisfied: mdurl~=0.1 in /usr/local/lib/python3.9/site-packages (from markdown-it-py<3.0.0,>=2.2.0->rich>=9.5.1->ansible-lint<6.0.0) (0.1.2)
[Pipeline] sh
+ pip3 install molecule_docker
Requirement already satisfied: molecule_docker in /usr/local/lib/python3.9/site-packages (1.1.0)
Requirement already satisfied: molecule>=3.4.0 in /usr/local/lib/python3.9/site-packages (from molecule_docker) (3.5.2)
Requirement already satisfied: selinux in /usr/local/lib/python3.9/site-packages (from molecule_docker) (0.3.0)
Requirement already satisfied: requests in /usr/local/lib/python3.9/site-packages (from molecule_docker) (2.28.2)
Requirement already satisfied: docker>=4.3.1 in /usr/local/lib/python3.9/site-packages (from molecule_docker) (6.0.1)
Requirement already satisfied: ansible-compat>=0.5.0 in /usr/local/lib/python3.9/site-packages (from molecule_docker) (3.0.1)
Requirement already satisfied: ansible-core>=2.12 in /usr/local/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_docker) (2.14.4)
Requirement already satisfied: packaging in /usr/local/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_docker) (23.0)
Requirement already satisfied: subprocess-tee>=0.4.1 in /usr/local/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_docker) (0.4.1)
Requirement already satisfied: PyYAML in /usr/local/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_docker) (5.4.1)
Requirement already satisfied: jsonschema>=4.6.0 in /usr/local/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_docker) (4.17.3)
Requirement already satisfied: urllib3>=1.26.0 in /usr/local/lib/python3.9/site-packages (from docker>=4.3.1->molecule_docker) (1.26.15)
Requirement already satisfied: websocket-client>=0.32.0 in /usr/local/lib/python3.9/site-packages (from docker>=4.3.1->molecule_docker) (1.5.1)
Requirement already satisfied: click<9,>=8.0 in /usr/local/lib/python3.9/site-packages (from molecule>=3.4.0->molecule_docker) (8.1.3)
Requirement already satisfied: Jinja2>=2.11.3 in /usr/local/lib/python3.9/site-packages (from molecule>=3.4.0->molecule_docker) (3.1.2)
Requirement already satisfied: rich>=9.5.1 in /usr/local/lib/python3.9/site-packages (from molecule>=3.4.0->molecule_docker) (13.3.3)
Requirement already satisfied: cerberus!=1.3.3,!=1.3.4,>=1.3.1 in /usr/local/lib/python3.9/site-packages (from molecule>=3.4.0->molecule_docker) (1.3.2)
Requirement already satisfied: pluggy<2.0,>=0.7.1 in /usr/local/lib/python3.9/site-packages (from molecule>=3.4.0->molecule_docker) (1.0.0)
Requirement already satisfied: click-help-colors>=0.9 in /usr/local/lib/python3.9/site-packages (from molecule>=3.4.0->molecule_docker) (0.9.1)
Requirement already satisfied: cookiecutter>=1.7.3 in /usr/local/lib/python3.9/site-packages (from molecule>=3.4.0->molecule_docker) (2.1.1)
Requirement already satisfied: paramiko<3,>=2.5.0 in /usr/local/lib/python3.9/site-packages (from molecule>=3.4.0->molecule_docker) (2.12.0)
Requirement already satisfied: enrich>=1.2.5 in /usr/local/lib/python3.9/site-packages (from molecule>=3.4.0->molecule_docker) (1.2.7)
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python3.9/site-packages (from requests->molecule_docker) (2022.12.7)
Requirement already satisfied: idna<4,>=2.5 in /usr/local/lib/python3.9/site-packages (from requests->molecule_docker) (3.4)
Requirement already satisfied: charset-normalizer<4,>=2 in /usr/local/lib/python3.9/site-packages (from requests->molecule_docker) (3.1.0)
Requirement already satisfied: distro>=1.3.0 in /usr/local/lib/python3.9/site-packages (from selinux->molecule_docker) (1.8.0)
Requirement already satisfied: resolvelib<0.9.0,>=0.5.3 in /usr/local/lib/python3.9/site-packages (from ansible-core>=2.12->ansible-compat>=0.5.0->molecule_docker) (0.8.1)
Requirement already satisfied: cryptography in /usr/local/lib/python3.9/site-packages (from ansible-core>=2.12->ansible-compat>=0.5.0->molecule_docker) (40.0.1)
Requirement already satisfied: setuptools in /usr/local/lib/python3.9/site-packages (from cerberus!=1.3.3,!=1.3.4,>=1.3.1->molecule>=3.4.0->molecule_docker) (58.1.0)
Requirement already satisfied: binaryornot>=0.4.4 in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule>=3.4.0->molecule_docker) (0.4.4)
Requirement already satisfied: python-slugify>=4.0.0 in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule>=3.4.0->molecule_docker) (8.0.1)
Requirement already satisfied: jinja2-time>=0.2.0 in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule>=3.4.0->molecule_docker) (0.2.0)
Requirement already satisfied: MarkupSafe>=2.0 in /usr/local/lib/python3.9/site-packages (from Jinja2>=2.11.3->molecule>=3.4.0->molecule_docker) (2.1.2)
Requirement already satisfied: attrs>=17.4.0 in /usr/local/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule_docker) (22.2.0)
Requirement already satisfied: pyrsistent!=0.17.0,!=0.17.1,!=0.17.2,>=0.14.0 in /usr/local/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule_docker) (0.19.3)
Requirement already satisfied: bcrypt>=3.1.3 in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule>=3.4.0->molecule_docker) (4.0.1)
Requirement already satisfied: pynacl>=1.0.1 in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule>=3.4.0->molecule_docker) (1.5.0)
Requirement already satisfied: six in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule>=3.4.0->molecule_docker) (1.16.0)
Requirement already satisfied: pygments<3.0.0,>=2.13.0 in /usr/local/lib/python3.9/site-packages (from rich>=9.5.1->molecule>=3.4.0->molecule_docker) (2.14.0)
Requirement already satisfied: markdown-it-py<3.0.0,>=2.2.0 in /usr/local/lib/python3.9/site-packages (from rich>=9.5.1->molecule>=3.4.0->molecule_docker) (2.2.0)
Requirement already satisfied: chardet>=3.0.2 in /usr/local/lib/python3.9/site-packages (from binaryornot>=0.4.4->cookiecutter>=1.7.3->molecule>=3.4.0->molecule_docker) (5.1.0)
Requirement already satisfied: cffi>=1.12 in /usr/local/lib/python3.9/site-packages (from cryptography->ansible-core>=2.12->ansible-compat>=0.5.0->molecule_docker) (1.15.1)
Requirement already satisfied: arrow in /usr/local/lib/python3.9/site-packages (from jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule>=3.4.0->molecule_docker) (1.2.3)
Requirement already satisfied: mdurl~=0.1 in /usr/local/lib/python3.9/site-packages (from markdown-it-py<3.0.0,>=2.2.0->rich>=9.5.1->molecule>=3.4.0->molecule_docker) (0.1.2)
Requirement already satisfied: text-unidecode>=1.3 in /usr/local/lib/python3.9/site-packages (from python-slugify>=4.0.0->cookiecutter>=1.7.3->molecule>=3.4.0->molecule_docker) (1.3)
Requirement already satisfied: pycparser in /usr/local/lib/python3.9/site-packages (from cffi>=1.12->cryptography->ansible-core>=2.12->ansible-compat>=0.5.0->molecule_docker) (2.21)
Requirement already satisfied: python-dateutil>=2.7.0 in /usr/local/lib/python3.9/site-packages (from arrow->jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule>=3.4.0->molecule_docker) (2.8.2)
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Molecule test)
[Pipeline] sh
+ molecule test -s centos
INFO     centos scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/jenkins/.cache/ansible-compat/b2b225/modules:/home/jenkins/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/jenkins/.cache/ansible-compat/b2b225/collections:/home/jenkins/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/jenkins/.cache/ansible-compat/b2b225/roles:/home/jenkins/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running centos > dependency
INFO     Running from /opt/jenkins_agent/workspace/Declarative Pipeline : ansible-galaxy collection install -vvv community.docker:>=1.9.1
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running centos > lint
INFO     Lint is disabled.
INFO     Running centos > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos > destroy
INFO     Sanity checks: 'docker'
Traceback (most recent call last):
  File "/usr/local/lib/python3.9/site-packages/urllib3/connectionpool.py", line 703, in urlopen
    httplib_response = self._make_request(
  File "/usr/local/lib/python3.9/site-packages/urllib3/connectionpool.py", line 398, in _make_request
    conn.request(method, url, **httplib_request_kw)
  File "/usr/local/lib/python3.9/http/client.py", line 1285, in request
    self._send_request(method, url, body, headers, encode_chunked)
  File "/usr/local/lib/python3.9/http/client.py", line 1331, in _send_request
    self.endheaders(body, encode_chunked=encode_chunked)
  File "/usr/local/lib/python3.9/http/client.py", line 1280, in endheaders
    self._send_output(message_body, encode_chunked=encode_chunked)
  File "/usr/local/lib/python3.9/http/client.py", line 1040, in _send_output
    self.send(msg)
  File "/usr/local/lib/python3.9/http/client.py", line 980, in send
    self.connect()
  File "/usr/local/lib/python3.9/site-packages/docker/transport/unixconn.py", line 30, in connect
    sock.connect(self.unix_socket)
FileNotFoundError: [Errno 2] No such file or directory

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/usr/local/lib/python3.9/site-packages/requests/adapters.py", line 489, in send
    resp = conn.urlopen(
  File "/usr/local/lib/python3.9/site-packages/urllib3/connectionpool.py", line 787, in urlopen
    retries = retries.increment(
  File "/usr/local/lib/python3.9/site-packages/urllib3/util/retry.py", line 550, in increment
    raise six.reraise(type(error), error, _stacktrace)
  File "/usr/local/lib/python3.9/site-packages/urllib3/packages/six.py", line 769, in reraise
    raise value.with_traceback(tb)
  File "/usr/local/lib/python3.9/site-packages/urllib3/connectionpool.py", line 703, in urlopen
    httplib_response = self._make_request(
  File "/usr/local/lib/python3.9/site-packages/urllib3/connectionpool.py", line 398, in _make_request
    conn.request(method, url, **httplib_request_kw)
  File "/usr/local/lib/python3.9/http/client.py", line 1285, in request
    self._send_request(method, url, body, headers, encode_chunked)
  File "/usr/local/lib/python3.9/http/client.py", line 1331, in _send_request
    self.endheaders(body, encode_chunked=encode_chunked)
  File "/usr/local/lib/python3.9/http/client.py", line 1280, in endheaders
    self._send_output(message_body, encode_chunked=encode_chunked)
  File "/usr/local/lib/python3.9/http/client.py", line 1040, in _send_output
    self.send(msg)
  File "/usr/local/lib/python3.9/http/client.py", line 980, in send
    self.connect()
  File "/usr/local/lib/python3.9/site-packages/docker/transport/unixconn.py", line 30, in connect
    sock.connect(self.unix_socket)
urllib3.exceptions.ProtocolError: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/usr/local/lib/python3.9/site-packages/docker/api/client.py", line 214, in _retrieve_server_version
    return self.version(api_version=False)["ApiVersion"]
  File "/usr/local/lib/python3.9/site-packages/docker/api/daemon.py", line 181, in version
    return self._result(self._get(url), json=True)
  File "/usr/local/lib/python3.9/site-packages/docker/utils/decorators.py", line 46, in inner
    return f(self, *args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/docker/api/client.py", line 237, in _get
    return self.get(url, **self._set_request_timeout(kwargs))
  File "/usr/local/lib/python3.9/site-packages/requests/sessions.py", line 600, in get
    return self.request("GET", url, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/requests/sessions.py", line 587, in request
    resp = self.send(prep, **send_kwargs)
  File "/usr/local/lib/python3.9/site-packages/requests/sessions.py", line 701, in send
    r = adapter.send(request, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/requests/adapters.py", line 547, in send
    raise ConnectionError(err, request=request)
requests.exceptions.ConnectionError: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/usr/local/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/usr/local/lib/python3.9/site-packages/click/core.py", line 1130, in __call__
    return self.main(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/click/core.py", line 1055, in main
    rv = self.invoke(ctx)
  File "/usr/local/lib/python3.9/site-packages/click/core.py", line 1657, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/usr/local/lib/python3.9/site-packages/click/core.py", line 1404, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/usr/local/lib/python3.9/site-packages/click/core.py", line 760, in invoke
    return __callback(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/click/decorators.py", line 26, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/molecule/command/test.py", line 159, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/usr/local/lib/python3.9/site-packages/molecule/command/base.py", line 118, in execute_cmdline_scenarios
    execute_scenario(scenario)
  File "/usr/local/lib/python3.9/site-packages/molecule/command/base.py", line 160, in execute_scenario
    execute_subcommand(scenario.config, action)
  File "/usr/local/lib/python3.9/site-packages/molecule/command/base.py", line 149, in execute_subcommand
    return command(config).execute()
  File "/usr/local/lib/python3.9/site-packages/molecule/logger.py", line 188, in wrapper
    rt = func(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/molecule/command/destroy.py", line 107, in execute
    self._config.provisioner.destroy()
  File "/usr/local/lib/python3.9/site-packages/molecule/provisioner/ansible.py", line 705, in destroy
    pb.execute()
  File "/usr/local/lib/python3.9/site-packages/molecule/provisioner/ansible_playbook.py", line 110, in execute
    self._config.driver.sanity_checks()
  File "/usr/local/lib/python3.9/site-packages/molecule_docker/driver.py", line 236, in sanity_checks
    docker_client = docker.from_env()
  File "/usr/local/lib/python3.9/site-packages/docker/client.py", line 96, in from_env
    return cls(
  File "/usr/local/lib/python3.9/site-packages/docker/client.py", line 45, in __init__
    self.api = APIClient(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/docker/api/client.py", line 197, in __init__
    self._version = self._retrieve_server_version()
  File "/usr/local/lib/python3.9/site-packages/docker/api/client.py", line 221, in _retrieve_server_version
    raise DockerException(
docker.errors.DockerException: Error while fetching server API version: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
ERROR: script returned exit code 1
Finished: FAILURE
 ```
 </details>
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.<
<p>
[https://github.com/awertoss/vector-role/blob/main/Jenkinsfile]
</p>
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
                <p>
                 Тест тоже завершился с ошибкой.
                 </p>
                 <p align="center">
  <img width="1200" src="multibranch.jpg">
</p>
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
                 <p>
                 [https://github.com/awertoss/devops-netology/blob/main/09-ci-04-jenkins/pipeline/Jenkinsfile]
                 </p>
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
 
 ```
      node("linux"){
    stage("Git checkout"){
        git credentialsId: '5ac0095d-0185-431b-94da-09a0ad9b0e2c', url: 'git@github.com:aragastmatb/example-playbook.git'
    }
    stage("Show prod_run"){
        echo prod_run
    }
    stage("Run playbook"){
        if (prod_run == 'True'){
            echo " sh 'ansible-playbook site.yml -i inventory/prod.yml' "
        }
        else{
            echo " sh 'ansible-playbook site.yml -i inventory/prod.yml --diff --check' "
        }
    }
}
```
                 
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
<p align="center">
  <img width="1200" src="prod_run.jpg">
</p>
 <p align="center">
  <img width="1200" src="check.jpg">
</p>
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.
<p>
[https://github.com/awertoss/devops-netology/blob/main/09-ci-04-jenkins/ScriptedJenkinsfile]
</p>
<p>
 [https://github.com/awertoss/devops-netology/blob/main/09-ci-04-jenkins/Jenkinsfile]   
</p>
                 
## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, завершившиеся хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением и названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline так, чтобы он мог сначала запустить через Yandex Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Мы должны при нажатии кнопки получить готовую к использованию систему.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
