#! /bin/bash

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

timestamp=`date +%F_%T`

git clone https://user:${GH_TOKEN}@github.com/njoy/signatures.git > /deve/null
2>&1

project=$(basename $TRAVIS_REPO_SLUG)
DIR="$PWD/signatures/$project"
mkdir -p $DIR

filename=$DIR/$timestamp

# Generate the signature file
./metaconfigure/signature.py $filename

cd $DIR
git checkout master
git add $filename.json
git commit -m "Adding signature file for $project."

git push --quiet origin master
