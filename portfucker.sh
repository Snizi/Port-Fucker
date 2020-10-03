#!/bin/bash


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
	printf "\t\t\t(3)Scan for specific ports in a IP range\n"
	printf "\t\t\t(4)Scan for a range of ports in a IP range\n\n"

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
2)
	printf "Ip address: "
	read ip
	printf "What is the range that you want to scan? (min max)\n"
	printf "Example: 1 65535 \n"
	read -ra portsArray 
	printf "Scanning on $ip\n"
	min_port=${portsArray[0]}
	max_port=${portsArray[1]}

	for port in $(seq $min_port $max_port)
	do
		openports=$(hping3 -S $ip -c 1 --destport $port 2>/dev/null | grep "flags=SA" | cut -d "=" -f 6 | cut -d " " -f 1);
		if [ "$openports" != "" ]
		then
			printf "${PINK}Port: $openports is open\n"
		fi
	done
;;
3)
	printf "Ip address (192.168.0): "
	read ip
	printf "Load ports from ports.txt? [Y\N]:"
	read menu

	if [ $menu == "Y" ] || [ $menu == "y" ]
	then
		
		for lastbyte in $(seq 1 255)
		do
			printf "${CYAN}Scanning on $ip.$lastbyte\n"
			for port in $(cat ports.txt)
        	do
				openports=$(hping3 -S $ip.$lastbyte -c 1 --destport $port 2>/dev/null | grep "flags=SA" | cut -d "=" -f 6 | cut -d " " -f 1);
				if [ "$openports" != "" ]
				then
					printf "${PINK}Port: $openports is open\n"
				fi
			done
		done
	
	else
						#Specific typed ports
		printf "Type the ports that you want to scan (80, 443...1337): \n"
		read -ra portsArray 
		for lastbyte in $(seq 1 255)
		do
			printf "${CYAN}Scanning on $ip.$lastbyte\n"
			for port in "${portsArray[@]}"
			do
				openports=$(hping3 -S $ip.$lastbyte -c 1 --destport $port 2>/dev/null | grep "flags=SA" | cut -d "=" -f 6 | cut -d " " -f 1);
				if [ "$openports" != "" ]
				then
					printf "${PINK}Port: $openports is open\n"
				fi
			done
		done
	fi
;;
4)
	printf "Ip address (192.168.0): "
	read ip

	printf "What is the range that you want to scan? (min max)\n"
	printf "Example: 1 65535 \n"
	read -ra portsArray 
	min_port=${portsArray[0]}
	max_port=${portsArray[1]}

	for lastbyte in $(seq 1 255)
	do
		printf "${CYAN}Scanning on $ip.$lastbyte\n"
		for port in $(seq $min_port $max_port)
		do
			openports=$(hping3 -S $ip.$lastbyte -c 1 --destport $port 2>/dev/null | grep "flags=SA" | cut -d "=" -f 6 | cut -d " " -f 1);
			if [ "$openports" != "" ]
			then
				printf "${PINK}Port: $openports is open\n"
			fi
		done
	done
	



esac #end of the switch
 

