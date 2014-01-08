#!/bin/sh

SCRIPTS_DIR=/home/master/paypal/scripts
REPO_OWNER=pderoxas
REPO_NAME=pos-sdk
REPO_DIR=/home/master/paypal/repos
LOG_FILE=/logs/cronDownloadReleaseFilesJava.log

cd $SCRIPTS_DIR
echo "Downloading Releases..." >> $LOG_FILE
./downloadReleaseFiles.sh -o $REPO_OWNER -r $REPO_NAME -d $REPO_DIR >> $LOG_FILE

