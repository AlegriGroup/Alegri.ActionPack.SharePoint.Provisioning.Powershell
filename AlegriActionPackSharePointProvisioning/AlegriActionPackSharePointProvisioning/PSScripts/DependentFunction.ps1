#
# DependentFunction.ps1
#

###### Alegri.ActionPack.SharePoint.Environment.Powershell  ##########
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
function Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath
{
	[CmdletBinding()]
    [OutputType([int])]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $path
	)
	Begin
    {
          Write-Verbose "Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath BEGIN"
    }
    Process
    {
		return Check-AP_SPEnvironment_ReplaceProjectPath -path $path
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath END"
    }
}
function Use-AP_SPProvisioning_SPEnvironment_Get-ProjectPath 
{
	return Get-AP_SPEnvironment_ProjectPath;
}
function Use-AP_SPProvisioning_SPEnvironment_Get-CurrentEnvironment
{
	return $Global:AP_SPEnvironment_XmlCurrentEnvironment
}
function Use-AP_SPProvisioning_SPEnvironment_Get-EnvironmentFromDestignation
{
[CmdletBinding()]
    [OutputType([int])]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $destignation
	)
	Begin
    {
          Write-Verbose "Use-AP_SPProvisioning_SPEnvironment_Get-EnvironmentFromDestignation BEGIN"
    }
    Process
    {
		return Get-EnvironmentFromDestignation -destignation $destignation
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_SPEnvironment_Get-EnvironmentFromDestignation END"
    }
}
function Use-AP_SPProvisioning_SPEnvironment_Get-WebFromTitle
{
	[CmdletBinding()]
    [OutputType([int])]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $title
	)
	Begin
    {
          Write-Verbose "Use-AP_SPProvisioning_SPEnvironment_Get-WebFromTitle BEGIN"
    }
    Process
    {
		try{
			$web = Get-WebFromTitle -title $title
			return $web;
		} catch {
			return $null;
		}		
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_SPEnvironment_Get-WebFromTitle END"
    }
}

##### Base ##############
function Use-AP_SPProvisioning_PnP_Set-PnPTraceLog
{
	[CmdletBinding()]
    param
    (
		$modus
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Set-PnPTraceLog Begin" 
    }
    Process
    {
		$path = $Global:AP_SPProvisioning_Folder_LogFiles + "\traceoutput.txt"
		if($modus) {
			Set-PnPTraceLog -On -LogFile $path -Level Debug
		}
		else {
			Set-PnPTraceLog -Off
		}
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Set-PnPTraceLog End"
    }
}

##### Site ##############
function Use-AP_SPProvisioning_PnP_Remove-PnPWeb
{
	[CmdletBinding()]
    param
    (
		$Identity,
		$Force,
		$Web
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPWeb Begin" 
    }
    Process
    {
		if($Identity -ne $null) 
		{
			
				if($Force){
					Remove-PnPWeb -Identity $Identity -Force -Web $Web
				}
				else
				{
					Remove-PnPWeb -Identity $Identity -Web $Web
				}
			
		} 
		else 
		{
			Write-Host "The Argument URL are missed" -ForegroundColor Red
		} 
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPWeb End"
    }
}
function Use-AP_SPProvisioning_PnP_New-PnPWeb
{
	[CmdletBinding()]
    param
    (
		$Title,
		$Url,
		$Description,
		$Locale,
		$Template,
		$Web
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_New-PnPWeb Begin" 
    }
    Process
    {
		if($Title -ne $null -and $Url -ne $null -and $Description -ne $null -and $Locale -ne $null -and $Template -ne $null -and $Web -ne $null) 
		{
			New-PnPWeb -Title $Title -Url $Url -Description $Description -Locale $Locale -Template $Template -Web $Web
		} 
		else 
		{
			Write-Host "One Argument URL are missed [Use-AP_SPProvisioning_PnP_New-PnPWeb]" -ForegroundColor Red
		} 
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_New-PnPWeb End"
    }
}


