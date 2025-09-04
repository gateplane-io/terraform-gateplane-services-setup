# Copyright (C) 2025 Ioannis Torakis <john.torakis@gmail.com>
# SPDX-License-Identifier: Elastic-2.0
#
# Licensed under the Elastic License 2.0.
# You may obtain a copy of the license at:
# https://www.elastic.co/licensing/elastic-license
#
# Use, modification, and redistribution permitted under the terms of the license,
# except for providing this software as a commercial service or product.

locals {
  messenger_scope_template = <<JSON
{
${
  join(",\n", [
    for option in var.messenger_entity_metadata :
    "\"messenger_options_${option}\": {{identity.entity.metadata.${option}}}"
  ])
}
}
JSON

webui_configuration = {
  "OpenID Connect Audience" = vault_identity_oidc_client.this.client_id,
  "identity_provider_name"  = vault_identity_oidc_provider.this.name
}

services_jwks_uri = data.vault_identity_oidc_openid_config.this.jwks_uri
services_idp_details = {
  "audience" = vault_identity_oidc_client.this.client_id,
  "keystore" = jsonencode({ "keys" = data.vault_identity_oidc_public_keys.this.keys })
}
}
