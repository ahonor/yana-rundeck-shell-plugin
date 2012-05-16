#!/bin/bash

# Reference: http://rundeck.org/docs/manpages/man5/resource-v13.html

die() { echo "ERROR: $@" ; exit 1 ; }

#
# Lookup the plugin config settings exported as env vars
#

# URL to remote server
[ -z "$RD_CONFIG_URL" ] && RD_CONFIG_URL=http://localhost:8080
# Type name to filter 
[ -z "${RD_CONFIG_NODETYPE}" ] && RD_CONFIG_NODETYPE=Node
# Yana username
[ -z "${RD_CONFIG_USERNAME}" ] && RD_CONFIG_USERNAME=admin
# Yana password
[ -z "${RD_CONFIG_PASSWORD}" ] && RD_CONFIG_PASSWORD=admin

# Temporary working files
cookie=/tmp/yana-rundeck-shell-plugin.tmp.cookie
response=/tmp/yana-rundeck-shell-plugin.tmp.response


#
# Login and create a session
#
curl --fail --silent \
    --data "j_username=${RD_CONFIG_PASSWORD}&j_password=${RD_CONFIG_PASSWORD}" \
    ${RD_CONFIG_URL}/springSecurityApp/j_spring_security_check \
    --cookie-jar ${cookie} || die "login failed for \${RD_CONFIG_USER}: ${RD_CONFIG_USER}"
#
# Retrieve the data from Yana
#
curl --fail --silent ${RD_CONFIG_URL}/node/list?format=xml \
    --cookie ${cookie} -o ${response} || die "failed obtaining Yana listing: ${RD_CONFIG_URL}"

#
# Validate the response is well formed XML
#
xmlstarlet val --well-formed --quiet ${response} 2>/dev/null || die "Yana response failed XML validation"

#
# Transform into RundeckXml format
#
xmlstarlet tr $(dirname $0)/rundeck.xsl \
    -s username=${RD_CONFIG_USERNAME} \
    -s url=${RD_CONFIG_URL} \
    -s nodeType=${RD_CONFIG_NODETYPE} ${response} | xmlstarlet fo || die "XML transformation failed"


#
# Done.
#