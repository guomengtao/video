<%
'******************************************************************************************
' Software name: Max(����˹) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ����
' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
'******************************************************************************************
Sub alertMsg(str,url)
	dim urlstr 
	if url<>"" then urlstr="location.href='"&url&"';"
	if not isNul(str) then str ="alert('"&str&"');"
	echo("<script>"&str&urlstr&"</script>")
End Sub

Sub echoMsgAndGo(str,timenum,bhome)
	echo str&", <font color=""red"">"&timenum&"</font> ����Զ�����...<script language=""javascript"">setTimeout(""goLastPage()"","&timenum*1000&");function goLastPage(){history.go(-1);}</script>"
	if bhome then echo "&nbsp;&nbsp;<a href='/' target='_self'>������վ��ҳ</a>"&" Powered By "&siteName
End Sub

Sub selectMsg(str,url1,url2)
	echo("<script>if(confirm('"&str&"')){location.href='"&url1&"'}else{location.href='"&url2&"'}</script>") 
End Sub

Sub last
	die "<script>history.go(-1)</script>"
End Sub

Sub echo(str)
	response.write(str)
	response.Flush()
End Sub

Sub die(str)
	if not isNul(str) then
		echo str
	end if	 
	response.End()
End Sub

Sub echoErr(byval str,byval id, byval des)
	dim errstr,cssstr
	cssstr="<style>body{text-align:center}#msg{background-color:white;border:1px solid #1B76B7;margin:0 auto;width:400px;text-align:left}.msgtitle{padding:3px 3px;color:white;font-weight:700;line-height:21px;height:25px;font-size:12px;border-bottom:1px solid #1B76B7; text-indent:3px; background-color:#1B76B7}#msgbody{font-size:12px;padding:40px 8px 50px;line-height:25px}#msgbottom{text-align:center;height:20px;line-height:20px;font-size:12px;background-color:#1b76b7;color:#FFFFFF}</style>"
	errstr=cssstr&"<div id='msg'><div class='msgtitle'>��ʾ��***��"&str&"��***</div><div id='msgbody'>����ţ�<b>"&id&"</b><br>����������<b>"&des&"</b></div><div id='msgbottom'>Powered By "&siteName&"</div></div>" 
	cssstr=""
	die(errstr)
End Sub

Sub setStartTime()
	starttime=timer()
End Sub

Sub echoRunTime()
	endtime=timer()      
	echo pageRunStr(0)&FormatNumber((endtime-starttime),4,-1)&pageRunStr(1)&conn.queryCount&pageRunStr(2)
End Sub

dim span:span=""
Sub makeTypeOption(topId,separateStr)
	Dim i,j,k,m,t,TL:TL=getTypeLists():j=getTypeindex("m_id"):k=getTypeindex("m_upid"):m=getTypeindex("m_name"):topId=Clng(topId)
	for i=0 to UBound(TL,2)
		if Clng(TL(k,i))=topId then
			if topId<>0 then span=span&separateStr
			echo "<option value='"&TL(j,i)&"'>"&span&"&nbsp;|��"&TL(m,i)&"</option>"
			makeTypeOption TL(j,i),separateStr
		end if
	next
	if not isNul(span) then span=left(span,len(span)-len(separateStr))
End Sub

Sub makeNewsTypeOption(topId,separateStr)
	Dim i,j,k,m,t,TL:TL=getNewsTypeLists():j=getTypeindex("m_id"):k=getTypeindex("m_upid"):m=getTypeindex("m_name"):topId=Clng(topId)
	for i=0 to UBound(TL,2)
		if Clng(TL(k,i))=topId then
			if topId<>0 then span=span&separateStr
			echo "<option value='"&TL(j,i)&"'>"&span&"&nbsp;|��"&TL(m,i)&"</option>"
			makeNewsTypeOption TL(j,i),separateStr
		end if
	next
	if not isNul(span) then span=left(span,len(span)-len(separateStr))
End Sub

Sub makeTypeSelect(selectName)
	echo "<select name='"&selectName&"'>"
	echo "<option value=''>��ѡ����Ƶ����</option>"
	makeTypeOption 0,"&nbsp;|&nbsp;&nbsp;"
	echo "</select>"
End Sub

Sub makeNewsTypeSelect(selectName)
	echo "<select name='"&selectName&"'>"
	echo "<option value=''>��ѡ�����·���</option>"
	makeNewsTypeOption 0,"&nbsp;|&nbsp;&nbsp;"
	echo "</select>"
End Sub

Sub echoSaveStr(ptype)
	dim cssstr
	cssstr="<style>body{text-align:center}#msg{background-color:white;border:1px solid #1B76B7;margin:0 auto;width:400px;text-align:left}.msgtitle{padding:3px 3px;color:white;font-weight:700;line-height:21px;height:25px;font-size:12px;border-bottom:1px solid #1B76B7; text-indent:3px; background-color:#1B76B7}#msgbody{font-size:12px;padding:40px 8px 50px;line-height:25px}#msgbottom{text-align:center;height:20px;line-height:20px;font-size:12px;background-color:#1b76b7;color:#FFFFFF}</style>"
	select case ptype
		case "safe"
			die cssstr&"<div id='msg'><div class='msgtitle'>�����桿�Ƿ��ύ��</div><div id='msgbody'>���ύ�������зǷ��ַ������IP��<b>"&getIp&"</b>���ѱ���¼,����ʱ��:"&now()&"</div><div id='msgbottom'>Powered By "&siteName&"</div></div>" 
		case "null"
			die cssstr&"<div id='msg'><div class='msgtitle'>�����桿��������</div><div id='msgbody'><b>��������</b>������Ϊ�ջ���ȷ</div><div id='msgbottom'>Powered By "&siteName&"</div></div>"
	end Select
	cssstr=""
End Sub

Sub writeFontWaterPrint(saveImgPath,location)
	dim jpegObj,strWidth,strHeight,picPath:strWidth=len(waterMarkFont)*8:strHeight=3 
	on error resume next
	set jpegObj=Server.CreateObject(JPEG_OBJ_NAME)
	picPath=Server.MapPath(saveImgPath)
	with jpegObj
		.Interpolation=2:.Open picPath:.Canvas.Font.BkMode=true:.Canvas.Font.BkColor=&HFF3300:.Canvas.Font.Color=&Hffffff:.Canvas.Font.Family="Tahoma":.Canvas.Font.Size=14:.Canvas.Font.Bold=true
		select case location
			case "1":jpegObj.Canvas.Print 5 , strHeight, waterMarkFont
			case "2":jpegObj.Canvas.Print (jpegObj.width-strWidth) / 2, strHeight, waterMarkFont
			case "3":jpegObj.Canvas.Print jpegObj.width-strWidth-5, strHeight, waterMarkFont
			case "4":jpegObj.Canvas.Print 5 , (jpegObj.height-strHeight)/2, waterMarkFont
			case "5":jpegObj.Canvas.Print (jpegObj.width-strWidth) / 2, (jpegObj.height-strHeight)/2, waterMarkFont
			case "6":jpegObj.Canvas.Print jpegObj.width-strWidth-5, (jpegObj.height-strHeight)/2, waterMarkFont
			case "7":jpegObj.Canvas.Print 5 , jpegObj.height-20, waterMarkFont
			case "8":jpegObj.Canvas.Print (jpegObj.width-strWidth) / 2, jpegObj.height-20, waterMarkFont
			case else:jpegObj.Canvas.Print jpegObj.width-strWidth-5, jpegObj.height-20, waterMarkFont
		end select
		.Canvas.Pen.Color=&Heeeeee:.Canvas.Pen.Width=1:.Canvas.Brush.Solid=False:.Canvas.Bar 0, 0, jpegObj.Width, jpegObj.Height:.Save picPath
	end with
	set jpegObj=nothing:if err then err.clear
End Sub

Sub setSession(sessionName,sessionValue)
	session(sessionName)=sessionValue
End Sub

Sub parseLabelHaveLen(Byval str,Byval label)
	dim bLabel,eLabel,strBegin,strLen,regObj,match,matches,strByLen
	set regObj=New RegExp:regObj.ignoreCase=true:regObj.Global=true:regObj.Pattern="\{\w+:"&label&"\s+len=(\d+)?\s*\}"
	if regObj.Test(templateObj.content) then 
		set matches=regObj.Execute(templateObj.content)
		for each match in matches
			strLen=Clng(match.SubMatches(0))
			if label="actor" OR label="author" then strByLen=getKeywordsList(left(str,strLen),"&nbsp;&nbsp;") else strByLen=left(str,strLen)
			if label="des" OR label="outline" OR label="content" then strByLen=ReplaceStr(ReplaceStr(left(filterStr(codeTextarea(str,"en"),"html"),strLen),chr(10),""),chr(13),"")
			templateObj.content=replaceStr(templateObj.content,match.value,strByLen)
		next
		set matches =nothing:set regObj=nothing
	else 
		exit sub
	end if
	set regObj=nothing
End Sub

Sub tryDieCacheFile(ByVal Id,ByVal flag)
	if IsCacheSearch<>0 then
		Dim x:x=getCacheFile(Id,flag)
		if isExistFile(x) then
			dim stxt,ct:stxt=LoadFile(x)
			if Str2Num(getNumTime)-Str2Num(StrSlice(stxt,CBTag,CETag))<CacheSearchTime*60 then
				stxt=replaceStr(stxt,"{maxcms:runinfo}",getRunTime()):terminateAllObjects:die stxt
			else
				delFile x
			end if
		end if
	end if
End Sub

Sub WriteCacheFile(ByVal Id,ByVal flag,ByVal txt)
	if IsCacheSearch<>0 then CreateTextFile txt&CBTag&getNumTime&CETag,getCacheFile(Id,flag),""
End Sub

Sub OutNotFound(ByVal flag)
	response.Clear():if runMode="forgedStatic" or newsrunMode="forgedStatic" then response.Status="404 Not found"
	die loadFileOnCache("max404"&flag,"/"&sitepath&"max404.html")
End Sub

Sub wCookie(cookieName,cookieValue)
	response.cookies(cookieName)=cookieValue
End Sub

Sub wCookieInTime(cookieName,cookieValue,dateType,dateNum)
	Response.Cookies(cookieName).Expires=DateAdd(dateType,dateNum,now())
	response.cookies(cookieName)=cookieValue
End Sub

Function rCookie(cookieName)
	rCookie=request.cookies(cookieName)
End Function

Function isNul(str)
	if isnull(str) or str="" then isNul=true else isNul=false
End Function

Function isNum(str)
	if not isNul(str) then isNum=isnumeric(str) else isNum=false
End Function

Function isUrl(str)
	if not isNul(str) then
		if left(str,7)="http://" then isUrl=true else isUrl=false
	else
		isUrl=false
	end if
End Function

Function getFileFormat(str)
	dim ext:str=trim(""&str):ext=""
	if str<>"" then
		if instr(" "&str,"?")>0 then:str=mid(str,1,instr(str,"?")-1):end if
		if instrRev(str,".")>0 then:ext=mid(str,instrRev(str,".")):end if
	end if
	getFileFormat=ext
End Function

Function getForm(element,ftype)
	Select case ftype
		case "get"
			getForm=trim(request.QueryString(element))
		case "post"
			getForm=trim(request.Form(element))
		case "both"
			if isNul(request.QueryString(element)) then getForm=trim(request.Form(element)) else getForm=trim(request.QueryString(element))
	End Select
End Function

Function isInstallObj(objname)
	dim isInstall,obj
	On Error Resume Next
	set obj=server.CreateObject(objname)
	if Err then 
		isInstallObj=false:err.clear 
	else 
		isInstallObj=true:set obj=nothing
	end if
End Function

Function loadFile(ByVal filePath)
    dim errid,errdes
    On Error Resume Next
    With objStream
        .Type=2
        .Mode=3
        .Open
	.Charset="gbk"
        .LoadFromFile Server.MapPath(filePath)
        If Err Then  errid=err.number:errdes=err.description:Err.Clear:echoErr err_loadfile,errid,errdes
        .Position=0
        loadFile=.ReadText
        .Close
    End With
End Function

