#!/bin/bash
#
# Interfaces Yana and returns Node data formatted in XML format:
# * Reference: http://rundeck.org/docs/manpages/man5/resource-v13.html

# Fail if a command errors or an unset variable is referenced.
set -eu

# Dependencies verification:
#
# * xmlstarlet
(which xmlstarlet >/dev/null) 


#
# Default unset plugin config settings.
#

# URL to remote server
: ${RD_CONFIG_URL=http://localhost:8080/yana2}
# Yana username
: ${RD_CONFIG_USERNAME=admin}
# Yana password
: ${RD_CONFIG_PASSWORD=admin}




# Temporary working files
cookie=/tmp/yana-rundeck-shell-plugin.tmp.cookie
response=/tmp/yana-rundeck-shell-plugin.tmp.response

# Set up curl to fail on error and run silently.
CURLOPTS="-k -f -s -S -L -c cookies -b cookies"
CURL="curl $CURLOPTS"


#
# Login and create a session
#
$CURL --data "j_username=${RD_CONFIG_PASSWORD}&j_password=${RD_CONFIG_PASSWORD}" \
    ${RD_CONFIG_URL}/j_spring_security_check >/dev/null
#
# Retrieve the data from Yana
#

# List any nodes
#$CURL ${RD_CONFIG_URL}/api/node/list/xml?project=$RD_PROJECT > $response

# Search nodes for any matching nodetype.
query="nodetype:$RD_CONFIG_NODETYPE"; # The colon char will be encoded as %3A in the url.
$CURL -X GET "${RD_CONFIG_URL}/search/index?format=xml&project=${RD_CONFIG_PROJECT}&q=${query/:/%3A}" > $response

#
# Validate the response is well formed XML
#
xmlstarlet val --well-formed --quiet ${response} 2>/dev/null 

#
# Transform into RundeckXml format
#
xmlstarlet tr $(dirname $0)/rundeck.xsl \
    -s username=${RD_CONFIG_USERNAME} \
    -s url=${RD_CONFIG_URL} \
    -s nodeType=${RD_CONFIG_NODETYPE} ${response} | 
xmlstarlet fo 


#
# Done.
#
exit $?
