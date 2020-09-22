# https://gallery.technet.microsoft.com/Watches-a-perf-counter-and-2fe742b4
# before MSFT shutdowns it
<#
.SYNOPSIS
Watches a Windows performance counter, and executes the specified file
once the specified counter threshold is crossed.
.DESCRIPTION
Watches a Windows performance counter, and executes the specified file
once the specified counter threshold is crossed. You must know the 
name and path of the performance counter you're after. Use Get-Counter
if you want to explore the syntax of performance counter paths. You
may monitor performance counters on a remote machine as well. The
specified Action can be any executable file, an exe, a vbs, a bat file,
etc. You can also specify the PollFrequency, in seconds. Default is 5.
Use the Verbose switch for extra detail.
.PARAMETER CounterName
This is the full path of the performance counter that you want to monitor.
It may be from the local machine or from a remote machine.
.PARAMETER Threshold
When the performance counter crosses this threshold, the specified action will be triggered. 
It could be an absolute value or it could be a percentage, depending on the perf counter.
.PARAMETER Action
This can be any file that exists and is accessible - it will be executed when the performance
counter threshold is crossed.
.PARAMETER PollFrequency
The frequency, in seconds, that the performance counter will be polled. Default is 5 seconds.
.EXAMPLE
C:\PS> Watch-PerfCounter -CounterName '\processor(_total)\% processor time' -Threshold 90 -Action 'C:\MyFile.bat' -PollFrequency 10 -Verbose
Polls the processer time performance counter every 10 seconds, and executes MyFile.bat once the CPU is over 90%. Outputs Verbose information.
.EXAMPLE
C:\PS> Watch-PerfCounter -CounterName '\\host02\memory\% committed bytes in use' -Threshold 25 -Action 'C:\Compress.exe'
Polls the memory perf counter on remote computer HOST02, and executes a program once it crosses 25%.
.NOTES
Powershell written by Joseph Ryan Ries, but it was Justin Turner's idea.
#>
Function Watch-PerfCounter
{
    #Version: 01 - September 17 2015 - Initial release.
    [CmdletBinding()]
    Param([Parameter(Mandatory=$True)]
            [String]$CounterName,
          [Parameter(Mandatory=$True)]
            [Decimal]$Threshold,
          [Parameter(Mandatory=$True)]
          [ValidateScript({Test-Path $_ -PathType Leaf})]
            [String]$Action,
          [Parameter(Mandatory=$False)]
          [ValidateRange(1,360)]
            [Int]$PollFrequency = 5)
    BEGIN
    {
        Set-StrictMode -Version Latest
        [Diagnostics.Stopwatch]$Stopwatch = [Diagnostics.Stopwatch]::StartNew()

        Write-Verbose "$($PSCmdlet.CommandRuntime) beginning on $(Get-Date)."

        Try
        {
            Get-Counter $CounterName -ErrorAction Stop | Out-Null
            Write-Verbose "Performance counter $CounterName was found."
        }
        Catch
        {
            Write-Error "Perfermance counter was not found or could not be read! `n`n $($_.Exception.Message)"
            Return
        }

        Write-Verbose "Polling every $PollFrequency."
        Write-Verbose "Use Ctrl+C to abort."


        [Bool]$ThresholdCrossed = $False

        While (-Not($ThresholdCrossed))
        {
            Try
            {
                $CookedValue = (Get-Counter $CounterName -ErrorAction Stop).CounterSamples.CookedValue

                Write-Verbose "$CounterName = $CookedValue"

                If ($CookedValue -GT $Threshold)
                {
                    Write-Verbose "Performance counter $CounterName has crossed the threshold of $Threshold!"
                    $ThresholdCrossed = $True
                }
            }
            Catch
            {
                Write-Error "Error reading performance counter. This error may be transient. `n`n $($_.Exception.Message)"
            }

            If (-Not($ThresholdCrossed))
            {
                Start-Sleep -Seconds $PollFrequency
            }
        }

        Invoke-Expression $Action
    }
    PROCESS
    {

    }
    END
    {
        # Reminder: This code block still executes even if we return prematurely from the BEGIN block.
        $Stopwatch.Stop()
        Write-Verbose "$($PSCmdlet.CommandRuntime) completed in $([Math]::Round($Stopwatch.Elapsed.TotalSeconds, 2)) seconds."
    }
}
