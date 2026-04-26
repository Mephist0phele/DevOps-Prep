locals {
  # Use the first subnet from subnet_ids list if available, otherwise use subnet_id
  primary_public_subnet = try(var.subnet_ids[0], var.subnet_id)
}
