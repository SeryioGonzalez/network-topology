#/bin/bash

resGroupPrefix="gvp"

location="westeurope"

coreVnetName="core_vnet"
coreVnetParameterFile="parameters_core_vnet.json"
coreVnetTemplateFile="template_core_vnet.json"
coreVnetDeploymentName="template_core_vnet"
coreVnetResGroupName=$resGroupPrefix"_vnet_core"

firewallCoreVnetVpnsTemplate="template_firewall_core_vnet_vpns.json"
firewallCoreVnetVpnsParameters="parameters_firewall_core_vnet_vpns.json"

spokeDataFile="data_spoke_vnets.json"
regularSpokeVnetTemplateFile="template_regular_spoke_vnet.json"
natSpokeVnetTemplateFile="template_nat_spoke_vnet.json"

vmssTemplate="template_vmss.json"
vmssParameters="parameters_vmss.json"

telefonicaVnetRG="RG-VP-PRE-NET-01"
telefonicaVnet="VNET-VP-PRE-NET-01"

source credentials.sh