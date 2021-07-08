#!/bin/bash

# set -o pipefail
# set -o xtrace

err(){
  echo "Error: $*" >>/dev/stderr
}

uri=api.${region}.logging.cloud.ibm.com

cat > "${config_directory}/post_payload.json" <<- EOF
{
  "name": "${group_name}",
  "accessScopes": ["${group_access_scope}"]
}
EOF
[ $? -ne 0 ] && err "cat post_payload.json" && exit 1

post_result=$(curl -s -X POST -H "Content-Type: application/json" -H "servicekey: ${service_key}" -d @${config_directory}/post_payload.json "https://${uri}/v1/config/groups")
[ $? -ne 0 ] && err "post_result" && exit 1

echo ${post_result} >${config_directory}/post_result.json
groupId=$(jq -r '.groupId | select (.!=null)' ${config_directory}/post_result.json | tr -d '\r')
if [ ! -z ${groupId} ]; then
  jq -n --arg groupId "${groupId}" '{"groupId":$groupId}'
else
  jq -n --arg post_result "${post_result}" '{"error": "error reading group id", "message": $post_result}'
  exit 1
fi 

sleep 5
exit 0 