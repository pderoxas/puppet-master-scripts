#!/bin/sh

SCRIPTS_DIR=/home/master/puppet-master-scripts
LOG_FILE=/home/master/logs/getHieraData.log

cd $SCRIPTS_DIR
echo "Getting hiera data..." >> $LOG_FILE
./getHieraData.sh >> $LOG_FILE

