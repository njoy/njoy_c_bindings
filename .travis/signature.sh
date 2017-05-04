#! /bin/bash

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

timestamp=`date +%F_%T`

project=$(basename $TRAVIS_REPO_SLUG)
git clone https://github.com/${TRAVIS_REPO_SLUG}.git

DIR="$PWD/signatures/$project"
mkdir -p $DIR

filename=$DIR/$timestamp

# Generate the signature file
./metaconfigure/signature.py $filename

cd $DIR
echo "I'm in: $PWD"
echo "adding $filename.json to signatures"
git add $filename.json

git remote add origin-travis https://${GH_TOKEN}@github.com/$TRAVIS_REPO_SLUG.git > /dev/null 2>&1

echo "pushing to github"
git push --quiet --set-upstream origin-travis master

ls
