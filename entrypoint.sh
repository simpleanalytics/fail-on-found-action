#!/bin/bash

set -eu -o pipefail

# Remove spaces from the comma-separated string
QUERY_TERMS=$(echo "$INPUT_QUERY" | sed 's/, /,/g')

# Convert comma-separated string to pipe-separated string
EXCLUDE_FOLDERS=$(echo "$INPUT_EXCLUDE" | sed -E 's/, ?/|/g')

# Set found to 0
found=0

# Split the query terms into an array outside the loop for efficiency
IFS=',' read -ra terms <<< "$QUERY_TERMS"

# Loop through all files in the repo
find . -type f | grep -vE "$EXCLUDE_FOLDERS" | while read -r file; do
  # Loop through the array of forbidden terms
  for term in "${terms[@]}"; do
    # If the term is found as a whole word in the file, set found to 1
    if grep -qw "$term" "$file"; then
      echo "Found '$term' in file '$file'"
      found=1
    fi
  done
done

# If found is 1, exit and fail with 1
if [[ $found -eq 1 ]]; then
  echo "Failed because it did find (one of) your query terms in your files"
  exit 1
else
  echo "Success! Did not find query terms in files"
fi
