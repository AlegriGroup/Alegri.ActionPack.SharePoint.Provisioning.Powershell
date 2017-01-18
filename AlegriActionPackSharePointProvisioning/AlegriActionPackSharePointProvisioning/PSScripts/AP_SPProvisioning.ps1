#
# AP_SPProvisioning.ps1
#

#If you want to create default folders for your action package, please comment on the section
#Kommentieren Sie den Bereich ein, wenn Sie vor haben f�r Ihr Aktionspaket Standard Ordner anzulegen 
#$Global:AP_SPProvisioning_Folder_ImportantExample = "$env:USERPROFILE\Documents\ActionFlow\AP_SPProvisioning\ImportantExample"

# All Global Variable where use in this Package and is released from the outside for use
# $Global:AP_SPProvisioning_MyGlobalVariable = $null

# Allows you to bind all scripts into one function call of an action
# Hiermit binden Sie alle Scripte in die jeweils eine Funktionsaufruf einer Aktion enth�lt
. "$PSScriptRoot\DependentFunction.ps1"
. "$PSScriptRoot\LookupSiteColumnFunctions.ps1"
. "$PSScriptRoot\SiteColumnFunctions.ps1"
. "$PSScriptRoot\ProvisioningFunctions.ps1"

# You should register a new function in the two lower functions.
# Sie sollten eine neue Funktion in den beiden unteren Funktionen registrieren. 

<#.Synopsis
.DESCRIPTION
Here is checked if there is the action
Hier wird gepr�ft ob es die Aktion gibt
.PARAMETER actionName
The name of the action
Der Name der Aktion
#>
function Find-ActionInAP_SPProvisioning
{
    [CmdletBinding()]
    [OutputType([bool])]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [string]$actionName
	)
    Begin
    {
		Write-Verbose "Start Find-ActionInAP_SPProvisioning"     
    }
    Process
    {
          switch($actionName)
		  {
			"AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning" { $returnValue = $true }
			"AP_SPProvisioning_ClearLookupSiteColumnOnContentType" { $returnValue = $true }
			"AP_SPProvisioning_ClearLookupSiteColumnOnList" { $returnValue = $true }
			"AP_SPProvisioning_ClearLookupSiteColumn" { $returnValue = $true }
			"AP_SPProvisioning_RemovedSiteColumn" { $returnValue = $true }
			"AP_SPProvisioning_RemovedSiteColumnFromContentType" { $returnValue = $true }
			"AP_SPProvisioning_PnPProvisioning" { $returnValue = $true }
			"AP_SPProvisioning_GetProvisioningTemplate" { $returnValue = $true }
			default { $returnValue = $false }
		  }

		  return $returnValue
    }
    End
    {
		Write-Verbose "End Find-ActionInAP_SPProvisioning"
    }
}

<#
.Synopsis
Start the action
Start der Aktion
.DESCRIPTION
Here the corresponding action is initiated by calling the corresponding function
Hier wird die entsprechende Aktion angestossen in dem die dazugeh�rige Funktion aufgerufen wird
.PARAMETER xmlAction
An XML element <alg: ActionObject>
Ein XML Element <alg:ActionObject>
#>
function Start-ActionFromAP_SPProvisioning
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlAction
	)
    Begin
    {
        Write-Verbose "Start Start-ActionFromAP_SPProvisioning"
    }
    Process
    {
		$actionName = $xmlAction.ActionObject.FirstChild.LocalName

		switch($actionName)
		{
			"AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning" { Start-AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning -xmlActionObject $xmlAction.ActionObject.AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning }
			"AP_SPProvisioning_ClearLookupSiteColumnOnContentType" { Start-AP_SPProvisioning_ClearLookupSiteColumnOnContentType -xmlActionObject $xmlAction.ActionObject.AP_SPProvisioning_ClearLookupSiteColumnOnContentType }
			"AP_SPProvisioning_ClearLookupSiteColumnOnList" { Start-AP_SPProvisioning_ClearLookupSiteColumnOnList -xmlActionObject $xmlAction.ActionObject.AP_SPProvisioning_ClearLookupSiteColumnOnList }
			"AP_SPProvisioning_ClearLookupSiteColumn" { Start-AP_SPProvisioning_ClearLookupSiteColumn -xmlActionObject $xmlAction.ActionObject.AP_SPProvisioning_ClearLookupSiteColumn }
			"AP_SPProvisioning_RemovedSiteColumn" { Start-AP_SPProvisioning_RemovedSiteColumn -xmlActionObject $xmlAction.ActionObject.AP_SPProvisioning_RemovedSiteColumn }
			"AP_SPProvisioning_RemovedSiteColumnFromContentType" { Start-AP_SPProvisioning_RemovedSiteColumnFromContentType -xmlActionObject $xmlAction.ActionObject.AP_SPProvisioning_RemovedSiteColumnFromContentType }
			"AP_SPProvisioning_PnPProvisioning" { Start-AP_SPProvisioning_PnPProvisioning -xmlActionObject $xmlAction.ActionObject.AP_SPProvisioning_PnPProvisioning }
			"AP_SPProvisioning_GetProvisioningTemplate"{ Start-AP_SPProvisioning_GetProvisioningTemplate -xmlActionObject $xmlAction.ActionObject.AP_SPProvisioning_GetProvisioningTemplate}
		}

		Write-Host "Action : $($actionName) is ready" -ForegroundColor Green
		Write-Host ""
    }
    End
    {
		Write-Verbose "End Start-ActionFromAP_SPProvisioning"
    }
}

function Check-ExistFolderInAP_SPProvisioning
{
    <#
    .SYNOPSIS
    Check if the StandardFolder Exists
	�berpr�fen Sie, ob der StandardFolder vorhanden ist
    .DESCRIPTION
	When the module is loaded, it is checked whether the default folders are available. If not, the folders are created accordingly.
    Beim Laden des Moduls wird �berpr�ft ob die Standardordner vorhanden sind. Falls nicht werden die Ordner entsprechend angelegt.
    #>
    begin
    {
        Write-Verbose "Begin Check-ExistFolderInAP_SPProvisioning"
    }
    process
    {
		#Check if Standard folders exist / Pr�fe ob Standard Ordner existieren
		$folder1 = $Global:AP_SPProvisioning_Folder_ImportantExample
		$checkFolder1 = Test-Path $folder1

        if (!$checkFolder1)
        {
            Write-Host "Standard-Folder from Action Pack $($Global:ActionPackageName) must be created" -ForegroundColor Magenta

			if(!(Test-Path $folder1)) #System
			{
                New-Item "$folder1" -ItemType directory | Out-Null   #System
                Write-Host "$folder1 are created" -ForegroundColor Green
            }
        }
		else 
		{
			Write-Host "Standard-Folder from Action Pack $($Global:ActionPackageName) are exist" -ForegroundColor Green
		}
    }
    end
    {
        Write-Verbose "End Check-ExistFolderInAP_SPProvisioning"
    }    
}