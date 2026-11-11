# PostgreSQL Automated Backup Script

$ErrorActionPreference = "Stop"

$projectFolder = Split-Path -Parent $PSScriptRoot
$backupFolder = Join-Path $projectFolder "backups"

if (!(Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = Join-Path $backupFolder "capstone_$timestamp.dump"

Write-Host "Starting PostgreSQL backup..."

pg_dump -U postgres -h localhost -p 5432 -d capstone -F c -f $backupFile

if ($LASTEXITCODE -ne 0) {
    throw "Backup failed. Check PostgreSQL connection and credentials."
}

Write-Host "Backup completed successfully!"
Write-Host "Backup location: $backupFile"
