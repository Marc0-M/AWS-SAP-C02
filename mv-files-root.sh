#!/bin/bash

# Generate initial list
find . -name "*.md" | sort > before.txt

# Move all .md files to root
find . -name "*.md" -exec mv {} . \;

# Check if any remain in subdirs
remaining=$(find . -mindepth 2 -name "*.md" | wc -l)

if [ "$remaining" -eq 0 ]; then
    echo "✅ All .md files moved successfully!"
else
    echo "❌ Some .md files remain in subdirectories:"
    find . -mindepth 2 -name "*.md"
fi

# Cleanup
rm before.txt