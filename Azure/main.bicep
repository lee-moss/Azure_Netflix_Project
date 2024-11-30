// Define the subnets array
var subnets = [
  {
    name: 'default'
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: 'AKS'
    addressPrefix: '10.0.1.0/24'
  }
]

module vnetModule 'modules/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    vnetName: 'myVNet'
    vnetAddressPrefix: '10.0.0.0/16'
    subnets: subnets  
  }
}
