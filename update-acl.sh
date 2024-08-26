#!/bin/bash

# which zonefile to watch
ZONE_FILE="/etc/bind/db/db.se.krei.couch.jnl"
DBDUMP_FILE="/etc/bind/named_dump.db"
LINE_STRING="611 IN A"

ACL_FILE="/etc/bind/recursionACL"

echo $LINE_STRING

# Function to extract IPs and update ACL
update_acl() {

    # dump the bind db
    rndc dumpdb -zones

    sleep 2

    # filter by LINE_STRING
    temp_lines=$(cat $DBDUMP_FILE | grep "$LINE_STRING")

    # Extract IPs from the zone file
    echo "acl guestCouch {" > "$ACL_FILE"
    echo "$temp_lines" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u | sed 's/$/;/' >> "$ACL_FILE"
    echo "};" >> "$ACL_FILE"

    # Add the ACL to the BIND config or reload the ACL
    # You might need to include the ACL in named.conf or reload the server
    rndc sync -clean
    rndc reconfig
}

# Initial update
update_acl

# Monitor the zone file for changes
while inotifywait -e modify "$ZONE_FILE"; do
    update_acl
done