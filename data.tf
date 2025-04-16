# ===========================================================================
# Data Sources for Gremlin Team Credentials
# ===========================================================================
data "local_file" "gremlin_team_id" {
  filename = var.gremlin_team_id_path
}

data "local_sensitive_file" "gremlin_team_certificate" {
  filename = var.gremlin_team_certificate_path
}

data "local_sensitive_file" "gremlin_team_private_key" {
  filename = var.gremlin_team_private_key_path
}

