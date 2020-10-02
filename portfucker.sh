#!/bin/bash

# ==========================================================================
# CONSTANTS
# ==========================================================================

# Constant for the colors
PINK='\033[1;35m'
CYAN='\033[1;36m'

# ==========================================================================
# Menu
# ==========================================================================
print_menu() {
	printf "${PINK}=%.0s" {1..80} #print the pink line

	printf "\n\n${CYAN}\t\t\t\t\tPort Fucker\n\n"
	printf "\t\t\t(1)Scan for specific ports\n"
	printf "\t\t\t(2)Scan for a range of ports\n"
	printf "\t\t\t(3)Scan for specific ports on a IP range\n"
	printf "\t\t\t(4)Scan for a range of ports on a IP range\n\n"

	printf "${PINK}=%.0s" {1..80} #print the pink line

	printf "\n${CYAN}Choose an option: "
}


print_menu #call the function

read menu #read the option picked by the user

case $menu in
1)
	printf "Ip address: "
	read ip
	printf "Load ports from ports.txt? [Y\N]:"
	read menu
	if [ $menu == "Y" ] || [ $menu == "y" ]
	then
		printf "Scanning on $ip\n"
		for port in $(cat ports.txt)
        do
            openports=$(hping3 -S $ip -c 1 --destport $port 2>/dev/null | grep "flags=SA" | cut -d "=" -f 6 | cut -d " " -f 1);
			if [ "$openports" != "" ]
			then
				printf "${PINK}Port: $openports is open\n"
			fi
		done
	
	else
							#Specific typed ports
		printf "Type the ports that you want to scan (80, 443...1337): \n"
		read -ra portsArray 
		printf "Scanning on $ip\n"
		for port in "${portsArray[@]}"
		do
			openports=$(hping3 -S $ip -c 1 --destport $port 2>/dev/null | grep "flags=SA" | cut -d "=" -f 6 | cut -d " " -f 1);
			if [ "$openports" != "" ]
			then
				printf "${PINK}Port: $openports is open\n"
			fi
		done
	fi
;;

esac #end of the switch
