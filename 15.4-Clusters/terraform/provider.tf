terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.78.2"
    }
  }
}

provider "yandex" {
  token = "y0_AgAAAAAFc18888*******USQXef1ejzte5OnZFU6qQ"
  # service_account_key_file = "key.json"
  cloud_id  = "b1gnj*****hrh7s"
  folder_id = "b1gd*****h14"
  zone      = var.yandex_compute_default_zone
}
