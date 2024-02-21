# Server and Client Counter Script

This script consists of two parts: a server and a client, both available in bash and tcsh.

## Server Counter
The server component serves as a counter and can be set up on any port using the `-p port` option. It ensures the following:
- It prevents multiple instances from running on the same port. If attempted, subsequent instances will be terminated with a friendly message.
- It remembers its state between executions, starting from the last recorded count. It considers how to store this state for each port.
- It can also be executed as its own client, with behavior regulated by both the invocation option and the name it is called by.

### Invocation Options
- `-s`: Start the server.
- `-c`: Start the client.

### Default Settings
- The default memory location and port settings should be sensible but configurable via options and an rc file, in order of precedence: option, rc file, default.
- Optionally, an `-f filename` option allows overriding the default rc file name. The suggested filenames are `.counter.rc` for the bash version and `.counter.csh` for the tcsh version.

### Additional Option
- `-i IP`: Forces the use of a specific IP address instead of the default behavior, which utilizes all local IP numbers.

## Client Counter
The client component interacts with the server to query and display the current count.

### Usage Example
```bash
# Start the server on port 8080
./script1.sh -s -p 8080

# Start the client to query the server
./script1.sh -c
```
