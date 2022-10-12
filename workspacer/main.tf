variable "organization_name" {
  default = "terraform-tom"
}

variable "vcs_repo_identifier" {
  default = "straubt1/tfe-workspace-env-vars-per-file"
}

variable "oauth_token_id" {
  default = "ot-Monoqnd7F42rZiwR"
}

locals {
  workspaces = toset(["dev", "stage", "prod"])
}

resource "random_pet" "namespace" {}

resource "tfe_workspace" "this" {
  for_each = local.workspaces

  organization = var.organization_name
  name         = "${random_pet.namespace.id}-ws-${each.key}"

  vcs_repo {
    identifier     = var.vcs_repo_identifier
    oauth_token_id = var.oauth_token_id
  }
}

resource "tfe_variable" "this" {
  for_each = local.workspaces

  workspace_id = tfe_workspace.this[each.key].id

  key         = "TF_CLI_ARGS_plan"
  value       = "-var-file=vars/${each.key}.tfvars"
  category    = "env"
  description = "Set the workspace run to use a vars file within the repository."
}

output "workspaces" {
  value = [for w in tfe_workspace.this : w.name]
}
