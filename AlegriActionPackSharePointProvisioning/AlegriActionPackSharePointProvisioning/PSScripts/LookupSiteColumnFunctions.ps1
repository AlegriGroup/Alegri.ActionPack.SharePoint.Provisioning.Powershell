#
# SiteColumnFunctions.ps1
#

function Start-AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning
{
	<#
	.Synopsis
	Start AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning
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
		Write-Verbose "Start Start-AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning"
    }
    Process
    {	
		$pathXML = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath -path $xmlActionObject.pathToProvisioningXML
		Clear-AP_SPProvisioning_LookupSiteColumnAfterProvisioning -pathToProvisioningXML $pathXML
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning"
    }
}

function Start-AP_SPProvisioning_ClearLookupSiteColumnOnContentType
{
	<#
	.Synopsis
	Start AP_SPProvisioning_ClearLookupSiteColumnOnContentType
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_ClearLookupSiteColumnOnContentType
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
		Write-Verbose "Start Start-AP_SPProvisioning_ClearLookupSiteColumnOnContentType"
    }
    Process
    {	
		$contentType_name = $xmlActionObject.ContentTypeName
		$field_name = $xmlActionObject.FieldName
		$list_name = $xmlActionObject.ListName
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		$contentTypeAsObject = Use-AP_SPProvisioning_PnP_Get-PnPContentType -Web $currentWeb.Web -Identity $contentType_name
		$fieldAsObject = Use-AP_SPProvisioning_PnP_Get-PnPField -Web $currentWeb.Web -Identity $field_name
		$listAsObject = Use-AP_SPProvisioning_PnP_Get-PnPList -Web $currentWeb.Web -Identity $list_name


		if($contentTypeAsObject -ne $null -and $listAsObject -ne $null -and $fieldAsObject -ne $null)
		{
			Clear-AP_SPProvisioning_LookupSiteColumnOnContentType -contentTypeToFind $contentTypeAsObject -field $fieldAsObject -listid $listAsObject.Id -webid $currentWeb.Web.Id
		}
		else
		{
			if($contentTypeAsObject -eq $null) { Write-Host "ContentType $($contentType_name) are not Found" -BackgroundColor Red }
			if($listAsObject -eq $null) { Write-Host "List $($list_name) are not Found" -BackgroundColor Red }
			if($fieldAsObject -eq $null) { Write-Host "Field $($field_name) are not Found" -BackgroundColor Red }
		}		
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_ClearLookupSiteColumnOnContentType"
    }
}

function Start-AP_SPProvisioning_ClearLookupSiteColumnOnList
{
	<#
	.Synopsis
	Start AP_SPProvisioning_ClearLookupSiteColumnOnList
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_ClearLookupSiteColumnOnList
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
		Write-Verbose "Start Start-AP_SPProvisioning_ClearLookupSiteColumnOnList"
    }
    Process
    {	
		$listNameFromField = $xmlActionObject.ListNameFromField
		$field_name = $xmlActionObject.FieldName
		$list_name = $xmlActionObject.ListName
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		$listFromFieldAsObject = Use-AP_SPProvisioning_PnP_Get-PnPList -Web $currentWeb.Web -Identity $listNameFromField
		$fieldAsObject = Use-AP_SPProvisioning_PnP_Get-PnPField -Web $currentWeb.Web -Identity $field_name
		$listAsObject = Use-AP_SPProvisioning_PnP_Get-PnPList -Web $currentWeb.Web -Identity $list_name

		if($listFromFieldAsObject -ne $null -and $listAsObject -ne $null -and $fieldAsObject -ne $null)
		{
			Clear-AP_SPProvisioning_LookupSiteColumnOnList -listToFind $listFromFieldAsObject -field $fieldAsObject -listid $listAsObject.Id -Web $currentWeb.Web
		}
		else
		{
			if($listFromFieldAsObject -eq $null) { Write-Host "List $($listNameFromField) are not Found" -BackgroundColor Red }
			if($listAsObject -eq $null) { Write-Host "List $($list_name) are not Found" -BackgroundColor Red }
			if($fieldAsObject -eq $null) { Write-Host "Field $($field_name) are not Found" -BackgroundColor Red }
		}
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_ClearLookupSiteColumnOnList"
    }
}

