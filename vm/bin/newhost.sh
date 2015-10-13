#!/bin/bash

function error {
	echo "$*"
	echo 'usage: newhost address [hostname] [alias] [category]'
	exit 42
}

if [[ "${1}" ]] 
then
	ADDR=${1}
else
	error "Address required but not given"
fi

if [[ "${2}" ]] 
then
	HOST_NAME=${2}
else
	HOST_NAME=${1}
fi

if [[ "${3}" ]] 
then
	ALIAS=${3}
else
	ALIAS=${1}
fi

if [[ "${4}" ]] 
then
	CATEGORY=${4}
else
	CATEGORY="generic-host"
fi


HOST_TEMPLATE="define host{
	use		${CATEGORY}
	host_name	${HOST_NAME}
	alias		${ALIAS}
	address		${ADDR}
	}"

echo "$HOST_TEMPLATE"
