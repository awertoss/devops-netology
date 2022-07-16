# devops-netology

Игнорировать все файлы в директории любые категории/terraform

**/.terraform/*

Игнорировать все файлы с расширением tfstate

*.tfstate

Игнорировать все файлы с расширением tfstate. любые символы

*.tfstate.*


Игнорировать файл crash.log
crash.log

Игнорировать crash.любые символы.log
crash.*.log

# Exclude all .tfvars files, which are likely to contain sensitive data, such as
# password, private keys, and other secrets. These should not be part of version 
# control as they are data points which are potentially sensitive and subject 
# to change depending on the environment.


Игнорировать все файлы с расширение tfvars и tfvars.json
*.tfvars
*.tfvars.json

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
Игнорировать override.tf overridge.tf.json и любые символы_overridge.tf и любые символы_override.tf.json
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

# Ignore CLI configuration files
Игнорировать .terraformrc и terraform.rc
.terraformrc
terraform.rc
novaya strochka
