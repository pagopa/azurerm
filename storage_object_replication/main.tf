/*
Storage account object replication.
*/

resource "azurerm_storage_object_replication" "this" {
  source_storage_account_id      = var.source_storage_account_id
  destination_storage_account_id = var.destination_storage_account_id

  dynamic "rules" {
    for_each = var.rules
    iterator = r
    content {
      source_container_name      = r.value.source_container_name
      destination_container_name = r.value.destination_container_name
      copy_blobs_created_after   = r.value.copy_blobs_created_after
    }
  }
}