output "id" {
  value = module.storage_account_durable_function.id
}

output "primary_connection_string" {
  value     = module.storage_account_durable_function.primary_connection_string
  sensitive = true
}

output "primary_access_key" {
  value     = module.storage_account_durable_function.primary_access_key
  sensitive = true
}

output "primary_blob_connection_string" {
  value     = module.storage_account_durable_function.primary_blob_connection_string
  sensitive = true
}

output "primary_blob_host" {
  value = module.storage_account_durable_function.primary_blob_host
}

output "primary_web_host" {
  value = module.storage_account_durable_function.primary_web_host
}

output "name" {
  value = module.storage_account_durable_function.name
}