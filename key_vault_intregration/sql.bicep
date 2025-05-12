param location string
param environmentName string
param solutionName string
param sqlDatabaseSku object
param sqlAdminLoginSecretId string
param sqlAdminPasswordSecretId string

var sqlServerName = '${environmentName}-${solutionName}-sqlserver'
var sqlDBName = '${environmentName}-${solutionName}-slqDB'

// Retrieve the SQL Admin Login and Password from Key Vault secrets
var sqlAdminLogin = reference(sqlAdminLoginSecretId, '2019-09-01').value
var sqlAdminPassword = reference(sqlAdminPasswordSecretId, '2019-09-01').value

resource sqlServer 'Microsoft.Sql/servers@2024-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier
  }
}
