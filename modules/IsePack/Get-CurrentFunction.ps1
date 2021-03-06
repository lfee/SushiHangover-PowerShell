function Get-FunctionFromText {    
    <#
    .Synopsis
        A Quick Description of what the command does
    .Description
        A Detailed Description of what the command does
    .Example
        An example of using the command        
    #>
    $allTokens = Get-CurrentOpenedFileToken
    $currentToken = Get-CurrentToken 
    
    $functions = @($allTokens |
        Where-Object {
            $_.Type -eq "Keyword" -and
            $_.Content -eq "Function"
        })
        
    $braces = @($allTokens |
        Where-Object {
            "GroupStart", "GroupEnd" -contains $_.Type -and
            "{", "}" -contains $_.Content
        })
        
    $significantTokens = @($functions + $braces | 
        Sort-Object Start)
                    
    for ($i = 0; $i -lt $significantTokens.Count; $i++) {
        if ($significantTokens[$i].Content -eq "Function") {
            $f = $significantTokens[$i]
            
            for ($i = $i + 1; $i -lt $significantTokens.Count; $i++) {
                if ($significantTokens[$i].Content -eq "{") { 
                    $braceCount++
                }
                if ($significantTokens[$i].Content -eq "}") {
                    $braceCount--
                }    
                if ($baceCount -eq 0) {
                    break
                }
            }
            
            if ($significantTokens[$i]) {
                $lastToken = $significantTokens($i)                
            }            
        }
    }
}                        