if (Get-Command -Name concfg -ErrorAction Ignore) {
    Write-Verbose -Message '[dotfiles] Loading ConCfg settings ...'

    # Set PSReadline colors based on theme
    & concfg tokencolor -n enable
} else {
    Write-Verbose -Message '[dotfiles] Skipping ConCfg settings as unable to locate concfg.'
}