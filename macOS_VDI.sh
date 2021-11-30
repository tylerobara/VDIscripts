#!/bin/bash

#Set variables for VMware Horizon download url & temp directory for certs
HORIZONURL="https://download3.vmware.com/software/view/viewclients/CART22FH2/VMware-Horizon-Client-2111-8.4.0-18968281.dmg"
CERTSDIR=${HOME}/certsdir

#Deleting any cert remnants, downloading and installing certs, deleting un-needed certs directory
rm -rf $CERTSDIR
mkdir -pv $CERTSDIR
cd $CERTSDIR
curl -s https://militarycac.com/maccerts/AllCerts.p7b -o AllCerts.p7b
openssl pkcs7 -inform DER -outform PEM -in AllCerts.p7b -print_certs > AllCerts.cer
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain AllCerts.cer
RootCerts=( RootCert2 RootCert3 RootCert4 RootCert5 )
for cert in "${RootCerts[@]}"
    do
        :
        curl -s https://militarycac.com/maccerts/$cert".cer" -o $cert".cer"
        sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $cert".cer"
done
rm -rf $CERTSDIR

#Downloading VMware Horizon, copying to $AppsDir, cleaning up and launching Horizon Client
curl -s $HORIZONURL -o ~/Downloads/horizon.dmg
hdiutil attach ~/Downloads/horizon.dmg
sudo cp -R "/Volumes/VMware Horizon Client/VMware Horizon Client.app" /Applications
diskutil list | grep VMware | awk '{print $(NF)}' | sed 's/..$//'
horizon_disk=$(diskutil list | grep VMware | awk '{print $(NF)}' | sed 's/..$//')
diskutil unmountDisk /dev/$horizon_disk
rm ~/Downloads/horizon.dmg

open -a "/Applications/VMware Horizon Client.app"
