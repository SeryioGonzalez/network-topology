#!/bin/bash

source config.sh

templateFile=$vmssTemplate
parametersFile=$vmssParameters

#az login --tenant $telefonicaTenant --subscription $telefonicaSubscription

#CHECK TEMPLATE
echo "LOGGING: Checking template JSON"
cat $templateFile | python3 -m json.tool >> /dev/null  || echo "NOT valid JSON"

resGroupName=$resGroupPrefix"_vmss"

vnetId="/subscriptions/$telefonicaSubscription/resourceGroups/$telefonicaVnetRG/providers/Microsoft.Network/virtualNetworks/$telefonicaVnet"

#CREATE EXECUTOR RESOURCE GROUP 
echo "LOGGING: Creating new resource group $resGroupName"
az group create -l $location -n $resGroupName

#DEPLOY INFRAESTRUCTURE
echo "LOGGING: Deploying spoke template"
set -x
az group deployment create --no-wait --resource-group $resGroupName --template-file "$templateFile" \
		--parameters "@${parametersFile}" \
		--parameters vnetId="$vnetId"  







