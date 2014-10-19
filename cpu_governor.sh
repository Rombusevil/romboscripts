#!/bin/bash 
# Use this script to change the current cpu governor. 
# Changes made with this script will be lost on reboot.
# It's based upon cpufrequtils.

function showGovernor() {
	for i in `seq 0 $(( $(nproc) -1))`; do # nproc tells me the number of cores
		echo -e "\tcore $i $(sudo cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor;)";
	done
}

function getAvailableGovernors(){
	echo "Available governors: $(cpufreq-info -g)";
}

function setGovernor() {
 #
 # @param governor
 # Receive governor string as param
 #
	governor=$(getAvailableGovernors);
	if [[ $governor == *$1* ]]; then
		# It's a valid governor

		for i in `seq 0 $(( $(nproc) -1))`; do
			sudo cpufreq-set -c$i -g $1;
	    done
		echo "Governor updated";
		echo "Current governor:";
		showGovernor;
	else
		echo "Unsupported governor";
		getAvailableGovernors;
	fi
}

# main
if [[ -z $1 ]]; then
	echo "Current governor:";
	showGovernor; echo ""; 
	getAvailableGovernors; echo "";
	echo "Usage: ./cpu_governor.sh [available governor]";
else
	setGovernor $1;
fi


