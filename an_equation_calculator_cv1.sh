#!/bin/bash
#
############################################
### TITLE: an_equation_calculator_cv1.sh ###
### AUTHOR: Boardleash (Derek)           ###
### DATE: Saturday, October 12 2024      ###
############################################
#
###################
### DESCRIPTION ###
###################
#
# This is a script that performs some basic math functions.
# The user will be asked to provide two numbers to be used by the script.
# PI in this script is limited to 3.14159.
# The range of numbers allowed is between -100 to 100 (excluding 0).
# This script does utilize the "bc" command, so if the package is not installed, it would need to be installed to execute successfully.
# The decimal limit is set to 5 places for decimal numbers in this script.
# This script does NOT need to be run with elevated privileges.
# Tested on CentOS Stream 9 VM (Server w/GUI) in both graphical (GUI) and multi-user (Server) targets.

##################
### FORMATTING ###
##################

# Set up formatting.
bgrn='\033[1;32m'
brd='\033[1;31m'
bprp='\033[1;35m'
noc='\033[0m'

#####################
### INTRODUCTIONS ###
#####################

# Set up an intro function.
intro() {
	echo
	echo "Hello!  I can perform some calculations on two numbers for you if you want.
	If not, simply say no on the first question."
	echo
}

# Set up an 'ask for numbers' function.
user_numbers() {
	# Have user enter a number and store it as variable "numba".
	read -p "Enter a number (between -100 and 100, excluding 0): " numba
	# Check that "numba" meets the script's desired value (-100 to 100 excluding 0).
	if [[ "$numba" =~ ^[-+]?([1-9][0-9]?|100)$ ]]; then
		# If the first number meets the script's desired value, have user enter another number.
		# Store the input as variable "numbb".
		read -p "Enter a second number (between -100 and 100, excluding 0): " numbb
		# Check that "numbb" meets the script's desired value (-100 to 100 excluding 0)
		if [[ "$numbb" =~ ^[-+]?([1-9][0-9]?|100)$ ]]; then
			# If the second number meets the script's desired value, thank the user and move on.
			echo "Thank you."
			echo
		# If "numbb" is found to be 0, raise an error and restart this function.
		elif [ "$numbb" == 0 ]; then
			echo "I cannot accept that number.  Let's start from the beginning."
			user_numbers
		# If "numbb" is something that is not within the desired range and is also not 0, raise an error.
		else
			echo "That is either out of range or not a number.  Let's start from the beginning."
			user_numbers
		fi
	elif [ "$numba" == 0 ]; then
		echo "I cannot accept that number.  Let's start from the beginning."
		user_numbers
	# If the user enters some variation of "no" as the first number and "numba" equals that variation of "no"
	# then end the script and exit.
	elif [ "$numba" == 'No' ] || [ "$numba" == 'no' ] || [ "$numba" == 'N' ] || [ "$numba" == 'n' ]; then
		echo "No worries!  We don't need to do any math today anyways!  Hahahaha."
		exit
	else
	# If the user enters something that is not within the desired range and is also not 0, raise an error.
		echo "That is either out of range or not a number.  Let's start from the beginning."
		user_numbers
	fi
}

