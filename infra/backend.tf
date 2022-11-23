terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = var.remote_organization

    workspaces {
      name = var.remote_workspace
    }
  }
}
