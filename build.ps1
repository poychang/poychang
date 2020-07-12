function Get-Joke {
    $targetUrl = "https://api.jokes.one/jod"
    $Headers = @{ 'Content-Type' = 'application/json'; }
    $Response = Invoke-WebRequest $targetUrl -SessionVariable 'Session' -Method 'GET' -Headers $Headers
    Write-Output ($Response.Content | ConvertFrom-JSON).contents.jokes[0].joke.text
}

$readme = @"
# Hello World $(Get-Date -Format 'yyyy/MM/dd')

$(Get-Joke)
"@

$readme | Out-File -FilePath .\README.md
