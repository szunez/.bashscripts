#!/bin/bash
ROOT_DIR="$1"
OUTPUT_DIR="$2"

# Check if root directory exists
if [ ! -d "$ROOT_DIR" ]; then
    echo "Error: Root directory '$ROOT_DIR' does not exist."
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through all immediate subdirectories in the root directory
for dir in "$ROOT_DIR"/*/ ; do
    # Check if the directory exists and is indeed a directory
    if [ -d "$dir" ]; then
        DELIVERABLES_DIR="${dir}6 Deliverables"
        if [ -d "$DELIVERABLES_DIR" ]; then
            find "$DELIVERABLES_DIR" -type f -name "*.pptx" -exec cp -v {} "$OUTPUT_DIR" \;
        fi
    fi
done