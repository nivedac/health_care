$ErrorActionPreference = "Stop"

Write-Host "====================================================="
Write-Host "  Android Production Keystore Generation Setup"
Write-Host "====================================================="
Write-Host "Please enter a strong password for the production keystore."
Write-Host "This password will be used for both the store and the key."
Write-Host "Make sure to write this password down in a secure location!"
Write-Host ""

$secpwd = Read-Host "Enter Keystore Password" -AsSecureString
$pwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secpwd))

if ($pwd.Length -lt 6) {
    Write-Host "Error: Password must be at least 6 characters long." -ForegroundColor Red
    Pause
    exit 1
}

$keystorePath = Join-Path $PSScriptRoot "android\app\upload-keystore.jks"
$keyPropertiesPath = Join-Path $PSScriptRoot "android\key.properties"

if (Test-Path $keystorePath) {
    Write-Host "Error: Keystore already exists at $keystorePath" -ForegroundColor Red
    Pause
    exit 1
}

Write-Host ""
Write-Host "Generating Keystore..."
$dname = "CN=Dr. Baijus Health Care, OU=Development, O=Dr. Baijus Health Care, L=Kerala, C=IN"

& keytool -genkeypair -v -keystore $keystorePath -keyalg RSA -keysize 2048 -validity 10000 -alias upload -dname $dname -storepass $pwd -keypass $pwd

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error generating keystore. See output above." -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

Write-Host "Keystore generated successfully at $keystorePath" -ForegroundColor Green

Write-Host "Generating key.properties..."
$propertiesContent = @"
storePassword=$pwd
keyPassword=$pwd
keyAlias=upload
storeFile=upload-keystore.jks
"@

Set-Content -Path $keyPropertiesPath -Value $propertiesContent -Encoding utf8
Write-Host "key.properties created successfully at $keyPropertiesPath" -ForegroundColor Green

Write-Host ""
Write-Host "====================================================="
Write-Host "SUCCESS! Keystore and key.properties created."
Write-Host "====================================================="
