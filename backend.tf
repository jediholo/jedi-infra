terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "jediholo"

    workspaces {
      name = "jedi-infra"
    }
  }
}
