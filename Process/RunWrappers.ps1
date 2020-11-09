<#
.SYNOPSIS
    Launches, waits for return of a process and send back info
.DESCRIPTION
    Starts a process and waits for its return code & stderr/stdout output
.EXAMPLE
    PS C:\> $procdata = Start-ProcessAndWait -Process 'cmd.exe' -Arguments '/c','echo Hello'
    if ($procdata.ReturnCode -ne 0) {
        Write-Host "Process exited with error code $($procdata.ReturnCode)"
        Write-Host "Error output: $($procdata.StdErr)"
    } else {
        Write-Host "Standard output: $($procdata.StdOut)"
    }
    Launches the command cmd /c "echo Hello"
.INPUTS
    Process: path to the executable
    Arguments: array of arguments as strings
.OUTPUTS
    hashtable with keys:
        ReturnCode: Exit Code of the Process. Usually 0 means OK.
        StdOut: Standard Output as captured
        StdErr: Error Output as captured
.NOTES
    Exit codes are directly returned by the process. Check the process documentation for meaning
#>
function Start-ProcessAndWait {
    [CmdletBinding()]
    param (
        # Name (including path if necessary) of the binary to launch
        [Parameter(Mandatory,Position=0)]
        [string]$Process,
        # Array of arguments to pass to the program
        [Parameter(Position=1)]
        [string[]]$Arguments
    )
    
    Write-Verbose "Start-ProcessAndWait: Launching $process with parameters:"
    Write-Verbose "$($Arguments -join ' ')"
    $errorfile = [System.IO.Path]::GetTempFileName()
    $outputfile = [System.IO.Path]::GetTempFileName()
    $pi = Start-Process -FilePath $process -ArgumentList $Arguments -Wait `
         -PassThru -RedirectStandardError $errorfile -RedirectStandardOutput $outputfile
    $returncode = $pi.ExitCode
    Write-Verbose "Return Code: $returncode"    
    $outdata = Get-Content $outputfile -raw
    $errdata = Get-Content $errorfile -raw 
    Write-Verbose "Standard Output:"
    if ($null -eq $outdata) {
        Write-Verbose "(No data written to StdOut)"
    } else {
        Write-Verbose $outdata
    }   
    Write-Verbose "Error Output:"
    if ($null -eq $errdata) {
        Write-Verbose "(No data written to StdErr)"
    } else {
        Write-Verbose $errdata
    }
    
    
    Remove-Item -Path $errorfile -Force
    Remove-Item -Path $outputfile -Force
    return @{ReturnCode=$returncode;StdOut=$outdata;StdErr=$errdata}
}

<#
.SYNOPSIS
    Launches the NSI engine and waits for it has finished
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> $procdata = Start-MSI -MSIfile 'foobar.msi' -Arguments 'VAR1=VALUE1','/quiet'
 
.INPUTS
    MSIFile: location of the MSI file
    Arguments: array of arguments as strings, including switches and variable values.
.OUTPUTS
    hashtable with keys:
        ReturnCode: Exit Code of the Process. Usually 0 means OK.
        StdOut: Standard Output as captured
        StdErr: Error Output as captured
.NOTES
    Exit codes are directly returned by the process. Check the process documentation for meaning.
#>

function Start-MSI {
    [CmdletBinding()]
    param (
        # Name (including path if necessary) of the .msi to launch
        [Parameter(Mandatory,Position=0)]
        [string]$MSIfile,
        # Array of arguments to pass to the MSI engine
        [Parameter(Position=1)]
        [string[]]$Arguments
    )
    
    $msiexec = 'msiexec.exe'
    $paramsToPass = @('/i',$MSIfile)+$Arguments
    Write-Verbose "Launching $msiexec with parameters:"
    Write-Verbose "$($paramsToPass -join ' ')"
    $pi = Start-ProcessAndWait -Process $msiexec -Arguments $paramsToPass
    return $pi
}
