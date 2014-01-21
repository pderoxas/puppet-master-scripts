#!/bin/bash
#PRE-REQUISITE: jq library must be installed!!
#http://stedolan.github.io/jq/

#the base url of the git repositories
BASE_URL="http://192.168.1.6:3000"
STORE_HIERA_DIR="/repos/hieradata/store_configs"
GROUP_HIERA_DIR="/repos/hieradata/group_configs"
LOCATION_HIERA_DIR="/repos/hieradata/geo_location_configs"

mkdir -p $STORE_HIERA_DIR
#mkdir -p $GROUP_HIERA_DIR
mkdir -p $LOCATION_HIERA_DIR

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
    curSdk=$(echo $curConfig | jq '.sdk')
    curId=$(echo $curConfig | jq ".name" | sed -e 's/^"//'  -e 's/"$//')
    echo "Saving hiera data to $curHieraDir/$curId.json"
    echo $curSdk > $curHieraDir/$curId.json
  done

}

function saveStoreConfigs() {
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
    curSdk=$(echo $curConfig | jq '.sdk')
    curStores=$(echo $curConfig | jq '.stores')
    echo "curStores=$curStores"

    numberOfStores=$(echo $curStores | jq '. | length')
    echo "numberOfStores=$numberOfStores"
    for ((j = 0; j <= numberOfStores - 1; j++))
    do
       
       curStore=$(echo $curStores | jq ".[${j}]")
       echo "curStore=$curStore"

       curGeoLocation=$(echo $curStore | jq ".geoLocation" | sed -e 's/^"//'  -e 's/"$//')
       curStoreNumber=$(echo $curStore | jq " .storeNumber" | sed -e 's/^"//'  -e 's/"$//')

       mkdir -p $curHieraDir/$curGeoLocation
       echo "Saving $curSdk hiera data to $curHieraDir/$curGeoLocation/$curStoreNumber.json"
       echo $curSdk > $curHieraDir/$curGeoLocation/$curStoreNumber.json
    done

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
#store_data=$(curl $storeConfigs_url)

#echo
#echo "STORE=$store_data"
#echo 
echo "GROUP=$group_data"
#echo
#echo "LOCATION=$location_data"
#echo

#save store hiera data
saveStoreConfigs "$STORE_HIERA_DIR" "$group_data"

#save group hiera data
#saveHieraFiles "$GROUP_HIERA_DIR" "$group_data"

#save location hiera data
saveHieraFiles "$LOCATION_HIERA_DIR" "$location_data"

