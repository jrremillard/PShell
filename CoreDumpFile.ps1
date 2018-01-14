# This is going to get default CoreDupmp file location and set it if needed.
Clear-Host
$Hst = Read-Host "Enter Esx host FQDN to Query Core Dump File location?"
$Srv = $hst.split(".")[0]
$ESXCLi = get-esxcli -vmhost $Hst
Clear-Host
$CoreFile = ($esxcli.system.coredump.file.list() | Where-Object {$_.Active -eq $True}).Path
$CoreFile
Write-Host ""
$Request = Read-Host "Current active Dump File. Would you like to configure the default location Y /N ?"
if ($Request -eq "Y")
{
$esxcli.system.coredump.file.add($null,"husvm-211257-31ea-norep-scratch",$null,"$srv",$null)
$esxcli.system.coredump.file.set($null,"/vmfs/volumes/538e2c79-c5c23ceb-a364-6cae8b2de601/vmkdump/$srv.dumpfile",$null,$null)
$Rpt = ($esxcli.system.coredump.file.list() | Where-Object {$_.Active -eq $True}).Path
Write-Host "New Location is $Rpt."
}
Else
    { 
    Clear-Host
    Write-Host "$CoreFile will remain the core dump location"
     }