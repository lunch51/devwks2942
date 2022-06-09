#____________________________________________________________
#
# Collect the moid of the VSAN Policy - Add VSAN as an Output
#____________________________________________________________

output "moid" {
  description = "VSAN Policy - Add VSAN Managed Object ID (moid)."
  value       = intersight_fabric_vsan.vsan.moid
}
