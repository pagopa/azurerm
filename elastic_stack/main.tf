#############
# Install CRDs and Operator
# https://www.elastic.co/guide/en/cloud-on-k8s/2.1/k8s-deploy-eck.html
# version 2.6.1
#############
locals {
  orig_crd_yaml     = file("${path.module}/yaml/crds.yaml")
  crd_yaml_del_time = replace(local.orig_crd_yaml, "\n  creationTimestamp: null", "")
  crd_yaml          = local.crd_yaml_del_time

  orig_operator_yaml          = file("${path.module}/yaml/operator.yaml")
  operator_yaml_set_namespace = replace(local.orig_operator_yaml, "namespace: elastic-system", "namespace: ${var.namespace}") #usato il replace per essere più comodi in un futuro cambio versione 
  operator_yaml               = local.operator_yaml_set_namespace

  elastic_yaml = templatefile("${path.module}/yaml/elastic.yaml", {
    namespace      = var.namespace
    nodeset_config = var.nodeset_config
  })

  elastic_ingress_yaml = yamldecode(templatefile("${path.module}/yaml/ingress_elastic.yaml", {
    namespace                = var.namespace
    kibana_internal_hostname = var.kibana_internal_hostname
    secret_name              = var.secret_name
  }))

  kibana_secret_provider_yaml = yamldecode(templatefile("${path.module}/yaml/SecretProvider.yaml", {
    namespace     = var.namespace
    secret_name   = var.secret_name
    keyvault_name = var.keyvault_name
  }))

  kibana_mounter_yaml = yamldecode(templatefile("${path.module}/yaml/mounter.yaml", {
    namespace   = var.namespace
    secret_name = var.secret_name
  }))

  kibana_yaml = templatefile("${path.module}/yaml/kibana.yaml", {
    namespace       = var.namespace
    external_domain = var.kibana_external_domain
  })

  kibana_ingress_yaml = yamldecode(templatefile("${path.module}/yaml/ingress_kibana.yaml", {
    namespace                = var.namespace
    kibana_internal_hostname = var.kibana_internal_hostname
    secret_name              = var.secret_name
  }))

  apm_yaml = templatefile("${path.module}/yaml/apm.yaml", {
    namespace = var.namespace
  })

  apm_ingress_yaml = yamldecode(templatefile("${path.module}/yaml/ingress_apm.yaml", {
    namespace                = var.namespace
    kibana_internal_hostname = var.kibana_internal_hostname
    secret_name              = var.secret_name
  }))

  orig_agent_yaml = file("${path.module}/yaml/agent.yaml")
  agent_yaml      = replace(local.orig_agent_yaml, "namespace: kube-system", "namespace: ${var.namespace}") #usato il replace per essere più comodi in un futuro cambio versione 

  logstash_config_yaml = templatefile("${path.module}/yaml/logstash_config.yaml", {
    namespace = var.namespace
  })
  logstash_yaml = templatefile("${path.module}/yaml/logstash.yaml", {
    namespace = var.namespace
  })
  logstash_ingress_yaml = yamldecode(templatefile("${path.module}/yaml/ingress_logstash.yaml", {
    namespace                = var.namespace
    kibana_internal_hostname = var.kibana_internal_hostname
    secret_name              = var.secret_name
  }))
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
    when        = destroy
    command     = "kubectl get namespaces --no-headers -o custom-columns=:metadata.name | xargs -n1 kubectl delete elastic --all -n"
    interpreter = ["/bin/bash", "-c"]
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
# version 8.6.2 
#############
####################
## USE trick for crd https://medium.com/@danieljimgarcia/dont-use-the-terraform-kubernetes-manifest-resource-6c7ff4fe629a
####################
resource "kubectl_manifest" "elasticsearch_cluster" {
  depends_on = [
    kubernetes_manifest.operator
  ]
  force_conflicts = true
  yaml_body       = local.elastic_yaml
}

resource "kubernetes_manifest" "ingress_elastic_manifest" {
  manifest = local.elastic_ingress_yaml
  depends_on = [
    kubectl_manifest.elasticsearch_cluster
  ]
}

resource "null_resource" "wait_elasticsearch_cluster" {
  depends_on = [
    kubernetes_manifest.ingress_elastic_manifest
  ]

  # triggers = {
  #   always_run = "${timestamp()}"
  # }
  provisioner "local-exec" {
    command     = "while [ true ]; do STATUS=`kubectl -n ${var.namespace} get Elasticsearch -ojsonpath='{range .items[*]}{.status.health}'`; if [ \"$STATUS\" = \"green\" ]; then echo \"ELASTIC SUCCEEDED\" ; break ; else echo \"ELASTIC INPROGRESS\"; sleep 3; fi ; done"
    interpreter = ["/bin/bash", "-c"]
  }
}

# resource "null_resource" "get_elastic_credential" {
#   depends_on = [
#     null_resource.wait_elasticsearch_cluster
#   ]

#   #############
#   # Username: elastic
#   # Password: $(kubectl -n elastic-system get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo)
#   #############
#   provisioner "local-exec" {
#     command     = "ES_PASSWORD=`kubectl -n ${var.namespace} get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo`; echo \"\n## ELASTIC #########################\n# USERNAME: elastic \n# PASSWORD: $ES_PASSWORD\n####################################\n\""
#     interpreter = ["/bin/bash", "-c"]
#   }
# }



#############
# Create cert mounter for certs
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
  manifest        = local.kibana_secret_provider_yaml
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
  manifest        = local.kibana_mounter_yaml
}


