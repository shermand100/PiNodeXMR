#!/bin/bash

#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh

lwsloc=/home/nodo/monero-lws/build/src
mla="$lwsloc/monero-lws-admin"

accept_all() {
	$mla accept_requests create "$(monero-lws-admin list_requests | jq -j '.create? | .[]? | .address?+" "')"
}

list_accounts() {
	$mla list_accounts | jq -r '.active | .[] | .address'
}
