#!/bin/bash
#PRE-REQUISITE: jq library must be installed!!
#http://stedolan.github.io/jq/

#the base url of the git repositories
BASE_URL="http://192.168.1.6:3000"
STORE_HIERA_DIR="/etc/puppet/hieradata/env/DEV/store_configs"
GROUP_HIERA_DIR="/etc/puppet/hieradata/env/DEV/group_configs"
LOCATION_HIERA_DIR="/etc/puppet/hieradata/env/DEV/geo_location_configs"

echo "Using web service URL: $BASE_URL"

function saveHieraFiles() {
  curHieraDir=$1
  curData=$2
  #echo $curHieraDir
  #echo $curData

  #purge existing files
  find $curHieraDir -mindepth 1 -delete
  
  #save each config as .json
  numberOfConfigs=$(echo $curData | jq '. | length')
  for ((i = 0; i <= numberOfConfigs - 1; i++))
  do
    curConfig=$(echo $curData | jq ".[${i}]")
    curId=$(echo $curConfig | jq ".name" | sed -e 's/^"//'  -e 's/"$//')
    echo "Saving hiera data to $curHieraDir/$curId.json"
    echo $curConfig>$curHieraDir/$curId.json
  done

}

#construct the releases url
locationConfigs_url="$BASE_URL/locationConfigs"
groupConfigs_url="$BASE_URL/groupConfigs"
storeConfigs_url="$BASE_URL/storeConfigs"

#hiera_data=$(curl $hiera_url)
#store_data=$(echo $hiera_data | jq ". | .storeConfigs")
#group_data=$(echo $hiera_data | jq ". | .groupConfigs")
#location_data=$(echo $hiera_data | jq ". | .locationConfigs")

location_data=$(curl $locationConfigs_url)
group_data=$(curl $groupConfigs_url)
store_data=$(curl $storeConfigs_url)

#echo
#echo "STORE=$store_data"
#echo 
#echo "GROUP=$group_data"
#echo
#echo "LOCATION=$location_data"
#echo

#save store hiera data
saveHieraFiles "$STORE_HIERA_DIR" "$store_data"

#save group hiera data
saveHieraFiles "$GROUP_HIERA_DIR" "$group_data"

#save location hiera data
saveHieraFiles "$LOCATION_HIERA_DIR" "$location_data"

