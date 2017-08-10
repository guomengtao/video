<%
'******************************************************************************************
' Software name: Max(����˹) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ����
' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
'******************************************************************************************
'����:��û�б�Ҫ���ֹ ���� ִ��VB�ű� �� execute ���� Ĭ��Ϊ��ֹ(true)��Ч��ֹ�Ƿ��ű���ִ��
'��ֹ�ɼ��ű�ͨ��executeִ��VBSCRIPT: ��ֹ��Ϊtrue ������Ϊfalse
Dim tConn,tQuery,tDic,tTypeDic,tnTypeDic,gHttpObj,gMSControl:tConn=null:gMSControl=null
Const TEMPDATABASEFILENAME="tempdata.mdb"
'Const ESCDIR = "items/video/"
'Const ESCACHEDIR = "cache/"
Dim initStep:initStep=1

Function IsClientConnected()
	IsClientConnected=response.IsClientConnected
End Function

Function Object()
	SET Object = Server.CreateObject(DICTIONARY_OBJ_NAME):Object.CompareMode=1
End Function

'��ֵ
Function SetValue(ByRef Var,ByVal Val)
	if isObject(val) then
		if isObject(Var) then:SET Var=nothing:end if
		SET Var=Val:SET SetValue=Val
	else
		Var=Val:SetValue=Val
	end if
End Function

'�Ƚ�2�������Ƿ���ͬ
Function varComp(ByVal var1,ByVal var2)
	if typename(var1)<>typename(var2) then:varComp=false:exit function:end if
	if typename(var1)="Object" then:varComp=var1 is var2:exit function:end if
	if typename(var1)="Variant()" then:varComp=join(var1,"$")=join(var2,"$"):else:varComp=var1=var2:end if
End Function

Function Random()
	Randomize():Random=Rnd
End Function

Sub Push(ByRef Arr,ByRef Val)
	on Error resume next
	Dim l:l=UBound(Arr)+1:l=ifthen(err,0,l):ReDim Preserve Arr(l)
	if isObject(Val) then:SET Arr(l)=Val:else:Arr(l)=Val:end if
End Sub

Function Pop(ByRef Arr)
	dim l:l=UBound(Arr)
	on Error resume next
	SetValue Pop,Arr(l)
	ReDim Preserve Arr(l-1)
End Function

Function unShift(ByRef Arr)
	dim i,t:t=array()
	on Error resume next
	SetValue unShift,Arr(0)
	For i=1 to UBound(Arr):Push t,Arr(i):Next:ReDim Arr(-1):Arr=t
End Function

Function concat(ByVal Arr1,ByVal Arr2)
	dim i
	for i=0 to Ubound(Arr2)
		Push Arr1,Arr2(i)
	next
	concat = Arr1
End Function

'������Ա	Start��ʼλ��	��������
Function Splice(ByRef Arr,ByVal Start,ByVal Length)
	Splice=jsSplice(Arr,Start,Length,null)
End Function

Function jsSplice(ByRef Arr,ByVal Start,ByVal Length,ByVal arg)
	Dim ret,i,t,al,iEnd:iEnd=Start+Length:al=Ubound(Arr):t=array():ret=array()
	for i=Start to iEnd-1:Push ret,Arr(i):next
	for i=iEnd to al:Push t,Arr(i):next
	ReDim Preserve Arr(Start-1)
	if IsArray(arg) then:for i=0 to UBound(arg):Push Arr,arg(0):next:end if
	for i=0 to UBound(t):Push Arr,t(i):next
	jsSplice=ret
End Function

Function array_unique(ByVal arr)
	dim i,j,ret,bol:ret=array()
	for i=0 to UBound(arr)
		bol=true
		for j=UBound(ret) to 0 step -1
			if varComp(arr(i),ret(j)) then
				bol=false
				exit for
			end if
		next
		if bol then
			Push ret,arr(i)
		end if
	next
	array_unique=ret
End Function

Function array_reverse(ByVal arr)
	dim i,ret:ret=array()
	for i=UBound(arr) to 0 step -1
		Push ret,arr(i)
	next
	array_reverse=ret
End Function

Function getFileTime(Byval Path)
	Path=Server.MapPath(Path)
	if objFso.FileExists(Path) then
		Dim f:SET f=objFso.getFile(Path)
		getFileTime=f.DateLastModified:SEt f=nothing
	else
		getFileTime="N/A"
	end if
End Function

Function jsCharAt(ByVal Str,ByVal iIndex)
	jsCharAt=jsSubstr(Str,iIndex,1)
End Function

Function jsCharAtCode(ByVal Str,ByVal iIndex)
	jsCharAtCode=Asc(jsSubstr(Str,iIndex,1))
End Function

Function jsIndexOf(ByVal Str,ByVal substr)
	Dim Pos:Pos=inStr(chr(0)&Str,substr):jsIndexOf=IfThen(Pos=0,-1,Pos-1)
End Function

Function jsSubstr(ByVal Str,ByVal Start,ByVal Length)
	if Length<0 then:Length=0:end if:jsSubstr=Mid(Str,Start+1,Length)
End Function

Function jsSlice(ByVal Str,ByVal Start,ByVal iEnd)
	If Start<0 Then:Start=len(Str)+Start:end if:If iEnd<1 Then:iEnd=len(Str)+iEnd:end if:jsSlice=jsSubstr(Str,Start,iEnd-Start)
End Function

Function isString(ByVal Val)
	isString=typename(Val)="String"
End Function

Function isBool(ByVal Val)
	isBool=typename(Val)="Boolean"
End Function

Function IfThen(ByVal Bool, Byval A,ByVal B)
	if Bool=true then
		SetValue IfThen,A
	else
		SetValue IfThen,B
	end if
End Function

'ȫ��RegExp
Dim gRegExp:gRegExp=null
Function getGRegExp(ByVal Pattern)
	if typename(gRegExp) <> "RegExp" then:SET gRegExp=new RegExp:end if
	SetRegExpAttribute gRegExp,jsPattern(Pattern)
	SET getGRegExp=gRegExp
End Function

Sub SetRegExpAttribute(ByRef oRegExp,ByVal aAtt)
	dim e,pattern:pattern=aAtt(0):e=" "&aAtt(1):with oRegExp:.IgnoreCase=inStr(e,"i")>0:.Global=inStr(e,"g")>0:.Multiline=inStr(e,"m")>0:.Pattern=pattern:end with
End Sub

Function jsPattern(ByVal Pattern)
	Dim rp,mt:rp=InstrRev(Pattern,"/"):mt=right(Pattern,len(Pattern)-rp):Pattern=Mid(Pattern,2,rp-2)
	jsPattern=array(Pattern,mt)
End Function

Function jsRegExp(ByVal Pattern)
	SET jsRegExp=new RegExp:SetRegExpAttribute jsRegExp,jsPattern(Pattern)
End Function

Function RegExpExec(ByVal Str,ByVal Pattern)
	Dim i,m,ms:RegExpExec=array()
	on Error resume next
	SET ms=getGRegExp(Pattern).execute(Str)
	for each m in ms
		for i=0 to m.submatches.count-1:Push RegExpExec,m.submatches(i):next
	next
End Function

Function RegMatchesCount(ByVal Str,ByVal Pattern)
	RegMatchesCount=getGRegExp(Pattern).execute(Str).count
End Function

'�����滻
Function RegReplace(ByVal Str, ByVal Pattern, ByVal rStr)
	on Error resume next
	if Str="" then:RegReplace="":exit function:end if
	Dim rg,m,ms:SET rg=getGRegExp(Pattern)
	if rg.test(Str) then
		RegReplace=rg.Replace(Str,rStr)
	else
		RegReplace=Str
	end if
End Function