Function loadFileOnCache(Byval fileFlag,Byval filePath)
	dim cacheName
	cacheName=fileFlag&filePath
	if cacheStart=1 then
		if (cacheObj.chkCache(cacheName)) then  loadFileOnCache=cacheObj.getCache(cacheName) else loadFileOnCache=loadFile(filePath):cacheObj.setCache cacheName,loadFileOnCache
	else
		loadFileOnCache=loadFile(filePath)
	end if
End Function

Function getRunTime()
	endtime=timer()
	getRunTime=pageRunStr(0)&FormatNumber((endtime-starttime),4,-1)&pageRunStr(1)&conn.queryCount&pageRunStr(2)
End Function

Function getKeywordsList(key,span)
	dim keyWordsArray,i,keyWordsStr,keystr
	keystr=replaceStr(key,"��",",")
	if instr(keystr,",")>0 then keyWordsArray=split(keystr,",") else keyWordsArray=split(keystr," ")
	for i=0 to ubound(keyWordsArray)
		keyWordsStr=keyWordsStr&"<a href=""/"&sitePath&"search.asp?searchword="&server.URLEncode(keyWordsArray(i))&""">"&keyWordsArray(i)&"</a>"&span
	next
	getKeywordsList=keyWordsStr
End Function

Function getDataCount(countType)
	dim whereStr
	whereStr=" where year(m_addtime)="&Year(date)&" and month(m_addtime)="&month(date)&" and day(m_addtime)="&day(date)
	select case countType
		case "all"
			getDataCount=conn.db("select count(*) from {pre}data","execute")(0)
		case "day"
			getDataCount=conn.db("select count(*) from {pre}data "&whereStr,"execute")(0)
	end select	
End Function

Function replaceStr(Byval str,Byval finStr,Byval repStr)
	on error resume next
	if isNull(repStr) then repStr=""
	replaceStr=replace(str,finStr,repStr)
	if err then replaceStr="":err.clear
End Function

Function getArrayElementID(Byval parray,Byval itemid,Byval compareValue)
	dim i
	for i=0 to ubound(parray,2)
		if trim(parray(itemid,i))=trim(compareValue) then
			getArrayElementID=i
			Exit Function
		end if
	next
End Function

Function trimOuter(Byval str)
	dim vstr:vstr=str
	if left(vstr,1)=chr(32) then vstr=right(vstr,len(vstr)-1) 
	if right(vstr,1)=chr(32) then  vstr=left(vstr,len(vstr)-1)
	trimOuter=vstr
End Function

Function trimOuterStr(Byval str,Byval flag)
	dim vstr,m:vstr=str:m=len(flag)
	if left(vstr,m)=flag then vstr=right(vstr,len(vstr)-m) 
	if right(vstr,m)=flag then  vstr=left(vstr,len(vstr)-m)
	trimOuterStr=vstr
End Function

Function getPageSize(Byval str,Byval ptype)
	dim regObj,matchChannel,matchesChannel,sizeValue
	set regObj=New RegExp
	regObj.Pattern="\{maxcms:"&ptype&"list[\s\S]*size=([\d]+)[\s\S]*\}"	
	set matchesChannel=regObj.Execute(str)
	for each matchChannel in matchesChannel
		sizeValue=matchChannel.SubMatches(0):if isNul(sizeValue) then sizeValue=10
		set regObj=nothing
		set matchesChannel=nothing
		getPageSize=sizeValue
		Exit Function
	next
End Function

Function getPageSizeOnCache(Byval templatePath,Byval Flag,Byval Flag2)
		dim cacheName,pSize
		cacheName=Flag&"_pagesize_"&Flag2
		if cacheStart=1 then
			if cacheObj.chkCache(cacheName) then pSize=cacheObj.getCache(cacheName) else pSize=getPageSize(loadFile(templatePath),Flag):cacheObj.setCache cacheName,pSize
		else
			pSize=getPageSize(loadFile(templatePath),Flag)
		end if
		getPageSizeOnCache=pSize
End Function

Function filterStr(Byval str,Byval filtertype)
	if isNul(str) then  filterStr="":Exit Function
	dim regObj, outstr,rulestr:set regObj=New Regexp
	regObj.IgnoreCase=true:regObj.Global=true
	Select case filtertype
		case "html"	
			rulestr="(<[a-zA-Z!].*?>)|(<[\/][a-zA-Z].*?>)|(&\w+?;)"
		case "jsiframe"
			rulestr="(<(script|iframe).*?>)|(<[\/](script|iframe).*?>)"
	end Select
	regObj.Pattern=rulestr
	outstr=regObj.Replace(str, "")
	set regObj=Nothing:filterStr=outstr
End Function

Function getAgent()
	getAgent=request.ServerVariables("HTTP_USER_AGENT")
End Function

Function getRefer()
	Dim ref:ref=getForm("REFERER","both"):if isNul(ref) then:ref=Request.ServerVariables("HTTP_REFERER"):end if:getRefer=urlencode(ref)
End Function

Function getServername()
	getServername=request.ServerVariables("server_name")
End Function

Function isOutSubmit()
	dim server1, server2
	server1=getRefer
	server2=getServername
	if Mid(server1, 8, len(server2)) <> server2 then
		isOutSubmit=true
	else
		isOutSubmit=false
	end if
End Function

Function getIp()
	dim forwardFor
	forwardFor=request.servervariables("Http_X_Forwarded_For")
	if forwardFor="" then 
		getIp=request.servervariables("Remote_Addr") 
	else 
		getIp=forwardFor
	end if
	getIp=replace(getIp, chr(39), "")
	if isExistStr(getIp,",") then  getIp=getSubStrByFromAndEnd(getIp,"",",","end")
End Function

Function createTextFile(Byval content,Byval fileDir,Byval code)
	dim fileobj,fileCode:fileDir=replace(fileDir, "\", "/")
	if isNul(code) then fileCode="gbk" else fileCode=code
	call createfolder(fileDir,"filedir")
	on error resume next:err.clear
	set fileobj=objFso.CreateTextFile(server.mappath(fileDir),True)
	fileobj.Write(content)
	set fileobj=nothing
	if Err or not isNul(code) then
		err.clear 
		With objStream
			.Charset=fileCode:.Type=2:.Mode=3:.Open:.Position=0
			.WriteText content:.SaveToFile Server.MapPath(fileDir), 2
			.Close
		End With
	end if	
	if Err Then createTextFile=false:errid=err.number:errdes=err.description:Err.Clear:echoErr err_writefile,errid,errdes else createTextFile=true
End Function

Function createStreamFile(Byval stream,Byval fileDir)
	dim errid,errdes
	fileDir=replace(fileDir, "\", "/")
	call createfolder(fileDir,"filedir")
	on error resume next
	With objStream
		.Type =1
		.Mode=3  
		.Open
		.write stream
		.SaveToFile server.mappath(fileDir),2
		.close
	End With
	if Err Then  error.clear:createStreamFile=false else createStreamFile=true
End  Function

Function createFolder(Byval dir,Byval dirType)
	dim subPathArray,lenSubPathArray, pathDeep, i
	on error resume next
	dir=replace(dir, "\", "/")
	dir=replace(server.mappath(dir), server.mappath("/"), "")
	subPathArray=split(dir, "\")
	pathDeep=pathDeep&server.mappath("/")
	select case dirType
		case "filedir"
			 lenSubPathArray=ubound(subPathArray) - 1
		case "folderdir"
			lenSubPathArray=ubound(subPathArray)
	end select
	for i=1 to  lenSubPathArray
		pathDeep=pathDeep&"\"&subPathArray(i)
		if not objFso.FolderExists(pathDeep) then objFso.CreateFolder pathDeep
	next
	if Err Then createFolder=false:errid=err.number:errdes=err.description:Err.Clear:echoErr err_createFolder,errid,errdes else createFolder=true
End Function

Function isExistFile(Byval fileDir)
	on error resume next
	If (objFso.FileExists(server.MapPath(fileDir))) Then  isExistFile=True  Else  isExistFile=False
	if err then err.clear:isExistFile=False
End Function

Function isExistFolder(Byval folderDir)
	on error resume next
	If objFso.FolderExists(server.MapPath(folderDir)) Then  isExistFolder=True Else isExistFolder=False
	if err then err.clear:isExistFolder=False
End Function

Function delFolder(Byval folderDir)
	on error resume next
	If isExistFolder(folderDir)=True Then  
		objFso.DeleteFolder(server.mappath(folderDir)) 
		if Err Then delFolder=false:errid=err.number:errdes=err.description:Err.Clear:echoErr err_delFolder,errid,errdes else delFolder=true
	else
		delFolder=false:die(err_notExistFolder)
	end if
End Function

Function delFile(Byval fileDir)
	on error resume next
	If isExistFile(fileDir)=True Then objFso.DeleteFile(server.mappath(fileDir))
	if  Err Then delFile=false:errid=err.number:errdes=err.description:Err.Clear:echoErr err_delFile,errid,errdes else delFile=true
End Function

Function initializeAllObjects()
	dim errid,errdes
	on error resume next
	if not isobject(objFso) then set objFso=server.createobject(FSO_OBJ_NAME)
	If Err Then errid=err.number:errdes=err.description:Err.Clear:echoErr err_fsoobj,errid,errdes
	if not isobject(objStream) then Set objStream=Server.CreateObject(STREAM_OBJ_NAME)
	If Err Then errid=err.number:errdes=err.description:Err.Clear:echoErr err_stmobj,errid,errdes
End Function

Function terminateAllObjects()
	on error resume next
	if conn.isConnect then conn.close
	if isobject(conn) then:set conn=nothing
	if isobject(objFso) then set objFso=nothing
	if isobject(objStream) then set objStream=nothing
	if isobject(cacheObj) then set cacheObj=nothing
	if isobject(mainClassObj) then set mainClassObj=nothing
	if isObject(gXmlHttpObj) then SET gXmlHttpObj=Nothing
End Function

Function moveFolder(oldFolder,newFolder)
	dim voldFolder,vnewFolder
	voldFolder=oldFolder
	vnewFolder=newFolder
	on error resume next
	if voldFolder <> vnewFolder then
		voldFolder=server.mappath(oldFolder)
		vnewFolder=server.mappath(newFolder)
		if not objFso.FolderExists(vnewFolder) then createFolder newFolder,"folderdir" 
		if objFso.FolderExists(voldFolder) then objFso.CopyFolder voldFolder,vnewFolder:objFso.DeleteFolder(voldFolder)
		if Err Then moveFolder=false:errid=err.number:errdes=err.description:Err.Clear:echoErr err_moveFolder,errid,errdes else moveFolder=true
	end if
End Function

Function moveFile(ByVal src,ByVal target,Byval operType)
	dim srcPath,targetPath
	srcPath=Server.MapPath(src) 
	targetPath=Server.MapPath(target)
	if isExistFile(src) then
		objFso.Copyfile srcPath,targetPath
		if operType="del" then  delFile src 
		moveFile=true
	else
		moveFile=false
	end if
End Function

Function getFolderList(Byval cDir)
	dim filePath,objFolder,objSubFolder,objSubFolders,i
	i=0
	redim  folderList(0)
	filePath=server.mapPath(cDir)
	set objFolder=objFso.GetFolder(filePath)
	set objSubFolders=objFolder.Subfolders
	for each objSubFolder in objSubFolders
		ReDim Preserve folderList(i)
		With objSubFolder
			folderList(i)=.name&",�ļ���,"&.size/1000&"k,"&.DateLastModified&","&cDir&"/"&.name
		End With
		i=i + 1 
	next 
	set objFolder=nothing
	set objSubFolders=nothing
	getFolderList=folderList
End Function

Function getFileList(Byval cDir)
	dim filePath,objFolder,objFile,objFiles,i
	i=0
	redim  fileList(0)
	filePath=server.mapPath(cDir)
	set objFolder=objFso.GetFolder(filePath)
	set objFiles=objFolder.Files
	for each objFile in objFiles
		ReDim Preserve fileList(i)
		With objFile
			fileList(i)=.name&","&Mid(.name, InStrRev(.name, ".") + 1)&","&.size/1000&"k,"&.DateLastModified&","&cDir&"/"&.name
		End With
		i=i + 1 
	next 
	set objFiles=nothing
	set objFolder=nothing
	getFileList=fileList
End Function

Function urldecode(ByVal sUrl)
	Dim i,c,ts,b,lc,t,n:ts="":b=false:lc=""
	for i=1 to len(sUrl)
		c=mid(sUrl,i,1)
		if c="+" then
			ts=ts & " "
		elseif c="%" then
			t=mid(sUrl,i+1,2):n=cint("&H" & t)
			if b then
				b=false:ts=ts & chr(cint("&H" & lc & t))
			else
				if abs(n)<=127 then
					ts=ts & chr(n)
				else
					b=true:lc=t
				end if
			end if
			i=i+2
		else
			ts=ts & c
		end if
	next
	urldecode=ts
End Function

Function urlencode(ByVal sUrl)
	if InStr(" "&sUrl,"?")>0 then
		dim ts,i,l,s:ts=Split(Mid(sUrl,InStr(sUrl,"?")+1),"&"):l=UBound(ts)
		for i=0 to l
			if InStr(" "&ts(i),"=")>0 then
				s=Split(ts(i),"=")
				if s(1)<>"" AND InStr(" "&s(1),"%")=0 then
					s(1)=Server.urlencode(s(1)):ts(i)=Join(s,"=")
				end if
			end if
		next
		urlencode=Mid(sUrl,1,InStr(sUrl,"?"))&Join(ts,"&")
	else
		urlencode=sUrl
	end if
End Function

dim gXmlHttpVer
Function getXmlHttpVer()
	dim i,xmlHttpVersions,xmlHttpVersion
	getXmlHttpVer=false
	xmlHttpVersions=Array("Microsoft.XMLHTTP", "MSXML2.XMLHTTP", "MSXML2.XMLHTTP.3.0","MSXML2.XMLHTTP.4.0","MSXML2.XMLHTTP.5.0")
	for i=0 to ubound(xmlHttpVersions)
		xmlHttpVersion=xmlHttpVersions(i)
		if isInstallObj(xmlHttpVersion) then getXmlHttpVer=xmlHttpVersion:gXmlHttpVer=xmlHttpVersion: Exit Function
	next
End Function

Function tryXmlHttp()
	dim i,ah:ah=array("MSXML2.ServerXMLHTTP.3.0","MSXML2.ServerXMLHTTP.5.0","MSXML2.ServerXMLHTTP.4.0","MSXML2.ServerXMLHTTP.2.0","MSXML2.ServerXMLHTTP","MSXML2.ServerXMLHTTP.6.0","Microsoft.XMLHTTP", "MSXML2.XMLHTTP", "MSXML2.XMLHTTP.3.0","MSXML2.XMLHTTP.4.0","MSXML2.XMLHTTP.5.0")
	On Error Resume Next
	for i=0 to UBound(ah)
		SET tryXmlHttp=Server.CreateObject(ah(i))
		if err.number=0 then:gXmlHttpVer=ah(i):tryXmlHttp.setTimeouts 2000,20000,20000,180000:err.clear:Exit Function:else:err.clear:end if
	next
End Function

dim gXmlHttpObj
Function getRemoteContent(Byval url,Byval returnType)
	if not isObject(gXmlHttpObj) then:set gXmlHttpObj=tryXmlHttp():end if
	gXmlHttpObj.open "GET",url,False
	'On error resume next
	gXmlHttpObj.send()
	'if err.number = -2147012894 then
	'	dim des
	'	select case gXmlHttpObj.readyState
	'		Case 1:des="��������������Զ�̷�����"
	'		Case 2:des="��������"
	'		Case 3:des="��������"
	'		Case else:des="δ֪�׶�"
	'	end select
	'	die gXmlHttpVer&"���<br />������ ��"&url&"��ʱ<br />����" + des + " ��ʱ����,������.������⻹û���������ϵ��ķ�����"
	'else
		select case returnType
			case "text"
				getRemoteContent=gXmlHttpObj.responseText
			case "body"
				getRemoteContent=gXmlHttpObj.responseBody
		end select
	'end if
End Function

Function bytesToStr(Byval responseBody,Byval strCharSet)
	with objStream
		.Type=1
		.Mode =3
		.Open
		.Write responseBody
		.Position=0
		.Type=2
		.Charset=strCharSet
		bytesToStr=objstream.ReadText
		objstream.Close
	End With
End Function

Function computeStrLen(Byval str)
	dim strlen,charCount,i,an
	str=trim(str)   
	charCount=len(str)   
	strlen=0   
	for i=1 to charCount
		an=asc(mid(str,i,1))
		if an < 0 or an >255 then   
			strlen=strlen + 2
		else   
			strlen=strlen + 1
		end if
	next
	computeStrLen=strlen
End Function

Function getStrByLen(Byval str, Byval strlen)
	dim vStrlen,charCount,i,an
	str=trim(str)
	if isNul(str) then Exit Function
	charCount=len(str)  
	vStrlen=0   
	for i=1 to charCount
		an=asc(mid(str,i,1))
		if an < 0 or an >255 then
			vStrlen=vStrlen + 2
		else   
			vStrlen=vStrlen + 1
		end if
		if vStrlen > strlen then getStrByLen=left(str,i-1):Exit Function
	next
	getStrByLen=str
End Function

Function encodeHtml(Byval str)
	IF len(str)=0 OR Trim(str)="" then exit function
		str=replace(str,"<","&lt;")
		str=replace(str,">","&gt;")
		str=replace(str,CHR(34),"&quot;")
		str=replace(str,CHR(39),"&apos;")
		encodeHtml=str
End Function

Function decodeHtml(Byval str)
	IF len(str)=0 OR Trim(str)="" or isNull(str) then exit function
		str=replace(str,"&lt;","<")
		str=replace(str,"&gt;",">")
		str=replace(str,"&quot;",CHR(34))
		str=replace(str,"&apos;",CHR(39))
		decodeHtml=str
End Function

Function codeTextarea(Byval str,Byval enType)
	select case enType
		case "en"
			codeTextarea=replace(replace(str,chr(10),""),chr(13),"<br>")
		case "de"
			codeTextarea=replace(str,"<br>",chr(13)&chr(10))
	end select
End Function

Function getPageLink(ByVal page,Byval linkType)
	select case linkType
		case "channel"
			getPageLink=getChannelPagesLink(currentTypeId,page)
		case "search","newssearch"
			getPageLink="?page="&page&"&searchword="&server.urlencode(searchword)&"&searchtype="&searchType
		case "topicindex"
			getPageLink=getTopicIndexLink(page)
		case "topicpage"
			getPageLink=getTopicPageLink(currentTopicId,page,"")
		case "newspage"
			getPageLink=getNewsPartLink(currentTypeId,page)
		case "newssubpage"
			getPageLink=formatArticleLink(currentTypeId, currentId, currentEnname, currentDatetime, "",page)
		case "customvideo"
			getPageLink=getCustomLink(page)
		case "videolist"
			getPageLink="?page="&page&"&order="&order&"&type="&vtype&"&keyword="&keyword&"&m_state="&m_state&"&m_commend="&m_commend&"&repeat="&repeat&"&topic="&pTopic&"&playfrom="&playfrom
		case "adslist","selflabellist","templist","adminlist"
			getPageLink="?page="&page&"&action="&action&"&keyword="&keyword
		case "newslist"
			getPageLink="?page="&page&"&where="&where&"&action="&action&"&keyword="&keyword
	end select
End Function

Function makePagenumberLoop(Byval curPage,Byval pageline,Byval maxpage,Byval linkType,ByVal loopstr)
	dim j,i,iStart,iEnd,ret,tmp:curPage=clng(curPage)
	if pageline mod 2=0 then j=pageline / 2 else j=clng(pageline / 2) - 1
	if  curPage < 1  then curPage=1 else if curPage > maxpage then curPage=maxpage
	if pageline > maxpage then pageline=maxpage
	if curPage - j < 1 then
		iStart=1:iEnd=pageline
	elseif curPage - j + pageline > maxpage  then
		iStart=maxpage - pageline + 1:iEnd=maxpage
	else
		iStart=curPage - j:iEnd=curPage - j + pageline - 1
	end if
	for i=iStart to iEnd
		tmp=replace(loopstr,"[pagenumber:link]",getPageLink(i,linkType)):tmp=replace(tmp,"[pagenumber:page]",i):ret=ret&tmp
	next
	makePagenumberLoop=ret
End Function

Function makePageNumber(Byval curPage,Byval pageline,Byval maxpage,Byval linkType)
	dim j,i,iStart,iEnd,ret:curPage=clng(curPage)
	if pageline mod 2=0 then j=pageline / 2 else j=clng(pageline / 2) - 1
	if  curPage < 1  then curPage=1 else if curPage > maxpage then curPage=maxpage
	if pageline > maxpage then pageline=maxpage
	if curPage - j < 1 then
		iStart=1:iEnd=pageline
	elseif curPage - j + pageline > maxpage  then
		iStart=maxpage - pageline + 1:iEnd=maxpage
	else
		iStart=curPage - j:iEnd=curPage - j + pageline - 1
	end if
	for i=iStart to iEnd
		if clng(i)=clng(curPage) then
			if linkType="search" or linkType="newssearch" or linkType="channel"  or linkType="newspagelist"  or linkType="topicpage" then 
				ret=ret&"<em>"&i&"</em>"
			else
				ret=ret&"<span><font color=red>"&i&"</font></span>"
			end if
		else
			ret=ret&"<a href='"&getPageLink(i,linkType)&"'>"&i&"</a>"
		end if
	next
	makePageNumber=ret
End Function

Function pageNumberLinkInfo(Byval curPage,Byval pageline,Byval maxpage,Byval linkType,Byval recordcount)
	dim pageNumber,pagesStr,i,ret,ftPage,ltPage,ntPage,lastPage
	pageNumber=makePageNumber(curPage,pageline,maxpage,linkType)
	select case linkType
		case "search","newssearch"
			searchword=Server.URLEncode(searchword)
			if curPage=1 then
				ftPage="<em class='nolink'>��ҳ</em>":ltPage="<em class='nolink'>��һҳ</em>"
			else
				ftPage="<a href='?page=1&searchword="&searchword&"&searchtype="&searchType&"'>��ҳ</a>":ltPage="<a href='?page="&curPage-1&"&searchword="&searchword&"&searchtype="&searchType&"'>��һҳ</a>"
			end if
			if curPage=maxpage then 
				ntPage="<em class='nolink'>��һҳ</em>":lastPage="<em class='nolink'>βҳ</em>"
			else
				ntPage="<a href='?page="&curPage+1&"&searchword="&searchword&"&searchtype="&searchType&"'>��һҳ</a>":lastPage="<a href='?page="&maxpage&"&searchword="&searchword&"&searchtype="&searchType&"'>βҳ</a>"
			end if 
			pagesStr="<span><input type='input' name='page' size='4'/><input type='button' value='��ת' onclick=""goSearchPage("&maxpage&",'page','?page=<page>&searchword="&searchword&"&searchtype="&searchType&"')"" class='btn' /></span>"
			ret="<span>��"&recordcount&"������ ҳ��:"&curPage&"/"&maxpage&"ҳ</span>"&ftPage&ltPage&pageNumber&""&ntPage&""&lastPage&pagesStr
		case "channel"
			if curPage=1 then
				ftPage="<em class='nolink'>��ҳ</em>":ltPage="<em class='nolink'>��һҳ</em>"
			else
				ftPage="<a href='"&getChannelPagesLink(currentTypeId,1)&"'>��ҳ</a>":ltPage="<a href='"&getChannelPagesLink(currentTypeId,curPage-1)&"'>��һҳ</a>"
			end if
			if curPage=maxpage then
				ntPage="<em class='nolink'>��һҳ</em>":lastPage="<em class='nolink'>βҳ</em>"
			else
				ntPage="<a href='"&getChannelPagesLink(currentTypeId,curPage+1)&"'>��һҳ</a>":lastPage="<a href='"&getChannelPagesLink(currentTypeId,maxpage)&"'>βҳ</a>"
			end if
			pagesStr="<span><input type='input' name='page' size='4'/><input type='button' value='��ת' onclick=""getPageGoUrl("&maxpage&",'page','"&getChannelPagesLink(currentTypeId,"<page>")&"')"" class='btn' /></span>"
			ret="<span>��"&recordcount&"������ ҳ��:"&curPage&"/"&maxpage&"ҳ</span>"&ftPage&ltPage&pageNumber&""&ntPage&""&lastPage&pagesStr
		case "topicpage"
			if curPage=1 then
				ftPage="<em class='nolink'>��ҳ</em>":ltPage="<em class='nolink'>��һҳ</em>"
			else
				ftPage="<a href='"&getTopicPageLink(currentTopicId,1,"")&"'>��ҳ</a>":ltPage="<a href='"&getTopicPageLink(currentTopicId,curPage-1,"")&"'>��һҳ</a>"
			end if
			if curPage=maxpage then 
				ntPage="<em class='nolink'>��һҳ</em>":lastPage="<em class='nolink'>βҳ</em>"
			else
				ntPage="<a href='"&getTopicPageLink(currentTopicId,curPage+1,"")&"'>��һҳ</a>":lastPage="<a href='"&getTopicPageLink(currentTopicId,maxpage,"")&"'>βҳ</a>"
			end if
			pagesStr="<span><input type='input' name='page' size='4'/><input type='button' value='��ת' onclick=""getPageGoUrl("&maxpage&",'page','"&getTopicPageLink(currentTopicId,"<page>","")&"')"" class='btn'></span>"
			ret="<span>��"&recordcount&"������ ҳ��:"&curPage&"/"&maxpage&"ҳ</span>"&ftPage&ltPage&pageNumber&""&ntPage&""&lastPage&pagesStr
		case "topicindex"
			if curPage=1 then
				ftPage="<em class='nolink'>��ҳ</em>":ltPage="<em class='nolink'>��һҳ</em>"
			else
				ftPage="<a href='"&getTopicIndexLink(1)&"'>��ҳ</a>":ltPage="<a href='"&getTopicIndexLink(curPage-1)&"'>��һҳ</a>"
			end if
			if curPage=maxpage then 
				ntPage="<em class='nolink'>��һҳ</em>":lastPage="<em class='nolink'>βҳ</em>"
			else
				ntPage="<a href='"&getTopicIndexLink(curPage+1)&"'>��һҳ</a>":lastPage="<a href='"&getTopicIndexLink(maxpage)&"'>βҳ</a>"
			end if
			pagesStr="<span><input type='input' name='page' size='4'/><input type='button' value='��ת' onclick=""getPageGoUrl("&maxpage&",'page','"&getTopicIndexLink("<page>")&"')"" class='btn'></span>"
			ret="<span>��"&recordcount&"������ ҳ��:"&curPage&"/"&maxpage&"ҳ</span>"&ftPage&ltPage&pageNumber&""&ntPage&""&lastPage&pagesStr
		case "newspage"
			if curPage=1 then
				ftPage="<em class='nolink'>��ҳ</em>":ltPage="<em class='nolink'>��һҳ</em>"
			else
				ftPage="<a href='"&getNewsPartLink(currentTypeId,1)&"'>��ҳ</a>":ltPage="<a href='"&getNewsPartLink(currentTypeId,curPage-1)&"'>��һҳ</a>"
			end if
			if clng(curPage)=clng(maxpage) then
				ntPage="<em class='nolink'>��һҳ</em>":lastPage="<em class='nolink'>βҳ</em>"
			else
				ntPage="<a href='"&getNewsPartLink(currentTypeId,curPage+1)&"'>��һҳ</a>":lastPage="<a href='"&getNewsPartLink(currentTypeId,maxpage)&"'>βҳ</a>"
			end if
			pagesStr="<span><input type='input' name='page' size='4'/><input type='button' value='��ת' onclick=""getPageGoUrl("&maxpage&",'page','"&getNewsPartLink(currentTypeId,"<page>")&"')"" class='btn'></span>"
			ret="<span>��"&recordcount&"������ ҳ��:"&curPage&"/"&maxpage&"ҳ</span>"&ftPage&ltPage&pageNumber&""&ntPage&""&lastPage&pagesStr
		case "customvideo"
			if curPage=1 then
				ftPage="<em class='nolink'>��ҳ</em>":ltPage="<em class='nolink'>��һҳ</em>"
			else
				ftPage="<a href='"&getCustomLink(1)&"'>��ҳ</a>":ltPage="<a href='"&getCustomLink(curPage-1)&"'>��һҳ</a>"
			end if
			if curPage=maxpage then 
				ntPage="<em class='nolink'>��һҳ</em>":lastPage="<em class='nolink'>βҳ</em>"
			else
				ntPage="<a href='"&getCustomLink(curPage+1)&"'>��һҳ</a>":lastPage="<a href='"&getCustomLink(maxpage)&"'>βҳ</a>"
			end if
			pagesStr="<span><input type='input' name='page' size='4'/><input type='button' value='��ת' onclick=""getPageGoUrl("&maxpage&",'page','"&getCustomLink("<page>")&"')"" class='btn' /></span>"
			ret="<span>��"&recordcount&"������ ҳ��:"&curPage&"/"&maxpage&"ҳ</span>"&ftPage&ltPage&pageNumber&""&ntPage&""&lastPage&pagesStr
		case "newssubpage"
			if maxpage<2 then pageNumberLinkInfo="":Exit Function
			if curPage=1 then
				ftPage="<em class='nolink'>��ҳ</em>":ltPage="<em class='nolink'>��һҳ</em>"
			else
				ftPage="<a href='"&formatArticleLink(currentTypeId, currentId, currentEnname, currentDatetime, "",1)&"'>��ҳ</a>":ltPage="<a href='"&formatArticleLink(currentTypeId, currentId, currentEnname, currentDatetime, "",curPage-1)&"'>��һҳ</a>"
			end if
			if clng(curPage)=clng(maxpage) then
				ntPage="<em class='nolink'>��һҳ</em>":lastPage="<em class='nolink'>βҳ</em>"
			else
				ntPage="<a href='"&formatArticleLink(currentTypeId, currentId, currentEnname, currentDatetime, "",curPage+1)&"'>��һҳ</a>":lastPage="<a href='"&formatArticleLink(currentTypeId, currentId, currentEnname, currentDatetime, "",maxpage)&"'>βҳ</a>"
			end if
			ret=ftPage&ltPage&pageNumber&""&ntPage&""&lastPage
	end select
	pageNumberLinkInfo=ret
End Function

Function formatChannelLink(ByVal id,ByVal page,ByVal linkType)
	Dim x:page=Cstr(page)
	Select Case runMode
		Case "dynamic":x=channelDirName1&"/?":if paramset=0 then:x=x&id&ifthen(page="1","","-"&page)&fileSuffix:else:x=x&paramid&"="&id&ifthen(page="1","","&"&parampage&"="&page):end if
		Case "static"
			Select Case makeMode
				Case "dir1","dir3","dir5","dir7":x=getTypePathOnCache(id,""):if linkType<>"link" OR page<>"1" then x=x&channelPageName2&ifthen(page="1","",page)&fileSuffix
				Case "dir2","dir4":x=channelDirName3&"/"&channelPageName3&id&ifthen(page="1","","_"&page)&fileSuffix
				Case "dir6","dir8":x=channelDirName3&"/"&channelPageName3&Split(getTypeNameTemplateArrayOnCache(id),",")(3)&ifthen(page="1","",page)&fileSuffix
			End Select
		Case "forgedStatic":x=channelDirName4&"/"&channelPageName4&id&ifthen(page="1","","-"&page)&fileSuffix
	End Select
	formatChannelLink="/"&sitepath&x
End Function

Function formatContentLink(ByVal typeid,ByVal id,ByVal enname,ByVal sDate,ByVal linkType)
	Dim x
	Select Case runMode
		Case "dynamic":x=contentDirName1&"/?":if paramset=0 then:x=x&id&fileSuffix:else:x=x&paramid&"="&id:end if
		Case "static"
			Select Case makeMode
				Case "dir1":if md5Content=1 then:id=LCase(md5(id,16)):end if:x=getTypePathOnCache(typeid,"")&id&"/":if linkType<>"link" then x=x&contentPageName2&fileSuffix
				Case "dir3":if md5Content=1 then:id=LCase(md5(id,16)):end if:x=getTypePathOnCache(typeid,"")&year(sDate)&"-"&Month(sDate)&"/"&id&fileSuffix
				Case "dir5":x=getTypePathOnCache(typeid,"")&enname&"/":if linkType<>"link" then x=x&contentPageName2&fileSuffix
				Case "dir7":x=getTypePathOnCache(typeid,"")&year(sDate)&"-"&Month(sDate)&"/"&enname&fileSuffix
				Case "dir2":if md5Content=1 then:id=LCase(md5(id,16)):else:id=contentPageName3&id:end if:x=ContentDirName3&"/"&id&fileSuffix
				Case "dir4":if md5Content=1 then:id=LCase(md5(id,16)):else:id=contentPageName3&id:end if:x=ContentDirName3&"/"&year(sDate)&"-"&Month(sDate)&"/"&id&fileSuffix
				Case "dir6":x=ContentDirName3&"/"&contentPageName3&enname&fileSuffix
				Case "dir8":x=ContentDirName3&"/"&year(sDate)&"-"&Month(sDate)&"/"&contentPageName3&enname&fileSuffix
			End Select
		Case "forgedStatic":x=ContentDirName4&"/"&contentPageName4&id&fileSuffix
	End Select
	formatContentLink="/"&sitepath&x
End Function

Function formatPlayLink(ByVal typeid,ByVal id,ByVal enname,ByVal sDate,ByVal fileSuffix)
	Dim x,y,z:y=runMode:z=fileSuffix
	if y<>"forgedStatic" then
		if ismakeplay=0 then
			y="dynamic"
		elseif ismakeplay=2 then
			z=".asp"
		end if
	end if
	Select Case y
		Case "dynamic":x=playDirName1&"/"
		Case "static"
			Select Case makeMode
				Case "dir1":if md5Content=1 then:id=LCase(md5(id,16)):end if:x=getTypePathOnCache(typeid,"")&id&"/"&playPageName2&z
				Case "dir3":if md5Content=1 then:id=LCase(md5(id,16)):end if:x=getTypePathOnCache(typeid,"")&year(sDate)&"-"&Month(sDate)&"/"&id&"/"&playPageName2&z
				Case "dir5":x=getTypePathOnCache(typeid,"")&enname&"/"&playPageName2&z
				Case "dir7":x=getTypePathOnCache(typeid,"")&year(sDate)&"-"&Month(sDate)&"/"&enname&"/"&playPageName2&z
				Case "dir2":if md5Content=1 then:x=playDirName3&"/"&LCase(md5(id,16))&z:else:x=playDirName3&"/"&playPageName3&id&z:end if
				Case "dir4":if md5Content=1 then:x=playDirName3&"/"&year(sDate)&"-"&Month(sDate)&"/"&LCase(md5(id,16))&z:else:x=playDirName3&"/"&year(sDate)&"-"&Month(sDate)&"/"&playPageName3&id&z:end if
				Case "dir6":x=playDirName3&"/"&enname&"/"&ifthen(playPageName3<>"",playPageName3,"index")&z
				Case "dir8":x=playDirName3&"/"&year(sDate)&"-"&Month(sDate)&"/"&enname&"/"&ifthen(playPageName3<>"",playPageName3,"index")&z
			End Select
		Case "forgedStatic":x=playDirName4&"/"
	End Select
	formatPlayLink="/"&sitepath&x
End Function

Function getChannelPagesLink(Byval typeId,Byval page)
	getChannelPagesLink=formatChannelLink(typeId,page,"")
End Function

Function getTypeLink(Byval typeId)
	getTypeLink=formatChannelLink(typeId,1,"link")
End Function

Function getContentLink(ByVal typeid,ByVal id,ByVal enname,ByVal sDate,ByVal linkType)
	getContentLink=formatContentLink(typeid,id,enname,sDate,linkType)
End Function

Function getPlayLink(ByVal typeid,ByVal id,ByVal enname,ByVal sDate)
	getPlayLink=formatPlayLink(typeid,id,enname,sDate,fileSuffix)
End Function

Function getPlayLink2(ByVal typeid,ByVal id,ByVal enname,ByVal sDate,ByVal From,ByVal index)
	dim x
	if ismakeplay=3 AND runMode="static" then
		x="-"&From&"-"&index&fileSuffix:x=formatPlayLink(typeid,id,enname,sDate,x)
	elseif runMode="forgedStatic" then
		x=getPlayLink(typeid,id,enname,sDate)&id&"-"&From&"-"&index&fileSuffix
	else
		x=getPlayLink(typeid,id,enname,sDate)
		if paramset=0 then:x=x&"?"&id&"-"&From&"-"&index:else:x=x&"?"&paramid&"="&id&"&"&parampage&"="&From&"&"&paramindex&"="&index:end if
		if runMode<>"static" AND paramset<>1 OR ismakeplay=0 then:x=x&fileSuffix
	end if
	getPlayLink2=x
End Function

Function formatPartLink(ByVal id,ByVal page,ByVal linkType)
	Dim x:page=Cstr(page)
	Select Case newsRunMode
		Case "dynamic":x=PartDirName1&"/?":if newsparamset=0 then:x=x&id&ifthen(page="1","","-"&page)&newsFileSuffix:else:x=x&newsparamid&"="&id&ifthen(page="1","","&"&newsparampage&"="&page):end if
		Case "static"
			Select Case newsMakeMode
				Case "dir1","dir3","dir5","dir7":x=newsDirName2&"/"&getTypePathOnCache(id,"news"):if linkType<>"link" OR page<>"1" then x=x&PartPageName2&ifthen(page="1","",page)&newsFileSuffix
				Case "dir2","dir4":x=newsDirName3&"/"&PartDirName3&"/"&PartPageName3&id&ifthen(page="1","","_"&page)&newsFileSuffix
				Case "dir6","dir8":x=newsDirName3&"/"&PartDirName3&"/"&PartPageName3&Split(getNewsTypeNameTemplateArrayOnCache(id),",")(3)&ifthen(page="1","",page)&newsFileSuffix
			End Select
		Case "forgedStatic":x=newsDirName4&"/"&PartDirName4&"/"&PartPageName4&id&ifthen(page="1","","-"&page)&newsFileSuffix
	End Select
	formatPartLink="/"&sitepath&x
End Function

Function formatArticleLink(ByVal typeid,ByVal id,ByVal enname,ByVal sDate,ByVal linkType,Byval Page)
	Dim x
	Select Case newsRunMode
		Case "dynamic":x=articleDirName1&"/?":if newsparamset=0 then:x=x&id&ifthen(Page="1","","-"&Page)&newsFileSuffix:else:x=x&newsparamid&"="&id&ifthen(Page="1","","&"&newsparampage&"="&Page):end if
		Case "static"
			Select Case newsMakeMode
				Case "dir1":if newsmd5Content=1 then:id=LCase(md5(id,16)):end if:x=newsdirname2&"/"&getTypePathOnCache(typeid,"news")&id&"/":if linkType<>"link" OR page<>"1" then x=x&articlePageName2&ifthen(page="1","",page)&newsFileSuffix
				Case "dir3":if newsmd5Content=1 then:id=LCase(md5(id,16)):end if:x=newsdirname2&"/"&getTypePathOnCache(typeid,"news")&year(sDate)&"-"&Month(sDate)&"/"&id&ifthen(page="1","","-"&page)&newsFileSuffix
				Case "dir5":x=newsdirname2&"/"&getTypePathOnCache(typeid,"news")&enname&"/":if linkType<>"link" then x=x&articlePageName2&ifthen(page="1","",page)&newsFileSuffix
				Case "dir7":x=newsdirname2&"/"&getTypePathOnCache(typeid,"news")&year(sDate)&"-"&Month(sDate)&"/"&enname&ifthen(page="1","",page)&newsFileSuffix
				Case "dir2":if newsmd5Content=1 then:id=LCase(md5(id,16)):else:id=articlePageName3&id:end if:x=newsdirname3&"/"&articleDirName3&"/"&id&ifthen(page="1","","-"&page)&newsFileSuffix
				Case "dir4":if newsmd5Content=1 then:id=LCase(md5(id,16)):else:id=articlePageName3&id:end if:x=newsdirname3&"/"&articleDirName3&"/"&year(sDate)&"-"&Month(sDate)&"/"&id&ifthen(page="1","","-"&page)&newsFileSuffix
				Case "dir6":x=newsdirname3&"/"&articleDirName3&"/"&articlePageName3&enname&ifthen(page="1","",page)&newsFileSuffix
				Case "dir8":x=newsdirname3&"/"&articleDirName3&"/"&year(sDate)&"-"&Month(sDate)&"/"&articlePageName3&enname&ifthen(page="1","",page)&newsFileSuffix
			End Select
		Case "forgedStatic":x=newsDirName4&"/"&articleDirName4&"/"&articlePageName4&id&ifthen(page="1","","-"&page)&newsFileSuffix
	End Select
	formatArticleLink="/"&sitepath&x
End Function

Function getNewsArticleLink(ByVal typeid,ByVal id,ByVal enname,ByVal sDate,ByVal linkType)
	getNewsArticleLink=formatArticleLink(typeid,id,enname,sDate,linkType,1)
End Function

Function getNewsPartLink(ByVal id,ByVal page)
	getNewsPartLink=formatPartLink(id,page,"")
End Function

Function getNewsTypeLink(Byval typeId)
	getNewsTypeLink=formatPartLink(typeId,1,"link")
End Function

Function getNewsIndexLink()
	if newsRunMode="dynamic" then
		getNewsIndexLink="/"&sitePath&newsDirName1&"/"
	elseif newsRunMode="static" then
		if InStr("#dir2#dir4#dir6#dir8",newsMakeMode)>0 then
			getNewsIndexLink="/"&sitePath&newsdirname3&"/"&newsPageName2&newsFileSuffix
		else
			getNewsIndexLink="/"&sitePath&newsdirname2&"/"&newsPageName3&newsFileSuffix
		end if
	elseif newsRunMode="forgedStatic" then
		getNewsIndexLink="/"&sitePath&newsDirName4&"/"&newsPageName4&newsFileSuffix
	end if
End Function

Function getTopicPageLink(Byval id,Byval page,ByVal enname)
	Dim x:page=Cstr(page)
	Select Case runMode
		Case "dynamic":x=topicpageDirName&"/?":if paramset=0 then:x=x&id&ifthen(page="1","","-"&page)&fileSuffix:else:x=x&paramid&"="&id&ifthen(page="1","","&"&parampage&"="&page):end if
		Case "static":if enname="" then:x=conn.db("select m_enname from {pre}topic where m_id="&id,"array")(0,0):else:x=enname:end if:x=topicpageDirName&"/"&x&ifthen(page="1","","-"&page)&fileSuffix
		Case "forgedStatic":x=topicpageDirName4&"/"&id&ifthen(page="1","","-"&page)&fileSuffix
	End Select
	getTopicPageLink="/"&sitepath&x
End Function

Function getTopicIndexLink(ByVal page)
	Dim x:page=Cstr(page)
	if runMode="dynamic" then
		x="/"&sitePath&topicDirName&"/":if paramset=0 then:x=x&ifthen(page="1","","?"&page&fileSuffix):else:x=x&ifthen(page="1","","?"&parampage&"="&page):end if
	elseif runMode="static" then
		x="/"&sitePath&topicDirName&"/index"&ifthen(page<>"1",page,"")&fileSuffix
	elseif runMode="forgedStatic" then
		x="/"&sitePath&topicDirName4&"/index"&ifthen(page<>"1",page,"")&fileSuffix
	end if
	getTopicIndexLink=x
End Function

Function getCustomLink(ByVal page)
	getCustomLink=Replace(customLink,"<page>",ifthen(Cstr(page)<>"1",page,""))
End Function

Function getIndexLink()
	if runMode="dynamic" OR runMode="static" then  
		getIndexLink="/"&sitePath
	elseif runMode="forgedStatic" then
		getIndexLink="/"&sitePath&"index"&fileSuffix
	end if
End Function

Function getPlayerParas()
	if paramset=0 then
		Dim paras:paras=Split(replaceStr(request.QueryString,fileSuffix,""),"-")
		if UBound(paras)>1 then
			getPlayerParas=array(paras(1),paras(2))
		else
			getPlayerParas=array(-1,-1)
		end if
	else
		getPlayerParas=array(getForm(parampage,"both"),getForm(paramindex,"both"))
	end if
End Function

Function getPlayUrlList(Byval ifrom,Byval url,Byval typeId,Byval vId,ByVal enname,ByVal sDate,Byval typestr,ByVal starget)
	dim urlArray,singleUrlArray,urlCount,i,urlStr,contactStr,behindStr,style,paras,target:paras=getPlayerParas()
	if isNul(url) then
		getPlayUrlList="":Exit Function
	else
		if ""&starget<>"" then
			target=" target="""&starget&""""
		else
			target=" target=""_blank"""
		end if
		urlArray=split(url,"#")
		urlCount=ubound(urlArray)
		urlStr="<ul>"
		for i=0 to urlCount
			if not isNul(urlArray(i)) then
				singleUrlArray=split(urlArray(i),"$")
				if ubound(singleUrlArray)<2 then singleUrlArray=Array("","","")
				if ""&paras(0)=""&ifrom AND ""&i=""&paras(1) then style=" style=""color:red""" else style=""
				select case typestr
					case "play"
						if isAlertWin=1 then
							urlStr=urlStr&"<li><a title='"&singleUrlArray(0)&"' href=""javascript:openWin('"&getPlayLink2(typeId,vId,enname,sDate,ifrom,i)&"',"&(alertWinW+10)&","&(alertWinH+55)&",250,100,1)"""&style&">"&singleUrlArray(0)&"</a></li>"
						else
							urlStr=urlStr&"<li><a title='"&singleUrlArray(0)&"' href='"&getPlayLink2(typeId,vId,enname,sDate,ifrom,i)&"'"&style&target&">"&singleUrlArray(0)&"</a></li>"
						end if
					case "down"
						urlStr=urlStr&"<li><a href='"&singleUrlArray(1)&"'"&style&target&">"&singleUrlArray(0)&"</a></li>"
				end select
			end if
		next
	end if
	getPlayUrlList=urlStr&"</ul>"
