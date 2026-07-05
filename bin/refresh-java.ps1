<#
.SYNOPSIS
    Engine for Java Version Switcher (jsw)
#>
param(
    [string]$SwitchTo = $null,
    [switch]$List = $false
)

$JavaRoot = "C:\Program Files\Java"
$SymlinkPath = "$JavaRoot\current"
$ConfigPath = "$PSScriptRoot\..\versions.json"

# 1. Scan for Installed Java Versions
function Get-JavaVersions {
    $Paths = @($JavaRoot, "C:\Program Files\Eclipse Adoptium", "C:\Program Files\Amazon Corretto")
    $Found = @{}

    foreach ($Path in $Paths) {
        if (Test-Path $Path) {
            Get-ChildItem $Path -Directory | Where-Object { $_.Name -match 'jdk[-_]?(\d+)' } | ForEach-Object {
                $Ver = $Matches[1]
                if (-not $Found.ContainsKey($Ver)) {
                    $Found[$Ver] = $_.FullName
                }
            }
        }
    }
    return $Found
}

$Versions = Get-JavaVersions

# Handle listing
if ($List -or ($null -eq $SwitchTo -and $false -eq $List)) {
    Write-Host "Available Java Versions:" -ForegroundColor Cyan
    foreach ($v in ($Versions.Keys | Sort-Object {[int]$_})) {
        Write-Host "  [$v] -> $($Versions[$v])"
    }
    if (Test-Path $SymlinkPath) {
        $CurrentTarget = (Get-Item $SymlinkPath).Target
        Write-Host "`nCurrent Active Version Target: $CurrentTarget" -ForegroundColor Yellow
    }
    exit
}

# Handle switching
if ($SwitchTo) {
    if (-not $Versions.ContainsKey($SwitchTo)) {
        Write-Error "Java version '$SwitchTo' is not installed or detected."
        exit 1
    }

    $TargetJDK = $Versions[$SwitchTo]
    Write-Host "Switching to Java $SwitchTo..." -ForegroundColor Green

    # Remove existing symlink safely without prompting or traversing target folders
    if (Test-Path $SymlinkPath) {
        (Get-Item $SymlinkPath).Delete()
    }

    # Create new Symlink
    New-Item -ItemType SymbolicLink -Path $SymlinkPath -Value $TargetJDK | Out-Null
    
    # Update User JAVA_HOME environment variable permanently
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $SymlinkPath, "User")
    
    Write-Host "Successfully switched! Restart your terminal or run 'refreshenv' if needed." -ForegroundColor Green
}
