function Get-Quote {
    $targetUrl = "https://quotes.rest/qod?language=en"
    $Headers = @{ 'Content-Type' = 'application/json'; }
    $Response = Invoke-WebRequest $targetUrl -SessionVariable 'Session' -Method 'GET' -Headers $Headers
    Write-Output ($Response.Content | ConvertFrom-JSON).contents.quotes[0].quote
}

$readme = @"
# Hello World $(Get-Date -Format 'yyyy/MM/dd')

$(Get-Quote)
"@

$readme | Out-File -FilePath .\README.md
