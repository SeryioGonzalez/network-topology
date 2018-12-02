#!/bin/bash

source config.sh

templateFile=$vmssTemplate
parametersFile=$vmssParameters

#CHECK TEMPLATE
echo "LOGGING: Checking template JSON"
cat $templateFile | python3 -m json.tool >> /dev/null  || echo "NOT valid JSON"

resGroupName=$resGroupPrefix"_vmss"

vnetId=$(az group deployment show -g $coreVnetResGroupName -n $coreVnetDeploymentName --query properties.outputs.vnetResourceID.value -o tsv)

#CREATE EXECUTOR RESOURCE GROUP 
echo "LOGGING: Creating new resource group $resGroupName"
az group create -l $location -n $resGroupName

#DEPLOY INFRAESTRUCTURE
echo "LOGGING: Deploying spoke template"
set -x
az group deployment create --no-wait --resource-group $resGroupName --template-file "$templateFile" \
		--parameters "@${parametersFile}" \
		--parameters vnetId="$vnetId"  







