resource "kubernetes_manifest" "elastic_manifest" {
  field_manager {
    force_conflicts = true
  }
  computed_fields = ["metadata.labels", "metadata.annotations", "spec", "status"]
  manifest = yamldecode(templatefile("${path.module}/elk/elastic.yaml", {
    num_node_balancer      = var.num_node_balancer
    num_node_master        = var.num_node_master
    num_node_hot           = var.num_node_hot
    num_node_warm          = var.num_node_warm
    num_node_cold          = var.num_node_cold
    storage_size_balancer  = var.storage_size_balancer
    storage_size_master    = var.storage_size_master
    storage_size_hot       = var.storage_size_hot
    storage_size_warm      = var.storage_size_warm
    storage_size_cold      = var.storage_size_cold
    storage_class_balancer = var.storage_class_balancer
    storage_class_master   = var.storage_class_master
    storage_class_hot      = var.storage_class_hot
    storage_class_warm     = var.storage_class_warm
    storage_class_cold     = var.storage_class_cold
  }))
}

resource "kubernetes_manifest" "kibana_manifest" {
  field_manager {
    force_conflicts = true
  }
  computed_fields = ["metadata.labels", "metadata.annotations", "spec", "status"]
  manifest = yamldecode(templatefile("${path.module}/elk/kibana.yaml", {
    external_domain = var.kibana_external_domain

  }))
}

resource "kubernetes_manifest" "ingress_manifest" {
  manifest = yamldecode(file("${path.module}/elk/ingress.yaml"))
}

resource "kubernetes_manifest" "apm_manifest" {
  field_manager {
    force_conflicts = true
  }
  computed_fields = ["metadata.labels", "metadata.annotations", "spec", "status"]
  manifest        = yamldecode(file("${path.module}/elk/apm.yaml"))
}

resource "kubernetes_manifest" "secret_manifest" {
  field_manager {
    force_conflicts = true
  }
  computed_fields = ["metadata.labels", "metadata.annotations", "spec", "status"]
  manifest        = yamldecode(templatefile("${path.module}/elk/SecretProvider.yaml", {}))
}