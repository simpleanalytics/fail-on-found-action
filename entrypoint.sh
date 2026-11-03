#!/bin/bash

set -eu -o pipefail

# Remove spaces from the comma-separated string
QUERY_TERMS=$(echo "$INPUT_QUERY" | sed 's/, /,/g')

# Convert comma-separated string to pipe-separated string
EXCLUDE_FOLDERS=$(echo "$INPUT_EXCLUDE" | sed -E 's/, ?/|/g')

found=0

IFS=',' read -ra terms <<< "$QUERY_TERMS"

# Match whole words only, so "trail" doesn't match "trailing". Only add a word
# boundary to a side that ends in a word character, so terms such as
# '.indexOf("' still match after "str".
patterns=()
for term in "${terms[@]}"; do
  pattern="$term"
  if [[ $pattern =~ ^[[:alnum:]_] ]]; then pattern="\\b$pattern"; fi
  if [[ $pattern =~ [[:alnum:]_]$ ]]; then pattern="$pattern\\b"; fi
  patterns+=("$pattern")
done

# Loop through all text files in the repo
while IFS= read -r file; do
  for i in "${!terms[@]}"; do
    # Annotate every line that contains the term
    while IFS=: read -r line _; do
      echo "::warning file=${file#./},line=$line,title=Forbidden word::Found '${terms[$i]}'"
      found=$((found + 1))
    done < <(grep -nI -- "${patterns[$i]}" "$file" || true)
  done
done < <(find . -type f | grep -vE "$EXCLUDE_FOLDERS")

if [[ $found -gt 0 ]]; then
  echo "Found $found forbidden word(s), see the warnings"
else
  echo "Did not find any forbidden words"
fi