function Start-AP_SPProvisioning_ClearLookupSiteColumn
{
	<#
	.Synopsis
	Start AP_SPProvisioning_ClearLookupSiteColumn
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_ClearLookupSiteColumn
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
		Write-Verbose "Start Start-AP_SPProvisioning_ClearLookupSiteColumn"
    }
    Process
    {	
		$field_name = $xmlActionObject.FieldName
		$list_name = $xmlActionObject.ListName
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		$fieldAsObject = Use-AP_SPProvisioning_PnP_Get-PnPField -Web $currentWeb.Web -Identity $field_name
		$listAsObject = Use-AP_SPProvisioning_PnP_Get-PnPList -Web $currentWeb.Web -Identity $list_name

		if($listAsObject -ne $null -and $fieldAsObject -ne $null)
		{
			Rename-AP_SPProvisioning_SchemaXML_Field -Field $fieldAsObject -List_Value $listAsObject.Id -WebID_Value $currentWeb.Web.Id
		}
		else
		{
			if($listAsObject -eq $null) { Write-Host "List $($list_name) are not Found" -BackgroundColor Red }
			if($fieldAsObject -eq $null) { Write-Host "Field $($field_name) are not Found" -BackgroundColor Red }
		}

    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_ClearLookupSiteColumn"
    }
}

