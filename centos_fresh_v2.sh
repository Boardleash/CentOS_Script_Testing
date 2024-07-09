#!/bin/bash
#
# TITLE: centos_fresh_v2.sh
# AUTHOR: Boardleash (Derek)
# DATE: Monday, July 8 2024
#
# A script created to perform a fresh/clean install of Docker, LibreOffice, and GNOME-Tweaks.
# Performs system updates and verifications of Docker and SSH services as well.
# Tested on CentOS Stream 9 Workstation and CentOS Stream 9 Server(with GUI) VM images.
# Ensure correct permissions have been set (chmod) if having issues running this script.
# This script should be ran with elevated privileges (sudo).

# Provide brief description of script, only visible in the "fresh.log" file.
{
	echo "This script will perform a clean install of Docker, LibreOffice, and GNOME-Tweaks."
	echo "System updates will be performed, as well as verification of Docker and SSH services."
	echo "A reboot will occur at the end of script execution."
} > /tmp/fresh.log

# Establish formatting variables.
green='\033[0;32m'
red='\033[0;31m'
reset='\033[0m'

# Create spinner function to show an "in progress" status to user.
spinner() {
	local i sp n
	sp='/-\|'
	n=${#sp}
	printf ' '
	while sleep 0.1; do
		printf "%s\b" "${sp:i++%n:1}"
	done
}

# Notify user that script is being executed.
echo;echo "Script execution has begun.  There will be a reboot!" | tee -a /tmp/fresh.log

##################################
### DOCKER REMOVAL and INSTALL ###
##################################

# Notify user that Docker will be removed. 
echo "Removing Docker, if it exists." | tee -a /tmp/fresh.log
spinner &
spinner_pid=$!
{
	yum remove -y docker*
	yum remove -y containerd.io
} &>> /tmp/fresh.log

# Notify user that Docker removal is complete.
echo "Docker removed, if it existed.  Docker install starting." | tee -a /tmp/fresh.log

# Run if/else statement to install Docker if "extras-common" is verified, else, don't install.
yum repolist enabled | grep extras &>> /tmp/fresh.log
exit_status=$?
if [ "$exit_status" == '0' ]; then

	# Start Docker install.
	{
		yum install -y yum-utils
		yum config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		yum install -y docker-ce
		yum install -y docker-ce-cli
		yum install -y containerd.io
		yum install -y docker-buildx-plugin
		yum install -y docker-compose-plugin

	# Enable Docker service.
		systemctl enable docker
	} &>> /tmp/fresh.log

	# Create a Docker user and associate with Docker group.
	# If this is not desired, remove or comment out this part.
	# If a different user is preferred, change "dockman" to preferred user.
	{
		useradd -c "Docker User" -s /bin/bash dockman
		usermod -aG docker dockman
	} &>> /tmp/fresh.log

	# Notify user that Docker install is complete.
	echo "Docker install complete." | tee -a /tmp/fresh.log
else

	# Notify user that Docker cannot install and to check for "extras-common" repo.
	echo "Docker install unsuccessful.  Check for 'extras-common' repo." | tee -a /tmp/fresh.log
fi

#######################################
### LIBREOFFICE REMOVAL and INSTALL ###
#######################################

# Notify user LibreOffice will be removed.
echo "Removing LibreOffice, if it exists." | tee -a /tmp/fresh.log

# Start LibreOffice removal.
yum remove -y libreoffice* &>> /tmp/fresh.log

# Notify user LibreOffice has been removed and LibreOffice install is starting.
echo "LibreOffice removed, if it existed.  LibreOffice install starting." | tee -a /tmp/fresh.log

# Start LibreOffice install.
{
	yum install -y libreoffice-core
	wget https://download.documentfoundation.org/libreoffice/stable/24.2.4/rpm/x86_64/LibreOffice_24.2.4_Linux_x86-64_rpm.tar.gz
	tar xvf LibreOffice_24.2.4_Linux_x86-64_rpm.tar.gz
	cd LibreOffice_24.2.4.2_Linux_x86-64_rpm/RPMS/ || exit
	yum install -y ./*rpm*
	rm -rf /home/*/Libre*
} &>> /tmp/fresh.log

# Notify user LibreOffice has been installed.
echo "LibreOffice install complete." | tee -a /tmp/fresh.log

############################
### GNOME-TWEAKS INSTALL ###
############################

# Notify user GNOME-Tweaks install is starting.
echo "Installing GNOME-Tweaks." | tee -a /tmp/fresh.log

# Start GNOME-Tweaks install.
yum install -y gnome-tweaks &>> /tmp/fresh.log

# Notify user GNOME-Tweaks has been installed.
echo "GNOME-Tweaks install complete." | tee -a /tmp/fresh.log

#########################################
### UPDATE SYSTEM and VERIFY SERVICES ### 
#########################################

# Notify user that system updates are being performed.
echo "Starting system updates." | tee -a /tmp/fresh.log

# Start system updates.
{
	dnf update -y
	dnf upgrade -y
	dnf clean all 
} &>> /tmp/fresh.log

# Notify user that system updates are complete and services are being verified.
echo "System updates complete.  Verifying Docker and SSH services." | tee -a /tmp/fresh.log

# Verify Docker services.
var_docker=$(systemctl is-active docker)
var_docker_enabled=$(systemctl is-enabled docker)
if [ "$var_docker" == 'active' ]; then
	echo
	echo -e "Docker is: $green $var_docker $reset" | tee -a /tmp/fresh.log
else
	echo
	echo -e "Docker is: $red $var_docker $reset" | tee -a /tmp/fresh.log
fi
if [ "$var_docker_enabled" == 'enabled' ]; then
	echo -e "Docker is: $green $var_docker_enabled $reset" | tee -a /tmp/fresh.log 
else 
	echo -e "Docker is: $red $var_docker_enabled $reset" | tee -a /tmp/fresh.log
fi

# Verify SSH services.
var_sshd_enabled=$(systemctl is-enabled sshd)
var_sshd=$(systemctl is-active sshd)
if [ "$var_sshd" == 'active' ]; then
	echo
	echo -e "SSH is: $green $var_sshd $reset" | tee -a /tmp/fresh.log
else
	echo
	echo -e "SSH is: $red $var_sshd $reset" | tee -a /tmp/fresh.log
fi
if [ "$var_sshd_enabled" == 'enabled' ]; then
	echo -e "SSH is: $green $var_sshd_enabled $reset" | tee -a /tmp/fresh.log
else
	echo -e "SSH is: $red $var_sshd_enabled $reset" | tee -a /tmp/fresh.log
fi

# Notify user that reboot will occur in 15 seconds.
echo;echo "This system will reboot in 15 seconds." | tee -a /tmp/fresh.log
echo

# Start 15 second delay followed by reboot.
sleep 15s
kill -9 $spinner_pid
reboot

# EOF
