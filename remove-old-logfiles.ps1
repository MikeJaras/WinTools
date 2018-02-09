$RetainedDays = 12
#$ProcessFiles = New-Object System.Collections.ArrayList
#$ProcessFiles = @()
$RootPath = "c:\temp\"
$ArchiveBoundary = (Get-Date).AddDays(-$RetainedDays).ToString('yyyy-MM-dd')
#$Candidates = (Get-ChildItem -Path $RootPath).FullName |
#    Where-Object { ($_.BaseName -split '_|\.')[1] -lt $ArchiveBoundary }

$Today = get-date -format yyyy-MM-dd
$Today = [datetime]::ParseExact($Today,"yyyy-MM-dd", $null)
#$Today = get-date -format (Get-Culture).DateTimeFormat.ShortDatePattern
$FileNameRegex  = "([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))"
foreach ($File in (Get-ChildItem -Path $RootPath).FullName) {

   $match = [regex]::matches($File, $FileNameRegex )
   if ($match -ne "") {
    $FileNameDate = $match[0].Groups[1].Value
#    ($Today - [datetime]$FileNameDate).days #skriver hur gammal filen är i dagar.
    if (($Today - [datetime]$FileNameDate).days  -ge $RetainedDays) { $ProcessFiles += $File }
   }
}

$ProcessFiles
