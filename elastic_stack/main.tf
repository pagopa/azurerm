#############
# Install CRDs and Operator
# https://www.elastic.co/guide/en/cloud-on-k8s/2.1/k8s-deploy-eck.html
# version 2.1.0
#############
locals {
  orig_crd_yaml = file("${path.module}/yaml/crds.yaml")
  crd_yaml_del_time = replace(local.orig_crd_yaml, "\n  creationTimestamp: null", "")
  crd_yaml = local.crd_yaml_del_time
  
  orig_operator_yaml = file("${path.module}/yaml/operator.yaml")
  operator_yaml_set_namespace = replace(local.orig_operator_yaml, "namespace: elastic-system", "namespace: ${var.namespace}")
  operator_yaml = local.operator_yaml_set_namespace
}

resource "kubernetes_manifest" "crd" {
  # Create a map { "kind--name" => yaml_doc } from the multi-document yaml text.
  # Each element is a separate kubernetes resource.
  # Must use \n---\n to avoid splitting on strings and comments containing "---".
  # YAML allows "---" to be the first and last line of a file, so make sure
  # raw yaml begins and ends with a newline.
  # The "---" can be followed by spaces, so need to remove those too.
  # Skip blocks that are empty or comments-only in case yaml began with a comment before "---".
  for_each = {
    for value in [
      for yaml in split(
        "\n---\n",
        "\n${replace(local.crd_yaml, "/(?m)^---[[:blank:]]*(#.*)?$/", "---")}\n"
      ) :
      yamldecode(replace(yaml, "/(?s:\nstatus:.*)$/", ""))
      if trimspace(replace(yaml, "/(?m)(^[[:blank:]]*(#.*)?$)+/", "")) != ""
    ] : "${value["kind"]}--${value["metadata"]["name"]}" => value
  }
  manifest = each.value
  field_manager {
    force_conflicts = true
  }
  computed_fields = [
    "metadata.labels", "metadata.annotations",
    "metadata.creationTimestamp",
  ]
}



resource "kubernetes_manifest" "operator" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl get namespaces --no-headers -o custom-columns=:metadata.name | xargs -n1 kubectl delete elastic --all -n"
  }

  # Create a map { "kind--name" => yaml_doc } from the multi-document yaml text.
  # Each element is a separate kubernetes resource.
  # Must use \n---\n to avoid splitting on strings and comments containing "---".
  # YAML allows "---" to be the first and last line of a file, so make sure
  # raw yaml begins and ends with a newline.
  # The "---" can be followed by spaces, so need to remove those too.
  # Skip blocks that are empty or comments-only in case yaml began with a comment before "---".
  for_each = {
    for value in [
      for yaml in split(
        "\n---\n",
        "\n${replace(local.operator_yaml, "/(?m)^---[[:blank:]]*(#.*)?$/", "---")}\n"
      ) :
      yamldecode(replace(yaml, "/(?s:\nstatus:.*)$/", ""))
      if trimspace(replace(yaml, "/(?m)(^[[:blank:]]*(#.*)?$)+/", "")) != ""
    ] : "${value["kind"]}--${value["metadata"]["name"]}" => value
  }
  manifest = each.value
  field_manager {
    force_conflicts = true
  }
  computed_fields = [
    "metadata.labels", "metadata.annotations",
    "metadata.creationTimestamp", "webhooks",
  ]
  depends_on = [
    kubernetes_manifest.crd
  ]
}


#############
# Install Elasticsearch cluster
# https://www.elastic.co/guide/en/cloud-on-k8s/2.1/k8s-deploy-elasticsearch.html
# version 8.6.2 > 8.1.2
#############

####################
## USE trick for crd https://medium.com/@danieljimgarcia/dont-use-the-terraform-kubernetes-manifest-resource-6c7ff4fe629a
####################
# resource "kubernetes_manifest" "elasticsearch_cluster" {
#   depends_on = [
#     kubernetes_manifest.operator
#   ]
#   field_manager {
#     force_conflicts = true
#   }
#   computed_fields = ["metadata.labels", "metadata.annotations", "spec", "status"]
#   manifest = yamldecode(templatefile("${path.module}/yaml/elastic.yaml", {
#     nodeset_config      = var.nodeset_config
#   }))
# }
resource "kubectl_manifest" "elasticsearch_cluster" {
  depends_on = [
    kubernetes_manifest.operator
  ]

  force_conflicts = true

  yaml_body = templatefile("${path.module}/yaml/elastic.yaml", {
    nodeset_config      = var.nodeset_config
  })
  
}

