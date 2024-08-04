#!/bin/bash
#
# TITLE: file_creator_cv1.sh
# AUTHOR: Boardleash (Derek)
# DATE: Sunday, August 4 2024
#
# A script to create test files in various formats for TEST environments.
# A use-case for this is to create random files to test out a script or function on, without impacting other files.
# Tested on CentOS Stream 9 Workstation and Server (with GUI) VM images.
# There is also a "cleanup" function that will remove the created test files if they exist,
# but only in the directories mentioned in this script if they are there.
# If you do not want to cleanup the test files, just type "No" when prompted by the cleanup function.
# Alternatively, you can comment out the cleanup function, if desired.

# Create intro function.
intro() {
	echo -e "\nHello! I am the FILE CREATOR.  I will create various types of files in the location that you select."
	echo "Below is a list of five options:
	a) /home/$USER/Documents/
	b) /home/ $USER/Downloads/
	c) /tmp/
	d) /home/$USER/
	e) /home/$USER/test/" # This option creates a 'test' directory in the user's home directory.
	read -p "Which directory would you prefer the test files to be created in? (a, b, c, d, OR, e): " response	
}

# Create response "a" function.  This function will create test files under the 'Documents' directory.
response_a() {
	# Set up an if/else statement to check for two different formats of a 'documents' directory on the user home directory.
	if [[ $(ls /home/$USER/ | grep document -i) == 'Documents' ]]; then
		# Change into the 'Documents' directory.
		cd /home/$USER/Documents/ || exit
		# Set up a for loop to only iterate 3 times.
		for x in {1..3}; do
			# Create 3 of each file extension.  The files will have '1', '2', and '3' as part of their name.
			touch file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png
		done
		# Let user know that the test files have been created.
		echo -e "\nThree files of each various extensions have been successfully created in the 'Documents' directory.\n"
	elif [[ $(ls /home/$USER/ | grep document -i) == 'documents' ]]; then
		# Change into the 'documents' directory.
		cd /home/$USER/documents/ || exit
		# Set up a for loop to only iterate 3 times.
		for x in {1..3}; do
			# Create 3 of each file extension.  The files will have '1', '2', and '3' as part of their name.
			touch file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png
		done
		# Let user know that the test files have been created.
		echo -e "\nThree files of each various extensions have been successfully created in the 'documents' directory.\n"
	else
		# Create the 'Documents' directory, if it is found to have not existed.
		mkdir -p /home/$USER/Documents/
		# Change into the 'Documents' directory.
		cd /home/$USER/Documents/ || exit
		# Set up a for loop to only iterate 3 times.
		for x in {1..3}; do
			# Create 3 of each file extension.  The files will have '1', '2', and '3' as part of their name.
			touch file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png
		done
		# Let user know that a 'Documents' directory has been created and the test files have been created.
		echo -e "\nA 'Documents' directory has been created and three files of each various extensions have been successfully created in that directory.\n"

	fi
}

# Create response "b" function.  This function will create test files under the 'Downloads' directory.
response_b() {
	# Set up an if/else statement to check for two different formats of a 'downloads' directory on the user home directory.
	if [[ $(ls /home/$USER/ | grep download -i) == 'Downloads' ]]; then
		# Change into the 'Downloads' directory.
		cd /home/$USER/Downloads/ || exit
		# Set up a for loop to only iterate 3 times.
		for x in {1..3}; do
			# Create 3 of each file extension.  The files will have '1', '2', and '3' as part of their name.
			touch file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png
		done
		# Let user know that the test files have been created.
		echo -e "\nThree files of each various extensions have been successfully created in the 'Downloads' directory.\n"
	elif [[ $(ls /home/$USER/ | grep download -i) == 'downloads' ]]; then
		# Change into the 'downloads' directory.
		cd /home/$USER/downloads/ || exit
		# Set up a for loop to only iterate 3 times.
		for x in {1..3}; do
			# Create 3 of each file extension.  The files will have '1', '2', and '3' as part of their name.
			touch file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png
		done
		# Let user know that the test files have been created.
		echo -e "\nThree files of each various extensions have been successfully created in the 'downloads' directory.\n"
	else
		# Create the 'Downloads' directory, if it is found to have not existed.
		mkdir -p /home/$USER/Downloads/
		# Change into the 'Downloads' directory.
		cd /home/$USER/Downloads/ || exit
		# Set up a for loop to only iterate 3 times.
		for x in {1..3}; do
			# Create 3 of each file extension.  The files will have '1', '2', and '3' as part of their name.
			touch file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png
		done
		# Let user know that a 'Downloads' directory has been created and the test files have been created.
		echo -e "\nA 'Downloads' directory has been created and three files of each various extensions have been successfully created in that directory.\n"

	fi
}

