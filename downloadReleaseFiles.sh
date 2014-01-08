#!/bin/bash
#PRE-REQUISITE: jq library must be installed!!
#http://stedolan.github.io/jq/

#the base url of the git repositories
BASE_URL="http://api.github.com/repos"
OAUTH_TOKEN=8a8a7eb9c55aea24ce3b3a9f01d4a5fdb50904cb
#!/bin/bash
#PRE-REQUISITE: jq library must be installed!!
#http://stedolan.github.io/jq/

#the base url of the git repositories
BASE_URL="https://api.github.com/repos"
OAUTH_TOKEN=8a8a7eb9c55aea24ce3b3a9f01d4a5fdb50904cb

function printUsage()
{
   echo "Usage: downloadReleaseFiles.sh -o <Repo Owner> -r <Repo Name> -t <Release Tag> -d <Directory Path>"
   echo "       -o The owner of the repository    (Required)"
   echo "       -r The name of the repository     (Required)"
   echo "       -d The root repo direcotry        (Required)" 
}

# read and parse input parameters
while getopts o:r:t:d: option; do 
   case $option in
      o) repo_owner=$OPTARG ;;
      r) repo_name=$OPTARG ;;
      d) dir_path=$OPTARG ;;
   esac
done

#check for required parameters
if [[ -z "$repo_owner" ]] || [[ -z "$repo_name" ]] || [[ -z "$dir_path" ]]; then
   printUsage
   echo
   echo "Parameters passed:"
   echo "       -o $repo_owner"
   echo "       -r $repo_name"
   echo "       -d $dir_path"
   exit 1 
fi

#construct the releases url
releases_url="$BASE_URL/$repo_owner/$repo_name/releases"
echo "Releases URL: $releases_url"
#get the releases for the repo
releases=$(curl -u $OAUTH_TOKEN:x-oauth-basic $releases_url)
numberOfReleases=$(echo $releases | jq 'length')
echo "Number of releases for $repo_name: $numberOfReleases"
if [ $numberOfReleases -eq 0 ]; then
   echo "No releases found for owner: $repo_owner, repo: $repo_name"
   exit 1 
fi

tag_name_list=$(echo $releases | jq ".[] | .tag_name")

while read -r tag_name; do
 
   tag_name=$(echo $tag_name | sed -e 's/^"//' -e 's/"$//')
   echo "Tag Name: $tag_name"

   echo "Check if $dir_path/$tag_name exists"
   if [ ! -d "$dir_path/$tag_name" ]; then
      	echo "Tag: $tag_name has not been downloaded yet..."

	#parse out the release id based on the tag
	release_id=$(echo $releases | jq ".[] | select(.tag_name==\"$tag_name\") | .id") 

	#construct the url for the assets for the tagged release
	assets_url="$releases_url/$release_id/assets"
	#echo $assets_url
	#get the assets for the release, -L to handle redirects
	assets=$(curl -u $OAUTH_TOKEN:x-oauth-basic -L $assets_url)
	numberOfAssets=$(echo $assets | jq 'length')
	#echo "numberOfAssets: $numberOfAssets"
	if [ $numberOfAssets -eq 0 ]; then
	   echo "No assets found for tag: $tag_name"
	   exit 1 
	fi
	#parse out the list of asset ids
	asset_id_list=$(echo $assets | jq ".[] | .id")
	#echo "asset_id_list: $asset_id_list"

	#make the version specific repo directory if it does not already exist
	mkdir -p $dir_path/$tag_name

	#per the api doc, send application/octet-stream to download binary files associated to the release
	media_type='application/octet-stream'
	#for each asset, download the file to the defined target directory
	while read -r asset_id; do
	   #echo "id: $asset_id"
	   #parse out the download url and file name
	   #sed -> strip leading/trailing double quotes
	   asset_url=$(echo $assets | jq ".[] | select(.id==$asset_id) | .url" | sed -e 's/^"//'  -e 's/"$//')
	   asset_name=$(echo $assets | jq ".[] | select(.id==$asset_id) | .name" | sed -e 's/^"//'  -e 's/"$//')
	   #echo "asset_url: $asset_url"
	   #echo "asset_name: $asset_name"
	   
	   curl -u $OAUTH_TOKEN:x-oauth-basic -L -o $dir_path/$tag_name/$asset_name --create-dirs -H "Accept: $media_type" $asset_url
	done <<< "$asset_id_list"
   fi                 
done <<< "$tag_name_list"

