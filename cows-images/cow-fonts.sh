#!/bin/bash

# while read p; do
#   echo "$p"
#   # test=$(fortune -s | toilet -f Fender.flf && cat bill-no-bg.txt)
#   test=$(echo "deleteme.png" | toilet -f Fender.flf && cat bill-no-bg.txt)
#   echo "$test" | convert -background black -fill white -font $p -trim label:@- temp/fonts/$p.png
# done <fonts

cowsay "All fonts for each cow"

for file in ../media/art/cows/*.cow
do

  echo Cow file: $file

  filename=$(basename "$file")
  filename="${filename%.*}"
  echo Filename: "$filename"
  ansipath="output/$filename.ansi"
  echo ansi path: $ansipath
  
  mkdir "../media/fonts/$filename"

  width=$(cowsay -f $file "deleteme.png" | sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | wc -L)
  for font in /usr/share/figlet/*.flf
  do 

      fname=$(echo $font | grep -o -P '(?<=/usr/share/figlet/).*(?=)')
      echo "$fname"

      if [ ! -f "../media/fonts/$filename/$fname.png" ]; then
        ls "../media/fonts/$filename/$fname.png"
        echo doesnt exits
        #Static text
        # echo "$(figlet -c -w $width -f "$font" "deleteme.flf" && cat $ansipath)" | ansi2html | wkhtmltoimage --quality 50 - - | convert - -resize 720 -trim "../media/fonts/$cow/$fname.png"
        #Fortune
        echo "$(fortune -s | figlet -c -w $width -f "$font" && cat $ansipath)" | ansi2html | wkhtmltoimage --quality 50 - - | convert - -trim "../media/fonts/$filename/$fname.png"
      fi
      

  done

done