End Function

Function getTypePath(ByVal id,ByVal by)
	Dim i,j,k,l,TL:j=getTypeindex("m_id"):k=getTypeindex("m_upid"):l=getTypeindex("m_enname"):getTypePath="":id=Clng(id)
	if by="news" then
		TL=getNewsTypeLists()
	else
		TL=getTypeLists()
	end if
	
	for i=0 to UBound(TL,2)
		if Clng(TL(j,i))=id then
			if Clng(TL(k,i))=0 then
				getTypePath=TL(l,i)&"/":Exit Function
			else
				getTypePath=getTypePath(TL(k,i),by)&TL(l,i)&"/"
			end if
		end if
	next
End Function

Dim gTypePathCache
Function getTypePathOnCache(ByVal id,ByVal by)
	dim cacheName,pathStr:cacheName="str_get_curtype_dir_type"&id
	if not isArray(gTypePathCache) then ReDim gTypePathCache(1)
	if gTypePathCache(0)<>id then
		if cacheStart=1 then
			if cacheObj.chkCache(cacheName) then pathStr=cacheObj.getCache(cacheName) else pathStr=getTypePath(id,by):cacheObj.setCache cacheName,pathStr end if
		else
			pathStr=getTypePath(id,by)
		end if
		gTypePathCache(0)=id:gTypePathCache(1)=pathStr
	end if
	getTypePathOnCache=gTypePathCache(1)
