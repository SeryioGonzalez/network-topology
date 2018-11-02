#!/bin/bash

source config.sh

templateFile=$firewallCoreVnetVpnsTemplate

#CHECK TEMPLATE
echo "LOGGING: Checking template JSON"
cat $templateFile | python3 -m json.tool >> /dev/null  || echo "NOT valid JSON"

resGroupName=$resGroupPrefix"_firewall_core_vnet_vpns"

#CREATE EXECUTOR RESOURCE GROUP 
echo "LOGGING: Creating new resource group $resGroupName"
az group create -l $location -n $resGroupName

#DEPLOY INFRAESTRUCTURE
echo "LOGGING: Deploying spoke template"
set -x
az group deployment create --debug --no-wait --resource-group $resGroupName --template-file "$templateFile" \
		--parameters "@${firewallCoreVnetVpnsParameters}" \
		#--parameters vnet_name="$coreVnetName"  







