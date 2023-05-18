#!/bin/bash

_dir="$(dirname "$0")"

source "$_dir/config.sh"

if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID ]; then
        RECORD_ID=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID)
        rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID
fi

DOMAIN=$(echo $CERTBOT_DOMAIN |rev|  cut -d"." -f1,2 | rev)

# Remove the challenge TXT record from the zone
if [ -n "${RECORD_ID}" ]; then
	
	RESULT=$(curl -s -X DELETE https://api360.yandex.net/directory/v1/org/${ORG_ID}/domains/${DOMAIN}/dns/$RECORD_ID \
            -H "Authorization: OAuth ${API_KEY}" \
	 | sed -e "s/{}/success/")

	echo $RESULT 
fi