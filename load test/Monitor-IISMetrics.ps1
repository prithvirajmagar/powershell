# Script to monitor IIS server metrics in real-time
param (
    [int]$IntervalSeconds = 5,    # Interval for refreshing metrics
    [string]$SiteName = "Default Web Site" # IIS site name to monitor
)

# Ensure IIS management module is available
Import-Module WebAdministration -ErrorAction SilentlyContinue

# Function to get IIS metrics
function Get-IISMetrics {
    # CPU Usage
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $cpuUsage = [math]::Round($cpu.CookedValue, 2)

    # Memory Usage
    $memory = Get-CimInstance Win32_OperatingSystem
    $totalMemory = $memory.TotalVisibleMemorySize / 1MB
    $freeMemory = $memory.FreePhysicalMemory / 1MB
    $usedMemory = [math]::Round($totalMemory - $freeMemory, 2)
    $memoryUsagePercent = [math]::Round(($usedMemory / $totalMemory) * 100, 2)

    # IIS Requests per Second
    $requestsPerSec = Get-Counter "\Web Service($SiteName)\Current Connections" | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $currentConnections = [math]::Round($requestsPerSec.CookedValue, 2)

    # Disk I/O
    $diskReads = Get-Counter '\PhysicalDisk(_Total)\Disk Reads/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $diskWrites = Get-Counter '\PhysicalDisk(_Total)\Disk Writes/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $diskIO = [math]::Round($diskReads.CookedValue + $diskWrites.CookedValue, 2)

    # Output metrics
    Clear-Host
    Write-Host "===== IIS Server Metrics ====="
    Write-Host "Timestamp: $(Get-Date)"
    Write-Host "CPU Usage: $cpuUsage %"
    Write-Host "Memory Usage: $usedMemory GB ($memoryUsagePercent %)"
    Write-Host "Current IIS Connections: $currentConnections"
    Write-Host "Disk I/O (Reads + Writes/sec): $diskIO"
    Write-Host "============================="
}

# Continuous monitoring loop
Write-Host "Monitoring IIS server metrics every $IntervalSeconds seconds (Press Ctrl+C to stop)..."
while ($true) {
    Get-IISMetrics
    Start-Sleep -Seconds $IntervalSeconds
}
