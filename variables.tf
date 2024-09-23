variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
  default     =  "Mgmt"
}

variable "location" {
  type        = string
  description = "Azure region for the resource group"
  default     = "Central India"

 validation {
    condition     = contains(["Central India", "East US", "West US", "Central US", "North Europe", "West Europe", "Southeast Asia", "Australia East", "Japan East"], var.location)
    error_message = "The location must be one of the specified Azure regions: East US, West US, Central US, North Europe, West Europe, Southeast Asia, Australia East, Japan East."
  }
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of the Log Analytics workspace"
  default     = "sentineltest"
}

variable "management_group_name" {
  description = "The name of the management group."
  type        = string
}

variable "management_group_display_name" {
  description = "The display name of the management group."
  type        = string
}

variable "subscription_id" {
  description = "2793aacc-1351-45c4-8d45-c14043796a29"
  type        = string
}

variable "tenant_id" {
  description = "The ID of the tenant that this Azure Active Directory Data Connector connects to."
  type        = string
  default     = null
}



variable "enable_alerts" {
  description = "(Optional) Whether to enable alerts for the connector. Defaults to true."
  type        = bool
  default     = true
}

variable "enable_discovery_logs" {
  description = "(Optional) Whether to enable discovery logs for the connector. Defaults to true."
  type        = bool
  default     = true
}

variable "data_connectors" {
  description = "(Optional) The list of data connectors to enable for the Azure Security Center Data Connector. Defaults to ['AzureActiveDirectory']."
  type        = string
  default     = "AzureActiveDirectory"
}


