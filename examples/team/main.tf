module "gateplane_services" {
  source = "github.com/gateplane-io/terraform-gateplane-services-setup?ref=0.1.0"

  // replace this with the location of the Vault/OpenBao instance
  issuer_host = "vault.example.com:8200"

  // The Vault/OpenBao Entity metadata field where the SlackID of each user resides
  messenger_entity_metadata = ["slack_id"]

  /*
    You can explicitly set which users take up the license seats,
    or omit to allow everyone in Vault/OpenBao to connect
  allowed_entities = [
    # Vault/OpenBao Entity IDs:
    "c15cfc49-ecb1-4771-9b86-3139d8f37223",
    "0b9faf28-e043-45ef-8cc3-9ad83123af20",
    ...
  ]
  */
}

output "gateplane_services_output" {
  value = module.gateplane_services.full_output
}
