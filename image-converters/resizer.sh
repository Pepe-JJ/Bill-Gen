for file in ../image-source-examples/*
do
    echo $file
    filename_ext=$(basename "$file")
    # echo $filename_ext
    filename="${filename_ext%.*}"
    # echo $filename
    
    # Remove special characters and replace spaces with underscores
    new_filename=$(echo "$filename" | tr -cd '[:alnum:]_' | tr ' ' '_')

    if [ ! -f "../background-removers/images/${new_filename}-300.png" ]; then
        echo Resizing image

        convert "$file" -resize 300 "../background-removers/images/${new_filename}-300.png"
    else 
        echo File exists
    fi

done