function Clear-AP_SPProvisioning_LookupSiteColumnAfterProvisioning()
{
	<# 
	.SYNOPSIS
	Clean up the reference of the LookUpSiteColumn of the provisioning
    Bereinige die Referenz der LookUpSiteColumn der Provisionierung	
    .DESCRIPTION
	In the case of provisioning, for example, SiteColumn of type Lookup, Although the list itself is not present. This causes the SiteColumn to fail.
	This function fixes the problem and cleans the references of the lookup column in the SiteColumn, SiteContentType and List as ListContentType and ListContentTypeSiteColumn
    Bei der Provisionierung kann es vorkommen das z.B. SiteColumn vom Typ Lookup angelegt werden, obwohl die List selbst nicht vorhanden ist. Dadurch ist die SiteColumn Fehlerhaft.
	Diese Funktion behebt das Problem und Bereinigt die Referenzen des Lookupspalte in dem SiteColumn, SiteContentType und List wie ListContentType und ListContentTypeSiteColumn
    .PARAMETER pathToProvisioningXML
	Path to provisioning XML
    Pfad zur Provisionierungs XML 	
	#>
	Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
        [string]$pathToProvisioningXML
    )
	begin
	{
		Write-Verbose "Clear-AP_SPProvisioning_LookupSiteColumnAfterProvisioning begin"
	}
    Process
    {
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		[xml]$wpXml = Get-Content "$($pathToProvisioningXML)" -Encoding String
		$XMLSiteColumns = $wpXml.Provisioning.Templates.ProvisioningTemplate.SiteFields.Field | Where-Object { $_.Type -like "Lookup*"}

		$fields = Use-AP_SPProvisioning_PnP_Get-PnPField -Web $currentWeb.Web
		$contentTypes = Use-AP_SPProvisioning_PnP_Get-PnPContentType -Web $currentWeb.Web
		$lists = Use-AP_SPProvisioning_PnP_Get-PnPList -Web $currentWeb.Web

		foreach($xmlSiteColumn in $XMLSiteColumns)
		{
			Write-Host "Check Lookup $($XMLSiteColumn.Name)" -BackgroundColor Green
		
			$listName = $xmlSiteColumn.List

			if($listName -like "{{*")
			{
				$listName = $listName.Split(":")
				$listName = $listName[1].Replace("}}","")
			}

			$currList = Use-AP_SPProvisioning_PnP_Get-PnPList -Web $currentWeb.Web -Identity $listName
        
			if($currList){
            
				$listid = $currList.Id 
				$field = $fields | Where-Object { $_.InternalName -eq $XMLSiteColumn.Name }
				if($field)
				{
					Write-Host "START RenameXML SiteColumn" 
						
					Rename-AP_SPProvisioning_SchemaXML_Field -Field $field -List_Value $listid -WebId_Value $currentWeb.Web.Id
						
					Write-Host "END RenameXML SiteColumn"
                
					Write-Host "START RenameXML SiteContentTypes"

						$xmlContentTypes = $wpXml.Provisioning.Templates.ProvisioningTemplate.ContentTypes

						foreach($contentType in $xmlContentTypes.ContentType)
						{
							Write-Host "Check CT $($contentType.Name)"         
							$contentTypeToFind = $contentTypes | Where-Object { $_.Id -like $contentType.ID}
                    
							if($contentTypeToFind) {
								Clear-AP_SPProvisioning_LookupSiteColumnOnContentType -contentTypeToFind $contentTypeToFind -field $field -listid $listid -webid $currentWeb.Web.Id										 
							} else {
								Write-Host "ContentType $($contentType.Name) not founded" -BackgroundColor Red
							}
						}

					Write-Host "END RenameXML SiteContentTypes"

					Write-Host "START RenameXML Iterate All Lists"

						$xmlLists = $wpXml.Provisioning.Templates.ProvisioningTemplate.Lists
                                    
						foreach($list in $xmlLists.ListInstance)
						{
							Write-Host "Check List $($list.Title)" -BackgroundColor Green
							$listToFind = $lists | Where-Object {$_.Title -eq $list.Title }
                    
							if($listToFind) {
								Clear-AP_SPProvisioning_LookupSiteColumnOnList -listToFind $listToFind -field $field -listid $listid -Web $currentWeb.Web  
							} else {
								Write-Host "List $($list.Title) not founded" -BackgroundColor Red
							}
						}

					Write-Host "END RenameXML Iterate All Lists"
				}
				else {
					Write-Host "Field $($XMLSiteColumn.Name) are not founded" -BackgroundColor Red 
				}
			}
			else
			{
				Write-Host "Liste $listName from Column $($XMLSiteColumn.Name) are not founded" -BackgroundColor Red
			}
		}
		Write-Host "Successfully Clear Lookup Site Column"
		Write-Host ""
	}
	end
	{
		Write-Verbose "Clear-AP_SPProvisioning_LookupSiteColumnAfterProvisioning end"
	}
}

function Clear-AP_SPProvisioning_LookupSiteColumnOnContentType
{
	<# 
	.SYNOPSIS
	Clean the reference of the LookUpSiteColumn within the ContentType
    Bereinige die Referenz der LookUpSiteColumn innerhalb des ContentTypes	
    .DESCRIPTION
	The column in the content type is fetched and the schema XML of the column is adjusted
    Es wird die Spalte im Inhaltstyp geholt und das Schema XML der Spalte wird angepasst
    .PARAMETER contentTypeToFind
	The ContentType where the column is contained
	Der ContentType wo die Spalte enthalten ist
	.PARAMETER field
	The lookup column to be customized
	Die Lookup Spalte die angepasst werden soll
	.PARAMETER listid 
	The List ID for the schema
	Die List ID für das Schema
	.PARAMETER webid 
	The Web ID for the schema  	
	Die Web ID für das Schema
	#>
	Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
        $contentTypeToFind,
		$field,
		$listid,
		$webid
    )
	begin
	{
		Write-Verbose "Clear-AP_SPProvisioning_LookupSiteColumnOnContentType begin"
	}
    Process
    {
		$ctFields = $contentTypeToFind.Fields
		$contentTypeToFind.Context.Load($ctFields)
		$contentTypeToFind.Context.ExecuteQuery()

		$checkField = $ctFields | Where-Object {$_.Id -eq $field.Id}

		if($checkField)
		{
			Rename-AP_SPProvisioning_SchemaXML_Field -Field $checkField -List_Value $listid -WebId_Value $webid
			Write-Host "Rename SchemaXML from Field $($checkField.Title) on ContentType $($contentType.Name)" -BackgroundColor Green
		}
	}
	end
	{
		Write-Verbose "Clear-AP_SPProvisioning_LookupSiteColumnOnContentType end"
	}
}

