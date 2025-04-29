param webAppName string
param location string
param serverFarmId string

resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: serverFarmId
    httpsOnly: true
  }
}
