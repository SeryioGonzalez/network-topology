#!/bin/bash

source config.sh

resGroupPrefix=$resGroupPrefix

#READING RESOURCE GROUPS
echo "LOGGING: DELETING RESOURCE GROUPS WITH PREFIX $resGroupPrefix in name"

for purgable in $(az group list --output tsv | awk '{ print $4}' | grep "^$resGroupPrefix")
do
	az group delete --yes --no-wait --name $purgable
done


