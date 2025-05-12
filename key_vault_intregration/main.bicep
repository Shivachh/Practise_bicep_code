param location string = resourceGroup().location

@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string

param appServicePlanSku object

@minLength(5)
@maxLength(50)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

param sqlDatabaseSku object

@secure()
param sqlAdminLogin string

@secure()
param sqlAdminPassword string

// Key Vault module
module keyVault 'key_vault.bicep' = {
  name: 'deployKeyVault'
  params: {
    location: location
    environmentName: environmentName
    solutionName: solutionName
    sqlAdminLogin: sqlAdminLogin
    sqlAdminPassword: sqlAdminPassword
  }
}

// SQL Server module
module sql 'sql.bicep' = {
  name: 'deploySQL'
  params: {
    location: location
    environmentName: environmentName
    solutionName: solutionName
    sqlDatabaseSku: sqlDatabaseSku
    sqlAdminLoginSecretId: keyVault.outputs.sqlAdminLoginSecretId
    sqlAdminPasswordSecretId: keyVault.outputs.sqlAdminPasswordSecretId
  }
  dependsOn: [
    keyVault
  ]
}

// App Service module
module appService 'appService.bicep' = {
  name: 'deployAppService'
  params: {
    location: location
    environmentName: environmentName
    solutionName: solutionName
    appServicePlanSku: appServicePlanSku
  }
  dependsOn: [
    sql
  ]
}