End Function

Function getTypeField(ByVal id,ByVal Col,ByVal by)
	Dim i,j,k,l,TL:if by="news" then:TL=getNewsTypeLists():else:TL=getTypeLists():end if:j=getTypeindex("m_id"):k=split(Col,","):id=Clng(id)
	for i=0 to UBound(TL,2)
		if Clng(TL(j,i))=id then
			for j=0 to UBound(k)
				k(j)=TL(getTypeindex(k(j)),i)
			next
			getTypeField=k:Exit Function
		end if
	next
	redim k(UBound(k)):getTypeField=k
End Function

Function getTypeUpid(ByVal id)
	Dim x:x=getTypeField(id,"m_upid","")(0)
	if isNum(x) then
		getTypeUpid=Clng(x)
	else
		getTypeUpid=id
	end if
End Function

Function getNewsTypeUpid(ByVal id)
	Dim x:x=getTypeField(id,"m_upid","news")(0)
	if isNum(x) then
		getNewsTypeUpid=Clng(x)
	else
		getNewsTypeUpid=id
	end if
End Function

Function getTypeText(ByVal id)
	Dim i,j,k,l,TL:TL=getTypeLists():j=getTypeindex("m_id"):k=getTypeindex("m_upid"):l=getTypeindex("m_name"):getTypeText="":id=Clng(id)
	for i=0 to UBound(TL,2)
		if Clng(TL(j,i))=id then
			if Clng(TL(k,i))=0 then
				getTypeText="<a href='"&getIndexLink()&"'>��ҳ</a>&nbsp;&nbsp;&raquo;&nbsp;&nbsp;<a href='"&getTypeLink(TL(j,i))&"' >"&TL(l,i)&"</a>":Exit Function
			else
				getTypeText=getTypeText(TL(k,i))&"&nbsp;&nbsp;&raquo;&nbsp;&nbsp;<a href='"&getTypeLink(TL(j,i))&"'>"&TL(l,i)&"</a>"
			end if
		end if
	next
