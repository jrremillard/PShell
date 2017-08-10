# This is a smalll capacity query tool to show hosts resources to VMs resource configured requirements.
# 7/06/2017
cls
Write-host "Getting Cluster List."
Write-host ""
(get-Cluster).Name
write-host""
$clstrs = read-host "Enter Cluster Name to get Capacity results?"
cls
foreach ($clstr in $clstrs)
{
Write-host "Cluster Name: " $clstr -foreground red
write-host ""
$VmCPU = ((Get-cluster $Clstr | get-vm).NumCpu | measure-object -sum).Sum
"Total VM Virtual CPUs: "  + $VmCPU
$VmMem = ((Get-cluster $Clstr | get-vm).MemoryGB | measure-object -sum).Sum
"Total VM Memory: " + [math]::Round($VmMem) + " Gb"
$Vm = (Get-cluster $clstr | get-vm).count
"Total VMs: " + $Vm
$VhstCPU = ((Get-cluster $Clstr | get-vmhost | select -ExpandProperty extensiondata).hardware.cpuinfo.NumCpuThreads | measure-object -sum).Sum
"Total Hosts Logical CPUs: " + $VhstCPU
$VhstMem = ((Get-cluster $Clstr | get-vmhost).MemoryTotalGB | measure-object -sum).Sum
$Vhst = (Get-cluster $clstr | get-vmhost).count
"Total Hosts: " + $Vhst
"Total VM CPUs To Hosts CPUs: " + $VmCPU / $VhstCPU
"Total VM Memory To Total Hosts Memory: " + $VmMem / $VhstMem
"Total VMs To Hosts: " + [math]::Round($Vm / $Vhst) + " VMs to 1 Host"
write-host ""
write-host ""
write-host ""
}