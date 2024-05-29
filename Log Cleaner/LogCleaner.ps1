$DirectoryListFilePath = "D:\website-development\projects\personal\powershell-beginner-projects\Log Cleaner\LogDirectories.csv"

$DirectoryList = Import-Csv -Path $DirectoryListFilePath

foreach ($Directory in $DirectoryList) {
 $DirectoryPath = $Directory.DirectoryPath
 $KeepForDays = $Directory.KeepForDays

  Get-ChildItem -Path $DirectoryPath | Where-Object LastWriteTime -lt $(Get-Date).AddDays(-$KeepForDays) | Remove-Item -Confirm:$false -Force
}