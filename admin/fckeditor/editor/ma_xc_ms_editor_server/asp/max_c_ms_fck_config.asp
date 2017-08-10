<!--#include file="../../../../admin_inc.asp"-->

<%
' SECURITY: You must explicitly enable this "connector" (set it to "True").
' WARNING: don't just set "ConfigIsEnabled = true", you must be sure that only
'		authenticated users can access this file or use some kind of session checking.
Dim ConfigIsEnabled
ConfigIsEnabled = true

' Path to user files relative to the document root.
' This setting is preserved only for backward compatibility.
' You should look at the settings for each resource type to get the full potential
Dim ConfigUserFilesPath
ConfigUserFilesPath = "/"&sitePath&"pic/fckimg/"

' Due to security issues with Apache modules, it is recommended to leave the
' following setting enabled.
Dim ConfigForceSingleExtension
ConfigForceSingleExtension = true

' What the user can do with this connector
Dim ConfigAllowedCommands
ConfigAllowedCommands = "QuickUpload|FileUpload|GetFolders|GetFoldersAndFiles|CreateFolder"

' Allowed Resource Types
Dim ConfigAllowedTypes
ConfigAllowedTypes = "File|Image|Flash|Media"

' For security, HTML is allowed in the first Kb of data for files having the
' following extensions only.
Dim ConfigHtmlExtensions
ConfigHtmlExtensions = "html|htm|xml|xsd|txt|js"
'
'	Configuration settings for each Resource Type
'
'	- AllowedExtensions: the possible extensions that can be allowed.
'		If it is empty then any file type can be uploaded.
'
'	- DeniedExtensions: The extensions that won't be allowed.
'		If it is empty then no restrictions are done here.
'
'	For a file to be uploaded it has to fulfill both the AllowedExtensions
'	and DeniedExtensions (that's it: not being denied) conditions.
'
'	- FileTypesPath: the virtual folder relative to the document root where
'		these resources will be located.
'		Attention: It must start and end with a slash: '/'
'
'	- FileTypesAbsolutePath: the physical path to the above folder. It must be
'		an absolute path.
'		If it's an empty string then it will be autocalculated.
'		Useful if you are using a virtual directory, symbolic link or alias.
'		Examples: 'C:\\MySite\\userfiles\\' or '/root/mysite/userfiles/'.
'		Attention: The above 'FileTypesPath' must point to the same directory.
'		Attention: It must end with a slash: '/'
'
' - QuickUploadPath: the virtual folder relative to the document root where
'		these resources will be uploaded using the Upload tab in the resources
'		dialogs.
'		Attention: It must start and end with a slash: '/'
'
'	 - QuickUploadAbsolutePath: the physical path to the above folder. It must be
'		an absolute path.
'		If it's an empty string then it will be autocalculated.
'		Useful if you are using a virtual directory, symbolic link or alias.
'		Examples: 'C:\\MySite\\userfiles\\' or '/root/mysite/userfiles/'.
'		Attention: The above 'QuickUploadPath' must point to the same directory.
'		Attention: It must end with a slash: '/'
'

Dim ConfigAllowedExtensions, ConfigDeniedExtensions, ConfigFileTypesPath, ConfigFileTypesAbsolutePath, ConfigQuickUploadPath, ConfigQuickUploadAbsolutePath
Set ConfigAllowedExtensions	= CreateObject( "Scripting.Dictionary" )
Set ConfigDeniedExtensions	= CreateObject( "Scripting.Dictionary" )
Set ConfigFileTypesPath	= CreateObject( "Scripting.Dictionary" )
Set ConfigFileTypesAbsolutePath	= CreateObject( "Scripting.Dictionary" )
Set ConfigQuickUploadPath	= CreateObject( "Scripting.Dictionary" )
Set ConfigQuickUploadAbsolutePath	= CreateObject( "Scripting.Dictionary" )

ConfigAllowedExtensions.Add	"File", "7z|aiff|asf|avi|bmp|csv|doc|fla|flv|gif|gz|gzip|jpeg|jpg|mid|mov|mp3|mp4|mpc|mpeg|mpg|ods|odt|pdf|png|ppt|pxd|qt|ram|rar|rm|rmi|rmvb|rtf|sdc|sitd|swf|sxc|sxw|tar|tgz|tif|tiff|txt|vsd|wav|wma|wmv|xls|xml|zip"
ConfigDeniedExtensions.Add	"File", ""
ConfigFileTypesPath.Add "File", ConfigUserFilesPath & "file/"
ConfigFileTypesAbsolutePath.Add "File", ""
ConfigQuickUploadPath.Add "File", ConfigUserFilesPath
ConfigQuickUploadAbsolutePath.Add "File", ""

ConfigAllowedExtensions.Add	"Image", "bmp|gif|jpeg|jpg|png"
ConfigDeniedExtensions.Add	"Image", ""
ConfigFileTypesPath.Add "Image", ConfigUserFilesPath & "image/"
ConfigFileTypesAbsolutePath.Add "Image", ""
ConfigQuickUploadPath.Add "Image", ConfigUserFilesPath
ConfigQuickUploadAbsolutePath.Add "Image", ""

ConfigAllowedExtensions.Add	"Flash", "swf|flv"
ConfigDeniedExtensions.Add	"Flash", ""
ConfigFileTypesPath.Add "Flash", ConfigUserFilesPath & "flash/"
ConfigFileTypesAbsolutePath.Add "Flash", ""
ConfigQuickUploadPath.Add "Flash", ConfigUserFilesPath
ConfigQuickUploadAbsolutePath.Add "Flash", ""

ConfigAllowedExtensions.Add	"Media", "aiff|asf|avi|bmp|fla|flv|gif|jpeg|jpg|mid|mov|mp3|mp4|mpc|mpeg|mpg|png|qt|ram|rm|rmi|rmvb|swf|tif|tiff|wav|wma|wmv"
ConfigDeniedExtensions.Add	"Media", ""
ConfigFileTypesPath.Add "Media", ConfigUserFilesPath & "media/"
ConfigFileTypesAbsolutePath.Add "Media", ""
ConfigQuickUploadPath.Add "Media", ConfigUserFilesPath
ConfigQuickUploadAbsolutePath.Add "Media", ""


Sub checkPower2
	dim loginValidate,rsObj : loginValidate = "maxcms"
	err.clear
	'on error resume next
	set rsObj=conn.db("select m_random,m_level from {pre}manager where m_username='"&replaceStr(rCookie("m_username"),"'","")&"'","execute")
	loginValidate = md5(getAgent&getIp&rsObj(0),32)
	if err then wCookie "check"&rCookie("m_username"),"" : die "<script>top.location.href='../../../../index.asp?action=login';</script>"
	if rCookie("check"&rCookie("m_username"))<>loginValidate then wCookie "check"&rCookie("m_username"),"" : die "<script>top.location.href='../../../../index.asp?action=login';</script>"
	checkManagerLevel  rsObj(1)
	set rsObj=nothing
End Sub
checkPower2
%>