# update-bind-acls

This script updates a bind9-compatible ACL from bind9-zones.

Define a line-catch to get all clients you want in the ACL. I use a unique TTL to filter dyndns-clients.

The ACL generated can be included in named.conf to allow query, recursion, etc.

Enjoy!