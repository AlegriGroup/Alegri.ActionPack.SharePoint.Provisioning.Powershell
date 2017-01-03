#
# DependentFunction.ps1
#

function Get-AP_SPProvisioning_SPEnvironment_CurrentWeb 
{
	[CmdletBinding()]
    param
    ()
    Begin
    {
         Write-Verbose "Use_AP_SPProvisioning_SPEnvironment_CurrentWeb  Begin" 
    }
    Process
    {		
        return $Global:AP_SPEnvironment_CurrentWeb  
    }
    End
    {
		Write-Verbose "Use_AP_SPProvisioning_SPEnvironment_CurrentWeb  End"
    }
}

function Use-AP_SPProvisioning_PnP_Get-PnPField
{
    [CmdletBinding()]
    param
    (
		$Web,
		$List,
		$Identity
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPField Begin" 
    }
    Process
    {
		if($List -ne $null -and $Identity -ne $null) 
		{
			return Get-PnPField -Web $Web -List $List -Identity $Identity
		} 
		elseif ($List -eq $null -and $Identity -ne $null)
		{
			return Get-PnPField -Web $Web -Identity $Identity
		} 
		else 
		{
			return Get-PnPField -Web $Web  
		} 
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPField End"
    }
}

function Use-AP_SPProvisioning_PnP_Get-PnPList
{
    [CmdletBinding()]
    param
    (
		$Web,
		$Identity
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPList Begin" 
    }
    Process
    {
		if($Identity -ne $null)
		{ 
			return Get-PnPList -Identity $Identity -Web $Web
		} 
		else 
		{
			return Get-PnPList -Web $web 
		}  
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPList End"
    }
}

function Use-AP_SPProvisioning_PnP_Get-PnPContentType
{
    [CmdletBinding()]
    param
    (
		$Web,
		$Identity
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPList Begin" 
    }
    Process
    {
		if($Identity -ne $null)
		{ 
			return Get-PnPContentType -Identity $Identity -Web $Web
		} 
		else 
		{
			return Get-PnPContentType -Web $web 
		}  
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPList End"
    }
}

