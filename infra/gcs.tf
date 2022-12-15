# https://registry.terraform.io/modules/terraform-google-modules/cloud-storage/google/latest

module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.3"

  name       = var.checkpoints_bucket_name
  project_id = var.project_id
  location   = var.region

  #   iam_members = [{
  #     role   = "roles/storage.objectViewer"
  #     member = "user:example-user@example.com"
  #   }]
}

# https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#authenticating_to

resource "kubernetes_service_account" "ksa_gcs" {
  metadata {
    name      = "ksa-gcs"
    namespace = kubernetes_namespace.determined.id
  }
}

locals {
  ksa_gcs_name      = kubernetes_service_account.ksa_gcs.metadata[0].name
  ksa_gcs_namespace = kubernetes_service_account.ksa_gcs.metadata[0].namespace
}

resource "google_service_account" "gsa_gcs" {
  account_id   = "gsa-gcs"
  display_name = "Service account for Determined GCS checkpoint buckets"
  project      = var.project_id
}

resource "google_project_iam_binding" "gsa_gcs_project_iam_binding" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.gsa_gcs.email}"
  ]
}

resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.gsa_gcs.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${local.ksa_gcs_namespace}/${local.ksa_gcs_name}]"
  ]
}

resource "kubernetes_annotations" "ksa_gsa_annotation" {
  api_version = "v1"
  kind        = "ServiceAccount"

  metadata {
    name      = local.ksa_gcs_name
    namespace = local.ksa_gcs_namespace
  }

  annotations = {
    "iam.gke.io/gcp-service-account" = google_service_account.gsa_gcs.email
  }
}
