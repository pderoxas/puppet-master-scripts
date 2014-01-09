#!/bin/sh

CUR_DATE=`date +%Y-%m-%d`
CUR_DATE_TIME=`date +%Y/%m/%d" "%H:%M:%S`

SCRIPTS_DIR=/home/master/puppet-master-scripts
REPO_OWNER=pderoxas
REPO_NAME=pos-sdk-java
REPO_DIR=/repos/java
LOG_FILE=/logs/$CUR_DATE.downloadReleaseFilesJava.log



cd $SCRIPTS_DIR
echo "$CUR_DATE_TIME Downloading Releases..." >> $LOG_FILE
./downloadReleaseFiles.sh -o $REPO_OWNER -r $REPO_NAME -d $REPO_DIR >> $LOG_FILE
echo
