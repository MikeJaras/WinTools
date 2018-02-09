<#   
This script compress all files with certain extension in there current folder 

#> 
 
 
#### 7 zip variable I got it from the below link  
 
#### http://mats.gardstad.se/matscodemix/2009/02/05/calling-7-zip-from-powershell/  
# Alias for 7-zip 
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe" 
 
############################################## 
#### Variables  
 
# $filePath = "D:\Loggar\Temp\arkiv\" 
$filePath = "D:\Loggar\Temp\" 
$fileExtension = ".log" 
#$files = Get-ChildItem -Path $filePath | Where-Object { $_.Extension -eq $fileExtension } 
$files = Get-ChildItem  -Path $filePath 192.168.1.2_2018-*.* | Where-Object {$_.Name -match "\d.log"}
$expectedFilesCounter = 0
$zippedFilesCounter = 0
 
########### END of VARIABLES ################## 

### add a check if files already exists
### add a check if there are no .log files, then exit
#############

### compress files in folder to same name
 
foreach ($file in $files) { 
                    $expectedFilesCounter = $files.Count
                    $name = $file.name 
                    $directory = $file.DirectoryName 
                    $zipfile = $name.Replace($fileExtension,".zip") 
                    sz a -tzip "$directory\$zipfile" "$directory\$name"
						if (test-path $zipfile) {
							$zippedFilesCounter++
						}	
					write-host "expected file:" $expectedFilesCounter "actual: " $zippedFilesCounter
                } 

if ($expectedFilesCounter -ne $zippedFilesCounter) {
	Write-Host "--------------------------------------"
    write-host "Check for problems " 
	write-host "Expected files does not match $expectedFilesCounter != $zippedFilesCounter " 
	Write-Host "--------------------------------------"
	}
    else {
	write-host "All done - end of job -"
        }
########### END OF SCRIPT ####################
 