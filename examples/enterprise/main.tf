module "gateplane_services" {
  source = "github.com/gateplane-io/terraform-gateplane-services-setup?ref=0.1.0"

  // replace this with the location of the Vault/OpenBao instance
  issuer_host = "vault.example.com:8200"

  // The Vault/OpenBao Entity metadata field where the MSTeams of each user resides
  messenger_entity_metadata = ["msteams_id"]

  // The custom subdomain of the WebUI assigned to the Enterprise
  gateplane_webui_domain = "myorg.app.gateplane.io"
}

output "gateplane_services_output" {
  value = module.gateplane_services.full_output
}
