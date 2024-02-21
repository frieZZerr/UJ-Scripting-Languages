#!/usr/bin/bash

# Arg check
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 ADRES_IP_1 ADRES_IP_2"
  exit 1
fi

check_ip() {
  local ip="$1"
  local ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

  if ! [[ "$ip" =~ $ip_regex ]]; then
    echo "Invalid IP address format."
    exit 1  # Bad IP address
  fi

  IFS="." read -ra ip_parts <<< "$1"

  for part in "$ip_parts"; do
    if [[ "$part" -gt 256 || "$part" -lt 0 ]]; then
      echo "Invalid IP address format."
      exit 1 # Bad IP address
    fi
  done
  
  return 0  # Correct IP address
}

ping_ip_range() {
  local ip1="$1"
  local ip2="$2"

  IFS="." read -ra ip1_parts <<< "$ip1"
  IFS="." read -ra ip2_parts <<< "$ip2"

  # Check bigger
  for ((i = 0; i < "${#ip1_parts[@]}"; i++)); do
    if [ "${ip2_parts[i]}" -lt "${ip1_parts[i]}" ]; then
      IFS="." read -ra ip1_parts <<< "$ip2"
      IFS="." read -ra ip2_parts <<< "$ip1"
      break
    fi
  done

  for i in $(seq "${ip1_parts[0]}" "${ip2_parts[0]}"); do
    for j in $(seq "${ip1_parts[1]}" "${ip2_parts[1]}"); do
      for k in $(seq "${ip1_parts[2]}" "${ip2_parts[2]}"); do
        for l in $(seq "${ip1_parts[3]}" "${ip2_parts[3]}"); do
          current_ip="$i.$j.$k.$l"
          if check_ip "$current_ip"; then
            timeout 10 ping -c 1 "$current_ip" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
              echo "{ $current_ip, ALIVE }"
            else
              echo "{ $current_ip, DEAD }"
            fi
          fi
        done
      done
    done
  done
}

# Check if IPs are valid
check_ip "$1"
check_ip "$2"

# Ping IP range
ping_ip_range "$1" "$2"
