locals {
  kid = format("%s_%s", var.jwt_name, tls_private_key.jwt.public_key_fingerprint_md5)
}

resource "tls_private_key" "jwt" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "jwt_self" {
  allowed_uses = [
    "crl_signing",
    "data_encipherment",
    "digital_signature",
    "key_agreement",
    "cert_signing",
    "key_encipherment"
  ]
  key_algorithm         = "RSA"
  private_key_pem       = tls_private_key.jwt.private_key_pem
  validity_period_hours = var.cert_validity_hours
  subject {
    common_name = var.cert_common_name
  }
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "jwt_private_key" {
  name         = format("%s-private-key", var.jwt_name)
  value        = tls_private_key.jwt.private_key_pem
  content_type = "text/plain"

  key_vault_id = var.key_vault_id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "jwt_public_key" {
  name         = format("%s-public-key", var.jwt_name)
  value        = tls_private_key.jwt.public_key_pem
  content_type = "text/plain"

  key_vault_id = var.key_vault_id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "jwt_cert" {
  name         = format("%s-cert", var.jwt_name)
  value        = tls_self_signed_cert.jwt_self.cert_pem
  content_type = "text/plain"

  key_vault_id = var.key_vault_id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "jwt_kid" {
  name         = format("%s-kid", var.jwt_name)
  value        = local.kid
  content_type = "text/plain"

  key_vault_id = var.key_vault_id
}