# Set up an 'ask for units' function.
what_units() {
	# Inform the user that they have options for units of measurement.
	echo "This script can provide the following units of measurement to your numbers:
	a) Millimeters (mm)
	b) Centimeters (cm)
	c) Meters (m)
	d) Inches (in)
	e) Feet (ft)
	f) Yards (yd)
	g) None"
	# Ask the user for what unit of measurement they would like.
	read -p "What unit of measurement would you like to use: " units
	# Use an if/elif/else statement to capture all of the possible options and have the "units" variable store the user's choice.
	if [ "$units" == 'a' ] || [ "$units" = 'A' ] || [ "$units" == 'mm' ] || [ "$units" == 'MM' ] || [ "$units" == 'Mm' ] || [ "$units" == 'Millimeters' ] || [ "$units" == 'millimeters' ]; then
		units='mm'
	elif [ "$units" == 'b' ] || [ "$units" == 'B' ] || [ "$units" == 'cm' ] || [ "$units" == 'CM' ] || [ "$units" == 'Cm' ] || [ "$units" == 'Centimeters' ] || [ "$units" == 'centimeters' ]; then
		units='cm'
	elif [ "$units" == 'c' ] || [ "$units" == 'C' ] || [ "$units" == 'm' ] || [ "$units" == 'M' ] || [ "$units" == 'Meters' ] || [ "$units" == 'meters' ]; then
		units='m'
	elif [ "$units" == 'd' ] || [ "$units" == 'D' ] || [ "$units" == 'in' ] || [ "$units" == 'IN' ] || [ "$units" == 'In' ] || [ "$units" == 'Inches' ] || [ "$units" == 'inches' ]; then
		units='in'
	elif [ "$units" = 'e' ] || [ "$units" == 'E' ] || [ "$units" == 'ft' ] || [ "$units" == 'FT' ] || [ "$units" == 'Ft' ] || [ "$units" == 'Feet' ] || [ "$units" == 'feet' ]; then
		units='ft'
	elif [ "$units" = 'f' ] || [ "$units" == 'F' ] || [ "$units" == 'yd' ] || [ "$units" == 'YD' ] || [ "$units" == 'Yd' ] || [ "$units" == 'Yard' ] || [ "$units" == 'Yards' ] || [ "$units" == 'yard' ] || [ "$units" == 'yards' ]; then
		units='yd'
	elif [ "$units" = 'g' ] || [ "$units" == 'G' ] || [ "$units" == 'None' ] || [ "$units" == 'none' ] || [ "$units" == 'NONE' ]; then
		units=''
	else
		# If the user selects an option that is not allowed, raise an error and restart the function.
		echo "That cannot be accpeted as a unit of measurement.  Let's try again."
		what_units
	fi
}

# Set up a reference function to remind user what numbers they input and what unit of measurement they selected.
ref() {
	echo
	echo -e "For reference;
	YOUR$bprp FIRST$noc NUMBER is: "$bprp""$numba""$noc"
	YOUR$bprp SECOND$noc NUMBER is: "$bprp""$numbb""$noc"
	YOUR$bprp UNIT OF MEASUREMENT$noc is: "$bprp""$units""$noc"
	^2 = SQUARED
	^3 = CUBED"
	echo
}

##################
### BASIC MATH ###
##################

# Set up addition function.
addnumbers() {
	eq_one=$(echo "scale=5; $numba+$numba" | bc)
	eq_two=$(echo "scale=5; $numba+$numbb" | bc)
	# SUM = A+B
	echo -e "The$bgrn SUM$noc of your numbers is:" "$bgrn""$eq_two""$units""$noc"
}

# Set up subtraction function.
subtractnumbers() {
	eq_one=$(echo "scale=5; $numba-$numba" | bc)
	eq_two=$(echo "scale=5; $numba-$numbb" | bc)
	eq_three=$(echo "scale=5; $numbb-$numba" | bc)
	# DIFFERNCE = A-B
	echo -e "The$bgrn DIFFERENCE$noc of your$brd FIRST$noc number ("$numba") subtracted from your$brd SECOND$noc number ("$numbb") is:" "$bgrn""$eq_two""$units""$noc"
	# DIFFERENCE = B-A
	echo -e "The$bgrn DIFFERENCE$noc of your$brd SECOND$noc number ("$numbb") subtracted from your$brd FIRST$noc number ("$numba") is:" "$bgrn""$eq_three""$units""$noc"
}

# Set up multiplication function.
multiplynumbers() {
	eq_one=$(echo "scale=5; $numba*$numba" | bc)
	eq_two=$(echo "scale=5; $numba*$numbb" | bc)
	# PRODUCT = AxB
	echo -e "The$bgrn PRODUCT$noc of your numbers is:" "$bgrn""$eq_two""$units""$noc"
}

