

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
				$file = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath $changeVersion.FileName

				if($CurrentEnvironment.SharePointVersion -eq "15")
				{
					(Get-Content $file) -replace '16.0.0.0', '15.0.0.0' | Set-Content $file

				}
				if($CurrentEnvironment.SharePointVersion -eq "16")
				{
					(Get-Content $file) -replace '15.0.0.0', '16.0.0.0' | Set-Content $file
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
		$RemoveWebPart = $xmlActionObject.RemoveExistWebParts
		$arrayWebPartSite = $xmlActionObject.Site
		if($RemoveWebPart -eq "true")
		{
			Remove-WebParts -arrayWebPartSite $arrayWebPartSite
		}		

		foreach($site in $arrayWebPartSite.ChildNodes)
		{
			$pageUrl = $Global:XmlCurrentEnvironment.siteRelUrl + $Global:CurrentWebXML.Url + $site.ServerRelativePageUrl;
        
			Write-Host "START AddWebParts for $pageUrl"

			foreach($webPart in $site.WebPart)
			{
				$pathToWebPart = ReplaceVariable($webPart.FileWithXMLContent);
				[xml]$wpXml = Get-Content "$($pathToWebPart)";
            
				if($webPart.ChangeXML)
				{
					Write-Host "START ChangeXML"    

					foreach($param in $webPart.ChangeXML)
					{                    
						$clearValue = ReplaceVariable($param.Value)
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

				Add-SPOWebPartToWebPartPage -ServerRelativePageUrl $pageUrl -XML $wpXml.OuterXml -ZoneId $webPart.ZoneID -ZoneIndex $webPart.ZoneIndex -Web $Global:CurrentWeb #PnP
            
				Write-Host "Add webpart $($webPart.FileWithXMLContent)  to $pageUrl" 
			}
       
			Write-Host "END AddWebParts for $pageUrl"
		}
		}
	end
	{
		Write-Verbose "Start-AP_SPProvisioning_AddWebPartToSite end"
	}
}

function Remove-WebParts
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
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
	[ValidateNotNullOrEmpty()]
    $arrayWebPartSite 
	)
	begin
	{
		Write-Verbose "RemoveWebParts begin"
	}
	process
	{
		foreach($site in $arrayWebPartSite.ChildNodes)
		{
			$pageUrl = $Global:XmlCurrentEnvironment.siteRelUrl + $Global:CurrentWebXML.Url + $site.ServerRelativePageUrl; 
        
			Write-Host "START RemoveWebParts for $pageUrl"
        
			$wpToRemove = Get-SPOWebPart -ServerRelativePageUrl $pageUrl

			foreach($webPart in $wpToRemove)
			{
				Remove-SPOWebPart -Title $webPart.WebPart.Title -ServerRelativePageUrl $pageUrl -Web $Global:CurrentWeb
			}

			Write-Host "Removed All webpart from $pageUrl" 
		}
	}
	end
	{
		Write-Verbose "RemoveWebParts end"
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