# Copyright (C) 2025 Ioannis Torakis <john.torakis@gmail.com>
# SPDX-License-Identifier: Elastic-2.0
#
# Licensed under the Elastic License 2.0.
# You may obtain a copy of the license at:
# https://www.elastic.co/licensing/elastic-license
#
# Use, modification, and redistribution permitted under the terms of the license,
# except for providing this software as a commercial service or product.

output "webui_configuration" {
  description = "The values to provide in GatePlane WebUI.\n`openid_connect_audience` for *OpenID Connect Audience*\n`identity_provider_name` for *Identity Provider Name*"
  value       = local.webui_configuration
}

output "services_jwks_uri" {
  description = "Provide this value to GatePlane Services in case Vault/OpenBao instance *can* accept traffic from the Internet"
  value       = local.services_jwks_uri
}

output "services_idp_details" {
  description = "Provide these values to GatePlane Services in case Vault/OpenBao instance **cannot** accept traffic from the Internet (e.g: air-gapped environments, internal networks)"
  value       = local.services_idp_details
}

output "full_output" {
  value = {
    "webui"  = local.webui_configuration,
    "net"    = local.services_jwks_uri,
    "no-net" = local.services_idp_details,
  }
}
