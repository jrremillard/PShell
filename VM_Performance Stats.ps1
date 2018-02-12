$VmName = Read-Host "Enter VM to query Performance Stats"
$Day = Read-Host "Enter how many prior hours you want data from"
#$Fday = ($day - 1)
#$StrtTime = (Get-Date).AddDays(- $Fday)
$StrtTime = (Get-Date).AddHours(-$Day)
$endTime = (Get-Date).AddHours("0")
$StrtTime
$endTime
Get-VM $VmName | Select-Object Name, VMHost, NumCpu, MemoryMB, `
@{N = "Start Time" ; E = {$StrtTime}}, @{N = "End Time" ; E = {$endTime}}, `
@{N = "CPU Usage (Average), Mhz" ; E = {[Math]::Round((($_ | Get-Stat -Stat "cpu.usagemhz.average" -Start $StrtTime -Finish $endTime | Measure-Object Value -Average).Average), 2)}} , `
@{N = "Memory Usage (Average), %" ; E = {[Math]::Round((($_ | Get-Stat -Stat "mem.usage.average" -Start $StrtTime -Finish $endTime | Measure-Object Value -Average).Average), 2)}} , `
@{N = "Network Usage (Average), KBps" ; E = {[Math]::Round((($_ | Get-Stat -Stat "net.usage.average" -Start $StrtTime -Finish $endTime | Measure-Object Value -Average).Average), 2)}} , `
@{N = "Disk Usage (Average), KBps" ; E = {[Math]::Round((($_ | Get-Stat -Stat "disk.usage.average" -Start $StrtTime -Finish $endTime | Measure-Object Value -Average).Average), 2)}} | Export-Csv -Path c:\temp\AverageUsage.csv -NoTypeInformation -UseCulture
write-host "Report is located in following location c:\temp\AverageUsage.csv"