output "jwt_private_key_pem" {
  value     = tls_private_key.jwt.private_key_pem
  sensitive = true
}

output "jwt_public_key_pem" {
  value = tls_private_key.jwt.public_key_pem
}

output "jwt_kid" {
  value = local.kid
}

output "certificate_data_pem" {
  value = tls_self_signed_cert.jwt_self.cert_pem
}
