#!/bin/bash
#PRE-REQUISITE: jq library must be installed!!
#http://stedolan.github.io/jq/

#the base url of the git repositories
BASE_URL="http://192.168.1.13:8080/paypal-hiera/hieraData"
CUSTOM_HIERA_DIR="/etc/puppet/hieradata/env/DEV/custom_configs"
GROUP_HIERA_DIR="/etc/puppet/hieradata/env/DEV/group_configs"
DEFAULT_HIERA_DIR="/etc/puppet/hieradata/env/DEV/default_configs"


#construct the releases url
hiera_url="$BASE_URL"
echo "Hiera URL: $hiera_url"
hiera_data=$(curl $hiera_url)
custom_data=$(echo $hiera_data | jq ". | .customConfigs")
group_data=$(echo $hiera_data | jq ". | .groupConfigs")
default_data=$(echo $hiera_data | jq ". | .defaultConfigs")


#echo
#echo "CUSTOM=$custom_data"
#echo 
#echo "GROUP=$group_data"
#echo
#echo "DEFAULT=$default_data"
#echo

find $CUSTOM_HIERA_DIR -mindepth 1 -delete
numberOfCustom=$(echo $custom_data | jq '. | length')
for ((i = 0; i <= numberOfCustom - 1; i++))
do
  curConfig=$(echo $custom_data | jq ".[${i}]")
  curId=$(echo $curConfig | jq ".id" | sed -e 's/^"//'  -e 's/"$//')
  echo $curConfig>$CUSTOM_HIERA_DIR/$curId.json
done

find $GROUP_HIERA_DIR -mindepth 1 -delete
numberOfGroup=$(echo $group_data | jq '. | length')
for ((i = 0; i <= numberOfGroup - 1; i++))
do
  curConfig=$(echo $group_data | jq ".[${i}]")
  curId=$(echo $curConfig | jq ".id" | sed -e 's/^"//'  -e 's/"$//')
  echo $curConfig>$GROUP_HIERA_DIR/$curId.json
done

find $DEFAULT_HIERA_DIR -mindepth 1 -delete
numberOfDefault=$(echo $default_data | jq '. | length')
for ((i = 0; i <= numberOfDefault - 1; i++))
do
  curConfig=$(echo $default_data | jq ".[${i}]")
  curId=$(echo $curConfig | jq ".id" | sed -e 's/^"//'  -e 's/"$//')
  echo $curConfig>$DEFAULT_HIERA_DIR/$curId.json
done

