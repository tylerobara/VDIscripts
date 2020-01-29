#!/usr/bin/env bash

CERTSDIR=${HOME}/certsdir
rm -rf $CERTSDIR

mkdir -pv $CERTSDIR
cd $CERTSDIR
wget -q https://militarycac.com/maccerts/AllCerts.p7b
wget -q https://militarycac.com/maccerts/RootCert2.cer
wget -q https://militarycac.com/maccerts/RootCert3.cer
wget -q https://militarycac.com/maccerts/RootCert4.cer
wget -q https://militarycac.com/maccerts/RootCert5.cer

openssl pkcs7 -inform der -in AllCerts.p7b -out AllCerts.cer
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain AllCerts.cer

ls -la $CERTSDIR
#rm -rf $CERTSDIR