#! /bin/bash

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
