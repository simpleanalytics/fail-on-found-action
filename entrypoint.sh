#!/bin/bash

set -eu -o pipefail

# Remove spaces from the comma-separated string
QUERY_TERMS=$(echo "$INPUT_QUERY" | sed 's/, /,/g')

# Convert comma-separated string to pipe-separated string
EXCLUDE_FOLDERS=$(echo "$INPUT_EXCLUDE" | sed -E 's/, ?/|/g')

# Annotate found words as errors and fail, or as warnings when warn is true
level=error
if [[ ${INPUT_WARN:-false} == true ]]; then level=warning; fi

found=0

IFS=',' read -ra terms <<< "$QUERY_TERMS"

# Loop through all text files in the repo
while IFS= read -r file; do
  for term in "${terms[@]}"; do
    # Skip empty terms, such as from a trailing comma, because they match every line
    if [[ -z $term ]]; then continue; fi

    # Match whole words only, so "trail" doesn't match "trailing". Only add a
    # word boundary to a side that ends in a word character, so terms such as
    # '.indexOf("' still match after "str".
    pattern="$term"
    if [[ $pattern =~ ^[[:alnum:]_] ]]; then pattern="\\b$pattern"; fi
    if [[ $pattern =~ [[:alnum:]_]$ ]]; then pattern="$pattern\\b"; fi

    while IFS=: read -r line _; do
      # GitHub shows only the first 10 annotations, so also log every location
      echo "Found '$term' in ${file#./}:$line"
      echo "::$level file=${file#./},line=$line,title=Forbidden word::Found '$term'"
      found=$((found + 1))
    done < <(grep -nI -- "$pattern" "$file" || true)
  done
done < <(find . -type f | grep -vE "$EXCLUDE_FOLDERS")

if [[ $found -gt 0 ]]; then
  echo "Found $found forbidden word(s)"
  if [[ $level == error ]]; then exit 1; fi
else
  echo "Did not find any forbidden words"
fi
