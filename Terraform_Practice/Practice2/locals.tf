locals {
  # Naming convention
  resource_name = "${var.project_name}-${var.environment}"

  # Process the subnet list - use try to safely handle empty list
  primary_public_subnet = try(var.subnet_ids[0], var.subnet_id)
  subnet_count          = length(var.subnet_ids)

  # Environmental deployment settings
  is_production      = var.environment == "prod"
  monitoring_enabled = var.monitoring || local.is_production
}