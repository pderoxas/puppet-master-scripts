#!/bin/sh

SCRIPTS_DIR=/paypal/scripts
LOCATION_ID="store-01-server"
REPO_OWNER="pderoxas"
REPO_NAME="pos-sdk"
JAVA_SDK_REPO_DIR=/paypal/java_sdk_repo
LOG_FILE=/logs/downloadReleaseFiles.log

cd $SCRIPTS_DIR
echo "Download all the releases from github repository..." >> $LOG_FILE
./downloadReleaseFiles.sh -o $REPO_OWNER -r $REPO_NAME -d $JAVA_SDK_REPO_DIR >> $LOG_FILE
echo "Completed download of all releases" >> $LOG_FILE

