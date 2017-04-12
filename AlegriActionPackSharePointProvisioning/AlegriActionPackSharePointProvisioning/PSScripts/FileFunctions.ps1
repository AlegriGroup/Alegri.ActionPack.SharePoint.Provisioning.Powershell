

function Start-AP_SPProvisioning_ChangeVersionInFile
{
	<# 
	.SYNOPSIS
    Ersetzt alle SharePoint Version in den Dateien 
    .DESCRIPTION
    Es wird im Content der Datei die Version Nummer z.B. 15.0.0.0 auf 16.0.0.0 ersetzt
    .PARAMETER CurrentEnvironment 
    Die aktuelle Environment Konfigurationen 
	.PARAMETER WebContent
	Die Inhalte des aktuellen Webs
	#>
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
    $xmlActionObject
	)
	begin
	{
		Write-Verbose "Start-AP_SPProvisioning_ChangeVersionInFile begin"
	}
	process
	{
		$CurrentEnvironment = $Global:AP_SPEnvironment_XmlCurrentEnvironment;

		if($xmlActionObject.Count -gt 0)
		{
			Write-Host "START Change Version in File"

			foreach($changeVersion in $xmlActionObject)
			{
				$file = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceEnvVariable $changeVersion.FileName

				if($CurrentEnvironment.SharePointVersion -eq "15")
				{
					(Get-Content $file -Encoding String) -replace '16.0.0.0', '15.0.0.0' | Set-Content $file -Encoding String

				}
				if($CurrentEnvironment.SharePointVersion -eq "16")
				{
					(Get-Content $file -Encoding String) -replace '15.0.0.0', '16.0.0.0' | Set-Content $file -Encoding String
				}

				Write-Host "Change Version '$($CurrentEnvironment.SharePointVersion)' in File $file" 
			}

			Write-Host "END Change Version in File" 
		}
		else
		{
			Write-Host "ChangeVersionInFile wird übergangen" 
		}
	}
	end
	{
		Write-Verbose "Start-AP_SPProvisioning_ChangeVersionInFile end"
	}
}

function Start-AP_SPProvisioning_AddWebPartToSite
{
	<# 
	.SYNOPSIS
    Fügt in allen Seiten die WebParts ein
    .DESCRIPTION
    Es werden aus der Provisionierung Konfigurationsdatei die Seiten und WebParts ausgelesen und 
	danach werden die WebParts in die Seiten eingefügt.
    .PARAMETER arrayWebPartSite 
    Die Auflistung der anzugelegenden WebParts in den Seiten 
    #>
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
    $xmlActionObject
	)
	begin
	{
		Write-Verbose "Start-AP_SPProvisioning_AddWebPartToSite begin"
	}
	process
	{
		$arrayWebPartSite = $xmlActionObject.Site

			if($arrayWebPartSite.GetType().Name -eq "XmlElement")
			{
				Add-WebPartsToSite -xmlNodeSite $arrayWebPartSite
			}
			else 
			{
				foreach($site in $arrayWebPartSite)
				{
					Add-WebPartsToSite -xmlNodeSite -$site
				}
			}
	}
	end
	{
		Write-Verbose "Start-AP_SPProvisioning_AddWebPartToSite end"
	}
}

function Add-WebPartsToSite 
{
	[CmdletBinding()]
	param(
		$xmlNodeSite 
	)
	begin
	{
		Write-Verbose "Add-WebPartsToSite begin"
	}
	process
	{
		if($xmlNodeSite.RemoveExistWebParts)
		{
			Remove-WebPartsFromSite -ServerRelativePageUrl $xmlNodeSite.ServerRelativePageUrl
		}
		
		if($xmlNodeSite.WebPart.GetType().Name -eq "XmlElement")
		{
			Add-WebPartToSite -ServerRelativePageUrl $xmlNodeSite.ServerRelativePageUrl -xmlWebPart $xmlNodeSite.WebPart
		}
		else
		{
			foreach($webPart in $xmlNodeSite.WebPart)
			{
				Add-WebPartToSite -ServerRelativePageUrl $xmlNodeSite.ServerRelativePageUrl -xmlWebPart $webPart
			}
		}		
	}
	end
	{
		Write-Verbose "Add-WebPartsToSite end"
	}
}

