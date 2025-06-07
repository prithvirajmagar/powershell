Usage Instructions:
Generate Load:
Save the first script as Generate-IISLoad.ps1.
Run it in PowerShell with parameters, e.g.:
powershell



.\Generate-IISLoad.ps1 -Url "http://your-iis-server" -Requests 1000 -Concurrency 20
Adjust -Url to your IIS server's URL, -Requests for the total number of requests, and -Concurrency for simultaneous requests.
Monitor Metrics:
Save the second script as Monitor-IISMetrics.ps1.
Ensure the IIS Management module is available (Import-Module WebAdministration).
Run it in PowerShell, e.g.:
powershell



.\Monitor-IISMetrics.ps1 -IntervalSeconds 5 -SiteName "Default Web Site"
Adjust -IntervalSeconds for refresh frequency and -SiteName to the specific IIS site name.
Notes:
Run both scripts on separate PowerShell instances to generate load and monitor simultaneously.
Ensure you have administrative privileges to access performance counters and IIS metrics.
Modify the monitored metrics or load parameters based on your specific needs.
