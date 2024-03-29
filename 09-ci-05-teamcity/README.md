# Домашнее задание к занятию 11 «Teamcity»

## Подготовка к выполнению

1. В Yandex Cloud создайте новый инстанс (4CPU4RAM) на основе образа `jetbrains/teamcity-server`.
2. Дождитесь запуска teamcity, выполните первоначальную настройку.
3. Создайте ещё один инстанс (2CPU4RAM) на основе образа `jetbrains/teamcity-agent`. Пропишите к нему переменную окружения `SERVER_URL: "http://<teamcity_url>:8111"`.
4. Авторизуйте агент.
5. Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity).
6. Создайте VM (2CPU4RAM) и запустите [playbook](./infrastructure).
```
root@promitey:/home/srg/0905/infrastructure# ansible-playbook site.yml -i inventory/cicd/hosts.yml

PLAY [Get Nexus installed] ******************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************
The authenticity of host '158.160.3.251 (158.160.3.251)' can't be established.
ED25519 key fingerprint is SHA256:UR0d5261UQ0oYVmisLI+iXCYEWQ67sD+hhTkNzXRljA.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [nexus-01]

TASK [Create Nexus group] *******************************************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus user] ********************************************************************************************************************************************
changed: [nexus-01]

TASK [Install JDK] **************************************************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus directories] *************************************************************************************************************************************
changed: [nexus-01] => (item=/home/nexus/log)
changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3)
changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3/etc)
changed: [nexus-01] => (item=/home/nexus/pkg)
changed: [nexus-01] => (item=/home/nexus/tmp)

TASK [Download Nexus] ***********************************************************************************************************************************************
[WARNING]: Module remote_tmp /home/nexus/.ansible/tmp did not exist and was created with a mode of 0700, this may cause issues when running as another user. To
avoid this, create the remote_tmp dir with the correct permissions manually
changed: [nexus-01]

TASK [Unpack Nexus] *************************************************************************************************************************************************
changed: [nexus-01]

TASK [Link to Nexus Directory] **************************************************************************************************************************************
changed: [nexus-01]

TASK [Add NEXUS_HOME for Nexus user] ********************************************************************************************************************************
changed: [nexus-01]

TASK [Add run_as_user to Nexus.rc] **********************************************************************************************************************************
changed: [nexus-01]

TASK [Raise nofile limit for Nexus user] ****************************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus service for SystemD] *****************************************************************************************************************************
changed: [nexus-01]

TASK [Ensure Nexus service is enabled for SystemD] ******************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus vmoptions] ***************************************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus properties] **************************************************************************************************************************************
changed: [nexus-01]

TASK [Lower Nexus disk space threshold] *****************************************************************************************************************************
skipping: [nexus-01]

TASK [Start Nexus service if enabled] *******************************************************************************************************************************
changed: [nexus-01]

TASK [Ensure Nexus service is restarted] ****************************************************************************************************************************
skipping: [nexus-01]

TASK [Wait for Nexus port if started] *******************************************************************************************************************************
ok: [nexus-01]

PLAY RECAP **********************************************************************************************************************************************************
nexus-01                   : ok=17   changed=15   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0


```

## Основная часть

1. Создайте новый проект в teamcity на основе fork.
2. Сделайте autodetect конфигурации.
3. Сохраните необходимые шаги, запустите первую сборку master.
<p align="center">
  <img width="1200" src="teamcity-1.jpg">
</p>
4. Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`.
<p align="center">
  <img width="1200" src="teamcity-2.jpg">
</p>
5. Для deploy будет необходимо загрузить [settings.xml](./teamcity/settings.xml) в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus.
<p align="center">
  <img width="1200" src="teamcity-3.jpg">
</p>
6. В pom.xml необходимо поменять ссылки на репозиторий и nexus.
<p>
[https://github.com/awertoss/example-teamcity/blob/master/pom.xml]
</p>
7. Запустите сборку по master, убедитесь, что всё прошло успешно и артефакт появился в nexus.
<p align="center">
  <img width="1200" src="nexus-1.jpg">
</p>
8. Мигрируйте `build configuration` в репозиторий.
<p align="center">
  <img width="1200" src="teamcity-4.jpg">
</p>
9. Создайте отдельную ветку `feature/add_reply` в репозитории.</br>
10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`.

