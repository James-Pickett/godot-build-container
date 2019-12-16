#!/bin/bash

# edits a key value pair of a .tres file or adds it as a new line if not found
#
# example:
# ./edit-tres.sh /mydir/myfile.tres key1 value1

path_to_file=$1
key="$2 = "
value=$3
combined="$key\"$value\""

kvp="$(grep -w "$key" "$path_to_file")"

if [ "${#kvp}" -eq "0" ]; then
    echo $combined >> $path_to_file 
else
    sed -i -e "s|$kvp|$combined|g" $path_to_file
fi
