@{
    IncludeRules = @('*')

    ExcludeRules = @(
        'PSAvoidUsingWriteHost',
        # Broken with child scopes pending fix (GH PR #1489)
        'PSReviewUnusedParameter',
        'PSUseOutputTypeCorrectly',
        'PSUseShouldProcessForStateChangingFunctions',
        'PSUseSingularNouns'
    )

    Rules = @{
        # General rules
        PSAlignAssignmentStatement = @{
            Enable                          = $false
            CheckHashtable                  = $true
        }

        PSAvoidLongLines = @{
            Enable                          = $false
            LineLength                      = 120
        }

        PSAvoidUsingCmdletAliases = @{
            Whitelist = @(
                '%',
                '?'
            )
        }

        PSPlaceCloseBrace = @{
            Enable                          = $true
            IgnoreOneLineBlock              = $true
            NewLineAfter                    = $false
            NoEmptyLineBefore               = $false
        }

        PSPlaceOpenBrace = @{
            Enable                          = $true
            IgnoreOneLineBlock              = $true
            NewLineAfter                    = $true
            OnSameLine                      = $true
        }

        PSProvideCommentHelp = @{
            Enable                          = $true
            BlockComment                    = $true
            ExportedOnly                    = $true
            Placement                       = 'begin'
            VSCodeSnippetCorrection         = $false
        }

        PSUseConsistentIndentation = @{
            Enable                          = $true
            IndentationSize                 = 4
            Kind                            = 'space'
            PipelineIndentation             = 'IncreaseIndentationForFirstPipeline'
        }

        PSUseConsistentWhitespace = @{
            Enable                          = $true
            CheckInnerBrace                 = $true
            CheckOpenBrace                  = $true
            CheckOpenParen                  = $true
            # Incompatible with aligned hashtable assignment (GH #769)
            CheckOperator                   = $false
            # Broken with interpolated strings pending fix (GH PR #1498)
            CheckParameter                  = $false
            CheckPipe                       = $true
            CheckPipeForRedundantWhitespace = $true
            CheckSeparator                  = $true
        }
    }
}
