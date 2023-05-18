#!/bin/bash

#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh

PWD=/home/nodo/monero-lws-admin
NUXT_LWS_API_KEY=$(getvar 'lws_admin_key')
NUXT_LWS_ADMIN_URL=$(getvar 'lws_admin_url')

export NUXT_LWS_API_KEY
export NUXT_LWS_ADMIN_URL

# from the readme;
# NUXT_LWS_API_KEY=yourapikey NUXT_LWS_ADMIN_URL=http://your-ip:1234 npm run dev

eval "cd $PWD && npm run dev"
