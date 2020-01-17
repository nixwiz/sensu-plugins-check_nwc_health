#!/bin/bash

files=( dist/*.tar.gz )
file=$(basename "${files[0]}")

version=${TRAVIS_TAG:-local-build}
project=$(echo $file | sed -e "s/_${version}.*$//")
echo "Checksumming: $project, version $version"

sha512_file="${project}_${version}_sha512-checksums.txt"
echo "SHA512 file is $sha512_file"

cd dist

echo "${sha512_file}" > sha512_file

sha512sum ./*.tar.gz > "${sha512_file}"
