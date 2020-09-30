#!/bin/bash
PINK='\033[1;35m'
CYAN='\033[1;36m'


tmpfile=$(mktemp)


#check if the file ports.txt exists
#echo add ports 55 22 >> ports.txt


			#menu
printf "${PINK}=%.0s" {1..100} #print the pink line

printf "\n\n${CYAN}\t\t\t\t\tPort Fucker\n\n"
printf "\t\t\t\t(1)Scan for specific ports\n"
printf "\t\t\t\t(2)Scan for a range of ports\n"
printf "\t\t\t\t(3)Scan for specific ports on a IP range\n"
printf "\t\t\t\t(4)Scan for a range of ports on a IP range\n\n"

printf "${PINK}=%.0s" {1..100} #print the pink line
			#menu
printf "\n${CYAN}Choose an option: "
read menu #read the option picked by the user

case $menu in
1)
	printf "Load ports from ports.txt? [Y\N]:"
	read menu
	if [ $menu == "Y" ] || [ $menu == "y" ]
	then
		printf "Ip address: "
		read ip

		printf "Scanning on $ip\n"


		for port in $(cat ports.txt)
                do
                       hping3 -S $ip -c 1 --destport $port 2>/dev/null | grep "flags=SA" | cut -d "=" -f 6 | cut -d " " -f 1 >> "$tmpfile";
		done

		#print out the open ports saved in the open_ports.txt file
		for openport in $(cat "$tmpfile")
		do
			printf "${PINK}Port: $openport is open\n"
		done
		rm "$tmpfile"

	fi
;;

esac #end of the switch
