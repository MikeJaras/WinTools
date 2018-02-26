$RetainedDays = 112
$RootPath = "c:\temp\"
$ArchivePath = "c:\temp\arkiv"
$ArchiveBoundary = (Get-Date).AddDays(-$RetainedDays).ToString('yyyy-MM-dd')
$ProcessFiles = New-Object System.Collections.ArrayList
#$ProcessFiles = @()
# Om man vill filtrera ytterligare, tex om man har andra filer i samma katalog.
#$Candidates = (Get-ChildItem -Path $RootPath).FullName |
#    Where-Object { ($_.BaseName -split '_|\.')[1] -lt $ArchiveBoundary }

$Today = get-date -format yyyy-MM-dd
$Today = [datetime]::ParseExact($Today,"yyyy-MM-dd", $null)
#$Today = get-date -format (Get-Culture).DateTimeFormat.ShortDatePattern
$FileNameRegex  = "([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))"

$targets = (Get-ChildItem -Path $RootPath)
foreach ($File in $targets) {
#foreach ($File in (Get-ChildItem -Path $RootPath).FullName) {

   $match = [regex]::matches($File, $FileNameRegex )
   if ($match -ne "") {
    $FileNameDate = $match[0].Groups[1].Value
#    $File
#    ($Today - [datetime]$FileNameDate).days #skriver hur gammal filen är i dagar.
    if (($Today - [datetime]$FileNameDate).days  -ge $RetainedDays) { $ProcessFiles += $File }
   }
}

if ($ProcessFiles) {
    Write-Host "Listing target files to archive"
    $ProcessFiles
}
else {
    Write-Host "No files to move"
    { exit }
}

write-host -nonewline "Continue moving the files to Archive? (Y/N) "
$response = read-host
if ( $response -ne "Y" ) { exit }

foreach ($File in $ProcessFiles) {
    $FileFullName = join-path -path $RootPath -childpath $File
    move-item $FileFullName -Destination $ArchivePath
    }
    
Write-Host "Done moving files"
write-host -nonewline "List all files in archive? (Y/N) "
$response = read-host
if ( $response -ne "Y" ) { exit }

Get-ChildItem -Path $ArchivePath
