variable "tags" {
  type    = map(string)
  default = {}
}

variable "preifx" {
  type    = string
  default = ""
}

variable "role" {
  type    = string
  default = "TerraformState"
}

variable "resource_group_name" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = ""
}

variable "terraform_version" {
  type    = string
  default = "0.12.6"
}

variable "backend_files" {
  type = list(object({
    key: string,
    path: string
  }))
  default = []
}
