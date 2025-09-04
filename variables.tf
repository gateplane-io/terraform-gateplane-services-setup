# Copyright (C) 2025 Ioannis Torakis <john.torakis@gmail.com>
# SPDX-License-Identifier: Elastic-2.0
#
# Licensed under the Elastic License 2.0.
# You may obtain a copy of the license at:
# https://www.elastic.co/licensing/elastic-license
#
# Use, modification, and redistribution permitted under the terms of the license,
# except for providing this software as a commercial service or product.

variable "key_rotation_days" {
  description = "Rotation period for JSON Web Key Sets (JWKS) in days"
  default     = 90
}

variable "jwt_duration_minutes" {
  description = "Active period for the issued JWT tokens in minutes (default 4 hours)"
  default     = 4 * 60 // 4 hours
}

variable "messenger_entity_metadata" {
  description = "Vault/OpenBao Entity metadata field to be set in the `messenger_options` scope, used by GatePlane Services pinging in Notifications (e.g: `[\"slack_id\"]`)"
  default     = []
}

variable "https_enabled" {
  description = "Whether HTTPS is enabled in this Vault/OpenBao endpoint. Used for testing (default `true`)"
  default     = true
}

variable "oidc_provider_name" {
  description = "The name of the IdP created in Vault/OpenBao"
  default     = "gateplane"
}

variable "gateplane_webui_domain" {
  description = "The domain of GatePlane WebUI instance. To be accepted as a valid *Redirect URI* by the created IdP Client."
  default     = "app.gateplane.io"
}

variable "allowed_entities" {
  description = "A list of Vault/OpenBao Entity IDs that will be allowed to use GatePlane Services. This can be explicitly set to control the seats of the GatePlane Services tier"
  default     = ["allow_all"]
}

variable "issuer_host" {
  description = "The domain and port of the Vault/OpenBao instance (e.g: `vault.example.com:8200`). This will be used as a part of the `iss` JWT claim"
}
