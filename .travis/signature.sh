#! /bin/bash

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

hash=`git rev-parse HEAD`
timestamp=`date +%F_%T`

git clone git@github.com:njoy/signatures.git

DIR="$PWD/signatures/$project"
mkdir -p $DIR

filename=$DIR/$timestamp
echo $filename

# Generate the signature file
./metaconfigure/signature.py $filename

git add $filename.json

cd $DIR
git remote add origin-travis https://${GH_TOKEN}@github.com/njoy/$project.git > /dev/null 2>&1

git push --quiet --set-upstream origin-travis master
