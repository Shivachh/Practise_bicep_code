param appServicePlanName string
param location string
param skuName string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    capacity: 1
  }
}

output serverFarmId string = appServicePlan.id
