# Git Cheat Sheet

## Basic Commands

```bash
# Initialize a new repository
git init

# Clone an existing repository
git clone https://github.com/username/repository.git

# Add files to staging
git add filename
git add .  # Add all files

# Commit changes
git commit -m "Commit message"

# Push changes to remote
git push origin branch-name

# Pull changes from remote
git pull origin branch-name

# Check status
git status

# View commit history
git log
git log --oneline  # Compact view
```

## Branching and Merging

```bash
# List branches
git branch

# Create a new branch
git branch branch-name

# Switch to a branch
git checkout branch-name

# Create and switch to a new branch
git checkout -b branch-name

# Merge a branch into current branch
git merge branch-name

# Delete a branch
git branch -d branch-name  # Local delete
git push origin --delete branch-name  # Remote delete
```

## Stashing

```bash
# Stash changes
git stash

# List stashes
git stash list

# Apply most recent stash
git stash apply

# Apply specific stash
git stash apply stash@{n}

# Remove most recent stash
git stash drop

# Apply and remove most recent stash
git stash pop
```

## Remote Repositories

```bash
# Add a remote repository
git remote add origin https://github.com/username/repository.git

# List remote repositories
git remote -v

# Fetch changes from remote
git fetch origin

# Set upstream branch
git push -u origin branch-name

# Update forked repository with upstream changes
git fetch upstream
git merge upstream/main
```

## Undoing Changes

```bash
# Discard changes in working directory
git checkout -- filename

# Unstage a file
git reset HEAD filename

# Undo last commit, keep changes
git reset --soft HEAD~1

# Undo last commit, discard changes
git reset --hard HEAD~1

# Amend last commit
git commit --amend -m "New commit message"
```

## Git Config

```bash
# Set username and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default editor
git config --global core.editor "code --wait"

# Set line endings
git config --global core.autocrlf input  # Linux/Mac
git config --global core.autocrlf true   # Windows

# Set aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
```

## Advanced

```bash
# Interactive rebase
git rebase -i HEAD~3  # Rebase last 3 commits

# Cherry-pick a commit
git cherry-pick commit-hash

# Create a tag
git tag -a v1.0.0 -m "Version 1.0.0"

# Push tags
git push origin --tags

# Revert a commit
git revert commit-hash

# Resolve merge conflicts
git mergetool

# Clean untracked files
git clean -fd  # Remove untracked files and directories
```