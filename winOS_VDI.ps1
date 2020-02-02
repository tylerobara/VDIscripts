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

Get-ChildItem $userdocs -Filter "vdi*"

$vdi_temp="$env:USERPROFILE/Documents/vdi_temp"
$userdocs="$env:USERPROFILE/Documents/"
$vdi_test=Test-Path $vdi_temp

If ($vdi_test -ne "True") {
    New-Item -Path $userdocs -Name "vdi_temp" -ItemType "directory"
} Else {
    Write-Host "-----Temp directory already exists-----"
}

Get-ChildItem $vdi_temp

<#
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
#>

Invoke-WebRequest -Uri "https://download3.vmware.com/software/view/viewclients/CART20FQ4/VMware-Horizon-Client-5.3.0-15208953.exe" -OutFile $vdi_temp/horizon.exe
Get-ChildItem $vdi_temp


Write-Host "-----Cleaning up files and folders-----"
#Remove-Item -path $vdi_temp -recurse