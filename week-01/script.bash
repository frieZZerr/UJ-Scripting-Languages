#!/usr/bin/bash

default_mode() {
  echo "Login: $USER"
  echo "Imie i nazwisko: $(getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1)"
}

display_help() {
  echo "Skrypt nr 1 | bash"
  echo "Bez argumentow: Wyswietla login oraz imie i nazwisko wywolujacego"
  echo "Uzycie: $0 [opcje]"
  echo "  -h, --help      Wyswietla pomoc"
  echo "  -q, --quiet     Konczy dzialanie"
}


# Look for -h flag first
for arg in "$@"; do
  case $arg in
    -h|--help)
    display_help
    exit 0
    ;;
  esac
done


# Check arguments
if [ "$#" -eq 0 ]; then
  default_mode
else
  # Consider -hq & -qh combinations
  if [[ "$@" == *"-hq"* ]] || [[ "$@" == *"-qh"* ]]; then
    display_help
    exit 0
  fi

  for arg in "$@"; do
    case $arg in
      -q|--quiet)
      exit 0
      ;;
    esac
  done

  # Ignore other options
  default_mode
fi
