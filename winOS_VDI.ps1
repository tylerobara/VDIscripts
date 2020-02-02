<#
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}
# Now running elevated so launch the script:
& Write-Host "test"
#>

#"$env:USERPROFILE/Documents/GitHub/VDIscripts/winOS_VDI.ps1"
Write-Host "`n-----This script will down and install the certificates and software necessary to connect to the AFNET VDI desktops-----`n"
$begin=Read-Host "`n-----Do you wish to continue? yes or no-----`n"

Write-Host $begin

 If ($begin -eq "yes" -OR "y") {
   
#Get-ChildItem $userdocs -Filter "vdi*"

$vdi_temp="$env:USERPROFILE/Documents/vdi_temp"
$userdocs="$env:USERPROFILE/Documents/"
$vdi_test=Test-Path $vdi_temp

If ($vdi_test -ne "True") {
    New-Item -Path $userdocs -Name "vdi_temp" -ItemType "directory"
} Else {
    Write-Host "`n-----Temp directory already exists-----`n"
}

Invoke-WebRequest -Uri "https://github.com/nsacyber/Windows-Secure-Host-Baseline/archive/master.zip" -OutFile $vdi_temp/master.zip

Expand-Archive -LiteralPath "$vdi_temp/master.zip" -DestinationPath $vdi_temp

$RootcertificatesPath = "$vdi_temp\Windows-Secure-Host-Baseline-master\Certificates\Root"

$certificateFiles = @(Get-ChildItem -Path $RootcertificatesPath -Recurse -Include *.cer | Where-Object { $_.PsIsContainer -eq $false})

$certificateFiles | ForEach {
    Import-Certificate -FilePath $_.FullName -CertStoreLocation cert:\LocalMachine\Root # Trusted Root Certification Authories
}

$IntercertificatesPath = "$vdi_temp\Windows-Secure-Host-Baseline-master\Certificates\Intermediate"

$certificateFiles = @(Get-ChildItem -Path $IntercertificatesPath -Recurse -Include *.cer | Where-Object { $_.PsIsContainer -eq $false})

$certificateFiles | ForEach {
    Import-Certificate -FilePath $_.FullName -CertStoreLocation cert:\LocalMachine\CA # Intermediate Certification Authories
}

$horizon_test=Test-Path $vdi_temp/horizon.exe

If ($horizon_test -ne "True") {
Invoke-WebRequest -Uri "https://download3.vmware.com/software/view/viewclients/CART20FQ4/VMware-Horizon-Client-5.3.0-15208953.exe" -OutFile $vdi_temp/horizon.exe
} Else {
    Write-Host "`n-----VMware Horizon Client installer already exists-----`n"
}

#Get-ChildItem $vdi_temp

#Start-Process -FilePath $vdi_temp/horizon.exe -ArgumentList "/silent /norestart" -Verb RunAs

Write-Host "`n-----Cleaning up files and folders-----`n"
#Remove-Item -path $vdi_temp -recurse

$vmview='C:\Program Files (x86)\VMware\VMware Horizon View Client\vmware-view.exe'
$vm_test=Test-Path $vmview
If ($vm_test -eq "True") {
 Start-Process -FilePath $vmview -ArgumentList "-serverURL https://afrcdesktops.us.af.mil"
} Else {
Write-Host "Process failed, please start over"
}
} Else {
 Write-Host "Are you sure?"
 }