param location string
param environmentName string
param solutionName string

@secure()
param sqlAdminLogin string

@secure()
param sqlAdminPassword string

var keyVaultName = '${environmentName}-${solutionName}-kv'

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
  }
}

// Create the secret for SQL Admin Login
resource sqlAdminLoginSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: 'sqlAdminLogin'
  parent: keyVault
  properties: {
    value: sqlAdminLogin
  }
}

// Create the secret for SQL Admin Password
resource sqlAdminPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: 'sqlAdminPassword'
  parent: keyVault
  properties: {
    value: sqlAdminPassword
  }
}

// Output the secret IDs for SQL Admin Login and Password
output sqlAdminLoginSecretId string = sqlAdminLoginSecret.id
output sqlAdminPasswordSecretId string = sqlAdminPasswordSecret.id
