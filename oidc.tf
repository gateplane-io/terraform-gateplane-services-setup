# Copyright (C) 2025 Ioannis Torakis <john.torakis@gmail.com>
# SPDX-License-Identifier: Elastic-2.0
#
# Licensed under the Elastic License 2.0.
# You may obtain a copy of the license at:
# https://www.elastic.co/licensing/elastic-license
#
# Use, modification, and redistribution permitted under the terms of the license,
# except for providing this software as a commercial service or product.

resource "vault_identity_oidc_key" "this" {
  name               = "gateplane-services-keys"
  allowed_client_ids = ["*"]
  rotation_period    = 3600 * 24 * var.key_rotation_days
  verification_ttl   = 3600 * 24 * var.key_rotation_days
}

resource "vault_identity_oidc_client" "this" {
  name = "gateplane"
  key  = vault_identity_oidc_key.this.name
  redirect_uris = [
    "https://192.168.56.101:5173/oidc/callback", # Reserved for testing
    "http://localhost:45450/oidc/callback",      # Reserved for the CLI
    "https://${var.gateplane_webui_domain}/oidc/callback",
  ]
  assignments = var.allowed_entities

  id_token_ttl     = 3600 * var.jwt_duration_minutes // 4 hours
  access_token_ttl = 3600 * var.jwt_duration_minutes // Not used at all

  client_type = "public"
}

resource "vault_identity_oidc_scope" "profile" {
  name        = "profile"
  template    = <<JSON
{
  "name": {{identity.entity.name}},
  "groups": {{identity.entity.groups.names}}
}
JSON
  description = "Profile scope"
}

resource "vault_identity_oidc_scope" "messenger_options" {
  name     = "messenger_options" # all these have to be pre-empt with 'messenger_options' to be parsed to a map later
  template = local.messenger_scope_template

  description = "Informs GatePlane Services of Entitie's ID on the Messenger App used for notifications"
}

resource "vault_identity_oidc_provider" "this" {
  name          = var.oidc_provider_name
  https_enabled = var.https_enabled
  issuer_host   = var.issuer_host

  allowed_client_ids = [
    vault_identity_oidc_client.this.client_id
  ]
  scopes_supported = [
    vault_identity_oidc_scope.profile.name,
    vault_identity_oidc_scope.messenger_options.name,
  ]
}


data "vault_identity_oidc_openid_config" "this" {
  name = vault_identity_oidc_provider.this.name
}

data "vault_identity_oidc_public_keys" "this" {
  name = vault_identity_oidc_provider.this.name
}
