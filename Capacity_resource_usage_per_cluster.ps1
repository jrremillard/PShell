# This is a smalll capacity query tool to show hosts resources to VMs resource configured requirements.
# 7/06/2017
Clear-Host
Write-host "Getting Cluster List."
Write-host ""
(get-Cluster).Name
write-host""
$clstrs = Read-Host "Enter Cluster Name for Capacity Results?"
Clear-Host
foreach ($clstr in $clstrs)
{
    $HyperThreadCheck = get-cluster $clstr | Get-VMHost
    foreach ($Hyperthread In $HyperThreadCheck)
    {
        $HyperThreadActive = (Get-vmhost $Hyperthread).hyperthreadingactive 
        if ($HyperThreadActive -eq $false)
        {
        $HyperthreadActive= "Disabled"
        }
        Else {$HyperthreadActive= "Enabled"}
    }
Write-host "Cluster Name: " $clstr -foreground red
write-host ""
$VmCPU = ((Get-cluster $Clstr | get-vm).NumCpu | measure-object -sum).Sum
"Total of Combined VM Virtual CPUs: "  + $VmCPU
$VmMem = ((Get-cluster $Clstr | get-vm).MemoryGB | measure-object -sum).Sum
"Total of Combined VM Memory: " + [math]::Round($VmMem) + " Gb"
$Vm = (Get-cluster $clstr | get-vm).count
"Total VM Count: " + $Vm
$VhstPCPU = ((Get-cluster $Clstr | get-vmhost | Select-Object -ExpandProperty extensiondata).hardware.cpuinfo.NumCpuPackages | measure-object -sum).Sum
"Total Hosts Physical CPUs: " + $VhstPCPU
$VhstCPUThread = ((Get-cluster $Clstr | get-vmhost | Select-Object -ExpandProperty extensiondata).hardware.cpuinfo.NumCpuCores | measure-object -sum).Sum
"Total Hosts CPU Threads: " + $VhstCPUThread
$VhstCPU = ((Get-cluster $Clstr | get-vmhost | Select-Object -ExpandProperty extensiondata).hardware.cpuinfo.NumCpuThreads | measure-object -sum).Sum
"Total Hosts Logical CPUs: " + $VhstCPU
$VhstMem = ((Get-cluster $Clstr | get-vmhost).MemoryTotalGB | measure-object -sum).Sum
$Vhst = (Get-cluster $clstr | get-vmhost).count
"Total Hosts: " + $Vhst
"Hyperthreading Status: " + $HyperthreadActive
"Total VM CPUs To Hosts Physical CPUs: " + $VmCPU / $VhstCPUThread
"Total VM CPUs To Hosts LogicalCPUs: " + $VmCPU / $VhstCPU
"Total VM Memory To Total Hosts Memory: " + $VmMem / $VhstMem
"Total VMs To Hosts: " + [math]::Round($Vm / $Vhst) + " VMs to 1 Host"
write-host ""
write-host ""
write-host ""
}