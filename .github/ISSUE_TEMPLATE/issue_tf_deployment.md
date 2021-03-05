---
name: Terraform Request - Azure App Service
about: Submit a request to create a new hosting environment for your app
title: Terraform Request for Azure App Service - 
labels: terraform
assignees: ShikhaThakkar

---

### Technical Information
**App Service Configuration:**
Update the below JSON with the appropriate values for the resource (**DO NOT use spaces or underscores**):

```json
{
    "requesting_team": "Team-Name",
    "app_service_name": "Application-Name",
    "location": "eastus",
    "sku_tier": "Standard",
    "sku_size": "S1",
    "tf_cloud_state": "false"
} 
```

### Deployment Slots:
**The following deployment slots will be added:**
- **uat**
- **staging**

### Policies and Compliance
**Required (will be assigned):**
- **HTTP_Version_Latest**: Ensure that 'HTTP Version' is the latest, if used to run the Web app
- **TLS_Version_Latest**: Ensure that 'HTTP Version' is the latest, if used to run the Web app
- **Diagnostic_Logs**: Diagnostic logs in App Services should be enabled
