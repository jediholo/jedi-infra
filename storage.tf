// Swift containers for assets
resource "openstack_objectstorage_container_v1" "os_container_gamerepo_default" {
  name           = "gamerepo-default"
  container_read = ".r:*,.rlistings" # public
}
resource "openstack_objectstorage_container_v1" "os_container_gamerepo_jedi_downloads" {
  name           = "gamerepo-jedi-downloads"
  container_read = ".r:*,.rlistings" # public
}
resource "openstack_objectstorage_container_v1" "os_container_gamerepo_jedi_private" {
  name           = "gamerepo-jedi-private"
}
resource "openstack_objectstorage_container_v1" "os_container_gamerepo_jedi_skins" {
  name           = "gamerepo-jedi-skins"
  container_read = ".r:*,.rlistings" # public
}

// GCS bucket for project files
resource "google_storage_bucket" "gcs_bucket_project" {
  name                        = var.gcp_project_id
  project                     = var.gcp_project_id
  location                    = var.gcp_region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

// GCS buckets for backups
resource "google_storage_bucket" "gcs_bucket_backups" {
  name                        = "${var.gcp_project_id}-backups"
  project                     = var.gcp_project_id
  location                    = var.gcp_region
  storage_class               = "COLDLINE"
  uniform_bucket_level_access = true
}
resource "google_storage_bucket" "gcs_bucket_gamerepo_default" {
  name                        = "${var.gcp_project_id}-gamerepo-default"
  project                     = var.gcp_project_id
  location                    = var.gcp_region
  storage_class               = "COLDLINE"
  uniform_bucket_level_access = true
}
resource "google_storage_bucket" "gcs_bucket_gamerepo_jedi_downloads" {
  name                        = "${var.gcp_project_id}-gamerepo-jedi-downloads"
  project                     = var.gcp_project_id
  location                    = var.gcp_region
  storage_class               = "COLDLINE"
  uniform_bucket_level_access = true
}
resource "google_storage_bucket" "gcs_bucket_gamerepo_jedi_private" {
  name                        = "${var.gcp_project_id}-gamerepo-jedi-private"
  project                     = var.gcp_project_id
  location                    = var.gcp_region
  storage_class               = "COLDLINE"
  uniform_bucket_level_access = true
}
resource "google_storage_bucket" "gcs_bucket_gamerepo_jedi_skins" {
  name                        = "${var.gcp_project_id}-gamerepo-jedi-skins"
  project                     = var.gcp_project_id
  location                    = var.gcp_region
  storage_class               = "COLDLINE"
  uniform_bucket_level_access = true
}

// Service Account with Storage Object Admin role
resource "google_service_account" "gcs_sa" {
  account_id   = "storage-writer"
  project      = var.gcp_project_id
  display_name = "Cloud Storage Writer"
}
resource "google_project_iam_member" "gcs_sa_iam_object_admin" {
  project = var.gcp_project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.gcs_sa.email}"
}

