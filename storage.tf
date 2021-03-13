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
