#!/bin/bash
mkdir -p background-removers/images
mkdir -p background-removers/output
mkdir -p background-removers/correct

cowsay "resize images"
for file in image-source-examples/*
do
    echo $file
    filename_ext=$(basename "$file")
    # echo $filename_ext
    filename="${filename_ext%.*}"
    # echo $filename
    
    if [ ! -f "background-removers/images/${filename}-300.png" ]; then
        
        echo Reszing image

        if [[ -f "$file" && "$file" == *" "* ]]; then
        echo "Renaming $file"
            new_name="${file// /_}"
            mv "$file" "$new_name"
            file="$new_name"
        fi
        
        convert "$file" -resize 300 "background-removers/images/${filename}-300.png"

    else 
        echo file exists
    fi

done
# exit

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
rm background-removers/images/*
rm background-removers/output/*
rm cows-images/output/*

