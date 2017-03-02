#!/bin/sh

FILE_PREFIX="check_leavers-"
FILE_SUFFIX=".zip"

/bin/echo -n "Enter version (e.g. 1.0.0): "
read versionstring

FULLFILENAME="$FILE_PREFIX$versionstring$FILE_SUFFIX"

echo "Generated filename will be: $FULLFILENAME"
echo "Control+C if this is incorrect, otherwise press Enter"
read unused

zip "$FULLFILENAME" check_leavers README.txt LICENSE

