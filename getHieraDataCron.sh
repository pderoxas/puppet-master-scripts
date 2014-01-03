#!/bin/sh

SCRIPTS_DIR=/paypal/scripts
LOG_FILE=/logs/getHieraData.log

cd $SCRIPTS_DIR
echo "Getting hiera data..." >> $LOG_FILE
./getHieraData.sh >> $LOG_FILE

