#!/bin/bash

#Images to ascii-art

# identify -format '%wx%h' temp/TransparentBills/*.png 

for file in ../media/TransparentBills/*; do

    filename=$(basename -- "$file")
    filename="${filename%.*}"
    echo file: $file
    echo filename: $filename
    # exit

    if [ -f "../media/art/AsciiBills/$filename-ascii-art.txt" ]; then
    echo "File  ../media/art/AsciiBills/$filename-ascii-art.txt exists"
    continue
    fi

    #Traer alto y ancho en pixeles
    identify -format '%wx%h' $file
    echo -e "\n"
    #Ancho
    X=$(identify -format '%wx%h' $file | sed 's/x.*//')
    #Alto
    Y=$(identify -format '%wx%h' $file | sed -n -e 's/^.*x//p')

    echo "X: $X"
    echo "Y: $Y"

    if [[ $X < $Y ]]
        then
        #Si la imagen es mas ancha entonces escalala en la altura
            echo "Width"
            ascii-image-converter $file -W 120 --save-txt ../media/art/AsciiBills/ --only-save
        else
        #Si la imagen es mas alta, escalala en la anchura
            echo "Height"
            ascii-image-converter $file -H 80 --save-txt ../media/art/AsciiBills/ --only-save
    fi

done


#Ascii art to generated image

# while read p; do
#     name=$(basename $p)
    
#     #nlines=$(cat Script | wc -l)
#     nparagrahps=$(grep -E '^$' Script | wc -l)

#     #n=$(($RANDOM % $nlines + 1)) && i=$(($RANDOM % 10 + 1)) && j=$((n+i))
#     n=$(($RANDOM % $nparagrahps + 1))
    

#     #echo "Quote line n: $n"
#     #echo "Number of lines i: $i"
#     echo "Paragraph n: $n"
#     echo -e "\n"
#     #echo "$bill"

#     #Get N paragraph
#     bill=$(cat Script | awk -v RS= -v p="$n" 'NR == p' | toilet -w 300 -f 'DOS Rebel' && cat $p)

#     echo "$bill" | convert -background black -fill white -font DejaVu-Sans-Mono-Bold -trim label:@- temp/trash/$name.png

# done