#!/usr/bin/bash

# Arg check
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 ADRES_IP_1 ADRES_IP_2 PORTS"
  exit 1
fi

check_port() {
  local port="$1"
  local port_regex="^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$"

  if ! [[ "$port" =~ $port_regex ]]; then
    echo "Invalid port format."
    exit 1  # Bad port
  fi

  return 1  # Correct port
}

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
  local port="$3"

  IFS="." read -ra ip1_parts <<< "$ip1"
  IFS="." read -ra ip2_parts <<< "$ip2"
  IFS=',' read -ra ports <<< "$port"

  # Check bigger
  for ((i = 0; i < "${#ip1_parts[@]}"; i++)); do
    if [ "${ip2_parts[i]}" -lt "${ip1_parts[i]}" ]; then
      IFS="." read -ra ip1_parts <<< "$ip2"
      IFS="." read -ra ip2_parts <<< "$ip1"
      break
    fi
  done

  for port in "${ports[@]}"; do
    for i in $(seq "${ip1_parts[0]}" "${ip2_parts[0]}"); do
      for j in $(seq "${ip1_parts[1]}" "${ip2_parts[1]}"); do
        for k in $(seq "${ip1_parts[2]}" "${ip2_parts[2]}"); do
          for l in $(seq "${ip1_parts[3]}" "${ip2_parts[3]}"); do
            current_ip="$i.$j.$k.$l"
            if check_ip "$current_ip"; then
              answer=$(nc -zv -w 1 "$current_ip" "$port" 2>&1)
              if [ $? -eq 0 ]; then
                info="$(grep -o '\[.*\]' <<< $answer)"
                echo "{ $current_ip:$port, ALIVE, $info }"
              else
                echo "{ $current_ip:$port, DEAD }"
              fi
            fi
          done
        done
      done
    done
  done
}

# Check if IPs are valid
check_ip "$1"
check_ip "$2"

# Check if ports are valid
IFS=',' read -ra ports <<< "$arg"

for port in "${ports[@]}"; do
  check_port "$port"
done

# Ping IP range
ping_ip_range "$1" "$2" "$3"
