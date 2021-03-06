Function New-NexposeSiteCredential {
<#
    .SYNOPSIS
        Creates a new site or shared credential

    .DESCRIPTION
        Creates a new site or shared credential

    .PARAMETER Name
        The name of the credential

    .PARAMETER Description
        The description of the credential

    .PARAMETER SiteId
        The identifier of the site for the site credential

    .PARAMETER Service
        Specify the type of service to authenticate as well as all of the information required by that service

    .PARAMETER HostRestriction
        The host name or IP address that you want to restrict the credentials to

    .PARAMETER PortRestriction
        Further restricts the credential to attempt to authenticate on a specific port. The port can only be restricted if the property hostRestriction is specified - This is an API bug

    .EXAMPLE
        New-NexposeSiteCredential -Name 'Domain Admin' -SiteId 3 -Service cifs -Domain 'example.com' -Username 'BillyJoeBob' -Password 'Password!'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/site_credentials
        POST: sites/{id}/site_credentials

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$Description,

        [Parameter(Mandatory = $true)]
        [string]$SiteId,

        [Parameter(Mandatory = $true)]
        [ValidateSet('as400','cifs','cifshash','cvs','db2','ftp','http','ms-sql','mysql','notes','oracle','pop','postgresql','remote-exec','snmp','snmpv3','ssh','ssh-key','sybase','telnet')]
        [string]$Service,

        [string]$HostRestriction,

        [ValidateRange(1, 65535)]
        [int]$PortRestriction
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        Switch ($Service) {
            'as400' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'cifs' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'cifshash' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'NTLMHash' -Type 'string' -Mandatory
            }

            'cvs' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'db2' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'ftp' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'http' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Realm'    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'ms-sql' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database'                 -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'UseWindowsAuthentication' -Type 'switch'
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'                   -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                 -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'                 -Type 'string'
            }

            'mysql' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'notes' {
                New-DynamicParameter -Dictionary $dynParam -Name 'NotesIdPassword' -Type 'string' -Mandatory
            }

            'oracle' {
                New-DynamicParameter -Dictionary $dynParam -Name 'SID'                    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'               -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'               -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'EnumerateSids'          -Type 'switch'
                New-DynamicParameter -Dictionary $dynParam -Name 'OracleListenerPassword' -Type 'string'
            }

            'pop' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'postgresql' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'remote-exec' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'snmp' {
                New-DynamicParameter -Dictionary $dynParam -Name 'CommunityName' -Type 'string' -Mandatory
            }

            'snmpv3' {
                New-DynamicParameter -Dictionary $dynParam -Name 'AuthenticationType' -Type 'string' -Mandatory -ValidateSet ('no-authentication','md5','sha')
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'           -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'           -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PrivacyType'        -Type 'string' -Mandatory -ValidateSet ('no-privacy','des','aes-128','aes-192','aes-192-with-3-des-key-extension','aes-256','aes-265-with-3-des-key-extension')
                New-DynamicParameter -Dictionary $dynParam -Name 'PrivacyPassword'    -Type 'string'
            }

            'ssh' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'                    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevation'         -Type 'string' -Mandatory -ValidateSet ('none','sudo','sudosu','su','pbrun','privileged-exec')
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationUsername' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationPassword' -Type 'string'
            }

            'ssh-key' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PrivateKeyPassword'          -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PEMKey'                      -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevation'         -Type 'string' -Mandatory -ValidateSet ('none','sudo','sudosu','su','pbrun','privileged-exec')
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationUsername' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationPassword' -Type 'string'
            }

            'sybase' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database'                 -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'UseWindowsAuthentication' -Type 'switch'
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'                   -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                 -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'                 -Type 'string'
            }

            'telnet' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }
        }
        Return $dynParam
    }

    Begin {
        # Validate account name does not already exist
        [object]$creds = Get-NexposeSiteCredential -Site $SiteId

        ForEach ($credential In $creds) {
            If ($credential.Name -eq $Name) { Throw 'Site credentials already exist with this name' }
        }

        # This loops through bound parameters.  If no corresponding variable exists, one is created
        Function _temp { [cmdletbinding()] param() }
        $BoundKeys = ($PSBoundParameters.Keys | Where-Object { (Get-Command _temp | Select-Object -ExpandProperty Parameters).Keys -notcontains $_ })
        ForEach ($param in $BoundKeys) {
            If (-not (Get-Variable -Name $param -ErrorAction SilentlyContinue)) {
                If (-not ($param -match 'Password|PEMKey|NTLMHash|WhatIf')) {
                    Write-Verbose "Adding variable for dynamic parameter '$param' with value '$($PSBoundParameters.$param)'"
                }
                New-Variable -Name $Param -Value $PSBoundParameters.$param
            }
        }
    }

    Process {
        $apiQuery = @{
            name        = $Name
            description = $Description
            account = @{ service = $Service }
        }

        If (-not [string]::IsNullOrEmpty($HostRestriction)) {
            $apiQuery += @{ hostRestriction = $HostRestriction }
            If ($PortRestriction -ne 0) { $apiQuery += @{ portRestriction = $PortRestriction }}    # BUG Workaround: 00229963
        }

        Switch ($Service) {
            'as400' {
                $apiQuery.account += @{
                    domain   = $Domain
                    username = $Username
                    password = $Password
                }
            }

            'cifs' {
                $apiQuery.account += @{
                    domain   = $Domain
                    username = $Username
                    password = $Password
                }
            }

            'cifshash' {
                $apiQuery.account += @{
                    domain   = $Domain
                    username = $Username
                    htmlHash = $NTLMHash
                }
            }

            'cvs' {
                $apiQuery.account += @{
                    domain   = $Domain
                    username = $Username
                    password = $Password
                }
            }

            'db2' {
                $apiQuery.account += @{
                    database = $Database
                    username = $Username
                    password = $Password
                }
            }

            'ftp' {
                $apiQuery.account += @{
                    username = $Username
                    password = $Password
                }
            }

            'http' {
                $apiQuery.account += @{
                    realm    = $Realm
                    username = $Username
                    password = $Password
                }
            }

            'ms-sql' {
                $apiQuery.account += @{
                    database = $Database
                    useWindowsAuthentication = ($UseWindowsAuthentication.IsPresent)
                    username = $Username
                    password = $Password
                }
                If ($UseWindowsAuthentication.IsPresent) {
                    $apiQuery.account += @{ domain = $Domain }
                }
            }

            'mysql' {
                $apiQuery.account += @{
                    database = $Database
                    username = $Username
                    password = $Password
                }
            }

            'notes' {
                $apiQuery.account += @{
                    notesIDPassword = $NotesIdPassword
                }
            }

            'oracle' {
                $apiQuery.account += @{
                    sid           =  $SID
                    username      =  $Username
                    password      =  $Password
                    enumerateSids = ($EnumerateSids.IsPresent)
                }
                If ($EnumerateSids.IsPresent) { $apiQuery += @{ account = @{ oracleListenerPassword = $OracleListenerPassword }} }
            }

            'pop' {
                $apiQuery.account += @{
                    username = $Username
                    password = $Password
                }
            }

            'postgresql' {
                $apiQuery.account += @{
                    database = $Database
                    username = $Username
                    password = $Password
                }
            }

            'remote-exec' {
                $apiQuery.account += @{
                    username = $Username
                    password = $Password
                }
            }

            'snmp' {
                $apiQuery.account += @{
                    communityName = $CommunityName
                }
            }

            'snmpv3' {
                $apiQuery.account += @{
                    authenticationType = $AuthenticationType
                    username           = $Username
                    privacyType        = $PrivacyType
                }
                If ($AuthenticationType -ne 'no-authentication') {
                    $apiQuery += @{ account = @{ password = $Password }}

                    If ($PrivacyType -ne 'no-authentication') {
                        $apiQuery += @{ account = @{ privacyPassword = $PrivacyPassword }}
                    }
                }
            }

            'ssh' {
                $apiQuery.account += @{
                    username                    = $Username
                    password                    = $Password
                    permissionElevation         = $PermissionElevation
                    permissionElevationUsername = $PermissionElevationUsername
                    permissionElevationPassword = $PermissionElevationPassword
                }
            }

            'ssh-key' {
                $apiQuery.account += @{
                    username                    = $Username
                    privateKeyPassword          = $PrivateKeyPassword
                    pemKey                      = $PEMKey
                    permissionElevation         = $PermissionElevation
                    permissionElevationUsername = $PermissionElevationUsername
                    permissionElevationPassword = $PermissionElevationPassword
                }
            }

            'sybase' {
                $apiQuery.account += @{
                    database                 =  $Database
                    useWindowsAuthentication = ($UseWindowsAuthentication.IsPresent)
                    username                 =  $Username
                    password                 =  $Password
                }
                If ($UseWindowsAuthentication.IsPresent) { $apiQuery.account += @{ domain = $Domain }}
            }

            'telnet' {
                $apiQuery.account += @{
                    username = $Username
                    password = $Password
                }
            }
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/site_credentials" -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