# Set up division function.
dividenumbers() {
	eq_one=$(echo "scale=5; $numba/$numba" | bc)
	eq_two=$(echo "scale=5; $numba/$numbb" | bc)
	eq_three=$(echo "scale=5; $numbb/$numba" | bc)
	# QUOTIENT = A/B
	echo -e "The$bgrn QUOTIENT$noc of your$brd FIRST$noc number ("$numba") divided by your$brd SECOND$noc number ("$numbb") is:" "$bgrn""$eq_two""$units""$noc"
	# QUOTIENT = B/A
	echo -e "The$bgrn QUOTIENT$noc of your$brd SECOND$noc number ("$numbb") divided by your$brd FIRST$noc number ("$numba") is:" "$bgrn""$eq_three""$units""$noc"
}

#################
### AREA MATH ###
#################

# Set up area equation functions.
areasquare() {
	# AREA of a SQUARE = AxA
	squarea=$(echo "scale=5; $numba*$numba" | bc)
	squareb=$(echo "scale=5; $numbb*$numba" | bc)
	# AREA of a SQUARE = AxA (in this case)
	echo -e "The$bgrn AREA of a SQUARE$noc with your$brd FIRST$noc number ("$numba") is:" "$bgrn""$squarea""$units"^2"$noc"
	# AREA of a SQUARE = BxB (in this case)
	echo -e "The$bgrn AREA of a SQUARE$noc with your$brd SECOND$noc number ("$numbb") is:" "$bgrn""$squareb""$units"^2"$noc"
}

arearectangle() {
	# AREA of a RECTANGLE = WIDTH x HEIGHT
	recta=$(echo "scale=5; $numba*$numbb" | bc)
	# AREA of a RECTANGLE = A x B (in this case)
	echo -e "The$bgrn AREA of a RECTANGLE$noc with your provided numbers is:" "$bgrn""$recta""$units"^2"$noc"
}

areatriangle() {
	# AREA of a TRIANGLE = BASE x HEIGHT x 0.5
	trianga=$(echo "scale=5; $numba*$numbb*0.5" | bc)
	# AREA of a TRIANGLE = A x B x 0.5 (in this case)
	echo -e "The$bgrn AREA of a TRIANGLE$noc with your provided numbers is:" "$bgrn""$trianga""$units"^2"$noc"
}

areacircle() {
	# AREA of a CIRCLE = PI x RADIUS(squared)
	eq_one=$(echo "scale=5; $numba*$numba" | bc)
	circlea=$(echo "scale=5; 3.14159*$eq_one" | bc)
	eq_two=$(echo "scale=5; $numbb*$numbb" | bc)
	circleb=$(echo "scale=5; 3.14159*$eq_two" | bc)
	# AREA of a CIRCLE = (3.14159 x A(squared)) (in this case)
	echo -e "The$bgrn AREA of a CIRCLE$noc with your$brd FIRST$noc number ("$numba") is:" "$bgrn""$circlea""$units"^2"$noc"
	# AREA of a CIRCLE = (3.14159 x B(squared)) (in this case)
	echo -e "The$bgrn AREA of a CIRCLE$noc with your$brd SECOND$noc number ("$numbb") is:" "$bgrn""$circleb""$units"^2"$noc"
}

areaellipse() {
	# AREA of an ELLIPSE = PI x RADIUS OF LONG AXIS x RADIUS OF SHORT AXIS
	ellipse=$(echo "scale=5; $numba*$numbb*3.14159" | bc)
	# AREA of an ELLIPSE = 3.14159 x A x B (A as long axis and B as short axis in this case)
	echo -e "The$bgrn AREA of an ELLIPSE$noc with your provided numbers is:" "$bgrn""$ellipse""$units"^2"$noc"
}

#########################
### SURFACE AREA MATH ###
#########################

