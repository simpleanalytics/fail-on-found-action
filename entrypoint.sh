#!/bin/bash

set -eu -o pipefail

# Remove spaces from the comma separated string
QUERY_TERMS=$(echo "$INPUT_QUERY" | sed 's/, /,/g')

# Convert comma separated string to pipe separated string
EXCLUDE_FOLDERS=$(echo "$INPUT_EXCLUDE" | sed -E 's/, ?/|/g')

# Set found to 0
found=0

# Loop through all files in the repo
for file in $(find . -type f | grep -vE "$EXCLUDE_FOLDERS"); do

  # Split the query terms into an array
  IFS=',' read -ra terms <<< "$QUERY_TERMS"

  # Loop through the array
  for term in "${terms[@]}"; do

    # If the term is found in the file, set found to 1
    if grep -q "$term" "$file"; then
      echo "Found '$term' in file '$file'"
      found=1
    fi
  done
done

# If found is 1, exit and fail with 1
if [[ $found -eq 1 ]]; then
  echo "Found your query terms in files"
  exit 1
else
  echo "Did not find query terms in files"
fi
