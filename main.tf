locals {
  location            = var.resource_group_name != "" ? concat(data.azurerm_resource_group.this.*.location, [""])[0] : concat(azurerm_resource_group.this.*.location, [""])[0]
  resource_group_name = var.resource_group_name != "" ? concat(data.azurerm_resource_group.this.*.name, [""])[0] : concat(azurerm_resource_group.this.*.name, [""])[0]
  tags = merge(
    var.tags,
    map(
      "Role", var.role
    )
  )
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name

  count = var.resource_group_name == "" ? 0 : 1
}

resource "azurerm_resource_group" "this" {
  name     = "${var.preifx}tfstate-rg"
  location = var.location

  tags  = local.tags
  count = var.resource_group_name == "" ? 1 : 0
}

resource "azurerm_storage_account" "this" {
  name                     = "${replace(var.preifx, "-", "")}tfstate"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags  = local.tags
}

resource "azurerm_storage_container" "this" {
  name                 = "tfstate"
  storage_account_name = azurerm_storage_account.this.name
}

resource "local_file" "backend_file" {
  filename = "${var.backend_files[count.index].path}/backend.tf"
  content  = templatefile("${path.module}/backend.tf.tpl", {
    terraform_version    = var.terraform_version
    resource_group_name  = local.resource_group_name
    storage_account_name = azurerm_storage_account.this.name
    container_name       = azurerm_storage_container.this.name
    key                  = var.backend_files[count.index].key
  })
  file_permission = "0644"

  count = length(var.backend_files)
}