resource "null_resource" "wait_elasticsearch_cluster" {
  depends_on = [
    kubectl_manifest.elasticsearch_cluster
  ]

  provisioner "local-exec" {
    command = "while [ true ]; do STATUS=`kubectl -n ${var.namespace} get Elasticsearch -ojsonpath='{range .items[*]}{.status.health}'`; if [ \"$STATUS\" = \"green\" ]; then echo \"SUCCEEDED\" ; break ; else echo \"INPROGRESS\"; sleep 3; fi ; done"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "get_elastic_credential" {
  depends_on = [
    null_resource.wait_elasticsearch_cluster
  ]

  #############
  # Username: elastic
  # Password: $(kubectl -n elastic-system get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo)
  #############
  provisioner "local-exec" {
    command = "ES_PASSWORD=`kubectl -n ${var.namespace} get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo`; echo \"\n## ELASTIC #########################\n# USERNAME: elastic \n# PASSWORD: $ES_PASSWORD\n####################################\n\""
    interpreter = ["/bin/bash", "-c"]
  }
}

#############
# Install Kibana
# https://www.elastic.co/guide/en/cloud-on-k8s/2.1/k8s-deploy-kibana.html
# version 8.6.2 > 8.1.2
#############

# create secret-provider for mounter
resource "kubernetes_manifest" "secret_manifest" {

  depends_on = [
    null_resource.wait_elasticsearch_cluster
  ]

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["metadata.labels", "metadata.annotations", "spec", "status"]
  manifest = yamldecode(templatefile("${path.module}/yaml/SecretProvider.yaml", {
    secret_name   = var.secret_name
    keyvault_name = var.keyvault_name
  }))
}

# create fake mounter for load certs
resource "kubernetes_manifest" "mounter_manifest" {
  depends_on = [
    kubernetes_manifest.secret_manifest
  ]
  field_manager {
    force_conflicts = true
  }
  computed_fields = ["metadata.labels", "metadata.annotations", "spec", "status"]
  manifest = yamldecode(templatefile("${path.module}/yaml/mounter.yaml", {
    secret_name = var.secret_name
  }))
}

####################
## USE trick for crd https://medium.com/@danieljimgarcia/dont-use-the-terraform-kubernetes-manifest-resource-6c7ff4fe629a
####################
# resource "kubernetes_manifest" "kibana_manifest" {
#   depends_on = [
#     kubernetes_manifest.operator,
#     kubernetes_manifest.mounter_manifest
#   ]
#   field_manager {
#     force_conflicts = true
#   }
#   computed_fields = ["metadata.labels", "metadata.annotations", "spec", "status"]
#   manifest = yamldecode(templatefile("${path.module}/yaml/kibana.yaml", {
#     external_domain = var.kibana_external_domain

#   }))
# }
resource "kubectl_manifest" "kibana_manifest" {
  depends_on = [
    kubernetes_manifest.mounter_manifest
  ]

  force_conflicts = true
 
  yaml_body = templatefile("${path.module}/yaml/kibana.yaml", {
    external_domain = var.kibana_external_domain
  })
}

## Create ingress for kibana
resource "kubernetes_manifest" "ingress_manifest" {
  manifest = yamldecode(templatefile("${path.module}/yaml/ingress.yaml", {
    kibana_internal_hostname = var.kibana_internal_hostname
    secret_name              = var.secret_name
  }))
  depends_on = [
    kubectl_manifest.kibana_manifest
  ]
}


#############
# Install APM Server
# https://www.elastic.co/guide/en/cloud-on-k8s/2.1/k8s-apm-eck-managed-es.html
# version 8.6.2 > 8.1.2
#############

####################
## USE trick for crd https://medium.com/@danieljimgarcia/dont-use-the-terraform-kubernetes-manifest-resource-6c7ff4fe629a
####################
# resource "kubernetes_manifest" "apm_manifest" {
#   depends_on = [
#     kubernetes_manifest.operator
#   ]
#   field_manager {
#     force_conflicts = true
#   }
#   computed_fields = ["metadata.labels", "metadata.annotations", "spec", "status"]
#   manifest        = yamldecode(file("${path.module}/yaml/apm.yaml"))
# }

resource "kubectl_manifest" "apm_manifest" {
  depends_on = [
    null_resource.wait_elasticsearch_cluster
  ]

  force_conflicts = true
 
  yaml_body = file("${path.module}/yaml/apm.yaml")


}