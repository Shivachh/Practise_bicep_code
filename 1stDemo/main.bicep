@allowed([
  'nonprod'
  'prod'
])
param environmentType string

param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param webAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
param storageKind string



var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'
var appServicePlanName = 'appservice-${uniqueString(resourceGroup().id)}'

module storageModule 'storage.bicep' = {
  name: 'storageDeployment'
  params: {
    storageAccountName: storageAccountName
    location: location
    storageKind: storageKind
    storageAccountSkuName: storageAccountSkuName
  }
}

module appServicePlanModule 'appServicePlan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    appServicePlanName: appServicePlanName
    location: location
    skuName: appServicePlanSkuName
  }
}

module webAppModule 'webApplication.bicep' = {
  name: 'webAppDeployment'
  params: {
    webAppName: webAppName
    location: location
    serverFarmId: appServicePlanModule.outputs.serverFarmId
  }
}
