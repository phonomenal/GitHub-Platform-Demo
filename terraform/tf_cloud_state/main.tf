terraform {
  required_version = "~> 0.14.0"
  required_providers {
    azurerm = "~> 2.33.0"
  }
  backend "remote" {
    organization = "phonomenal"

    workspaces {
      name = "AzureAppService-State"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

variable "app_service_name" {
  type        = string
  default     = "Phonomenal-App-Demo"
  description = "The requested name for the Azure App Service, must be unique"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "The Azure region location for the Resource Group where instances will be created"

  validation {
    condition     = contains(["eastus", "eastus2", "centralUS", "northcentralus", "southcentralus"], var.location)
    error_message = "The Azure region location needs to be one of the approved choices."
  }
}

variable "requesting_team" {
  type        = string
  default     = "solutionsengineers"
  description = "The name of the team requesting these Azure resources"

}

variable "sku_tier" {
  type        = string
  default     = "Standard"
  description = "The Azure SKU Tier for the requested Resource"

}
variable "sku_size" {
  type        = string
  default     = "S1"
  description = "The Azure SKU Size for the requested Resource"

}

variable "registry_username" {
  type        = string
  default     = "user@github.com"
  description = "The name of the team requesting these Azure resources"

}

variable "registry_password" {
  type        = string
  default     = "patvalue12345"
  description = "The name of the team requesting these Azure resources"

}


locals {
  service_name = "${var.requesting_team}-web"

  tags = {
    "OWNER"     = "octodemo-org"
    "TEAM"      = var.requesting_team
    "TERRAFORM" = "true"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.requesting_team}-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_app_service_plan" "main" {
  name                = "${local.service_name}-appservice"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  kind                = "Linux"
  reserved            = true

  sku {
    tier = var.sku_tier
    size = var.sku_size
  }
}

resource "azurerm_app_service" "main" {
  name                = var.app_service_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    linux_fx_version = "DOCKER|ghcr.io/octodemo/demoday-node:bootstrap"
    always_on        = "true"
  }
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://ghcr.io/"
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.registry_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.registry_password
    "WEBSITES_PORT"                   = "8000"
  }
}

resource "azurerm_app_service_slot" "staging" {
  name                = "STAGING"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id
  app_service_name    = azurerm_app_service.main.name

  site_config {
    linux_fx_version = "DOCKER|ghcr.io/octodemo/demoday-node:bootstrap"
    always_on        = "true"
  }
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://ghcr.io/"
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.registry_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.registry_password
    "WEBSITES_PORT"                   = "8000"
  }
}

resource "azurerm_app_service_slot" "uat" {
  name                = "UAT"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id
  app_service_name    = azurerm_app_service.main.name

  site_config {
    linux_fx_version = "DOCKER|ghcr.io/octodemo/demoday-node:bootstrap"
    always_on        = "true"
  }
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://ghcr.io/"
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.registry_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.registry_password
    "WEBSITES_PORT"                   = "8000"
  }
}

resource "azurerm_policy_assignment" "Diagnostic_Logs" {
  name                 = "Diagnostic_Logs"
  scope                = azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b607c5de-e7d9-4eee-9e5c-83f1bcee4fa0"

}

resource "azurerm_policy_assignment" "HTTP_Version_Latest" {
  name                 = "HTTP_Version_Latest"
  scope                = azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/8c122334-9d20-4eb8-89ea-ac9a705b74ae"

}

resource "azurerm_policy_assignment" "TLS_Version_Latest" {
  name                 = "TLS_Version_Latest"
  scope                = azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b"

}
