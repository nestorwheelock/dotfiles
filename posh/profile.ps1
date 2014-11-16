# Determine the parent directory of our profile script for use later
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Load PSReadLine if we're running PoSh >= 3.0
if ($PSVersionTable.PSVersion.Major -ge 3) {
    if ((Get-Module PSReadLine -ListAvailable) -and ($Host.Name -eq 'ConsoleHost')) {
        Import-Module PSReadLine

        # Search command history based on any already entered text
        Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
        Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
        Set-PSReadlineOption -HistorySearchCursorMovesToEnd

        # Bash style completion
        Set-PSReadlineKeyHandler -Key Tab -Function Complete
    } else {
        Write-Verbose "Couldn't locate PSReadLine module; not importing to environment."
    }
}

# Load posh-git if we're running PoSh >= 2.0
if ($PSVersionTable.PSVersion.Major -ge 2) {
    if (Get-Module posh-git -ListAvailable) {
        Import-Module posh-git
        Enable-GitColors
        Start-SshAgent -Quiet
    } else {
        Write-Verbose "Couldn't locate posh-git module; not importing to environment."
    }
}

# Load keys into ssh-agent (if we're not using Plink)
$SshKeysPath = 'Y:\Secured\SSH Keys'
$SshKeysExt = '.opsk'
if ($env:GIT_SSH -inotmatch 'plink') {
    if (Get-Command ssh-add.exe -ErrorAction SilentlyContinue) {
        if (Test-Path -PathType Container $SshKeysPath) {
            $SshKeys = Get-ChildItem $SshKeysPath | ? { $_.Extension -eq $SshKeysExt }
            if ($SshKeys) {
                $SshKeys | % { ssh-add $_ 2>&1 } | Out-Null
            } else {
                Write-Warning "Couldn't locate any SSH keys to add; looking for extension: $SshKeysExt"
            }
        } else {
            Write-Warning "The provided SSH keys location doesn't exist: $SshKeysPath"
        }
    } else {
        Write-Warning "Couldn't locate ssh-add.exe binary; not adding SSH keys to agent."
    }
}

# Source any function files in our Functions directory
Get-ChildItem "$ScriptPath\Functions" | % { . $_.FullName }

# Amend our Path to include our Scripts directory
$env:Path += ";$ScriptPath\Scripts"

# Source our custom aliases & functions
. (Join-Path $ScriptPath 'Aliases.ps1')
. (Join-Path $ScriptPath 'Functions.ps1')

# Clean-up
Remove-Variable ScriptPath