'���ӹ��ܺ���
'б��ת��
Function addcslashes(ByVal str)
	addcslashes=RegReplace(str,"/([\(\)\[\]\""\'\.\?\+\-\*\/\\\^\$])/ig","\$1")
End Function

Function stripcslashes(ByVal str)
	stripcslashes=RegReplace(str,"/\\([\(\)\[\]\""\'\.\?\+\-\*\/\\\^\$])/ig","$1")
End Function

Function TrimAll(ByVal Str)
	TrimAll=regReplace(Str,"/(\s*)/g","")
End Function

Function Trim(ByVal Str)
	Trim=regReplace(Str,"/(^\s*)|(\s*$)/g","")
End Function

Function LTrim(ByVal Str)
	LTrim=regReplace(Str,"/(^\s*)/g","")
End Function

Function RTrim(ByVal Str)
	RTrim=regReplace(Str,"/(\s*$)/g","")
End Function
'�Ƚ��ı�
Function StrComp(ByVal Str1,ByVal Str2,ByVal bool)
		Str1=IfThen(CBool(bool)<>true,UCase(Str1),Str1):Str2=IfThen(CBool(bool)<>true,UCase(Str2),Str2)
		StrComp=IfThen(Str1>Str2,1,IfThen(Str1<Str2,-1,0))
End Function

Function TEST_HTTP_REFERER()
	on error resume next
	if isBool(Application("TEST_HTTP_REFERER")) then:TEST_HTTP_REFERER=Application("TEST_HTTP_REFERER"):exit function:end if
	if GetForm("FUNC", "get")<>"" then
		die Request.ServerVariables("ALL_HTTP")
	else
		TEST_HTTP_REFERER=jsIndexOf(GetHttpTextFile("http://res.cmsplugin.net/out_all_http/?action=TEST_HTTP_REFERER&FUNC=true","gbk"),"HTTP_REFERER")<>-1:Application("TEST_HTTP_REFERER")=TEST_HTTP_REFERER
	end if
	err.clear
End Function

'��ȡ�ı��м�
Function StrSlice(ByVal Str,ByVal sStr,ByVal eStr)
	if eStr="" then:StrSlice="":exit function:end if
	Dim tStr,iPos,sLen:tStr=LCase(Str):iPos=JsIndexOf(tStr,LCase(sStr)):sLen=Len(sStr):StrSlice=""
	if iPos=-1 then exit function:end if
	iPos=ifthen(sLen>0,iPos+sLen,1):StrSlice=jsSubstr(Str,iPos-1,JsIndexOf(jsSlice(tStr,iPos-1,0),LCase(eStr))-1)
End Function

'��ȡ�ı��м�B ���Χ
Function StrSliceB(ByVal Str,ByVal sStr,ByVal eStr)
	if sStr&eStr="" then:StrSliceB=Str:exit function:end if
	Dim tStr,iPos,sLen:tStr=LCase(Str):iPos=JsIndexOf(tStr,LCase(sStr)):sLen=Len(sStr):StrSliceB=""
	if iPos=-1 then exit function:end if
	iPos=ifthen(sLen>0,iPos+sLen,1)
	if eStr="" then
		StrSliceB=jsSlice(Str,iPos-1,0)
	else
		tStr=jsSlice(tStr,iPos,0):StrSliceB=jsSubstr(Str,iPos-1,InstrRev(tStr,LCase(eStr)))
	end if
End Function

'�ָ��ı���
Function StrSplits(ByVal Str,ByVal sStr,ByVal eStr)
	if eStr="" OR Str="" then:StrSplits=array():exit function:end if
	Dim ret,iPos,ePos,sLen,eLen,tStr:ret=array():tStr=LCase(Str):sStr=LCase(sStr):eStr=LCase(eStr):sLen=Len(sStr):eLen=Len(eStr)
	do while true
		iPos=JsIndexOf(tStr,sStr):if iPos=-1 then:exit do:end if
		iPos=ifthen(sLen>0,iPos+sLen,1):tStr=jsSlice(tStr,iPos-1,0)
		ePos=JsIndexOf(tStr,eStr):if ePos=-1 then:exit do:end if
		Push ret,jsSubstr(Str,iPos-1,ePos-1):tStr=jsSlice(tStr,ePos+eLen-1,0):Str=jsSlice(Str,iPos+ePos+eLen-2,0)
	loop
	StrSplits=ret
End Function

Function HTMLEncode(ByVal HTMLStr)
	HTMLEncode = Server.HTMLEncode(HTMLStr)
ENd Function

'HTTP���ļ�
Function GetHttpFile(ByVal url)
	url=Replace(""&url,"&amp;","&"):if not isObject(gHttpObj) then:SET gHttpObj=tryXmlHttp():end if:gHttpObj.open "GET",url,False:gHttpObj.setRequestHeader "referer",url:gHttpObj.send:GetHttpFile=gHttpObj.responseBody
End Function

'HTTP���ı��ļ�
Function GetHttpTextFile(ByVal url,ByVal charset)
	GetHttpTextFile=bytesToStr(GetHttpFile(url),ifThen(charset<>"",charset,"gbk"))
End Function

Function paseAbsURI(ByVal Links,ByVal currUrl)
	Links=ifthen(isArray(Links),Links,Array(Links))
	on Error Resume Next
	Dim t,H,i,j,k,rg,ab,qt,Pb,siteUrl
	SET rg=jsRegExp("/^\s*[\/\\]/i"):SET ab=jsRegExp("/^http:\/\//i"):SET qt=jsRegExp("/\\([\\\/])/ig"):
	currUrl=qt.replace(trim(currUrl),"/"):siteUrl=RegReplace(currUrl,"/(https?\:\/\/)((\w+)(\.\w+)*(:\d+)?)\/.*/i","$1$2"):currUrl=replace(currUrl,siteUrl,"")
	for i=0 to Ubound(Links)
		H=CStr(Links(i))
		if not ab.test(H) then
			if rg.test(H) then:Links(i)=siteUrl&H:else:j=UBound(split(H,"../"))+1:t=Split(currUrl,"/"):k=Ubound(t)+1:j=ifthen(j<k,k-j,0)-1:ReDim Preserve t(j):Links(i)=siteUrl&Join(t,"/")&"/"&RegReplace(H,"/([\.]{2}\/)/g",""):end if
		end if
	next
	paseAbsURI=Links
	SET rg=nothing:SET ab=nothing:SET pb=nothing:SET qt=nothing
End Function

Function Str2Num(ByVal sNum)
	if not isNumeric(sNum) then:Str2Num=0:exit function:end if
	dim x:x=CDBL(sNum)
	if jsIndexOf(sNum,".")<>-1 OR (x<-2147483647 AND x>2147483647) then:Str2Num=CDbl(sNum):exit function:end if
	if x>-32768 AND x<32768 then:Str2Num=CInt(sNum):else:Str2Num=CLng(sNum):end if
End Function

Function stepBatchUrl(ByVal Url,Byval ValStr, ByVal iStart, ByVal iEnd, ByVal iSize, ByVal iPage, ByVal Order)
	dim i,j,ret:iPage=iSize*iPage:ret=array()
	if Order = true then
		for i=iEnd-iPage to iStart step -1
			Push ret,Replace(Url,ValStr,i)
			j=j+1:if j>=iSize then:exit for:end if
		next
	else
		for i=iStart+iPage to iEnd
			Push ret,Replace(Url,ValStr,i)
			j=j+1:if j>=iSize then:exit for:end if
		next
	end if
	stepBatchUrl=ret
End Function

'��������
Function SpecialLink(ByVal sLink,ByVal fLink,ByVal rLink)
	Dim t,i:t=split(fLink,"[����]")
	if UBound(t)<1 then
		SpecialLink=sLink
	else
		rLink=join(split(rLink,"[����]"),"$1")
		For i=0 to UBound(t):t(i)=addcslashes(t(i)):Next
		SpecialLink=RegReplace(sLink,"/"&Join(t,"([\w\W]+)")&"/ig",rLink)
	end if
End Function

Function SpecialLinks(ByVal aLinks,ByVal fLink,ByVal rLink)
	Dim t,i:t=split(fLink,"[����]")
	if UBound(t)<1 then
		SpecialLinks=aLinks
	else
		rLink=Join(split(rLink,"[����]"),"$1")
		For i=0 to UBound(t):t(i)=addcslashes(t(i)):Next
		fLink=Join(t,"([\w\W]+)")
		for i=0 to UBound(aLinks)
			aLinks(i)=RegReplace(aLinks(i),"/"&fLink&"/ig",rLink)
		next
		SpecialLinks=aLinks
	end if
End Function

Function RemoveHTMLCode(ByVal Str,ByVal cHas)
	Str=""&Str:if cHas="" OR Str="" then:RemoveHTMLCode=Cstr(Str):exit function:end if
	Dim i:cHas=split(trimall(UCASE(cHas)),"|")
	for i=0 to UBound(cHas)
		SELECT CASE cHas(i)
			CASE "TABLE":Str=RegReplace(Str,"/<\/?(table|thead|tbody|tr|th|td).*>/ig","")
			CASE "OBJECT":Str=RegReplace(Str,"/<\/?(object|param|embed).*>/ig","")
			CASE "SCR"&"IPT":Str=RegReplace(Str,"/<scr"&"ipt.*>[\w\W]+?<\/scr"&"ipt>/ig",""):Str=RegReplace(Str,"/on[\w]+=[\'\""].+?[\'\""](\s|>)/ig","$1")
			CASE "STYLE":Str=RegReplace(Str,"/<style.*>[\w\W]+?<\/style>/ig","")
			CASE "CLASS":Str=RegReplace(Str,"/\sclass=.+?(\s|>)/ig","")
			CASE "*":Str=RemoveHTMLCode(Str,"SCR"&"IPT|STYLE"):Str=RegReplace(Str,"/<.*?>/ig",""):Str=Replace(Replace(Str,"<","&lt;"),">","&gt;")
			CASE ELSE:Str=RegReplace(Str,"/<\/?"&addcslashes(cHas(i))&".*?>/ig","")
		End SELECT
	next
	RemoveHTMLCode=Replace(Str,"&nbsp;"," ")
End Function

Function ConnectTempDataBase
	dim tPath:tPath=accessFilePath:accessFilePath=ENGINEDIR&TEMPDATABASEFILENAME:SET ConnectTempDataBase=mainClassobj.createObject("MainClass.DB"):ConnectTempDataBase.dbType="acc":ConnectTempDataBase.connect():accessFilePath=tPath
End Function

Function LoadWord()
	LoadWord=""
End Function

Function filterQuote(Byval Str)
	filterQuote=replace(""&Str,"'","")
End Function

Function filterWord(Byval Str,ByVal rCol)
	dim i:Str=""&Str
	if Str="" then:filterWord=Str:exit function:end if
	if NOT IsArray(tDic) then
		if NOT isObject(tConn) then:SET tConn=ConnectTempDataBase():end if
		tDic=tConn.db("SELECT rColumn,uesMode,sFind,sReplace,sStart,sEnd FROM {pre}fWord WHERE Flag=true","array")
	end if
	if IsArray(tDic) then
		for i=0 to UBound(tDic,2)
			if tDic(0,i)=rCol then
				if tDic(1,i)=1 then
					if tDic(4,i)&tDic(5,i) <> "" then:Str=RegReplace(Str,"/"&addcslashes(tDic(4,i))&"([\w\W]+?)"&addcslashes(tDic(5,i))&"/ig",tDic(3,i)):end if
				else
					if tDic(2,i)<>"" then:Str=replace(Str,tDic(2,i),tDic(3,i)):end if
				end if
			end if
		next
	end if
	filterWord=Str
End Function

Function ClassID2Name(ByVal iClsID)
	if NOT isObject(tTypeDic) then
		dim t,i:SET tTypeDic=Object()
		t = conn.db("select m_id,m_name from {pre}type WHERE m_type=0 order by m_id asc","array")
		if IsArray(t) then
			for i=0 to UBound(t,2)
				tTypeDic(CStr(t(0,i)))=t(1,i)
			next
		end if
	end if
	ClassID2Name=tTypeDic(CStr(iClsID))
End Function

Function NewsClassID2Name(ByVal iClsID)
	if NOT isObject(tnTypeDic) then
		dim t,i:SET tnTypeDic=Object()
		t = conn.db("select m_id,m_name from {pre}type WHERE m_type=1 order by m_id asc","array")
		if IsArray(t) then
			for i=0 to UBound(t,2)
				tnTypeDic(CStr(t(0,i)))=t(1,i)
			next
		end if
	end if
	NewsClassID2Name=tnTypeDic(CStr(iClsID))
End Function

Function gatherIntoLibTransfer(Byval data,Byval str,Byval typeset)
	dim transtr,str1,str2,str1Array,str2Array,m,n,j,k,x:str1=trim(data):str2=trim(str)
	if  str1<>"" and str2<>"" then
		select case typeset
			case 0
				str1Array=split(str1,"$$$"):str2Array=split(str2,"$$$"):m=ubound(str1Array):n=ubound(str2Array)
				for k=0 to n
					x=findIsExistFrom(str1Array,split(str2Array(k),"$$")(0))
					if isNum(x) then 
						str1Array(x)=str2Array(k)
					else
						transtr=transtr&str2Array(k)&"$$$"
					end if				
				next
				for j=0 to m
					transtr=transtr&str1Array(j)&"$$$"
				next
				transtr = trimOuterStr(transtr,"$$$")
			case 1
				transtr=str&"$$$"&data
			case 2
				transtr=data&"$$$"&str
			case 3
				transtr=str
		end select
	else
		transtr=ifthen(str1<>"",str1,str2)
	end if
	gatherIntoLibTransfer=transtr
End Function

Function findIsExistFrom(array1,from)
	dim i,m:m=ubound(array1):findIsExistFrom=""
	for i=0 to m
		if trim(split(array1(i),"$$")(0))=trim(from) then
			findIsExistFrom=i:Exit Function
		end if
	next
End Function

'���ܹ���(sClsName ����,mName ��Ƶ��)
Function smartGeneralize(ByVal sClsName,ByVal mName)
	dim i,aTitle,Q_WHERE,tRs,kPre:sClsName=filterQuote(trim(sClsName)):mName=filterQuote(filterWord(trim(mName),0)):Q_WHERE=array():kPre="SG.":smartGeneralize=0
	if sClsName="" AND mName="" then:exit function:end if
	if NOT isObject(tQuery) then:SET tQuery=Object():end if
	if tQuery.Exists(kPre&sClsName) then:smartGeneralize=tQuery(kPre&sClsName):exit function:end if
	if tQuery.Exists(kPre&mName) then:smartGeneralize=tQuery(kPre&mName):exit function:end if
	if NOT isObject(tConn) then:SET tConn=ConnectTempDataBase():end if
	if sClsName<>"" then
		SET tRs=tConn.db("SELECT TOP 1 sysClsID FROM {pre}cls WHERE clsName='"&sClsName&"'","execute")
		if not tRs.eof then:smartGeneralize=tRs("sysClsID"):end if
		tRs.Close:SET tRs=Nothing
	end if
	if smartGeneralize>0 then:tQuery(kPre&sClsName)=smartGeneralize:exit function:end if
	aTitle=split(mName,"/")
	for i=0 to UBound(aTitle)
		if not isNULL(aTitle(i)) then:Push Q_WHERE,"'/'+m_name+'/' LIKE '%/"&aTitle(i)&"/%'":end if
	next
	if Ubound(Q_WHERE)>-1 then
		Q_WHERE=Join(Q_WHERE," OR ")
		SET tRs=tConn.db("SELECT TOP 1 m_type FROM {pre}tempdata WHERE "&Q_WHERE,"execute")
		if not tRs.eof then:smartGeneralize=tRs("m_type"):end if
		tRs.Close:SET tRs=Nothing
		if smartGeneralize=0 then
			SET tRs=Conn.db("SELECT TOP 1 m_type FROM {pre}data WHERE "&Q_WHERE,"execute")
			if not tRs.eof then:smartGeneralize=tRs("m_type"):end if
			tRs.Close:SET tRs=Nothing
		end if
	end if
	if smartGeneralize=0 AND sClsName<>"" then
		SET tRs=Conn.db("SELECT TOP 1 m_id FROM {pre}type WHERE m_type=0 AND m_name LIKE '"&sClsName&"%'","execute")
		if not tRs.eof then:smartGeneralize=tRs("m_id"):end if
		tRs.Close:SET tRs=Nothing
	end if
	tQuery(kPre&mName)=smartGeneralize
End Function

'���ܹ���(sClsName ����)
Function newssmartGeneralize(ByVal sClsName)
	dim i,aTitle,Q_WHERE,tRs,kPre:sClsName=filterQuote(trim(sClsName)):Q_WHERE=array():kPre="SG.":smartGeneralize=0
	if sClsName="" then:exit function:end if
	if NOT isObject(tQuery) then:SET tQuery=Object():end if
	if tQuery.Exists(kPre&sClsName) then:newssmartGeneralize=tQuery(kPre&sClsName):exit function:end if
	if NOT isObject(tConn) then:SET tConn=ConnectTempDataBase():end if
	if sClsName<>"" then
		SET tRs=tConn.db("SELECT TOP 1 sysClsID FROM {pre}newscls WHERE clsName='"&sClsName&"'","execute")
		if not tRs.eof then:newssmartGeneralize=tRs("sysClsID"):end if
		tRs.Close:SET tRs=Nothing
	end if
	if newssmartGeneralize>0 then:tQuery(kPre&sClsName)=newssmartGeneralize:exit function:end if
	if newssmartGeneralize=0 AND sClsName<>"" then
		SET tRs=Conn.db("SELECT TOP 1 m_id FROM {pre}type WHERE m_type=1 AND m_name LIKE '"&sClsName&"%'","execute")
		if not tRs.eof then:newssmartGeneralize=tRs("m_id"):end if
		tRs.Close:SET tRs=Nothing
	end if
	tQuery(kPre&mName)=newssmartGeneralize
End Function

Function repairStr(vstr,formstr)
	dim regExpObj : set regExpObj= new RegExp : regExpObj.ignoreCase = true : regExpObj.Global = true : regExpObj.Pattern = "[\s\S]+?\$[\s\S]+?\$[\s\S]+?"
	dim mystr,i,j : j=1:vstr=""&vstr
	vstr = replace(vstr,chr(10),"")
	vstr = split(vstr,chr(13))
	for i = 0  to ubound(vstr)
		if not(isnul(vstr(i))) then
			if regExpObj.Test(vstr(i)) = false then 
				regExpObj.Pattern = "[\s\S]+?\$[\s\S]+?"
				if regExpObj.Test(vstr(i)) = true then 
					mystr = mystr&trim(vstr(i))&"$"&formstr&chr(13)&chr(10)
				else
					mystr = mystr&"��"&j&"��$"&trim(vstr(i))&"$"&formstr&chr(13)&chr(10)
				end if 
				regExpObj.Pattern = "[\s\S]+?\$[\s\S]+?\$[\s\S]+?"
			else 
				mystr = mystr&trim(vstr(i))&chr(13)&chr(10)
			end if 
			j=j+1
		end if 
	next
	repairStr = mystr
	set regExpObj =nothing
End Function

Function repairUrlForm(vstr,formstr)
	dim strlen,formlen,str,fstr,rstr,i
	str = split(trimOuterStr(vstr,","),", ") : strlen = ubound(str)
	fstr = split(trimOuterStr(formstr,","),", ") : formlen  = ubound(fstr)
	if strlen <> formlen then 
		'die "δΪÿ������ѡ��������Դ"
	else
		for i=0 to strlen
			 if  trim(str(i))<>"" then:rstr = rstr&repairStr(str(i),getReferedId(fstr(i)))&", ":else:rstr = rstr&", ":end if
		next
	end if
	repairUrlForm = trimOuterStr(rstr,", ")
End Function

Function replaceSpecial(Byval str)
	replaceSpecial=replaceStr(str,"'","""")
End Function

Function repairDownUrl(vstr,formstr)
	dim strlen,formlen,str,fstr,rstr,i
	str = split(trimOuterStr(vstr,","),", ") : strlen = ubound(str)
	fstr = split(trimOuterStr(formstr,","),", ") : formlen  = ubound(fstr)
	if strlen <> formlen then
		die "δΪÿ��������ѡ��������Դ"
	else
		for i=0 to strlen
			if  trim(str(i))<>"" then:rstr = rstr&repairStr(str(i),"down")&", " else rstr = rstr&", ":end if
		next
	end if
	repairDownUrl = trimOuterStr(rstr,", ")
End Function

Function transferUrl(Byval fromStr,Byval playStr)
	dim fromLen,playLen,fromArray,playArray,i,resultStr
	if isNul(fromStr) and isNul(playStr) then:transferUrl="":exit function:end if
	fromStr=replaceStr(fromStr,"$$","") : playStr=replaceStr(replaceStr(playStr,"#",""),"$$","")
	playStr=replaceStr(playStr,chr(10),"")
	playStr=replaceStr(playStr,chr(13),"#")
	playStr=trimOuterStr(playStr,"#")
	fromStr=trimOuterStr(fromStr,",") : playStr=trimOuterStr(playStr,",") 
	fromArray=split(fromStr,", ") : fromLen=ubound(fromArray)
	playArray=split(playStr,", ") : playLen=ubound(playArray)
	if fromLen<>playLen then:die "��Դ���ߵ�ַû����д����":end if
	if fromLen=0 then
		transferUrl=trim(fromArray(0))&"$$"&trim(playArray(0)):exit function
	end if
	for i=0 to fromLen
		if not isNul(fromArray(i)) and  not isNul(playArray(i))  then
			resultStr=trim(resultStr)&trim(fromArray(i))&"$$"&trim(trimOuterStr(playArray(i),"#"))&"$$$"
		else
			if isNul(fromArray(i)) and not isNul(playArray(i)) then:die "��Դû����д����":end if
		end if 
	next
	transferUrl=trimOuterStr(resultStr,"$$$")
End Function

'��Ƶ���(mCls Object,iMode ��ⷽʽ,eMode ���浱ǰģʽ)
' mCls Լ����ӰƬ��Ϣ�ֶ���:	"����",	"ӰƬ��ַ����",	"��Դ",			"����",		"��Ա",		"����ID",	"������",		"����",			"����",			"��ע",		"ͼƬ",	"����",		"����״̬",	"��ʼ�����",	"�ؼ���",	"��ʼ������",	"���",			"������ɫ",	"�Ǽ�",		"��ʼ�ȴ���",	"ר��ID"

Function movieStorage(ByVal mdCls,ByVal iMode,ByVal eMode)
	dim l,Q_WHERE,dConn,tRs,sql,tablename,hFid,tFid,i,aTitle,moviesrcs,partnames,playfrom:Q_WHERE=array()
	if UCASE(typename(mdCls)) <>"DICTIONARY" then:Err.Raise 13,"","���Ͳ�ƥ ��һ�������봫�� �� ����ӰƬ��Ϣ��() ���ص�ֵ":exit Function:end if
	iMode=Str2Num(iMode):eMode=Str2Num(eMode)
	hFid=Array("����",	"ӰƬ��ַ",	"ӰƬ����",	"��Դ",			"����",		"��Ա",		"����ID",	"������",		"����",			"����",			"��ע",		"ͼƬ",	"����",		"����״̬",	"��ʼ�����",	"�ؼ���",	"��ʼ������",	"���",			"������ɫ",	"�Ǽ�",		"��ʼ�ȴ���",	"ר��ID",	"����",	"����")
	tFid=Array("fromurl",	"moviesrcs",	"partnames",	"playfrom",		"name",		"actor",	"type",		"typename",		"addtime",		"publisharea",	"note",		"pic",	"des",		"state",	"hit",			"keyword",	"digg",			"publishyear",	"color",	"commend",	"tread",	"topic",	"lang",	"director")
	dim mCls:SET mCls=Object()
	for i=0 to UBound(tFid)
		if mdCls.Exists(hFid(i)) then
			mCls(tFid(i))=mdCls(hFid(i))
		else
			if mdCls.Exists(tFid(i)) then:mCls(tFid(i))=mdCls(tFid(i)):end if
		end if
	next
	playfrom = replace(replace(filterQuote(mCls("playfrom")),"#",""),"$",""):mCls.Remove("playfrom")
	mCls("name")= replace(replace(filterQuote(replace(trim(mCls("name")),"\","/")),"[","��"),"]","��")
	if not isNumeric(mCls("type")) then:mCls("type")=smartGeneralize(mCls("type"),mCls("name")):end if
	tFid=Array("typename","from","addtime","publisharea","note","pic","lang","color","keyword","director")
	for i=0 to UBound(tFid)
		if mCls.Exists(tFid(i)) then:mCls(tFid(i)) = trim(mCls(tFid(i))):end if
	next
	tFid=Array("state","hit","digg","publishyear","tread","topic","commend")
	for i=0 to UBound(tFid)
		if mCls.Exists(tFid(i)) then:mCls(tFid(i)) = Str2Num(mCls(tFid(i))):end if
	next
	if mCls.Exists("actor") then
		mCls("actor") = RegReplace(trim(mCls("actor")),"/\s+/g",",")
		if computeStrLen(mCls("actor"))>250 then:mCls("actor")=getStrByLen(mCls("actor"),250):end if
	end if
	if computeStrLen(mCls("name"))>115 then:mCls("name")=getStrByLen(mCls("name"),115):end if
	if computeStrLen(mCls("typename"))>50 then:mCls("typename")=getStrByLen(mCls("typename"),50):end if
	if eMode<2 then:movieStorage=true:exit function:end if
	aTitle=split(mCls("name"),"/")
	for i=0 to UBound(aTitle)
		if not isNULL(aTitle(i)) then:Push Q_WHERE,"'/'+m_name+'/' LIKE '%/"&aTitle(i)&"/%'":end if
	next
	if Ubound(Q_WHERE)=-1 then:movieStorage=false:exit function:end if
	Q_WHERE=Join(Q_WHERE," OR ")
	if iMode=1 AND Str2Num(mCls("type"))<>0 then
		tablename="{pre}data":SET dConn=conn
	else
		if NOT isObject(tConn) then:SET tConn=ConnectTempDataBase():end if
		iMode=0:tablename="{pre}tempdata":Q_WHERE=ifthen(not isNull(mCls("fromurl")),"m_fromurl='"&mCls("fromurl")&"' OR ","")&Q_WHERE:SET dConn=tConn
	end if
	if iMode<>0 then
		mCls.remove("from"):mCls.remove("typename")
	else
		mCls("inbase")=0
	end if
	moviesrcs=mCls("moviesrcs"):mCls.remove("moviesrcs")
	partnames=mCls("partnames"):mCls.remove("partnames")
	if isArray(moviesrcs) then
		l=UBound(moviesrcs)
		if l<>-1 then
			if isArray(partnames) then
				if UBound(partnames)<>l then:ReDim Preserve partnames(l):end if
				for i=0 to l:moviesrcs(i)=ifthen(jsIndexOf(moviesrcs(i),"$")=-1,Replace(""&partnames(i),",","")&"$"&moviesrcs(i),moviesrcs(i)):next
			end if
			moviesrcs = repairUrlForm(join(moviesrcs,vbcrlf),playfrom)
		else
			moviesrcs = ""
		end if
	else
		moviesrcs=ifthen(not isNULL(moviesrcs),moviesrcs,"")
	end if
	if moviesrcs<>"" then:mCls("playdata")= transferUrl(playfrom,moviesrcs):end if
	mCls("enname")	= MoviePinYin(mCls("name"))
	mCls("letter")	= Left(mCls("enname"),1)
	SET tRs=dConn.db("SELECT TOP 1 m_id,m_playdata,m_state,m_type,m_pic FROM "&tablename&" WHERE "&Q_WHERE,"execute")
	if tRs.eof then
		mCls("datetime") = mCls("addtime")
		sql="INSERT INTO "&tablename&" "&mCls2SQL(mCls,0)
	else
		Dim ADDSET:ADDSET=""
		if gatherSet<>4 then
			if mCls.Exists("state") then:ADDSET=",m_state="&ifthen(mCls("state")>tRs("m_state"),mCls("state"),tRs("m_state")):mCls.remove("state"):end if
			if mCls.Exists("note") then:ADDSET=ADDSET&",m_note='"&filterQuote(mCls("note"))&"'":mCls.remove("note"):end if
			if mCls.Exists("inbase") then:ADDSET=ADDSET&",m_inbase=0":mCls.remove("inbase"):end if:mCls("type")=ifthen(tRs("m_type")<>0,tRs("m_type"),Str2Num(mCls("type")))
			if mCls.Exists("pic") AND trim(""&tRs("m_pic"))="" then:ADDSET=ADDSET&",m_pic='"&filterQuote(mCls("pic"))&"'":mCls.remove("pic"):end if
		end if
		select case gatherSet
			case 0,1,2,3
				mCls("playdata") = gatherIntoLibTransfer(tRs("m_playdata"),mCls("playdata"),gatherSet)
				sql="UPDATE "&tablename&" SET m_name='"&filterQuote(mCls("name"))&"',m_type="&mCls("type")&",m_playdata='"&filterQuote(mCls("playdata"))&"'"&ifthen(isDate(mCls("addtime")),",m_addtime='"&mCls("addtime")&"'","")&ADDSET&" WHERE m_id="&tRs("m_id")
			case 4
				mCls("datetime") = mCls("addtime")
				sql="INSERT INTO "&tablename&" "&mCls2SQL(mCls,0)
			case 5
				mCls.remove("hit"):mCls.remove("playdata"):sql="UPDATE "&tablename&" SET "&mCls2SQL(mCls,1)&ADDSET&" WHERE m_id="&tRs("m_id")
		end select
	end if
	tRs.close : SET tRs=nothing
	dConn.db sql,"execute"
End Function

'�������(mCls Object,iMode ��ⷽʽ,eMode ���浱ǰģʽ)
' mCls Լ������Ϣ�ֶ���:	"����",		"��Դ",			"����",		"����",		"����ID",	"������",		"����",			"����",		"ͼƬ",	"����",	"��ʼ�����",	"�ؼ���",	"��ʼ������",		"������ɫ",	"�Ǽ�",		"��ʼ�ȴ���",	"ר��ID"

Function newsStorage(ByVal mdCls,ByVal iMode,ByVal eMode)
	dim l,Q_WHERE,dConn,tRs,sql,tablename,hFid,tFid,i,aTitle,moviesrcs,partnames,playfrom:Q_WHERE=array()
	if UCASE(typename(mdCls)) <>"DICTIONARY" then:Err.Raise 13,"","���Ͳ�ƥ ��һ�������봫�� �� ����ӰƬ��Ϣ��() ���ص�ֵ":exit Function:end if
	iMode=Str2Num(iMode):eMode=Str2Num(eMode)
	hFid=Array("����",	"��Դ",			"����",		"����",		"����ID",	"������",		"����",			"����",		"ͼƬ",	"����",	"��ʼ�����",	"�ؼ���",	"��ʼ������",		"������ɫ",	"�Ǽ�",		"��ʼ�ȴ���",	"ר��ID")
	tFid=Array("fromurl",	"from",		"title",		"author",	"type",		"typename",		"addtime",	"outline",		"pic",	"content",	"hit",			"keyword",	"digg",	"color",	"commend",	"tread",	"topic")
	dim mCls:SET mCls=Object()
	for i=0 to UBound(tFid)
		if mdCls.Exists(hFid(i)) then
			mCls(tFid(i))=mdCls(hFid(i))
		else
			if mdCls.Exists(tFid(i)) then:mCls(tFid(i))=mdCls(tFid(i)):end if
		end if
	next
	mCls("title")= replace(replace(filterQuote(replace(trim(mCls("title")),"\","/")),"[","��"),"]","��")
	if not isNumeric(mCls("type")) then:mCls("type")=newssmartGeneralize(mCls("type"),mCls("title")):end if
	tFid=Array("typename","fromurl","from","author","addtime","outline","pic","color","keyword")
	for i=0 to UBound(tFid)
		if mCls.Exists(tFid(i)) then:mCls(tFid(i)) = trim(mCls(tFid(i))):end if
	next
	tFid=Array("hit","digg","tread","topic","commend")
	for i=0 to UBound(tFid)
		if mCls.Exists(tFid(i)) then:mCls(tFid(i)) = Str2Num(mCls(tFid(i))):end if
	next
	if computeStrLen(mCls("title"))>115 then:mCls("title")=getStrByLen(mCls("title"),115):end if
	if computeStrLen(mCls("typename"))>50 then:mCls("typename")=getStrByLen(mCls("typename"),50):end if
	if eMode<2 then:newsStorage=true:exit function:end if
	Push Q_WHERE,"m_title='"&mCls("title")&"'"
	Q_WHERE=Join(Q_WHERE," OR ")
	if iMode=1 AND Str2Num(mCls("type"))<>0 then
		tablename="{pre}news":SET dConn=conn
	else
		if NOT isObject(tConn) then:SET tConn=ConnectTempDataBase():end if
		iMode=0:tablename="{pre}tempnews":Q_WHERE=ifthen(not isNull(mCls("fromurl")),"m_fromurl='"&mCls("fromurl")&"' OR ","")&Q_WHERE:SET dConn=tConn
	end if
	if iMode<>0 then
		mCls.remove("fromurl"):mCls.remove("typename")
	else
		mCls("inbase")=0
	end if
	mCls("entitle")	= MoviePinYin(mCls("title"))
	mCls("letter")	= Left(mCls("entitle"),1)
	SET tRs=dConn.db("SELECT TOP 1 m_id,m_type FROM "&tablename&" WHERE "&Q_WHERE,"execute")
	if tRs.eof then
		mCls("datetime") = mCls("addtime")
		sql="INSERT INTO "&tablename&" "&nCls2SQL(mCls,0)
	else
		mCls("type")=ifthen(tRs("m_type")<>0,tRs("m_type"),Str2Num(mCls("type")))
		sql="UPDATE "&tablename&" SET "&nCls2SQL(mCls,1)&" WHERE m_id="&tRs("m_id")
	end if
	tRs.close : SET tRs=nothing
	dConn.db sql,"execute"
End Function

Function mCls2SQL(ByVal mCls,ByVal iType)
	Dim i,Keys,Vals:Keys=mCls.Keys:Vals=array()
	for i=0 to UBound(Keys)
		if Keys(i)<>"type" AND Keys(i)<>"hit" AND Keys(i)<>"state" AND Keys(i)<>"digg" AND Keys(i)<>"tread" AND Keys(i)<>"publishyear" AND Keys(i)<>"commend" AND Keys(i)<>"wrong" AND Keys(i)<>"topic" then
			Push Vals,"'"&filterQuote(mCls(Keys(i)))&"'"
		else
			Push Vals,mCls(Keys(i))
		end if
		Keys(i)=trim("m_"&filterQuote(Keys(i)))
	next
	if iType=0 then
		mCls2SQL="("&Join(Keys,", ")&")VALUES("&Join(Vals,", ")&")"
	else
		for i=0 to UBound(Keys)
			Vals(i)=Keys(i)&"="&Vals(i)
		next
		mCls2SQL = Join(Vals,", ")
	end if
End Function

Function nCls2SQL(ByVal mCls,ByVal iType)
	Dim i,Keys,Vals:Keys=mCls.Keys:Vals=array()
	for i=0 to UBound(Keys)
		if Keys(i)<>"type" AND Keys(i)<>"hit" AND Keys(i)<>"digg" AND Keys(i)<>"tread" AND Keys(i)<>"commend" AND Keys(i)<>"topic" then
			Push Vals,"'"&filterQuote(mCls(Keys(i)))&"'"
		else
			Push Vals,mCls(Keys(i))
		end if
		Keys(i)=trim("m_"&filterQuote(Keys(i)))
	next
	if iType=0 then
		nCls2SQL="("&Join(Keys,", ")&")VALUES("&Join(Vals,", ")&")"
	else
		for i=0 to UBound(Keys)
			Vals(i)=Keys(i)&"="&Vals(i)
		next
		nCls2SQL=Join(Vals,", ")
	end if
End Function

Function GatherTask()
	SET GatherTask=New TGatherTask
End Function

Class TGatherTask
	Private fDATA,fEvent
	Private Sub Class_Initialize()
		SET fEvent=Object():redim fDATA(-1)
	End Sub

	Private Sub Class_Terminate()
		SET fEvent=nothing
	End Sub

	Private Sub add2(Byval url)
		dim i:url=trim(url)
		for i=0 to UBound(fDATA)
			if not isString(url) OR fDATA(i)=url then
				exit Sub
			end if
		next
		if url<>"" AND url<>Empty then:Push fDATA,url:end if
	End Sub

	Public Sub add(ByVal vUrl)
		dim i
		if isArray(vUrl) then
			for i=0 to UBound(vUrl)
				add2 vUrl(i)
			next
		else
			add2 vUrl
		end if
	End Sub

	Public Function PopURL()
			if UBound(fDATA)<>-1 then:PopURL=unShift(fDATA):else:PopURL=Empty:end if
	End Function

	Public Function getUrls()
			getUrls = fDATA
	End Function

	Public Function Count()
			Count=UBound(fDATA)+1
	End Function

	Public Property LET onSuccess(ByVal OnFunName)
		fEvent.item("ONSUCCESS")=OnFunName
	End Property

	Public Property GET onSuccess()
		onSuccess=fEvent.item("ONSUCCESS")
	End Property

	Public Sub success(vHTML,vUrl)
		if NOT onSuccess=Empty then:execute("CALL "&Replace(onSuccess,"[arguments]","vHTML, vUrl")):end if
	End Sub

	Public Sub error(num,msg,url)
		if NOT onError=Empty then:execute("CALL "&Replace(onError,"[arguments]","num, msg, url")):end if
	End Sub

	Public Property LET onError(ByVal OnFunName)
		fEvent.item("ONERROR")=OnFunName
	End Property

	Public Property GET onError()
		onError=fEvent.item("ONERROR")
	End Property
End Class

Function GatHerProcess(ByVal ID,ByVal Mode)
	SET GatHerProcess=New TGatHerProcess:SET GatHerProcess.this=GatHerProcess
	GatHerProcess.id=ID:GatHerProcess.mode = Mode:if initStep>1 then:GatHerProcess.fstep = initStep:end if
End Function

Class TGatHerProcess
	Public Charset,this,fStep,Count,startTime,ID,iPage
	Private prefix,fENV,fInit,Inited,fonprogress,foncomplete,fMode,fMFile,fMfed,fPos,fItemSize,fIgnoreCount
	Private Sub Class_Initialize()
		prefix="TGATHERPROCESS.":SET fENV = Object():Inited=false:fMode=false:fStep=1:fonprogress=Empty:foncomplete=Empty:fPos=0:Count=0:fItemSize=1:fIgnoreCount=0:StartTime="":iPage=0
	End Sub

	Private Sub Class_Terminate()
	End Sub

	Private Sub writeCache(ByVal mode)
		on error resume next
		dim i,t,keys,b:OpenMFile:keys=fENV.keys:b=false
		for i=0 to UBound(keys)
			t=fENV(keys(i)).getUrls
			if UBound(t)>-1 then
				b=true:fMFile.item(keys(i))=t
			else
				fMFile.remove(keys(i))
			end if
			if mode=true then:fENV.remove(keys(i)):end if
		next
		fMFile.item("GT_INITED")=b:fMFile.item("GT_POS")=readPos:fMFile.item("GT_STARTTIME")=startTime:fMFile.item("GT_COUNT")=Count:fMFile.item("GT_ITEMSIZE")=fItemSize:fMFile.item("GT_IGNORECOUNT")=fIgnoreCount:fMFile.item("GT_IPAGE")=iPage
		CreateTextFile Json().var2json(fMFile),getJsonFilePath,"":if err then err.clear:end if
	End Sub

	Private Sub readCache()
		if Inited then:exit sub:end if:OpenMFile
		if fMFile.item("GT_INITED")=true then
			dim i,keys:keys=fENV.keys
			for i=0 to UBound(keys)
				if fMFile.Exists(keys(i)) then
					fENV.item(keys(i)).add(fMFile.item(keys(i)))
				end if
			next
			startTime=fMFile.item("GT_STARTTIME"):writePos fMFile.item("GT_POS"):Count=Str2Num(fMFile.item("GT_COUNT")):fItemSize=Str2Num(fMFile.item("GT_ITEMSIZE")):fIgnoreCount=Str2Num(fMFile.item("GT_IGNORECOUNT")):iPage=fMFile.item("GT_IPAGE"):Inited=true
		end if
	End Sub

	Private Sub OpenMFile()
		if fMfed<>true then
			fMfed=true:if not isObject(fMFile) then:SetValue fMFile,ParseJsonFile(getJsonFilePath):end if
			if not isObject(fMFile) then:SET fMFile=Object():end if
		end if
	End Sub

	Private Function readPos()
		readPos=fPos
	End Function

	Private Sub writePos(Byval Val)
		fPos=Str2Num(Val)
	End Sub

	Public Property GET itemSize()
		itemSize=fItemSize
	End Property

	Public Property LET itemSize(ByVal iSize)
		if iSize<>fItemSize AND fItemSize<>1 then:fIgnoreCount=fIgnoreCount+(fItemSize-iSize):end if:if iSize>fItemSize then:fItemSize=iSize:end if
	End Property

	Public Function CreateTask()
		dim i:i="#"&fENV.Count:SET CreateTask=GatHerTask():SET fENV.item(i)=CreateTask
	End Function

	Public Property GET getJsonFilePath()
		getJsonFilePath=ENGINEDIR&ESCACHEDIR&ID&".json"
	End Property

	Public Property LET onprogress(ByVal OnFunName)
		fonprogress=OnFunName
	End Property

	Public Property GET onprogress()
		onprogress=fonprogress
	End Property

	Public Sub progress(url)
		writePos readPos+1:if mode>=2 then:writeCache(false):end if
		if NOT onprogress=Empty then:execute("CALL "&Replace(onprogress,"[arguments]","fIgnoreCount,readPos,url")):end if
	End Sub

	Public Property LET oncomplete(ByVal OnFunName)
		foncomplete=OnFunName
	End Property

	Public Property GET oncomplete()
		oncomplete=foncomplete
	End Property

	Public Sub complete()
		if NOT oncomplete=Empty then:execute("CALL "&Replace(oncomplete,"[arguments]","")):end if
	End Sub

	Public Property LET Init(ByVal FunName)
		fInit=FunName
		if not isExistFile(ENGINEDIR&ESCDIR&ID) then:die "��Ч�� ����.ID	����ֵ #���̱�ʶID":end if
		if varComp(mode,false) then:die "δ����ִ��ģʽ ����.mode	����ֵ(#��ǰģʽ)":end if
		if mode=1 then:exit Property:end if
		if mode>=2 then:readCache:end if
		if NOT Inited AND NOT fInit=Empty then:execute("CALL "&Replace(fInit,"[arguments]","this")):end if
		if NOT Inited then:writePos(0):end if
		Start():if mode>=2 then:writeCache(true):end if
	End Property

	Public Property GET Init()
		Init=fInit
	End Property

	Public Property LET mode(Byval Val)
		dim msg:msg="����.mode ��Ч��ִ��ģʽ ��ѡֵ: #��ǰģʽ	#��ʾģʽ	#��ִ��	#ִ��ģʽ"
		'0.��ʾģʽ	1.��ִ��	2.ִ��ģʽ
		if not IsNumeric(Val) then:die msg:end if
		if Val<0 OR Val > 3 then:die msg:else:fMode=Val:end if
	End Property

	Public Property GET mode()
		mode=fMode
	End Property

	Private Sub Start()
		On Error Resume Next
		if fENV.count<1 then:exit Sub:end if
		dim item,Url,Keys,Key:Keys=fENV.Keys:Url=Empty
		do while IsClientConnected
			Key=Pop(Keys)
			if Key<>Empty then
				SET item=fENV.item(key):Url=item.PopUrl
			end if
			if Url<>Empty OR UBound(Keys)=-1 then:exit do:end if
		loop
		if Url=Empty then:exit Sub:end if
		progress(Url)
		Dim txt:txt=GetHttpTextFile(Url,Charset)
		if err.number=0 then
			item.success txt,Url
		else
			item.error err.number,err.description,Url:err.clear
		end if
		if mode=0 then:fENV.Remove(key):end if
		SET item=nothing
		if mode<>0 then:dim i,items,count:items=fENV.items:count=0:for i=0 to UBound(items):if isObject(items(i)) then:count=count+items(i).count:end if:next:if count=0 then:complete:end if:end if
		fStep=fStep-1:if fStep>0 OR mode=0 then:Start():end if
	End Sub

	Public Sub ExitRun(ByVal Msg)
		Msg=ifThen(Msg="","�ɼ����",Msg)
		if Msg<>"" then:echo "<script>alert('"&EnJsonString(Msg)&"');location.href='../admin_collect.asp?ChildDir="&StrSliceB(ID,"","/")&"';</script>":end if
	End Sub
End Class

Function Max(ByVal Num1,ByVal Num2)
	Max=ifthen(Str2Num(Num1)>Str2Num(Num2),Num1,Num2)
End Function

Function Json()
	Set Json=New JsonCls
End Function

Function ParseJsonFile(ByVal sJsonFile)
	SetValue ParseJsonFile,Json().parseFile(sJsonFile)
End Function

Function ParseJson(ByVal sJson)
	SetValue ParseJson,Json().json2var(sJson)
End Function

Function ReCrlf(ByVal txt)
	ReCrlf=ReplaceStr(ReplaceStr(txt,chr(10),"\n"),chr(13),"\r")
End Function

Function DeCrlf(ByVal txt)
	DeCrlf=ReplaceStr(ReplaceStr(txt,"\n",chr(10)),"\r",chr(13))
End Function

Function DeJsonString(ByVal txt)
	if isNul(txt) OR Len(txt)=0 then:DeJsonString="":exit function:end if
	if jsIndexOf(txt,"\\")<>-1 then:txt=Replace(txt,"\\","\u005c"):end if
	if jsIndexOf(txt,"\'")<>-1 then:txt=Replace(txt,"\'","'"):end if
	if jsIndexOf(txt,"\""")<>-1 then:txt=Replace(txt,"\""",""""):end if
	if jsIndexOf(txt,"\r")<>-1 then:txt=Replace(txt,"\r",chr(13)):end if
	if jsIndexOf(txt,"\n")<>-1 then:txt=Replace(txt,"\n",chr(10)):end if
	if jsIndexOf(txt,"\t")<>-1 then:txt=Replace(txt,"\t",chr(9)):end if
	if jsIndexOf(txt,"\u")<>-1 then:txt=QUnEscape(txt):end if
	DeJsonString=txt
End Function

Function EnJsonString(ByVal txt)
	if isNul(txt) OR Len(txt)=0 then:EnJsonString="":exit function:end if
	if jsIndexOf(txt,"\")<>-1 then:txt=Replace(txt,"\","\\"):end if
	if jsIndexOf(txt,"'")<>-1 then:txt=Replace(txt,"'","\'"):end if
	'if jsIndexOf(txt,"""")<>-1 then:txt=Replace(txt,"""","\"""):end if
	if jsIndexOf(txt,chr(13))<>-1 then:txt=Replace(txt,chr(13),"\r"):end if
	if jsIndexOf(txt,chr(10))<>-1 then:txt=Replace(txt,chr(10),"\n"):end if
	if jsIndexOf(txt,chr(9))<>-1 then:txt=Replace(txt,chr(9),"\t"):end if
	EnJsonString=txt'QEscape(txt)
End Function

Function QEscape(ByVal txt)
	if isNul(txt) OR Len(txt)=0 then:QEscape="":exit function:end if
	QEscape=Unescape(Replace(escape(txt),"%u","\u"))
End Function

Function QUnEscape(ByVal txt)
	if isNul(txt) OR Len(txt)=0 then:QUnEscape="":exit function:end if
	QUnEscape=Unescape(Replace(txt,"\u","%u"))
End Function

Class JsonCls
	Private Inited,oRg,aRg,dRg,sRg,sRg2,bRg,vRg,fjson

	Private Sub Class_Initialize()
		'echo "JsonCls.Class_Initialize();<br>"
	End Sub

	Private Sub Class_Terminate()
		'echo "JsonCls.Class_Terminate();<br>"
	End Sub

	Private Sub Init()
		if Inited<>true then
			Inited=true:SET oRg=jsRegExp("/^\s*\{([\w\W]*)\}/i"):SET aRg=jsRegExp("/^\s*\[([\w\W]*)\]/i"):SET dRg=jsRegExp("/^\s*([\-\+\.0-9]+)[\w\W]*/i"):SET sRg=jsRegExp("/^\s*\""(.*)\""/i"):SET sRg2=jsRegExp("/^\s*(\'(.*)\')/i"):SET bRg=jsRegExp("/^\s*(true|false)[,\s!=]?[\w\W]*/i"):SET vRg=jsRegExp("/^\s*([a-zA-Z\$\_][\w\$\_]*)[,\s!=]?[\w\W]*/i")
		end if
	End Sub

	Public Function parseFile(ByVal sPath)
		if isExistFile(sPath) then:fjson=LoadFile(sPath):else:fjson="":end if
		SetValue parseFile,json2var(fjson)
	End Function

	Private Function findSentence(ByVal x)
		dim sChr,eChr,isStr,sLen,iPos,iCount:x=LTrim(x):iPos=0:iCount=0:isStr=false
		if x="" then:findSentence="":exit function:end if
		if dRg.test(x) then
			iPos=Len(dRg.Replace(x,"$1"))
		else
			if bRg.test(x) then
				iPos=Len(bRg.Replace(x,"$1"))
			elseif vRg.test(x) then
				iPos=Len(vRg.Replace(x,"$1"))
			else
				sLen=len(x)
				do while iPos<sLen
					sChr=jsCharAt(x,iPos):iPos=iPos+1
					if sChr = "{" OR sChr = "[" then
						iCount=iCount+1
					else
						if sChr = "}" OR sChr = "]" then
							iCount=iCount-1:if iCount=0 then:exit do:end if
						else
							if sChr="""" OR sChr="'" then
								isStr=iPos=1
								do while true
									if IsClientConnected=false then:response.end:end if
									iPos=iPos+InStr(jsSlice(x,iPos,0),sChr)-1:eChr=jsCharAt(x,iPos):iPos=iPos+1
									if sChr=eChr AND jsCharAt(x,iPos-2)<>"\" then
										exit do
									end if
								loop
								if isStr then
									exit do
								end if
							end if
						end if
					end if
				loop
			end if
		end if
		findSentence=array(jsSubstr(x,0,iPos),jsSlice(x,iPos,0))
	End Function

	Private Function ParseObject(ByVal x)
		Dim key,t,fs:SET t = Object():x=trim(x)
		if x<>"" then
			do while true
				fs=findSentence(x):key=Json2Var(fs(0)):x=jsSlice(fs(1),jsIndexOf(fs(1),":"),0)
				fs=findSentence(x):t(key)=Json2Var(fs(0))
				if fs(1)="" then
					exit do
				else
					x=jsSlice(LTrim(fs(1)),1,0)
				end if
			loop
		end if
		SET ParseObject=t
	End Function

	Private Function ParseArray(ByVal x)
		dim fs:ParseArray = Array():if x="" then:exit function:end if
		do while true
			fs=findSentence(x):Push ParseArray,Json2Var(fs(0))
			if fs(1)="" then
				exit do
			else
				x=jsSlice(LTrim(fs(1)),1,0)
			end if
		loop
	End Function

	Public Function Json2Var(ByVal x)
		Init
		if oRg.test(x) then:SET Json2Var = ParseObject(StrSliceB(x,"{","}")):exit function:end if
		if aRg.test(x) then:Json2Var = ParseArray(StrSliceB(x,"[","]")):exit function:end if
		if dRg.test(x) then:Json2Var=Str2Num(x):exit function:end if
		if sRg.test(x) then:Json2Var=DeJsonString(StrSliceB(x,"""","""")):exit function:end if
		if sRg2.test(x) then:Json2Var=DeJsonString(StrSliceB(x,"'","'")):exit function:end if
		if bRg.test(x) then:Json2Var=CBool(x):exit function:end if
		Json2Var=x
	End Function

	Public Function Var2Json(ByVal x)
		Init:on error resume next
		dim i
		if isObject(x) then
			if UCASE(typename(x)) = "DICTIONARY" then
				Dim Keys,ValTxt,key:Keys=x.keys
				for i=0 to UBound(Keys)
					key = Var2Json(EnJsonString(Keys(i)))
					ValTxt = Var2Json(x.item(Keys(i)))
					Keys(i)=chr(9)&key&": "&ifthen(ValTxt<>"",ValTxt,"""""")
				next
				Var2Json="{"&vbcrlf&join(Keys,","&vbcrlf)&vbcrlf&"}"
			else
				Var2Json="{}"
			end if
			exit function
		end if
		if isArray(x) then
			for i=0 to UBound(x):x(i)=Var2Json(x(i)):next
			Var2Json="["&Join(x,",")&"]":exit function
		end if
		if isBool(x) then:Var2Json=ifthen(x=true,"true","false"):exit function:end if
		if isNumeric(x) then:Var2Json= x:else:Var2Json= "'"&EnJsonString(x)&"'":end if
	End Function
End Class

Function CreateMappingFile(ByVal MarkID)
	SET CreateMappingFile=New TMappingFile:CreateMappingFile.open MarkID,false
End Function

Sub FreeMappingFile(ByVal MarkID)
	CreateMappingFile(MarkID).RemoveAll
End Sub

Class TMappingFile
	Public isCache
	Private fENV,fOpened,fPath,fFName
	Private Sub Class_Initialize()
		SET fENV=Object():fOpened=false:fPath=ENGINEDIR&ESCACHEDIR:isCache=false
	End Sub

	Private Sub Class_Terminate()
		SaveToFile:fENV.Removeall():SET fENV=Nothing
	End Sub

	Private Function getPath()
		if isCache then
			getPath=fPath&fFName&".tmp"
		else
			getPath=StrSliceB(fPath&fFName,"",".")&".json"
		end if
	end function

	Public Sub Open(ByVal MarkID,ByVal bMode)
		if not isExistFile(ENGINEDIR&ESCDIR&MarkID) then:die "��Ч�� ����.ID	����ֵ #���̱�ʶID":end if
		fFName=MarkID:fOpened=true
		if bMode = false then
			if isExistFile(getPath) then
				on error resume next
				SET fENV=nothing:SetValue fENV,ParseJsonFile(getPath)
				if err.number>0 then
					delFile getPath
					die "ӳ���ļ�����: "&getPath
				end if
			end if
		end if
	End Sub

	Private Function toString()
		toString=Json().Var2Json(fENV)
	End Function

	Public Sub SaveToFile()
		if not fOpened then:exit Sub:end if
		if fENV.Count=0 then
			delFile getPath
		else
			if not CreateTextFile(toString,getPath,"gb2312") then:throw 1916,"������д�롰"&getPath&"��ӳ���ļ�ʧ�ܣ�����Ŀ¼(��/д)Ȩ�ޣ����ռ��ǲ�������":die "":end if
		end if
	End Sub

	Public Sub Remove(ByVal Key)
		fENV.Remove(Key)
	End Sub

	Public Sub RemoveAll()
		fENV.RemoveAll
	End Sub

	Public Default Property GET Item(ByVal Key)
		Item=fENV(Key)
	End Property

	Public Property LET Item(ByVal Key,ByVal Val)
		fENV(Key)=Val
	End Property

	Public Function Exists(ByVal keyName)
		Exists=fENV.Exists(keyName)
	End Function

	Public Property GET Items()
		Items=fENV.Items
	End Property

	Public Property GET Keys()
		Keys=fENV.Keys
	End Property

	Public Function Count()
		Count=fENV.Count
	End Function
End Class
%>