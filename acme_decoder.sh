#! /bin/sh

file_path=$1

mkdir -p certs private
for row in $(cat $file_path | jq ".[\"lets-encrypt\"].Certificates" | jq -r ".[] | @base64"); do
    row=$(echo ${row} | base64 -d)

    domain=$(echo $row | jq -r ".domain.main")
    echo "Exporting $domain"
    
    cert=$(echo $row | jq -r ".certificate" | base64 -d)
    key=$(echo $row | jq -r ".key" | base64 -d)

    echo "$cert" > "certs/${domain}.crt"
    echo "$key" > "private/${domain}.key"
    echo "Done."
done
