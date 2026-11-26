#!/usr/bin/env bash
# Checks that a pull request adds exactly one complete team folder.
# Usage: check-submission.sh <base-ref>
set -uo pipefail

base="${1:-origin/main}"
failed=0

error() {
  echo "::error::$1"
  echo "❌ $1"
  failed=1
}

changed=$(git diff --name-only "$base"...HEAD)

if [ -z "$changed" ]; then
  error "This pull request does not change any files."
  exit 1
fi

# 1. Only files inside teams/
outside=$(echo "$changed" | grep -v '^teams/' || true)
if [ -n "$outside" ]; then
  error "Only change files inside teams/<your-folder>/. These files are outside: $(echo $outside)"
fi

# 2. Exactly one team folder
folders=$(echo "$changed" | grep '^teams/[^/]*/' | cut -d/ -f2 | sort -u)
count=$(echo "$folders" | grep -c . || true)
if [ "$count" -ne 1 ]; then
  error "Change exactly one team folder. Found $count: $(echo "$folders" | paste -sd ',' - | sed 's/,/, /g')"
fi

# 3. Each changed folder is complete
while IFS= read -r name; do
  [ -z "$name" ] && continue
  dir="teams/$name"
  # README (any capitalization)
  readme=$(find "$dir" -maxdepth 1 -type f -iname 'readme.md' | head -1)
  if [ -z "$readme" ]; then
    error "README.md is missing in $dir/. Copy it from TEMPLATE/."
  elif grep -q "Replace everything in this file" "$readme"; then
    error "$readme still contains the template text. Fill it in."
  fi

  # Slides: any PDF, but not the template
  real_pdf=0
  while IFS= read -r pdf; do
    [ -z "$pdf" ] && continue
    if cmp -s "$pdf" TEMPLATE/slides.pdf; then
      error "$pdf is still the template PDF. Delete it or replace it with your slides."
    else
      real_pdf=1
    fi
  done <<< "$(find "$dir" -type f -iname '*.pdf')"
  if [ "$real_pdf" -eq 0 ]; then
    error "No slides found in $dir/. Export your slides as PDF."
  fi

  # Demo: an Xcode project anywhere in the folder
  if [ -z "$(find "$dir" -name '*.xcodeproj' -o -name 'Package.swift' -o -name '*.swiftpm' | head -1)" ]; then
    error "No Xcode project found in $dir/."
  fi
done <<< "$folders"

# 4. No big files
while IFS= read -r file; do
  if [ -f "$file" ]; then
    size=$(wc -c < "$file" | tr -d ' ')
    if [ "$size" -gt 52428800 ]; then
      error "$file is bigger than 50 MB. Link videos instead of adding them."
    fi
  fi
done <<< "$changed"

if [ "$failed" -eq 0 ]; then
  echo "✅ Looks good: teams/$folders is complete."
fi
exit "$failed"
