#Connect to Microsoft Graph with MI
Connect-MgGraph -Identity

# Get the variables
$MailRecipient = (Get-AutomationVariable -Name "EmailAddress")
$ResourceGroup = (Get-AutomationVariable -Name "ResourceGroup")
$AppServiceName = (Get-AutomationVariable -Name "AppServiceName")
$EnableWebApp = (Get-AutomationVariable -Name "EnableWebApp")

# Create the date and file name
$date = (Get-Date).ToString("yyyyMMdd-HHmm")
$FileName = "MaesterReport" + $Date + ".zip"

$TempOutputFolder = $env:TEMP + $date
if (!(Test-Path $TempOutputFolder -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $TempOutputFolder
}

# Run Maester report
cd $env:TEMP
md maester-tests
cd maester-tests
Install-MaesterTests .\tests

# This is just added as examples of how to run Maester with different options
# You can ignore this and just run Invoke-Maester with the desired options
if ($EnableWebApp -eq "true") {
    Write-Output "EnableWebApp is true, running Maester for HTML page"
    Invoke-Maester -OutputHtmlFile "$TempOutputFolder\index.html"

    # Create the zip file
    Compress-Archive -Path "$TempOutputFolder\*" -DestinationPath $FileName

    # Connect Az Account using MI
    Connect-AzAccount -Identity

    # Publish to Azure Web App
    Publish-AzWebApp -ResourceGroupName $ResourceGroup -Name $AppServiceName -ArchivePath $FileName -Force
}