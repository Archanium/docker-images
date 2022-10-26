#!/usr/bin/env bash
EXTRA_KEYS=$(echo -e "${EXTRA_KEYS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
readarray -d',' -t EXTRA_KEYS_ARR <<< $EXTRA_KEYS
#declare -a EXTRA_KEYS=(
#  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeMLzGu01IcLMx7nUW50UPAuK/3ErjToKhwmzU1ij8lbIncTXwPCQkXCb6KioT9PdcrRmePx/NuK3TPRvg6U60Ql4QnrOKHuYu41QIZ/vG6YpbgXcA9lwaphzT5rkWCuBIyVP19h+37W8XIJWtpCPNPx0tWALRJYNJwPq2s7eXVF8GlDfN7lRc5KPCvS2OHvhEccqELSjSSHmKZHwWm/gJoYw2mlvs1aaSAoJQISnqmrht3lxuB3DUR3qWr1dTcMPPDx+raHc6Ain79zJeeaUWm3cTdMKe/B0GiDt9ITOjEEPJeN6v37qZLcf/uI2cx8hDYiKipE+W3b/UMEsUemgZ"
#  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUtQikF+RZJBRoWt7Sv7xEOZAwneTQ28uD2YEjAU3vk8InJHHm7HClamP2iuZu/35sFkHLK4RpWcFP+ErTwFdGynyE6ljYhATLTQarSgs/OHIdzE8hmQWpjxcICQFadHJ5gekWOLYVLYA+PhW6ZTf+eFWs3mBtmlGj5L65CLsAY9UiobXiLVLvqpHIB5W9AaZCsh3UWj1cNkAR43qb7vAXVYq5Xvj09Xqh63Oak9eBskA4sVxnqTL4LjcmE4TLoBxdjSq4EXI20VTbYD731VgUUe0dryNoQXYsE6haMmGgUX0de05aNN9uOUUmGdT3B54zOgP4i9jRajzS+mjyn/WD"
#)
GITHUB_MEMBERS=$(echo -e "${GITHUB_MEMBERS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
readarray -d ',' -t GITHUB_MEMBERS_ARR <<< $GITHUB_MEMBERS
#declare -a GITHUB_MEMBERS=(archanium cosminlupu butfirstcoffee samspinoy akarlberg)
touch temp_keys && truncate -s 0 temp_keys
echo "# Extra keys " >> temp_keys
echo "#Extra keys: ${#EXTRA_KEYS_ARR[@]}"
for extraKey in "${EXTRA_KEYS_ARR[@]}"
do
  :
  extraKey=$( echo "${extraKey}" | xargs echo -n )
  #echo "EXTRA_KEY: ${extraKey}x"
  if [ "${extraKey}x" != "x" ]; then 
    echo "${extraKey}" >> temp_keys
  fi 
done
echo "#GithubMembers: ${#GITHUB_MEMBERS_ARR[@]}"
for githubMember in "${GITHUB_MEMBERS_ARR[@]}"
do
  :
  githubMember=$( echo "${githubMember}" | tr -d '[:space:]')
  #echo "GITHUB_MEMBER: ${githubMember}x"
  if [ "${githubMember}x" != "x" ]; then 
    echo "# Keys from https://github.com/${githubMember}.keys" >> temp_keys
    curl --no-progress-meter "https://github.com/${githubMember}.keys" >> temp_keys
  fi 
   
done
if [ "${OUTPUT_FILE}x" = "x" ]; then
  cat temp_keys;
else
  mv -f temp_keys $OUTPUT_FILE && chmod 0600 $OUTPUT_FILE
  cat $OUTPUT_FILE
  if [ "${OWNER}x" != "x" ]; then
    chown "${OWNER}:${OWNER}" $OUTPUT_FILE
  fi
fi
