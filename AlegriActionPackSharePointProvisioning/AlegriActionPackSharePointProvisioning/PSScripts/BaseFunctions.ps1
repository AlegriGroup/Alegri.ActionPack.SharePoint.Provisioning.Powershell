#
# BaseFunctions.ps1
#
function Start-AP_SPProvisioning_DebugModus
{
	[CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
	)
    Begin
    {
		Write-Verbose "Start Start-AP_SPProvisioning_DebugModus"
    }
    Process
    {	
		if($xmlActionObject.Modus -eq "true")
		{
			Use-AP_SPProvisioning_PnP_Set-PnPTraceLog -modus $true
		}
		else 
		{
			Use-AP_SPProvisioning_PnP_Set-PnPTraceLog -modus $false
		}		
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_DebugModus"
    }
}