# Create response "c" function.  This function will create test files under the '/tmp' directory.
response_c() {
	# Change into the '/tmp' directory.
	cd /tmp/ || exit
	# Set up a for loop to iterate 3 times.
	for x in {1..3}; do
		# Create 3 of each file extension.  The files will have '1', '2', and '3' as part of their name.
		touch file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png
	done
	# Let user know that the test files have been created.
	echo -e "\nThree files of each various extensions have been successfully created in the /tmp/ directory.\n"
}

# Create response "d" function.  This function will create test files under the user's home directory.
response_d() {
	# Change into the user's home directory.
	cd /home/$USER/ || exit
	# Set up a for loop to iterate 3 times.
	for x in {1..3}; do
		# Create 3 of each file extension.  The files will have '1', '2', and '3' as part of their name.
		touch file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png
	done
	echo -e "\nThree files of each various extensions have been successfully created in the current user's home directory.\n"
}

# Create response "e" function.  This function will create a 'test' directory in the user's home directory, then create files under that directory.
response_e() {
	mkdir -p /home/$USER/test/
	cd /home/$USER/test/ || exit
	for x in {1..3}; do
		touch file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png
	done
	echo -e "\nA 'test' directory has been created and three files of each various extensions have been successfully createtd in that directory.\n"
}

# Create a cleanup function.
cleanup() {
	echo -e "\nDo you want to remove all of the test files that were created?"
	read -p "Yes or No?: " response
	if [ "$response" == 'Yes' ] || [ "$response" == 'yes' ] || [ "$response" == 'Y' ] || [ "$response" == 'y' ]; then
		if [[ $(ls /home/$USER/ | grep document -i) == 'Documents' ]] || [[ $(ls /home/$USER/ | grep document -i) == 'documents' ]]; then
			# Cleanup test files in either 'Documents' or 'documents' directory.
			cd /home/$USER/Documents/ || cd /home/$USER/documents/ || exit
			for x in {1..3}; do
				rm file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png 2> /dev/null
			done
		else
			sleep 0.1
		fi
		if [[ $(ls /home/$USER/ | grep download -i) == 'Downloads' ]] || [[ $(ls /home/$USER/ | grep download -i) == 'downloads' ]]; then
			# Cleanup test files in either 'Downloads' or 'downloads' directory.
			cd /home/$USER/Downloads/ || cd /home/$USER/downloads || exit
			for x in {1..3}; do
				rm file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png 2> /dev/null
			done
		else
			sleep 0.1
		fi
		if [[ $(ls /home/$USER/ | grep test) == 'test' ]];then
			# Cleanup test files in the 'test' directory.
			cd /home/$USER/test/ || exit
			for x in {1..3}; do
				rm file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png 2> /dev/null
			done
		else
			sleep 0.1
		fi
		if [[ $(ls / | grep tmp) == 'tmp' ]]; then
			# Cleanup test files in the /tmp/ directory.
			cd /tmp/ || exit
			for x in {1..3}; do
				rm file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png 2> /dev/null
			done
		else
			sleep 0.1
		fi
		# Cleanup test files in the user's home directory.
		cd /home/$USER/ || exit
		for x in {1..3}; do
			rm file$x.txt song$x.mp3 clip$x.mp4 image$x.jpg pic$x.png 2> /dev/null
		done
		echo -e "\nThe test files that were created have been cleaned up from the directories that they were created in, if they were still there.\n"
	elif [ "$response" == 'No' ] || [ "$response" == 'no' ] || [ "$response" == 'N' ] || [ "$response" == 'n' ]; then
		echo -e "\nNo problem!  Just don't forget that you may have leftover test files from this script on your system.\n"
	else
		echo -e "\nThat was not a valid response.  I'll ask again."
		cleanup
	fi
}

# Create MAIN function.
main() {
	brd='\033[1;31m'
	noc='\033[0m'
	intro
	if [ "$response" == 'a' ]; then
		response_a
		cleanup
	elif [ "$response" == 'b' ]; then
		response_b
		cleanup
	elif [ "$response" == 'c' ]; then
		response_c
		cleanup
	elif [ "$response" == 'd' ]; then
		response_d
		cleanup
	elif [ "$response" == 'e' ]; then
		response_e
		cleanup
	else
		echo -e "\n${brd}That is not a valid response.  It will be assumed that you DO NOT wish to have any test files created.  This program will exit.${noc}\n"
		exit
	fi
}

# Run the script.
main

# EOF