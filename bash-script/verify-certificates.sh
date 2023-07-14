#!/bin/bash
# Description: script to check validity of certificates from a list of domains
# Author: Bruno Avelino
# Date: 14/DEZ/2021

RED='\033[0;31m';
NC='\033[0m';

for i in $(cat domains.txt.organizados  |  grep -v "^$" | grep -v "^#" | sed "s/ /\n/g");do 
  echo -e "${RED}[*] $i ${NC}";server="$i";
  echo | openssl s_client -servername $server -connect $server:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -d "=" -f2;
done
