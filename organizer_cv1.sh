#!/bin/bash
#
# TITLE: organizer_cv1.sh
# AUTHOR: Boardleash (Derek)
# DATE: Sunday, August 11 2024
#
# A script to help organize files in a user's Desktop, Documents or Downloads directory.
# This will provide the user with an options of what directory they would like to organize.
# This has been tested on CentOS Stream 9 Workstation and Server (with GUI) VM images.
# Due to some repetitive tasks within this function, comments will be layed out per function.
# Functions that repeat similar tasks will not have repeat comments (defer to the function that is commented).

# Define the introductory function.
intro() {
	echo -e "\nHello!  I can help organize one of your directories if you would like?"
	echo "I will assume that you have standard directories in your home directory."
	echo -e "\nIf that is the case, the options below are what I can organize:
	a) /home/"$USER"/Desktop/
	b) /home/"$USER"/Documents/
	c) /home/"$USER"/Downloads/"
	echo
	echo "For more customization in the organization process, type 'custom' when prompted.  You will be asked several questions if you select this option."
	# Capture user's response in a variable to be used in an if/else condition.
	read -p "Which directory would you like to organize?: " response

}

# Define 'Desktop' option function.
org_desktop() {
	# Provide user with two options for organization. 
	echo -e "\nWhich would you prefer?:
	a) Simply move various files from your Desktop to standard directories (Documents, Music, etc.) as applicable
	b) Create new directories on your Desktop to then move various files to (i.e, create a 'Text_Files' directory on your Desktop to move text files to, etc.)"
	# Capture the user's repsonse and store in a variable to be used for an if/else condition.
	read -p "Please select either 'a' or 'b': " response
	# If user response is 'a', then do XYZ.
	if [ "$response" == 'a' ]; then
		# Change into the appropriate directory or else, exit the command.
		cd /home/"$USER"/Desktop/ || exit
		# Move all necessary files to appropriate destinations.  Send errors to /dev/null.
		{
			mv -t /home/"$USER"/Documents/ *.txt *.pdf *.o
			mv *.mp3 /home/"$USER"/Music/
			mv *.mp4 /home/"$USER"/Videos/
			mv -t /home/"$USER"/Pictures/ *.jpg *.png
		} 2> /dev/null
		# Change into the user's home directory or else, exit the command.
		cd /home/"$USER"/ || exit
		# Let user know that file organization is complete.
		echo -e "\nSuccess!  File organization complete!\n"
	# If user response is 'b', then do a different XYZ.
	elif [ "$response" == 'b' ]; then
		# Change into the appropriate directory or else, exit the command.
		cd /home/"$USER"/Desktop/ || exit
		# Create necessary directories and move relevant files to appropriate destinations.  Send errors to /dev/null.
		{
			mkdir 'Text_Files' 'PDF_Files' 'LibreOffice_Files' 'Music_Files' 'Video_Files' 'Image_Files'
			mv *.txt 'Text_Files'/
			mv *.pdf 'PDF_Files'/
			mv *.o 'LibreOffice_Files'/ 
			mv *.mp3 'Music_Files'/
			mv *.mp4 'Video_Files'/
			mv -t 'Image_Files'/ *.jpg *.png
		} 2> /dev/null
		# Change into the user's home directory or else, exit the command.
		cd /home/"$USER"/ || exit
		# Let the user know that file organization is complete.
		echo -e "\nSuccess!  File organization complete!\n"
	else
		# Let user know that they did not enter a valid response.  Re-run the function to have them restart, if they want.
		echo -e "\nYou did not enter a valid response.  Please type either 'a' or 'b'.  If you do not wish to continue, please press 'Ctrl+C' to exit this operation.\n"
		org_desktop
	fi
}

