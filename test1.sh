#!/bin/bash

if [[ -f "./Main.java" ]]; then
  javac Main.java
  if [[ $? -ne 0 ]]; then  # Check for compilation errors
    echo "Compilation failed"
    exit 1
  fi

  passed=0
  failed=0
  total=0

  if [[ -d "test1/input" ]] && [[ -d "test1/output" ]]; then
    for input in test1/input/*.txt; do
      ((total++))
      base_name=$(basename "$input" .txt)
      output_file="test1/output/output${base_name:5}.txt"  # Change input to output
      java Main < "$input" > temp.txt
      if [[ $? -ne 0 ]]; then  # Check for execution errors
        echo "Execution failed for $input"
        ((failed++))
        continue
      fi

      if diff -qwB temp.txt "$output_file"; then
        echo "Test Passed: Output matches expected output for $base_name"
        ((passed++))
      else
        echo -e "Test Failed: Output does not match expected output for $base_name\n"
        echo -e "\tActual output:\n"
        ((failed++))
        cat temp.txt
        echo -e "\n\tExpected output:\n"
        cat "$output_file"
        echo ""
      fi
    done
  else
    echo "Error: Directories 'test1/input' or 'test1/output' not found."
    exit 1
  fi
  echo "-------------------------------"
  echo "$passed passed $failed failed"
  echo "-------------------------------"
  rm temp.txt
else
  echo "Coudn't find Main.java"
  exit 1
fi
