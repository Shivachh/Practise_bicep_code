using 'main.bicep'

param environmentName = 'dev'
param location = 'centralus'
param appServicePlanSku = {
  name: 'P1v2'
  tier: 'PremiumV2'
}
param appServicePlanInstanceCount = 1