#!/bin/sh

TOKEN='token=xoxp-3057259082-3057259092-3247338018-9890ee'
CHANNEL='channel=C031P7M3E'
TEXT="text=${NAGIOS_DESCRIPTION}"
USR='username=nagiosbot'
URL="https://slack.com/api/chat.postMessage?${TOKEN}&${CHANNEL}&${TEXT}&${USER}"
