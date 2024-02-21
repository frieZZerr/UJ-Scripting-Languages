## Retrieve data

This script retrieves the user's login name and full name. It utilizes desktop information to access this data. When executed without any arguments, it displays the user's login name and full name. Additionally:

- When called with the `-h` or `--help` option, it provides a brief description of its functionality.
- When called with the `-q` or `--quiet` option, it terminates without performing any action.
- Unknown options or arguments are ignored.
- If an argument does not resemble an option, the script behaves as if it were called without any arguments, exiting with an error code of 0.
