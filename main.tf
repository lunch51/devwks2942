terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "1.0.36"
    }
  }
}

provider "intersight" {
    # Configuration options
    apikey    = "62545ef67564612d333560e2/62545ef67564612d333560e7/629139897564612d3304a081"
    secretkey = "/home/devnet/devwks2121/secretkey.txt"
    endpoint = "https://intersight.com" 
}

#__________________________________________________________________
#
# Intersight NTP Policy
# GUI Location: Policies > Create Policy > NTP
#__________________________________________________________________

resource "intersight_ntp_policy" "ntp" {
  description = var.ntp_description
  enabled     = var.enabled
  name        = var.ntp_name
  ntp_servers = var.ntp_servers
  timezone    = var.timezone
  #organization {
  #  moid        = var.org_moid
  #  object_type = "organization.Organization"
  #}
  dynamic "authenticated_ntp_servers" {
    for_each = var.authenticated_ntp_servers
    content {
      key_type      = "SHA1"
      object_type   = authenticated_ntp_servers.value.object_type
      server_name   = authenticated_ntp_servers.value.server_name
      sym_key_id    = authenticated_ntp_servers.value.sym_key_id
      sym_key_value = authenticated_ntp_servers.value.sym_key_value
    }
  }
  dynamic "profiles" {
    for_each = var.ntp_profiles
    content {
      moid        = profiles.value.moid
      object_type = profiles.value.object_type
    }
  }
  dynamic "tags" {
    for_each = var.ntp_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}