param vnetName string
param location string = resourceGroup().location
param vnetAddressPrefix string

@description('Array of subnet configurations')
param subnets array = [
  {
    name: 'subnet1'
    addressPrefix: '10.0.1.0/24'
  }
  {
    name: 'subnet2'
    addressPrefix: '10.0.2.0/24'
  }
]

resource vnet 'Microsoft.Network/virtualNetworks@2024-03-01' = {
    name: vnetName
    location: location
    properties: {
      addressSpace: {
        addressPrefixes: [
          vnetAddressPrefix
        ]
      }
      subnets: [
        for subnet in subnets: {
          name: subnet.name
          properties: {
            addressPrefix: subnet.addressPrefix        
          }
        }
      ]
    }
  }

output vnetId string = vnet.id
output subnetIds array = [for subnet in subnets: '${vnet.id}/subnets/${subnet.name}']
