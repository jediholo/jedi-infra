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
resource "google_cloudfunctions2_function" "discord_interaction_function" {
  name        = "discord-interaction"
  project     = var.gcp_project_id
  location    = var.gcp_region
  description = "Discord interaction"

  build_config {
    runtime     = "nodejs18"
    entry_point = "interaction"
    source {
      storage_source {
        bucket = google_storage_bucket_object.discord_interaction_object.bucket
        object = google_storage_bucket_object.discord_interaction_object.name
      }
    }
  }

  service_config {
    max_instance_count = 10
    available_memory   = "128Mi"
    environment_variables = {
      ADMIN_ROLE_ID        = var.discord_admin_role_id
      ANNOUNCE_WEBHOOK_URL = var.discord_announce_webhook_url
      CLIENT_PUBLIC_KEY    = var.discord_client_public_key
    }
    ingress_settings      = "ALLOW_ALL"
    service_account_email = google_service_account.discord_interaction_sa.email
  }
}

// Discord interaction service account
resource "google_service_account" "discord_interaction_sa" {
  project      = var.gcp_project_id
  account_id   = "discord-interaction"
  display_name = "Service account for Discord interaction"
}

// Discord interaction IAM entry for public access
resource "google_cloud_run_service_iam_member" "discord_interaction_function_iam" {
  project  = google_cloudfunctions2_function.discord_interaction_function.project
  location = google_cloudfunctions2_function.discord_interaction_function.location
  service  = google_cloudfunctions2_function.discord_interaction_function.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

// Discord interaction URL (output)
output "discord_interaction_https_url" {
  value       = google_cloudfunctions2_function.discord_interaction_function.service_config[0].uri
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
resource "google_cloudfunctions2_function" "jka_logs_processor_function" {
  name        = "jka-logs-processor"
  project     = var.gcp_project_id
  location    = var.gcp_region
  description = "JKA logs processor"

  build_config {
    runtime     = "nodejs18"
    entry_point = "process"
    source {
      storage_source {
        bucket = google_storage_bucket_object.jka_logs_processor_object.bucket
        object = google_storage_bucket_object.jka_logs_processor_object.name
      }
    }
  }

  service_config {
    max_instance_count = 10
    available_memory   = "128Mi"
    environment_variables = {
      COMMLINK_WEBHOOK_URL = var.discord_commlink_webhook_url
      COUNCIL_WEBHOOK_URL  = var.discord_council_webhook_url
      RCON_PASSWORD        = lookup(var.jka_rcon_password, "default", "")
      RCON_SERVERS         = jsonencode(var.jka_server_hostport)
    }
    ingress_settings      = "ALLOW_INTERNAL_ONLY"
    service_account_email = google_service_account.jka_logs_processor_sa.email
  }

  event_trigger {
    event_type            = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic          = google_pubsub_topic.web_logstash_pubsub_topic.id
    retry_policy          = "RETRY_POLICY_RETRY"
    service_account_email = google_service_account.jka_logs_processor_sa.email
  }
}

// JKA logs processor service account
resource "google_service_account" "jka_logs_processor_sa" {
  project      = var.gcp_project_id
  account_id   = "jka-logs-processor"
  display_name = "Service account for JKA logs processor"
}

// JKA logs processor IAM entry for internal access
resource "google_cloud_run_service_iam_member" "jka_logs_processor_function_iam" {
  project  = google_cloudfunctions2_function.jka_logs_processor_function.project
  location = google_cloudfunctions2_function.jka_logs_processor_function.location
  service  = google_cloudfunctions2_function.jka_logs_processor_function.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.jka_logs_processor_sa.email}"
}
