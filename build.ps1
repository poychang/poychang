function Get-Quote {
    $targetUrl = "https://v2.jokeapi.dev/joke/Programming?type=single&safe-mode"
    $Headers = @{ 'Content-Type' = 'application/json'; }
    $Response = Invoke-RestMethod -Uri $targetUrl -Method 'GET' -Headers $Headers

    if ($Response.error) {
        throw "JokeAPI returned an error: $($Response.message)"
    }

    Write-Output $Response.joke
}

$readmePath = Join-Path $PSScriptRoot 'README.md'
$readme = Get-Content -Path $readmePath -Raw
$quote = Get-Quote

$quoteStart = '<!-- quote:start -->'
$quoteEnd = '<!-- quote:end -->'
$quotePattern = "($([regex]::Escape($quoteStart))).*?($([regex]::Escape($quoteEnd)))"

if ($readme -notmatch $quotePattern) {
    throw 'Could not find quote markers in README.md.'
}

$quoteLines = ($quote -split "\r?\n") | ForEach-Object {
    "> $_"
}
$quoteBlock = $quoteLines -join "`n"

$updatedReadme = [regex]::Replace(
    $readme,
    $quotePattern,
    {
        param($match)
        "$($match.Groups[1].Value)`n$quoteBlock`n$($match.Groups[2].Value)"
    },
    [System.Text.RegularExpressions.RegexOptions]::Singleline
)

[System.IO.File]::WriteAllText(
    $readmePath,
    $updatedReadme,
    [System.Text.UTF8Encoding]::new($false)
)
