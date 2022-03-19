#!/bin/bash
touch pass.txt
PASS_1=$(openssl rand 60 | openssl base64 -A)
PASS_2=$(openssl rand 60 | openssl base64 -A)
PASS_3=$(openssl rand 60 | openssl base64 -A)
echo $PASS_1 >> pass.txt
echo $PASS_2 >> pass.txt
echo $PASS_3 >> pass.txt
echo $PASS_1
echo $PASS_2
echo $PASS_3
read anything