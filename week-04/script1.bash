#!/usr/bin/bash

# Set defaults
SERVER_MODE=false
CLIENT_MODE=false
DEFAULT_IP=localhost
DEFAULT_PORT=8080

# Check args
for arg in "$@"; do
  case $1 in
  -p)
    PORT="$2"
    shift
    ;;
  -i)
    IP="$2"
    shift
    ;;
  -c)
    CLIENT_MODE=true
    shift
    ;;
  -s)
    SERVER_MODE=true
    shift
    ;;
  \?)
    echo "Invalid option: -$1" >&2
    exit 1
    ;;
  esac
done

# Prepare files
if ! [ -f "client.sh" ]; then
  ln -s script1.sh client.sh
fi
if ! [ -f "server.sh" ]; then
  ln -s script1.sh server.sh
fi

PORT=${PORT:-$DEFAULT_PORT}
IP=${IP:-$DEFAULT_IP}
MODE=$(basename "$0")

# Server mode
if [ "$SERVER_MODE" = true ] || [ "$MODE" = "server.sh" ]; then
  if lsof -Pi :"$PORT" -sTCP:LISTEN -t >/dev/null; then
    echo "Error: Server is already running on port $PORT."
    exit 1
  fi

  COUNTER=0
  FILE_LOCATION="$(pwd)/state_$PORT"

  if test -f "$FILE_LOCATION"; then
    COUNTER=$(<"$FILE_LOCATION")
  fi

  while true; do
    printf 'COUNTER %s\r\n' "$COUNTER" | nc -l "$IP" "$PORT"
    ((COUNTER++))
    echo $COUNTER >"$FILE_LOCATION"
  done
  exit 0
fi

# Client mode
if [ "$CLIENT_MODE" = true ] || [ "$MODE" = "client.sh" ]; then
  nc -w1 "$IP" "$PORT"
  exit 0
fi

exit 0
