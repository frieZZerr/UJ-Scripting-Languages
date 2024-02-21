# Script for Pinging IP Addresses

## Script 1

This script pings all IP addresses between the ones provided as arguments, arranging the results in ascending order. It checks the correctness of the arguments as IP addresses and displays a pair "IP_number alive/dead".

### Pinging IP Addresses
- Pings ALL IP numbers from the one provided as the first argument to the one provided as the second argument.
- If the arguments are in the wrong order, the order is reversed.
- Any remaining arguments, if present, are ignored.
- Checks the validity of both arguments as IP addresses.

### Results
- The results are arranged in ascending order of the IP numbers, regardless of the order of the arguments.
- For each IP number, it displays a pair "IP_number alive/dead".
- Consideration of handling addresses in a human-readable form, e.g., mail.uj.edu.pl.

### Usage Example
- `./script1.sh 192.168.0.1 192.168.0.10`

## Script 2

This script is a simple modification of the third script. It determines whether and which servers respond on ports specified as the third argument of the call, which is a list of numeric ports separated by commas, for IP numbers specified as before by the first two arguments. For each IP number, it provides the shortest possible information about each server in one line, such as:
- `149.156.90.10: ssh - OpenSSH 6.0pl1, http - apache 1.3.67, https - httpd 2.0.57`

Optionally, it can also provide the operating system information for the entire result. If something responds on a particular port but it is difficult to determine what it is, it simply writes "open". For ports where nothing responds, it writes "closed".

### Caveats
- Servers may provide false information about their identity, but this possibility is ignored at this stage as it is not easy to verify, let alone counteract.
- Some servers do not provide any information without the client sending something to them, which requires additional investigation to obtain any reasonable response from the server.

### Usage Example
- `./script2.sh 192.168.0.1 192.168.0.10 22,80,443`