End Function

Function getNewsTypeText(ByVal id)
	Dim i,j,k,l,TL:TL=getNewsTypeLists():j=getTypeindex("m_id"):k=getTypeindex("m_upid"):l=getTypeindex("m_name"):getNewsTypeText="":id=Clng(id)
	for i=0 to UBound(TL,2)
		if Clng(TL(j,i))=id then
			if Clng(TL(k,i))=0 then
				getNewsTypeText="<a href='"&getIndexLink()&"'>��ҳ</a>&nbsp;&nbsp;&raquo;&nbsp;&nbsp;<a href='"&getNewsIndexLink()&"'>������ҳ</a>&nbsp;&nbsp;&raquo;&nbsp;&nbsp;<a href='"&getNewsTypeLink(TL(j,i))&"' >"&TL(l,i)&"</a>":Exit Function
			else
				getNewsTypeText=getNewsTypeText(TL(k,i))&"&nbsp;&nbsp;&raquo;&nbsp;&nbsp;<a href='"&getNewsTypeLink(TL(j,i))&"'>"&TL(l,i)&"</a>"
			end if
		end if
	next
End Function

dim gTypeTextOnCache,gNewsTypeTextOnCache
Function getTypeTextOnCache(ByVal id)
	dim cacheName,typeText:cacheName="str_get_curtype_location_type"&id
	if not isArray(gTypeTextOnCache) then ReDim gTypeTextOnCache(1)
	if gTypeTextOnCache(0)<>id then
		if cacheStart=1 then
			if cacheObj.chkCache(cacheName)  then typeText=cacheObj.getCache(cacheName) else typeText=getTypeText(id):cacheObj.setCache cacheName,typeText end if
		else
			typeText=getTypeText(id)
		end if
		gTypeTextOnCache(0)=id:gTypeTextOnCache(1)=typeText
	end if
	getTypeTextOnCache=gTypeTextOnCache(1)
