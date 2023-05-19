#!/bin/bash

_dir="$(dirname "$0")"

source "$_dir/config.sh"

# Strip only the top domain to get the zone id
DOMAIN=$(echo $CERTBOT_DOMAIN |rev|  cut -d"." -f1,2 | rev)

CREATE_DOMAIN=$(echo _acme-challenge.$CERTBOT_DOMAIN | sed -e "s/.${DOMAIN}//")


# Create TXT record

RECORD_ID=$(curl -s -X POST https://api360.yandex.net/directory/v1/org/${ORG_ID}/domains/${DOMAIN}/dns \
            -H "Authorization: OAuth ${API_KEY}" \
            -d "{  name: '${CREATE_DOMAIN}',  text: '${CERTBOT_VALIDATION}',  ttl: '600',  type: 'TXT'}" \
           | python -c "import sys,json;print(json.load(sys.stdin)['recordId'])")

echo $RECORD_ID
# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
fi

echo $RECORD_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID

# Sleep to make sure the change has time to propagate over to DNS
sleep 700
