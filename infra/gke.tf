module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google/modules/private-cluster"
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
      name              = "gpu-node-pool"
      machine_type      = "n1-standard-4"
      accelerator_type  = "nvidia-tesla-p100"
      accelerator_count = 1
      node_locations    = var.zone
      min_count         = 3
      max_count         = 3
      local_ssd_count   = 0
      spot              = false
      disk_size_gb      = 100
      disk_type         = "pd-standard"
      enable_gcfs       = false
      enable_gvnic      = false
      auto_repair       = true
      auto_upgrade      = true
      preemptible       = false
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    gpu-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    gpu-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    gpu-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    gpu-node-pool = [
      "default-node-pool",
    ]
  }
}
