# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
token= var.OAUTH
cloud_id="b1gnjst4dee7j34hrh7s"
folder_id=var.folder_id
zone=var.zone
}
