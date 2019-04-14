#!/usr/local/bin/sh

./shortest "chris evans" "bill clinton" | head -n 8 > "./tests/6_1.txt"
./shortest "chris evans" "bill clinton" | tail -n 6 > "./tests/6_2.txt"
./shortest "emma stone" "al pacino" | tail -n 4 > "./tests/6_3.txt"
./shortest "emma stone" "adam garcia" | tail -n 4 > "./tests/6_4.txt"
./shortest "emma stone" "chelsea field" | tail -n 4 > "./tests/6_5.txt"

diff "./tests/6_1.txt" "./tests/6_1_exp.txt"
diff "./tests/6_2.txt" "./tests/6_2_exp.txt"
diff "./tests/6_3.txt" "./tests/6_3_exp.txt"
diff "./tests/6_4.txt" "./tests/6_4_exp.txt"
diff "./tests/6_5.txt" "./tests/6_5_exp.txt"