End Function

Function getNewsTypeTextOnCache(ByVal id)
	dim cacheName,typeText:cacheName="str_get_curtype_location_type"&id
	if not isArray(gNewsTypeTextOnCache) then ReDim gNewsTypeTextOnCache(1)
	if gNewsTypeTextOnCache(0)<>id then
		if cacheStart=1 then
			if cacheObj.chkCache(cacheName)  then typeText=cacheObj.getCache(cacheName) else typeText=getNewsTypeText(id):cacheObj.setCache cacheName,typeText end if
		else
			typeText=getNewsTypeText(id)
		end if
		gNewsTypeTextOnCache(0)=id:gNewsTypeTextOnCache(1)=typeText
	end if
	 getNewsTypeTextOnCache=gNewsTypeTextOnCache(1)
End Function

Function getTopicId()
	dim i,ary,ret:ary=conn.db("SELECT m_id FROM {pre}topic ORDER BY m_sort ASC","array")
	for i=0 to UBound(ary,2)
		if ret="" then
			ret=ary(0,i)
		else
			ret=ret&","&ary(0,i)
		end if
	next
	getTopicId=ret
End Function

Function getTypeId(ByVal id)
	dim i,j,k,TL,ret:TL=getTypeLists():j=getTypeIndex("m_upid"):k=getTypeIndex("m_id"):ret="":id=Clng(id)
	if id>0 then:ret=id
	for i=0 to UBound(TL,2)
		if Clng(TL(j,i))=id then
			if ret="" then
				ret=getTypeId(TL(k,i))
			else
				ret=ret&","&getTypeId(TL(k,i))
			end if
		end if
	next
	getTypeId=ret
End Function

Function getNewsTypeId(ByVal id)
	dim i,j,k,TL,ret:TL=getNewsTypeLists():j=getTypeIndex("m_upid"):k=getTypeIndex("m_id"):ret="":id=Clng(id)
	if id>0 then:ret=id
	for i=0 to UBound(TL,2)
		if Clng(TL(j,i))=id then
			if ret="" then
				ret=getNewsTypeId(TL(k,i))
			else
				ret=ret&","&getNewsTypeId(TL(k,i))
			end if
		end if
	next
	getNewsTypeId=ret
End Function

Function getTypeIdOnCache(Byval id)
	dim cacheName,typeid
	cacheName="str_get_subtypes_type"&id
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then  typeid=cacheObj.getCache(cacheName) else typeid=getTypeId(id):cacheObj.setCache cacheName,typeid
	else
		typeid=getTypeId(id)
	end if
	getTypeIdOnCache=typeid
End Function

Function getNewsTypeIdOnCache(Byval id)
	dim cacheName,typeid
	cacheName="str_get_newssubtypes_type"&id
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then typeid=cacheObj.getCache(cacheName) else typeid=getNewsTypeId(id):cacheObj.setCache cacheName,typeid
	else
		typeid=getNewsTypeId(id)
	end if
	getNewsTypeIdOnCache=typeid
End Function

Function getAllMenuList(ByVal id)
	Dim i,j,k,l,TL,s:TL=getTypeLists():j=getTypeindex("m_upid"):k=getTypeindex("m_id"):l=getTypeindex("m_name"):getAllMenuList="":s="":id=Clng(id)
	for i=0 to UBound(TL,2)
		if Clng(TL(j,i))=id then
			s=s&"<li><a href='"&getTypeLink(TL(k,i))&"'>"&TL(l,i)&"</a>"&getAllMenuList(TL(k,i))&"</li>"
		end if
	next
	if s<>"" then:getAllMenuList="<ul>"&s&"</ul>":end if
End Function

Function getAllNewsMenuList(ByVal id)
	Dim i,j,k,l,TL,s:TL=getNewsTypeLists():j=getTypeindex("m_upid"):k=getTypeindex("m_id"):l=getTypeindex("m_name"):getAllNewsMenuList="":s="":id=Clng(id)
	for i=0 to UBound(TL,2)
		if Clng(TL(j,i))=id then
			s=s&"<li><a href='"&getTypeLink(TL(k,i))&"'>"&TL(l,i)&"</a>"&getAllNewsMenuList(TL(k,i))&"</li>"
		end if
	next
	if s<>"" then:getAllNewsMenuList="<ul>"&s&"</ul>":end if
End Function

Function getAllMenuListOnCache(ByVal id,ByVal by)
	dim cacheName,menuList
	cacheName="str_"&by&"menu_list"&id
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then
			menuList=cacheObj.getCache(cacheName)
		else
			if by="news" then
				menuList=getAllNewsMenuList(id)
			else
				menuList=getAllMenuList(id)
			end if
			cacheObj.setCache cacheName,menuList
		end if
	else
		if by="news" then
			menuList=getAllNewsMenuList(id)
		else
			menuList=getAllMenuList(id)
		end if
	end if
	getAllMenuListOnCache=menuList
End Function

Function getTypeArray(itype)
	Dim Rows:Rows=conn.db("SELECT m_id,m_name,m_enname,m_sort,m_upid,m_hide,m_template,m_unionid,-1 AS m_count,m_keyword,m_description,m_subtemplate FROM {pre}type WHERE m_type="&itype&" ORDER BY m_sort ASC","array")
	if not isArray(Rows) then
		Redim Rows(11,-1)
	end if
	getTypeArray=Rows
End Function

Dim gTypeary,gNewsTypeary
Function getTypeLists()
	Dim cacheName:cacheName="array_type_lists_all"
	if not isArray(gTypeary) then
		if cacheStart=1 then
			if cacheObj.chkCache(cacheName) then:gTypeary=cacheObj.getCache(cacheName):else:gTypeary=getTypeArray(0):cacheObj.setCache cacheName,gTypeary:end if
		else
			gTypeary=getTypeArray(0)
		end if
	end if
	getTypeLists=gTypeary
End Function

Function getNewsTypeLists()
	Dim cacheName:cacheName="array_newstype_lists_all"
	if not isArray(gNewsTypeary) then
		if cacheStart=1 then
			if cacheObj.chkCache(cacheName) then:gNewsTypeary=cacheObj.getCache(cacheName):else:gNewsTypeary=getTypeArray(1):cacheObj.setCache cacheName,gNewsTypeary:end if
		else
			gNewsTypeary=getTypeArray(1)
		end if
	end if
	getNewsTypeLists=gNewsTypeary
End Function

Function getNumPerType(ByVal id)
	dim ids,num,i,j,l,Bool:j=getTypeIndex("m_id"):l=getTypeIndex("m_count"):num=0:Bool=false
	if not isArray(gTypeary) then:getTypeLists():end if
	ids = " ,"&Replace(getTypeIdOnCache(id)," ","")&","
	for i=0 to UBound(gTypeary,2)
		if InStr(ids,","&trim(gTypeary(j,i))&",")>0 then
			gTypeary(l,i)=Clng(gTypeary(l,i))
			if gTypeary(l,i)=-1 then:gTypeary(l,i)=conn.db("select count(*) from {pre}data where m_type="&gTypeary(j,i),"execute")(0):end if
			num=num+Clng(gTypeary(l,i)):Bool=true
		end if
	next
	if Bool=true then
		if cacheStart=1 then
			cacheObj.setCache "array_type_lists_all",gTypeary
		end if
	end if
	getNumPerType = num
End Function

Function getNumPerNewsType(ByVal id)
	dim ids,num,i,j,l,Bool:j=getTypeIndex("m_id"):l=getTypeIndex("m_count"):num=0:Bool=false
	if not isArray(gNewsTypeary) then:getNewsTypeLists():end if
	ids = " ,"&Replace(getNewsTypeIdOnCache(id)," ","")&","
	for i=0 to UBound(gNewsTypeary,2)
		if InStr(ids,","&trim(gNewsTypeary(j,i))&",")>0 then
			gNewsTypeary(l,i)=Clng(gNewsTypeary(l,i))
			if gNewsTypeary(l,i)=-1 then:gNewsTypeary(l,i)=conn.db("select count(*) from {pre}news where m_type="&gNewsTypeary(j,i),"execute")(0):end if
			num=num+Clng(gNewsTypeary(l,i)):Bool=true
		end if
	next
	if Bool=true then
		if cacheStart=1 then
			cacheObj.setCache "array_newstype_lists_all",gNewsTypeary
		end if
	end if
	getNumPerNewsType = num
End Function

Function getTypeindex(ByVal sName)
	dim i
	SELECT Case sName
		Case "m_id":i=0
		Case "m_name":i=1
		Case "m_enname":i=2
		Case "m_sort":i=3
		Case "m_upid":i=4
		Case "m_hide":i=5
		Case "m_template":i=6
		Case "m_unionid":i=7
		Case "m_count":i=8
		Case "m_keyword":i=9
		Case "m_description":i=10
		Case "m_subtemplate":i=11
	End SELECT
	getTypeindex=i
End Function

Dim gHideTypeIDS,gHideNewsTypeIDS:gHideTypeIDS=empty:gHideNewsTypeIDS=empty
Function getHideTypeIDS()
	if gHideTypeIDS=empty then
		Dim i,j,k,ret,TS:TS=getTypeLists():j=getTypeIndex("m_hide"):k=getTypeIndex("m_id"):ret=""
		for i=0 to UBound(TS,2)
			if ""&TS(j,i)="1" then
				if ret="" then
					ret=TS(k,i)
				else
					ret=ret&","&TS(k,i)
				end if
			end if
		next
		gHideTypeIDS=ret
	end if
	getHideTypeIDS=gHideTypeIDS
End Function

