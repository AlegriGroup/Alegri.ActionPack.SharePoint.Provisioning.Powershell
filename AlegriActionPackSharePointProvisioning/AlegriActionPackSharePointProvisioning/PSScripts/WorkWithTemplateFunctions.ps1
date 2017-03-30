

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

        [xml]$content = Get-Content -Path $xmlFilePath -Encoding String
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

		Set-Content -Path $xmlFilePath -Value $content.InnerXml -Encoding String

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

        [xml]$content = Get-Content -Path $xmlFilePath -Encoding String
		$contentTypes = $content.Provisioning.Templates.ProvisioningTemplate.ContentTypes.ContentType

        foreach($contentType in $contentTypes)
		{
			if($groupNames -notcontains $contentType.Group)
			{
				$content.Provisioning.Templates.ProvisioningTemplate.ContentTypes.RemoveChild($contentType);
			}
		}	

		Set-Content -Path $xmlFilePath -Value $content.InnerXml -Encoding String

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

		if($provisioning.Properties -and $handlers -notcontains "Properties")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.Properties);
		}

		if($provisioning.SitePolicy -and $handlers -notcontains "SitePolicy")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.SitePolicy);
		}

		if($provisioning.WebSettings -and $handlers -notcontains "WebSettings")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.WebSettings);
		}

		if($provisioning.RegionalSettings -and $handlers -notcontains "RegionalSettings")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.RegionalSettings);
		}

		if($provisioning.SupportedUILanguages -and $handlers -notcontains "SupportedUILanguages")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.SupportedUILanguages);
		}

		if($provisioning.AuditSettings -and $handlers -notcontains "AuditSettings")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.AuditSettings);
		}

		if($provisioning.PropertyBagEntries -and $handlers -notcontains "PropertyBagEntries")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.PropertyBagEntries);
		}

		if($provisioning.Security -and $handlers -notcontains "Security")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.Security);
		}

		if($provisioning.Navigation -and $handlers -notcontains "Navigation")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.Navigation);
		}

		if($provisioning.SiteFields -and $handlers -notcontains "SiteFields")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.SiteFields);
		}

		if($provisioning.ContentTypes -and $handlers -notcontains "ContentTypes")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.ContentTypes);
		}

		if($provisioning.Lists -and $handlers -notcontains "Lists")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.Lists);
		}

		if($provisioning.Features -and $handlers -notcontains "Features")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.Features);
		}

		if($provisioning.CustomActions -and $handlers -notcontains "CustomActions")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.CustomActions);
		}

		if($provisioning.Files -and $handlers -notcontains "Files")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.Files);
		}

		if($provisioning.Pages -and $handlers -notcontains "Pages")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.Pages);
		}

		if($provisioning.TermGroups -and $handlers -notcontains "TermGroups")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.TermGroups);
		}

		if($provisioning.ComposedLook -and $handlers -notcontains "ComposedLook")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.ComposedLook);
		}

		if($provisioning.Workflows -and $handlers -notcontains "Workflows")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.Workflows);
		}

		if($provisioning.SearchSettings -and $handlers -notcontains "SearchSettings")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.SearchSettings);
		}

		if($provisioning.Publishing -and $handlers -notcontains "Publishing")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.Publishing);
		}

		if($provisioning.AddIns -and $handlers -notcontains "AddIns")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.AddIns);
		}

		if($provisioning.Providers -and $handlers -notcontains "Providers")
		{
			$var = $content.Provisioning.Templates.ProvisioningTemplate.RemoveChild($provisioning.Providers);
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




