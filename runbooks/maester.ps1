#Connect to Microsoft Graph with Mi
Connect-MgGraph -Identity

#Define mail recipient

$MailRecipient = (Get-AutomationVariable -Name "EmailAddress")

#create output folder
$date = (Get-Date).ToString("yyyyMMdd-HHmm")
$FileName = "MaesterReport" + $Date + ".zip"

$TempOutputFolder = $env:TEMP + $date
if (!(Test-Path $TempOutputFolder -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $TempOutputFolder
}

#Run Maester report
cd $env:TEMP
md maester-tests
cd maester-tests
Install-MaesterTests .\tests
Write-Output "Running Maester tests"
Write-Output "Sending report to $MailRecipient"
Invoke-Maester -MailUserId $MailRecipient -MailRecipient $MailRecipient -OutputFolder $TempOutputFolder