##### Fields ############
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
			$ctx = Get-PnPContext
			if($ctx.Web.Id -eq $Web.Id)
			{
				return Get-PnPField;
			}
			return Get-PnPField -Web $Web  
		} 
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPField End"
    }
}
function Use-AP_SPProvisioning_PnP_Remove-PnPField
{
    [CmdletBinding()]
    param
    (
		$Web,
		$List,
		$Identity,
		$Force
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPField Begin" 
    }
    Process
    {
		if($List -ne $null -and $Identity -ne $null) 
		{
			if($Force -ne $null)
			{
				Remove-PnPField -Web $Web -List $List -Identity $Identity -Force
			}
			else 
			{
				Remove-PnPField -Web $Web -List $List -Identity $Identity
			}
			
		} 
		elseif ($List -eq $null -and $Identity -ne $null)
		{
			if($Force -ne $null)
			{
				Remove-PnPField -Web $Web -Identity $Identity -Force
			}
			else 
			{
				Remove-PnPField -Web $Web -Identity $Identity 
			}
		} 
		else 
		{
			Write-Error "[Use-AP_SPProvisioning_PnP_Remove-PnPField] => Missing attributes. At least one of the attributes [List or Identity] must be passed" 
		} 
	}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPField End"
    }
}
function Use-AP_SPProvisioning_PnP_Add-PnPField
{
	[CmdletBinding()]
    param
    (
		$Web,
		$List,
		$DisplayName,
		$InternalName,
		$Type,
		$Id
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Add-PnPField Begin" 
    }
    Process
    {
		if($DisplayName -ne $null -and $InternalName -ne $null -and $Type -ne $null) {
			if($List -ne $null) 
			{
				Add-PnPField -List $List -DisplayName $DisplayName -InternalName $InternalName -Type $Type -Id $Id			
			} 
			else
			{
				Add-PnPField -DisplayName $DisplayName -InternalName $InternalName -Type $Type -Id $Id	
			} 
		}
		else 
		{
			Write-Error "[Use-AP_SPProvisioning_PnP_Add-PnPField] => Missing attributes. At least one of the attributes [DisplayName, InternalName or Type] must be passed" 
		} 
	}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Add-PnPField End"
    }
}

###### Lists #############
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
function Use-AP_SPProvisioning_PnP_Remove-PnPList
{
    [CmdletBinding()]
    param
    ( $Web,	$Identity, $Force	)
    Begin
    { Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPList Begin" }
    Process
    {
			if($Force)
			{ 
				Remove-PnPList -Identity $Identity -Web $Web -Force
			} 
			else 
			{ 
				Remove-PnPList -Identity $Identity -Web $Web 
			} 

    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPList End"
    }
}
function Use-AP_SPProvisioning_PnP_Get-PnPListItem
{
    [CmdletBinding()]
    param
    (
		$Web,
		$List
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPListItem Begin" 
    }
    Process
    {
		return Get-PnPListItem -List $list -Web $Web
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPListItem End"
    }
}
function Use-AP_SPProvisioning_PnP_Add-PnPListItem
{
    [CmdletBinding()]
    param
    (
		$List,
		$Values,
		$Web
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPListItem Begin" 
    }
    Process
    {
		Add-PnPListItem -List $List -Values $Values
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPListItem End"
    }
}

###### Content Types #################################
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
			$ctx = Get-PnPContext
			if($ctx.Web.Id -eq $Web.Id)
			{
				return Get-PnPContentType;
			}
			return Get-PnPContentType -Web $Web 
		}  
    }
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPList End"
    }
}
function Use-AP_SPProvisioning_PnP_Add-PnPContentType
{
[CmdletBinding()]
    param
    (
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 0)]
			$Web,
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 1)]
			$contentTypeId,
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 2)]
			$contentTypeName,
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 2)]
			$contentTypeDescription,
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 2)]
			$contentTypeGroup
		)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Add-PnPContentType Begin" 
    }
    Process
    {
		return Add-PnPContentType -Name $contentTypeName -ContentTypeId $contentTypeId -Description $contentTypeDescription -Group $contentTypeGroup -Web $Web
	}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Add-PnPContentType End"
    }
}
function Use-AP_SPProvisioning_PnP_Remove-PnPContentType
{
    [CmdletBinding()]
    param
    (
		$Web,
		$Identity,
		$Force
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPContentType Begin" 
    }
    Process
    {
		if($Identity -ne $null) 
		{
			if($Force -ne $null)
			{
				Remove-PnPContentType -Web $Web -Identity $Identity -Force
			}
			else 
			{
				Remove-PnPContentType -Web $Web -Identity $Identity
			}			
		} 
		else 
		{
			Write-Error "[Use-AP_SPProvisioning_PnP_Remove-PnPContentType] => Missing attributes. At least one of the attributes [Identity] must be passed" 
		} 
	}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPContentType End"
    }
}
function Use-AP_SPProvisioning_PnP_Add-PnPFieldFromContentType
{
    [CmdletBinding()]
    param
    (
		$Field,
		$contentTypeId,
		$Required,
		$Hidden,
		$Web
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Add-PnPFieldFromContentType Begin" 
    }
    Process
    {
		if($Required)
		{ 
			if($Hidden) { Add-PnPFieldToContentType -Field $Field -ContentType $contentTypeId -Required -Web $Web -Hidden } 
			else        { Add-PnPFieldToContentType -Field $Field -ContentType $contentTypeId -Required -Web $Web }
		} 
		else 
		{   
			if($Hidden) { Add-PnPFieldToContentType -Field $Field -ContentType $contentTypeId -Web $Web -Hidden }
			else        { Add-PnPFieldToContentType -Field $Field -ContentType $contentTypeId -Web $Web  }
		}
	}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Add-PnPFieldFromContentType End"
    }
}
function Use-AP_SPProvisioning_PnP_Remove-PnPFieldFromContentType
{
    [CmdletBinding()]
    param
    (
		$Web,
		$FieldName,
		$ContentType,
		$DoNotUpdateChildren
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPFieldFromContentType Begin" 
    }
    Process
    {
		if($ContentType -ne $null -and $FieldName -ne $null) 
		{
			if($DoNotUpdateChildren)
			{
				Remove-PnPFieldFromContentType -Field $FieldName -ContentType $ContentType -DoNotUpdateChildren
			}
			else
			{
				Remove-PnPFieldFromContentType -Field $FieldName -ContentType $ContentType
			}
		} 
		else 
		{
			Write-Error "[Use-AP_SPProvisioning_PnP_Remove-PnPFieldFromContentType] => Missing attributes. At least one of the attributes [ContentType or Field] must be passed" 
		} 
	}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPFieldFromContentType End"
    }
}
function Use-AP_SPProvisioning_PnP_Add-PnPContentTypeToList
{
    [CmdletBinding()]
    param
    (
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 0)]
			[ValidateNotNullOrEmpty()]
			$Web,
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 1)]
			[ValidateNotNullOrEmpty()]
			$List,
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 2)]
			[ValidateNotNullOrEmpty()]
			$ContentType,
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 3)]
			[ValidateNotNullOrEmpty()]
			[bool]$DefaultContentType
		)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Add-PnPContentType Begin" 
    }
    Process
    {
			if($DefaultContentType -eq $true) {
				Add-PnPContentTypeToList -List $List -ContentTyp $ContentType -Web $Web -DefaultContentType 
			} 
			else {
				Add-PnPContentTypeToList -List $List -ContentTyp $ContentType -Web $Web
			}		
		}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Add-PnPContentType End"
    }
}
function Use-AP_SPProvisioning_PnP_Remove-PnPContentTypeFromList
{
    [CmdletBinding()]
    param
    (
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 0)]
			[ValidateNotNullOrEmpty()]
			$Web,
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 1)]
			[ValidateNotNullOrEmpty()]
			$List,
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position = 2)]
			[ValidateNotNullOrEmpty()]
			$ContentType
		)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPContentTypeFromList Begin" 
    }
    Process
    {
				Remove-PnPContentTypeFromList -List $List -ContentType $ContentType -Web $Web
		}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Remove-PnPContentTypeFromList End"
    }
}

