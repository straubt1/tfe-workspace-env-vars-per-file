variable "prefix" {
  # default = ""
}

resource "random_pet" "main" {
  prefix = var.prefix
}

output "pet" {
  value = random_pet.main.id
}
