#!/usr/bin/tcsh

# Arg check
if ("$#" != 3) then
  echo "Usage: $0 ADRES_IP_1 ADRES_IP_2 PORTS"
  exit 1
endif

set ip1 = $1
set ip2 = $2
set ports_arg = $3

# Check port regex
set port_regex='^[1-9][0-9]*$'

set ports = `echo $ports_arg | tr "," " "`

foreach port ($ports)
    if ! ($port =~ $port_regex) then
        echo "Invalid port format."
        exit 1
    endif
end

# Check IP regex
set ip_regex = '^([0-9]{1,3}\.){3}[0-9]{1,3}$'

if ( ! ($ip1 =~ $ip_regex) || ! ($ip2 =~ $ip_regex) ) then
    echo "Invalid IP address format."
    exit 1
endif

# Split IP parts
set ip1_parts = `echo $ip1 | tr "." " "`
set ip2_parts = `echo $ip2 | tr "." " "`

# Check IP range
set bigger = 0
foreach i (`seq 1 $#ip1_parts`)
    if ( $ip2_parts[$i] < $ip1_parts[$i] ) then
        set bigger = 1
        break
    endif
end

if ( $bigger == 1 ) then
    set ip1_parts = `echo $ip2 | tr "." " "`
    set ip2_parts = `echo $ip1 | tr "." " "`
endif

# Pinging IP range
foreach port ($ports)
    foreach i (`seq $ip1_parts[1] $ip2_parts[1]`)
        foreach j (`seq $ip1_parts[2] $ip2_parts[2]`)
            foreach k (`seq $ip1_parts[3] $ip2_parts[3]`)
                foreach l (`seq $ip1_parts[4] $ip2_parts[4]`)
                    set current_ip = "$i.$j.$k.$l"
                    set ip_regex_check = '^([0-9]{1,3}\.){3}[0-9]{1,3}$'

                    # Check IP
                    if ( ! ($current_ip =~ $ip_regex_check) ) then
                        echo "Invalid IP address format."
                        exit 1
                    endif

                    # Ping
                    set result = `nc -zv -w 1 "$current_ip" "$port" >& /dev/null; echo $?`
                    
                    if ( $result == 0 ) then
                        echo "{ $current_ip":"$port, ALIVE }"
                    else
                        echo "{ $current_ip":"$port, DEAD }"
                    endif
                end
            end
        end
    end
end
