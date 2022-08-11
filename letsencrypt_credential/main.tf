resource "null_resource" "this" {
  triggers = {
    prefix        = var.prefix
    env           = var.env
    subscription  = var.subscription_name
    keyvault_name = var.key_vault_name
    email         = var.le_email
  }

  # https://docs.microsoft.com/it-it/cli/azure/ad/sp?view=azure-cli-latest#az_ad_sp_create_for_rbac
  provisioner "local-exec" {
    command = <<EOT
      container_name="le${self.triggers.prefix}${self.triggers.env}"

      docker run --name $container_name certbot/certbot:${var.certbot_version} register --agree-tos --email "${self.triggers.email}" -n

      mkdir -p ./accounts/${self.triggers.prefix}${self.triggers.env}
      docker cp $container_name:/etc/letsencrypt/accounts/ ./accounts/${self.triggers.prefix}${self.triggers.env}

      docker rm -v $container_name

      private_key_json=$(find ./accounts/${self.triggers.prefix}${self.triggers.env} -name "private_key.json")

      az keyvault secret set \
        --name "le-private-key-json" \
        --vault-name "${self.triggers.keyvault_name}" \
        --subscription "${self.triggers.subscription}" \
        --file "$private_key_json"

      reg_json=$(find ./accounts/${self.triggers.prefix}${self.triggers.env} -name "regr.json")

      az keyvault secret set \
        --name "le-regr-json" \
        --vault-name "${self.triggers.keyvault_name}" \
        --subscription "${self.triggers.subscription}" \
        --file "$reg_json"

      rm -rf accounts/${self.triggers.prefix}${self.triggers.env}

    EOT
  }
}