# Set up surface area functions.
surfareacube() {
	# SURFACE AREA of a CUBE = 6 x A(squared)
	eq_one=$(echo "scale=5; $numba*$numba" | bc)
	surfa=$(echo "scale=5; $eq_one*6" | bc)
	eq_two=$(echo "scale=5; $numbb*$numbb" | bc)
	surfb=$(echo "scale=5; $eq_two*6" | bc)
	# SURFACE AREA  of a CUBE = 6 x A(squared) (in this case)
	echo -e "The$bgrn SURFACE AREA of a CUBE$noc with your$brd FIRST$noc number ("$numba") is:" "$bgrn""$surfa""$units"^2"$noc"
	# SURFACE AREA of a CUBE = 6 x B(squared) (in this case)
	echo -e "The$bgrn SURFACE AREA of a CUBE$noc with your$brd SECOND$noc number ("$numbb") is:" "$bgrn""$surfb""$units"^2"$noc"
}

surfareasphere() {
	# SURFACE AREA of a SPHERE = 4 x PI x RADIUS(squared)
	eq_one=$(echo "scale=5; 4*3.14159" | bc)
	eq_two=$(echo "scale=5; $numba*$numba" | bc)
	surfa=$(echo "scale=5; $eq_one*$eq_two" | bc)
	eq_three=$(echo "scale=5; 4*3.14159" | bc)
	eq_four=$(echo "scale=5; $numbb*$numbb" | bc)
	surfb=$(echo "scale=5; $eq_three*$eq_four" | bc)
	# SURFACE AREA of a SPHERE = 4 x 3.14159 x A(squared) (in this case)
	echo -e "The$bgrn SURFACE AREA of a SPHERE$noc with your$brd FIRST$noc number ("$numba") is:" "$bgrn""$surfa""$units"^2"$noc"
	# SURFACE AREA of a SPHERE = 4 x 3.14159 x B(squared) (in this case)
	echo -e "The$bgrn SURFACE AREA of a SPHERE$noc with your$brd SECOND$noc number ("$numbb") is:" "$bgrn""$surfb""$units"^2"$noc"
}

surfareacylinder() {
	# SURFACE AREA of a CYLINDER = (2 x PI x RADIUS x HEIGHT) + (2 x PI x RADIUS(squared))
	eq_one=$(echo "scale=5; 2*3.14159*$numba*$numbb" | bc)
	eq_two=$(echo "scale=5; $numba*$numba" | bc)
	eq_three=$(echo "scale=5; 2*3.14159*$eq_two" | bc)
	surfa=$(echo "scale=5; $eq_one+$eq_three" | bc)
	eq_four=$(echo "scale=5; $numbb*$numbb" | bc)
	eq_five=$(echo "scale=5; 2*3.14159*$eq_four" | bc)
	surfb=$(echo "scale=5; $eq_one+$eq_five" | bc)
	# SURFACE AREA of a CYLINDER = (2 x 3.14159 x A x B) + (2 x 3.14159 x A(squared)) (A as the radius and B as the height in this case)
	echo -e "The$bgrn SURFACE AREA of a CYLINDER$noc with your$brd FIRST$noc number ("$numba") as the radius is:" "$bgrn""$surfa""$units"^2"$noc"
	# SURFACE AREA of a CYLINDER = (2 x 3.14159 x B x A) + (2 x 3.14159 x B(squared)) (B as the radius and A as the height in this case)
	echo -e "The$bgrn SURFACE AREA of a CYLINDER$noc with your$brd SECOND$noc number ("$numbb") as the radius is:" "$bgrn""$surfb""$units"^2"$noc"
}

###################
### VOLUME MATH ###
###################

# Set up volume functions.
volcube() {
	# VOLUME of a CUBE = A(cubed)
	vola=$(echo "scale=5; $numba*$numba*$numba" | bc)
	volb=$(echo "scale=5; $numbb*$numbb*$numbb" | bc)
	# VOLUME of a CUBE = A(cubed) (in this case)
	echo -e "The$bgrn VOLUME of a CUBE$noc with your$brd FIRST$noc number ("$numba") is:" "$bgrn""$vola""$units"^3"$noc"
	# VOLUME of a CUBE = B(cubed) (in this case)
	echo -e "The$bgrn VOLUME of a CUBE$noc with your$brd SECOND$noc number ("$numbb") is:" "$bgrn""$volb""$units"^3"$noc"
}

