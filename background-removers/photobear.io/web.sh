#!/bin/bash

flag=true

while $flag; do
  # Loop over each image file in the ../../images directory
  for input in ../images/*; do
    # Get the filename without the directory path or file extension
    filename="$(basename $input)"
    filename="${filename%.*}"
    echo Input: "$input"
    # Run each of the commands using the current input file

    if [ ! -f "../output/${filename}_photobear.png" ]; then
        
      echo Removing background using photobear

      url=$(curl -sL "https://api.cloudinary.com/v1_1/dy4s1umzd/upload" -H "sec-ch-ua: \"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundarygdqxDdYWwrLanYDK" -H "Accept: application/json, text/javascript, */*; q=0.01" -H "X-Requested-With: XMLHttpRequest" -H "sec-ch-ua-platform: \"Windows\"" -H "Sec-Fetch-Site: same-site" -H "Sec-Fetch-Mode: cors" -H "Sec-Fetch-Dest: empty" -F "folder=\"photobear/background_removal/f2zib\"" -F "upload_preset=\"photobear-upload-bg-removal\"" -F "source=\"uw\"" -F "file=@\"$input\"" | jq -r .secure_url)
      echo $url

      image=$(curl -sL "https://2nw3bl8h3m.execute-api.us-east-1.amazonaws.com/default/photo-bear-bkg-removef" -H "sec-ch-ua: \"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"" -H "sec-ch-ua-platform: \"Windows\"" -H "sec-ch-ua-mobile: ?0" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" -H "Content-Type: text/plain;charset=UTF-8" -H "Accept: */*" -H "Sec-Fetch-Site: cross-site" -H "Sec-Fetch-Mode: cors" -H "Sec-Fetch-Dest: empty" -d "{\"orig_url\":\"$url\"}")
      

      curl -sL "$image" -H "sec-ch-ua: \"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"" -H "sec-ch-ua-platform: \"Windows\"" -H "sec-ch-ua-mobile: ?0" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" -H "Content-Type: text/plain;charset=UTF-8" -H "Accept: */*" -H "Sec-Fetch-Site: cross-site" -H "Sec-Fetch-Mode: cors" -H "Sec-Fetch-Dest: empty" > "../output/${filename}_photobear.png"
      # wget -O "https://2nw3bl8h3m.execute-api.us-east-1.amazonaws.com/default/photo-bear-bkg-removef" -H "sec-ch-ua: \"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"" -H "sec-ch-ua-platform: \"Windows\"" -H "sec-ch-ua-mobile: ?0" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" -H "Content-Type: text/plain;charset=UTF-8" -H "Accept: */*" -H "Sec-Fetch-Site: cross-site" -H "Sec-Fetch-Mode: cors" -H "Sec-Fetch-Dest: empty" -d "{\"orig_url\":\"$url\"}"

      if identify "../output/${filename}_photobear.png" >/dev/null 2>&1; then
          echo "Image file loaded successfully."
          flag=false
      else
          echo "Image file could not be loaded."
      fi

    else 
      echo file exists
    fi 

    flag=false 

  done
done
