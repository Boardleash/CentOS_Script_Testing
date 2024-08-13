#!/bin/bash
#
# TITLE: nocnoc_cv1.sh
# AUTHOR: Boardleash (Derek)
# DATE: Monday, August 12 2024
#
# A simple script that pulls user information on a machine.
# It is recommended to run this with escalated privileges (sudo).
# Tested on CentOS Stream 9 Workstation and CentOS Stream 9 Server (with GUI) VM images.

# Create some formatting variables.
brd='\033[3;31m'
noc='\033[0m'

# Set up an intro function.
intro() {
	echo -e "\n"$brd"Hey there!  Would you like to see who's been on your system?"$noc""
	read -p "                   Yes or No?: " response
}

# Set up the function for if the user DOES want to see who's been on their system.
thedoor() {
	echo -e "\n"$brd"WHO IS RUNNING THIS SCRIPT:"$noc" $(whoami)"
	echo -e "\n"$brd"USERS ALREADY PRESENT ON HOST"$noc"\n"
 	# Check the passwd file for users that currently reside on the host.
	grep "/bin/bash\|/bin/sh\|/bin/csh\|/bin/ksh\|/bin/zsh\|/bin/ion\|/bin/dash\|/bin/ash" /etc/passwd > .your-users
 	# Format the above output to look nice.
	awk -F: '{print $1}' .your-users
	echo -e "\n"$brd"WHO IS LOGGED INTO YOUR MACHINE RIGHT NOW"$noc"\n"
 	# Run the 'w' command to capture who is currently logged in.
	w > .current-logins
 	# Use 'sed' and 'awk' to format the output of the 'w' command to look nice.
	sed '1d' .current-logins > .current-logins-two
	awk '{print $1}' .current-logins-two | sed -e '1d'| sort -u
	echo -e "\n"$brd"WHO HAS ACCESSED YOUR MACHINE"$noc"\n"
 	# Run the 'last' command to see who has successfully logged into your machine.
	last -w > .accessed
 	# Format the above command's output to look nice.
	awk '{print $1}' .accessed | sort -u | sed -e '/wtmp/d' -e '/reboot/d' -e '1d'
	echo -e "\n"$brd"WHO TRIED TO ACCESS YOUR MACHINE"$noc"\n"
 	# Run the 'lastb' command to capture who attempted to login to your machine, but unsuccessfully.
	lastb > .access-attempts
	if [ $(echo $?) == 0 ]; then
 		# If you are running the command with escalated privileges, then present the information nicely.
		sed '$d' .access-attempts > .access-attempts-clean
		sed '$d' .access-attempts-clean > .access-attempts
		awk '{print $1,$3,$4,$5,$6}' .access-attempts
	else
 		# If you are NOT running the command with escalated privileges, then let the user know that.
		echo "You need elevated privileges to see this information."
	fi
	echo -e "\n"$brd"          Knock, Knock!"$noc"\n"
} 2> /dev/null

# Set up main function to run the options.
main() {
	intro
	if [ "$response" == 'Yes' ] || [ "$response" == 'Y' ] || [ "$response" == 'yes' ] || [ "$response" == 'y' ]; then
		thedoor
  		# Clean up the temporary files used to hold relevant information.
		rm .accessed .access-attempts .access-attempts-clean .current-logins .current-logins-two .your-users 2> /dev/null
	elif [ "$response" == 'No' ] || [ "$response" == 'N' ] || [ "$response" == 'no' ] || [ "$response" == 'n' ]; then
		echo -e "\n"$brd"Ah...out of sight, out of mind..."$noc"\n"
	else
		echo -e "\nYou did not enter a vaild response.  Please try again, otherwise, press 'Ctrl+C' to exit this script."
		main
	fi
}

# Run the script.
main

# EOF
