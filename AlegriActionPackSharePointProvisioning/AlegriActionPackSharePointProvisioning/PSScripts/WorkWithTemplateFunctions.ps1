

function Start-AP_SPProvisioning_CleanPnPTemplateSiteColumnByGroupName {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
    )
    Begin 
	{
        Write-Verbose "Start Start-AP_SPProvisioning_CleanPnPTemplateSiteColumnByGroupName"
    }
    Process 
	{	
        $xmlFilePath = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath -path $xmlActionObject.pathToProvisioningXML;
		$groupNames = $xmlActionObject.GroupNames.split(";");

        [xml]$content = Get-Content -Path $xmlFilePath -Encoding UTF8
		$siteFields = $content.Provisioning.Templates.ProvisioningTemplate.SiteFields.Field
	
		foreach($siteField in $siteFields)
		{
			if($groupNames -contains $siteField.Group)
			{
				if($siteField.WebId) { $siteField.WebId = "{parameter:newWebId}"; }
				if($siteField.SourceID) { $siteField.SourceID = "{parameter:newSourceId}"; }				
			}
			else
			{
				$content.Provisioning.Templates.ProvisioningTemplate.SiteFields.RemoveChild($siteField);
			}
		}	

		Set-Content -Path $xmlFilePath -Value $content.InnerXml

    }
    End 
	{
        Write-Verbose "End Start-AP_SPProvisioning_CleanPnPTemplateSiteColumnByGroupName"
    }
}

function Start-AP_SPProvisioning_CleanPnPTemplateContentTypeByGroupName {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
    )
    Begin 
	{
        Write-Verbose "Start Start-AP_SPProvisioning_CleanPnPTemplateSiteColumnByGroupName"
    }
    Process 
	{	
        $xmlFilePath = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath -path $xmlActionObject.pathToProvisioningXML;
		$groupNames = $xmlActionObject.GroupNames.split(";");

        [xml]$content = Get-Content -Path $xmlFilePath -Encoding UTF8
		$contentTypes = $content.Provisioning.Templates.ProvisioningTemplate.ContentTypes.ContentType

        foreach($contentType in $contentTypes)
		{
			if($groupNames -notcontains $contentType.Group)
			{
				$content.Provisioning.Templates.ProvisioningTemplate.ContentTypes.RemoveChild($contentType);
			}
		}	

		Set-Content -Path $xmlFilePath -Value $content.InnerXml

    }
    End 
	{
        Write-Verbose "End Start-AP_SPProvisioning_CleanPnPTemplateSiteColumnByGroupName"
    }
}

function Create-AP_SPProvisioning_TemplateWithHandlers
{
	[CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $pathToProvisioning,
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $handlers
    )
    Begin 
	{
        Write-Verbose "Start Create-AP_SPProvisioning_TemplateWithHandlers"
    }
    Process 
	{	
        $xmlFilePath = $pathToProvisioning;
		$projectPath = Use-AP_SPProvisioning_SPEnvironment_Get-ProjectPath
		$handlers = $handlers.split(";");
		
        [xml]$content = Get-Content -Path $xmlFilePath 
		$provisioning = $content.Provisioning.Templates.ProvisioningTemplate

		if($provisioning.SiteFields -and $handlers -notcontains "SiteFields")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.SiteFields);
		}

		if($provisioning.ContentTypes -and $handlers -notcontains "ContentTypes")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.ContentTypes);
		}
		
		$tempFilePath = $projectPath + "\Temp\TempProvisioning.xml"

		Set-Content -Path $tempFilePath -Value $content.InnerXml

		return $projectPath + "\Temp\TempProvisioning.xml";
    }
    End 
	{
        Write-Verbose "End Create-AP_SPProvisioning_TemplateWithHandlers"
    }
}




