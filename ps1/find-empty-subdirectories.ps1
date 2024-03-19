<#
.SYNOPSIS
    Finds and returns all empty subdirectories within a specified directory.

.DESCRIPTION
    Accepts a directory path as input and iterates through all its subdirectories,
    returning those that are empty. A subdirectory is considered empty if it does not contain
    any files or other directories.

.PARAMETER InputDirectory
    The path to the directory whose subdirectories will be checked for being empty.

.PARAMETER Help
    Displays the help information for this script.

.EXAMPLE
    .\FindEmptySubdirectories.ps1 -InputDirectory "C:\Path\To\Your\Directory"
    Checks for empty subdirectories within "C:\Path\To\Your\Directory" and outputs their paths.

.EXAMPLE
    .\FindEmptySubdirectories.ps1 -H
    Displays the help information for this script.

.NOTES
    Author: Your Name
    Date: Insert Date
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$InputDirectory,

    [Parameter(Mandatory=$false)]
    [switch]$Help,

    [Parameter(Mandatory=$false)]
    [switch]$H
)

# Function to display help
function Show-Help {
    $helpText = Get-Help $MyInvocation.MyCommand.Path
    Write-Output $helpText
}

# Check if help was requested
if ($Help -or $H) {
    Show-Help
    exit
}

# Verify that InputDirectory was provided
if (-not $InputDirectory) {
    Write-Error "InputDirectory parameter is missing. Use -Help for more information."
    exit
}

# Main script functionality goes here
try {
    # Check if the input directory exists
    if (-Not (Test-Path -Path $InputDirectory)) {
        Write-Error "Directory does not exist: $InputDirectory"
        exit
    }

    # Function to check if a directory is empty
    function Test-DirectoryEmpty {
        param (
            [string]$DirectoryPath
        )

        $items = Get-ChildItem -Path $DirectoryPath -ErrorAction Stop
        return $items.Length -eq 0
    }

    # Get all subdirectories of the input directory
    $subdirectories = Get-ChildItem -Path $InputDirectory -Directory -Recurse -ErrorAction Stop

    # Filter empty subdirectories
    $emptySubdirectories = $subdirectories | Where-Object { Is-DirectoryEmpty $_.FullName }

    # Output the paths of the empty subdirectories
    if ($emptySubdirectories) {
        $emptySubdirectories.FullName
    } else {
        Write-Output "No empty subdirectories found."
    }
} catch {
    Write-Error "An error occurred: $_"
}