Function getHideNewsTypeIDS()
	if gHideNewsTypeIDS=empty then
		Dim i,j,k,ret,TS:TS=getNewsTypeLists():j=getTypeIndex("m_hide"):k=getTypeIndex("m_id"):ret=""
		for i=0 to UBound(TS,2)
			if ""&TS(j,i)="1" then
				if ret="" then
					ret=TS(k,i)
				else
					ret=ret&","&TS(k,i)
				end if
			end if
		next
		gHideNewsTypeIDS=ret
	end if
	getHideNewsTypeIDS=gHideNewsTypeIDS
End Function

Function makeTopicSelect(selectName,arrayObj,strSelect,topicId)
		dim i,str,selectedStr
		str="<select id='"&selectName&"'  name='"&selectName&"' >"
		if not isNul(strSelect) then  str=str&"<option value=''>"&strSelect&"</option>"
		if isArray(arrayObj) then
			for  i=0 to ubound(arrayObj,2)
				if not isNul(topicId) then
					if clng(arrayObj(0,i))=clng(topicId) then   selectedStr="selected" else  selectedStr=""
				end if
				str=str &"<option value='"&arrayObj(0,i)&"' "&selectedStr&">"&arrayObj(1,i)&"</option>"
			next
		end if
		str=str&"</select>"
		makeTopicSelect=str
End Function

Function makeTopicOptions(arrayObj,strSelect)
	dim i,str
	if not isNul(str) then  str=str&"<option value='-1'>"&strSelect&"</option>"
	if isArray(arrayObj) then 
		for  i=0 to ubound(arrayObj,2)
			str=str&"<option value='"&arrayObj(0,i)&"'>"&arrayObj(1,i)&"</option>"
		next
	end if
	makeTopicOptions=str
End Function

Function arrayToDictionay(Byval arrayObj)
	dim dictionaryObj:set dictionaryObj=server.CreateObject(DICTIONARY_OBJ_NAME)
	dim dicKey,dicValue,i
	if isArray(arrayObj) then
		for i=0 to ubound(arrayObj,2)
			dicKey= arrayObj(0,i):dicValue= arrayObj(1,i)
			if not dictionaryObj.Exists(dicKey) then dictionaryObj.add dicKey,dicValue  else  dictionaryObj(dicKey)=dicValue
		next
	end if
	set arrayToDictionay=dictionaryObj
End Function

Function getTypeNameTemplateArray(m_id)
	dim typeArray,i,j,ret:j=getTypeIndex("m_id"):ret=",,,,":typeArray=getTypeLists():m_id=""&m_id
	for i=0 to UBound(typeArray,2)
		if ""&typeArray(j,i)=m_id then
			ret=typeArray(getTypeIndex("m_name"),i)&","&typeArray(getTypeIndex("m_template"),i)&","&typeArray(getTypeIndex("m_upid"),i)&","&typeArray(getTypeIndex("m_enname"),i)&","&typeArray(getTypeIndex("m_subtemplate"),i):exit for
		end if
	next
	getTypeNameTemplateArray=ret
End Function

Function getNewsTypeNameTemplateArray(m_id)
	dim typeArray,i,j,ret:j=getTypeIndex("m_id"):ret=",,,,":typeArray=getNewsTypeLists():m_id=""&m_id
	for i=0 to UBound(typeArray,2)
		if ""&typeArray(j,i)=m_id then
			ret=typeArray(getTypeIndex("m_name"),i)&","&typeArray(getTypeIndex("m_template"),i)&","&typeArray(getTypeIndex("m_upid"),i)&","&typeArray(getTypeIndex("m_enname"),i)&","&typeArray(getTypeIndex("m_subtemplate"),i):exit for
		end if
	next
	getNewsTypeNameTemplateArray=ret
End Function

Function getTypeNameTemplateArrayOnCache(m_id)
	dim cacheName,ret:cacheName="array_type_id_name_template_upid"&m_id
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then ret=cacheObj.getCache(cacheName) else ret=getTypeNameTemplateArray(m_id):cacheObj.setCache cacheName,ret
	else
		ret=getTypeNameTemplateArray(m_id)
	end if
	getTypeNameTemplateArrayOnCache=ret
End Function

Function getNewsTypeNameTemplateArrayOnCache(m_id)
	dim cacheName,ret:cacheName="array_type_id_name_template_upid"&m_id
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then ret=cacheObj.getCache(cacheName) else ret=getNewsTypeNameTemplateArray(m_id):cacheObj.setCache cacheName,ret
	else
		ret=getNewsTypeNameTemplateArray(m_id)
	end if
	getNewsTypeNameTemplateArrayOnCache=ret
End Function

Function preventSqlin(content,vtype)
	dim sqlStr,sqlArray,i,speStr
	sqlStr="<|>|%|%27|'|''|;|*|and|exec|dbcc|alter|drop|insert|select|update|delete|count|master|truncate|char|declare|where|set|declare|mid|chr"
	if isNul(content) then Exit Function
	sqlArray=split(sqlStr,"|")
	for i=lbound(sqlArray) to ubound(sqlArray)
		if instr(lcase(content),sqlArray(i))<>0 then
			if vtype="filter" then
				select case sqlArray(i)
					case "<":speStr="&lt;"
					case ">":speStr="&gt;"
					case "'","""":speStr="&quot;"
					case ";":speStr="��"
					case else:speStr=""
				end select
				content=replace(content,sqlArray(i),speStr,1,-1,1)
			else
				echoSaveStr "safe":Exit Function
			end if
		end if
	next
	preventSqlin=content
End Function

Function replaceCurrentTypeId(str)
	str=replaceStr(str,"{maxcms:currenttypeid}",currentTypeId)
	replaceCurrentTypeId=str
End Function

Function replaceTopicId(str)
	replaceTopicId=replaceStr(str,"{maxcms:currenttopicid}",currentTopicId)
End Function

Function getFromStr(playurl)
	if isNul(playurl) then getFromStr="":Exit Function
	dim playurlArray,playurlLen,i,span1,span2,urlstr:span1="$$$":span2="$$"
	playurlArray=split(playurl,span1):playurlLen=ubound(playurlArray)
	for i=0 to playurlLen
		if i=playurlLen then urlstr=urlstr&split(playurlArray(i),span2)(0) else urlstr=urlstr&split(playurlArray(i),span2)(0)&","
	next
	getFromStr=urlstr
End Function

Function getPlayurlArray(playurl)
	dim span1:span1="$$$"
	if isNul(playurl) then playurl=""
	getPlayurlArray=split(playurl,span1)
End Function

Function filterDirty(content)
	dim dirtyStr,dirtyStrArray,i:dirtyStr="%u80E1%u9526%u6D9B%2C%u6E29%u5BB6%u5B9D%2C%u5C3B%2C%u5C4C%2C%u64CD%u4F60%2C%u5E72%u6B7B%u4F60%2C%u8D31%u4EBA%2C%u72D7%u5A18%2C%u5A4A%u5B50%2C%u8868%u5B50%2C%u9760%u4F60%2C%u53C9%u4F60%2C%u53C9%u6B7B%2C%u63D2%u4F60%2C%u63D2%u6B7B%2C%u5E72%u4F60%2C%u5E72%u6B7B%2C%u65E5%u4F60%2C%u65E5%u6B7B%2C%u9E21%u5DF4%2C%u777E%u4E38%2C%u5305%u76AE%2C%u9F9F%u5934%2C%u5C44%2C%u8D51%2C%u59A3%2C%u808F%2C%u5976%u5B50%2C%u5976%u5934%2C%u9634%u6BDB%2C%u9634%u9053%2C%u9634%u830E%2C%u53EB%u5E8A%2C%u5F3A%u5978%2C%u7231%u6DB2%2C%u6027%u9AD8%u6F6E%2C%u505A%u7231%2C%u6027%u4EA4%2C%u53E3%u4EA4%2C%u809B%u4EA4"
	dirtyStrArray=split(unescape(dirtyStr),",")
	for i=0 to ubound(dirtyStrArray)
		content=replace(content,dirtyStrArray(i),"***",1,-1,1)
	next
	filterDirty=content
End Function

Function regexFind(Byval str,Byval pattern)
	if isNul(str) then:regexFind="":Exit Function
	dim regObj,match,matches,findStr:set regObj=New RegExp
	regObj.Pattern=pattern:set matches=regObj.Execute(str)
	for each match in matches
		regexFind=match.SubMatches(0)
		set regObj=nothing:set matches=nothing:Exit Function
	next
End Function

Function getTimeSpan(sessionName)
	dim lastTime:lastTime=session(sessionName)
	if isNul(lastTime) then lastTime=0
	getTimeSpan=DateDiff("s",lasttime,now())
End Function

Function showFace(m_content)
	dim templateobj:set templateobj=mainClassObj.createObject("MainClass.template")
	m_content=templateobj.regExpReplace(m_content,"\[ps:(\d{1,})?\]","<img src=""/"&sitePath&"pic/faces/$1.gif"" border=0/>")
	set templateobj=nothing
	showFace=m_content
End Function

Function isExistStr(str,findstr)
	if isNul(str) or isNul(findstr) then isExistStr=false:Exit Function
	if instr(str,findstr)>0 then isExistStr=true else isExistStr=false
End Function

Function getFirstLetter(str)
	dim temNum,char:char=left(replace(trim(str)," ",""),1)
	on error resume next
	temNum=65536+asc(char)
	if err then  getFirstLetter="":err.clear:exit function
	IF (temNum>=45217 and temNum<=45252) Then 
		getFirstLetter= "A" 
	ElseIF(temNum>=45253 and temNum<=45760) Then 
		getFirstLetter= "B" 
	ElseIF(temNum>=45761 and temNum<=46317) Then 
		getFirstLetter= "C" 
	ElseIF(temNum>=46318 and temNum<=46825) Then 
		getFirstLetter= "D" 
	ElseIF(temNum>=46826 and temNum<=47009) Then 
		getFirstLetter= "E" 
	ElseIF(temNum>=47010 and temNum<=47296) Then 
		getFirstLetter= "F" 
	ElseIF(temNum>=47297 and temNum<=47613) Then 
		getFirstLetter= "G" 
	ElseIF(temNum>=47614 and temNum<=48118) Then 
		getFirstLetter= "H" 
	ElseIF(temNum>=48119 and temNum<=49061) Then 
		getFirstLetter= "J" 
	ElseIF(temNum>=49062 and temNum<=49323) Then 
		getFirstLetter= "K" 
	ElseIF(temNum>=49324 and temNum<=49895) Then 
		getFirstLetter= "L" 
	ElseIF(temNum>=49896 and temNum<=50370) Then 
		getFirstLetter= "M" 
	ElseIF(temNum>=50371 and temNum<=50613) Then 
		getFirstLetter= "N" 
	ElseIF(temNum>=50614 and temNum<=50621) Then 
		getFirstLetter= "O" 
	ElseIF(temNum>=50622 and temNum<=50905) Then 
		getFirstLetter= "P" 
	ElseIF(temNum>=50906 and temNum<=51386) Then 
		getFirstLetter= "Q" 
	ElseIF(temNum>=51387 and temNum<=51445) Then 
		getFirstLetter= "R" 
	ElseIF(temNum>=51446 and temNum<=52217) Then 
		getFirstLetter= "S" 
	ElseIF(temNum>=52218 and temNum<=52697) Then 
		getFirstLetter= "T" 
	ElseIF(temNum>=52698 and temNum<=52979) Then 
		getFirstLetter= "W" 
	ElseIF(temNum>=52980 and temNum<=53688) Then 
		getFirstLetter= "X" 
	ElseIF(temNum>=53689 and temNum<=54480) Then 
		getFirstLetter= "Y" 
	ElseIF(temNum>=54481 and temNum<=62289) Then 
		getFirstLetter= "Z"
	ElseIF(temNum=-2354+65536) Then 
		getFirstLetter= "X"
	Else
		getFirstLetter=UCase(char) 
	End if
End Function

Function replacedirtyWords(str)
	dim i
	dim mystr:mystr=str
	dim warray:warray=split(dirtyWords,",")
	for i=0 to ubound(warray)
		mystr=replace(mystr,warray(i),"*")
	next
	replacedirtyWords=mystr
End Function

Function getletterlist
	dim i,mystr
	for i=65 to 90
		mystr=mystr&"<a href=""/"&sitepath&"search.asp?searchtype=4&searchword="&chr(i)&""">"&chr(i)&"</a>"
	next
	getletterlist=mystr
End Function

