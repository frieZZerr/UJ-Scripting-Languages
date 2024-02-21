#!/usr/bin/tcsh -f

# Set defaults
set SERVER_MODE=false
set CLIENT_MODE=false
set DEFAULT_IP=localhost
set DEFAULT_PORT=8080

# Check args
foreach arg ($argv)
  if ( "$arg" == "-p" ) then
    set DEFAULT_PORT=$2
    shift
    shift
    continue
  endif
  if ( "$arg" == "-i" ) then
    set DEFAULT_IP=$2
    shift
    shift
    continue
  endif
  if ( "$arg" == "-c" ) then
    set CLIENT_MODE=true
    shift
    continue
  endif
  if ( "$arg" == "-s" ) then
    set SERVER_MODE=true
    shift
    continue
  endif
end

# Prepare files
if (! -f "client.sh") then
  ln -s script1.sh client.sh
endif
if (! -f "server.sh") then
  ln -s script1.sh server.sh
endif

set MODE=`basename "$0"`

# Server mode
if ( $SERVER_MODE == true || $MODE == "server.sh" ) then
  lsof -Pi :"$DEFAULT_PORT" -sTCP:LISTEN -t >/dev/null
  if ( $? == 0 ) then
    echo "Error: Server is already running on port $DEFAULT_PORT."
    exit 1
  endif

  set COUNTER = 0
  set FILE_LOCATION = "`pwd`/state_$DEFAULT_PORT"

  test -f "$FILE_LOCATION"
  if ( $? == 0 ) then
    set COUNTER=`<"$FILE_LOCATION"`
  endif

  while (1)
    printf 'COUNTER %s\r\n' "$COUNTER" | nc -l "$DEFAULT_IP" "$DEFAULT_PORT"
    @ COUNTER++
    echo $COUNTER > "$FILE_LOCATION"
  end
  exit 0
endif

# Client mode
if ( $CLIENT_MODE == true || $MODE == "client.sh" ) then
  nc -w 1 "$DEFAULT_IP" "$DEFAULT_PORT"
  exit 0
endif

exit 0