###### Provisioning #######
function Use-AP_SPProvisioning_PnP_Apply-PnPProvisioningTemplate
{
    [CmdletBinding()]
    param
    (
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		$Web,
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
		$Path
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Apply-PnPProvisioningTemplate Begin" 
    }
    Process
    {
        Apply-PnPProvisioningTemplate -Path $Path -Web $Web
	}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Apply-PnPProvisioningTemplate End"
    }
}
function Use-AP_SPProvisioning_PnP_Get-PnPProvisioningTemplate
{
    [CmdletBinding()]
    param
    (
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		$Web,
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
		$Out,
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
		[bool]$standard,
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)]
		$handlers
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPProvisioningTemplate Begin" 
    }
    Process
    {
		if($standard -eq $true) 
		{
			Get-PnPProvisioningTemplate -Out $Out -Web $web -Handlers Navigation, Fields, ContentTypes, Lists, CustomActions, Files
		} 
		else 
		{
			if($handlers -eq "" ) {
				Get-PnPProvisioningTemplate -Out $Out -Web $Web
			}
			else {
				Get-PnPProvisioningTemplate -Out $Out -Web $Web -Handlers $handlers
			}
		}		
	}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Get-PnPProvisioningTemplate End"
    }
}

###### Web Parts #######
function Use-AP_SPProvisioning_PnP_Get-PnPWebPart
{
	[CmdletBinding()]
    param
    (
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		$Web,
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
		$Path
	)
    Begin
    {
         Write-Verbose "Use-AP_SPProvisioning_PnP_Apply-PnPProvisioningTemplate Begin" 
    }
    Process
    {
		Apply-PnPProvisioningTemplate -Path $Path -Web $Web -Parameters @{ "newWebId"=$Web.Id ;"newSourceId"=$Web.id }
	}
    End
    {
		Write-Verbose "Use-AP_SPProvisioning_PnP_Apply-PnPProvisioningTemplate End"
    }
}



