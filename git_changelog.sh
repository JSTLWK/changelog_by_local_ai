#!/bin/bash

# Set the repo directory to the current location
REPO_DIR="$(pwd)"

# Set the Ollama model (change if needed)
MODEL="llama3"

# Ensure it's a Git repository
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Error: No Git repository found in $REPO_DIR"
    exit 1
fi

# Get unstaged + staged changes
DIFF=$(git diff --unified=5)  # Show 5 lines of context
STAGED_DIFF=$(git diff --staged --unified=5)

# Combine both diffs
FULL_DIFF="${DIFF}\n${STAGED_DIFF}"

if [ -n "$FULL_DIFF" ]; then
    # Format the prompt for Ollama
    PROMPT="Generate a clear changelog summary in bullet points based on these local code changes using the following categories:

    - **Changed**: Modifications or updates
    - **Added**: New features or files
    - **Fixed**: Bug fixes or corrections
    - **Removed**: Eliminations or deprecations
    - **Deprecated**: Features marked for future removal
    - **Security**: Security-related updates

    Keep it **brief** and **non-programmer friendly**. Here are the changes:\n\n$FULL_DIFF"

    # Run Ollama
    RESPONSE=$(echo -e "$PROMPT" | ollama run "$MODEL")

    # Print response
    echo "=== Changelog Summary ==="
    echo "$RESPONSE"
else
    echo "No local changes detected."
fi


