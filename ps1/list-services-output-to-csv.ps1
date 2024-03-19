<#
.SYNOPSIS
Exports a list of Windows services, sorted by their state, to a CSV file and prints the information to the console. Services currently running are marked with 'Running'.

.DESCRIPTION
This PowerShell script retrieves all services on the local machine, sorts them by their state, and exports selected properties to a CSV file and to the console. The default output file path is "C:\dev\data\write-service-info-to-csv.csv", but can be customized via the -OutputFile parameter. If the --VerboseOutput parameter is present, additional properties (ProcessId, StartMode, Status, ExitCode) are included.

.PARAMETER OutputFile
The path to the output CSV file where the service information will be saved. If the specified output directory does not exist, it will be created. If not specified, the default path is used.

.PARAMETER VerboseOutput
If this switch is provided, include additional properties in the output.

.EXAMPLE
.\list-services-output-to-csv.ps1
Exports the service information to the default file path "C:\dev\data\current-service-info.csv" and prints the information to the console.

.EXAMPLE
.\list-services-output-to-csv.ps1 -OutputFile "C:\custom\path\services.csv" -VerboseOutput
Exports the service information to a specified file path with additional details and prints the information to the console.

.NOTES
Author: Sean Mare
Date: March 7, 2024
#>

param(
    [string]$OutputFile = "C:\dev\data\current-service-info.csv",
    [switch]$VerboseOutput
)

# Ensure the directory exists before attempting to write the file
$directory = Split-Path -Path $OutputFile -Parent
if (-not (Test-Path -Path $directory))
{
    New-Item -ItemType Directory -Path $directory -Force
}

# Get all services and sort them by their state
# Add "-Descending" to change sort order
$services = Get-CimInstance -ClassName Win32_Service | Sort-Object -Property State

# Conditionally select additional properties based on the VerboseOutput switch
$propertyList = if ($VerboseOutput.IsPresent) {
    @(
        'State',
        'Name',
        'Description',
        'ProcessId',
        'StartMode',
        'Status',
        'ExitCode'
    )
} else {
    @(
        'State',
        'Name',
        'Description'
    )
}

# Select the specified properties
$selectedServices = $services | Select-Object $propertyList

# Export the selected information to the specified CSV file, with a default name if not specified
# Add "-NoTypeInformation" to supress header in CSV file
$selectedServices | Export-Csv -Path $OutputFile

# Print the selected information to the console
if ($VerboseOutput.IsPresent) {
    # For verbose output, explicitly list all properties
    $selectedServices | Format-Table -Property 'State', 'Name', 'Description', 'ProcessId', 'StartMode', 'Status', 'ExitCode' -AutoSize -Wrap | Write-Output
} else {
    # For non-verbose output, list only the basic properties
    $selectedServices | Format-Table -Property 'State', 'Name', 'Description' -AutoSize -Wrap | Write-Output
}