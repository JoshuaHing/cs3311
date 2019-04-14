#!/usr/local/bin/sh

./similar "Happy Feet" 30 > "./tests/4_1.txt"
./similar "The Shawshank Redemption" 30 > "./tests/4_2.txt"

diff "./tests/4_1.txt" "./tests/4_1_exp.txt"
diff "./tests/4_2.txt" "./tests/4_2_exp.txt"
