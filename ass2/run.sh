#!/bin/sh
source /srvr/$(whoami)/env

dropdb a2
createdb a2
psql a2 -f a2.db
psql -d a2 -f updates.sql
./acting "james franco" >output.txt
./acting "james franco"| wc -l >>output.txt
./acting "john smith"| wc -l >>output.txt

./title "star war" >>output.txt
./title "happy" >>output.txt
./title "mars" >>output.txt

./toprank "Action&Sci-Fi&Adventure" 10 2005 2005 >>output.txt
./toprank "Sci-Fi&Adventure&Action" 20 1920 2019 >>output.txt
./toprank 20 1920 2019 >>output.txt

./similar "Happy Feet" 30 >>output.txt
./similar "The Shawshank Redemption" 30 >>output.txt

./shortest "tom cruise" "Jeremy Renner" >>output.txt
./shortest "chris evans" "Scarlett Johansson" >>output.txt
./shortest "tom cruise" "Robert Downey Jr." >>output.txt
./shortest "brad pitt" "will smith" >>output.txt
./shortest "chris evans" "bill clinton" |egrep  "(^[0-8]\. )|(^4[5-9]\. )|(^50\. )" >>output.txt
./shortest "emma stone" "al pacino" |egrep  "(^3[2-5]\. )" >>output.txt
./shortest "emma stone" "adam garcia" |egrep  "(^[5-8]\. )" >>output.txt
./shortest "emma stone" "chelsea field" |egrep  "(^2[2-5]\. )" >>output.txt

./degrees "chris evans" 1 2 |egrep  "(^[0-9]\. )|(^1[0-9]\. )|(^2[0-8]\. )|(^36[8-9]\. )|(^37[0-5]\. )" >>output.txt
./degrees "chris evans" 2 2 |egrep  "(^[0-6]\. )|(^34[5-9]\. )|(^35[0-1]\. )" >>output.txt
./degrees "tom cruise" 1 1 |egrep  "(^[0-9]\. )|(^1[0]\. )|(^4[5-9]\. )|(^5[0-3]\. )" >>output.txt
./degrees "tom cruise" 1 2 |wc -l >>output.txt
./degrees "chris evans" 4 4 |wc -l >>output.txt

dropdb a2
pgs stop

diff "output.txt" "result.txt"
