#!/bin/bash
# Author: Boardleash (Derek)
# Date: Sunday, July 7 2024

# This is a script intended to be ran after a fresh install of CentOS Stream 9 (Workstation and Server with GUI).
# In this version, Docker and LibreOffice are installed because they are what I use pretty often.
# A use-case for this is if a drive fails, a partition corrupts or a general fresh install.

# NOTE: The "fresh.log" serves as the log for capturing all steps and errors.  This is stored in /tmp/, so will be removed on reboot.
# If desired to keep the log, you can change the directory (and log name if desired) as necessary.

# ALSO NOTE: If you are having issues running this script, check permissions (chmod) and run with root privileges (sudo).

# Provide amplifying information in the restoration log, only visible in the log.
echo > /tmp/fresh.log
echo "This is the restoration process for CentOS Workstation and Server with GUI builds." >> /tmp/fresh.log
echo "In this process, fresh installs will occur for Docker and LibreOffice." >> /tmp/fresh.log
echo "Additionally, a system update will be performed after packages are installed." >> /tmp/fresh.log
echo "Docker and SSH services will also be verified." >> /tmp/fresh.log

# Set up variables for formatting.
green='\033[0;32m'
red='\033[0;31m'
reset='\033[0m'
bold=$(tput bold)
normal=$(tput sgr0)