volsphere() {
	# VOLUME of a SPHERE = (4/3) x PI x RADIUS(cubed)
	eq_one=$(echo "scale=5; $numba*$numba*$numba" | bc)
	eq_two=$(echo "scale=5; 3.14159*$eq_one" | bc)
	eq_three=$(echo "scale=5; 4/3" | bc)
	vola=$(echo "scale=5; $eq_three*$eq_two" | bc)
	eq_four=$(echo "scale=5; $numbb*$numbb*$numbb" | bc)
	eq_five=$(echo "scale=5; 3.14159*$eq_four" | bc)
	volb=$(echo "scale=5; $eq_three*$eq_five" | bc)
	# VOLUME of a SPHERE = (4/3) x 3.14159 x A(cubed) (A as the radius in this case)
	echo -e "The$bgrn VOLUME of a SPHERE$noc with your$brd FIRST$noc number ("$numba") is:" "$bgrn""$vola""$units"^3"$noc"
	# VOLUME of a SPHERE = (4/3) x 3.14159 x B(cubed) (B as the radius in this case)
	echo -e "The$bgrn VOLUME of a SPHERE$noc with your$brd SECOND$noc number ("$numbb") is:" "$bgrn""$volb""$units"^3"$noc"
}

volcylinder() {
	# VOLUME of a CYLINDER = PI x RADIUS(squared) x HEIGHT
	eq_one=$(echo "scale=5; $numba*$numba" | bc)
	eq_two=$(echo "scale=5; $numbb*$numbb" | bc)
	eq_three=$(echo "scale=5; $eq_one*3.14159" | bc)
	eq_four=$(echo "scale=5; $eq_two*3.14159" | bc)
	vola=$(echo "scale=5; $eq_three*$numbb" | bc)
	volb=$(echo "scale=5; $eq_four*$numba" | bc)
	# VOLUME of a CYLINDER = 3.14159 x A(squared) x B (A as the radius and B as the height in this case)
	echo -e "The$bgrn VOLUME of a CYLINDER$noc with your$brd FIRST$noc number ("$numba") as the radius is:" "$bgrn""$vola""$units"^3"$noc"
	# VOLUME of a CYLINDER = 3.14159 x B(squared) x A (B as the radius and A as the height in this case)
	echo -e "The$bgrn VOLUME of a CYLINDER$noc with your$brd SECOND$noc number ("$numbb") as the radius is:" "$bgrn""$volb""$units"^3"$noc"
}

##############################
### FUNCTION CONSOLIDATION ###
##############################

# Consolidate basic math functions.
basicmath() {
	# Announce to user this is the basic math section.
	echo -e "$bprp BASIC MATH$noc"
	echo
	# Consolidate the functions that were created for basic math.
	addnumbers
	subtractnumbers
	multiplynumbers
	dividenumbers
	echo
}

# Consolidate area math functions.
areamath() {
	# Announce to user this is the area math section.
	echo -e "$bprp AREA MATH$noc"
	echo
	# Consolidate the functions that were created for area math.
	areasquare
	arearectangle
	areatriangle
	areacircle
	areaellipse
	echo
}

# Consolidate surface area math functions.
surfareamath() {
	# Announce to user this is the surface area math section.
	echo -e "$bprp SURFACE AREA MATH$noc"
	echo
	# Consolidate the functions that were created for surface area math.
	surfareacube
	surfareasphere
	surfareacylinder
	echo
}

# Conslidate volume math functions.
volumemath() {
	# Announce to user this is the volume math section.
	echo -e "$bprp VOLUME MATH$noc"
	echo
	# Consolidate the functions that were created for volume math.
	volcube
	volsphere
	volcylinder
	echo
}

###################
### MAIN SCRIPT ###
###################

# Create a main script function that takes all of the above consolidations.
math() {
	intro
	user_numbers
	what_units
	ref
	basicmath
	areamath
	surfareamath
	volumemath
}

# Run main script.
math

# EOF
