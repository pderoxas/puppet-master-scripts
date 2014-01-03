#!/bin/bash

function echoPlusLog()
{
    local _message="$1"
    local _logPath="$2"
    date_time=`date +%m/%d/%Y" "%H:%M:%S`
    
    echo -e "$_message"
    echo -e "$date_time: $_message" >> "$_logPath"
}
