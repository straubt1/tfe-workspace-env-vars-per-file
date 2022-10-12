variable "prefix" {
  # default = ""
}

resource "random_pet" "main" {
  prefix = var.prefix
}
