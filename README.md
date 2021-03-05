<p align="center">
  <img src=".github/img/github_infocus.png" height=200  >
</p>

# Welcome

As feature in Infocus Series 2021 - [Automating CI/CD and security on a single platform with GitHub Enterprise](https://infocus.github.com/sessions/automating-ci-cd-and-security-on-a-single-platform-with-github-enterprise/)

This nodejs app will allow you to search for any GitHub user by their handle!

Leverage the GitHub Platform to build, test, containerize, deploy, and secure your code.

## Getting Started

### Generate Azure Service Principal
To deploy to Azure you will need to create a service principal. You can do that with the following command:

```sh
az ad sp create-for-rbac --name {yourServicePrincipalName} --role contributor \
                            --scopes /subscriptions/{subscription-id} \
                            --sdk-auth

  # Replace {yourServicePrincipalName}, {subscription-id} with the a service principal name and subscription id.

  # The command should output a JSON object similar to the example below

  {
    "clientId": "<GUID>",
    "clientSecret": "<GUID>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>",
    (...)
  }
```

### Generate Azure Service Principal for Policy Assignment

```sh
  az ad sp create-for-rbac --name {ServicePrincipalName} --role owner \
                              --scopes /subscriptions/{subscription-id} \
                              --skip-assignment false \
                              --sdk-auth
 ```

 *This service principal does the work but is probably way too powerful for what you need, you might want to consider reducing its privileges, check the [docs](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest) to know more!*
  
### Creating GitHub Secrets for Azure Service Principal
Add the JSON output as the following secrets in the GitHub repository:

> `TF_VAR_agent_client_id` 

> `TF_VAR_agent_client_secret` 

> `TF_VAR_subscription_id` 

> `TF_VAR_tenant_id` 

For steps to create and storing secrets, please check [here](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets)

These secrets are assigned in the workflow .yml files for the AzureRM Provider Argument References found [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#argument-reference)

> `ARM_CLIENT_ID: ${{ secrets.TF_VAR_agent_client_id }}`

> `ARM_CLIENT_SECRET: ${{ secrets.TF_VAR_agent_client_secret }}`

> `ARM_SUBSCRIPTION_ID: ${{ secrets.TF_VAR_subscription_id }}`

> `ARM_TENANT_ID: ${{ secrets.TF_VAR_tenant_id }}`

### Creating GitHub Secrets for Terraform Cloud Token
Add the the following secrets in the GitHub repository:

> `TF_TOKEN` 

Generated from your Terraform Cloud User Account (if using Terraform Cloud for state management). See [Terraform API Tokens](https://www.terraform.io/docs/cloud/users-teams-organizations/users.html#api-tokens).

### Creating GitHub Secrets for GitHub Container Registry Token
Add the the following secrets in the GitHub repository:

> `GHCR_PASSWORD` 

See [About scopes and permissions for GitHub Container Registry](https://docs.github.com/en/packages/guides/about-github-container-registry#about-scopes-and-permissions-for-github-container-registry)

## How to Use

### Run App Locally:

1. Fork/Clone Repo
2. Open in Codespaces or IDE of your choice
3. `npm install`
4. `npm run test`
5. `npm run dev`

### Run in container

1. `docker build --tag nodejs-demo .`
2. `docker run -p 8000:8000 nodejs-demo`

### Run from container image
1. `docker run -it -p 8000:8000 ghcr.io/octodemo/demoday-node:<tag> /bin/bash`

### Demo Flow
1. Create a new issue using the issue template: "Terraform Request - Azure App Service"
2. Fill out required JSON body fields for the Azure App Service
3. Add a comment to the issue that includes the trigger string '/approved'
4. GitHub Action will kick off generating:
    - an Azure Resource Group, App Service plan and App Service (with deployment slots)
    - GitHub Environments (for UAT and STAGING - will include protection rules for STAGING)
5. Create an environment secret for the two generate environments with a value for the **AZURE_WEBAPP_PUBLISH_PROFILE** downloaded from the Azure App Service slots
5. Create a New PR, include in the JSON body the issue # from *step 4*
6. Deploy Container via PR workflow will trigger performing:
    - Issue Ops grabbing Azure resource values from the TF request Issue
    - Build and Test 
    - Build and Deploy to GHCR 
    - Deploying to UAT and STAGING Slots for Azure Web App
8. Close the Issue to perform an Azure Resource Teardown and deletion of the generated Environments and Deployments

## Reference Material
### Docs
- [Environments - GitHub Docs](https://docs.github.com/en/free-pro-team@latest/actions/reference/environments)
- [GitHub + Microsoft Teams Integration](https://github.com/integrations/microsoft-teams)
- [GitHub Container Registry - GitHub Docs](https://docs.github.com/en/packages/guides/about-github-container-registry)
- [Deploy to App Service using GitHub Actions - Microsoft Docs](https://docs.microsoft.com/en-us/azure/app-service/deploy-github-actions?tabs=applevel)
- [Terraform Workspaces - HashiCorp Docs](https://www.terraform.io/docs/cloud/workspaces/index.html)
- [GitHub Codespaces](https://github.com/features/codespaces)

### Some of the Actions Featured!
- [HashiCorp - Setup Terraform](https://github.com/marketplace/actions/hashicorp-setup-terraform)
- [Issue Body Parser](https://github.com/marketplace/actions/issue-body-parser)
- [Build and push Docker Images](https://github.com/marketplace/actions/build-and-push-docker-images)
- [Azure WebApp](https://github.com/marketplace/actions/azure-webapp)


## Feedback?

Open a discussion thread in this repo!

Participate in our Support Community for Code-to-Cloud:

- https://github.community/c/code-to-cloud/52
