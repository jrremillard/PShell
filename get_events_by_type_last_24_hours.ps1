# This will get events for the last 24 hours
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