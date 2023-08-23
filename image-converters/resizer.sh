for file in ../image-source-examples/*
do
    echo $file
    filename_ext=$(basename "$file")
    # echo $filename_ext
    filename="${filename_ext%.*}"
    # echo $filename
    
    if [ ! -f "../background-removers/images/${filename}-300.png" ]; then
        
        echo Reszing image

        if [[ -f "$file" && "$file" == *" "* ]]; then
        echo "Renaming $file"
            new_name="${file// /_}"
            mv "$file" "$new_name"
            file="$new_name"
        fi
        
        convert "$file" -resize 300 "../background-removers/images/${filename}-300.png"

    else 
        echo file exists
    fi

done