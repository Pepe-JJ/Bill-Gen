#!/bin/bash
mkdir -p background-removers/images
mkdir -p background-removers/output
mkdir -p background-removers/correct

cowsay "resize images"
cd image-converters/
bash resizer.sh
cd ..

cowsay "background removers"
cd background-removers/
bash create.sh
cd ..

#Move images, wait for user input, then run node cow
echo -e "\nMove the correct images from background-removers/output, to correct.\n"
read -p "Press any key to continue" key
cd image-converters/nodecow/
bash cow-converter.sh
cd ../../

cd cows-images
bash foreachcow.sh

# bash cow-fonts.sh

#delete images in background removers
cd ../
pwd
rm -f background-removers/images/*
rm -f background-removers/output/*
rm -f cows-images/output/*