function Add-WebPartToSite
{
	[CmdletBinding()]
	param(
		$ServerRelativePageUrl,
		$xmlWebPart 
	)
	begin
	{
		Write-Verbose "Add-WebPartToSite begin"
	}
	process
	{
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb
		$pathToWebPart = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceEnvVariable $xmlWebPart.FileWithXMLContent;
		[xml]$wpXml = Get-Content "$($pathToWebPart)";
            
		if($xmlWebPart.ChangeXML)
		{
			Write-Host "START ChangeXML"    

			foreach($param in $xmlWebPart.ChangeXML)
			{                    
				$clearValue = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceEnvVariable $param.Value
				$par = $param.Key.Split(".")
                    
				if($par.Length -eq 1){ 
					$par1 = $par[0]
					$wpXml.WebPart.$par1 = $clearValue 
				}
				if($par.length -eq 2){ 
					$par1 = $par[0]
					$par2 = $par[1]
					$wpXml.WebPart.$par1.$par2 = $clearValue
				}
                    
				Write-Host "Change Content for Param $($param.Param) with value '$clearValue'" 
			}               
                
			Write-Host "END ChangeXML"    
		}

		Use-AP_SPProvisioning_PnP_Add-PnPWebPartToWebPartPage -ServerRelativePageUrl $ServerRelativePageUrl -XML $wpXml.OuterXml -ZoneId $xmlWebPart.ZoneID -ZoneIndex $xmlWebPart.ZoneIndex -Web $currentWeb.Web
            
		Write-Host "Add webpart $($xmlWebPart.FileWithXMLContent) to $ServerRelativePageUrl"
	}
	end
	{
		Write-Verbose "Add-WebPartToSite end"
	}
}

function Remove-WebPartsFromSite
{    
	<# 
	.SYNOPSIS
    Entfernt WebParts von einer Seite
    .DESCRIPTION
    Es werden alle WepParts auf der jeweiligen Seite entfernt
    .PARAMETER arrayWebPartSite 
    Alle Seiten in dennen die WebParts entfert werden sollen. 
	#>
	[CmdletBinding()]
	param(
    $ServerRelativePageUrl
	)
	begin
	{
		Write-Verbose "Remove-WebPartsFromSite begin"
	}
	process
	{
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		Write-Host "START RemoveWebParts for $ServerRelativePageUrl"
        
		$wpToRemove = Use-AP_SPProvisioning_PnP_Get-PnPWebPart -ServerRelativePageUrl $ServerRelativePageUrl -Web $currentWeb.Web

		foreach($webPart in $wpToRemove)
		{
			Use-AP_SPProvisioning_PnP_Remove-PnPWebPart -Title $webPart.WebPart.Title -ServerRelativePageUrl $ServerRelativePageUrl -Web $currentWeb.Web
			Write-Host "Removed WebPart $($webPart.WebPart.Title) from $($ServerRelativePageUrl)"
		}

		Write-Host "Removed All webpart from $ServerRelativePageUrl" 
			
	}
	end
	{
		Write-Verbose "Remove-WebPartsFromSite end"
	}
}

##TODO Alle funktionen noch anpassen

function Start-AddWebParts
{
	<# 
	.SYNOPSIS
    Startet das Hinzufügen der WebParts 
    .DESCRIPTION
    Es werden die WebParts an die Seite hinzugefügt
	.PARAMETER WebContent
	Die Inhalte des aktuellen Webs
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
		$WebContent
	)
	begin
	{
		Write-Verbose "Start-AddWebParts begin"
	}
	process
	{
		if($WebContent.Sites.Site.WebPart.Count -gt 0) 
		{
			AddWebParts -arrayWebPartSite $WebContent.Sites
			Write-Host "Successfully added web parts" 
			Write-Host
		}
		else
		{
			Write-Host "AddWebParts wird übergangen"
		}		
	}
	end
	{
		Write-Verbose "Start-AddWebParts end"
	}
}

function Start-RemoveWebParts
{
	<# 
	.SYNOPSIS
    Startet das Entfernen von WebParts 
    .DESCRIPTION
    Es werden die WebParts von der Seite entfernt
	.PARAMETER WebContent
	Die Inhalte des aktuellen Webs
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
		$WebContent
	)
	begin
	{
		Write-Verbose "Start-RemoveWebParts begin"
	}
	process
	{
		if($WebContent.Sites.Site.WebPart)
		{
			RemoveWebParts -arrayWebPartSite $WebContent.Sites
			Write-Host "Successfully removed web parts from pages" 
			Write-Host
		}
		else
		{
			Write-Host "RemoveWebParts wird übergangen"
		}		
	}
	end
	{
		Write-Verbose "Start-RemoveWebParts end"
	}
}