#!/bin/sh

SCRIPTS_DIR=/home/master/paypal/scripts
REPO_OWNER=pderoxas
REPO_NAME=pos-sdk-dotnet
REPO_DIR=/home/master/paypal/repos/dotnet
LOG_FILE=/logs/cronDownloadReleaseFilesDotnet.log

cd $SCRIPTS_DIR
echo "Downloading Releases..." >> $LOG_FILE
./downloadReleaseFiles.sh -o $REPO_OWNER -r $REPO_NAME -d $REPO_DIR >> $LOG_FILE

