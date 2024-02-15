#!/bin/bash

# Run the sync-content.sh script which is outside of this repo
../sync-content.sh
wait

# Add all changes to the staging area
git add content

# Check if there are any changes
if [[ -z $(git status --porcelain) ]]; then
  echo "No changes to commit. Exiting..."
  exit 0
fi

# Commit the changes
git commit -m "Sync content"

# Push the changes to the remote repository
git push