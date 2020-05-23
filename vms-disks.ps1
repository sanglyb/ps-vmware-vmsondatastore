connect-viserver yourVcenterServer
$results = @()
foreach ($vm in Get-Vm)
{
  foreach ($vmHardDisk in $vm | Get-HardDisk)
  {
  $result = "" | select vmName,vmPowerState,MemoryGB,name,FileName,FilePath,CapacityGb,type
  $result.vmName = $vm.Name 
  $result.VMPowerState=$vm.PowerState
  $result.Name = $vmHardDisk.Name
  $result.FileName = $vmHardDisk.Filename.split("]")[0].split("[")[1]
  $result.filepath = $vmHardDisk.Filename
  $result.CapacityGb = [System.Math]::Round($vmHardDisk.CapacityGB, 0)
  $result.type=$vmHardDisk.StorageFormat
  $results += $result
  }
  $result = "" | select vmName,vmPowerState,MemoryGB,name,FileName,FilePath,CapacityGb,type
  $result.vmName = $vm.Name 
#$vm.Name 
  $result.VMPowerState=$vm.PowerState
  $result.Name = "RAM"
  $result.FileName = Get-Datastore -id $vm.datastoreidlist | Select -ExpandProperty Name
  $result.CapacityGb = $vm.MemoryGB
$result.type="none"
  $results += $result
}
#$results
$results | export-csv .\vms-disks.csv -Delimiter ";" -notypeinformation -encoding "UTF8"
