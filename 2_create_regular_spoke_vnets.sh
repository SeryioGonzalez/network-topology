#!/bin/bash

source config.sh

if [ $1"FF" != "FF" ]
then
	spokeDataFile=$1
fi

spokeType="regular_spoke_vnets"
templateFile=$regularSpokeVnetTemplateFile

#CHECK TEMPLATE
echo "LOGGING: Checking template JSON"
cat $templateFile | python3 -m json.tool >> /dev/null  || echo "NOT valid JSON"

echo "LOGGING: Reading spoke data"
numSpokes=$(jq -r ".$spokeType | length" $spokeDataFile)
numSpokes=$( expr $numSpokes - 1 )

for spokeIndex in $(seq 0 $numSpokes)
do
	echo "LOGGING: Reading spoke $spokeIndex data"

	spoke_vnet_name=$(jq -r           ".$spokeType[$spokeIndex].vnet_name"           $spokeDataFile)	
	spoke_vnet_cidr=$(jq -r           ".$spokeType[$spokeIndex].vnet_cidr"           $spokeDataFile)
	spoke_GatewaySubnet_cidr=$(jq -r  ".$spokeType[$spokeIndex].GatewaySubnet_cidr"  $spokeDataFile)
	
	resGroupName=$resGroupPrefix"_vnet_spoke_"$spoke_vnet_name

	#CREATE EXECUTOR RESOURCE GROUP 
	echo "LOGGING: Creating new resource group $resGroupName"
	az group create -l $location -n $resGroupName

	#DEPLOY INFRAESTRUCTURE
	echo "LOGGING: Deploying spoke template"
	set -x
	az group deployment create --no-wait --resource-group $resGroupName --template-file "$templateFile" \
		--parameters "@${coreVnetParameterFile}" \
		--parameters vnet_name="$spoke_vnet_name"  \
		--parameters spoke_vnet_cidr="$spoke_vnet_cidr"  \
		--parameters spoke_GatewaySubnet_cidr="$spoke_GatewaySubnet_cidr" 
	set +x	
	
done







