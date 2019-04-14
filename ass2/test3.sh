#!/usr/local/bin/sh

./toprank "Action&Sci-Fi&Adventure" 10 2005 2005 > "./tests/3_1.txt"
./toprank "Sci-Fi&Adventure&Action" 20 1920 2019 > "./tests/3_2.txt"
./toprank 20 1920 2019 > "./tests/3_3.txt"

diff "./tests/3_1.txt" "./tests/3_1_exp.txt"
diff "./tests/3_2.txt" "./tests/3_2_exp.txt"
diff "./tests/3_3.txt" "./tests/3_3_exp.txt"
