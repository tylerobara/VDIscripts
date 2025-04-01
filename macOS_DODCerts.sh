#!/bin/bash

CERTSDIR=${HOME}/certsdir

#Deleting any cert remnants, downloading and installing certs, deleting un-needed certs directory
rm -rf $CERTSDIR && mkdir -pv $CERTSDIR && cd $CERTSDIR
echo "Downloading DoD Root Certificates..."
curl -s https://militarycac.com/maccerts/AllCerts.p7b -o AllCerts.p7b

echo "Converting AllCerts.p7b to PEM format..."
openssl pkcs7 -inform DER -outform PEM -in AllCerts.p7b -print_certs > AllCerts.cer

echo "Adding AllCerts.cer to System Keychain as trusted root certificate..."
echo "Note: You may be prompted for your password to authorize this action."
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain AllCerts.cer

echo "Downloading individual Root Certificates..."
RootCerts=( RootCert3 RootCert4 RootCert5 RootCert6 )
for cert in "${RootCerts[@]}"; do
        curl -s https://militarycac.com/maccerts/$cert".cer" -o $cert".cer"
        echo "Adding $cert.cer to System Keychain as trusted root certificate..."
        echo "  Note: You may be prompted for your password to authorize this action."
        sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $cert".cer"
done

echo "All DoD Root Certificates have been added to the System Keychain as trusted root certificates."
rm -rf $CERTSDIR

