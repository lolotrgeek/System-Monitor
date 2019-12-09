#https://techontip.wordpress.com/2010/03/30/powershell-transfer-output-to-txt-csv-html-variable/
#https://stackoverflow.com/questions/47590453/obtain-disk-serial-number-from-drive-letter

#get-wmiobject win32_logicaldisk | Export-Csv f:\disklog.csv -force


$DriveLetters = get-volume | select -ExpandProperty DriveLetter
$Names = get-volume | select -ExpandProperty FileSystemLabel

$i = 0
foreach($DriveLetter in $DriveLetters) 
{
    $Path = $DriveLetter + ':'
    $Index = Get-CimInstance -ClassName Win32_DiskDrive |
        Get-CimAssociatedInstance -Association Win32_DiskDriveToDiskPartition |
        Get-CimAssociatedInstance -Association Win32_LogicalDiskToPartition |
        Where-Object DeviceId -eq $Path |
        Get-CimAssociatedInstance -Association Win32_LogicalDiskToPartition |
        Get-CimAssociatedInstance -Association Win32_DiskDriveToDiskPartition |
        select -ExpandProperty Index

    $LetterIndex = $DriveLetter + ',' + $Index + ',' + $Names[$i]
    $LetterIndex

    $LetterIndex | Out-File disklog$DriveLetter.txt -Encoding utf8
    $i++
} 


#0x$Index
#Get-Content F:\Documents\Rainmeter\Skins\HWiNFO\@Resources\HWiNFO.inc | 
#select-string "HDD" |
#select-string 0x$Index |
#select-string  -SimpleMatch 'HDD' |
#select-string -Pattern '(\d+)'
