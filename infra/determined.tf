resource "kubernetes_namespace" "determined" {
  metadata {
    annotations = {
      name = "determined"
    }
    name = "determined"
  }
}

resource "helm_release" "determined" {
  name      = "determined"
  chart     = "https://docs.determined.ai/${var.determined_version}/_downloads/389266101877e29ab82805a88a6fc4a6/determined-latest.tgz"
  version   = var.determined_version
  namespace = kubernetes_namespace.determined.metadata[0].name

  # Only used for Determined DB deployment. Configures the size of the PersistentVolumeClaim for the
  # Determined deployed database, as well as the CPU and memory requirements. Should be adjusted for
  # scale.

  set {
    name  = "db.cpuRequest"
    value = 1
  }

  set {
    name  = "db.memRequest"
    value = 2
  }

  # Memory and CPU requirements for the master instance. Should be adjusted for scale.

  set {
    name  = "masterCpuRequest"
    value = 1
  }

  set {
    name  = "masterMemRequest"
    value = "4Gi"
  }

  # This is the number of GPUs there are per machine. Determined uses this information when scheduling
  # multi-GPU tasks. Each multi-GPU (distributed training) task will be scheduled as a set of
  # `slotsPerTask / maxSlotsPerPod` separate pods, with each pod assigned up to `maxSlotsPerPod` GPUs.
  # Distributed tasks with sizes that are not divisible by `maxSlotsPerPod` are never scheduled. If
  # you have a cluster of different size nodes (e.g., 4 and 8 GPUs per node), set `maxSlotsPerPod` to
  # the greatest common divisor of all the sizes (4, in that case).

  set {
    name  = "maxSlotsPerPod"
    value = 1
  }

  # For CPU-only clusters, use `slotType: cpu`, and make sure to set `slotResourceRequest` below.

  set {
    name  = "slotType"
    value = "cpu"
  }

  # Number of cpu units requested for compute slots. Note: since kubernetes may schedule some
  # system tasks on the nodes which take up some resources, 8-core node may not always fit
  # a `cpu: 8` task container.

  set {
    name  = "slotResourceRequests.cpu"
    value = 2
  }
}
