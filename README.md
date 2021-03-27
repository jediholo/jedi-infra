# JEDI Infrastructure

This repository holds infrastructure definition and configuration for the [JEDI](https://www.jediholo.net) role-playing clan, which includes Web and Jedi Academy (JKA) hosting.

## Architecture

All resources in this repository are managed by [Terraform](https://www.terraform.io). Workloads are deployed as containers on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

The main infrastructure components are:
- DNS records (`dns.tf`)
- JKA servers (`jka.tf`)
- Web hosting (`web.tf`) - *Not available yet*
- Cloud storage buckets for assets and backups (`storage.tf`)
- Discord [interaction](https://discord.com/developers/docs/interactions/slash-commands) used on the official JEDI Discord channel (`discord-interaction.tf`)

The main underlying provider is currently [OVH](https://www.ovh.com). Some resources are hosted or backed up on [Google Cloud Platform (GCP)](https://cloud.google.com).

## Deployment

For development and deployment, download and install [Terraform CLI](https://www.terraform.io/downloads.html) version 0.14 or higher.

Create a `terraform.tfvars` file to customize sensitive variables marked as `"toComplete"` in `terrafom.auto.tfvars`. See `variables.tf` for more information.

When done, you may execute the following commands in this repository:
```
# Download plugins and current state
terraform init

# Preview infrastructure changes
terraform plan

# Apply infrastructure changes
terraform apply
```

The Terraform state is stored in a [Terraform Cloud](https://app.terraform.io/app/jediholo/workspaces/jedi-infra) workspace.

## Credits

- **Lead developer:** Fabien Crespel (a.k.a. Soh Raun)
