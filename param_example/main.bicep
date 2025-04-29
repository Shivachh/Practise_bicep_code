@description('The name of the environment. This must be dev, test, or prod.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string

@allowed([
  'eastus'
  'westus'
  'centralus'
])
@description('The location for the resources.')
param location string

@description('The name of the solution.')
@minLength(10)
@maxLength(30)
param solutionName string = 'toyLauncher-${uniqueString(resourceGroup().id)}'

@description('SKU object for App Service Plan.')
param appServicePlanSku object

@description('The number of instances for the App Service Plan.')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int

var appServicePlanName = '${environmentName}-${solutionName}-app'
var appServiceAppName = '${environmentName}-${solutionName}-appservice'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
  }
}

resource appServiceApp 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
