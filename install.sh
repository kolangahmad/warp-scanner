#!/bin/bash

GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

get_values() {

    local api_output=$(curl -sL "https://api.zeroteam.top/warp?format=sing-box")
    
    local ipv6=$(echo "$api_output" | grep -oE '"2606:4700:[0-9a-f:]+/128"' | sed 's/"//g')
    local private_key=$(echo "$api_output" | grep -oE '"private_key":"[0-9a-zA-Z\/+]+=+"' | sed 's/"private_key":"//; s/"//')
    local public_key=$(echo "$api_output" | grep -oE '"peer_public_key":"[0-9a-zA-Z\/+]+=+"' | sed 's/"peer_public_key":"//; s/"//')
    local reserved=$(echo "$api_output" | grep -oE '"reserved":\[[0-9]+(,[0-9]+){2}\]' | sed 's/"reserved"://; s/\[//; s/\]//')
    

    echo "$ipv6@$private_key@$public_key@$reserved"
}

case "$(uname -m)" in
	x86_64 | x64 | amd64 )
	    cpu=amd64
	;;
	i386 | i686 )
        cpu=386
	;;
	armv8 | armv8l | arm64 | aarch64 )
        cpu=arm64
	;;
	armv7l )
        cpu=arm
	;;
	* )
	echo "The current architecture is $(uname -m), temporarily not supported"
	exit
	;;
esac

cfwarpIP(){
echo "download warp endpoint file base on your CPU architecture"
if [[ -n $cpu ]]; then
curl -L -o warpendpoint -# --retry 2 https://raw.githubusercontent.com/kolangahmad/warp-scanner/main/cpu/$cpu
fi
}

endipv4(){
	n=0
	iplist=100
	while true
	do
		temp[$n]=$(echo 162.159.192.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 162.159.193.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 162.159.195.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.96.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.97.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.98.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.99.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
	done
	while true
	do
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.192.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.193.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.195.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.96.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.97.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.98.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.99.$(($RANDOM%256)))
			n=$[$n+1]
		fi
	done
}


endipresult(){
temp_var=$1
echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u > ip.txt
ulimit -n 102400
chmod +x warpendpoint
./warpendpoint
clear
echo "${GREEN}successfully generated ipv4 endip list${RESET}"
echo "${GREEN}successfully create result.csv file${RESET}"
echo "${CYAN}Now we're going to process result.csv${RESET}"
process_result_csv $temp_var
rm -rf ip.txt result.csv
exit
}



process_result_csv() {
count_conf=$1

values=$(get_values)
w_ip=$(echo "$values" | cut -d'@' -f1)
w_pv=$(echo "$values" | cut -d'@' -f2)
w_pb=$(echo "$values" | cut -d'@' -f3)
w_res=$(echo "$values" | cut -d'@' -f4)

i_values=$(get_values)
i_w_ip=$(echo "$i_values" | cut -d'@' -f1)
i_w_pv=$(echo "$i_values" | cut -d'@' -f2)
i_w_pb=$(echo "$i_values" | cut -d'@' -f3)
i_w_res=$(echo "$i_values" | cut -d'@' -f4)


    
    num_lines=$(wc -l < ./result.csv)
    echo ""
    echo "We have considered the number of ${num_lines} IPs."
    echo ""

if [ "$count_conf" -lt "$num_lines" ]; then
    num_lines=$count_conf
elif [ "$count_conf" -gt "$num_lines" ]; then
    echo "Warning: The number of IPs found is less than the number you want!"
    num_lines=$count_conf
fi




    
    for ((i=2; i<=$num_lines; i++)); do
        
        local line=$(sed -n "${i}p" ./result.csv)
        local endpoint=$(echo "$line" | awk -F',' '{print $1}')
        local ip=$(echo "$endpoint" | awk -F':' '{print $1}')
        local port=$(echo "$endpoint" | awk -F':' '{print $2}')


new_json='{
      "type": "wireguard",
      "tag": "(@warp)'"$i"'",
      "server": "'"$ip"'",
      "server_port": '"$port"',

      "local_address": [
        "172.16.0.2/32",
        "'"$w_ip"'"
      ],
      "private_key": "'"$w_pv"'",
      "peer_public_key": "'"$w_pb"'",
      "reserved": ['$w_res'],

      "mtu": 1280,
      "fake_packets": "5-10"
    },
    {
      "type": "wireguard",
      "tag": "ÐΛɌ₭ᑎΞ𐒡𐒡'"$i"'",
      "detour": "(@warp)'"$i"'",
      "server": "'"$ip"'",
      "server_port": '"$port"',
      
      "local_address": [
          "172.16.0.2/32",
          "'"$i_w_ip"'"
      ],
      "private_key": "'"$i_w_pv"'",
      "peer_public_key": "'"$i_w_pb"'",
      "reserved": ['$i_w_res'],  

      "mtu": 1120,
      "fake_packets": "5-10"
    }'


    temp_json+="$new_json"
if [ $i -lt $num_lines ]; then
    temp_json+=","
fi

    done
full_json='
{
  "outbounds": 
  [
    '"$temp_json"'
  ]
}
'
echo "$full_json" > output.json
echo ""
outputFIle=output_$(date +"%Y%m%d_%H%M%S").json
echo "${GREEN}$outputFIle file is ready${RESET}"
mv output.json $outputFIle

}
menu(){
clear
echo ""
echo ""
echo ""
echo "${BLUE}   ✴️Welcome to Quick🔸(Warp on Warp)🔸${RESET}"
echo ""
echo ""
echo ""
echo ""
echo "${GREEN}▶️ 1.Automatic scanning and execution (Android / Linux)${RESET}"
echo "${GREEN}▶️ 2.Import custom IPs with result.csv file (windows)${RESET}"
echo ""
echo ""
read -r -p "${CYAN}▶️ Please choose an option:${RESET} " option
if [ "$option" = "1" ]; then
echo ""
echo ""
echo ""
echo "${BLUE}▶️ How many configurations do you need?${RESET}"
read -r -p "${BLUE} Number of required configurations(suggested 5 or 10)${RESET}:  " number_of_configs
if [ ! -f ./warpendpoint ]; then
    cfwarpIP
fi
endipv4
endipresult $number_of_configs
elif [ "$option" = "2" ]; then
	read -r -p "▶️ ${BLUE} Number of required configurations(suggested 5 or 10)${RESET}:  " number_of_configs
	process_result_csv $number_of_configs
else
	echo "Invalid option"
fi



}

menu
