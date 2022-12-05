module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                    = "23.3.0"
  project_id                 = var.project_id
  name                       = "gke-cluster-determined-ai"
  region                     = var.region
  zones                      = [var.zone]
  network                    = google_compute_network.gke_network.name
  subnetwork                 = google_compute_subnetwork.gke_subnetwork.name
  ip_range_pods              = "secondary-range-pods"
  ip_range_services          = "secondary-range-services"
  http_load_balancing        = true
  network_policy             = true
  horizontal_pod_autoscaling = true
  enable_private_endpoint    = false
  enable_private_nodes       = true
  remove_default_node_pool   = true

  node_pools = [
    {
      name           = "default-cpu-only-pool"
      machine_type   = "n1-standard-4"
      node_locations = var.zone
      # Two n1-standard-4 instances include 8 CPUs (the max free trial quota)
      min_count       = 2
      max_count       = 2
      local_ssd_count = 0
      spot            = false
      disk_size_gb    = 100
      disk_type       = "pd-standard"
      enable_gcfs     = false
      enable_gvnic    = false
      auto_repair     = true
      auto_upgrade    = true
      preemptible     = false
    }
    # Free trial accounts have the quota compute.googleapis.com/gpus_all_regions set to 0
    # Only paid accounts can request GPUs
    # {
    #   name              = "gpu-enabled-pool"
    #   accelerator_count = 1
    #   accelerator_type  = "nvidia-tesla-k80"
    #   machine_type      = "n1-standard-4"
    #   node_locations    = var.zone
    #   min_count         = 2
    #   max_count         = 2
    #   local_ssd_count   = 0
    #   spot              = false
    #   disk_size_gb      = 100
    #   disk_type         = "pd-standard"
    #   enable_gcfs       = false
    #   enable_gvnic      = false
    #   auto_repair       = true
    #   auto_upgrade      = true
    #   preemptible       = false
    # }
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-cpu-only-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}
  }

  node_pools_taints = {
    all = []
  }

  node_pools_tags = {
    all = []

    default-cpu-only-pool = [
      "default-node-pool",
    ]
  }
}

data "http" "nvidia_driver_daemonset" {
  url = "https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml"
}

# This will only match on nodes with GPUs
resource "kubectl_manifest" "nvidia_driver_daemonset" {
  yaml_body = data.http.nvidia_driver_daemonset.response_body
}
