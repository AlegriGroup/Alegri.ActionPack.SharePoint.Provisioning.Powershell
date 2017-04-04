# ProvisioningFunctions.ps1
#

function Start-AP_SPProvisioning_PnPProvisioning {
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
        $xmlFilePath = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath -path $xmlActionObject.pathToProvisioningXML;
		$handlers  = "";
		if($xmlActionObject.Handlers) { $handlers = $xmlActionObject.Handlers };
        
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

        if($xmlFilePath -ne $null) {
			
			if($handlers -ne "") 
			{
				$xmlFilePath = Create-AP_SPProvisioning_TemplateWithHandlers -pathToProvisioning $xmlFilePath -handlers $handlers	
            }

            if($handlers -eq "ContentTypes") 
            {
				Add-ContentTypes -xmlFile $xmlFilePath
			}   
			else 
			{         
				Use-AP_SPProvisioning_PnP_Apply-PnPProvisioningTemplate -Path $xmlFilePath -Web $currentWeb.Web 
			}
        }
        else {
            Write-Error "Missing attributes. The attributes [pathToProvisioningXML] must be passed"
        }		
    }
    End 
	{
        Write-Verbose "End Start-AP_SPProvisioning_PnPProvisioning"
    }
}

function Start-AP_SPProvisioning_GetProvisioningTemplate {
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
    Begin {
        Write-Verbose "Start Start-AP_SPProvisioning_GetProvisioningTemplate"
    }
    Process {	
        $xmlFilePath = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath -path $xmlActionObject.Out;
        $standard = $xmlActionObject.StandardArtefactsOutput;
		$handlers = "";
		if($xmlActionObject.Handlers) { $handlers = $xmlActionObject.Handlers }

        if($standard -eq $null -or $standard -eq "true") 
		{
            $standard = $true 
        } else 
		{
            $standard = $false 
        }

        $currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

        if($xmlFilePath -ne $null) {
            Use-AP_SPProvisioning_PnP_Get-PnPProvisioningTemplate -Out $xmlFilePath -Web $currentWeb.Web -standard $standard -Handlers $handlers
        }
        else {
            Write-Error "Missing attributes. The attributes [Out] must be passed"
        }		
    }
    End {
        Write-Verbose "End Start-AP_SPProvisioning_GetProvisioningTemplate"
    }
}

<#
	.Synopsis
	Get-AP_SPProvisioning_GetContentTypeFromXML
	.DESCRIPTION
	Give the ContentType from XML
	.PARAMETER pathToProvisioningXML
  The Path to the Provisiong XML for Search the ContentType
#>
function Get-AP_SPProvisioning_GetContentTypeNameFromXML {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $pathToProvisioningXML
    )
    Begin {
        Write-Verbose "START Get-AP_SPProvisioning_GetContentTypeFromXML"
    }
    Process {	
        $array = @()

        [XML]$provElement = Get-Content -Path $pathToProvisioningXML -Encoding String
        
        if($provElement.Provisioning.Templates.ProvisioningTemplate.ContentTypes) 
        {
            $contentTypes = $provElement.Provisioning.Templates.ProvisioningTemplate.ContentTypes
            
            foreach($val in $contentTypes){
                $array = $val.ContentType.Name
            }
        }
        return $array
    }
    End {
        Write-Verbose "End Start-AP_SPProvisioning_GetProvisioningTemplate"
    }
}
function Get-AP_SPProvisioning_GetListTitleFromXML {
 [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $pathToProvisioningXML
    )
    Begin {
        Write-Verbose "START Get-AP_SPProvisioning_GetContentTypeFromXML"
    }
    Process {	
        $array = @()
        [XML]$provElement = Get-Content -Path $pathToProvisioningXML -Encoding String

        if($provElement.Provisioning.Templates.ProvisioningTemplate.Lists) 
        {
            $Lists = $provElement.Provisioning.Templates.ProvisioningTemplate.Lists
            
            foreach($val in $Lists){
                $array = $val.ListInstance.Title
            }
        }
        return $array
    }
    End {
        Write-Verbose "End Start-AP_SPProvisioning_GetProvisioningTemplate"
    }
}
function Get-AP_SPProvisioning_GetSiteColumngNameFromXML {
 [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $pathToProvisioningXML
    )
    Begin {
        Write-Verbose "START Get-AP_SPProvisioning_GetContentTypeFromXML"
    }
    Process {	
        $array = @()
        [XML]$provElement = Get-Content -Path $pathToProvisioningXML -Encoding String

        if($provElement.Provisioning.Templates.ProvisioningTemplate.SiteFields) 
        {
            $SiteColumns = $provElement.Provisioning.Templates.ProvisioningTemplate.SiteFields
            
            foreach($val in $SiteColumns){
                $array = $val.Field.Name
            }
        }
        return $array
    }
    End {
        Write-Verbose "End Start-AP_SPProvisioning_GetProvisioningTemplate"
    }
}
function Get-AP_SPProvisioning_GetListInstanceFromXML {
	param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $pathToProvisioningXML,
		$title
    )
    Begin {
        Write-Verbose "START Get-AP_SPProvisioning_GetContentTypeFromXML"
    }
    Process {	
        
        [XML]$provElement = Get-Content -Path $pathToProvisioningXML -Encoding String

        if($provElement.Provisioning.Templates.ProvisioningTemplate.Lists.ListInstance) 
        {
            return $provElement.Provisioning.Templates.ProvisioningTemplate.Lists.ListInstance | Where-Object {$_.Title -eq $title }
        }
        else 
		{
			throw "No ListInstance with Title $($title) on File $($pathToProvisioningXML)"
		}
    }
    End {
        Write-Verbose "End Start-AP_SPProvisioning_GetProvisioningTemplate"
    }
}