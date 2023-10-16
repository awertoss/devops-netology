// Create SA
resource "yandex_iam_service_account" "n15" {
  folder_id = "b1gd02p4ii36h57v2h14"
  name      = "n15"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "viewer" {
  folder_id = "b1gd02p4ii36h57v2h14"
  role      = "viewer"
  member    = "serviceAccount:${yandex_iam_service_account.n15.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = "b1gd02p4ii36h57v2h14"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.n15.id}"
}


