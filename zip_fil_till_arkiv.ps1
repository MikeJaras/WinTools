<#   
Author Mikael Jarås 2018-01-03
This script compress all files with certain extension in there current folder 
#> 

if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe" 
 
############################################## 
#### Variables  
 
$filePath = "C:\testcatalog" 
$fileExtension = ".log" 
$files = Get-ChildItem -Path $filePath | Where-Object { $_.Extension -eq $fileExtension } 
$expectedFilesCounter = 0
$existingFiles = 0
$zippedFilesCounter = 0
$AlreadyCompressedFiles = @()
$CompressedFiles = @()
 
########### END of VARIABLES ################## 
 
### add a check if there are no .log files, then exit
#############
 

### compress files in folder to same name 
if ($files) {
    foreach ($file in $files) { 

        # test if there already exists a zipped file.

        $filename = $file | select -expand name
        $filenamenoextension = [System.Io.Path]::GetFileNameWithoutExtension("$filename")
        $ttsf = ($filenamenoextension | %{$_ + ".zip"} )
        $ttuf = ($filenamenoextension | %{$_ + "_UploadedToNTT.zip"} )
#        $ttsf = ((get-childitem  (join-path -path $filepath -childpath $filename)).basename | %{$_ + ".zip"} )
#        $ttuf = ((get-childitem  (join-path -path $filepath -childpath $filename)).basename | %{$_ + "_UploadedToNTT.zip"} )
        (join-path -path $filepath -childpath $ttsf)
        test-path (join-path -path $filepath -childpath $ttsf)
        (join-path -path $filepath -childpath $ttuf)
        test-path (join-path -path $filepath -childpath $ttuf)

    		if (!(test-path (join-path -path $filepath -childpath $ttsf)) -and !(test-path (join-path -path $filepath -childpath $ttuf))) {
                       $expectedFilesCounter = $files.Count
                        $name = $file.name 
                        $directory = $file.DirectoryName 
                        $zipfile = $name.Replace($fileExtension,".zip-compressing") 
                        sz a -tzip "$directory\$zipfile" "$directory\$name"
    					if (test-path "$directory\$zipfile") {
    						$zippedFilesCounter++
                                    $file = (get-childitem "$directory\$zipfile") 
                                    $filenew = (($file.basename) | %{$_ + ".zip"} )
                                    Rename-Item $file $filenew
    						}	
    					write-host "expected file:" $expectedFilesCounter "actual: " $zippedFilesCounter
            }
    		else{
    				$existingFiles++
                    $AlreadyCompressedFiles += $File 
    		}	
    	} 

    if ($expectedFilesCounter -ne $zippedFilesCounter) {
    	Write-Host "--------------------------------------"
        write-host "Check for problems " 
    	write-host "Expected files does not match $expectedFilesCounter != $zippedFilesCounter " 
    	Write-Host "--------------------------------------"
    }

    if ($files.count -eq 0) {Write-Host "No files to compress was found"}
    if ($existingFiles -ne 0) {	write-host "$expectedFilesCounter expected to compress, $existingFiles zip-files already exists"}
    if ($zippedFilesCounter -eq 0) {Write-Host "Nothing to do, no files compressed"}

    Write-host "Files found that are compressed but not removed."
    $AlreadyCompressedFiles 
}
else {
write-host "no files selected, nothing to do"
}    
########### END OF SCRIPT ####################
