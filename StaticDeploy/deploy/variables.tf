variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "region" {
  default = "us-west-2"
}

variable "static_bucket_name" {
  default = "nguyenquybao"
}

locals {
  mime_types = jsondecode(file("./content-type.json"))
}