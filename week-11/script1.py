#!/usr/bin/env python3

import re

def main():
    # Check args
    import sys
    if len(sys.argv) < 2:
        print("Usage:", sys.argv[0], "file1 [file2 ...]")
        sys.exit(1)

    for input_file in sys.argv[1:]:
        with open(input_file, 'r') as fh:
            data = fh.readlines()

        output = create_report(data)

        output_file = re.sub(r'\..+$', '.oceny', input_file)
        with open(output_file, 'w') as out_fh:
            out_fh.writelines(data)
            out_fh.write(output)

        print("Saved data from", input_file, "to", output_file)

def create_report(data):
    grades = {}
    name = ""

    for line in data:
        elements = line.split()
        name = f"{elements[0].capitalize()} {elements[1].capitalize()}"
        grade = process_grade(elements[2])
        grades.setdefault(name, []).append(grade)

    output = "\n"
    for person, person_grades in grades.items():
        average = calculate_average(person_grades)
        output += f"{person} Lista ocen: {person_grades} Średnia: {average:.2f}\n"

    return output

def process_grade(grade):
    add = 0

    match = re.search(r'([+-])(\d)', grade)
    if match:
        grade = match.group(2) + match.group(1) if match.group(1) in ['+', '-'] else grade

    if grade.endswith('+'):
        add += 0.25
    elif grade.endswith('-'):
        add -= 0.25

    grade = grade.replace('+', '').replace('-', '')

    try:
        grade = float(grade)
        if 1 <= grade <= 6:
            return grade + add
    except ValueError:
        print("Wrong format:", grade)

    return None

def calculate_average(grades):
    if grades:
        return sum(grades) / len(grades)
    return 0

if __name__ == "__main__":
    main()
