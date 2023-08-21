#!/bin/bash
mkdir -p output

# Loop over each image file in the ../../images directory
for input in ../images/*; do

  # Get the filename without the directory path or file extension
  filename=$(basename "$input")
  filename="${filename%.*}"

  if [ ! -f "../output/${filename}_removal.png" ]; then
        
    echo Removing background using removal.ai
    
    action="rm_upload"
    image=""
    flag=true
    
    # Run each of the commands using the current input file
    b64=$(cat "$input" | base64)
    
    while $flag; do
      while [ -z "$image" ]; do

        echo "$input"
      
        s_field=$(curl -sL "https://removal.ai/" -H "authority: removal.ai" -H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7" -H "accept-language: es-419,es;q=0.9" -H "cache-control: no-cache" -H "pragma: no-cache" -H "referer: https://removal.ai/upload/" -H "sec-ch-ua: \"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"" -H "sec-ch-ua-mobile: ?0" -H "sec-ch-ua-platform: \"Windows\"" -H "sec-fetch-dest: document" -H "sec-fetch-mode: navigate" -H "sec-fetch-site: same-origin" -H "sec-fetch-user: ?1" -H "upgrade-insecure-requests: 1" -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" | grep -oP 'var removal_data = {\K[^}]+(?=})' | grep -oP 'ajax_s_field":"\K[^"]+')
        
        # echo $s_field

        #url encode the values
        encoded_action=$(printf "%s" "$action" | jq -s -R -r @uri)
        encoded_s_field=$(printf "%s" "$s_field" | jq -s -R -r @uri)
        encoded_file=$(printf "%s" "$b64" | jq -s -R -r @uri)

        #data="action=${encoded_action}&s_field=${encoded_s_field}&file=${encoded_file}"
        data="file=${encoded_file}"

        # echo "$data"
        

        #image=$(curl -sL "https://removal.ai/wp-admin/admin-ajax.php" -H "authority: removal.ai" -H "accept: */*" -H "accept-language: es-419,es;q=0.9" -H "cache-control: no-cache" -H "content-type: application/x-www-form-urlencoded; charset=UTF-8" -H "origin: https://removal.ai" -H "pragma: no-cache" -H "referer: https://removal.ai/upload/" -H "sec-ch-ua: \"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"" -H "sec-ch-ua-mobile: ?0" -H "sec-ch-ua-platform: \"Windows\"" -H "sec-fetch-dest: empty" -H "sec-fetch-mode: cors" -H "sec-fetch-site: same-origin" -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" -H "x-kl-ajax-request: Ajax_Request" -H "x-requested-with: XMLHttpRequest" -d "action=rm_upload" -d "s_field=${s_field}" --data-urlencode "file=${b64}" | jq .url)
        #image=$(curl -sL "https://removal.ai/wp-admin/admin-ajax.php" -H "authority: removal.ai" -H "accept: */*" -H "accept-language: es-419,es;q=0.9" -H "cache-control: no-cache" -H "content-type: application/x-www-form-urlencoded; charset=UTF-8" -H "origin: https://removal.ai" -H "pragma: no-cache" -H "referer: https://removal.ai/upload/" -H "sec-ch-ua: \"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"" -H "sec-ch-ua-mobile: ?0" -H "sec-ch-ua-platform: \"Windows\"" -H "sec-fetch-dest: empty" -H "sec-fetch-mode: cors" -H "sec-fetch-site: same-origin" -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" -H "x-kl-ajax-request: Ajax_Request" -H "x-requested-with: XMLHttpRequest" -d "action=rm_upload" -d "s_field=${s_field}" --data-urlencode 'file="'"$(base64 $input)"'"' | jq .url)
        #image=$(echo "file=$b64" | curl -sL "https://removal.ai/wp-admin/admin-ajax.php" -H "authority: removal.ai" -H "accept: */*" -H "accept-language: es-419,es;q=0.9" -H "cache-control: no-cache" -H "content-type: application/x-www-form-urlencoded; charset=UTF-8" -H "origin: https://removal.ai" -H "pragma: no-cache" -H "referer: https://removal.ai/upload/" -H "sec-ch-ua: \"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"" -H "sec-ch-ua-mobile: ?0" -H "sec-ch-ua-platform: \"Windows\"" -H "sec-fetch-dest: empty" -H "sec-fetch-mode: cors" -H "sec-fetch-site: same-origin" -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" -H "x-kl-ajax-request: Ajax_Request" -H "x-requested-with: XMLHttpRequest" -d "action=rm_upload" -d "s_field=${s_field}" --data-urlencode @- | jq .url)
        # image=$(echo "$data" | curl -sL "https://removal.ai/wp-admin/admin-ajax.php" -H "authority: removal.ai" -H "accept: */*" -H "accept-language: es-419,es;q=0.9" -H "cache-control: no-cache" -H "content-type: application/x-www-form-urlencoded; charset=UTF-8" -H "origin: https://removal.ai" -H "pragma: no-cache" -H "referer: https://removal.ai/upload/" -H "sec-ch-ua: \"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"" -H "sec-ch-ua-mobile: ?0" -H "sec-ch-ua-platform: \"Windows\"" -H "sec-fetch-dest: empty" -H "sec-fetch-mode: cors" -H "sec-fetch-site: same-origin" -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" -H "x-kl-ajax-request: Ajax_Request" -H "x-requested-with: XMLHttpRequest" -d "action=rm_upload" -d "s_field=${s_field}" -d @- | jq -r .url)
        image=$(echo "$data" | curl -sL "https://removal.ai/wp-admin/admin-ajax.php" -H "content-type: application/x-www-form-urlencoded; charset=UTF-8" -d "action=rm_upload" -d "s_field=${s_field}" -d @- | jq -r .url)

        echo "$image"
      
        sleep 5
      
      done
      

      # image=$(echo "$image" | sed 's/\\//g')
      # file=$(echo "${image##*/}" | sed 's/\"//g')
      # echo "${file}"
  
      curl -sL "$image" -H "authority: removal.ai" -H "accept: */*" -H "accept-language: es-419,es;q=0.9" -H "cache-control: no-cache" -H "content-type: application/x-www-form-urlencoded; charset=UTF-8" -H "origin: https://removal.ai" -H "pragma: no-cache" -H "referer: https://removal.ai/upload/" -H "sec-ch-ua: \"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"" -H "sec-ch-ua-mobile: ?0" -H "sec-ch-ua-platform: \"Windows\"" -H "sec-fetch-dest: empty" -H "sec-fetch-mode: cors" -H "sec-fetch-site: same-origin" -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" -H "x-kl-ajax-request: Ajax_Request" -H "x-requested-with: XMLHttpRequest" > "../output/${filename}_removal.png"

      if identify "../output/${filename}_removal.png" >/dev/null 2>&1; then
        echo "Image file loaded successfully."
        flag=false
      else
        echo "Image file could not be loaded."
      fi

    done

  else 
    echo file exists
  
  fi  
  
done

