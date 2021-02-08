output "discord_interaction_https_url" {
  value       = google_cloudfunctions_function.discord_interaction_function.https_trigger_url
  description = "Discord interaction URL"
}
