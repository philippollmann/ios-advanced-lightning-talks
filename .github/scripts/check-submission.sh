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
  error "Change exactly one team folder. Found $count: $(echo $folders)"
fi

# 3. Each changed folder is complete
for name in $folders; do
  dir="teams/$name"
  if ! [[ "$name" =~ ^[a-z0-9-]+$ ]]; then
    error "Folder name '$name': use only lowercase letters, numbers and dashes (e.g. foundation-models)."
  fi
  if [ ! -f "$dir/README.md" ]; then
    error "$dir/README.md is missing. Copy it from TEMPLATE/."
  elif grep -q "Replace everything in this file" "$dir/README.md"; then
    error "$dir/README.md still contains the template text. Fill it in."
  fi
  if [ ! -f "$dir/slides.pdf" ]; then
    error "$dir/slides.pdf is missing. Export your slides as PDF."
  fi
  if [ ! -f "$dir/screenshot.png" ]; then
    error "$dir/screenshot.png is missing."
  fi
  if [ ! -d "$dir/Demo" ]; then
    error "$dir/Demo/ is missing."
  elif [ -z "$(find "$dir/Demo" -name '*.xcodeproj' -o -name 'Package.swift' -o -name '*.swiftpm' | head -1)" ]; then
    error "No Xcode project found in $dir/Demo/."
  fi
done

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
