#!/bin/sh

CUR_DATE=`date +%Y-%m-%d`
CUR_DATE_TIME=`date +%Y/%m/%d" "%H:%M:%S`
SCRIPTS_DIR=/home/master/puppet-master-scripts
LOG_FILE=/logs/$CUR_DATE.getHieraData.log

cd $SCRIPTS_DIR
echo "$CUR_DATE_TIME Getting hiera data..." >> $LOG_FILE
./getHieraData.sh >> $LOG_FILE
echo