# Define 'Documents' function.
org_documents() {
	echo -e "\nWhich would you prefer?:
	a) Simply move various files (non-text, non-pdf) from your Documents directory to other standard directories (Music, Videos, etc.)
	b) Create 'Text_Files', 'PDF_Files', and 'LibreOffice_Files' directories within your Documents directory and move all appropriate files to those directories, AS WELL AS move other miscellaneous files to appropriate standard directories"
	read -p "Please select either 'a' or 'b': " response
	if [ "$response" == 'a' ]; then
		cd /home/"$USER"/Documents/ || exit
		{
			mv *.mp3 /home/"$USER"/Music/
			mv *.mp4 /home/"$USER"/Videos/
			mv -t /home/"$USER"/Pictures/ *.jpg *.png
		} 2> /dev/null
		cd /home/"$USER"/ || exit
		echo -e "\nSuccess!  File organization complete!\n"
	elif [ "$response" == 'b' ]; then
		cd /home/"$USER"/Documents/ || exit
		{
			mkdir 'Text_Files' 'PDF_Files' 'LibreOffice_Files'
			mv *.txt 'Text_Files'/
			mv *.pdf 'PDF_Files'/
			mv *.o 'LibreOffice_Files'/
			mv *.mp3 /home/"$USER"/Music/
			mv *.mp4 /home/"$USER"/Videos/
			mv -t /home/"$USER"/Pictures/ *.jpg *.png
		} 2> /dev/null
		cd /home/"$USER"/ || exit
		echo -e "\nSuccess!  File organization complete!\n"
	else
		echo -e "\nYou did not enter a valid response.  Please type either 'a' or 'b'.  If you do not wish to continue, please press 'Ctrl+C' to exit this operation.\n"
		org_documents
	fi
}

# Define 'Downloads' function.
org_downloads() {
	echo -e "\nWhich would you prefer?:
	a) Simply move various files from your Downloads directory to other standard directories (Documents, Music, etc.)
	b) Create new directories in your Downloads directory to then move various files to (i.e, create a 'Text_Files' directory in your Downloads directory to move text files to, etc.)"
	read -p "Please select either 'a' or 'b': " response
	if [ "$response" == 'a' ]; then	
		cd /home/"$USER"/Downloads/ || exit
		{
			mv -t /home/"$USER"/Documents/ *.txt *.pdf *.o
			mv *.mp3 /home/"$USER"/Music/
			mv *.mp4 /home/"$USER"/Videos/
			mv -t /home/"$USER"/Pictures/ *.jpg *.png
		} 2> /dev/null
		cd /home/"$USER"/ || exit
		echo -e "\nSuccess!  File organization complete!\n"
	elif [ "$response" == 'b' ]; then
		cd /home/"$USER"/Downloads/ || exit
		{
			mkdir 'Text_Files' 'PDF_Files' 'LibreOffice_Files' 'Music_Files' 'Video_Files' 'Image_Files'
			mv *.txt 'Text_Files'/
			mv *.pdf 'PDF_Files'/
			mv *.o 'LibreOffice_Files'/
			mv *.mp3 'Music_Files'/
			mv *.mp4 'Video_Files'/
			mv -t 'Image_Files'/ *.jpg *.png
		} 2> /dev/null
		cd /home/"$USER"/ || exit
		echo -e "\nSuccess!  File organization complete!\n"
	else
		echo -e "\nYou did not enter a valid response.  Please type either 'a' or 'b'.  If you do not wish to continue, please press 'Ctrl+C' to exit this operation.\n"
		org_downloads
	fi
}

