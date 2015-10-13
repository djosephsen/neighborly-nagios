#!/bin/bash

OBJ_DIR='/etc/nagios/objects'
HOSTS="${OBJ_DIR}/hosts.cfg"
HOSTGROUPS="${OBJ_DIR}/hostgroups.cfg"

function debug {
#print debugging messages
# $1 error string
	[[ "${DEBUG}" ]] && echo "DEBUG:: $* " >&2
}

function error {
#throw an error and exit
# $1 error string
	echo "ERROR:: $* " >&2
	exit 1
}

function reWriteLine {
# replaces the text $4 on line number $1 in file $2 with the text $3
# $1 line number  $2 filename  $3 replacement text  $4 text to replace
	tmp=$(mktemp)
	cat ${2} | sed -e "${1}s/${3}/${4}/" > ${tmp}
	mv ${tmp} ${2}
	rm -f ${tmp}
}

function insertLine {
# insert text $3 on line number $1 in file $2 (moving the current contents of $1 down one line)
# $1 line number  $2 filename  $3 insert text
	tmp=$(mktemp)
	M=$((${1}-1))
	PRE=$(cat ${2} | sed -ne "1,${M}p")
	POST=$(cat ${2} | sed -ne "${1},\$p")
	echo "${PRE}" > ${tmp}
	echo "${3}" >> ${tmp}
	echo "${POST}" >> ${tmp}
	mv ${tmp} ${2}
	rm -f ${tmp}
}

function deleteLine {
# Delete line number $1 from file $2
	tmp=$(mktemp)
	cat ${2} | sed -e "${1}d" > ${tmp}
	mv ${tmp} ${2}
	rm -f ${tmp}
}
	

function getValue {
#return the attribute value on line $1 of file $2
# $1 Line number   $2 file name
	cat ${2} | sed -ne "${1}p" | awk '{print $2}'
}

function checkMembership {
#return true if $1 is a member of $2
# $1 thing    $2 comma separated list of things
	for i in $(echo ${2} | tr ',' ' ')
	do
		if [ ${i} == ${1} ]
		then
			return 0
		fi
	done
	return 1
}

function findUseLine {
# finds the line number of the use line for host $1
# $1 host name
 	c=0
   while read LINE
   do
      c=$((c+1))
      if echo ${LINE} | egrep -q 'use'
      then
         USE=${c}
      elif echo ${LINE} | grep -q 'host_name'
      then
         HOST=${LINE}
      elif echo ${LINE} | grep -q '}'
      then
         if echo "${HOST}" | grep -q "${1}"
         then
            echo ${USE}
				return
         fi
      fi
   done < ${HOSTS}
}

function findMembersLine {
# finds the line number of the use line for host $1
# $1 host name
 	c=0
   while read LINE
   do
      c=$((c+1))
      if echo ${LINE} | egrep -q 'members'
      then
         MEMBERS=${c}
      elif echo ${LINE} | grep -q 'hostgroup_name'
      then
         HOSTGROUP=${LINE}
      elif echo ${LINE} | grep -q '}'
      then
         if echo "${HOSTGROUP}" | grep -q "${1}"
         then
				if [ -n "${MEMBERS}" ]
				then
            	echo "${MEMBERS}"
				else
					echo "append,${c}"
				fi
				return
         fi
			unset MEMBERS HOSTGROUP
      fi
   done < ${HOSTGROUPS}
}

function setTemplate {
#replace the currently used template for host $1 with template $2
# $1 hostname    $2 template name
	LINE=$(findUseLine "${1}")
	CUR=$(getValue "${LINE}" "${HOSTS}")
	reWriteLine ${LINE} ${HOSTS} "${CUR}" "${2}"
}

function joinGroup {
#Add host $1 to the list of hosts on the members line of hostgroup $2
# $1 hostname    $2 hostgroup
	LINE=$(findMembersLine "${2}")

	if echo ${LINE} | grep -q 'append'
	then
		LN=$(echo ${LINE} | cut -d, -f2)
		insertLine ${LN} ${HOSTGROUPS} "       members        ${1}"
		return
	fi
		
	CUR=$(getValue "${LINE}" "${HOSTGROUPS}")
	if checkMembership ${1} ${CUR}
	then
		error "${1} is already a member of ${2} (${CUR})"
	else
		NEW="${CUR},${1}"
		reWriteLine ${LINE} ${HOSTGROUPS} ${CUR} ${NEW}
	fi
}
		
function leaveGroup {
#remove host $1 from the list of hosts on the members line of hostgroup $2
# $1 hostname    $2 hostgroup
	LINE=$(findMembersLine "${2}")

	if echo ${LINE} | grep 'append'
	then
		error "${2} has no members attribute"
	fi

	CUR=$(getValue "${LINE}" "${HOSTGROUPS}")
	if echo ${CUR} | grep -q ','
	then
		if checkMembership ${1} ${CUR}
		then
			NEW=$(echo ${CUR} | sed -e "s/${1}//" | tr -s ',')
			reWriteLine ${LINE} ${HOSTGROUPS} ${CUR} ${NEW}
		else
			error "${1} is not a member of ${2}"
		fi
	else
		deleteLine ${LINE} ${HOSTGROUPS}
	fi
}
