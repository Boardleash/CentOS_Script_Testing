#!/bin/bash

####################
### NETWORK TEST ###
####################
#
# TITLE: network_test_cv1.sh
# AUTHOR: Boardleash (Derek)
# DATE: Sunday, November 17 2024
#
###################
### DESCRIPTION ###
###################
#
# This is a simple script to test network connectivity.
# It will test IPv4 and IPv6 connections (in separate sections).
# This does NOT require escalated privileges to run.
# Tested on CentOS Stream 9 VM (GUI and Server).

################################
### FORMATTING AND VARIABLES ###
################################

brd='\033[1;31m'
bgrn='\033[1;32m'
bcyan='\033[1;36m'
noc='\033[0m'

msg=""
msg_two=""
msg_three=""
msg_four=""

#####################
### INTRODUCTIONS ###
#####################

intro() {
	echo; echo -e ""$bcyan"Hello!  I'm going to look at some things regarding your network.  Please give me a bit..."$noc""; echo
}

#######################
### IPV4 PING TESTS ###
#######################

ip4ping() {
	ping -4 -qc 5 127.0.0.1
	if [ $(echo $?) == 0 ]; then
		msg="Local host IPv4 ping "$bgrn"SUCCESSFUL"$noc"."
	else
		msg="Local host IPv4 ping "$brd"FAILED"$noc"."
	fi
	ping -4 -qc 5 8.8.8.8
	if [ $(echo $?) == 0 ]; then
		msg_two="Outside IPv4 ping "$bgrn"SUCCESSFUL"$noc"."
	else
		msg_two="Outside IPv4 ping "$brd"FAILED"$noc"."
	fi
} > /tmp/.net_results 2> /tmp/.net_result_errors

#######################
### IPV6 PING TESTS ###
#######################

ip6ping() {
	ping -6 -qc 5 ::1
	if [ $(echo $?) == 0 ]; then
		msg_three="Local host IPv6 ping "$bgrn"SUCCESSFUL"$noc"."
	else
		msg_three="Local host IPv6 ping "$brd"FAILED"$noc"."
	fi
	ping -6 -qc 5 2001:4860:4860::8888
	if [ $(echo $?) == 0 ]; then
		msg_four="Outside IPv6 ping "$bgrn"SUCCESSFUL"$noc"."
	else
		msg_four="Outside IPv6 ping "$brd"FAILED"$noc"."
	fi
} >> /tmp/.net_results 2>> /tmp/.net_result_errors

###########################
### NETWORK INFORMATION ###
###########################

getnetinfo() {
	echo -e ""$bcyan"### ROUTING CHECKS ###"$noc""
	netstat -r
	echo; echo -e ""$bcyan"Complete"$noc""; echo
}

#####################
### MAIN FUNCTION ###
#####################

main() {
	intro
	ip4ping
	echo -e ""$bcyan"### IPv4 CHECKS ###"$noc""; echo -e "$msg"; echo -e "$msg_two"; echo
	ip6ping
	echo -e ""$bcyan"### IPv6 CHECKS ###"$noc""; echo -e "$msg_three"; echo -e "$msg_four"; echo
	getnetinfo
	rm /tmp/.net_results /tmp/.net_result_errors
}

###################
### MAIN SCRIPT ###
###################

main

# EOF