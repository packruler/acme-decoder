#! /bin/sh

file_path=${1:-acme.json}

if [ ! -f "$file_path" ]; then
    echo "Unable to access '$file_path'."
    return 1
fi

USER=$(stat -c '%u' $1)
GROUP=$(stat -c '%g' $1)

if [ ! -d certs ]; then
    mkdir certs
    chown "${USER}:${GROUP}" certs
fi
if [ ! -d priv ]; then
    mkdir priv
    chown "${USER}:${GROUP}" priv
fi

for row in $(cat $file_path | jq ".[\"lets-encrypt\"].Certificates" | jq -r ".[] | @base64"); do
    row=$(echo ${row} | base64 -d)

    domain=$(echo $row | jq -r ".domain.main")
    echo "Exporting $domain"
    
    cert=$(echo $row | jq -r ".certificate" | base64 -d)
    key=$(echo $row | jq -r ".key" | base64 -d)

    cert_file="certs/${domain}.crt"
    if [ ! -f $cert_file ]; then
        touch $cert_file
        chown "${USER}:${GROUP}" $cert_file
    fi

    key_file="priv/${domain}.key"
    if [ ! -f $cert_file ]; then
        touch $cert_file
        chown "${USER}:${GROUP}" $cert_file
    fi

    echo "$cert" > $cert_file
    echo "$key" > $key_file
    echo "Done."
done
