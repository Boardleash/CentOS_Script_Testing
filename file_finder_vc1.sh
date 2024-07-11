#!/bin/bash
#
# TITLE: file_finder_vc1.sh
# AUTHOR: Boardleash (Derek)
# DATE: Wednesday, July 10 2024
#
# An interactive script, with three options for finding files.
# This particular script has been tested on CentOS Stream 9 VM image.
# Ensure correct permissions have been set (chmod) if having issues running this script.
# This script is not intended to be ran with elevated permissions, but could be.
# Directories and files searched are limited to home directories (for simplicity).
# If deeper searches are preferred, make appropriate changes to code.

# Set up an interactive greeting.
echo
echo "Hello $USER!  Below are three options you may choose from regarding files."
echo
echo "a) Search a user's home directory for files."
echo "b) Search all home directories for files accessed, changed, or modified within 24 hours."
echo "c) Search all home directories for files that are older than 60 days."
echo

# Create function to ask user to make selection and store the answer in a variable called "response".
gotta_question () {
	read -p "Please select from one of the options above by typing a, b or c (all lowercase, NO UPPERCASE): " response
	if [ "$response" == 'a' ] || [ "$response" == 'b' ] || [ "$response" == 'c' ]; then
		# Continue on with script by using "return".
		return	
	else
		echo
		echo "Please respond with the actual letters 'a', 'b' or 'c' (all lowercase)."
		echo
		echo "a) Search a user's home directory for files."
		echo "b) Search all home directories for files accessed, changed, or modified within 24 hours."
		echo "c) Search all home directories for files that are older than 60 days."
		echo
		# Start over if invalid response is given.
		gotta_question
	fi
}
# Create option 'a' function (find files in selected user's home directory (if it exists)).
user_files () {
	echo
	echo "You have selected option 'a'."
	echo
	# Store response as a variable in "username".
	read -p "Please enter a username: " username
	# Create second variable to run command and provide exit code to check against for if statement.
	name_check=$(grep -q "$username" /etc/passwd; echo $?)
	# If character count in "username" variable is less than 2, notify user and try again.
	if [ "${#username}" -lt 2 ]; then
		echo "Please refrain from entering a single character as a username.  You may try again."
		user_files
	# If character count in "username" variable is greater than 32, notify user and try again.
	elif [ "${#username}" -gt 32 ]; then
		echo "This a very large username, and likely, not possible.  You can try again though."
		user_files
	# Assuming character count is within range, utilze the "name_check" variable to grab exit code.
	elif [ "$name_check" == '0' ]; then
		echo "Searching for files that $username owns..." | tee > /tmp/"${username}"_files
		echo >> /tmp/"${username}"_files
		find /home/"$username" -user "$username" -type f >> /tmp/"${username}"_files 2> /tmp/"${username}"_errors
		echo >> /tmp/"${username}"_files
		echo "Files that $username owns have been found and are stored in /tmp/${username}_files. Any errors are in the appropriate errors file."
		echo
	else
		# If "username" variable does not show in /etc/passwd file, notify user and try again.
		echo "$username does not appear to be user here.  Please try again."
		user_files
	fi
}

# Create option 'b' function (files accessed, changed or modified within 24 hours).
recently_accessed () {
	echo
	echo "You have selected option 'b'."
	echo
	echo "Searching for files accessed, changed or modified within 24 hours on this system..."
	{
		echo "Files ACCESSED within 24 hours"
		find /home/* -type f -atime 1
		echo
		echo "Files CHANGED within 24 hours"
		find /home/* -type f -ctime 1
		echo
		echo "Files MODIFIED within 24 hours"
		find /home/* -type f -mtime 1
	} > /tmp/accessed_files 2> /tmp/accessed_files_errors
	echo "Files accessed, changed or modified within 24 hours have been collected and stored in /tmp/accessed_files!"
	echo
}

# Create option 'c' function (files older than 60 days).
old_files () {
	echo
	echo "You have selected option 'c'."
	echo "Searching for files that are older than 60 days..." | tee /tmp/old_files
	find /home/* -mtime +60 -type f >> /tmp/old_files 2> /tmp/old_files_errors
	echo >> /tmp/old_files
	echo "Files older than 60 days have been found and stored in /tmp/old_files!" | tee -a /tmp/old_files
	echo
}

# Set up statements to run the appropriate function based on the user response.
gotta_question
if [ "$response" == 'a' ]; then
	user_files
elif [ "$response" == 'b' ]; then
	recently_accessed
elif [ "$response" == 'c' ]; then
	old_files
fi

# EOF
