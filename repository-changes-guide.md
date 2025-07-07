# Repository Changes Guide

## Current Repository Status
- **Repository**: `rahul-deolikar/PSL`
- **Current Branch**: `cursor/change-repository-settings-1c43`
- **Remote Origin**: `https://github.com/rahul-deolikar/PSL`
- **Working Tree**: Clean

## Common Repository Changes

### 1. Change Remote Repository URL

#### Change to a different repository:
```bash
git remote set-url origin https://github.com/NEW-USERNAME/NEW-REPOSITORY.git
```

#### Change to SSH instead of HTTPS:
```bash
git remote set-url origin git@github.com:rahul-deolikar/PSL.git
```

#### Add a new remote (keeping the original):
```bash
git remote add upstream https://github.com/UPSTREAM-USERNAME/REPOSITORY.git
```

### 2. Update Access Token
If your current token expires or needs updating:
```bash
git remote set-url origin https://x-access-token:NEW-TOKEN@github.com/rahul-deolikar/PSL.git
```

### 3. Repository Settings Changes

#### Rename the repository:
- Go to GitHub.com → Your repository → Settings → Repository name
- Or use GitHub CLI: `gh repo rename NEW-NAME`

#### Change repository visibility:
```bash
# Make repository private
gh repo edit --visibility private

# Make repository public
gh repo edit --visibility public
```

#### Change default branch:
```bash
# Create and switch to new default branch
git checkout -b new-main
git push -u origin new-main

# Change default branch on GitHub
gh repo edit --default-branch new-main

# Delete old main branch
git push origin --delete main
```

### 4. Transfer Repository Ownership
```bash
# Transfer to another user/organization
gh repo transfer NEW-OWNER
```

### 5. Clone Configuration Changes

#### Change clone behavior:
```bash
# Set default clone behavior
git config --global clone.defaultRemoteName origin
git config --global init.defaultBranch main
```

### 6. Local Repository Settings

#### Change user configuration for this repository:
```bash
git config user.name "New Name"
git config user.email "new-email@example.com"
```

#### Change remote tracking:
```bash
# Set upstream for current branch
git branch --set-upstream-to=origin/main

# Change tracked branch
git branch --set-upstream-to=origin/different-branch
```

### 7. Migration to New Repository

#### Complete migration with history:
```bash
# Clone the repository
git clone --bare https://github.com/rahul-deolikar/PSL.git

# Push to new repository
cd PSL.git
git push --mirror https://github.com/NEW-USERNAME/NEW-REPOSITORY.git
```

### 8. Backup Current State
Before making changes, create a backup:
```bash
# Create a backup branch
git checkout -b backup-$(date +%Y%m%d)
git push origin backup-$(date +%Y%m%d)
```

## Verification Commands

After making changes, verify with:
```bash
# Check remote configuration
git remote -v

# Check branch tracking
git branch -vv

# Test connection
git fetch --dry-run
```

## Current Commands for Your Setup

Based on your current repository, here are the most likely commands you might need:

```bash
# If changing to a new repository:
git remote set-url origin https://github.com/NEW-USERNAME/NEW-REPO.git

# If updating access token:
git remote set-url origin https://x-access-token:NEW-TOKEN@github.com/rahul-deolikar/PSL.git

# If changing to SSH:
git remote set-url origin git@github.com:rahul-deolikar/PSL.git
```

## Next Steps
1. Determine what specific change you need
2. Create a backup if the change is significant
3. Execute the appropriate command from above
4. Verify the change worked with `git remote -v`
5. Test with `git fetch` or `git push`