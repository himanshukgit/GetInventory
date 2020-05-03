<# 
browse report on browser 
 
for local 
.\Get-ServerInventory.ps1 -ComputerName localhost -Nomail 
 
 
for other server than local add $credetial and replace code (-ComputerName $computername) with (-ComputerName $computername -Credential $Credential)  
.\Get-ServerInventory.ps1 -ComputerName servername -Credential $Credential -Nomail 
 
 
send report on email (comment out and fillup your details in email section) 
.\Get-ServerInventory.ps1 -ComputerName localhost  
 
#> 
 
[CmdletBinding()] 
 
    Param( 
    [string[]]$ComputerName=$env:COMPUTERNAME, 
    [System.Management.Automation.PSCredential]$Credential, 
    [switch]$Nomail, 
    $Outfile ="$env:temp\out.html", 
    $EmailTo="$env:USERNAME@yourcompany.com" 
 
    ) 
   
 
function Get-Information { 
 
param($computername) 
 
$osx = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computername 
$csx =Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computername 
$bios =Get-WmiObject -Class Win32_BIOS -ComputerName $computername 
$disk=Get-WmiObject -Class Win32_DiskDrive -ComputerName $computername 
 
$properties = [ordered]@{ 
‘RegisteredUser’=$osx.RegisteredUser 
'SystemDirectory'=$osx.SystemDirectory 
'SerialNumber'=$osx.SerialNumber 
‘OS Version’=$osx.version 
‘OS Build’=$osx.buildnumber 
‘RAM’=$csx.totalphysicalmemory 
‘Processors’=$csx.numberofprocessors 
‘BIOS Serial’=$bios.serialnumber  
'Partitions'=$disk.Partitions 
'DeviceID'=$disk.DeviceID 
'Model'=$disk.Model 
'Size'=$disk.Size 
'Caption'=$disk.Caption 
} 
 
$singleserver = New-Object -TypeName PSObject -Property $properties 
echo $singleserver 
 
} 
 
 
$maintable = Get-Information –ComputerName $ComputerName | ConvertTo-Html -As LIST -Fragment -PreContent "<h2>$($ComputerName) Info</h2>"| Out-String 
 
$subtable = Get-WmiObject -Class Win32_LogicalDisk -Filter ‘DriveType=3’ -ComputerName $ComputerName | Select DeviceID,  
@{l="Freespace in MB";e={[math]::round($_.FreeSpace/1024/1024, 0)} }, 
@{l="Size in MB";e={[math]::round($_.FreeSpace/1024/1024, 0)} } | ConvertTo-Html -Fragment -PreContent ‘<h2>Disk Info</h2>’ | Out-String 
 
$head=@' 
<!--mce:0--> 
'@ 
 
$report=ConvertTo-HTML -head $head -PostContent $maintable,$subtable -PreContent “<h1>Inventory on $($ComputerName)</h1>” 
 
 
    if ($nomail) 
    { 
        [System.IO.File]::Delete($Outfile) 
    return  $report
    #| Out-File -FilePath $Outfile 
    #    Invoke-Expression -Command $Outfile 
    } 
    else 
    { 
     
    } 