#!/bin/bash

cowsay "All fonts for each cow"

for file in ../media/art/cows/*.cow
do

  echo Cow file: $file

  filename=$(basename "$file")
  filename="${filename%.*}"
  echo Filename: "$filename"
  # ansipath="output/$filename.ansi"
  # echo ansi path: $ansipath
  
  mkdir -p "../media/fonts/$filename"

  width=$(cowsay -f $file "deleteme.png" | sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | wc -L)
  
  for font in /usr/share/figlet/*.flf
  do 

      fname=$(echo $font | grep -o -P '(?<=/usr/share/figlet/).*(?=)')
      echo "Font name: $fname"

      if [ ! -f "../media/fonts/$filename/$fname.png" ]; then
        ls "../media/fonts/$filename/$fname.png"
        echo doesnt exits
        #Static text
        # echo "$(figlet -c -w $width -f "$font" "deleteme.flf" && cat $ansipath)" | ansi2html | wkhtmltoimage --quality 50 - - | convert - -resize 720 -trim "../media/fonts/$cow/$fname.png"
        #Fortune
        echo "$(fortune -s | figlet -c -w $width -f "$font" && cat $ansipath)" | ansi2html | wkhtmltoimage --quality 50 - - | convert - -trim "../media/fonts/$filename/$fname.png"
        # echo "$(fortune -s | figlet -c -w $width -f "$font" && cowsay -f "$file" "deleteme.png" | sed '1,3d')" | ansi2html | wkhtmltoimage --quality 50 - - | convert - -trim "../media/fonts/$filename/$fname.png"
      fi
      

  done

done