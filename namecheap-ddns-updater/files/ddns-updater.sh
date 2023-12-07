#!/bin/bash


###########################################
## Check if we have a public IP
###########################################
ipv4_regex='([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])'
ip=$(curl -s -4 https://cloudflare.com/cdn-cgi/trace | grep -E '^ip'); ret=$?
if [[ ! $ret == 0 ]]; then # In the case that cloudflare failed to return an ip.
    # Attempt to get the ip from other websites.
    ip=$(curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com)
else
    # Extract just the ip from the ip line from cloudflare.
    ip=$(echo $ip | sed -E "s/^ip=($ipv4_regex)$/\1/")
fi
echo "At $(date), the IP address is $ip."

# Use regex to check for proper IPv4 format.
if [[ ! $ip =~ ^$ipv4_regex$ ]]; then
    logger -s "DDNS Updater: Failed to find a valid IP."
    exit 2
fi

# ###########################################
# ## Seek for the A record
# ###########################################
old_ip=$(nslookup dev.file.hosting.jumpai.tech dns1.namecheaphosting.com | awk '/^Address: / { print $2 }')

# ###########################################
# ## Check if the domain has an correct A record
# ###########################################
if [[ $old_ip == $ip ]]; then
  echo ip is correct
  exit 1
fi



# ###########################################
# ## Change the IP@Namecheap using the API
# ###########################################
# update=$(curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" \
#                      -H "X-Auth-Email: $auth_email" \
#                      -H "$auth_header $auth_key" \
#                      -H "Content-Type: application/json" \
#                      --data "{\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\",\"ttl\":\"$ttl\",\"proxied\":${proxy}}")

