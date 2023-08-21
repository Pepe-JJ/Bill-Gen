#!/bin/bash
mkdir -p output

# Loop over each image file in the ../../images directory
for file in ../images/*; do
  echo "$file"
  # Get the filename without the directory path or file extension
  filename_ext=$(basename "$file")
  filename="${filename_ext%.*}"
  # echo "$filename_ext"

  if [ ! -f "../output/${filename}_rgba.png" ]; then
        
    echo Removing background using transparent-background

    scp $file Developmers2:~/background-removers/source/
    # Run each of the commands using the current file

    #Outputs as filename_rgba.png
    # ssh Developmers2 '/home/ubuntu/.local/bin/transparent-background --source ~/background-removers/source/"'"$filename_ext"'" --jit --dest ~/background-removers/output'
    ssh Developmers2 '/home/ubuntu/.local/bin/transparent-background --source ~/background-removers/source/"'"$filename_ext"'" --dest ~/background-removers/output'
    scp Developmers2:"~/background-removers/output/${filename}_rgba.png" ../output/
    # ssh Developmers2 'rm "~/background-removers/source/$filename*" && rm "~/background-removers/output/$filename"'
    ssh Developmers2 'rm ~/background-removers/source/$filename*'
    ssh Developmers2 'ls ~/background-removers/source/'
    ssh Developmers2 'rm ~/background-removers/output/$filename*'
    ssh Developmers2 'ls ~/background-removers/output/'
    # transparent-background --source $file --jit --dest ../output

  else 
    echo file exists
  fi
  
done