#!/bin/bash

# Run the sync-content.sh script
../sync-content.sh

# Add all changes to the staging area
git add .

# Commit the changes
git commit -m "Sync content"

# # Push the changes to the remote repository
# git push