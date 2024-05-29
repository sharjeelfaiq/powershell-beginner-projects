Install-Package -Name 'MimeKit' -Source "https://www.nuget.org/api/v2" -SkipDependcies
Install-Package -Name 'MailKit' -Source "https://www.nuget.org/api/v2" -SkipDependcies

Add-Type -Path "C:\Program Files (x86)\PackageManagement\NuGet\Packages\MimeKit.4.6.0\lib\netstandard2.0\MimeKit.dll"

Add-Type -Path "C:\Program Files (x86)\PackageManagement\NuGet\Packages\MailKit.4.6.0\lib\netstandard2.0\MailKit.dll"6

$SMTP = New-Object Mailkit.Net.Smtp.SmtpClient
$SMTP

$ServicesFilePath = "D:\website-development\projects\personal\powershell-beginner-projects\Service Checker\Services.csv"

$LogPath = "D:\website-development\projects\personal\powershell-beginner-projects\Service Checker\Log"
$Now = Get-Date -Format "yyyy-MM-dd, hh-mm-ss"
$LogFile = "Service-log-$Now.txt"

$ServiceList = Import-Csv $ServicesFilePath -Delimiter ','

foreach ($Service in $ServiceList) {
 $ServiceName = $Service.Name
 $ServiceStatus = $Service.Status
 $CurrentServiceStatus = (Get-Service -Name $ServiceName).status 

 if ($ServiceStatus -ne $CurrentServiceStatus) {
  $Log = "Service: $ServiceName is currently $CurrentServiceStatus, should be $ServiceStatus."
  $Log
  Out-File -FilePath "$LogPath\$LogFile" -Append -InputObject $Log
  
  Set-Service -Name $ServiceName -Status $ServiceStatus 

  $NewServiceStatus = (Get-Service -Name $ServiceName).status

  if ($NewServiceStatus -eq $ServiceStatus) {
   $Log = "Action was successfull! $ServiceName is now $NewServiceStatus"
   Write-Output $Log

   Out-File -FilePath "$LogPath\$LogFile" -Append -InputObject $Log
  }
  else {
   $Log = "Action failed! $ServiceName is still $CurrentServiceStatus, should be $ServiceStatus."
   Write-Output $Log
  }
 }
}