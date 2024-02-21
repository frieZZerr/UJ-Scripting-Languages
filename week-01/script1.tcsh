#!/usr/bin/tcsh

alias display_help 'echo "Skrypt nr 1 | tcsh"; echo "Uzycie: $0 [opcje]"; echo "  -h, --help    Wyswietla pomoc"; echo "  -q, --quiet   Konczy dzialanie";'

alias default_mode 'echo "Login name: $USER"; echo "Imie i nazwisko: `getent passwd $USER | cut -d: -f5 | cut -d ',' -f 1`";'


# Look for -h flag first
foreach arg ($*)
  if ("$arg" == "-h" || "$arg" == "--help") then
    display_help
    exit 0
  endif
end

# Check arguments
if ($#argv == 0) then
  default_mode
  exit 0
else
  # Consider -hq & -qh combinations
  foreach arg ($*)
    if ("$arg" == "-hq" || "$arg" == "-qh") then
      display_help
      exit 0
    endif
  end

  foreach arg ($*)
    if ("$arg" == "-q" || "$arg" == "--quiet") then
      exit 0
    endif
  end

  # Ignore other options
  default_mode
endif
