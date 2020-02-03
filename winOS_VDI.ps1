Write-Host "`n-----This script will down and install the certificates and software necessary to connect to the AFNET VDI desktops-----`n"
  
$vdi_temp="$env:USERPROFILE/Documents/vdi_temp"
$userdocs="$env:USERPROFILE/Documents/"
$vdi_test=Test-Path $vdi_temp

If ($vdi_test -ne "True") {
    New-Item -Path $userdocs -Name "vdi_temp" -ItemType "directory"
} Else {
    Write-Host "`n-----Temp directory already exists-----`n"
}

Invoke-WebRequest -Uri "http://militarycac.com/CACDrivers/DoDRoot2-5.p7b" -OutFile $vdi_temp/DoDRoot2-5.p7b
Import-Certificate -FilePath $vdi_temp/DoDRoot2-5.p7b -CertStoreLocation cert:\LocalMachine\Root # Trusted Root Certification Authories

Invoke-WebRequest -Uri "http://militarycac.com/maccerts/AllCerts.p7b" -OutFile $vdi_temp/AllCerts.p7b
Import-Certificate -FilePath $vdi_temp/AllCerts.p7b -CertStoreLocation cert:\LocalMachine\CA # Intermediate Certification Authories

$vmview='C:\Program Files (x86)\VMware\VMware Horizon View Client\vmware-view.exe'
$horizon_test=Test-Path $vmview

If ($horizon_test -ne "True") {
Invoke-WebRequest -Uri "https://download3.vmware.com/software/view/viewclients/CART20FQ4/VMware-Horizon-Client-5.3.0-15208953.exe" -OutFile $vdi_temp/horizon.exe
} Else {
    Write-Host "`n-----VMware Horizon Client installer already exists-----`n"
}

Write-Host "`n-----Cleaning up files and folders-----`n"
#Remove-Item -path $vdi_temp -recurse

Start-Process -FilePath $vmview -ArgumentList "--serverURL https://afrcdesktops.us.af.mil"

exit