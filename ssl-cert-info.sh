#!/bin/bash
 
cd /opt/APP/openresty/nginx/conf/ssl/
source="local"
opt="-text -certopt no_header,no_version,no_serial,no_signame,no_pubkey,no_sigdump,no_aux"

FormatOutput()
{ 
  grep -A1 "Subject Alternative Name:" | tail -n1 | tr -d ' ' | tr ',' '\n' | sed 's/DNS://g'
}

CheckLocalCert()
{ 
  openssl x509 -in $crt -noout $opt
}
 
FILESC=*.crt
for crts in $FILESC
do
  echo "$crts"
  crt="$crts"
  CheckLocalCert | FormatOutput
done
