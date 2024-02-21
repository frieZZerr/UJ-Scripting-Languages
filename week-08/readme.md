# Diary Summary Generator

This Perl script generates a summary table from a file containing lines of the format:
- `FirstName LastName Grade`
where each line represents a single grade. The script organizes the data into a table with an alphabetically sorted list:
- `LastName FirstName: Grade List: Average (rounded to two decimal places).`

If multiple input files are provided, a separate table is generated for each file, and these tables are saved in files with the same name as the input file but with the `.oceny` extension. At the end of each output file, the average grade for the entire file/group is calculated.

## Additional Requirements:
- The project utilizes a data type called a dictionary (hash in Perl).
- An extended module from a previous project is used, containing a function that checks if a value is a valid grade and returns the appropriate value to calculate the average. Correct grades include expressions like 3+ or +3, which represent a quarter point higher, and -4 or 4-, which represent a quarter point lower. Grades like 3.3 are also considered valid and should be included in the average calculation.

Note that both first names and last names can be entered in any combination of uppercase and lowercase letters. However, the output should follow the standard Polish convention of capitalizing the first letter of both the first name and last name.

The script should handle all valid lines in the input file correctly, while any invalid lines should be output to stderr. Additionally, as an extra task for those interested, the script should be made resilient to the simplest error in the input file, which is splitting a correct line into two lines (e.g., after the first name or last name).

## Usage Example
- `perl script1.pl [options] input_file1.txt input_file2.txt ...`