# Define 'custom' function.
org_custom() {
	echo ""
	# Capture user's desired directory input in the 'selected_directory' variable.
	read -p "Please type what directory (within your home directory) you wish to organize (case sensitive): " selected_directory
	# Capture the user's desired file type input in the 'file_type' variable.
	read -p "Please type which files you wish to organize (text, pdf, LibreOffice, music, video, or image): " file_type
	# Capture the user's desired directory to send files in the 'send_directory' variable.
	read -p "Please type the name of the directory that you wish to send the type of files you selected above to: " send_directory
	# Start to perform organization based on the three questions above.
	echo -e "\nI think I have what I need.  Give me a few seconds to organize the files you selected from the directory you want to organize into the directory you want those files.\n"
	# Set up conditional statement for the 'selected_directory' variable.  This variable has VERY limited conditions.
	if [ "$selected_directory" == 'Desktop' ] || [ "$selected_directory" == 'Documents' ] || [ "$selected_directory" == 'Downloads' ] || [ "$selected_directory" == 'Music' ] || [ "$selected_directory" == "Pictures" ] || [ "$selected_directory" == 'Videos' ]; then
		{
			# If the necessary conditions are met, change into the user's 'selected_directory' or else, exit the command.
			cd /home/"$USER"/"$selected_directory"/ || exit
			# Create the user's desired directory to send files to.
			mkdir "$send_directory"
		} 2> /dev/null
	else
		# If the necessary conditionis for the 'selected_directory' variable are NOT met, let the user know and have them try again.
		echo "Please ensure you are selecting a standard directory that exists in your home directory.  Also please keep case sensitivity in mind."
		org_custom
	fi
	# Set up a conditional statement for the 'file_type' variable.  There are multiple conditions for this variable.  In this first instance, it is text, but
	# the others are just as obvious.
	if [ "$file_type" == 'text' ] || [ "$file_type" == 'txt' ] || [ "$file_type" == 'Text' ] || [ "$file_type" == 'TEXT' ]; then
		# If the necessary conditions for the 'file_type' variable are met, move the relevant files to the appropriate destination.
		mv *.txt "$send_directory"/ 2> /dev/null
		# Let user know that organization is complete.
		echo "Success!  File organization complete!"
		# Ask user if they want to go through the custom process again.
		echo "Do you wish to go through the process again?"
		# Capture the user's repsonse in the 'response' variable.
		read -p "Yes or No?: " response
		# Set up a conditional statement based on the user's response.  If 'yes', re-run the custom function.
		if [ "$response" == 'Yes' ] || [ "$response" == 'yes' ] || [ "$response" == 'Y' ] || [ "$response" == 'y' ]; then
			org_custom
		# If user response is 'no', exit the custom function.
		elif [ "$response" == 'No' ] || [ "$response" == 'no' ] || [ "$response" == 'N' ] || [ "$response" == 'n' ]; then
			echo "Understood.  Thanks for letting me help you today!"
			exit
		else
			# Let user know that they did not enter an appropriate response and exit the script.
			echo "You did not enter a valid response.  This will be interpreted as a desire to exit.  I will terminate now."
			exit
		fi
	elif [ "$file_type" == 'pdf' ] || [ "$file_type" == 'PDF' ]; then
		mv *.pdf "$send_directory"/ 2> /dev/null
		echo "Success!  File organization complete!"
		echo "Do you wish to go through the process again?"
		read -p "Yes or No?: " response
		if [ "$response" == 'Yes' ] || [ "$response" == 'yes' ] || [ "$response" == 'Y' ] || [ "$response" == 'y' ]; then
			org_custom
		elif [ "$response" == 'No' ] || [ "$response" == 'no' ] || [ "$response" == 'N' ] || [ "$response" == 'n' ]; then
			echo "Understood.  Thanks for letting me help you today!"
			exit
		else
			echo "You did not enter a valid response.  This will be interpreted as a desire to exit.  I will terminate now."
			exit
		fi
	elif [ "$file_type" == 'LibreOffice' ] || [ "$file_type" == 'libreoffice' ] || [ "$file_type" == 'libre' ] || [ "$file_type" == 'office' ]; then
		mv *.o "$send_directory"/ 2> /dev/null
		echo "Success!  File organization complete!"
		echo "Do you wish to go through the process again?"
		read -p "Yes or No?: " response
		if [ "$response" == 'Yes' ] || [ "$response" == 'yes' ] || [ "$response" == 'Y' ] || [ "$response" == 'y' ]; then
			org_custom
		elif [ "$response" == 'No' ] || [ "$response" == 'no' ] || [ "$response" == 'N' ] || [ "$response" == 'n' ]; then
			echo "Understood.  Thanks for letting me help you today!"
			exit
		else
			echo "You did not enter a valid response.  This will be interpreted as a desire to exit.  I will terminate now."
			exit
		fi
	elif [ "$file_type" == 'music' ] || [ "$file_type" == 'Music' ] || [ "$file_type" == 'mp3' ]; then
		mv *.mp3 "$send_directory"/ 2> /dev/null
		echo "Success!  File organization complete!"
		echo "Do you wish to go through the process again?"
		read -p "Yes or No?: " response
		if [ "$response" == 'Yes' ] || [ "$response" == 'yes' ] || [ "$response" == 'Y' ] || [ "$response" == 'y' ]; then
			org_custom
		elif [ "$response" == 'No' ] || [ "$response" == 'no' ] || [ "$response" == 'N' ] || [ "$response" == 'n' ]; then
			echo "Understood.  Thanks for letting me help you today!"
			exit
		else
			echo "You did not enter a valid response.  This will be interpreted as a desire to exit.  I will terminate now."
			exit
		fi
	elif [ "$file_type" == 'video' ] || [ "$file_type" == 'Video' ] || [ "$file_type" == 'videos' ] || [ "$file_type" == 'movies' ] || [ "$file_type" == 'Movies' ]; then
		mv *.mp4 "$send_directory"/ 2> /dev/null
		echo "Success!  File organization complete!"
		echo "Do you wish to go through the process again?"
		read -p "Yes or No?: " response
		if [ "$response" == 'Yes' ] || [ "$response" == 'yes' ] || [ "$response" == 'Y' ] || [ "$response" == 'y' ]; then
			org_custom
		elif [ "$response" == 'No' ] || [ "$response" == 'no' ] || [ "$response" == 'N' ] || [ "$response" == 'n' ]; then
			echo "Understood.  Thanks for letting me help you today!"
			exit
		else
			echo "You did not enter a valid response.  This will be interpreted as a desire to exit.  I will terminate now."
			exit
		fi
	elif [ "$file_type" == 'image' ] || [ "$file_type" == 'Image' ] || [ "$file_type" == 'images' ] || [ "$file_type" == 'pics' ] || [ "$file_type" == 'pictures' ] || [ "$file_type" == 'screenshots' ]; then
		mv -t "$send_directory"/ *.jpg *.png 2> /dev/null
		echo "Success!  File organization complete!"
		echo "Do you wish to go through the process again?"
		read -p "Yes or No?: " response
		if [ "$response" == 'Yes' ] || [ "$response" == 'yes' ] || [ "$response" == 'Y' ] || [ "$response" == 'y' ]; then
			org_custom
		elif [ "$response" == 'No' ] || [ "$response" == 'no' ] || [ "$response" == 'N' ] || [ "$response" == 'n' ]; then
			echo "Understood.  Thanks for letting me help you today!"
			exit
		else
			echo "You did not enter a valid response.  This will be interpreted as a desire to exit.  I will terminate now."
			exit
		fi
	else
		echo "More than likely, the type of file you entered is not an available option.  Please try again.  If you do not wish to continue, please press 'Ctrl+C' to exit this operation."
		org_custom
	fi
}

# Define main function for script and define the appropriate functions for the appropriate responses.
main() {
	intro
	if [ "$response" == 'a' ]; then
		org_desktop
	elif [ "$response" == 'b' ]; then
		org_documents
	elif [ "$response" == 'c' ]; then
		org_downloads
	elif [ "$response" == 'custom' ]; then
		org_custom
	else
		echo -e "\nYou did not enter a valid response.  Please try again.  If you do not wish to continue, please press 'Ctrl+C' to exit this operation."
		main
	fi
}

# Run the script.
main

# EOF