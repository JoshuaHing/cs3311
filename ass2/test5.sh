#!/usr/local/bin/sh

./shortest "tom cruise" "Jeremy Renner" > "./tests/5_1.txt"
./shortest "chris evans" "Scarlett Johansson" > "./tests/5_2.txt"
./shortest "tom cruise" "Robert Downey Jr." > "./tests/5_3.txt"
./shortest "brad pitt" "will smith" > "./tests/5_4.txt"

diff "./tests/5_1.txt" "./tests/5_1_exp.txt"
diff "./tests/5_2.txt" "./tests/5_2_exp.txt"
diff "./tests/5_3.txt" "./tests/5_3_exp.txt"
diff "./tests/5_4.txt" "./tests/5_4_exp.txt"
