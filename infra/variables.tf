variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "determined_version" {
  type    = string
  default = "0.19.8"
}

variable "checkpoints_bucket_name" {
  type    = string
  default = "checkpoints-82aa787c-e6ea-45e6-a21a-72ca5004f291"
}