Function writeRole
	writeRole=false
	createTextFile "","role.asp",""
	if objFso.FileExists(server.mappath("role.asp")) then writeRole=true:delFile "role.asp"
End Function

Function getNewsFolder(vdate)
	if  isnul(vdate) then vdate=now
	if isdate(vdate)=false then vdate=now
	if month(vdate)<10 then getNewsFolder=year(vdate)&"0"&month(vdate) else getNewsFolder=year(vdate)&month(vdate)
End Function

Function getSubStrByFromAndEnd(str,startStr,endStr,operType)
	dim location1,location2
	select case operType
		case "start"
			location1=instr(str,startStr)+len(startStr):location2=len(str)+1
		case "end"
			location1=1:location2=instr(location1,str,endStr)
		case else
			location1=instr(str,startStr)+len(startStr):location2=instr(location1,str,endStr)
	end select
	getSubStrByFromAndEnd=mid(str,location1,location2-location1) 
End Function

Function getPlayerIntroArray(str)
	dim xmlobj,vNodes,i,j,l,xmlFile,xmlNode,tmp
	ReDim temp(2,0)
	if str="play" then 
		xmlFile="/"&sitePath&"inc/playerKinds.xml":xmlNode="playerkinds/player" 
	else  
		xmlFile="/"&sitePath&"inc/downKinds.xml":xmlNode="downkinds/source"
	end if
	set xmlobj = mainClassobj.createObject("MainClass.Xml")
	xmlobj.load xmlFile,"xmlfile"
	set vNodes=xmlobj.getNodes(xmlNode):l=vNodes.length-1
	for i=0 to l
		ReDim Preserve temp(2,i)
		temp(0,i)=xmlobj.getAttributesByNode(vNodes(i),"flag")
		temp(1,i)=vNodes(i).childNodes(0).text&"__maxcc__"&xmlobj.getAttributesByNode(vNodes(i),"open")
		temp(2,i)=xmlobj.getAttributesByNode(vNodes(i),"sort")
		if isNumeric(temp(2,i)) then:temp(2,i)=Clng(temp(2,i)):else:temp(2,i)=0:end if
	next
	set vNodes=nothing:set xmlobj=nothing
	for i=0 to l
		for j=i+1 to l
			if temp(2,i) < temp(2,j) then
				tmp=temp(0,j):temp(0,j)=temp(0,i):temp(0,i)=tmp
				tmp=temp(1,j):temp(1,j)=temp(1,i):temp(1,i)=tmp
				tmp=temp(2,j):temp(2,j)=temp(2,i):temp(2,i)=tmp
			end if
		next
	next
	getPlayerIntroArray=temp
End Function

Dim gPlayerIntroArray(1)
Function getPlayerIntroArrayOnCache(str)
	Dim i:if str="play" then:i=0:else:i=1:end if
	if not isArray(gPlayerIntroArray(i)) then
		dim cacheName,playerArray:cacheName="array_"&str&"list"
		if cacheStart=1 then
			if cacheObj.chkCache(cacheName) then:gPlayerIntroArray(i)=cacheObj.getCache(cacheName):else:gPlayerIntroArray(i)=getPlayerIntroArray(str):cacheObj.setCache cacheName,gPlayerIntroArray(i)
		else
			gPlayerIntroArray(i)=getPlayerIntroArray(str)
		end if
	end if
	getPlayerIntroArrayOnCache=gPlayerIntroArray(i)
End Function

Function getPlayerIntroOnCache(str,flag)
	dim playerArray:playerArray=getPlayerIntroArrayOnCache(str)
	getPlayerIntroOnCache=playerArray(1,getArrayElementID(playerArray,0,flag))
End Function

Function getRndPlayerurlSpan(rndType)
	dim rndNumber,rndNumber2,rndArray
	select case rndType
		case 1
			randomize():rndNumber=clng(10000*rnd)
			randomize():rndNumber2=clng(3*rnd)
			select case rndNumber2
				case 0
					getRndPlayerurlSpan=rndNumber&"'+'"&replaceStr(replaceStr(replaceStr(cacheFlag,"C",""),"_",""),"2009","")&"'+'"&rndNumber
				case 1
					getRndPlayerurlSpan=rndNumber&"'+'"&replaceStr(replaceStr(replaceStr(cacheFlag,"C",""),"_",""),"2009","")&rndNumber
				case 2
					getRndPlayerurlSpan=rndNumber&replaceStr(replaceStr(replaceStr(cacheFlag,"C",""),"_",""),"2009","")&"'+'"&rndNumber
				case 3
					getRndPlayerurlSpan=rndNumber&replaceStr(replaceStr(replaceStr(cacheFlag,"C",""),"_",""),"2009","")&rndNumber
			end select
		case 2
			randomize():rndNumber=clng(3*rnd)
			rndArray=Array("un"&"esc"&"ape('%2524')+u"&"nesca"&"pe('%25')+unes"&"cape('24')","un"&"esc"&"ape('%25')+u"&"nesca"&"pe('24%25')+unes"&"cape('24')","u"&"nesca"&"pe('%2524')+un"&"esc"&"ape('%2524')","unes"&"cape('%2524%2524')")
			getRndPlayerurlSpan=rndArray(rndNumber)
	end select
End Function

Function getTextsegments()
	Dim l,ret,xmlobj,Nodes,Node:ret=array():SET xmlobj=mainClassobj.createObject("MainClass.Xml"):l=0
	xmlobj.load "/"&sitePath&"inc/textsegment.xml","xmlfile"
	SET Nodes=xmlobj.getNodes("root/item")
	for each Node in Nodes
		ReDim Preserve ret(l)
		ret(l)=Node.text:l=l+1
	next
	set xmlobj = nothing:getTextsegments=ret
End Function

Function getTextsegmentsOnCache()
	dim cacheName,ret:cacheName="array_textsegmentlist"
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then ret=cacheObj.getCache(cacheName) else ret=getTextsegments():cacheObj.setCache cacheName,ret
	else
		ret=getTextsegments()
	end if
	getTextsegmentsOnCache=ret
End Function

Function doPseudo(ByVal des,ByVal iId)
	dim iType,ts,l,pos:iType=iId MOD 3:ts=getTextsegmentsOnCache():l=UBound(ts)+1
	if l=0 OR des="" then
		doPseudo=des
	elseif iType=1 then
		doPseudo=ts(iId MOD l)&des
	elseif iType=2 then
		doPseudo=des&ts(iId MOD l)
	else
		pos=inStr(des,"<br>")
		if pos=0 then pos=inStr(des,"<br/>")
		if pos=0 then pos=inStr(des,"<br />")
		if pos=0 then pos=inStr(des,vbcrlf)
		if pos=0 then pos=inStr(des,"��")+1
		if pos>0 then
			doPseudo=Mid(des,1,pos-1)&ts(iId MOD l)&Mid(des,pos)
		else
			doPseudo=ts(iId MOD l)&des
		end if
	end if
End Function

Function ResetFromSort(ByVal sData)
	if sData="" then ResetFromSort="":exit function
	on error resume next
	dim i,j,dd,dl,ff:dd=getPlayurlArray(sData):dl=UBound(dd)
	if dl>0 then
		dim ay:ay=getPlayerIntroArrayOnCache("play")
		dim ul,ret:ul=UBound(ay,2):ReDim li(ul):ret=""
		for i=0 to dl
			ff=Split(dd(i),"$$"):j=getArrayElementID(ay,0,ff(0))
			if ""&li(j)<>"" then
				li(j)=li(j)&"$$$"&dd(i)
			else
				li(j)=dd(i)
			end if
		next
		for i=0 to ul
			if li(i)<>"" then
				if ret<>"" then:ret=ret&"$$$"&li(i):else:ret=li(i):end if
			end if
		next
		ResetFromSort=ret
	else
		ResetFromSort=sData
	end if
End Function

Function ifthen(ByVal bool,ByRef vala,ByRef valb)
	if bool=true then:ifthen=vala:else:ifthen=valb:end if
End Function

Function getNumTime()
	Dim t,Y,M,D,H,N,S:t=Now():Y=Year(t):M=Month(t):D=Day(t):H=Hour(t):N=Minute(t):S=Second(t)
	getNumTime=Y&Right("00"&M,2)&Right("00"&D,2)&Right("00"&H,2)&Right("00"&N,2)&Right("00"&S,2)
End Function

Function StrSlice(ByVal stxt,ByVal s,ByVal e)
	StrSlice="":if stxt="" then Exit Function
	Dim p:p=InStr(stxt,s)
	if p=0 then Exit Function
	stxt=Mid(stxt,p+Len(s)):p=InStr(stxt,e)
	if p=0 then Exit Function
	StrSlice=Mid(stxt,1,p-1)
End Function

Function Str2Num(ByVal sNum)
	if not isNumeric(sNum) then:Str2Num=0:exit function:end if
	Str2Num=CDBL(sNum)
End Function

Function PlayData2Json(playData)
	Dim x,y,i,j,l,r,z:x=split(playData,"$$$"):l=UBound(x):r=array():j=0
	for i=0 to l
		y=split(x(i),"$$"):z=getPlayerIntroOnCache("play",y(0))
		if Instr(z,"maxcc__0")<1 then
			y(0)="'"&y(0)&"'":y(1)=unescape(ReplaceStr(escape(Join(split(y(1),"#"),"','")),"%u","\u"))
			y(1)=ifthen(y(1)<>"","['"&y(1)&"']","[]")
			Redim Preserve r(j)
			r(j)="["&y(0)&","&y(1)&"]":j=j+1
		end if
	next
	j=Join(r,",")
	PlayData2Json=ifthen(j<>"","["&replaceStr(j,",''","")&"]","[]")
End Function

Function PlayData2Json2(playData)
	Dim x,y,i,j,ret,pn,ary,z,l,k,r,p,t,q,it,f:x=split(playData,"$$$"):l=UBound(x):ary=array():f=array():r=array():ret=array("[%s]",0,array(),array()):k=0
	for i=0 to l
		y=split(x(i),"$$"):z=getPlayerIntroOnCache("play",y(0))
		if Instr(z,"maxcc__0")<1 then
			Redim Preserve f(k):f(k)=y(0)
			y(0)="'"&y(0)&"'":pn=split(y(1),"#"):t=array():q=array():it=0
			for j=0 to UBound(pn)
				p=Instr(pn(j),"$")
				if p>0 then
					Redim Preserve t(it):Redim Preserve q(it)
					t(it)=pn(j):q(it)=mid(pn(j),1,p-1)
					it=it+1
				end if
			next
			y(1)=unescape(ReplaceStr(escape(Join(t,"','")),"%u","\u")):y(1)=ifthen(y(1)<>"","['"&y(1)&"']","[]")
			Redim Preserve r(k):Redim Preserve ary(k)
			r(k)="["&y(0)&","&y(1)&"]":ary(k)=q:k=k+1
		end if
	next
	ret(1)=k-1:ret(2)=ary:ret(3)=f
	ret(0)=Replace(ret(0),"%s",Join(r,","))
	PlayData2Json2=ret
End Function

Function getPartName(playData,m,n)
	on error resume next
	Dim x:x=split(split(playData,"$$$")(m),"$$")
	x(1)=split(split(x(1),"#")(n),"$")(0)
	getPartName=x
	if err then getPartName=array("",""):err.clear
End Function

Function parseNewsNote(ByVal by)
	parseNewsNote=ifthen((by and 64)<>0,"[��]","")&ifthen((by and 128)<>0,"[ͼ]","")&ifthen((by and 32)<>0,"[��]","")
End Function

function getCacheFile(ByVal Id,ByVal flag)
	Dim x,y:x=(Id mod 16):y=(Id mod 32)
	getCacheFile="/"&sitepath&CDIRNAME&"/"&x&"/"&y&"/"&Id&flag&".html"
end function

'SQLģת��
Function EscapeSql(ByVal S)
	Dim x,y,i,l,cn,en,z:x="��һ�����������߰˾�":y="0123456789":l=Len(y)
	for i=1 to l
		cn=mid(x,i,1):en=mid(y,i,1):z="["&cn&en&"]"
		if Instr(s,cn)>0 then
			S=Join(Split(S,cn),z)
		elseif Instr(s,en)>0 then
			S=Join(Split(S,en),z)
		end if
	next
	EscapeSql=S
End Function
%>