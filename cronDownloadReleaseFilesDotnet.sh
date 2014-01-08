#!/bin/sh

SCRIPTS_DIR=/home/master/puppet-master-scripts
REPO_OWNER=pderoxas
REPO_NAME=pos-sdk-dotnet
REPO_DIR=/repos/dotnet
LOG_FILE=/home/master/logs/cronDownloadReleaseFilesDotnet.log

cd $SCRIPTS_DIR
echo "Downloading Releases..." >> $LOG_FILE
./downloadReleaseFiles.sh -o $REPO_OWNER -r $REPO_NAME -d $REPO_DIR >> $LOG_FILE

