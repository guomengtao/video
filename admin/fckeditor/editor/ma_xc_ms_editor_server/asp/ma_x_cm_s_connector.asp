
<!--#include file="max_c_ms_fck_config.asp"-->
<!--#include file="m_ax_cms_util.asp"-->
<!--#include file="m_ax_cms_io.asp"-->
<!--#include file="ma_xc_ms_basexml.asp"-->
<!--#include file="m_a_x_cms_commands.asp"-->
<!--#include file="ma_xcms_uploadclass.asp"-->
<%

If ( ConfigIsEnabled = False ) Then
	SendError 1, "This connector is disabled. Please check the ""ma_xc_ms_editor_server/asp/max_c_ms_fck_config.asp"" file"
End If

DoResponse

Sub DoResponse()
	Dim sCommand, sResourceType, sCurrentFolder

	' Get the main request information.
	sCommand = Request.QueryString("Command")

	sResourceType = Request.QueryString("Type")
	If ( sResourceType = "" ) Then sResourceType = "File"

	sCurrentFolder = GetCurrentFolder()

	' Check if it is an allowed command
	if ( Not IsAllowedCommand( sCommand ) ) then
		SendError 1, "The """ & sCommand & """ command isn't allowed"
	end if

	' Check if it is an allowed resource type.
	if ( Not IsAllowedType( sResourceType ) ) Then
		SendError 1, "The """ & sResourceType & """ resource type isn't allowed"
	end if

	' File Upload doesn't have to Return XML, so it must be intercepted before anything.
	If ( sCommand = "FileUpload" ) Then
		FileUpload sResourceType, sCurrentFolder, sCommand
		Exit Sub
	End If

	SetXmlHeaders

	CreateXmlHeader sCommand, sResourceType, sCurrentFolder, GetUrlFromPath( sResourceType, sCurrentFolder, sCommand)

	' Execute the required command.
	Select Case sCommand
		Case "GetFolders"
			GetFolders sResourceType, sCurrentFolder
		Case "GetFoldersAndFiles"
			GetFoldersAndFiles sResourceType, sCurrentFolder
		Case "CreateFolder"
			CreateFolder sResourceType, sCurrentFolder
	End Select

	CreateXmlFooter

	Response.End
End Sub

%>
