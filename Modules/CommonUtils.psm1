<#
    .DESCRIPTION
    Contain commonly used funcions.
#>

<#
    .DESCRIPTION
    Execute a process and throw an error if not exit correctly
    .OUTPUTS
    True if sucess. Throw error if failed
#>
function Start-ShellProcess {
    param (
        [Parameter(Mandatory)]
        [string] $execName,
        [System.Collections.ArrayList] $params
    )

    $proc = Start-Process $execName -ArgumentList $params -Wait -PassThru

    if ($proc.ExitCode -ne 0) {
        # 如果非正常结束，就会报错
        throw "Error executing $($execName) with param: $($params)"
    }

    return $true
}
Export-ModuleMember -Function Start-ShellProcess
