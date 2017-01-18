#
# ProvisioningFunctions.ps1
#

function Start-AP_SPProvisioning_PnPProvisioning
{
	<#
	.Synopsis
	Start AP_SPProvisioning_PnPProvisioning
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_PnPProvisioning
	.PARAMETER xmlActionObject
	#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
	)
    Begin
    {
		Write-Verbose "Start Start-AP_SPProvisioning_PnPProvisioning"
    }
    Process
    {	
		$xmlFilePath = $xmlActionObject.pathToProvisioningXML;
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		if($xmlFilePath -ne $null)
		{
			Use-AP_SPProvisioning_PnP_Apply-PnPProvisioningTemplate -Path $xmlFilePath -Web $currentWeb.Web 
		}
		else 
		{
			Write-Error "Missing attributes. The attributes [pathToProvisioningXML] must be passed"
		}		
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_PnPProvisioning"
    }
}

function Start-AP_SPProvisioning_GetProvisioningTemplate
{
	<#
	.Synopsis
	Start AP_SPProvisioning_GetProvisioningTemplate
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_GetProvisioningTemplate
	.PARAMETER xmlActionObject
	#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
	)
    Begin
    {
		Write-Verbose "Start Start-AP_SPProvisioning_GetProvisioningTemplate"
    }
    Process
    {	
		$xmlFilePath = $xmlActionObject.Out;
		$standard = $xmlActionObject.StandardArtefactsOutput;

		if($standard -eq $null -or $standard -eq "true") { $standard = $true } else { $standard = $false }

		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		if($xmlFilePath -ne $null)
		{
			Use-AP_SPProvisioning_PnP_Get-PnPProvisioningTemplate -Out $xmlFilePath -Web $currentWeb.Web -standard $standard
		}
		else 
		{
			Write-Error "Missing attributes. The attributes [Out] must be passed"
		}		
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_GetProvisioningTemplate"
    }
}