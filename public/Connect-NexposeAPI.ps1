Function Connect-NexposeAPI {
<#
    .SYNOPSIS
        Creates a new authentication session to Nexpose

    .DESCRIPTION
        Creates a new authentication session to Nexpose

    .PARAMETER HostName
        The name or ip of the Nexpose Security Console

    .PARAMETER Port
        The port number of the Nexpose Security Console.  Default of 3780

    .PARAMETER Credential
        Credential object containing username and password of user to connect with
        Most of the commands require global administrator rights

    .PARAMETER SkipSSLCheck
        Skip the validation of a self-signed certificate

    .EXAMPLE
        Connect-NexposeAPI -HostName 10.1.2.3 -Port 3780 -Credential (Get-Credential)

    .EXAMPLE
        Connect-NexposeAPI -HostName 10.1.2.3 -Credential $creds

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$HostName,

        [int]$Port = 3780,

        [Parameter(Mandatory = $true)]
        [pscredential]$Credential,

        [switch]$SkipSSLCheck
    )

    Begin {
        If ($SkipSSLCheck.IsPresent) {
            Skip-SSLError
        }
    }

    Process {
        If ($PSCmdlet.ShouldProcess("$($HostName):$Port")) {
            [string]$username = $Credential.UserName
            [string]$securepw = (ConvertFrom-SecureString -SecureString $Credential.Password)
            [string]$password = (New-Object System.Net.NetworkCredential('Null', $(ConvertTo-SecureString -String $securepw), 'Null')).Password
            [string]$authInfo = ([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(('{0}:{1}' -f $username, $password))))

            $iWebReq = (Invoke-WebRequest -Uri "https://$($HostName):$($Port)/api/3/" -Method Get `
                -Headers @{Authorization = ('Basic {0}' -f $authInfo)} `
                -SessionVariable global:NexposeSession `
                -ErrorAction Stop
            )

            # Add extra header information
            $global:NexposeSession.Headers.Add('HostName', $HostName)
            $global:NexposeSession.Headers.Add('Port',     $Port    )
        }
    }

    End {
        Write-Verbose "Connection Status: $($iWebReq.statusCode) $($iWebReq.statusDescription)"
        Write-Output $iWebReq
    }
}
