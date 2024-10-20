#!/bin/bash

# Define variables
REPO_URL="https://github.com/TheeKingZa/De-Muskerteers.git"
BRANCH_MAIN="master"
BRANCH_GH_PAGES="gh-pages"

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    if [ $? -ne 0 ]; then
        echo "Error initializing git."
        exit 1
    fi
else
    echo "Git already initialized."
fi

# Add all files
echo "Adding files to staging..."
git add .
if [ $? -ne 0 ]; then
    echo "Error adding files."
    exit 1
fi

# Commit files
echo "Committing files..."
git commit -m "Automated commit for GitHub Pages deployment"
if [ $? -ne 0 ]; then
    echo "Error committing files."
    exit 1
fi

# Check if remote origin is already set
git remote | grep origin &> /dev/null
if [ $? -ne 0 ]; then
    echo "Adding remote origin..."
    git remote add origin $REPO_URL
    if [ $? -ne 0 ]; then
        echo "Error adding remote origin."
        exit 1
    fi
else
    echo "Remote origin already exists."
fi

# Fetch any remote changes to avoid conflicts
echo "Fetching remote changes..."
git fetch origin $BRANCH_MAIN
if [ $? -ne 0 ]; then
    echo "Error fetching remote changes."
    exit 1
fi

# Merge remote changes into local branch
echo "Merging remote changes into local branch..."
git merge origin/$BRANCH_MAIN --allow-unrelated-histories
if [ $? -ne 0 ]; then
    echo "Error merging remote changes. Resolve conflicts manually."
    exit 1
fi

# Push to the main branch
echo "Pushing to main branch..."
git branch -M $BRANCH_MAIN
git push -u origin $BRANCH_MAIN
if [ $? -ne 0 ]; then
    echo "Error pushing to main branch."
    exit 1
fi

# Check if the gh-pages branch exists locally
if git show-ref --quiet refs/heads/$BRANCH_GH_PAGES; then
    echo "$BRANCH_GH_PAGES branch already exists locally."
else
    echo "Creating $BRANCH_GH_PAGES branch..."
    git checkout -b $BRANCH_GH_PAGES
fi

# Push to the gh-pages branch
echo "Pushing to gh-pages branch..."
git push origin $BRANCH_GH_PAGES
if [ $? -ne 0 ]; then
    echo "Error pushing to gh-pages branch."
    exit 1
fi

# Display success message with GitHub Pages link
echo "Deployment successful!"
echo "Your site should be available soon at: https://theekingza.github.io/De-Muskerteers/"

