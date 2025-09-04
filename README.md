# Vault/OpenBao setup for GatePlane Services
![License: ElasticV2](https://img.shields.io/badge/ElasticV2-green?style=flat-square&label=license&cacheSeconds=3600&link=https%3A%2F%2Fwww.elastic.co%2Flicensing%2Felastic-license)

## How to use

### Team
Call the module as below for the Team tier:
```hcl
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
```

### Enterprise
Additionally set the custom GatePlane WebUI domain for Enterprise tier:
```hcl
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
```

The output will look like below:
```hcl
{
  "net" = "http://192.168.56.101:8200/v1/identity/oidc/provider/gateplane/.well-known/keys"
  "no-net" = {
    "audience" = "w7bSkpV5Ndie9q027ziVeO8v90B5ePPE"
    "keystore" = "{\"keys\":[{\"alg\":\"RS256\",\"e\":\"AQAB\",\"kid\":\"30cf4ac4-4052-c9d6-ce84-68d506c39459\",\"kty\":\"RSA\",\"n\":\"zitzVsGyC3pX9IsqDhn[eWZKmqUP65Hvy6FvzJY1j8UrvHngwMhdPuJlsXITrYh3m_k-zUwaMpMd
    TZR9QSA_KxT4fAWp0kQuPD5_ijuUnMx4p9TgsKPL5rAP7i97MnYXSPyQW312IrfnovgLTiQpIQ2I6Sv66LFWrd_udZkOJbVOChK2OIBZiXo2eEbFKtmLIyKhnv8WOUJlDSM8HgpFQ3eJ1zXuwYfyU1HA7HM4DwRajC_42UTQDISgJoDXNUmlaAKEXho0hwBv1OzjRgV2IvN-4mj2HF5
    zp7ysh0Gc84FRHDCXcq4V6s0b8RHe4TiZUqsmrVR6gK6EeDy2HP3EksQ\",\"use\":\"sig\"},{\"alg\":\"RS256\",\"e\":\"AQAB\",\"kid\":\"bc7015bf-9c92-75d6-f777-d6eeaee06723\",\"kty\":\"RSA\",\"n\":\"02c9ReStd82MHRx-_ziL8_GMGK70
    frBCRB1AXs292pHSCfgxJy4ExIm2WFIRFx-H3ckVhbcbVTpN_pMDGbe-uy9JBF60RFyfj9LgGFJ8cgrPNHGdVNxYPThqJdOJLmyVYwJ6awZZm5CG-c5ke4wMfdiZ2Wbkny1lqL4FeomZ-cNACoSccGfgfGE2wonh78XzWGN7sEyPAZfCM4uEe9HbycZjNXnLRphvvS0HVj5rznrlaZm
    NvS0IRx4yehdTGzuD7ltxSIkD6kBC5eTtXf2gjprRSrU_Nuhopp2uKugiztAKoDbELXj4Qn_LnjyL0b-PEKHCDeoysfscaB4mKnbSFw\",\"use\":\"sig\"}]}]"
  }
  "webui" = {
    "OpenID Connect Audience" = "w7bSkpV5Ndie9q027ziVeO8v90B5ePPE"
    "identity_provider_name" = "gateplane"
  }
}
```

* The values under `net` must be submitted GatePlane Services if the Vault/OpenBao instance **can accept** Internet connections

* The values under `no-net` must be submitted in case Vault/OpenBao instance is inaccessible from the Internet, located in an **internal network**, or is **air-gapped**.

* [Team tier] The `web-ui` values must be set to the *Configuration* tab of the [GatePlane WebUI](https://app.gateplane.io) (Enterprise users do not need to do that).

## How to enable GatePlane Services

After using this module, send the output field `full_output` to [`services@gateplane.io`](mailto:services@gateplane.io).

The output of this module consists of Public keys and **non-sensitive information** only.

## What it does
This Terraform module enables a Vault/OpenBao instance to use GatePlane Services

* It creates an *OIDC Identity Provider* (IdP) supporting [*Proof Key for Code Exchange* (PKCE)](https://datatracker.ietf.org/doc/html/rfc7636) in Vault/OpenBao

* Creates a Client App for the created IdP (named `gateplane`) and generates its keys

* Creates a `messenger_options` scope providing to the GatePlane Services the relevant Vault/OpenBao Entity Metadata for the messenger application used (used by the Notification service)

* Provides the JSON Web Key Sets (JWKS) and its URI, as well as the OIDC Audience (or client ID), needed to enable [Team or Enterprise tier](https://www.gateplane.io/#pricing) of GatePlane Services.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.2.1 |

## Resources

| Name | Type |
|------|------|
| [vault_identity_oidc_client.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_oidc_client) | resource |
| [vault_identity_oidc_key.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_oidc_key) | resource |
| [vault_identity_oidc_provider.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_oidc_provider) | resource |
| [vault_identity_oidc_scope.messenger_options](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_oidc_scope) | resource |
| [vault_identity_oidc_scope.profile](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_oidc_scope) | resource |
| [vault_identity_oidc_openid_config.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/identity_oidc_openid_config) | data source |
| [vault_identity_oidc_public_keys.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/identity_oidc_public_keys) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_issuer_host"></a> [issuer\_host](#input\_issuer\_host) | The domain and port of the Vault/OpenBao instance (e.g: `vault.example.com:8200`). This will be used as a part of the `iss` JWT claim | `any` | n/a | yes |
| <a name="input_allowed_entities"></a> [allowed\_entities](#input\_allowed\_entities) | A list of Vault/OpenBao Entity IDs that will be allowed to use GatePlane Services. This can be explicitly set to control the seats of the GatePlane Services tier | `list` | <pre>[<br/>  "allow_all"<br/>]</pre> | no |
| <a name="input_gateplane_webui_domain"></a> [gateplane\_webui\_domain](#input\_gateplane\_webui\_domain) | The domain of GatePlane WebUI instance. To be accepted as a valid *Redirect URI* by the created IdP Client. | `string` | `"app.gateplane.io"` | no |
| <a name="input_https_enabled"></a> [https\_enabled](#input\_https\_enabled) | Whether HTTPS is enabled in this Vault/OpenBao endpoint. Used for testing (default `true`) | `bool` | `true` | no |
| <a name="input_jwt_duration_minutes"></a> [jwt\_duration\_minutes](#input\_jwt\_duration\_minutes) | Active period for the issued JWT tokens in minutes (default 4 hours) | `number` | `240` | no |
| <a name="input_key_rotation_days"></a> [key\_rotation\_days](#input\_key\_rotation\_days) | Rotation period for JSON Web Key Sets (JWKS) in days | `number` | `90` | no |
| <a name="input_messenger_entity_metadata"></a> [messenger\_entity\_metadata](#input\_messenger\_entity\_metadata) | Vault/OpenBao Entity metadata field to be set in the `messenger_options` scope, used by GatePlane Services pinging in Notifications (e.g: `["slack_id"]`) | `list` | `[]` | no |
| <a name="input_oidc_provider_name"></a> [oidc\_provider\_name](#input\_oidc\_provider\_name) | The name of the IdP created in Vault/OpenBao | `string` | `"gateplane"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_full_output"></a> [full\_output](#output\_full\_output) | n/a |
| <a name="output_services_idp_details"></a> [services\_idp\_details](#output\_services\_idp\_details) | Provide these values to GatePlane Services in case Vault/OpenBao instance **cannot** accept traffic from the Internet (e.g: air-gapped environments, internal networks) |
| <a name="output_services_jwks_uri"></a> [services\_jwks\_uri](#output\_services\_jwks\_uri) | Provide this value to GatePlane Services in case Vault/OpenBao instance *can* accept traffic from the Internet |
| <a name="output_webui_configuration"></a> [webui\_configuration](#output\_webui\_configuration) | The values to provide in GatePlane WebUI.<br/>`openid_connect_audience` for *OpenID Connect Audience*<br/>`identity_provider_name` for *Identity Provider Name* |


## License

This project is licensed under the [Elastic License v2](https://www.elastic.co/licensing/elastic-license).

This means:

- ✅ You can use, fork, and modify it for **yourself** or **within your company**.
- ✅ You can submit pull requests and redistribute modified versions (with the license attached).
- ❌ You may **not** sell it, offer it as a paid product, or use it in a hosted service (e.g., SaaS).
- ❌ You may **not** re-license it under a different license.

In short: You can use and extend the code freely, privately or inside your business - just don’t build a business around it without our permission.
[This FAQ by Elastic](https://www.elastic.co/licensing/elastic-license/faq) greatly summarizes things.

See the [`./LICENSES/Elastic-2.0.txt`](./LICENSES/Elastic-2.0.txt) file for full details.
