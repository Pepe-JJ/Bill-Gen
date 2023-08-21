#!/bin/bash

cowsay "For each cow"

for file in output/*.cow
do
    echo Cow file: $file
    

    #check if the line its commented, if not do it
    if grep -qE '^\$t = "\$thoughts "' $file; then
        sed -i 's/^\$t = "\$thoughts "/#&/' $file
    else
        echo "Thoughts already commented"
    fi

    filename=$(basename -- "$file" .cow)
    echo File name: $filename

    # Check if the base png file already exists
    # if [ ! -f "output/${filename}.png" ]; then
    #     #This actually creates the image itself
    #     cowsay -f ./$file "deleteme.png" | sed '1,3d' | ansi2html | wkhtmltoimage --quality 50 - - | convert - -resize 720 -trim "output/${filename}.png"
    # fi

    # # Check if the ansi file already exists
    # if [ ! -f "output/${filename}.ansi" ]; then
    #     #This is so i can just o cat file without needing cowsay command
    #     cowsay -f ./$file "deleteme.png" | sed '1,3d' > "output/${filename}.ansi"
    # fi

    # Check if the svg file already exists
    # if [ ! -f "output/${filename}.svg" ]; then
    #     ansitoimg "output/${filename}.ansi" "output/${filename}".svg -w
    # fi

    # Check if the file already exists
    if [ ! -f "output/${filename}-fortune.png" ]; then
        width=$(cowsay -f ./$file "deleteme.png" | sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | wc -L)
        echo "$(fortune -s | figlet -c -w $width -f 'DOS Rebel' && cat output/${filename}.ansi)" | ansi2html | wkhtmltoimage --quality 50 - - | convert - -trim "output/${filename}-fortune.png"
    fi

done

cowsay "Choose cow"

for file in output/*.cow; do
    # Get the base filename (without extension)
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    echo file: $file
    echo filename: $filename

    if [ ! -f "../media/art/cows/$filename.cow" ] || [ ! -f "../media/art/cows/$filename-true.cow" ]; then

        # Determine if the filename indicates a true color cow
        if [[ "$filename" == *-true ]]; then
            true_color_cow=true
            filename="${filename%-true}"
        else
            true_color_cow=false
            echo continue
            continue # Skip non-true color cows
        fi

        # # Prompt the user to choose whether to move the file
        # read -p "Choose true color cow for $file? (Y/n/r) " choice

        # if [[ "$choice" =~ ^[Yy]$ ]] || [[ -z "$choice" ]]; then
        # if [ "$true_color_cow" = true ]; then
        #         mv "$file" ../media/art/cows/
        #     fi
        # else
        #     if [ "$true_color_cow" = false ]; then
        #         mv "$file" ../media/art/cows/
        #     fi
        # fi

        # Prompt the user to choose whether to move the file
        read -p "Choose true color cow for $file? (yes/no/remove) " choice

        choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')  # Convert choice to lowercase

        case $choice in
            y|yes|"")  # Accepts "y", "yes", "YES", or empty input
                if [ "$true_color_cow" = true ]; then
                    mv "$file" ../media/art/cows/
                fi
                ;;
            n|no)  # Accepts "n" or "no"
                if [ "$true_color_cow" = false ]; then
                    mv "$file" ../media/art/cows/
                fi
                ;;
            r|remove)  # Accepts "r" or "remove"
                # Use the find command to search for files matching the prefix
                # The -type f option ensures that only regular files are matched
                # The -name "$prefix*" option matches filenames starting with the prefix
                prefix=$filename
                # find . -type f -name "$prefix*"
                # find ../background-removers -type f -name "$filename*"
                # exit
                find . -type f -name "$prefix*" 2>/dev/null | while read -r filename; do
                    echo "Removing $filename"
                    rm "$filename"
                done

                find ../background-removers -type f -name "$prefix*" 2>/dev/null | while read -r filepath; do
                    echo "Removing $filepath"
                    rm "$filepath"
                done
                ;;
            *)
                echo "Invalid choice. Please choose 'yes', 'no', or 'remove'."
                ;;
        esac

    else
        echo Cow exists in ../media/art/cows
    fi

done



#Print cows with centered text, no thoughts because they are commmented in the cowfile and colored as a rainbow
#sed its used to remove ansi coloring code to get exact number of colums (width) of the output using wc -L
#the last sed just deletes the text output of the cow command so it comes as a clean image

# width=$(cowsay -f ~/Cows/axolotl.cow "deleteme.png" | sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | wc -L)
# echo "$(figlet -c -w $width -f standard "$(fortune -s)" | toilet -w $width --gay -f term && cowsay -f ~/Cows/axolotl.cow "deleteme.png" | sed '1,3d')" | ansi2html | wkhtmltoimage - - | convert - -trim temp/bill.png

# width=$(cowsay -f ~/Cows/axolotl.cow "deleteme.png" | sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | wc -L)
# figlet -c -w $width -f standard "deleteme.png" | toilet -w $width --gay -f term && cowsay -f ~/Cows/axolotl.cow "deleteme.png" | sed '1,3d'