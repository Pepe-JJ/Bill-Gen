#!/bin/bash

# Define the array of values
array=("u2net" "u2netp" "u2net_human_seg" "u2net_cloth_seg" "silueta" "isnet-general-use")

# Loop over each element in the array and run the commands for each file in the images folder
for file in ../images/*; do
  # echo $file
  scp $file Developmers2:~/background-removers/source/
  filename_ext=$(basename "$file")
  filename="${filename_ext%.*}"
  # echo $filename_ext
  for i in "${array[@]}"
  do
    echo "$i : $filename_ext"
    ssh Developmers2 '/home/ubuntu/.local/bin/rembg i -m "'"$i"'" ~/background-removers/source/"'"$filename_ext"'" ~/background-removers/output/"'"$filename-$i.png"'"'
    scp Developmers2:~/background-removers/output/$filename-$i.png ../output/
    # rembg i -m "$i" "$file" "../output/${filename}_$i.png"
  done
done
