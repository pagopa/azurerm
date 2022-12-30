output "main_functions" {
  value       = module.function_app
  description = "The list of the created function app."
}

output "beta_slots" {
  value       = module.function_app_beta_slot
  description = "The list of the created beta slots."
}

output "storage_account_internal_function_for_beta" {
  value = var.internal_storage.enable ? module.storage_account_for_beta[0] : null
}
