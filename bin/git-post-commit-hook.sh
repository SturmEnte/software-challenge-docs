#!/bin/sh
set -e #Instantly abort on error
if [ "master" = "$(git rev-parse --abbrev-ref HEAD)" ]; then
  echo "Updating date in index.adoc"
  ./docs update-date
  echo "removing output directory ('out')"
  rm -rf ./out
  echo "getting gh-pages repository..."
  old_git_dir="$GIT_DIR"
  unset GIT_DIR
  old_git_working_dir="$GIT_WORK_TREE"
  unset GIT_WORK_TREE
  git clone git@github.com:CAU-Kiel-Tech-Inf/socha-enduser-docs.git --branch gh-pages --single-branch out
  echo "generating static pages..."
  ./docs generate pdf
  echo "putting new version in gh-pages branch"
  cd out
  git add -A
  git commit -a -u -m "automatically updated generated files on commit to master"
  echo "deploying to github"
  git push origin
  cd ..
  rm -rf ./out
  GIT_DIR="$old_git_dir"
  GIT_WORK_TREE="$old_git_working_dir"
fi