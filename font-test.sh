#!/bin/bash

# while read p; do
#   echo "$p"
#   # test=$(fortune -s | toilet -f Fender.flf && cat bill-no-bg.txt)
#   test=$(echo "deleteme.png" | toilet -f Fender.flf && cat bill-no-bg.txt)
#   echo "$test" | convert -background black -fill white -font $p -trim label:@- temp/fonts/$p.png
# done <fonts


rm figletfonts

for font in /usr/share/figlet/*.flf
do 

    echo "Font path: $font"
    echo "Font path: $font" >> figletfonts

    fname=$(echo $font | grep -o -P '(?<=/usr/share/figlet/).*(?=)')
    echo "$fname"

    echo "Fonts name: $fname" >> figletfonts
    # echo "$(figlet -c -w $width -f "$font" "deleteme.flf" | toilet -w $width -f term)" >> figletfonts
    echo "$(figlet -c -w $width -f "$font" "deleteme.flf")" >> figletfonts
    
    echo -e "\n\n\n\n\n\n" >> figletfonts

done
