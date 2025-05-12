using 'main.bicep'

param environmentName = 'dev'
param solutionName = 'toyhrApp'

param sqlDatabaseSku = {
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
}

@secure()
param sqlAdminLogin = 'adminuser'

@secure()
param sqlAdminPassword = 'P@ssw0rd'

param appServicePlanSku = {
  name: 'S1'
  capacity: 1
  tier: 'Standard'
}
