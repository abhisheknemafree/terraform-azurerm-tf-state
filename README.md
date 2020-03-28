# AzureRM Backend

Creates storage account and `backend.tf` file for further use

Example configuration:
```hcl-terraform
module "tf_state" {
  source  = "jacops/tf-state/azurerm"
  version = "0.2.0"


  location      = var.location
  backend_files = [
    {key = "main.tfstate", path = "${path.cwd}/.." }
  ]
}
```