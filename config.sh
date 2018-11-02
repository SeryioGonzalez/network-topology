#/bin/bash

resGroupPrefix="poc"

location="westeurope"

coreVnetName="core_vnet"
coreVnetParameterFile="parameters_core_vnet.json"
coreVnetTemplateFile="template_core_vnet.json"

firewallCoreVnetVpnsTemplate="template_firewall_core_vnet_vpns.json"
firewallCoreVnetVpnsParameters="parameters_firewall_core_vnet_vpns.json"

spokeDataFile="data_spoke_vnets.json"
regularSpokeVnetTemplateFile="template_regular_spoke_vnet.json"
natSpokeVnetTemplateFile="template_nat_spoke_vnet.json"
