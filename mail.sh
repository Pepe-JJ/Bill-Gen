#!/bin/bash

mail () {
  # Generate random string of 10 lowercase letters
  string=$(openssl rand -base64 32 | tr -dc 'a-z' | fold -w 10 | head -n 1)
#   echo $string

  # Get domain from Mail.tm API
  domain=$(curl -sX 'GET' 'https://api.mail.tm/domains?page=1' -H 'accept: application/ld+json' | jq -r '.["hydra:member"][0]["domain"]')>>/dev/null
#   echo $domain
  email="$string@$domain"
#   echo $email
#   exit
  
  # Create account and get id and token from Mail.tm API
  response=$(curl -sX 'POST' 'https://api.mail.tm/accounts' -H 'accept: application/ld+json' -H 'Content-Type: application/ld+json' -d "{\"address\": \"$string@$domain\", \"password\": \"$string\"}")
#   echo $response
  id=$(echo "$response" | jq -r '.id')
#   echo $id
  token=$(curl -sX 'POST' 'https://api.mail.tm/token' -H 'accept: application/json' -H 'Content-Type: application/json' -d "{\"address\": \"$string@$domain\", \"password\": \"$string\"}" | jq -r '.token')
#   echo $token

  # Send request to removal.ai with email address
  curl -s 'https://removal.ai/wp-admin/admin-ajax.php' -H 'authority: removal.ai' -H 'accept: */*' -H 'accept-language: es-419,es;q=0.9,en;q=0.8' -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'referer: https://removal.ai/login/' -H 'sec-ch-ua: "Google Chrome";v="111", "Not(A:Brand";v="8", "Chromium";v="111"' -H 'sec-ch-ua-mobile: ?0' -H 'sec-ch-ua-platform: "Windows"' -H 'sec-fetch-dest: empty' -H 'sec-fetch-mode: cors' -H 'sec-fetch-site: same-origin' -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36' -H 'x-kl-kfa-ajax-request: Ajax_Request' -H 'x-requested-with: XMLHttpRequest' --data-raw "action=rm_sign_up&u_email=$string@$domain&u_first_name=Foo&u_last_name=Bar&u_pass=$string&s_field=68d72ffd56" --compressed

  # Get message id from Mail.tm API
  message=$(curl -sX 'GET' 'https://api.mail.tm/messages?page=1' -H 'accept: application/ld+json' -H "Authorization: Bearer $token" | jq -r '.["hydra:member"][0].id')
  echo a
#   echo $message

#   echo "Created email account with id: $id and message id: $message"

  response=$(curl -sX 'GET' \
  "https://api.mail.tm/messages/$message" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token")
#   echo $response

href=$(echo $response | jq -r '.text' | grep -oP '\[https:\/\/removal\.ai\/\?action=rm_active&key=[^]]+\]' | sed 's/^\[\(.*\)\]$/\1/')
# echo "href: $href"

curl -sL "$href" >> /dev/null


curl -s --cookie-jar "cookies" 'https://removal.ai/wp-admin/admin-ajax.php' \
  -H 'authority: removal.ai' \
  -H 'accept: */*' \
  -H 'accept-language: es-419,es;q=0.9,en;q=0.8' \
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'origin: https://removal.ai' \
  -H 'referer: https://removal.ai/login/' \
  -H 'sec-ch-ua: "Google Chrome";v="111", "Not(A:Brand";v="8", "Chromium";v="111"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36' \
  -H 'x-kl-kfa-ajax-request: Ajax_Request' \
  -H 'x-requested-with: XMLHttpRequest' \
  --data-raw "action=rm_login&u_email=$string%40$domain&u_pass=$string&remember_me=0&return_url=&s_field=68d72ffd56" \
  --compressed >> /dev/null

api_token=$(curl -s --cookie "cookies" 'https://removal.ai/my-account/' \
  -H 'authority: removal.ai' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: es-419,es;q=0.9,en;q=0.8' \
  -H 'referer: https://removal.ai/login/' \
  -H 'sec-ch-ua: "Google Chrome";v="111", "Not(A:Brand";v="8", "Chromium";v="111"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36' \
  --compressed | grep -oP '(?<=id="api_token">)[^<]+')

#Delete account
curl -sX 'DELETE' \
  "https://api.mail.tm/accounts/$id" \
  -H 'accept: */*' \
  -H "Authorization: Bearer $token"

echo "$api_token"
}
echo $(mail)
# curl -L "https://api.removal.ai/3.0/remove" -H "Rm-Token: $api_token" -F "image_file=@\"/E:/Imagenes/confusion.png\""