#############
# Install Kibana
# https://www.elastic.co/guide/en/cloud-on-k8s/2.1/k8s-deploy-kibana.html
# version 8.6.2 
#############
####################
## USE trick for crd https://medium.com/@danieljimgarcia/dont-use-the-terraform-kubernetes-manifest-resource-6c7ff4fe629a
####################
resource "kubectl_manifest" "kibana_manifest" {
  depends_on = [
    kubernetes_manifest.mounter_manifest
  ]
  force_conflicts = true
  yaml_body       = local.kibana_yaml
}

## Create ingress for kibana
resource "kubernetes_manifest" "ingress_kibana_manifest" {
  manifest = local.kibana_ingress_yaml
  depends_on = [
    kubectl_manifest.kibana_manifest
  ]
}

resource "null_resource" "wait_kibana" {
  depends_on = [
    kubernetes_manifest.ingress_kibana_manifest
  ]
  # triggers = {
  #   always_run = "${timestamp()}"
  # }
  provisioner "local-exec" {
    command     = "while [ true ]; do STATUS=`kubectl -n ${var.namespace} get Kibana -ojsonpath='{range .items[*]}{.status.health}'`; if [ \"$STATUS\" = \"green\" ]; then echo \"KIBANA SUCCEEDED\" ; break ; else echo \"KIBANA INPROGRESS\"; sleep 3; fi ; done"
    interpreter = ["/bin/bash", "-c"]
  }
}



#############
# Install APM Server
# https://www.elastic.co/guide/en/cloud-on-k8s/2.1/k8s-apm-eck-managed-es.html
# version 8.6.2 
#############
####################
## USE trick for crd https://medium.com/@danieljimgarcia/dont-use-the-terraform-kubernetes-manifest-resource-6c7ff4fe629a
####################
resource "kubectl_manifest" "apm_manifest" {
  depends_on = [
    null_resource.wait_kibana
  ]
  force_conflicts = true
  yaml_body       = local.apm_yaml
}
resource "kubernetes_manifest" "ingress_apm_manifest" {
  manifest = local.apm_ingress_yaml
  depends_on = [
    kubectl_manifest.apm_manifest
  ]
}
resource "null_resource" "wait_apm" {
  depends_on = [
    kubernetes_manifest.ingress_apm_manifest
  ]
  # triggers = {
  #   always_run = "${timestamp()}"
  # }
  provisioner "local-exec" {
    command     = "while [ true ]; do STATUS=`kubectl -n ${var.namespace} get ApmServer -ojsonpath='{range .items[*]}{.status.health}'`; if [ \"$STATUS\" = \"green\" ]; then echo \"APM SUCCEEDED\" ; break ; else echo \"APM INPROGRESS\"; sleep 3; fi ; done"
    interpreter = ["/bin/bash", "-c"]
  }
}

#############
# Install Elastic Agent
#############
data "kubectl_file_documents" "elastic_agent" {
  content = local.agent_yaml
}
resource "kubectl_manifest" "elastic_agent" {
  depends_on = [
    null_resource.wait_elasticsearch_cluster
  ]
  for_each  = data.kubectl_file_documents.elastic_agent.manifests
  yaml_body = each.value

  force_conflicts = true
  wait            = true
}

#############
# Install Logstash
# Source: https://medium.com/kocsistem/elk-installation-with-eck-operator-56e8a0a501fa
#############
resource "kubernetes_manifest" "logstash_config" {
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
        "\n${replace(local.logstash_config_yaml, "/(?m)^---[[:blank:]]*(#.*)?$/", "---")}\n"
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
    null_resource.wait_elasticsearch_cluster
  ]
}

resource "kubernetes_manifest" "logstash" {
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
        "\n${replace(local.logstash_yaml, "/(?m)^---[[:blank:]]*(#.*)?$/", "---")}\n"
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
    kubernetes_manifest.logstash_config
  ]
}

# resource "kubernetes_manifest" "ingress_logstash_manifest" {
#   manifest = local.logstash_ingress_yaml
#   depends_on = [
#     kubernetes_manifest.logstash
#   ]
# }


