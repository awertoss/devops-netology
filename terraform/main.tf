resource "yandex_compute_instance" "node01" {

name = "node01"
hostname ="node01"
description="node01"
folder_id=var.folder_id
zone=var.zone

allow_stopping_for_update=true
  resources {
   cores=2
   core_fraction=100
   memory=4
  }
    boot_disk {
    initialize_params {
 image_id = "fd8crfebu4gi2omg8lk2"
 name = "root-service01"
 type = "network-nvme"
 size = "20"
    }
  }                                                                                                                                                                                                               name = "node01"                                                                                                                hostname ="node01"                                                                                                             description="node01"                                                                                                           folder_id=var.folder_id                                                                                                        zone=var.zone                                                                                                                                                                                                                                                 allow_stopping_for_update=true                                                                                                   resources {                                                                                                                     cores=2                                                                                                                        core_fraction=100                                                                                                              memory=4                                                                                                                      }                                                                                                                                boot_disk {                                                                                                                    initialize_params {                                                                                                         image_id = "fd8crfebu4gi2omg8lk2"                                                                                              name = "root-service01"                                                                                                        type = "network-nvme"                                                                                                          size = "20"                                                                                                                       }                                                                                                                            } 

network_interface {
subnet_id="e2l4r907kvo0cigeauo5"
nat=true
}
 metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}
variable "folder_id" {
type=string
default="b1gd02p4ii36h57v2h14"
}
variable "zone" {
type=string
default="ru-central1-a"
}

variable "OAUTH" {
  type = string
}
