
<!--#include file="max_c_ms_fck_config.asp"-->
<!--#include file="m_ax_cms_util.asp"-->
<!--#include file="m_ax_cms_io.asp"-->
<!--#include file="m_a_x_cms_commands.asp"-->
<!--#include file="ma_xcms_uploadclass.asp"-->
<%

Sub SendError( number, text )
	SendUploadResults number, "", "", text
End Sub

' Check if this uploader has been enabled.
If ( ConfigIsEnabled = False ) Then
	SendUploadResults "1", "", "", "This file uploader is disabled. Please check the ""ma_xc_ms_editor_server/asp/max_c_ms_fck_config.asp"" file"
End If

	Dim sCommand, sResourceType, sCurrentFolder

	sCommand = "QuickUpload"

	sResourceType = Request.QueryString("Type")
	If ( sResourceType = "" ) Then sResourceType = "File"

	sCurrentFolder = GetCurrentFolder()

	' Is Upload enabled?
	if ( Not IsAllowedCommand( sCommand ) ) then
		SendUploadResults "1", "", "", "The """ & sCommand & """ command isn't allowed"
	end if

	' Check if it is an allowed resource type.
	if ( Not IsAllowedType( sResourceType ) ) Then
		SendUploadResults "1", "", "", "The " & sResourceType & " resource type isn't allowed"
	end if

	FileUpload sResourceType, sCurrentFolder, sCommand

%>
