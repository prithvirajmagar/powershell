# Script to generate load on IIS server
param (
    [string]$Url = "http://localhost", # Target IIS server URL
    [int]$Requests = 100,             # Number of requests to send
    [int]$Concurrency = 10            # Number of concurrent requests
)

# Function to send HTTP request
function Send-Request {
    param ([string]$RequestUrl)
    try {
        $response = Invoke-WebRequest -Uri $RequestUrl -Method Get -UseBasicParsing
        Write-Host "Request to $RequestUrl - Status: $($response.StatusCode)"
    }
    catch {
        Write-Host "Error: $($_.Exception.Message)"
    }
}

# Main load generation loop
Write-Host "Starting load test on $Url with $Requests requests and $Concurrency concurrent threads..."

$jobs = @()
for ($i = 1; $i -le $Requests; $i++) {
    $jobs += Start-Job -ScriptBlock {
        param ($url)
        Send-Request -RequestUrl $url
    } -ArgumentList $Url

    # Control concurrency
    while (($jobs | Where-Object { $_.State -eq 'Running' }).Count -ge $Concurrency) {
        Start-Sleep -Milliseconds 100
    }
}

# Wait for all jobs to complete
$jobs | Wait-Job | Out-Null
$jobs | Remove-Job

Write-Host "Load test completed."
