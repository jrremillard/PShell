#This is a star of day Module!
Function Get-LastEvents {
# This will get events for the last 24 hours from VCenter. Log into Vcenter prior to running.
Clear-Host
""
"Gathering Events for Last 24 Hours!"
$OldRpt = Test-Path "c:\temp\EventsForLast24Hours.csv"
if ($OldRpt -eq $true)
{   
    Remove-Item -path "c:\temp\EventsForLast24Hours.csv"
}
$Ydate = get-date -Format yyyy
$Mdate = get-date -Format MM
$PDate = (get-date).adddays(-1).tostring("dd")
$CDate = get-date -format   dd
Get-VIEvent -Start (get-date -day $Pdate -month $MDate -year $YDate) -Finish (get-date -day $Cdate -month $MDate -year $YDate) | select-object CreatedTime, UserName, FullFormattedMessage | where {$_.FullFormattedMessage -notLike "User* logged out*" -and $_.FullFormattedMessage -notLike "Virtual machine*disks consolidated successfully*" -and $_.FullFormattedMessage -notLike "Changed custom field*EMC vProxy*" -and $_.FullFormattedMessage -notLike "Changed custom field com.vmware.vsan.clusterstate on*" -and $_.UserName -ne "VSPHERE.LOCAL\Administrator" } | sort-object fullformattedmessage -unique | sort-object CreatedTime| export-csv c:\temp\EventsForLast24Hours.csv -NoTypeInformation -UseCulture
}

# This will query a specifi log for errors and warnings...

Function Get-AllLogs {
Clear-Host
""
"Gathering Logs and Processing them!"
$OldRpt = Test-Path "c:\temp\Host_Errors.txt"
$OldRpt2 = Test-Path "c:\temp\FinalErrorReport.txt"
if ($OldRpt -eq $true)
{   
    Remove-Item -path "c:\temp\Host_Errors.txt"
    if ($OldRpt2 -eq $true)
    {
    Remove-Item -path "c:\temp\FinalErrorReport.txt"
    Remove-Item -path "c:\temp\ErrorReport.txt"
    }
}
Else{}
$ESXHsts = (get-vmhost).Name
#$ESXHsts = "ccesx02*"
foreach ($ESXHst in $Esxhsts)
{   
    write-output "" | out-file c:\temp\Host_Errors.txt -append
    write-output "" | out-file c:\temp\Host_Errors.txt -append
    $Esxhst | out-file c:\temp\Host_Errors.txt -append
    write-output "********************" | out-file c:\temp\Host_Errors.txt -append
    (Get-Log -VMHost (Get-VMHost $ESXHst*) vmkernel).Entries | Where-Object {$_ -like "*WARNING*" -and $_ -notlike "*Unsupported ioctl*"} | select-object -unique  | out-file c:\temp\Host_Errors.txt -append
    (Get-Log -VMHost (Get-VMHost $ESXHst*) vpxa).Entries | Where-Object {$_ -like "*WARNING*" -and $_ -notlike "*Unsupported ioctl*"} | select-object -unique | out-file c:\temp\Host_Errors.txt -append
    (Get-Log -VMHost (Get-VMHost $ESXHst*) vmkernel).Entries | Where-Object {$_ -like "*ERROR*" -and $_ -notlike "*Unsupported ioctl*"} | select-object -unique | out-file c:\temp\Host_Errors.txt -append
    (Get-Log -VMHost (Get-VMHost $ESXHst*) vpxa).Entries | Where-Object {$_ -like "*ERROR*" -and $_ -notlike "*Unsupported ioctl*"} | select-object -unique | out-file c:\temp\Host_Errors.txt -append
    (Get-Log -VMHost (Get-VMHost $ESXHst*) vmkernel).Entries | Where-Object {$_ -like "*Failed*" -and $_ -notlike "*Unsupported ioctl*"} | select-object -unique | out-file c:\temp\Host_Errors.txt -append
    (Get-Log -VMHost (Get-VMHost $ESXHst*) vpxa).Entries | Where-Object {$_ -like "*Failed*" -and $_ -notlike "*Unsupported ioctl*"} | select-object -unique | out-file c:\temp\Host_Errors.txt -append
}
$ErrorManage = get-content c:\temp\Host_Errors.txt
foreach ($Item in $ErrorManage)
{
    $Fix = $Item.indexof(")")
    $Item.substring($Fix+1) | out-file c:\temp\ErrorReport.txt -append
}
get-content c:\temp\Errorreport.txt | select-string -Pattern 'H:0x0' -notmatch | out-file c:\temp\FinalErrorReport.txt
}
