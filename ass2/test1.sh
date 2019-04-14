#!/usr/local/bin/sh

./acting "james franco" > "./tests/1.txt"

diff "./tests/1.txt" "./tests/exp1.txt"
