// Package source code to ZIP archive
data "archive_file" "discord_interaction_archive" {
  type        = "zip"
  source_dir  = "${path.module}/discord-interaction"
  output_path = "${path.module}/discord-interaction.zip"
}

// Bucket object for ZIP archive
resource "google_storage_bucket_object" "discord_interaction_object" {
  name   = "discord-interaction-${data.archive_file.discord_interaction_archive.output_sha}.zip"
  bucket = var.gcp_project_id
  source = data.archive_file.discord_interaction_archive.output_path
}

// Cloud Function
resource "google_cloudfunctions_function" "discord_interaction_function" {
  name        = "discord-interaction"
  project     = var.gcp_project_id
  description = "Discord interaction"
  runtime     = "nodejs12"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket_object.discord_interaction_object.bucket
  source_archive_object = google_storage_bucket_object.discord_interaction_object.name
  trigger_http          = true
  entry_point           = "interaction"

  environment_variables = {
    CLIENT_PUBLIC_KEY = var.discord_client_public_key
    WEBHOOK_ID        = var.discord_webhook_id
    WEBHOOK_TOKEN     = var.discord_webhook_token
    ADMIN_ROLE_ID     = var.discord_admin_role_id
  }
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "discord_interaction_function_iam" {
  project        = google_cloudfunctions_function.discord_interaction_function.project
  region         = google_cloudfunctions_function.discord_interaction_function.region
  cloud_function = google_cloudfunctions_function.discord_interaction_function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

// Interaction URL (output)
output "discord_interaction_https_url" {
  value       = google_cloudfunctions_function.discord_interaction_function.https_trigger_url
  description = "Discord interaction URL"
}
