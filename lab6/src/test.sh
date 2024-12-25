#!/bin/bash
# Compile the program
make

# Initialize the diff file
diff_file="../tests/diff.txt"
echo "Diff Results for All Tests" > "$diff_file"
echo "==========================" >> "$diff_file"

# Array of test files
test_files=("example1.kpl" "example2.kpl" "example3.kpl" "example4.kpl" "example5.kpl" "example6.kpl")

# Loop through each test file
for i in "${!test_files[@]}"; do
  test_file="${test_files[$i]}"
  # Calculate the result file number (1-based index)
  result_number=$((i + 1))

  # Run the scanner and redirect the output to a result file
  ./kplc "../tests/$test_file" > "../tests/result_self${result_number}.txt"

  # Compare the generated result with the expected result and append to diff file
  echo -e "\nDifferences for $test_file:" >> "$diff_file"
  echo "--------------------------" >> "$diff_file"
  diff "../tests/result_self${result_number}.txt" "../tests/result${result_number}.txt" >> "$diff_file"

  # Check if there are differences
  if diff "../tests/result_self${result_number}.txt" "../tests/result${result_number}.txt" > /dev/null; then
    echo "Test $test_file passed"
  else
    echo "Test $test_file failed. See diff.txt for details."
  fi
done

# Standalone test for swap.kpl
./kplc "../tests/swap.kpl" > "../tests/result_swap_self.txt"

# Compare the generated result with the expected result and append to diff file
echo -e "\nDifferences for swap.kpl:" >> "$diff_file"
echo "--------------------------" >> "$diff_file"
diff "../tests/result_swap_self.txt" "../tests/result_swap.txt" >> "$diff_file"

# Check if there are differences
if diff "../tests/result_swap_self.txt" "../tests/result_swap.txt" > /dev/null; then
  echo "Test swap.kpl passed"
else
  echo "Test swap.kpl failed. See diff.txt for details."
fi