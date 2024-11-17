Write-Output "Starting Maester runbook"

#Connect to Microsoft Graph with MI
Write-Output "Connecting to Microsoft Graph with MI"
Connect-MgGraph -Identity

# Get the variables
$MailRecipient = (Get-AutomationVariable -Name "EmailAddress")
$ResourceGroupName = (Get-AutomationVariable -Name "ResourceGroupName")
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
Write-Output "Installing MaesterTests module"
Install-MaesterTests .\tests

# This is just added as examples of how to run Maester with different options
# You can ignore this and just run Invoke-Maester with the desired options
if ($EnableWebApp -eq "true") {
    try {
        Write-Output "EnableWebApp is true, running Maester for HTML page"
        Invoke-Maester -OutputHtmlFile "$TempOutputFolder\index.html"

        # Create the zip file
        Compress-Archive -Path "$TempOutputFolder\*" -DestinationPath $FileName

        # Connect Az Account using MI
        Connect-AzAccount -Identity

        # Publish to Azure Web App
        Write-Output "Publishing to Azure Web App"
        Publish-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppServiceName -ArchivePath $FileName -Force
        Write-Output "Published to Azure Web App"
    } catch {
        Write-Output "Failed to publish to Azure Web App"
        Write-Output $_
    }
}

# Send the email
if ($MailRecipient) {
    try {
        Write-Output "Sending email to $MailRecipient"
        Invoke-Maester -MailRecipient $MailRecipient 
        Write-Output "Email sent"
    } catch {
        Write-Output "Failed to send email to $MailRecipient"
        Write-Output $_
    }
}