# Set up a spinner for indication of the processes running to the user.
spinner() {
	local i sp n
	sp='/-\|'
	n=${#sp}
	printf ' '
	while sleep 0.1; do
		printf "%s\b" "${sp:i++%n:1}"
	done
}

# Announce to user that the minimal recovery process has started and a reboot will occur at the end.
echo | tee -a /tmp/fresh.log
echo "$bold The minimal recovery process is starting.  There will be a reboot at the end!" | tee -a /tmp/fresh.log

##################################
### DOCKER REMOVAL and INSTALL ###
##################################

# Announce to user that the Docker removal process is starting and initiate Docker uninstall. 
echo "Removing old versions of Docker, if they existed." | tee -a /tmp/fresh.log
echo >> /tmp/fresh.log
spinner &
yum remove -y docker &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-client &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-client-latest &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-common &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-latest &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-latest-logrotate &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-logrotate &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-engine &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-ce &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-ce-cli &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y containerd.io &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-buildx-plugin &>> /tmp/fresh.log
echo >> /tmp/fresh.log
yum remove -y docker-compose-plugin &>> /tmp/fresh.log
echo >> /tmp/fresh.log

kill "$!"
printf "\b"

# Announce to user that Docker removal has completed.
echo "Old versions of Docker have been removed, if they ever existed." | tee -a /tmp/fresh.log
echo >> /tmp/fresh.log

# Announce to user that Docker install is starting.
echo "Starting fresh install of Docker." | tee -a /tmp/fresh.log
echo >> /tmp/fresh.log

# Check if the "extras-common" repo is enabled.
spinner &
yum repolist enabled | grep extras-common &>> /tmp/fresh.log
echo >> /tmp/fresh.log

# Run an "if..else" statement to either initiate the install of Docker or state that it is not possible at this time.
extras_repo=$(echo $?) &>> /tmp/fresh.log
if [ $extras_repo == '0' ]; then

	# Start Docker install.
	yum install -y yum-utils &>> /tmp/fresh.log
	echo >> /tmp/fresh.log
	yum config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo &>> /tmp/fresh.log
	echo >> /tmp/fresh.log
	yum install -y docker-ce &>> /tmp/fresh.log
	echo >> /tmp/fresh.log
	yum install -y docker-ce-cli &>> /tmp/fresh.log
	echo >> /tmp/fresh.log
	yum install -y containerd.io &>> /tmp/fresh.log
	echo >> /tmp/fresh.log
	yum install -y docker-buildx-plugin &>> /tmp/fresh.log
	echo >> /tmp/fresh.log
	yum install -y docker-compose-plugin &>> /tmp/fresh.log
	echo >> /tmp/fresh.log

	# Configure appropriate user and group associations.
	useradd -c "Docker User" -s /bin/bash dockman &>> /tmp/fresh.log
	usermod -aG docker dockman &>> /tmp/fresh.log
	echo >> /tmp/fresh.log

	# Announce to user that Docker install is complete.
	echo "Docker Engine install complete." | tee -a /tmp/fresh.log
else

	# Announce to user that Docker cannot be installed at this time and to check repolist for "extras-common".
	echo "Unable to install Docker Engine at this time; please check repolist for 'extras-common'." | tee -a /tmp/fresh.log
fi

kill "$!"
printf "\b"

#######################################
### LIBREOFFICE REMOVAL and INSTALL ###
#######################################

# Announce to user that LibreOffice will be uninstalled.
echo >> /tmp/fresh.log
echo "Uninstalling LibreOffice, if it even existed." | tee -a /tmp/fresh.log
echo >> /tmp/fresh.log

# Run command to uninstall LibreOffice.
spinner &
yum remove -y libreoffice* &>> /tmp/fresh.log

kill "$!"
printf "\b"

# Announce to user that uninstall is complete and fresh install will begin.
echo >> /tmp/fresh.log
echo "LibreOffice has been uninstalled, if it existed.  Starting fresh install of LibreOffice." | tee -a /tmp/fresh.log
echo >> /tmp/fresh.log

# Run command to install LibreOffice.
spinner &
yum install -y libreoffice-core &>> /tmp/fresh.log
echo >> /tmp/fresh.log
wget https://download.documentfoundation.org/libreoffice/stable/24.2.4/rpm/x86_64/LibreOffice_24.2.4_Linux_x86-64_rpm.tar.gz &>> /tmp/fresh.log
echo >> /tmp/fresh.log
tar xvf LibreOffice_24.2.4_Linux_x86-64_rpm.tar.gz &>> /tmp/fresh.log
echo >> /tmp/fresh.log
cd LibreOffice_24.2.4.2_Linux_x86-64_rpm/RPMS/ &>> /tmp/fresh.log
yum install -y *.rpm &>> /tmp/fresh.log
echo >> /tmp/fresh.log
rm -rf /home/*/Libre* &>> /tmp/fresh.log
echo >> /tmp/fresh.log

kill "$!"
printf "\b"

# Announce to user that install is complete.
echo "LibreOffice has been installed." | tee -a /tmp/fresh.log

############################
### GNOME TWEAKS INSTALL ###
############################

# Announce to user that GNOME Tweaks is being installed.
echo >> /tmp/fresh.log
echo "Installing GNOME Tweaks package." | tee -a /tmp/fresh.log
echo >> /tmp/fresh.log

# Run command to install GNOME Tweaks.
spinner &
yum install -y gnome-tweaks &>> /tmp/fresh.log
echo >> /tmp/fresh.log

kill "$!"
printf "\b"

# Announce to user that GNOME Tweaks has been installed.
echo "GNOME Tweaks has been installed." | tee -a /tmp/fresh.log
echo >> /tmp/fresh.log

#########################################
### UPDATE SYSTEM and VERIFY SERVICES ### 
#########################################

# Announce to user that system is being updated.
echo "Updates are being applied to the system now." | tee -a /tmp/fresh.log
echo >> /tmp/fresh.log

# Run the command to update the system.
spinner &
dnf update -y &>> /tmp/fresh.log;
echo >> /tmp/fresh.log
dnf upgrade -y &>> /tmp/fresh.log;
echo >> /tmp/fresh.log
dnf clean all &>> /tmp/fresh.log

kill "$!"
printf "\b"

# Announce to user that updates are complete and that services are being verified.
echo | tee -a /tmp/fresh.log
echo "System updated, now, services will be verified." | tee -a /tmp/fresh.log
echo | tee -a /tmp/fresh.log

# Verify Docker services.
var_docker=$(systemctl is-active docker)
var_docker_enabled=$(systemctl is-enabled docker)
if [ $var_docker == 'active' ]; then
	echo -e "Docker is: $green $var_docker $reset" | tee -a /tmp/fresh.log
else
	echo -e "$bold Docker is: $red $var_docker $reset" | tee -a /tmp/fresh.log
fi
if [ $var_docker_enabled == 'enabled' ]; then
	echo -e "$bold Docker is: $green $var_docker_enabled $reset" | tee -a /tmp/fresh.log 
else 
	echo -e "$bold Docker is: $red $var_docker_enabled $reset" | tee -a /tmp/fresh.log
fi
echo | tee -a /tmp/fresh.log

# Verify SSH services.
var_sshd_enabled=$(systemctl is-enabled sshd)
var_sshd=$(systemctl is-active sshd)
if [ $var_sshd == 'active' ]; then
	echo -e "$bold SSH is: $green $var_sshd $reset" | tee -a /tmp/fresh.log
else
	echo -e "$bold SSH is: $red $var_sshd $reset" | tee -a /tmp/fresh.log
fi
if [ $var_sshd_enabled == 'enabled' ]; then
	echo -e "$bold SSH is: $green $var_sshd_enabled $reset" | tee -a /tmp/fresh.log
else
	echo -e "$bold SSH is: $red $var_sshd_enabled $reset" | tee -a /tmp/fresh.log
fi
echo | tee -a /tmp/fresh.log

# Announce to user that a reboot will occur in 15 seconds.
echo "$bold This system will reboot in 15 seconds. $normal" | tee -a /tmp/fresh.log
echo | tee -a /tmp/fresh.log

# Run command to reboot system, with 15 second delay.
spinner &
sleep 15s &>> /tmp/fresh.log
reboot &>> /tmp/fresh.log

# EOF
