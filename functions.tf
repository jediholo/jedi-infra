// Discord interaction ZIP archive
data "archive_file" "discord_interaction_archive" {
  type        = "zip"
  source_dir  = "${path.module}/functions/discord-interaction"
  output_path = "${path.module}/functions/discord-interaction.zip"
}

// Discord interaction ZIP archive bucket object
resource "google_storage_bucket_object" "discord_interaction_object" {
  name   = "discord-interaction-${data.archive_file.discord_interaction_archive.output_sha}.zip"
  bucket = var.gcp_project_id
  source = data.archive_file.discord_interaction_archive.output_path
}

// Discord interaction Cloud Function
resource "google_cloudfunctions_function" "discord_interaction_function" {
  name        = "discord-interaction"
  project     = var.gcp_project_id
  description = "Discord interaction"
  runtime     = "nodejs18"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket_object.discord_interaction_object.bucket
  source_archive_object = google_storage_bucket_object.discord_interaction_object.name
  service_account_email = google_service_account.discord_interaction_sa.email
  trigger_http          = true
  entry_point           = "interaction"
  max_instances         = 10

  environment_variables = {
    ADMIN_ROLE_ID        = var.discord_admin_role_id
    ANNOUNCE_WEBHOOK_URL = var.discord_announce_webhook_url
    CLIENT_PUBLIC_KEY    = var.discord_client_public_key
  }
}

// Discord interaction service account
resource "google_service_account" "discord_interaction_sa" {
  project      = var.gcp_project_id
  account_id   = "discord-interaction"
  display_name = "Service account for Discord interaction"
}

// Discord interaction IAM entry for public access
resource "google_cloudfunctions_function_iam_member" "discord_interaction_function_iam" {
  project        = google_cloudfunctions_function.discord_interaction_function.project
  region         = google_cloudfunctions_function.discord_interaction_function.region
  cloud_function = google_cloudfunctions_function.discord_interaction_function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}

// Discord interaction URL (output)
output "discord_interaction_https_url" {
  value       = google_cloudfunctions_function.discord_interaction_function.https_trigger_url
  description = "Discord interaction URL"
}


// JKA logs processor ZIP archive
data "archive_file" "jka_logs_processor_archive" {
  type        = "zip"
  source_dir  = "${path.module}/functions/jka-logs-processor"
  output_path = "${path.module}/functions/jka-logs-processor.zip"
}

// JKA logs processor ZIP archive bucket object
resource "google_storage_bucket_object" "jka_logs_processor_object" {
  name   = "jka-logs-processor-${data.archive_file.jka_logs_processor_archive.output_sha}.zip"
  bucket = var.gcp_project_id
  source = data.archive_file.jka_logs_processor_archive.output_path
}

// JKA logs processor Cloud Function
resource "google_cloudfunctions_function" "jka_logs_processor_function" {
  name        = "jka-logs-processor"
  project     = var.gcp_project_id
  description = "JKA logs processor"
  runtime     = "nodejs18"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket_object.jka_logs_processor_object.bucket
  source_archive_object = google_storage_bucket_object.jka_logs_processor_object.name
  service_account_email = google_service_account.jka_logs_processor_sa.email
  entry_point           = "process"
  max_instances         = 10

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.web_logstash_pubsub_topic.name
    failure_policy {
      retry = true
    }
  }
}

// JKA logs processor service account
resource "google_service_account" "jka_logs_processor_sa" {
  project      = var.gcp_project_id
  account_id   = "jka-logs-processor"
  display_name = "Service account for JKA logs processor"
}
