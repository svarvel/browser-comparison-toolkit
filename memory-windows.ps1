param (
    [Parameter(Mandatory=$true)][string]$browser,
    [Parameter(Mandatory=$true)][string]$test
)

Write-Output "Measuring $browser for scenario $test"

$repeats = 3
$wait = 30

for ($i=1; $i -le $repeats; $i++) {
    Start-Process -FilePath $browser -WorkingDirectory $ENV:LOCALAPPDATA'\BraveSoftware\Brave-Browser-Beta\Application\'
    Start-Sleep -Seconds $wait

    Get-Content .\scenarios\$test.txt | ForEach-Object {
        $page = $_
        Write-Output "Opening page $page"
        Start-Process -FilePath $browser -WorkingDirectory $ENV:LOCALAPPDATA'\BraveSoftware\Brave-Browser-Beta\Application\' -ArgumentList $page
        Start-Sleep -Seconds 5
    }

    Start-Sleep -Seconds $wait

    $m = ps $browser | measure PM -Sum

    ("$browser $test {0:N2}MB " -f ($m.sum / 1mb))

    Get-Process -Name $browser | Foreach-Object { $_.CloseMainWindow() | Out-Null } | Stop-Process
    Start-Sleep -Seconds 5
}