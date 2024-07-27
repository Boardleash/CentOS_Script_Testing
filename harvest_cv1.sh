#!/bin/bash
#
# TITLE: harvest_cv1.sh
# AUTHOR: Boardleash (Derek)
# DATE: Saturday, July 27 2024
#
# A script that will pull certain host, hardware and user information on a host.
# This information is output to a hidden file called ".harvest" within the /tmp/ directory.
# There is also a separate TXT file (.harvest.txt) for just the information and none of the fancy stuff.
# Tested on RHEL 9 and CentOS Stream 9 Workstation and Server (with GUI) VM images.
# This can be run with escalated privileges if desired.

# Set up some formatting variables.
blinkcyan='\033[6;96m'
green='\033[1;92m'
iorange='\033[3;93m'
orange='\033[1;33m'
reset='\033[0m'

# Capture all output and formatting to be viewed via terminal only (cat).
exec > >(tee -i /tmp/.harvest)

# Set up animation function.
pumpkin() {
	echo -e "
	          $green ****
                 ****
                ****$reset
          $orange+===$reset$green*****$reset$orange===...
      ++=======+$reset$green***$reset$orange+=======...
    ++========================...
   ++============================...
  ++===+$reset$blinkcyan#$reset$orange*==============*$reset$blinkcyan#$reset$orange++=======...
  +==+*$reset$blinkcyan###$reset$orange+===========++$reset$blinkcyan###$reset$orange*+========...
  +=+$reset$blinkcyan######$reset$orange*+===++====+$reset$blinkcyan######$reset$orange*+=====...
  +===++++====+$reset$blinkcyan###$reset$orange+=====++++==========...
  +==========+*$reset$blinkcyan####$reset$orange*===============+=...
  ++===++====*+====++===++====+++=======...
  ++==++$reset$blinkcyan#######################$reset$orange+======...
   +===+*$reset$blinkcyan#####################$reset$orange*+=====...
    ++==+$reset$blinkcyan###$reset$orange**$reset$blinkcyan#####$reset$orange**$reset$blinkcyan####$reset$orange*+$reset$blinkcyan###$reset$orange+====+=...
      +========+=================...
        +===========+==========...
            +++==+++++==+++$reset"
	echo
	echo -e "$iorange     May the harvest be bountiful...$reset"
	echo
}

# Set up introduction function.
intro() {
	echo -e "$orange       Greetings! Is it time?
       Your harvest lies below.
     Should you want to gather it, 
      check your /tmp/ directory.$reset"
  sleep 5s
}

# Set up the harvester function.
harvest() {
	# Set up a separate "tee" to capture ONLY this function's output and place ina  text file.
	exec > >(tee -i /tmp/.harvest.txt)
	echo
	echo "Who is harvesting?: $USER"
	echo "
#################
### HOST INFO ###
#################"
	echo
	hostnamectl | grep "Static hostname\|Operating System\|Kernel\|Hardware Model"
	echo "
#####################
### HARDWARE INFO ###
#####################"
	echo
	lscpu | grep "Model name\|Virtualization"
	echo "
###########
### RAM ###
###########"
	echo
	lsmem | grep "Total"
	echo "
###############
### STORAGE ###
###############"
	echo
	df -h > /tmp/.wheat
	awk '{printf "%-20s %-20s %-20s\n", $1, $2, $5}' /tmp/.wheat
	echo
	lsblk > /tmp/.corn
	awk '{printf "%-20s %-20s %-20s\n", $1, $4, $6}' /tmp/.corn
	echo "
#####################################################
### LOAD AVG (1 minute, 5 minutes and 15 minutes) ###
#####################################################"
	echo
	echo "     For reference, 1.00 = 100% load average."
	echo
	awk '{printf "%-10s %-10s %-10s\n", $1, $2, $3}' /proc/loadavg
	echo "
#######################
### USERS LOGGED IN ###
#######################"
	echo
	w > /tmp/.seed
	sed -i 1d /tmp/.seed
	awk '{printf "%-10s %-10s %-10s\n", $1, $3, $7}' /tmp/.seed
	echo "
#######################
### USER OPEN FILES ###
#######################"
	echo
	lsof -i > /tmp/.sow
	awk '{printf "%-10s %-10s %-10s %-10s %-10s\n", $1, $3, $5, $8, $9}' /tmp/.sow
	echo "
#############
### USERS ###
#############"
	echo
	grep "/bin/bash\|/bin/sh\|/bin/csh\|/bin/ksh\|/bin/zsh\|/bin/ion\|/bin/dash\|/bin/ash" /etc/passwd
	sed -i !d /tmp/.harvest.txt
	echo
}

# Create an "ending" function.
ending() {
	echo -e "$orange Have you collected all you need (Yes/No)?$reset"
	read -p "" -e sunset
	if [ "$sunset" == 'Yes' ] || [ "$sunset" == 'yes' ] || [ "$sunset" == 'Y' ] || [ "$sunset" == 'y' ]; then
	echo
	echo -e "$orange Removing evidence of the harvest...$reset"
	sleep 3s
	rm /tmp/.corn /tmp/.harvest /tmp/.harvest.txt /tmp/.seed /tmp/.sow /tmp/.wheat
	clear
elif [ "$sunset" == 'No' ] || [ "$sunset" == 'no' ] || [ "$sunset" == 'N' ] || [ "$sunset" == 'n' ]; then
	echo
	echo -e "$orange I'll allow you 30 seconds to collect...remember to check your /tmp/ directory!$reset"
	sleep 30s
	echo
	echo -e "$orange Time is up!  Your harvest shall be removed...$reset"
	rm /tmp/.corn /tmp/.harvest /tmp/.harvest.txt /tmp/.seed /tmp/.sow /tmp/.wheat
	clear
else
	echo
	echo -e "$orange Ah, a response worthy of removing the harvest...$reset"
	sleep 3s
	rm /tmp/.corn /tmp/.harvest /tmp/.harvest.txt /tmp/.seed /tmp/.sow /tmp/.wheat
	clear
fi
}

# Create a main function to run all of the functions.
main() {
	pumpkin
	intro
	harvest
	ending
}

# Run the main function.
main

# EOF