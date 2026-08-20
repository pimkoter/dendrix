#!/usr/bin/env bash

# Target directory to clone repositories into
echo "Fetching repository list from GitHub..."

# Fetch only active (non-archived) repo clone URLs
repos=$(gh repo list --limit 1000 --json sshUrl,isArchived --jq '.[] | select(.isArchived == false) | .sshUrl')

if [ -z "$repos" ]; then
    echo "No repositories found or failed to fetch list."
    exit 1
fi

for repo in $repos; do
    echo "----------------------------------------"
    repo_name=$(basename "$repo" .git)
    if [ -d "$repo_name" ]; then
        echo "Directory $repo_name already exists. Pulling latest changes..."
        git -C "$repo_name" pull
    else
        echo "Cloning $repo..."
        git clone "$repo"
    fi
done

echo "----------------------------------------"
echo "All done! Repositories were downloaded!"
