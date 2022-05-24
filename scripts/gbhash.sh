#!/bin/bash

# name: gbhash


# Calculates the hash of all the files within a directory and calculates the hash of those hashes

if [ $# -ne 1 ]; then
   echo ""
   echo "Execute:"
   echo "$0 <folder>"
   echo ""
   exit 1
fi

HEADER="Gbml"

HASHES=`/usr/bin/sha256sum $1/* | awk '{print $1}'`
RESULTING_HASH=`echo -n $HASHES | /usr/bin/sha256sum | awk '{print $1}' | cut -b 12-47`

echo ""
echo $HEADER$RESULTING_HASH
echo ""