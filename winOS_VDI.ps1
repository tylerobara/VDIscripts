$vdi_temp="$env:USERPROFILE/Documents/vdi_temp"
$userdocs="$env:USERPROFILE/Documents/"
New-Item -Path $userdocs -Name "vdi_temp" -ItemType "directory"


Get-ChildItem $userdocs -Filter "vdi*"


Invoke-WebRequest -Uri "https://github.com/nsacyber/Windows-Secure-Host-Baseline/archive/master.zip" -OutFile $vdi_temp/master.zip

Expand-Archive -LiteralPath "$vdi_temp/master.zip" -DestinationPath $vdi_temp


Get-ChildItem $vdi_temp

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

#Remove-Item -path $vdi_temp -recurse