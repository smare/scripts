<#
.SYNOPSIS
Transforms a Onetab export file into a webpage.

.DESCRIPTION
This script takes a filename of the Onetab export file and an output filename to transform the export into a webpage. It assumes the input and output files are in "C:\dev\data\onetab" unless a full path is specified for each.  It will always assume the awk script is at "C:\dev\projects\scripts\awk\generate_webpage_from_onetab_export.awk".

.PARAMETER filename
The filename of the Onetab export file. Assumes the file is in the default directory unless a full path is specified.

.PARAMETER outputFile
The filename where the transformed webpage will be saved. Assumes the file is in the default directory unless a full path is specified.

.PARAMETER help
Displays help information for this script.

.EXAMPLE
.\script.ps1 -filename "export.txt" -outputFile "webpage.html"
Transforms "export.txt" from the default directory "C:\dev\data\onetab" into "webpage.html" in the same directory.

.EXAMPLE
.\script.ps1 -filename "C:\path\to\export.txt" -outputFile "C:\path\to\webpage.html"
Transforms "export.txt" from a specified path into "webpage.html" at a specified path.
#>

# Declare parameters
param (
    [string]$filename,
    [string]$outputFile,
    [switch]$help
)

if ($help) {
	$CommandForHelp = ".\" + $MyInvocation.MyCommand.Name
    Get-Help $CommandForHelp
    exit
}

# Validate arguments
if (-not $filename -or -not $outputFile) {
    Write-Host "Incorrect number of arguments provided. Use -help for usage information."
    exit 1
}

# Default directory for input and output files
$defaultDir = "C:\dev\data\onetab"

# Determine if the filename includes a directory path
if (-not [System.IO.Path]::IsPathRooted($filename)) {
    $inputFile = Join-Path -Path $defaultDir -ChildPath $filename
} else {
    $inputFile = $filename
}

# Check if the file exists
if (-not (Test-Path -Path $inputFile -PathType Leaf)) {
    Write-Host "File $inputFile not found."
    exit 1
}

# Determine if the outputFile includes a directory path
if (-not [System.IO.Path]::IsPathRooted($outputFile)) {
    $outputFile = Join-Path -Path $defaultDir -ChildPath $outputFile
} else {
    $outputFile = $outputFile
}

# Extract directory path from the output filename and create it if it doesn't exist
$outputDir = [System.IO.Path]::GetDirectoryName($outputFile)
if (-not (Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Default path for awk script
$awkScriptPath = "C:\dev\projects\scripts\awk\generate_webpage_from_onetab_export.awk"

# Convert Windows paths to WSL paths
$awkScriptPathWSL = $awkScriptPath -replace 'C:\\', '/mnt/c/' -replace '\\', '/'
$inputFilePathWSL = $inputFile -replace 'C:\\', '/mnt/c/' -replace '\\', '/'
$outputFilePathWSL = $outputFile -replace 'C:\\', '/mnt/c/' -replace '\\', '/'

# Execute the awk script with the provided filename and redirect output to the specified output file
# Formulate the command to execute within WSL, ensuring output redirection is handled by WSL's shell
$awkCommand = "wsl bash -c 'awk -f `"$awkScriptPathWSL`" `"$inputFilePathWSL`" > `"$outputFilePathWSL`"'"

Invoke-Expression $awkCommand

if ($LASTEXITCODE -ne 0) {
    Write-Host "An error occurred during the execution of the awk script."
    exit 1
} else {
    Write-Host "Onetab backup transformed successfully."
}
