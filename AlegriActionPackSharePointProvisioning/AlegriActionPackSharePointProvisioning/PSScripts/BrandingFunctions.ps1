#
# BrandingFunctions.ps1
#
function Start-AP_SPProvisioning_SetHomepage
{
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
    $xmlActionObject
	)
	begin
	{
		Write-Verbose "Start-AP_SPProvisioning_SetHomepage begin"
	}
	process
	{
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb
		Use-AP_SPProvisioning_PnP_Set-PnPHomePage -RootFolderRelativeUrl $xmlActionObject.RootFolderRelativeUrl -Web $currentWeb.Web
	}
	end
	{
		Write-Verbose "Start-AP_SPProvisioning_SetHomepage end"
	}
}