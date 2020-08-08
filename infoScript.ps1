$path1 = Split-Path $script:MyInvocation.MyCommand.Path
$hostname = hostname
$hostname += " INFO"
$finalpath = join-path $path1 $hostname

new-item $finalpath -itemtype directory

$exceloutput = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
$exceloutput += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate

$exceloutput | Export-Csv $finalpath\InstalledSoftware.csv

$hostname = hostname
$IEVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Internet Explorer').Version
$output = "Hostname: " + $hostname + "`r`n" + "IE Version: " +$IEVersion + "`r`n"
$output >$finalpath\BasicInfo.txt
ipconfig /all >$finalpath\NetworkInfo.txt
cd $finalpath
dxdiag /whql:off /t /64bit HardwareInfo.txt
