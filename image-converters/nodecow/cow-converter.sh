#!/bin/bash

cowsay "cow converter"
# Loop over each image file in the ../../images directory
for file in ../../background-removers/correct/*; do

  echo "$file"
  # Get the filename without the directory path or file extension
  filename_ext=$(basename "$file")
  filename="${filename_ext%.*}"
  # echo "$filename_ext"

    # Check if the file already exists
    if [ -f "../../media/art/cows/$filename.cow" ] || [ -f "../../media/art/cows/$filename-true.cow" ]; then
      echo "Cow already exists in media/art/cows"
    else
      if [ ! -f "../../cows-images/output/$filename.cow" ] || [ ! -f "../../cows-images/output/$filename-true.cow" ]; then
        scp "$file" Developmers2:~/image-converters/nodecow/
        echo "File sent"

        # Run each of the commands using the current file

        #Outputs as filename.cow
        ssh Developmers2 'cd ~/image-converters/nodecow/ && /home/ubuntu/.nvm/versions/node/v18.15.0/bin/node app.js "'"$filename_ext"'"'
        ssh Developmers2 'cd ~/image-converters/nodecow/ && /home/ubuntu/.nvm/versions/node/v18.15.0/bin/node app-truecolors.js "'"$filename_ext"'"'
        scp Developmers2:"~/image-converters/nodecow/${filename}*.cow" ../../cows-images/output/

        ssh Developmers2 "rm ~/image-converters/nodecow/$filename*"
      else
        echo "Cow already exists in output folder"
      fi
    fi

done