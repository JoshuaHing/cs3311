#!/usr/local/bin/sh

./title "star war" > "./tests/2_1.txt"
./title "happy" > "./tests/2_2.txt"
./title "mars" > "./tests/2_3.txt"

diff "./tests/2_1.txt" "./tests/2_1_exp.txt"
diff "./tests/2_2.txt" "./tests/2_2_exp.txt"
diff "./tests/2_3.txt" "./tests/2_3_exp.txt"
