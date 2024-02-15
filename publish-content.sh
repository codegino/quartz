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
commit_message="Sync content at $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_message"

# Push the changes to the remote repository
# Disabling for now
# git push