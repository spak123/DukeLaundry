
#!/bin/bash

mypath=`realpath $0`
mybase=`dirname $mypath`

dbname=laundry

if [[ -n `psql -lqt | cut -d \| -f 1 | grep -w "$dbname"` ]]; then
    dropdb $dbname
fi
createdb $dbname

cd $mybase
psql -af tables.sql $dbname
#psql -af load.sql $dbname
