terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "1.0.28"
    }
  }
}

provider "intersight" {
    # Configuration options
    apikey    = "62545ef67564612d333560e2/62545ef67564612d333560e7/629139897564612d3304a081"
    secretkey = "/Users/jefdrury/Documents/CiscoLive22/SecretKey1.txt"
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

#__________________________________________________________________
#
# Intersight Network Connectivity Policy
# GUI Location: Policies > Create Policy > Network Connectivity
#__________________________________________________________________

/*
  IPv6 is enabled because this is the only way that the provider allows the
  IPv6 DNS servers (primary and alternate) to be set to something. If it is not
  set to something other than null in this resource, then terraform "apply"
  will detect that thare changes to apply every time ("::" -> null).
*/

resource "intersight_networkconfig_policy" "dns" {
  alternate_ipv4dns_server = length(var.dns_servers_v4) > 1 ? var.dns_servers_v4[1] : null
  alternate_ipv6dns_server = length(var.dns_servers_v6) > 1 ? var.dns_servers_v6[1] : null
  description              = var.dns_description
  dynamic_dns_domain       = var.update_domain
  enable_dynamic_dns       = var.dynamic_dns
  enable_ipv4dns_from_dhcp = var.dynamic_dns == true ? true : false
  enable_ipv6              = var.ipv6_enable
  enable_ipv6dns_from_dhcp = var.ipv6_enable == true && var.dynamic_dns == true ? true : false
  preferred_ipv4dns_server = length(var.dns_servers_v4) > 0 ? var.dns_servers_v4[0] : null
  preferred_ipv6dns_server = length(var.dns_servers_v6) > 0 ? var.dns_servers_v6[0] : null
  name                     = var.dns_name
  #organization {
  #  moid        = var.org_moid
  #  object_type = "organization.Organization"
  #}
  dynamic "profiles" {
    for_each = var.profiles
    content {
      moid        = profiles.value.moid
      object_type = profiles.value.object_type
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
