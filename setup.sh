#!/usr/bin/env bash

# This script does the required work to set up your personal GitHub Pages
# repository for deployment using Hugo. Run this script only once -- when the
# setup has been done, run the `deploy.sh` script to deploy changes and update
# your website. See
# https://hjdskes.github.io/blog/deploying-hugo-on-personal-github-pages/index.html
# for more information.

# File copied from https://proquestionasker.github.io/blog/Making_Site/ tutorial
# on creating websites with blogdown, Hugo, and GitHub.

# GitHub username
USERNAME=chris-prener
# Name of the branch containing the Hugo source files.
# Name of the branch containing the Hugo source files.
SOURCE=sources

msg() {
    printf "\033[1;32m :: %s\n\033[0m" "$1"
}

msg "Adding a README.md file to \'$SOURCE\' branch"
touch README.md

msg "Deleting the \`master\` branch"
git branch -D master
git push origin --delete master

msg "Creating an empty, orphaned \`master\` branch"
git checkout --orphan master
git rm --cached $(git ls-files)

msg "Grabbing one file from the \`$SOURCE\` branch so that a commit can be made"
git checkout "$SOURCE" README.md
git commit -m "Initial commit on master branch"
git push origin master

msg "Returning to the \`$SOURCE\` branch"
git checkout -f "$SOURCE"

msg "Removing the \`_book\` folder to make room for the \`master\` subtree"
rm -rf _book
git add -u
git commit -m "Remove stale book folder"

msg "Adding the new \`master\` branch as a subtree"
git subtree add --prefix=_book \
    https://github.com/$USERNAME/autoBookdown.git master --squash