```
Итоговый файл:
package plaindoll;

public class Welcomer{
	public String sayWelcome() {
		return "Welcome home, good hunter. What is it your desire?";
	}
	public String sayFarewell() {
		return "Farewell, good hunter. May you find your worth in waking world.";
	}
	public String sayNeedGold(){
		return "Not enough gold";
	}
	public String saySome(){
		return "something in the way";
	}

        public String sayHunter(){
                return "Return of the hunter";
        }
}
```

```
package plaindoll;

public class HelloPlayer{
	public static void main(String[] args) {
		Welcomer welcomer = new Welcomer();
		System.out.println(welcomer.sayWelcome());
		System.out.println(welcomer.sayFarewell());
		System.out.println(welcomer.sayHunter());
	}
}
```

11. Дополните тест для нового метода на поиск слова `hunter` в новой реплике.

```
Создал новый файл WelcomerTest.java


package plaindoll;

import static org.hamcrest.CoreMatchers.containsString;
import static org.junit.Assert.*;

import org.junit.Test;

public class WelcomerTest {

        private Welcomer welcomer = new Welcomer();

        @Test
        public void welcomerSaysWelcome() {
                assertThat(welcomer.sayWelcome(), containsString("Welcome"));
        }
        @Test
        public void welcomerSaysFarewell() {
                assertThat(welcomer.sayFarewell(), containsString("Farewell"));
        }
        @Test
        public void welcomerSaysHunter() {
                assertThat(welcomer.sayWelcome(), containsString("hunter"));
                assertThat(welcomer.sayFarewell(), containsString("hunter"));
                assertThat(welcomer.sayHunter(), containsString("hunter"));
        }
        @Test
        public void welcomerSaysSilver(){
                assertThat(welcomer.sayNeedGold(), containsString("gold"));
        }
        @Test
        public void welcomerSaysSomething(){
                assertThat(welcomer.saySome(), containsString("something"));
        }

```
12. Сделайте push всех изменений в новую ветку репозитория.
13. Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.
<p align="center">
  <img width="1200" src="teamcity-5.jpg">
</p>
14. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`.

```
root@promitey:/home/srg/0905/teamcity/example-teamcity/example-teamcity# git checkout master
Already on 'master'
Your branch is ahead of 'origin/master' by 5 commits.
  (use "git push" to publish your local commits)
root@promitey:/home/srg/0905/teamcity/example-teamcity/example-teamcity# git merge remotes/origin/feature/add_reply
Merge made by the 'ort' strategy.
 src/main/java/plaindoll/HelloPlayer.java  | 1 +
 src/main/java/plaindoll/Welcomer.java     | 4 ++++
 src/main/java/plaindoll/WelcomerTest.java | 1 +
 3 files changed, 6 insertions(+)
 create mode 100644 src/main/java/plaindoll/WelcomerTest.java

root@promitey:/home/srg/0905/teamcity/example-teamcity/example-teamcity# git push -f origin master
Username for 'https://github.com': awertoss
Password for 'https://awertoss@github.com':
Enumerating objects: 18, done.
Counting objects: 100% (14/14), done.
Delta compression using up to 4 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (8/8), 962 bytes | 962.00 KiB/s, done.
Total 8 (delta 3), reused 6 (delta 2), pack-reused 0
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
To https://github.com/awertoss/example-teamcity.git
 + a17fd56...345ed68 master -> master (forced update)


```
15. Убедитесь, что нет собранного артефакта в сборке по ветке `master`.
<p align="center">
  <img width="1200" src="teamcity-6.jpg">
</p>
16. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки.
<p align="center">
  <img width="1200" src="teamcity-7.jpg">
</p>
17. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны.
<p align="center">
  <img width="1200" src="teamcity-8.jpg">
</p>
18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.
<p align="center">
  <img width="1200" src="teamcity-9.jpg">
</p>
19. В ответе пришлите ссылку на репозиторий.
<p>
[https://github.com/awertoss/example-teamcity.git]
</p>

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
