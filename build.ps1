function Get-Quote {
    $targetUrl = "https://v2.jokeapi.dev/joke/Any?type=single"
    $Headers = @{ 'Content-Type' = 'application/json'; }
    $Response = Invoke-WebRequest $targetUrl -SessionVariable 'Session' -Method 'GET' -Headers $Headers
    Write-Output ($Response.Content | ConvertFrom-JSON).joke
}

$readmePath = Join-Path $PSScriptRoot 'README.md'
$readme = Get-Content -Path $readmePath -Raw
$quote = Get-Quote
$quotePattern = '(<div\s+id=["'']quote["'']\s*>).*?(</div>)'

if ($readme -notmatch $quotePattern) {
    throw 'Could not find <div id="quote"> in README.md.'
}

$updatedReadme = [regex]::Replace($readme, $quotePattern, {
        param($match)
        "$($match.Groups[1].Value)`n$quote`n$($match.Groups[2].Value)"
    }, [System.Text.RegularExpressions.RegexOptions]::Singleline)

[System.IO.File]::WriteAllText($readmePath, $updatedReadme, [System.Text.UTF8Encoding]::new($false))
