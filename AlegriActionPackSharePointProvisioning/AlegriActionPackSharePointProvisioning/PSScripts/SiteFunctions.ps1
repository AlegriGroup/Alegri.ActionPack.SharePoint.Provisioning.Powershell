#
# SiteFunctions.ps1
#
function Start-AP_SPProvisioning_RemovedSubsite
{
	<#
	.Synopsis
	Start AP_SPProvisioning_RemovedListCorrectly
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_RemovedListCorrectly
	.PARAMETER xmlActionObject
	#>
    [CmdletBinding()]
    param
    (
        $xmlActionObject
	)
    Begin
    {
		Write-Verbose "Start Start-AP_SPProvisioning_RemovedSubsite"
    }
    Process
    {
		$currentEnvironment = Use-AP_SPProvisioning_SPEnvironment_Get-CurrentEnvironment
		$childs = $currentEnvironment.SubSites.split(";")

		foreach($child in $childs)
		{
			Remove-SubSite -child $child 
			Write-Host "Successfully removed subsites from the Web" -ForegroundColor Green
			Write-Host
		}   
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_RemovedSubsite"
    }
}

function Start-AP_SPProvisioning_AddSubsite
{
	<#
	.Synopsis
	Start AP_SPProvisioning_RemovedListCorrectly
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_RemovedListCorrectly
	.PARAMETER xmlActionObject
	#>
    [CmdletBinding()]
    param
    (
        $xmlActionObject
	)
    Begin
    {
		Write-Verbose "Start Start-AP_SPProvisioning_AddSubsite"
    }
    Process
    {
		$currentEnvironment = Use-AP_SPProvisioning_SPEnvironment_Get-CurrentEnvironment
		$childs = $currentEnvironment.SubSites.split(";")

		foreach($child in $childs)
		{
			Start-CreateSubSite -child $child 
			Write-Host "Successfully creates subsites for the Web" -ForegroundColor Green
			Write-Host
		}   
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_AddSubsite"
    }
}

function Start-CreateSubSite
{
	<# 
	.SYNOPSIS
    Startet die Erstellung der Subsite
    .DESCRIPTION
    Startet die Erstellung der Subsite
	.PARAMETER CurrentSubSite 
    Das aktuelle Web als XML
	#>	
	param(
        $child
	)
	begin
	{
		Write-Verbose "Start-CreateSubSite begin"
	}
	process
	{
		$env = Use-AP_SPProvisioning_SPEnvironment_Get-EnvironmentFromDestignation -destignation $child

		if($env)
		{
			$title = $env.Title
			$url = $env.Url
			$description = ""
			if($env.Description) { $description = $env.Description }
			$locale = "1033"
			if($env.Locale) { $locale = $env.Locale }
			$template = "STS#0"
			if($env.Template) { $template = $env.Template }
			$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

			Use-AP_SPProvisioning_PnP_New-PnPWeb -Title $title -Url $url -Description $description -Locale $locale -Template $template -Web $currentWeb.Web
		}
		else 
		{
			Write-Host "Subsites $($child) are not exist" -ForegroundColor Red
		}
	}
	end
	{
		Write-Verbose "Start-CreateSubSite end"
	}
}

function Remove-SubSite
{
	<# 
	.SYNOPSIS
    Löscht die Subsite vom SharePoint
    .DESCRIPTION
    Es werden alle Child Subsiten die in der Provisionierung Konfigurationsdatei vom SharePpoint gelöscht
	#>
	[CmdletBinding()]
	param(
		$child
	)
	begin
	{
		Write-Verbose "Remove-SubSite begin"
	}
	process
	{
		$env = Use-AP_SPProvisioning_SPEnvironment_Get-EnvironmentFromDestignation -destignation $child
		        
		if($env)
		{
			$subsite = Use-AP_SPProvisioning_SPEnvironment_Get-WebFromTitle -title $env.Title
			if($subsite)
			{
				Write-Host "Remove Subsites $($subsite.Title)"
				$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb
				Use-AP_SPProvisioning_PnP_Remove-PnPWeb -Identity $subsite.Web.Id -Force $true -Web $currentWeb.Web
				Write-Host "Successfully Remove Subsites $($subsite.Title)" -ForegroundColor Green
			}
			else 
			{
				Write-Host "Web ist nicht geladen [Remove-SubSite]" -ForegroundColor Red
			}
		} 
		else
		{
			Write-Host "Subsites $($child) are not exist" -ForegroundColor Red
		}
		
	}
	end
	{
		Write-Verbose "Remove-SubSite end"
	}
}