function Clear-AP_SPProvisioning_LookupSiteColumnOnList
{
	<# 
	.SYNOPSIS
	Clean the reference of the LookUpSiteColumn within the list
    Bereinige die Referenz der LookUpSiteColumn innerhalb der Liste	
    .DESCRIPTION
	The column of the list is loaded and then the schema XML is adapted
    Es wird die Spalte der Liste geladen und danach das Schema XML angepasst
    .PARAMETER listToFind
	The list containing the column
	Die Liste die die Spalte enthält
	.PARAMETER field
	The lookup column to be customized
	Die Lookup Spalte die angepasst werden soll
	.PARAMETER listid 
	The List ID for the schema
	Die List ID für das Schema
	.PARAMETER Web 
	The Current Web  	
	Das aktuelle Web
	#>
	Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
        $listToFind,
		$field,
		$listid,
		$Web
    )
	begin
	{
		Write-Verbose "Clear-AP_SPProvisioning_LookupSiteColumnOnList begin"
	}
    Process
    {
		$checkField = Use-AP_SPProvisioning_PnP_Get-PnPField -Web $Web -List $listToFind -Identity $field.Title
                
		if($checkField -ne $null)
		{
			Rename-AP_SPProvisioning_SchemaXML_Field -Field $checkField -List_Value $listid -WebId_Value $Web.Id
			Write-Host "Rename SchemaXML from Field $($checkField.Title) on List $($listToFind.Title)" -BackgroundColor Green
		} 
	}
	end
	{
		Write-Verbose "Clear-AP_SPProvisioning_LookupSiteColumnOnList end"
	}
}

function Rename-AP_SPProvisioning_SchemaXML_Field
{
    <#
    .SYNOPSIS
	Adapt the Schema XML
    Anpassung der Schema XML
    .DESCRIPTION
	The XML schema is adapted and set from the column.
    Aus der Spalte wird das Schema XML angepasst und neu gesetzt.
    .PARAMETER Field 
	The column where the schema XML should be adjusted
    Die Spalte wo das Schema XML angepasst werden soll 
	.PARAMETER WebID_Value
	The Web ID for the schema  	
	Die Web ID für das Schema
	.PARAMETER List_Value
	The List ID for the schema
	Die List ID für das Schema
    #>
    [CmdletBinding()]
    param
    ( 
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
        [Microsoft.SharePoint.Client.Field]$Field,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)]
		[string]$WebID_Value,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=2)]		
        [string]$List_Value

    )
    begin
    {
        Write-Verbose "Rename-AP_SPProvisioning_SchemaXML_Field begin"
    }
    process
    {
        $fieldTitle = $field.Title;
        $fieldSchema = $Field.SchemaXml;

        [XML]$xml = New-Object "System.Xml.XmlDocument"
        $xml.LoadXml($fieldSchema)

        $List_Value = "{" + $List_Value + "}";

        if($WebID_Value) { $xml.Field.WebID = $WebID_Value }
        if($List_Value) {
         if($xml.Field.List) {
            $xml.Field.List = $List_Value
         } else {
            $xml.Field.SetAttribute("List",$List_Value);
         }  
        }

        $fieldSchema = $xml.InnerXml

        $Field.SchemaXml = $fieldSchema;
        $Field.Update()
        $Field.Context.ExecuteQuery()

        Write-Host "Schema vom $fieldTitle geändert" -ForegroundColor Green
    }
    end
    {
        Write-Verbose "Rename-AP_SPProvisioning_SchemaXML_Field end"
    }    
}