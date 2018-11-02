#!/bin/bash

source config.sh

coreVnetName=$(az network vnet list --output tsv --query "[?tags.networkType=='core'].name")
coreVnetRG=$(az network vnet   list --output tsv --query "[?tags.networkType=='core'].resourceGroup")
coreVnetId=$(az network vnet   list --output tsv --query "[?tags.networkType=='core'].id")

if [ $coreVnetName"FF" = "FF" ]
then
	echo "ERROR - No VNET with tag networkType as core"
	exit
fi

#NAT VNETs
for vnetData in $(az network vnet list --output tsv --query "[?tags.networkType=='nat-spoke-vnet'].{RG: resourceGroup, name: name, id:id}"  | awk '{print $1"_____"$2"_____"$3}')
do
	vnetRG=$(echo $vnetData   | sed 's/_____/ /g' | awk '{print $1}')
	vnetName=$(echo $vnetData | sed 's/_____/ /g' | awk '{print $2}')
	vnetId=$(echo $vnetData   | sed 's/_____/ /g' | awk '{print $3}')
	
	set -x
	az network vnet peering create --name "peering-$vnetName-to-$coreVnetName" --resource-group $vnetRG      --vnet-name $vnetName     --remote-vnet $coreVnetId --allow-vnet-access #--allow-gateway-transit
	az network vnet peering create --name "peering-$coreVnetName-to-$vnetName" --resource-group $coreVnetRG  --vnet-name $coreVnetName --remote-vnet $vnetId     --allow-vnet-access #--use-remote-gateways
	set +x
done

#REGULAR VNETs
for vnetData in $(az network vnet list --output tsv --query "[?tags.networkType=='regular-spoke-vnet'].name")
do
	vnetRG=$(echo $vnetData   | sed 's/_____/ /g' | awk '{print $1}')
	vnetName=$(echo $vnetData | sed 's/_____/ /g' | awk '{print $2}')
	vnetId=$(echo $vnetData   | sed 's/_____/ /g' | awk '{print $3}')
	
	set -x
	az network vnet peering create --name "peering-$vnetName-to-$coreVnetName" --resource-group $vnetRG      --vnet-name $vnetName     --remote-vnet $coreVnetId --allow-vnet-access #--allow-gateway-transit
	az network vnet peering create --name "peering-$coreVnetName-to-$vnetName" --resource-group $coreVnetRG  --vnet-name $coreVnetName --remote-vnet $vnetId     --allow-vnet-access #--use-remote-gateways
	set +x
done
