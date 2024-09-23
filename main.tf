provider "azurerm" {
  features {}

  subscription_id = "2793aacc-1351-45c4-8d45-c14043796a29"
}

resource "azurerm_management_group" "example_mgmt_group" {
  name         = var.management_group_name
  display_name = var.management_group_display_name
}

resource "azurerm_management_group_subscription_association" "example_association" {
  management_group_id = azurerm_management_group.example_mgmt_group.id
  subscription_id     = var.subscription_id
}
resource "azurerm_resource_group" "ajsentinel" {
  name     = "ajsentinel"
  location = "Central India"
}



resource "azurerm_log_analytics_workspace" "sentinel_laws" {
  name                = "sentineltest"
  location            = azurerm_resource_group.ajsentinel.location
  resource_group_name = azurerm_resource_group.ajsentinel.name
  sku                 = "PerGB2018"
}
# Declare the data source for the existing Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "sentineltest" {
  name                = "sentineltest"   # Your existing Log Analytics Workspace name
  resource_group_name = azurerm_resource_group.ajsentinel.name 
  location            = azurerm_resource_group.ajsentinel.location    # Your existing Resource Group name
}



resource "azurerm_log_analytics_solution" "sentinel_solution" {
  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.ajsentinel.location
  resource_group_name   = azurerm_resource_group.ajsentinel.name
  workspace_resource_id = azurerm_log_analytics_workspace.sentinel_laws.id
  workspace_name        = azurerm_log_analytics_workspace.sentinel_laws.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

resource "azurerm_role_assignment" "sentinel_role_assignment" {
  scope                = azurerm_log_analytics_workspace.sentinel_laws.id
  role_definition_name = "Log Analytics Reader"
  principal_id         = "27a6beff-5df7-4433-b707-4d0eb2f11b3e"  # Replace with user or service principal ID
}
/*
# 4. Auto-provisioning in Security Center
resource "azurerm_security_center_auto_provisioning" "example" {
  auto_provision = "On"   # Enables auto-provisioning.
}

# 5. Alert Rule (Define this as a resource)
resource "azurerm_sentinel_alert_rule" "example_alert_rule" {
  name                = "example-alert-rule"
  resource_group_name = azurerm_resource_group.sentinel_rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel_workspace.id

  query               = "SecurityEvent | where TimeGenerated > ago(1h)"
  query_frequency     = "PT1H"
  query_period        = "PT1H"
  severity            = "Medium"
  tactic              = ["Exploitation"]

  trigger {
    threshold       = 1
    operator        = "GreaterThan"
  }
}

# 6. Automation Rule
resource "azurerm_sentinel_automation_rule" "example" {
  name                       = "example-automation-rule"
  resource_group_name        = azurerm_resource_group.ajsentinel.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel_laws.id

  trigger {
    alert_rule_id = azurerm_sentinel_alert_rule.example_alert_rule.id
  }

  action {
    playbook_id = azurerm_logic_app_workflow.example_playbook.id
  }
}

# 7. Logic App (Playbook) Example
resource "azurerm_logic_app_workflow" "example_playbook" {
  name                = "example-playbook"
  resource_group_name = azurerm_resource_group.ajsentinel.name
  location            = azurerm_resource_group.ajsentinel.location
  definition          = jsonencode({
    // Define your playbook actions here
  })
} */ 
# Enabling Microsoft Entra ID (Azure AD) Data Connector for Sentinel
resource "azurerm_sentinel_data_connector_azure_active_directory" "entra_id_data_connector" {
  name                       = "entra-id-connector"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel_laws.id
}

# Uncomment below if you need to add Virtual Network and Subnet in the future
# Virtual Network
# resource "azurerm_virtual_network" "vnet" {
#   name                = "example-vnet"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.sentinel_rg.location
#   resource_group_name = azurerm_resource_group.sentinel_rg.name
# }

# Subnet
# resource "azurerm_subnet" "subnet" {
#   name                 = "example-subnet"
#   resource_group_name  = azurerm_resource_group.sentinel_rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }



# Azure Sentinel Data Connector for Office 365
resource "azurerm_sentinel_data_connector_office_365" "office365_connector" {
  name                         = "Office365Connector"
  log_analytics_workspace_id    = azurerm_log_analytics_workspace.sentinel_laws.id
  exchange_enabled              = true
  sharepoint_enabled            = true
  teams_enabled                 = true
}

#  TThreat Intelligence Data Connector
resource "azurerm_sentinel_data_connector_threat_intelligence" "threat_intelligence_connector" {
  name                      = "threat-intelligence-connector"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel_laws.id
}

/*#  Threat Intelligence TAXII Data Connector
resource "azurerm_sentinel_data_connector_threat_intelligence_taxii" "threat_intelligence_taxii_connector" {
  name                      = "threat-intelligence-taxii-connector"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel_laws.id
  taxii_server               = "<your_taxii_server_url>"  # Replace with your TAXII Server URL
  collection_id              = "<your_taxii_collection_id>" # Replace with TAXII Collection ID
  
}*/

# Sentinel Alert Rule - Scheduled Rule
resource "azurerm_sentinel_alert_rule_scheduled" "example_alert_rule" {
  name                       = "example-alert-rule"
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.sentinel_laws.id
  display_name               = "Example Scheduled Alert Rule"
  severity                   = "High"
  query                      = "SecurityEvent | where EventID == 4625"
  query_frequency            = "PT5M"
  query_period               = "PT1H"
  trigger_operator           = "GreaterThan"
  trigger_threshold          = 0
  enabled                    = true
  suppression_enabled        = false

  tactics = ["InitialAccess", "Persistence"]

  
}

# Logic App - Playbook
resource "azurerm_logic_app_workflow" "example_playbook" {
  name                = "example-playbook"
  resource_group_name = azurerm_resource_group.ajsentinel.name
  location            = azurerm_resource_group.ajsentinel.location

  
  
  parameters = {
    "exampleParameter" = "exampleValue"  # Direct string assignment
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}




