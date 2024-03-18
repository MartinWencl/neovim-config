#! /usr/bin/env python3

import sqlparse
import sys

def main():
    contents = sys.stdin.read()
    result = sqlparse.format(contents,
                             indent_columns=True,
                             keyword_case="lower",
                             identifier_case="upper",
                             reindent=True,
                             # reindent_aligned=True,
                             output_format="sql",
                             indent_after_first=True,
                             wrap_after=100,
                             comma_first=True
    )
    print(result.strip(), file=sys.stdout)

if __name__ == "__main__":
   main() 
