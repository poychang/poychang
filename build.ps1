function Get-Quote {
    $targetUrl = "https://v2.jokeapi.dev/joke/Any?type=single"
    $Headers = @{ 'Content-Type' = 'application/json'; }
    $Response = Invoke-WebRequest $targetUrl -SessionVariable 'Session' -Method 'GET' -Headers $Headers
    Write-Output ($Response.Content | ConvertFrom-JSON).joke
}

$readme = @"
# Hello World $(Get-Date -Format 'yyyy/MM/dd')

$(Get-Quote)

![PoyChang's github stats](https://github-readme-stats.vercel.app/api?username=poychang&show_icons=true&theme=dracula)
"@

$readme | Out-File -FilePath .\README.md
