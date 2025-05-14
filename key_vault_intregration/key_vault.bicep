param location string
param environmentName string
param solutionName string

@secure()
param sqlAdminLogin string

@secure()
param sqlAdminPassword string

var keyVaultName = '${environmentName}-${solutionName}-kv'

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
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
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: '00000000-0000-0000-0000-000000000000' // Replace with your deployment identity's objectId
        permissions: {
          secrets: [
            'get'
            'list'
            'set'
          ]
        }
      }
    ]
  }
}

resource sqlAdminLoginSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: keyVault
  name: 'sqlAdminLogin'
  properties: {
    value: sqlAdminLogin
  }
}

resource sqlAdminPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: keyVault
  name: 'sqlAdminPassword'
  properties: {
    value: sqlAdminPassword
  }
}

output sqlAdminLoginSecretId string = sqlAdminLoginSecret.id
output sqlAdminPasswordSecretId string = sqlAdminPasswordSecret.id
