<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<%
'******************************************************************************************
' Software name: Max(马克斯) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: 石头(maxcms2008@qq.com),yuet,长明,酒瓶
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************
Option Explicit

dim starttime,endtime
setStartTime
Const CBTag="<!--FILE CACHE TIME:":Const CETag="-->":Const CDIRNAME="webcache"
const CONN_OBJ_NAME="ADODB.CONNECTION"
const RECORDSET_OBJ_NAME="ADODB.RECORDSET"

dim FSO_OBJ_NAME
	FSO_OBJ_NAME="SCRI"&"PTING.FILES"&"YSTEMOBJECT"

dim STREAM_OBJ_NAME
	STREAM_OBJ_NAME="ADOD"&"B.ST"&"REAM"

dim DICTIONARY_OBJ_NAME
	DICTIONARY_OBJ_NAME="SCRIPTING.DICTIONARY"

dim JPEG_OBJ_NAME
	JPEG_OBJ_NAME="Persits.jpeg"

dim TABLE_PRE
	TABLE_PRE="m_"

Class MainClass
	private className

	Private Sub Class_Initialize
		className=""
	End Sub

	Public Function createObject(byval classStr)
		className=classStr
		classname=replace(classname,".","_")
		Execute("set createObject=new "&classname)
	End Function

	Private Sub Class_Terminate()
		
	End Sub
End Class


Class MainClass_DB
	public dbConn,dbRs,isConnect,fetchCount,tablepre
	private connStr,vqueryCount,vdbType
	private errid,errdes

	Private Sub Class_Initialize
		isConnect=false:vqueryCount=0:fetchCount=0
	End Sub

	Public Property Get queryCount
		queryCount=vqueryCount
	End Property

	Public Property Let dbType(byval pType)
		if pType="sql" then vdbType=pType  else vdbType="acc"
	End Property

	Private Sub getConnStr()
		if vdbType="sql" then
			tablepre=ifthen(tableuser<>"",tableuser&".","")&TABLE_PRE:connStr="Provider=Sqloledb;Data Source="&databaseServer&";Initial Catalog="&databaseName&";User ID="&databaseUser&";Password="&databasePwd&";"
		elseif vdbType="acc" then
			tablepre=TABLE_PRE:connStr="Provider=Microsoft.Jet.OLEdb.4.0;Data Source="&server.mappath(accessFilePath)
		end if
	End Sub

	Public Sub connect()
		getConnStr
		if isObject(dbConn)=false or isConnect=false then
			On Error Resume Next
			set dbConn=server.CreateObject(CONN_OBJ_NAME)
			dbConn.open connStr
			isConnect=true
			if Err then errid=Err.number:errdes=Err.description:Err.Clear:dbConn.close:set dbConn=nothing:isConnect=false:echoErr err_dbconect,errid,errdes
		end if
	End Sub

	Function db(byval sqlStr,byval sqlType)
		if not isConnect=true then connect
		On Error Resume Next
		sqlStr=replace(sqlStr,"{pre}",tablepre)
		'echo sqlStr&"<br>"
		select case sqlType
			case "execute"
				set db=dbConn.execute(sqlStr)
			case "records1"
				set db=server.CreateObject(RECORDSET_OBJ_NAME)
				db.open sqlStr,dbConn,1,1
			case "records3"
				set db=server.CreateObject(RECORDSET_OBJ_NAME)
				db.open sqlStr,dbConn,3,3
			case "array"
				set dbRs=server.CreateObject(RECORDSET_OBJ_NAME)
				dbRs.open sqlStr,dbConn,1,1
				if not dbRs.eof then
					if fetchCount=0 then db=dbRs.getRows() else db=dbRs.getRows(fetchCount)
				end if
				dbRs.close:set dbRs=nothing
		end select
		vqueryCount=vqueryCount+1
		if Err then
			'echo sqlStr&"<br>"
			errid=Err.number:errdes=Err.description:Err.Clear:dbConn.close:set dbConn=nothing:isConnect=false
			echoErr err_rsopen,errid,errdes
		end if
	End Function

	Public Sub Class_Terminate()
		if isObject(dbRs) then set dbRs=nothing
		if isConnect then dbConn.close:set dbConn=nothing:isConnect=false
	End Sub
End Class



Class MainClass_Cache
	Public continueTime,vcacheFlag 
	Private v_cacheName,cacheData,cacheNum

	Private Sub Class_Initialize()
		continueTime=clng(cacheTime)
		vcacheFlag=cacheFlag
		cacheNum=200
	End Sub 

	Public Function setCache(ByVal p_cacheName,ByVal p_cacheValue)
		if getCacheNum > cacheNum then clearOtherCache
		on error resume next
		v_cacheName=LCase(p_cacheName)
		If v_cacheName<>"" Then
			cacheData=Application(vcacheFlag&v_cacheName)
			If IsArray(cacheData) Then
				if isObject(p_cacheValue) then set cacheData(0)=p_cacheValue else cacheData(0)=p_cacheValue
				cacheData(1)=Now()
			Else
				ReDim cacheData(1)
				if isObject(p_cacheValue) then set cacheData(0)=p_cacheValue else cacheData(0)=p_cacheValue
				cacheData(1)=Now()
			End If
			if err then clearAll:err.clear
			Application.Lock
			Application(vcacheFlag&v_cacheName)=cacheData
			Application.unLock
		Else
			die err_cachename
		End If
	End Function

	Public Function getCache(ByVal p_cacheName)
		on error resume next
		v_cacheName=LCase(p_cacheName)
		If v_cacheName<>"" Then
			cacheData=Application(vcacheFlag&v_cacheName)
			If IsArray(cacheData) Then
				if isObject(cacheData(0)) then set getCache=cacheData(0) else getCache=cacheData(0)
				if err then clearAll:err.clear
			Else
				die err_cachevalue
			End If
		Else
			die err_cachename
		End If
	End Function 

	Public Function chkCache(ByVal p_cacheName)
		v_cacheName=LCase(p_cacheName)
		chkCache=false
		on error resume next
		cacheData=Application(vcacheFlag&v_cacheName)
		if err then clearAll:err.clear:Exit Function
		If Not IsArray(cacheData) Then Exit Function
		If Not IsDate(cacheData(1)) Then Exit Function
		If DateDiff("s",CDate(cacheData(1)),Now()) < 60*continueTime Then
			chkCache=true
		End If
	End Function

	Public Sub clearCache(ByVal p_cacheName)
		v_cacheName=LCase(p_cacheName)
		Application.Lock
		Application(vcacheFlag&v_cacheName)=Empty
		Application.unLock
	End Sub

	Public Function havedTime(Byval p_cacheName)
		v_cacheName=LCase(p_cacheName)
		If v_cacheName<>"" Then
			cacheData=Application(vcacheFlag&v_cacheName)
			If IsArray(cacheData) Then
				havedTime=cacheData(1)
			Else
				die err_cachevalue
			End If
		Else
			die err_cachename
		End If
	End Function

	Public Sub clearAll()
		Application.Lock()
		Application.Contents.RemoveAll()
		Application.UnLock()
	end sub

	Public Sub showAllCache()
		dim acon
		echo "缓存对象列表：共"&getCacheNum()&"个:<br>"
		for each acon in Application.Contents
			echo  acon&"<br>"
		next
	End Sub

	Public Function getCacheNum()
		getCacheNum=application.Contents.Count
	End Function

	Public Sub clearOtherCache()
		dim acon,i,otherNum:otherNum=getCacheNum - cacheNum:i=0
		for each acon in Application.Contents
			Application.Lock()
			application.contents.remove(acon)
			Application.UnLock()
			i=i + 1
			if i=otherNum then exit for
		next
	End Sub 
End Class


Class MainClass_Template
	Public content,allPages,currentPage,currentType
	Private cacheName,labelRule,regExpObj,strDictionary

	Public Sub Class_Initialize()
		set regExpObj= new RegExp
		regExpObj.ignoreCase=true
		regExpObj.Global=true
		set strDictionary=server.CreateObject(DICTIONARY_OBJ_NAME)
	End Sub

	Public Sub Class_Terminate()
		set regExpObj=nothing
		set strDictionary=nothing
	End Sub

	Public Function load(Byval filePath)
		cacheName="template_"&filePath
		if(clng(cacheStart)=1) then
			if (cacheObj.chkCache(cacheName)) then content=cacheObj.getCache(cacheName) else content=loadFile(filePath):cacheObj.setCache cacheName,content
		else
			content=loadFile(filePath)
		end if
	End Function

	Function parseStrip(ByVal str)
		if not isExistStr(str,"{/maxcms:strip}") then parseStrip=str:exit function
		Dim rg,i,matches,match,tmp:set rg= new RegExp:rg.ignoreCase=true:rg.Global=true
		rg.Pattern="(<script.*?>[\S\s]*?<\/script>)"
		set matches=rg.Execute(str):ReDim ary(matches.count):i=-1
		for each match in matches
			i=i+1:ary(i)=match.SubMatches(0):str=replace(str,match.value,"<[script."&i&"]>")
		next
		regExpObj.Pattern="{maxcms:strip}([\s\S]*?){/maxcms:strip}":rg.Pattern="[\t ]*[\r\n]+[\t ]*":set matches=regExpObj.Execute(str)
		for each match in matches
			str=replace(str,match.value,rg.replace(match.SubMatches(0),""))
		next
		set rg=nothing:set matches=nothing
		if i>-1 then
			for i=i to 0 step -1
				str=replace(str,"<[script."&i&"]>",ary(i))
			next
		end if
		parseStrip=str
	End Function

	Public Sub parseSelf()
		if not isExistStr(content,"{self:") then Exit Sub
		dim matches,match,labelName,selfLabelArray,selfLabelLen,sql,singleAttrKey,singleAttrValue
		sql="select m_name,m_content from {pre}selflabel"
		labelRule="{self:([\s\S]+?)}"
		if cacheStart=1  then
			if (not cacheObj.chkCache("array_allselflabel_name_content")) then selfLabelArray=conn.db(sql,"array"):cacheObj.setCache "array_allselflabel_name_content",selfLabelArray else  selfLabelArray=cacheObj.getCache("array_allselflabel_name_content")
		else
			selfLabelArray=conn.db(sql,"array")
		end if
		if isArray(selfLabelArray) then
			for selfLabelLen=0 to ubound(selfLabelArray,2)
				singleAttrKey=selfLabelArray(0,selfLabelLen)
				singleAttrValue=decodeHtml(selfLabelArray(1,selfLabelLen))
				dim singleLength:singleLength=Ubound(split(singleAttrValue,"$$$"))
				randomize:dim singleNum:singleNum=clng((singleLength)*rnd)
				if singleLength>0 then
					singleAttrValue=split(singleAttrValue,"$$$")(singleNum)
				end if 
				if not strDictionary.Exists(singleAttrKey) then strDictionary.add singleAttrKey,singleAttrValue  else  strDictionary(singleAttrKey)=singleAttrValue
			next
		end if
		regExpObj.Pattern=labelRule
		set matches=regExpObj.Execute(content)
		for each match in matches
			labelName=trim(match.SubMatches(0))
			if strDictionary.Exists(labelName) then content=replace(content,match.value,strDictionary(labelName))
		next
		strDictionary.RemoveAll
		set matches=nothing
	End Sub

	Public Sub parseTopAndFoot()
		dim tp:tp="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"
		content=replaceStr(content,"{maxcms:top}",parseStrip(loadFileOnCache("template_",tp&"head.html"))) 
		content=replaceStr(content,"{maxcms:foot}",parseStrip(loadFileOnCache("template_",tp&"foot.html")))
		if isExistStr(content,"{maxcms:load ") then
			Dim x,matches,match:regExpObj.Pattern="{maxcms:load([\s\S]+?)}"
			set matches=regExpObj.Execute(content)
			for each match in matches
				x=trim(match.SubMatches(0)):if isExistFile(tp&x) then content=replace(content,match.value,parseStrip(loadFileOnCache("template_",tp&x)))
			next
			set matches=nothing
		end if
		content=replaceStr(content,"images/","/"&sitePath&"template/"&defaultTemplate&"/images/")
		if gbookStart=0 then
			content=replaceStr(content,"{maxcms:gbook}","")
		else
			content=replaceStr(content,"{maxcms:gbook}","<a href=""/{maxcms:sitepath}gbook.asp"" target=""_blank""  >留言</a>")
		end if
		content=parseStrip(content)
	End Sub

	Public Sub parseGlobal()
		if isExistStr(content,"{maxcms:letterlist}") then content=replaceStr(content,"{maxcms:letterlist}",getletterlist)
		if isExistStr(content,"{maxcms:indexlink}") then content=replaceStr(content,"{maxcms:indexlink}",getIndexLink)
		if isExistStr(content,"{maxcms:topiclink}") then content=replaceStr(content,"{maxcms:topiclink}",getTopicIndexLink(1))
		if isExistStr(content,"{maxcms:newslink}") then content=replaceStr(content,"{maxcms:newslink}",getNewsIndexLink())
		content=replaceStr(content,"{maxcms:siteurl}",siteUrl)
		content=replaceStr(content,"{maxcms:sitepath}",sitePath)
		content=replaceStr(content,"{maxcms:adfolder}",siteAd)
		content=replaceStr(content,"{maxcms:sitename}",siteName)
		content=replaceStr(content,"{maxcms:copyright}",decodeHtml(copyRight))
		content=replaceStr(content,"{maxcms:des}",decodeHtml(siteDes))
		content=replaceStr(content,"{maxcms:sitevisitjs}",siteVisiteJs)
		content=replaceStr(content,"{maxcms:sitenotice}",decodeHtml(siteNotice))
		content=replaceStr(content,"{maxcms:keywords}",getKeywordsList(siteKeyWords,""))
		if isExistStr(content,"{maxcms:allcount}") then content=replaceStr(content,"{maxcms:allcount}",getDataCount("all"))
		if isExistStr(content,"{maxcms:daycount}") then content=replaceStr(content,"{maxcms:daycount}",getDataCount("day"))
		if gbookStart=0 then content=replaceStr(content,"{maxcms:gbook}","") else content=replaceStr(content,"{maxcms:gbook}","<a href=""/"&sitePath&"gbook.asp"" target=""_blank""  >留言</a>")
		parseSlide:parseMaxHistory
		if runMode="static" OR newsrunMode="static" then content=replaceStr(content,"{maxcms:runinfo}","")
	End Sub

	Public Function parseAttr(Byval attr)
		dim attrStr,attrArray,i,singleAttr,singleAttrKey,singleAttrValue
		attrStr=regExpReplace(attr,"[\s]+",chr(32))
		attrStr=trimOuter(attrStr)
		attrArray=split(attrStr,chr(32)):strDictionary.removeall()
		for i=0 to ubound(attrArray)
			singleAttr=split(attrArray(i),chr(61))
			singleAttrKey= singleAttr(0):singleAttrValue= singleAttr(1)
			if not strDictionary.Exists(singleAttrKey) then strDictionary.add singleAttrKey,singleAttrValue  else  strDictionary(singleAttrKey)=singleAttrValue
		next
		set parseAttr=strDictionary
	End Function

	Public Function regExpReplace(contentstr,patternstr,replacestr)
		regExpObj.Pattern=patternstr
		regExpReplace=regExpObj.replace(contentstr,replacestr)
	End Function

	Public Sub parseAreaList()
		if not isExistStr(content,"{maxcms:arealist") then Exit Sub
		dim matches,match,matchesVideolist,matchVideolist,totalStrAreaList,tmp
		dim labelAttrArealist,loopStrArealist,currentAreaType,areaType,areaTypeArray
		dim labelAttr,labelVideolist,labelRuleVideolist,videoListStr
		dim i,j,sql,typeStr,letHas,tagHas,TS,m,x:typeStr="":TS=getTypeLists():j=getTypeIndex("m_upid"):m=getTypeIndex("m_id")
		labelRule="{maxcms:arealist([\s\S]*?)}([\s\S]*?){/maxcms:arealist}"
		labelRuleVideolist="{maxcms:videolist([\s\S]*?)}([\s\S]*?){/maxcms:videolist}"
		for i=0 to UBound(TS,2)
			if ""&TS(j,i)="0" then
				if typeStr="" then
					typeStr=TS(m,i)
				else
					typeStr=typeStr&","&TS(m,i)
				end if
			end if
		next
		regExpObj.Pattern=labelRule:set matches=regExpObj.Execute(content)
		for each match in matches
			if typeStr<>"" then
				labelAttrArealist=match.SubMatches(0)
				loopStrArealist=match.SubMatches(1)
				Set x=parseAttr(labelAttrArealist):areaType=x("areatype"):letHas=x("arealetter"):tagHas=x("tag"):Set x=nothing
				if not isNul(letHas) then areaType="letter"
				if isNul(areaType) then areaType="all"
				if areaType="letter" then
					if isNul(letHas) OR letHas="all" then letHas="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
					letHas=Split(letHas,",")
					for j=0 to UBound(letHas)
						if letHas(j)<>"" then
							tmp=loopStrArealist
							tmp=replaceStr(tmp,"[arealist:i]",j+1)
							tmp=replaceStr(tmp,"[arealist:typename]",letHas(j))
							if isExistStr(tmp,"[arealist:count]") then
								tmp=replaceStr(tmp,"[arealist:count]",conn.db("SELECT COUNT(*) FROM {pre}data WHERE m_letter='"&letHas(j)&"'","execute")(0))
							end if
							tmp=replaceStr(tmp,"[arealist:link]","/"&sitepath&"search.asp?searchtype=4&searchword="&letHas(j))
							regExpObj.Pattern=labelRuleVideolist
							set matchesVideolist=regExpObj.Execute(tmp)
							for each matchVideolist in matchesVideolist
								videoListStr=replaceStr(matchVideolist.value,"arealetter",letHas(j))
								videoListStr=replaceStr(videoListStr,"areatype","all")
								tmp=replaceStr(tmp,matchVideolist.value,videoListStr)
							next
							set matchesVideolist=nothing
							totalStrAreaList=totalStrAreaList&tmp
						end if
					next
				elseif areaType="tag" then
					if isNul(tagHas) then tagHas="all"
					tagHas=Split(tagHas,",")
					for j=0 to UBound(tagHas)
						if tagHas(j)<>"" then
							tmp=loopStrArealist
							tmp=replaceStr(tmp,"[arealist:i]",j+1)
							tmp=replaceStr(tmp,"[arealist:typename]",tagHas(j))
							if isExistStr(tmp,"[arealist:count]") then
								tmp=replaceStr(tmp,"[arealist:count]",conn.db("SELECT COUNT(*) FROM {pre}data WHERE m_name LIKE '%"&tagHas(j)&"%' OR m_actor like '%"&tagHas(j)&"%' OR  m_director like '%"&tagHas(j)&"%'","execute")(0))
							end if
							tmp=replaceStr(tmp,"[arealist:link]","/"&sitepath&"search.asp?searchword="&Server.URLEncode(tagHas(j)))
							regExpObj.Pattern=labelRuleVideolist
							set matchesVideolist=regExpObj.Execute(tmp)
							for each matchVideolist in matchesVideolist
								videoListStr=replaceStr(matchVideolist.value,"areatag",tagHas(j))
								videoListStr=replaceStr(videoListStr,"areatype","all")
								tmp=replaceStr(tmp,matchVideolist.value,videoListStr)
							next
							set matchesVideolist=nothing
							totalStrAreaList=totalStrAreaList&tmp
						end if
					next
				else
					if areaType="all" then:areaTypeArray=split(typeStr,","):else:areaTypeArray=split(areaType,","):end if
					for j=0 to ubound(areaTypeArray)
						currentAreaType=areaTypeArray(j)
						if not isNum(currentAreaType) then die err_areaList
						m=getTypeNameTemplateArrayOnCache(currentAreaType):if m="" OR m=",," then Exit For
						tmp=loopStrArealist
						tmp=replaceStr(tmp,"[arealist:i]",j+1)
						tmp=replaceStr(tmp,"[arealist:typename]",Split(m,",")(0))
						if isExistStr(tmp,"[arealist:count]") then
							tmp=replaceStr(tmp,"[arealist:count]",getNumPerType(currentAreaType))
						end if
						tmp=replaceStr(tmp,"[arealist:link]",getTypeLink(currentAreaType))
						regExpObj.Pattern=labelRuleVideolist
						set matchesVideolist=regExpObj.Execute(tmp)
						for each matchVideolist in matchesVideolist
							videoListStr=replaceStr(matchVideolist.value,"arealetter","all")
							videoListStr=replaceStr(videoListStr,"areatype",currentAreaType)
							tmp=replaceStr(tmp,matchVideolist.value,videoListStr)
						next
						set matchesVideolist=nothing
						totalStrAreaList=totalStrAreaList&tmp
					next
				end if
			else
				totalStrAreaList=""
			end if
			content=replaceStr(content,match.value,totalStrAreaList)
			totalStrAreaList=""
		next
		set matches=nothing
	End Sub

	Public Sub parseVideoList()
		if not isExistStr(content,"{maxcms:videolist") then Exit Sub
		dim match,matches,matchfield,matchesfield
		dim labelAttr,loopstrVideoList,loopnew,loopstrTotal,attr
		dim vnum,vorder,vtype,vtopic,vtime,vstart,vstate,vcommend,vletter,vid
		dim fieldName,fieldAttr,fieldNameAndAttr,fieldAttrLen
		dim i,labelRuleField,field_des,field_playdata,n,ni:n=0
		dim namelen,attrval,actorlen,deslen,timestyle,videoTime,colornamelen,m_colorname,m_des,m_color,m_note,notelen,m_name,m_actor
		dim m,sql,orderStr,whereType,whereLetter,whereTopic,whereTime,whereStr,rsary,whereState,whereCommend,whereId,vtypeArray,vtypeI,vtypeStr,vtypeArrayLen,playlink_str
		labelRule="{maxcms:videolist([\s\S]*?)}([\s\S]*?){/maxcms:videolist}"
		labelRuleField="\[videolist:([\s\S]+?)\]"
		regExpObj.Pattern=labelRule
		set matches=regExpObj.Execute(content)
		for each match in matches
			labelAttr=match.SubMatches(0)
			loopstrVideoList=match.SubMatches(1)
			if isExistStr(loopstrVideoList,"[videolist:des") then field_des="m_des" else field_des="0"
			if isExistStr(loopstrVideoList,"[videolist:from]") then field_playdata="m_playdata" else  field_playdata="0"
			set attr=parseAttr(labelAttr)
			vnum=attr("num"):vorder=attr("order"):vletter=attr("letter"):vtype=attr("type"):vtopic=attr("topic"):vtime=attr("time"):vstart=attr("start"):vstate=attr("state"):vcommend=attr("commend"):vid=attr("id")
			if isNul(vnum) then vnum=10 else vnum=clng(vnum)
			if isNul(vorder) AND isNul(vid) then vorder="time"
			if isNul(vorder) then vorder="id"
			select case vorder
				case "id":orderStr =" order by m_id desc"
				case "hit","hot":orderStr =" order by m_hit desc"
				case "dayhit":orderStr =" order by m_dayhit desc"
				case "weekhit":orderStr =" order by m_weekhit desc"
				case "monthhit":orderStr =" order by m_monthhit desc"
				case "time":orderStr =" order by m_addtime desc"
				case "commend":orderStr =" order by m_commend desc"
				case "digg":orderStr =" order by m_digg desc"
				case "score":orderStr =" order by m_score desc"
				case "abc":orderStr =" order by m_enname asc"
				case "hitabc":orderStr =" order by m_hit desc,m_enname asc"
				case "random"
				if databaseType=0 then
					dim rndNum:randomize():rndNum=int(1000*rnd)+1:orderStr =" order by rnd( -1*"&rndNum&" * m_id)"
				else
					orderStr=" order by newid() desc"
				end if
			end select
			if isNul(vtype) then vtype="all"
			vtypeStr=""
			if vtype <> "all" then
				if vtype="current" then
					vtypeStr=getTypeIdOnCache(currentTypeId)
				else
					if instr(vtype,",")>0 then
						vtypeArray=split(vtype,","):vtypeArrayLen=ubound(vtypeArray)
						for vtypeI=0 to  vtypeArrayLen
							vtypeStr=vtypeStr&getTypeIdOnCache(vtypeArray(vtypeI))&","
						next
						vtypeStr=trimOuterStr(vtypeStr,",")
					else
						vtypeStr=getTypeIdOnCache(vtype)
					end if
				end if
				if InStr(vtypeStr,",")>0 then:whereType=" and m_type in ("&vtypeStr&") ":else:whereType=" and m_type="&vtypeStr:end if
			else
				whereType=""
			end if
			if not Isnul(vletter) AND vletter<>"all" then whereLetter=" and m_letter ='"&UCase(vletter)&"' " else whereLetter=""
			if not Isnul(vid) AND vid<>"all" then
				if InStr(vid,",")>0 then:whereId=" and m_id IN ("&vid&") ":else:whereId=" and m_id="&vid:end if
			else
				whereId=""
			end if
			if IsNum(vstate) then
				whereState=" and m_state>="&Clng(vstate)
			elseif vstate="series" then
				whereState=" and m_state>0"
			else
				whereState=""
			end if
			if not isNul(vcommend) then
				select case trim(vcommend)
					case "all":whereCommend=" and  m_commend>0"
					case else
						if instr(vcommend,",")>0 then whereCommend=" and m_commend in("&vcommend&")" else whereCommend=" and m_commend ="&vcommend
				end select
			else
				whereCommend=""
			end if
			if not isNul(vtopic) then
				select case trim(vtopic)
					case "all":whereTopic=" and m_topic>0"
					case "current":whereTopic=" and m_topic="&currentTopicId
					case else
						if instr(vtopic,",")>0 then whereTopic=" and m_topic in("&vtopic&")" else whereTopic=" and m_topic ="&vtopic
				end select
			else
				whereTopic=""
			end if
			if databaseType = 0 then
				select case vtime
					case "day":whereTime=" and  DateDiff('d',m_addtime,#"&now()&"#)=0"
					case "week":whereTime=" and  DateDiff('d',m_addtime,#"&now()&"#)<7"
					case "month":whereTime=" and  DateDiff('d',m_addtime,#"&now()&"#)<31"
					case else:whereTime=""
				end select
			else
				select case vtime
					case "day":whereTime=" and  DateDiff(d,m_addtime,'"&now()&"')=0"
					case "week":whereTime=" and  DateDiff(d,m_addtime,'"&now()&"')<7"
					case "month":whereTime=" and  DateDiff(d,m_addtime,'"&now()&"')<31"
					case else:whereTime=""
				end select
			end if 
			whereStr=Replace(" where m_recycle=0"&whereType&whereLetter&whereTopic&whereTime&whereState&whereCommend&whereId,"where  and ","where ")
			'if trim(whereStr)="where" then whereStr=""
			if not isNul(vstart) then vstart=clng(vstart) else vstart=1
			n=vstart-1:vnum=vnum+vstart-1:ni=1
			set attr=nothing
			sql="select top "&vnum+1&" m_id,m_name,m_type,m_state,m_pic,m_hit,m_actor,"&field_des&",m_topic,m_color,m_addtime,m_publishyear,m_publisharea ,m_commend,"&field_playdata&",m_note,m_letter,m_keyword,m_digg,m_tread,m_enname,m_datetime,m_director,m_lang,m_dayhit,m_weekhit,m_monthhit,m_score from {pre}data "&whereStr&orderStr
			conn.fetchCount=vnum:rsary=conn.db(sql,"array"):conn.fetchCount=0
			regExpObj.Pattern=labelRuleField
			set matchesfield=regExpObj.Execute(loopstrVideoList)
			loopstrTotal=""
			if isArray(rsary) then vnum=ubound(rsary,2) else vnum=-1
			for i=n to vnum
				loopnew=loopstrVideoList
				for each matchfield in matchesfield
					fieldNameAndAttr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
					fieldNameAndAttr=trimOuter(fieldNameAndAttr)
					m=instr(fieldNameAndAttr,chr(32))
					if m > 0 then
						fieldName=left(fieldNameAndAttr,m - 1)
						fieldAttr =	right(fieldNameAndAttr,len(fieldNameAndAttr) - m)
					else
						fieldName=fieldNameAndAttr
						fieldAttr =	""
					end if
					select case fieldName
						case "id"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(0,i))
						case "typeid"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(2,i))
						case "letter"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(16,i))
						case "name"
							m_name=rsary(1,i):namelen=parseAttr(fieldAttr)("len")
							if not isNul(namelen) and len(m_name)>clng(namelen) then m_name=left(m_name,clng(namelen)-1)&".."
							loopnew=replaceStr(loopnew,matchfield.value,m_name)
						case "colorname"
							m_color=rsary(9,i):m_name=rsary(1,i):colornamelen=parseAttr(fieldAttr)("len")
							if not isNul(colornamelen) and len(m_name)>clng(colornamelen) then m_name=left(m_name,clng(colornamelen)-1)&".."
							if not(isnul(m_color)) then m_name="<font color="&m_color&">"&m_name&"</font>"
							loopnew=replaceStr(loopnew,matchfield.value,m_name)
						case "note"
							m_note=rsary(15,i):notelen=parseAttr(fieldAttr)("len")
							if not isNul(notelen) and len(m_note) > clng(notelen) then m_note=left(m_note,clng(notelen)-1)&".."
							loopnew=replaceStr(loopnew,matchfield.value,m_note)
						case "actor"
							m_actor=rsary(6,i):actorlen=parseAttr(fieldAttr)("len")
							if not isNul(actorlen) and len(m_actor) > clng(actorlen) then m_actor=left(m_actor,clng(actorlen)-1)&".."
							loopnew=replaceStr(loopnew,matchfield.value,getKeywordsList(m_actor," "))
						case "nolinkactor"
							m_actor=rsary(6,i):actorlen=parseAttr(fieldAttr)("len")
							if not isNul(actorlen) and len(m_actor) > clng(actorlen) then m_actor=left(m_actor,clng(actorlen)-1)&".."
							loopnew=replaceStr(loopnew,matchfield.value,m_actor)
						case "des"
							m_des=filterStr(decodeHtml(rsary(7,i)),"html"):deslen=parseAttr(fieldAttr)("len")
							if isNul(deslen) then deslen=200
							if len(m_des) > clng(deslen) then m_des=left(m_des,clng(deslen)-1)&".."
							loopnew=replaceStr(loopnew,matchfield.value,m_des)
						case "time"
							videoTime=rsary(10,i):timestyle=parseAttr(fieldAttr)("style"):if isNul(timestyle) then timestyle="mm-dd"
							dim monthDayTime:monthDayTime=right("00"&month(videoTime),2)&"-"&right("00"&day(videoTime),2)
							select case timestyle
								case "yyyy-mm-dd"
									loopnew=replaceStr(loopnew,matchfield.value,year(videoTime)&"-"&monthDayTime)
								case "yy-mm-dd"
									loopnew=replaceStr(loopnew,matchfield.value,right(year(videoTime),2)&"-"&monthDayTime)
								case "yyyy-m-d"
									loopnew=replaceStr(loopnew,matchfield.value,year(videoTime)&"-"&month(videoTime)&"-"&day(videoTime))
								case else
									loopnew=replaceStr(loopnew,matchfield.value,monthDayTime)
							end select
						case "i"
							loopnew=replaceStr(loopnew,matchfield.value,i+1)
						case "n"
							loopnew=replaceStr(loopnew,matchfield.value,ni)
						case "typename"
							loopnew=replaceStr(loopnew,matchfield.value,Split(getTypeNameTemplateArrayOnCache(clng(rsary(2,i))),",")(0))
						case "typelink"
							loopnew=replaceStr(loopnew,matchfield.value,getTypeLink(rsary(2,i)))
						case "link"
							loopnew=replaceStr(loopnew,matchfield.value,getContentLink(rsary(2,i),rsary(0,i),rsary(20,i),rsary(21,i),"link"))
						case "playlink"
							playlink_str=getPlayLink2(rsary(2,i),rsary(0,i),rsary(20,i),rsary(21,i),0,0)
							if isAlertWin=1 then playlink_str="javascript:openWin('"&playlink_str&"',"&(alertWinW+10)&","&(alertWinH+55)&",250,100,1)"
							loopnew=replaceStr(loopnew,matchfield.value,playlink_str)
						case "pic"
							if not isNul(rsary(4,i)) then
								if instr(rsary(4,i),"http://")>0 then 
									loopnew=replaceStr(loopnew,matchfield.value,rsary(4,i))
								else
									loopnew=replaceStr(loopnew,matchfield.value,"/"&sitePath&rsary(4,i))
								end if
							else
								loopnew=replaceStr(loopnew,matchfield.value,"/"&sitePath&"pic/nopic.gif")
							end if
						case "hit"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(5,i))
						case "state"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(3,i))
						case "publishtime"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(11,i))
						case "publisharea"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(12,i))
						case "commend"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(13,i))
						case "from"
							loopnew=replaceStr(loopnew,matchfield.value,replaceStr(getFromStr(rsary(14,i)),"播客CC","FLV高清"))
						case "keyword"
							loopnew=replaceStr(loopnew,matchfield.value,getKeywordsList(rsary(17,i)," "))
						case "digg"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(18,i))
						case "tread"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(19,i))
						case "director"
							loopnew=replaceStr(loopnew,matchfield.value,getKeywordsList(rsary(22,i)," "))
						case "lang"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(23,i))
						case "dayhit"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(24,i))
						case "weekhit"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(25,i))
						case "monthhit"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(26,i))
						case "score"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(27,i))
					end select
					strDictionary.removeAll
				next
				loopstrTotal=loopstrTotal&loopnew:ni=ni+1
			next
			set matchesfield=nothing
			content=replaceStr(content,match.value,loopstrTotal)
			strDictionary.removeAll
		next
		set matches=nothing
	End Sub

	Public Sub parsePageList(ByVal typeId,ByVal currentPage,ByRef totalPages,ByVal pageListType)
		dim matchChannel,matchesChannel,loopstrChannel,loopstrTotal,attrChannel,attr,loopnew
		dim labelRuleField,field_des,field_playdata
		dim vsize,vorder,vtype,vtypeArray
		dim i,m,sql,rsObj,orderStr,whereStr,sql1,esql,tPages
		dim matchfield,matchesfield,fieldNameAndAttr,fieldName,fieldAttr
		dim namelen,actorlen,deslen,timestyle,videoTime,colornamelen,m_colorname,m_des,m_color,m_note,notelen,m_actor,m_name
		dim matchPagelist,matchesPagelist,labelRulePagelist,labelRulePagelist2,lenPagelist,strPagelist,playlink_str
		labelRule="{maxcms:"&pageListType&"list([\s\S]*?)}([\s\S]*?){/maxcms:"&pageListType&"list}"
		labelRuleField="\["&pageListType&"list:([\s\S]+?)\]"
		labelRulePagelist="\["&pageListType&"list:pagenumber([\s\S]*?)\]"
		labelRulePagelist2="\{"&pageListType&"list:pagenumber([\s\S]*?)\}([\s\S]*?){/"&pageListType&"list:pagenumber}"
		if isExistStr(content,"["&pageListType&"list:des") then field_des="m_des" else  field_des="0"
		if isExistStr(content,"["&pageListType&"list:from]") then field_playdata="m_playdata" else  field_playdata="0"
		regExpObj.Pattern=labelRule
		set matchesChannel=regExpObj.Execute(content):sql1="select m_id,m_name,m_type,m_state,m_pic,m_hit,m_actor,"&field_des&",m_topic,m_color,m_addtime,m_publishyear,m_publisharea,m_commend,"&field_playdata&",m_note,m_keyword,m_digg,m_tread,m_enname,m_datetime,m_director,m_lang,m_dayhit,m_weekhit,m_monthhit,m_score from {pre}data "
		for each matchChannel in matchesChannel
			attrChannel=matchChannel.SubMatches(0)
			loopstrChannel=matchChannel.SubMatches(1)
			set attr=parseAttr(attrChannel)
			vsize=clng(attr("size")):vorder=attr("order")
			if isNul(vsize) then vsize=12 
			if isNul(vorder) then vorder="time"
			select case vorder
				case "id":orderStr =" order by m_id desc"
				case "hit","hot":orderStr =" order by m_hit desc"
				case "dayhit":orderStr =" order by m_dayhit desc"
				case "weekhit":orderStr =" order by m_weekhit desc"
				case "monthhit":orderStr =" order by m_monthhit desc"
				case "time":orderStr =" order by m_addtime desc"
				case "commend":orderStr =" order by m_commend desc"
				case "digg":orderStr =" order by m_digg desc"
				case "score":orderStr =" order by m_score desc"
				case "letter":orderstr=" order by m_letter asc"
			end select
			select case pageListType
				case "channel"
					sql=sql1&"where m_recycle=0 AND m_type in ("&typeId&")"&orderStr
				case "search"
					esql=EscapeSql(searchword)
					select case clng(searchType)
						case -1:whereStr=" where m_recycle=0 AND (m_name like '%"&esql&"%' OR m_actor like '%"&esql&"%' OR  m_director like '%"&esql&"%')"
						case 0:whereStr=" where m_recycle=0 AND m_name like '%"&esql&"%'"
						case 1:whereStr=" where m_recycle=0 AND (m_actor like '%"&esql&"%' OR m_director like '%"&esql&"%')"
						case 2:whereStr=" where m_recycle=0 AND m_publisharea like '%"&esql&"%'"
						case 3:whereStr=" where m_recycle=0 AND m_publishyear like '%"&esql&"%'"
						case 4:whereStr=" where m_recycle=0 AND m_letter='"&UCase(searchword)&"'"
						case 5:whereStr=" where m_recycle=0 AND m_lang like '%"&esql&"%'"
					end select
					if Cstr(searchword)="" then whereStr=" where 1=2"
				sql=sql1&whereStr&orderStr
				case "topicpage"
					sql=sql1&"where m_recycle=0 AND m_topic="&typeId&orderStr
				case "customvideo"
					vtype=attr("type"):totalPages=attr("maxpage")
					if isNum(totalPages) then totalPages=Clng(totalPages) else totalPages=0
					if vtype <> "all" then
						if vtype="current" then
							vtype=getTypeIdOnCache(currentTypeId)
						else
							if instr(vtype,",")>0 then
								vtypeArray=split(vtype,",")
								for i=0 to ubound(vtypeArray)
									vtype=vtype&getTypeIdOnCache(vtypeArray(i))&","
								next
								vtype=trimOuterStr(vtype,",")
							else
								vtype=getTypeIdOnCache(vtype)
							end if
						end if
						if InStr(vtype,",")>0 then:whereStr=" and m_type in ("&vtype&") ":else:whereStr=" and m_type="&vtype:end if
					else
						whereStr=""
					end if
					sql=sql1&"where m_recycle=0"&whereStr&orderStr
			end select
			set attr=nothing:regExpObj.Pattern=labelRuleField
			set matchesfield=regExpObj.Execute(loopstrChannel)
			set rsObj=conn.db(sql,"records1")
			if rsObj.eof then
				if pageListType="channel" then
					loopstrTotal=channellistInfo(0)
				elseif pageListType="search" then
					loopstrTotal=searchlistInfo(0)&searchword&searchlistInfo(1)
				elseif pageListType="topicpage" then
					loopstrTotal=topicpageInfo(0)
				end if
				totalPages=0
			else
				rsObj.pagesize=vsize
				if totalPages>rsObj.pagecount or pageListType<>"customvideo" then totalPages=rsObj.pagecount
				if clng(currentPage)>totalPages then currentPage=totalPages
				rsObj.absolutepage=currentPage
				loopstrTotal=""			
				for i=1 to vsize
					loopnew=loopstrChannel
					for each matchfield in matchesfield
						fieldNameAndAttr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
						fieldNameAndAttr=trimOuter(fieldNameAndAttr)
						m=instr(fieldNameAndAttr,chr(32))
						if m > 0 then
							fieldName=left(fieldNameAndAttr,m - 1)
							fieldAttr =	right(fieldNameAndAttr,len(fieldNameAndAttr) - m)
						else
							fieldName=fieldNameAndAttr
							fieldAttr =	""
						end if
						select case fieldName
							case "id"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(0))
							case "typeid"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(2))
							case "name"
								m_name=rsObj(1):namelen=parseAttr(fieldAttr)("len")
								if not isNul(namelen) and len(m_name)>clng(namelen) then m_name=left(m_name,clng(namelen)-1)&".."
								loopnew=replaceStr(loopnew,matchfield.value,m_name)
							case "colorname"
								m_color=rsObj(9):m_name=rsObj(1):colornamelen=parseAttr(fieldAttr)("len")
								if not isNul(colornamelen) and len(m_name)>clng(colornamelen) then m_name=left(m_name,clng(colornamelen)-1)&".."
								if not(isnul(m_color)) then m_name="<font color="&m_color&">"&m_name&"</font>"
								loopnew=replaceStr(loopnew,matchfield.value,m_name)
							case "note"
								m_note=rsObj(15):notelen=parseAttr(fieldAttr)("len")
								if not isNul(notelen)  and len(m_note) > clng(notelen)  then m_note=left(m_note,clng(notelen)-1)&".."
								loopnew=replaceStr(loopnew,matchfield.value,m_note)
							case "actor"
								m_actor=rsObj(6):actorlen=parseAttr(fieldAttr)("len")
								if not isNul(actorlen) and len(m_actor) > clng(actorlen)  then m_actor=left(m_actor,clng(actorlen)-1)&".."
								loopnew=replaceStr(loopnew,matchfield.value,m_actor)
							case "des"
								m_des=filterStr(decodeHtml(rsObj(7)),"html"):deslen=parseAttr(fieldAttr)("len")
								if isNul(deslen) then deslen=200
								if len(m_des) > clng(deslen) then m_des=left(m_des,clng(deslen)-1)&".."
								loopnew=replaceStr(loopnew,matchfield.value,m_des)
							case "time"
								videoTime=rsObj(10):timestyle=parseAttr(fieldAttr)("style"):if isNul(timestyle) then timestyle="mm-dd"
								dim monthDayTime:monthDayTime=right("00"&month(videoTime),2)&"-"&right("00"&day(videoTime),2)
								select case timestyle
									case "yyyy-mm-dd"
										loopnew=replaceStr(loopnew,matchfield.value,year(videoTime)&"-"&monthDayTime)
									case "yy-mm-dd"
										loopnew=replaceStr(loopnew,matchfield.value,right(year(videoTime),2)&"-"&monthDayTime)
									case "yyyy-m-d"
										loopnew=replaceStr(loopnew,matchfield.value,year(videoTime)&"-"&month(videoTime)&"-"&day(videoTime))
									case else
										loopnew=replaceStr(loopnew,matchfield.value,monthDayTime)
								end select
							case "i"
								loopnew=replaceStr(loopnew,matchfield.value,i)
							case "typename"
								loopnew=replaceStr(loopnew,matchfield.value,Split(getTypeNameTemplateArrayOnCache(rsObj(2)),",")(0))
							case "typelink"
								loopnew=replaceStr(loopnew,matchfield.value,getTypeLink(rsObj(2)))
							case "link"
								loopnew=replaceStr(loopnew,matchfield.value,getContentLink(rsObj(2),rsObj(0),rsObj(19),rsObj(20),"link"))
							case "playlink"
								if isAlertWin=1 then playlink_str="javascript:openWin('"&getPlayLink2(rsObj(2),rsObj(0),rsObj(19),rsObj(20),0,0)&"',"&(alertWinW+10)&","&(alertWinH+55)&",250,100,1)" else playlink_str=getPlayLink2(rsObj(2),rsObj(0),rsObj(19),rsObj(20),0,0)
								loopnew=replaceStr(loopnew,matchfield.value,playlink_str)
							case "pic"
								if not isNul(rsObj(4)) then
									if instr(rsObj(4),"http://")>0 then
										loopnew=replaceStr(loopnew,matchfield.value,rsObj(4))
									else
										loopnew=replaceStr(loopnew,matchfield.value,"/"&sitePath&rsObj(4))
									end if
								else
									loopnew=replaceStr(loopnew,matchfield.value,"/"&sitePath&"pic/nopic.gif")
								end if
							case "hit"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(5))
							case "state"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(3))
							case "publishtime"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(11))
							case "publisharea"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(12))
							case "commend"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(13))
							case "from"
								loopnew=replaceStr(loopnew,matchfield.value,replaceStr(getFromStr(rsObj(14)),"播客CC","FLV高清"))
							case "keyword"
								loopnew=replaceStr(loopnew,matchfield.value,getKeywordsList(rsObj(16)," "))
							case "digg"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(17))
							case "tread"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(18))
							case "director"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(21))
							case "lang"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(22))
							case "dayhit"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(23))
							case "weekhit"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(24))
							case "monthhit"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(25))
							case "score"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(26))
						end select
						strDictionary.removeAll
					next
					loopstrTotal=loopstrTotal&loopnew
					rsObj.movenext
					if rsObj.eof then exit for
				next
			end if
			content=replace(content,matchChannel.value,loopstrTotal)
			regExpObj.Pattern=labelRulePagelist
			set matchesPagelist=regExpObj.Execute(content)
			for each matchPagelist in matchesPagelist
				if totalPages=0 then
					content=replace(content,matchPagelist.value,"")
				else
					lenPagelist=parseAttr(matchPagelist.SubMatches(0))("len")
					if isNul(lenPagelist) then lenPagelist=10 else lenPagelist=clng(lenPagelist)
					strPagelist=pageNumberLinkInfo(currentPage,lenPagelist,totalPages,pageListType,rsObj.recordcount)
					content=replace(content,matchPagelist.value,strPagelist)
				end if
			next
			tPages=ifthen(totalPages=0,1,totalPages)
			if Instr(content,"{/"&pageListType&"list:pagenumber}")>0 then
				regExpObj.Pattern=labelRulePagelist2
				set matchesPagelist=regExpObj.Execute(content)
				for each matchPagelist in matchesPagelist
					lenPagelist=parseAttr(matchPagelist.SubMatches(0))("len")
					strPagelist=matchPagelist.SubMatches(1)
					if isNul(lenPagelist) then lenPagelist=10 else lenPagelist=clng(lenPagelist)
					strPagelist=makePagenumberLoop(currentPage,lenPagelist,tPages,pageListType,strPagelist)
					content=replace(content,matchPagelist.value,strPagelist)
				next
			end if
			content=replace(content,"{"&pageListType&"list:page}",currentPage)
			content=replace(content,"{"&pageListType&"list:pagecount}",tPages)
			content=replace(content,"{"&pageListType&"list:recordcount}",rsObj.recordcount)

			content=replace(content,"{"&pageListType&"list:firstlink}",getPageLink(1,pageListType))
			content=replace(content,"{"&pageListType&"list:backlink}",getPageLink(ifthen(currentPage>1,currentPage-1,1),pageListType))
			content=replace(content,"{"&pageListType&"list:nextlink}",getPageLink(ifthen(currentPage<tPages,currentPage+1,tPages),pageListType))
			content=replace(content,"{"&pageListType&"list:lastlink}",getPageLink(tPages,pageListType))
			set matchesPagelist=nothing:set matchesfield=nothing:strDictionary.removeAll
			exit for
		next
		set matchesChannel=nothing
	End Sub

	Public Function getMenuArray(ByVal sId,ByVal m,ByVal by)
		if by="news" then
			getMenuArray=getMenuByArray(sId,m,getNewsTypeLists())
		else
			getMenuArray=getMenuByArray(sId,m,getTypeLists())
		end if
	End Function
	
	Public Function getMenuByArray(ByVal sId,ByVal m,ByVal ary)
		Dim i,j,k,l,h,vnum,rsArray,typeArray:vnum=-1:typeArray=ary:j=getTypeIndex("m_id"):k=getTypeIndex("m_name"):l=getTypeIndex("m_upid"):h=getTypeIndex("m_hide")
		if m="m_id" then:m=j:else:m=l:end if
		for i=0 to UBound(typeArray,2)
			if InStr(" ,"&sId&",",","&typeArray(m,i)&",")>0 AND ""&typeArray(h,i)="0" then
				vnum=vnum+1
				if not isArray(rsArray) then
					Redim rsArray(2,vnum)
				else
					Redim preserve rsArray(2,vnum)
				end if
				rsArray(0,vnum)=typeArray(k,i)
				rsArray(1,vnum)=typeArray(j,i)
				rsArray(2,vnum)=typeArray(l,i)
			end if
		next
		getMenuByArray=rsArray
	End Function

	Public Sub parseMenuList(str)
		dim match,matches,matchfield,matchesfield
		dim labelAttrMenulist,loopstrMenulist,loopnew,loopstrTotal
		dim att,vtype,vnum,vby,curUpId,curUpIdStr,curUpIdStrArray
		dim fieldName,fieldAttr,fieldNameAndAttr,fieldAttrLen,tlink
		dim i,labelRuleField
		dim m,rsArray,rsFlag
		labelRule="{maxcms:"&str&"menulist([\s\S]*?)}([\s\S]*?){/maxcms:"&str&"menulist}"
		labelRuleField="\["&str&"menulist:([\s\S]+?)\]"
		regExpObj.Pattern=labelRule
		set matches=regExpObj.Execute(content)
		for each match in matches
			loopstrTotal=""
			labelAttrMenulist=match.SubMatches(0)
			loopstrMenulist=match.SubMatches(1)
			Set att=parseAttr(labelAttrMenulist):vtype=att("type"):vby=att("by"):Set att=nothing
			if isNul(vtype) then vtype="top"
			select case vtype
				case "top"
					rsFlag="top":rsArray=getMenuArray("0","m_upid",vby)
					if isArray(rsArray) then:vnum=UBound(rsArray,2):else:vnum=-1:end if
				case "son"
					rsFlag="son"
					if vby="news" then:curUpIdStr=getNewsTypeNameTemplateArrayOnCache(clng(currentTypeId)):else:curUpIdStr=getTypeNameTemplateArrayOnCache(clng(currentTypeId)):end if
					curUpIdStrArray=split(curUpIdStr,",")
					if ubound(curUpIdStrArray)>=2 then curUpId=trim(curUpIdStrArray(2)) else curUpId=-444
					if curUpId="" then curUpId=0
					if clng(curUpId)<>0 then
						rsArray=getMenuArray(curUpId,"m_upid",vby)
					else
						rsArray=getMenuArray(trim(currentTypeId),"m_upid",vby)
					end if
					if isArray(rsArray) then:vnum=UBound(rsArray,2):else:vnum=-1:end if
				case "all"
					rsFlag="all":vnum=-1:loopstrTotal=getAllMenuListOnCache(0,vby)
				case else
					vtype=split(vtype,",")
					for i=0 to ubound(vtype)
						vtype(i)=trim(vtype(i))
						if not isnum(vtype(i)) then die channellistInfo(1)
					next
					vtype=Join(vtype,",")
					if isNul(str) then
						rsArray=getMenuArray(vtype,"m_id",vby)
					else
						rsArray=getMenuArray(vtype,"m_upid",vby)
					end if
					if isArray(rsArray) then:vnum=UBound(rsArray,2):else:vnum=-1:end if
			end select
			regExpObj.Pattern=labelRuleField
			set matchesfield=regExpObj.Execute(loopstrMenulist)
			for i=0 to vnum
				loopnew=loopstrMenulist
				if vby="news" then
					tlink=getNewsTypeLink(rsArray(1,i))
				else
					tlink=getTypeLink(rsArray(1,i))
				end if
				for each matchfield in matchesfield
					fieldNameAndAttr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
					fieldNameAndAttr=trimOuter(fieldNameAndAttr)
					m=instr(fieldNameAndAttr,chr(32))
					if m > 0 then
						fieldName=left(fieldNameAndAttr,m - 1)
						fieldAttr =	right(fieldNameAndAttr,len(fieldNameAndAttr) - m)
					else
						fieldName=fieldNameAndAttr
						fieldAttr =	""
					end if
					select case fieldName
						case "i"
							loopnew=replaceStr(loopnew,matchfield.value,i+1)
						case "typeid"
							loopnew=replaceStr(loopnew,matchfield.value,rsArray(1,i))
						case "typename"
							loopnew=replaceStr(loopnew,matchfield.value,rsArray(0,i))
						case "upid"
							loopnew=replaceStr(loopnew,matchfield.value,rsArray(2,i))
						case "link"
							loopnew=replaceStr(loopnew,matchfield.value,tlink)
					end select
				next
				loopstrTotal=loopstrTotal&loopnew
			next
			set matchesfield=nothing
			content=replaceStr(content,match.value,loopstrTotal)
			strDictionary.removeAll
		next
		set matches=nothing
		if isExistStr(content,"{maxcms:smallmenulist") then parseMenuList "small" else Exit Sub
	End Sub

	Public Sub parseTopicList()
		if not isExistStr(content,"{maxcms:topiclist") then Exit Sub
		dim match,matches,matchfield,matchesfield
		dim labelAttrTopiclist,loopstrTopiclist,loopstrTopiclistNew,loopstrTotal
		dim vtid,vnum,vstart,attr,n,ni:n=0
		dim fieldName,fieldAttr,fieldNameAndAttr,fieldAttrLen
		dim i,labelRuleField
		dim m,rsArray,rsFlag,whereTopic
		labelRule="{maxcms:topiclist([\s\S]*?)}([\s\S]*?){/maxcms:topiclist}"
		labelRuleField="\[topiclist:([\s\S]+?)\]"
		regExpObj.Pattern=labelRule
		set matches=regExpObj.Execute(content)
		for each match in matches
			loopstrTotal=""
			labelAttrTopiclist=match.SubMatches(0)
			loopstrTopiclist=match.SubMatches(1)
			SET attr=parseAttr(labelAttrTopiclist):vtid=attr("id"):vnum=attr("num"):vstart=attr("start")
			if isNul(vtid) then vtid="all"
			if isNul(vnum) then vnum=10 else vnum=clng(vnum)
			if not isNul(vstart) then vstart=clng(vstart) else vstart=1
			select case trim(vtid)
				case "all":whereTopic=""
				case else
					if instr(vtid,",")>0 then whereTopic=" where m_id in("&vtid&")" else whereTopic=" where m_id ="&vtid
			end select
			n=vstart-1:vnum=vnum+vstart-1:ni=1
			rsArray=conn.db("select top "&vnum&" m_name,m_id,m_pic,m_enname,m_des from {pre}topic "&whereTopic&" order by m_sort asc","array")
			if isArray(rsArray) then vnum=ubound(rsArray,2)  else  vnum=-1
			regExpObj.Pattern=labelRuleField
			set matchesfield=regExpObj.Execute(loopstrTopiclist)
			for i=n to vnum
				loopstrTopiclistNew=loopstrTopiclist
				for each matchfield in matchesfield
					fieldNameAndAttr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
					fieldNameAndAttr=trimOuter(fieldNameAndAttr)
					m=instr(fieldNameAndAttr,chr(32))
					if m > 0 then
						fieldName=left(fieldNameAndAttr,m - 1)
						fieldAttr =	right(fieldNameAndAttr,len(fieldNameAndAttr) - m)
					else
						fieldName=fieldNameAndAttr
						fieldAttr =	""
					end if
					select case fieldName
						case "i"
							loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,i+1)
						case "n"
							loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,ni)
						case "id"
							loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,rsArray(1,i))
						case "name"
							loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,rsArray(0,i))
						case "count"
							loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,conn.db("select count(*) from {pre}data where m_topic="&rsArray(1,i),"execute")(0))
						case "pic"
							if not isNul(rsArray(2,i)) then
								if instr(rsArray(2,i),"http://")>0 then
									loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,rsArray(2,i))
								else
									loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,"/"&sitePath&"pic/zt/"&rsArray(2,i))
								end if
							else
								loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,"/"&sitePath&"pic/nopic.gif")
							end if
						case "link"
							loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,getTopicPageLink(rsArray(1,i),1,rsArray(3,i)))
						case "des"
							dim deslen,m_des:m_des=decodeHtml(rsArray(4,i)):deslen=parseAttr(fieldAttr)("len")
							if isNul(deslen) then deslen=200
							if len(m_des) > clng(deslen) then m_des=left(m_des,clng(deslen)-1)&".."
							loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,m_des)
					end select
				next
				loopstrTotal=loopstrTotal&loopstrTopiclistNew:ni=ni+1
			next
			set matchesfield=nothing:SET attr=nothing
			content=replaceStr(content,match.value,loopstrTotal)
			strDictionary.removeAll
		next
		set matches=nothing
	End Sub

	Public Sub parseTopicIndex(currentPage,totalPages)
		if not isExistStr(content,"{maxcms:topicindexlist") then Exit Sub
		dim match,matches,matchfield,matchesfield,matchesPagelist,strPagelist
		dim labelAttrTopiclist,loopstrTopiclist,loopstrTopiclistNew,loopstrTotal,labelRulePagelist,labelRulePagelist2,matchPagelist
		dim vsize,tPages
		dim fieldName,fieldAttr,fieldNameAndAttr,fieldAttrLen,lenPagelist
		dim i,labelRuleField
		dim m,rsObj,rsFlag
		labelRule="{maxcms:topicindexlist([\s\S]*?)}([\s\S]*?){/maxcms:topicindexlist}"
		labelRuleField="\[topicindexlist:([\s\S]+?)\]"
		labelRulePagelist="\[topicindexlist:pagenumber([\s\S]*?)\]"
		labelRulePagelist2="\{topicindexlist:pagenumber([\s\S]*?)\}([\s\S]*?){/topicindexlist:pagenumber}"
		regExpObj.Pattern=labelRule
		set matches=regExpObj.Execute(content)
		for each match in matches
			loopstrTotal=""
			labelAttrTopiclist=match.SubMatches(0)
			loopstrTopiclist=match.SubMatches(1)
			vsize=clng(parseAttr(labelAttrTopiclist)("size"))
			set rsObj=conn.db("select m_name,m_id,m_pic,m_enname,m_des from {pre}topic order by m_sort asc","records1")
			if rsObj.eof then
				loopstrTotal=topicpageInfo(0)
			else
				rsObj.pagesize=vsize
				if clng(currentPage)>clng(rsObj.pagecount) then currentPage=rsObj.pagecount
				rsObj.absolutepage=currentPage:loopstrTotal=""
				regExpObj.Pattern=labelRuleField
				set matchesfield=regExpObj.Execute(loopstrTopiclist)
				for i=1 to vsize
					loopstrTopiclistNew=loopstrTopiclist
					for each matchfield in matchesfield
						fieldNameAndAttr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
						fieldNameAndAttr=trimOuter(fieldNameAndAttr)
						m=instr(fieldNameAndAttr,chr(32))
						if m > 0 then
							fieldName=left(fieldNameAndAttr,m - 1)
							fieldAttr =	right(fieldNameAndAttr,len(fieldNameAndAttr) - m)
						else
							fieldName=fieldNameAndAttr
							fieldAttr =	""
						end if
						select case fieldName
							case "i"
								loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,i+1)
							case "name"
								loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,rsObj(0))
							case "count"
								loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,conn.db("select count(*) from {pre}data where m_topic="&rsObj(1),"execute")(0))
							case "pic"
								if not isNul(rsObj(2)) then
									if instr(rsObj(2),"http://")>0 then
										loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,rsObj(2))
									else
										loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,"/"&sitePath&"pic/zt/"&rsObj(2))
									end if
								else
									loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,"/"&sitePath&"pic/nopic.gif")
								end if
							case "link"
								loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,getTopicPageLink(rsObj(1),1,rsObj(3)))
							case "des"
								dim deslen,m_des:m_des=decodeHtml(rsObj(4)):deslen=parseAttr(fieldAttr)("len")
								if isNul(deslen) then deslen=200
								if len(m_des) > clng(deslen) then m_des=left(m_des,clng(deslen)-1)&".."
								loopstrTopiclistNew=replaceStr(loopstrTopiclistNew,matchfield.value,m_des)
						end select
					next
					loopstrTotal=loopstrTotal&loopstrTopiclistNew
					rsObj.movenext
					if rsObj.eof then exit for
				next
				set matchesfield=nothing
			end if
			content=replaceStr(content,match.value,loopstrTotal)
			regExpObj.Pattern=labelRulePagelist
			set matchesPagelist=regExpObj.Execute(content)
			for each matchPagelist in matchesPagelist
				if rsObj.pagecount=0 then
					content=replace(content,matchPagelist.value,"")
				else
					lenPagelist=parseAttr(matchPagelist.SubMatches(0))("len")
					if isNul(lenPagelist) then lenPagelist=10 else lenPagelist=clng(lenPagelist)
					strPagelist=pageNumberLinkInfo(currentPage,lenPagelist,rsObj.pagecount,"topicindex",rsObj.recordcount)
					content=replace(content,matchPagelist.value,strPagelist)
				end if
			next
			tPages=ifthen(totalPages=0,1,totalPages)
			if Instr(content,"{/topicindexlist:pagenumber}")>0 then
				regExpObj.Pattern=labelRulePagelist2
				set matchesPagelist=regExpObj.Execute(content)
				for each matchPagelist in matchesPagelist
					lenPagelist=parseAttr(matchPagelist.SubMatches(0))("len")
					strPagelist=matchPagelist.SubMatches(1)
					if isNul(lenPagelist) then lenPagelist=10 else lenPagelist=clng(lenPagelist)
					strPagelist=makePagenumberLoop(currentPage,lenPagelist,tPages,"topicindex",strPagelist)
					content=replace(content,matchPagelist.value,strPagelist)
				next
			end if
			content=replace(content,"{topicindexlist:page}",currentPage)
			content=replace(content,"{topicindexlist:pagecount}",tPages)
			content=replace(content,"{topicindexlist:recordcount}",rsObj.recordcount)

			content=replace(content,"{topicindexlist:firstlink}",getPageLink(1,"topicindex"))
			content=replace(content,"{topicindexlist:backlink}",getPageLink(ifthen(currentPage>1,currentPage-1,1),"topicindex"))
			content=replace(content,"{topicindexlist:nextlink}",getPageLink(ifthen(currentPage<tPages,currentPage+1,tPages),"topicindex"))
			content=replace(content,"{topicindexlist:lastlink}",getPageLink(tPages,"topicindex"))
			set matchesPagelist=nothing:rsObj.close:set rsObj=nothing
		next
		set matches=nothing
	End Sub

	Public Sub parseLinkList()
		if not isExistStr(content,"{maxcms:linklist") then Exit Sub
		dim match,matches,matchfield,matchesfield
		dim labelAttrLinklist,loopstrLinklist,loopnew,loopstrTotal
		dim vtype,vnum,whereStr,linkArray
		dim fieldName,fieldAttr,fieldNameAndAttr,fieldAttrLen
		dim i,labelRuleField
		dim m,namelen,deslen,m_des
		labelRule="{maxcms:linklist([\s\S]*?)}([\s\S]*?){/maxcms:linklist}"
		labelRuleField="\[linklist:([\s\S]+?)\]"
		regExpObj.Pattern=labelRule
		set matches=regExpObj.Execute(content)
		for each match in matches
			labelAttrLinklist=match.SubMatches(0)
			loopstrLinklist=match.SubMatches(1)
			vtype=parseAttr(labelAttrLinklist)("type")
			if isNul(vtype) then vtype="font"
			select case vtype
				case "font":whereStr=chr(32)&"m_type='font'"&chr(32)
				case "pic":whereStr=chr(32)&"m_type='pic'"&chr(32)
				case else:whereStr=chr(32)&"m_type='font'"&chr(32)
			end select
			linkArray=conn.db("select m_name,m_pic,m_url,m_des from {pre}link  where "&whereStr&" order by m_sort asc","array")
			if not isarray(linkArray) then vnum=-1  else vnum=ubound(linkArray,2)
			regExpObj.Pattern=labelRuleField
			set matchesfield=regExpObj.Execute(loopstrLinklist)
			loopstrTotal=""
			for i=0 to vnum
				loopnew=loopstrLinklist
				for each matchfield in matchesfield
					fieldNameAndAttr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
					fieldNameAndAttr=trimOuter(fieldNameAndAttr)
					m=instr(fieldNameAndAttr,chr(32))
					if m > 0 then
						fieldName=left(fieldNameAndAttr,m - 1)
						fieldAttr =	right(fieldNameAndAttr,len(fieldNameAndAttr) - m)
					else
						fieldName=fieldNameAndAttr
						fieldAttr =	""
					end if
					select case fieldName
						case "name"
							namelen=parseAttr(fieldAttr)("len"):if isNul(namelen) then namelen=8 else namelen=clng(namelen)
							loopnew=replaceStr(loopnew,matchfield.value,left(linkArray(0,i),namelen))
						case "link"
							loopnew=replaceStr(loopnew,matchfield.value,linkArray(2,i))
						case "pic"
							loopnew=replaceStr(loopnew,matchfield.value,linkArray(1,i))
						case "des"
							m_des=decodeHtml(linkArray(3,i)):deslen=parseAttr(fieldAttr)("len")
							if isNul(deslen) then deslen=100
							if len(m_des) > clng(deslen) then m_des=left(m_des,clng(deslen)-1)&".."
							loopnew=replaceStr(loopnew,matchfield.value,m_des)
						case "i"
							loopnew=replaceStr(loopnew,matchfield.value,i+1)
					end select
				next
				loopstrTotal=loopstrTotal&loopnew
			next
			set matchesfield=nothing
			content=replaceStr(content,match.value,loopstrTotal)
			strDictionary.removeAll
		next
		set matches=nothing
	End Sub

	Public Sub parsePlayList(ByVal typeid,ByVal dataId,ByVal enname,ByVal sDate,ByVal playORdownData,ByVal str)
		if not isExistStr(content,"{playpage:playlist") and not isExistStr(content,"{playpage:downlist") then Exit Sub
		dim match,matches,matchfield,matchesfield
		dim loopstrPlaylist,loopstrPlaylistNew,loopstrTotal
		dim vtype,playRsArray,playDataArray,singlePlayData,vnum,videoFrom,videoUrl
		dim fieldName,fieldAttr,fieldNameAndAttr
		dim i,labelRuleField,i_2,PlayerIntroArray:PlayerIntroArray=getPlayerIntroArrayOnCache(str)
		dim m,videoFromStr,videoFromCount,whereStr,n,urlStr,playerInfoStr,playerSingleInfoArray
		labelRule="{playpage:"&str&"list\s*}([\s\S]*?){/playpage:"&str&"list}"
		labelRuleField="\["&str&"list:([\s\S]+?)\]"
		'whereStr =chr(32)&"m_id="&dataId&chr(32)
		regExpObj.Pattern=labelRule
		set matches=regExpObj.Execute(content)
		for each match in matches
			loopstrPlaylist=match.SubMatches(0)
			'playRsArray=conn.db("select m_type,m_"&str&"data from {pre}data where "&whereStr,"array")
			'playDataArray=getPlayurlArray(playRsArray(1,0))
			if IsFromSort=1 then playORdownData=ResetFromSort(playORdownData)
			playDataArray=getPlayurlArray(playORdownData)
			vnum=ubound(playDataArray)
			regExpObj.Pattern=labelRuleField
			set matchesfield=regExpObj.Execute(loopstrPlaylist)
			i_2=0:loopstrTotal=""
			for i=0 to vnum
				singlePlayData=split(playDataArray(i),"$$"):videoFrom=i:videoUrl=singlePlayData(1)
				playerInfoStr=getPlayerIntroOnCache(str,singlePlayData(0))
				if isExistStr(playerInfoStr,"__maxcc__") then
					playerSingleInfoArray=split(playerInfoStr,"__maxcc__")
					loopstrPlaylistNew=loopstrPlaylist
					if playerSingleInfoArray(1)="1" then
						i_2=i_2+1
						for each matchfield in matchesfield
							fieldNameAndAttr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
							fieldNameAndAttr=trimOuter(fieldNameAndAttr)
							m=instr(fieldNameAndAttr,chr(32))
							if m > 0 then
								fieldName=left(fieldNameAndAttr,m - 1)
								fieldAttr =	right(fieldNameAndAttr,len(fieldNameAndAttr) - m)
							else
								fieldName=fieldNameAndAttr
								fieldAttr =	""
							end if
							select case fieldName
								case "from"
									loopstrPlaylistNew=replace(replace(loopstrPlaylistNew,matchfield.value,singlePlayData(0)),"播客CC","FLV高清")
								case "intro"
									loopstrPlaylistNew=replace(loopstrPlaylistNew,matchfield.value,playerSingleInfoArray(0))
								case "link"
									urlStr=getPlayUrlList(videoFrom,videoUrl,typeid,dataId,enname,sDate,str,parseAttr(fieldAttr)("target"))
									loopstrPlaylistNew=replace(loopstrPlaylistNew,matchfield.value,urlStr)
								case "i"
									loopstrPlaylistNew=replace(loopstrPlaylistNew,matchfield.value,i_2)
							end select
						next
					else
						loopstrPlaylistNew=""
					end if
				else
					loopstrPlaylistNew=""
				end if
				loopstrTotal=loopstrTotal&loopstrPlaylistNew
			next
			set matchesfield=nothing
			content=replace(content,match.value,loopstrTotal)
			content=replace(content,"{playpage:"&str&"listlen}",i_2)
			strDictionary.removeAll
		next
		set matches=nothing
	End Sub

	Public Sub parseNews(ByVal vid,ByVal title,ByVal color,ByVal txt,ByVal addtime)
		dim labelRule,matchfield ,matches , fieldNameAndAttr , m , fieldName ,fieldAttr,x,y,z
		labelRule="{news:([\s\S]+?)}"
		regExpObj.Pattern=labelRule
		set matches=regExpObj.Execute(content)
		for each matchfield in matches
			fieldNameAndAttr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
			fieldNameAndAttr=trimOuter(fieldNameAndAttr)
			m=instr(fieldNameAndAttr,chr(32))
			if m > 0 then
			fieldName=left(fieldNameAndAttr,m - 1)
				fieldAttr =	right(fieldNameAndAttr,len(fieldNameAndAttr) - m)
			else
				fieldName=fieldNameAndAttr
				fieldAttr =	""
			end if
			select case fieldName
				case "title"
					x=title:y=parseAttr(fieldAttr)("len")
					if not isNul(y) and len(x) > clng(y) then x=left(x,clng(y)-1)&".."
					content=replaceStr(content,matchfield.value,x)
				case "colortitle"
					x=title:y=parseAttr(fieldAttr)("len"):if not isNul(y) and len(x)>clng(y) then x=left(x,clng(y)-1)&".."
					y=color:if not(isnul(y)) then:x="<font color="&y&">"&x&"</font>":end if:content=replaceStr(content,matchfield.value,x)
				case "content"
					x=replaceStr(replaceStr(decodeHtml(txt),"#p#",""),"#e#",""):y=parseAttr(fieldAttr)("len")
					if not isNul(y) and len(x)>clng(y) then x=left(filterStr(x,"html"),clng(y)-1)&".."
					content=replaceStr(content,matchfield.value,x)
				case "addtime","time"
					x=addtime:y=parseAttr(fieldAttr)("style"):if isNul(y) then y="mm-dd"
					select case y
						case "yyyy-mm-dd"
							content=replaceStr(content,matchfield.value,year(x)&"-"&Right("00"&month(x),2)&"-"&right("00"&day(x),2))
						case "yy-mm-dd"
							content=replaceStr(content,matchfield.value,right(year(x),2)&"-"&Right("00"&month(x),2)&"-"&right("00"&day(x),2))
						case "yyyy-m-d"
							content=replaceStr(content,matchfield.value,year(x)&"-"&month(x)&"-"&day(x))
						case "mm-dd"
							content=replaceStr(content,matchfield.value,Right("00"&month(x),2)&"-"&right("00"&day(x),2))
						case else
							content=replaceStr(content,matchfield.value,x)
					end select
			end select
		next
		set matches=nothing
	End Sub

	Public Sub parseNewsList()
		if not isExistStr(content,"{maxcms:newslist") then Exit Sub
		dim match,matches,matchfield,matchesfield
		dim labelAttr,loopstrVideoList,loopnew,loopstrTotal,attr
		dim vnum,vorder,vtype,vtopic,vtime,vstart,vstate,vcommend,vletter,vid,avid
		dim fieldName,fieldAttr,fieldNameAndAttr,fieldAttrLen
		dim i,labelRuleField,field_des,n,ni:n=0
		dim namelen,attrval,actorlen,deslen,timestyle,videoTime,colornamelen,m_colorname,m_des,m_color,m_note,notelen,m_name,m_actor
		dim m,sql,orderStr,whereType,whereLetter,whereTopic,whereTime,whereStr,rsary,whereCommend,whereId,whereVid,vtypeArray,vtypeI,vtypeStr,vtypeArrayLen,playlink_str
		labelRule="{maxcms:newslist([\s\S]*?)}([\s\S]*?){/maxcms:newslist}"
		labelRuleField="\[newslist:([\s\S]+?)\]"
		regExpObj.Pattern=labelRule
		set matches=regExpObj.Execute(content)
		for each match in matches
			labelAttr=match.SubMatches(0)
			loopstrVideoList=match.SubMatches(1)
			if isExistStr(loopstrVideoList,"[newslist:des") OR isExistStr(loopstrVideoList,"[newslist:content") then field_des="m_content" else field_des="0"
			set attr=parseAttr(labelAttr)
			vnum=attr("num"):vorder=attr("order"):vletter=attr("letter"):vtype=attr("type"):vtopic=attr("topic"):vtime=attr("time"):vstart=attr("start"):vcommend=attr("commend"):vid=attr("id"):avid=attr("vid")
			if isNul(vnum) then vnum=10 else vnum=clng(vnum)
			if isNul(vorder) AND isNul(vid) then vorder="time"
			if isNul(vorder) then vorder="id"
			select case vorder
				case "id":orderStr =" order by m_id desc"
				case "hit":orderStr =" order by m_hit desc"
				case "dayhit":orderStr =" order by m_dayhit desc"
				case "weekhit":orderStr =" order by m_weekhit desc"
				case "monthhit":orderStr =" order by m_monthhit desc"
				case "time":orderStr =" order by m_addtime desc"
				case "commend":orderStr =" order by m_commend desc"
				case "digg":orderStr =" order by m_digg desc"
				case "score":orderStr =" order by m_score desc"
				case "random"
				if databaseType=0 then
					dim rndNum:randomize():rndNum=int(1000*rnd)+1:orderStr =" order by rnd( -1*"&rndNum&" * m_id)"
				else
					orderStr=" order by newid() desc"
				end if
			end select
			if isNul(vtype) then vtype="all"
			vtypeStr=""
			if vtype <> "all" then
				if vtype="current" then
					vtypeStr=getNewsTypeIdOnCache(currentTypeId)
				else
					if instr(vtype,",")>0 then
						vtypeArray=split(vtype,","):vtypeArrayLen=ubound(vtypeArray)
						for vtypeI=0 to  vtypeArrayLen
							vtypeStr=vtypeStr&getNewsTypeIdOnCache(vtypeArray(vtypeI))&","
						next
						vtypeStr=trimOuterStr(vtypeStr,",")
					else
						vtypeStr=getNewsTypeIdOnCache(vtype)
					end if
				end if
				if InStr(vtypeStr,",")>0 then:whereType=" and m_type in ("&vtypeStr&") ":else:whereType=" and m_type="&vtypeStr:end if
			else
				whereType=""
			end if
			if not Isnul(vletter) AND vletter<>"all" then whereLetter=" and m_letter ='"&UCase(vletter)&"' " else whereLetter=""
			if not Isnul(vid) AND vid<>"all" then
				if InStr(vid,",")>0 then:whereId=" and m_id IN ("&vid&") ":else:whereId=" and m_id="&vid:end if
			else
				whereId=""
			end if
			if not Isnul(avid) AND avid<>"all" then
				if InStr(avid,",")>0 then:whereVid=" and m_vid IN ("&avid&") ":else:whereVid=" and m_vid="&vid:end if
			else
				whereVid=""
			end if
			if not isNul(vcommend) then
				select case trim(vcommend)
					case "all":whereCommend=" and  m_commend>0"
					case else
						if instr(vcommend,",")>0 then whereCommend=" and m_commend in("&vcommend&")" else whereCommend=" and m_commend ="&vcommend
				end select
			else
				whereCommend=""
			end if
			if not isNul(vtopic) then
				select case trim(vtopic)
					case "all":whereTopic=" and m_topic>0"
					case "current":whereTopic=" and m_topic="&currentTopicId
					case else
						if instr(vtopic,",")>0 then whereTopic=" and m_topic in("&vtopic&")" else whereTopic=" and m_topic ="&vtopic
				end select
			else
				whereTopic=""
			end if
			if databaseType = 0 then
				select case vtime
					case "day":whereTime=" and  DateDiff('d',m_addtime,#"&now()&"#)=0"
					case "week":whereTime=" and  DateDiff('d',m_addtime,#"&now()&"#)<7"
					case "month":whereTime=" and  DateDiff('d',m_addtime,#"&now()&"#)<31"
					case else:whereTime=""
				end select
			else
				select case vtime
					case "day":whereTime=" and  DateDiff(d,m_addtime,'"&now()&"')=0"
					case "week":whereTime=" and  DateDiff(d,m_addtime,'"&now()&"')<7"
					case "month":whereTime=" and  DateDiff(d,m_addtime,'"&now()&"')<31"
					case else:whereTime=""
				end select
			end if
			whereStr=Replace(" where m_recycle=0"&whereType&whereLetter&whereTopic&whereTime&whereCommend&whereId&whereVid,"where  and ","where ")
			'if trim(whereStr)="where" then whereStr=""
			if not isNul(vstart) then vstart=clng(vstart) else vstart=1
			n=vstart-1:vnum=vnum+vstart-1:ni=1
			set attr=nothing
			sql="select top "&vnum+1&" m_id,m_title,m_type,m_vid,m_pic,m_hit,m_author,"&field_des&",m_topic,m_color,m_addtime,m_from,m_outline,m_commend,m_letter,m_keyword,m_digg,m_tread,m_entitle,m_datetime,m_note,m_dayhit,m_weekhit,m_monthhit,m_score from {pre}news "&whereStr&orderStr
			conn.fetchCount=vnum:rsary=conn.db(sql,"array"):conn.fetchCount=0
			regExpObj.Pattern=labelRuleField
			set matchesfield=regExpObj.Execute(loopstrVideoList)
			loopstrTotal=""
			if isArray(rsary) then vnum=ubound(rsary,2) else vnum=-1
			for i=n to vnum
				loopnew=loopstrVideoList
				for each matchfield in matchesfield
					fieldNameAndAttr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
					fieldNameAndAttr=trimOuter(fieldNameAndAttr)
					m=instr(fieldNameAndAttr,chr(32))
					if m > 0 then
						fieldName=left(fieldNameAndAttr,m - 1)
						fieldAttr =	right(fieldNameAndAttr,len(fieldNameAndAttr) - m)
					else
						fieldName=fieldNameAndAttr
						fieldAttr =	""
					end if
					select case fieldName
						case "id"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(0,i))
						case "typeid"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(2,i))
						case "letter"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(14,i))
						case "title","name"
							m_name=rsary(1,i):namelen=parseAttr(fieldAttr)("len")
							if not isNul(namelen) and len(m_name)>clng(namelen) then m_name=left(m_name,clng(namelen)-1)&".."
							loopnew=replaceStr(loopnew,matchfield.value,m_name)
						case "colortitle","colorname"
							m_color=rsary(9,i):m_name=rsary(1,i):colornamelen=parseAttr(fieldAttr)("len")
							if not isNul(colornamelen) and len(m_name)>clng(colornamelen) then m_name=left(m_name,clng(colornamelen)-1)&".."
							if not(isnul(m_color)) then m_name="<font color="&m_color&">"&m_name&"</font>"
							loopnew=replaceStr(loopnew,matchfield.value,m_name)
						case "outline"
							m_note=rsary(12,i):notelen=parseAttr(fieldAttr)("len")
							if not isNul(notelen) and len(m_note) > clng(notelen) then m_note=left(m_note,clng(notelen)-1)&".."
							loopnew=replaceStr(loopnew,matchfield.value,m_note)
						case "author"
							m_actor=rsary(6,i):actorlen=parseAttr(fieldAttr)("len")
							if not isNul(actorlen) and len(m_actor) > clng(actorlen) then m_actor=left(m_actor,clng(actorlen)-1)&".."
							loopnew=replaceStr(loopnew,matchfield.value,m_actor)
						case "content","des"
							m_des=filterStr(decodeHtml(rsary(7,i)),"html"):m_des=replaceStr(replaceStr(m_des,"#p#",""),"#e#",""):deslen=parseAttr(fieldAttr)("len")
							if isNul(deslen) then deslen=200
							if len(m_des) > clng(deslen) then m_des=left(m_des,clng(deslen)-1)&".."
							loopnew=replaceStr(loopnew,matchfield.value,m_des)
						case "addtime","time"
							videoTime=rsary(10,i):timestyle=parseAttr(fieldAttr)("style"):if isNul(timestyle) then timestyle="mm-dd"
							dim monthDayTime:monthDayTime=right("00"&month(videoTime),2)&"-"&right("00"&day(videoTime),2)
							select case timestyle
								case "yyyy-mm-dd"
									loopnew=replaceStr(loopnew,matchfield.value,year(videoTime)&"-"&monthDayTime)
								case "yy-mm-dd"
									loopnew=replaceStr(loopnew,matchfield.value,right(year(videoTime),2)&"-"&monthDayTime)
								case "yyyy-m-d"
									loopnew=replaceStr(loopnew,matchfield.value,year(videoTime)&"-"&month(videoTime)&"-"&day(videoTime))
								case else
									loopnew=replaceStr(loopnew,matchfield.value,monthDayTime)
							end select
						case "i"
							loopnew=replaceStr(loopnew,matchfield.value,i+1)
						case "n"
							loopnew=replaceStr(loopnew,matchfield.value,ni)
						case "typename"
							loopnew=replaceStr(loopnew,matchfield.value,Split(getNewsTypeNameTemplateArrayOnCache(clng(rsary(2,i))),",")(0))
						case "typelink"
							loopnew=replaceStr(loopnew,matchfield.value,getNewsTypeLink(rsary(2,i)))
						case "newslink","link"
							loopnew=replaceStr(loopnew,matchfield.value,getNewsArticleLink(rsary(2,i),rsary(0,i),rsary(18,i),rsary(19,i),"link"))
						case "pic"
							if not isNul(rsary(4,i)) then 
								if instr(rsary(4,i),"http://")>0 then 
									loopnew=replaceStr(loopnew,matchfield.value,rsary(4,i))
								else
									loopnew=replaceStr(loopnew,matchfield.value,"/"&sitePath&rsary(4,i))
								end if
							else
								loopnew=replaceStr(loopnew,matchfield.value,"/"&sitePath&"pic/nopic.gif")
							end if
						case "hit"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(5,i))
						case "vid"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(3,i))
						case "from"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(11,i))
						case "commend"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(13,i))
						case "keyword"
							loopnew=replaceStr(loopnew,matchfield.value,replaceStr(getKeywordsList(rsary(15,i)," "),"search.asp","so.asp"))
						case "digg"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(16,i))
						case "tread"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(17,i))
						case "note"
							loopnew=replaceStr(loopnew,matchfield.value,parseNewsNote(rsary(20,i)))
						case "dayhit"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(21,i))
						case "weekhit"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(22,i))
						case "monthhit"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(23,i))
						case "score"
							loopnew=replaceStr(loopnew,matchfield.value,rsary(24,i))
					end select
					strDictionary.removeAll
				next
				loopstrTotal=loopstrTotal&loopnew:ni=ni+1
			next
			set matchesfield=nothing
			content=replaceStr(content,match.value,loopstrTotal)
			strDictionary.removeAll
		next
		set matches=nothing
	End Sub

	Public Sub parseNewsPartList(typeId,currentPage,totalPages,pageListType)
		dim matchChannel,matchesChannel,loopstrChannel,loopstrTotal,attrChannel,attr,loopnew
		dim labelRuleField,field_des,field_playdata
		dim vsize,vorder
		dim i,m,sql,rsObj,orderStr,whereStr,sql1,esql,tPages
		dim matchfield,matchesfield,fieldNameAndAttr,fieldName,fieldAttr
		dim namelen,actorlen,deslen,timestyle,videoTime,colornamelen,m_colorname,m_des,m_color,m_note,notelen,m_actor,m_name
		dim matchPagelist,matchesPagelist,labelRulePagelist,labelRulePagelist2,lenPagelist,strPagelist,playlink_str
		labelRule="{maxcms:"&pageListType&"list([\s\S]*?)}([\s\S]*?){/maxcms:"&pageListType&"list}"
		labelRuleField="\["&pageListType&"list:([\s\S]+?)\]"
		labelRulePagelist="\["&pageListType&"list:pagenumber([\s\S]*?)\]"
		labelRulePagelist2="\{"&pageListType&"list:pagenumber([\s\S]*?)\}([\s\S]*?){/"&pageListType&"list:pagenumber}"
		if isExistStr(content,"["&pageListType&"list:des") OR isExistStr(content,"["&pageListType&"list:content") then field_des="m_content" else  field_des="0"
		regExpObj.Pattern=labelRule
		set matchesChannel=regExpObj.Execute(content):sql1="select m_id,m_title,m_type,m_vid,m_pic,m_hit,m_author,"&field_des&",m_topic,m_color,m_addtime,m_from,m_outline,m_commend,m_letter,m_keyword,m_digg,m_tread,m_entitle,m_datetime,m_note,m_dayhit,m_weekhit,m_monthhit,m_score from {pre}news "
		for each matchChannel in matchesChannel
			attrChannel=matchChannel.SubMatches(0)
			loopstrChannel=matchChannel.SubMatches(1)
			set attr=parseAttr(attrChannel)
			vsize=clng(attr("size")):vorder=attr("order")
			if isNul(vsize) then vsize=12 
			if isNul(vorder) then vorder="time"
			select case vorder
				case "id":orderStr =" order by m_id desc"
				case "hit":orderStr =" order by m_hit desc"
				case "dayhit":orderStr =" order by m_dayhit desc"
				case "weekhit":orderStr =" order by m_weekhit desc"
				case "monthhit":orderStr =" order by m_monthhit desc"
				case "time":orderStr =" order by m_addtime desc"
				case "commend":orderStr =" order by m_commend desc"
				case "digg":orderStr =" order by m_digg desc"
				case "score":orderStr =" order by m_score desc"
				case "letter":orderstr=" order by m_letter asc"
			end select
			set attr=nothing
			select case pageListType
				case "newspage"
					sql=sql1&"where m_recycle=0 AND m_type in ("&typeId&")"&orderStr
				case "newssearch"
					esql=EscapeSql(searchword)
					select case clng(searchType)
						case -1:whereStr=" where m_recycle=0 AND m_title like '%"&esql&"%' or m_keyword like '%"&esql&"%'"
						case 0:whereStr=" where m_recycle=0 AND m_title like '%"&esql&"%'"
						case 1:whereStr=" where m_recycle=0 AND m_author like '%"&esql&"%'"
						case 2:whereStr=" where m_recycle=0 AND m_from like '%"&esql&"%'"
						case 3:whereStr=" where m_recycle=0 AND m_outline like '%"&esql&"%'"
						case 4:whereStr=" where m_recycle=0 AND m_letter='"&UCase(searchword)&"'"
					end select
					if Cstr(searchword)="" then whereStr=" where 1=2"
				sql=sql1&whereStr&orderStr
				case "newstopicpage"
					sql=sql1&"where m_recycle=0 AND m_topic="&typeId&orderStr
				end select
				regExpObj.Pattern=labelRuleField
			set matchesfield=regExpObj.Execute(loopstrChannel)
			set rsObj=conn.db(sql,"records1")
			if rsObj.eof then
				if pageListType="newspage" then
					loopstrTotal=channellistInfo(0)
				elseif pageListType="newssearch" then
					loopstrTotal=searchlistInfo(0)&searchword&searchlistInfo(1)
				elseif pageListType="newstopicpage" then
					loopstrTotal=topicpageInfo(0)
				end if
			else
				rsObj.pagesize=vsize
				if clng(currentPage)>clng(rsObj.pagecount) then currentPage=rsObj.pagecount				
				rsObj.absolutepage=currentPage
				loopstrTotal=""			
				for i=1 to vsize
					loopnew=loopstrChannel
					for each matchfield in matchesfield
						fieldNameAndAttr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
						fieldNameAndAttr=trimOuter(fieldNameAndAttr)
						m=instr(fieldNameAndAttr,chr(32))
						if m > 0 then
							fieldName=left(fieldNameAndAttr,m - 1)
							fieldAttr =	right(fieldNameAndAttr,len(fieldNameAndAttr) - m)
						else
							fieldName=fieldNameAndAttr
							fieldAttr =	""
						end if
						select case fieldName
							case "id"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(0))
							case "typeid"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(2))
							case "title","name"
								m_name=rsObj(1):namelen=parseAttr(fieldAttr)("len")
								if not isNul(namelen) and len(m_name)>clng(namelen) then m_name=left(m_name,clng(namelen)-1)&".."
								loopnew=replaceStr(loopnew,matchfield.value,m_name)
							case "colortitle","colorname"
								m_color=rsObj(9):m_name=rsObj(1):colornamelen=parseAttr(fieldAttr)("len")
								if not isNul(colornamelen) and len(m_name)>clng(colornamelen) then m_name=left(m_name,clng(colornamelen)-1)&".."
								if not(isnul(m_color)) then m_name="<font color="&m_color&">"&m_name&"</font>"
								loopnew=replaceStr(loopnew,matchfield.value,m_name)
							case "outline"
								m_note=rsObj(12):notelen=parseAttr(fieldAttr)("len")
								if not isNul(notelen) and len(m_note) > clng(notelen) then m_note=left(m_note,clng(notelen)-1)&".."
								loopnew=replaceStr(loopnew,matchfield.value,m_note)
							case "author"
								m_actor=rsObj(6):actorlen=parseAttr(fieldAttr)("len")
								if not isNul(actorlen) and len(m_actor) > clng(actorlen) then m_actor=left(m_actor,clng(actorlen)-1)&".."
								loopnew=replaceStr(loopnew,matchfield.value,m_actor)
							case "content","des"
								m_des=filterStr(decodeHtml(rsObj(7)),"html"):m_des=replaceStr(replaceStr(m_des,"#p#",""),"#e#",""):deslen=parseAttr(fieldAttr)("len")
								if isNul(deslen) then deslen=200
								if len(m_des) > clng(deslen) then m_des=left(m_des,clng(deslen)-1)&".."
								loopnew=replaceStr(loopnew,matchfield.value,m_des)
							case "addtime","time"
								videoTime=rsObj(10):timestyle=parseAttr(fieldAttr)("style"):if isNul(timestyle) then timestyle="mm-dd"
								dim monthDayTime:monthDayTime=right("00"&month(videoTime),2)&"-"&right("00"&day(videoTime),2)
								select case timestyle
									case "yyyy-mm-dd"
										loopnew=replaceStr(loopnew,matchfield.value,year(videoTime)&"-"&monthDayTime)
									case "yy-mm-dd"
										loopnew=replaceStr(loopnew,matchfield.value,right(year(videoTime),2)&"-"&monthDayTime)
									case "yyyy-m-d"
										loopnew=replaceStr(loopnew,matchfield.value,year(videoTime)&"-"&month(videoTime)&"-"&day(videoTime))
									case else
										loopnew=replaceStr(loopnew,matchfield.value,monthDayTime)
								end select
							case "i"
								loopnew=replaceStr(loopnew,matchfield.value,i)
							case "typename"
								loopnew=replaceStr(loopnew,matchfield.value,Split(getNewsTypeNameTemplateArrayOnCache(rsObj(2)),",")(0))
							case "typelink"
								loopnew=replaceStr(loopnew,matchfield.value,getNewsTypeLink(rsObj(2)))
							case "newslink","link"
								loopnew=replaceStr(loopnew,matchfield.value,getNewsArticleLink(rsObj(2),rsObj(0),rsObj(18),rsObj(19),"link"))
							case "pic"
								if not isNul(rsObj(4)) then
									if instr(rsObj(4),"http://")>0 then
										loopnew=replaceStr(loopnew,matchfield.value,rsObj(4))
									else
										loopnew=replaceStr(loopnew,matchfield.value,"/"&sitePath&rsObj(4))
									end if
								else
									loopnew=replaceStr(loopnew,matchfield.value,"/"&sitePath&"pic/nopic.gif")
								end if
							case "hit"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(5))
							case "vid"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(3))
							case "commend"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(13))
							case "from"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(11))
							case "keyword"
								loopnew=replaceStr(loopnew,matchfield.value,replaceStr(getKeywordsList(rsObj(15)," "),"search.asp","so.asp"))
							case "digg"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(16))
							case "tread"
								loopnew=replaceStr(loopnew,matchfield.value,rsObj(17))
							case "note"
								loopnew=replaceStr(loopnew,matchfield.value,parseNewsNote(rsObj(20)))
							case "dayhit"
								loopnew=replaceStr(loopnew,matchfield.value,parseNewsNote(rsObj(21)))
							case "weekhit"
								loopnew=replaceStr(loopnew,matchfield.value,parseNewsNote(rsObj(22)))
							case "monthhit"
								loopnew=replaceStr(loopnew,matchfield.value,parseNewsNote(rsObj(23)))
							case "score"
								loopnew=replaceStr(loopnew,matchfield.value,parseNewsNote(rsObj(24)))
						end select
						strDictionary.removeAll
					next
					loopstrTotal=loopstrTotal&loopnew
					rsObj.movenext
					if rsObj.eof then exit for
				next
			end if
			content=replace(content,matchChannel.value,loopstrTotal)
			regExpObj.Pattern=labelRulePagelist
			set matchesPagelist=regExpObj.Execute(content)
			for each matchPagelist in matchesPagelist
				if rsObj.pagecount=0 then
					content=replace(content,matchPagelist.value,"")
				else
					lenPagelist=parseAttr(matchPagelist.SubMatches(0))("len")
					if isNul(lenPagelist) then lenPagelist=10 else lenPagelist=clng(lenPagelist)
					strPagelist=pageNumberLinkInfo(currentPage,lenPagelist,rsObj.pagecount,pageListType,rsObj.recordcount)
					content=replace(content,matchPagelist.value,strPagelist)
				end if
			next
			tPages=ifthen(totalPages=0,1,totalPages)
			if Instr(content,"{/"&pageListType&"list:pagenumber}")>0 then
				regExpObj.Pattern=labelRulePagelist2
				set matchesPagelist=regExpObj.Execute(content)
				for each matchPagelist in matchesPagelist
					lenPagelist=parseAttr(matchPagelist.SubMatches(0))("len")
					strPagelist=matchPagelist.SubMatches(1)
					if isNul(lenPagelist) then lenPagelist=10 else lenPagelist=clng(lenPagelist)
					strPagelist=makePagenumberLoop(currentPage,lenPagelist,tPages,pageListType,strPagelist)
					content=replace(content,matchPagelist.value,strPagelist)
				next
			end if
			content=replace(content,"{"&pageListType&"list:page}",currentPage)
			content=replace(content,"{"&pageListType&"list:pagecount}",tPages)
			content=replace(content,"{"&pageListType&"list:recordcount}",rsObj.recordcount)

			content=replace(content,"{"&pageListType&"list:firstlink}",getPageLink(1,pageListType))
			content=replace(content,"{"&pageListType&"list:backlink}",getPageLink(ifthen(currentPage>1,currentPage-1,1),pageListType))
			content=replace(content,"{"&pageListType&"list:nextlink}",getPageLink(ifthen(currentPage<tPages,currentPage+1,tPages),pageListType))
			content=replace(content,"{"&pageListType&"list:lastlink}",getPageLink(tPages,pageListType))
			set matchesPagelist=nothing:set matchesfield=nothing:strDictionary.removeAll
		next
		set matchesChannel=nothing
	End Sub

	Private Sub parseSlide()
		dim slideStr,slideStr2,slidew,slideh,x
		slideStr="{maxcms:slide"
		if isExistStr(content,slideStr) then
			slideStr2=getSubStrByFromAndEnd(content,slideStr,"}",""):set x=parseAttr(slideStr2)
			slidew=x("width"):slideh=x("height")
			if isNul(slidew) then slidew=400
			if isNul(slideh) then slideh=280
			content=replaceStr(content,slideStr&slideStr2&"}","<script>loadSlide('"&slidew&"','"&slideh&"',sitePath)</script>")
			Set x=nothing
		end if
	End Sub

	Private Sub parseMaxHistory()
		dim x,y,w,h,i,q,c:x="{maxcms:maxhistory"
		content=replaceStr(content,"{maxcms:showhistory}","<a href=""javascript:void(0)"" onclick=""$MH.showHistory(1);"">我的观看历史</a>")
		if isExistStr(content,x) then
			y=getSubStrByFromAndEnd(content,x,"}",""):set q=parseAttr(y)
			w=q("width"):h=q("height"):i=q("num"):c=q("style"):Set q=nothing
			if isNul(w) then w=960
			if isNul(h) then h=170
			if isNul(i) then i=10
			content=replaceStr(content,x&y&"}","<script type=""text/javascript"" src=""/"&sitepath&"js/max_history.js""></script><script type=""text/javascript"">$MH.limit="&i&";$MH.WriteHistoryBox("&w&","&h&",'"&c&"');$MH.recordHistory({name:'{playpage:name}',link:'{playpage:url}',pic:'{playpage:pic}'})</script>")
		end if
	End Sub

	Public Sub paresPreNextVideo(dataid,typeFlag,vtype)
		dim nextid , lastid , nextname, nextenname, nextdatetime ,lastname,lastenname, lastdatetime,mystr,preNextLabel:preNextLabel="{playpage:prenext}"
		if not isExistStr(content,preNextLabel) then Exit Sub
		dim rs:set rs=conn.db("select top 1 m_id as nextid ,m_name as nextname,m_enname AS nextenname,m_datetime AS nextdatetime from {pre}data where m_type="&vtype&" and m_recycle=0 and m_id<"&dataId&" order by m_id desc ","records1")
		if rs.eof and rs.bof then nextid= 0 else nextid=rs("nextid"):nextname=rs("nextname"):nextenname=rs("nextenname"):nextdatetime=rs("nextdatetime")
		set rs=conn.db("select top 1 m_id as lastid,m_name  as lastname,m_enname AS lastenname,m_datetime AS lastdatetime from {pre}data where m_type="&vtype&" and m_recycle=0 and m_id>"&dataId&" order by m_id asc ","records1")
		if rs.eof and rs.bof then lastid= 0  else lastid=rs("lastid"):lastname=rs("lastname"):lastenname=rs("lastenname"):lastdatetime=rs("lastdatetime")
		rs.close
		set rs=nothing
		if typeFlag="parse_play_" then
			if lastid = 0 then mystr = "<span>上一篇:没有了</span> " else mystr = "<span>上一篇:<a href="&getPlayLink2(vtype,lastid,lastenname,lastdatetime,0,0)&">"&lastname&"</a></span> "
			if nextid = 0 then mystr = mystr&"<span>下一篇:没有了</span>" else mystr = mystr&"<span>下一篇:<a href="&getPlayLink2(vtype,nextid,nextenname, nextdatetime,0,0)&">"&nextname&"</a></span>"
		else 
			if lastid = 0 then mystr = "<span>上一篇:没有了</span> " else mystr = "<span>上一篇:<a href="&getContentLink(vtype,lastid,lastenname,lastdatetime,"link")&">"&lastname&"</a></span> "
			if nextid = 0 then mystr = mystr&"<span>下一篇:没有了</span>" else mystr = mystr&"<span>下一篇:<a href="&getContentLink(vtype,nextid,nextenname, nextdatetime,"link")&">"&nextname&"</a></span>"
		end if 
		content=replaceStr(content,preNextLabel,mystr)
	End Sub

	Public Sub paresPreNextNews(dataid,vtype)
		dim nextid , lastid , nextname, nextenname, nextdatetime ,lastname,lastenname, lastdatetime,mystr,preNextLabel:preNextLabel="{news:prenext}"
		if not isExistStr(content,preNextLabel) then Exit Sub
		dim rs:set rs=conn.db("select top 1 m_id as nextid ,m_title as nextname,m_entitle AS nextenname,m_datetime AS nextdatetime from {pre}news where m_type="&vtype&" and m_recycle=0 and m_id<"&dataId&" order by m_id desc ","records1")
		if rs.eof and rs.bof then nextid= 0 else nextid=rs("nextid"):nextname=rs("nextname"):nextenname=rs("nextenname"):nextdatetime=rs("nextdatetime")
		set rs=conn.db("select top 1 m_id as lastid,m_title  as lastname,m_entitle AS lastenname,m_datetime AS lastdatetime from {pre}news where m_type="&vtype&" and m_recycle=0 and m_id>"&dataId&" order by m_id asc ","records1")
		if rs.eof and rs.bof then lastid= 0  else lastid=rs("lastid"):lastname=rs("lastname"):lastenname=rs("lastenname"):lastdatetime=rs("lastdatetime")
		rs.close
		set rs=nothing
		if lastid = 0 then mystr = "<span>上一篇:没有了</span> " else mystr = "<span>上一篇:<a href="&getNewsArticleLink(vtype,lastid,lastenname,lastdatetime,"link")&">"&lastname&"</a></span> "
		if nextid = 0 then mystr = mystr&"<span>下一篇:没有了</span>" else mystr = mystr&"<span>下一篇:<a href="&getNewsArticleLink(vtype,nextid,nextenname, nextdatetime,"link")&">"&nextname&"</a></span>"
		content=replaceStr(content,preNextLabel,mystr)
	End Sub

	Public Sub parsePlayPageSpecial()
		dim x,y,q,l,c:x="{playpage:mark"
		if isExistStr(content,x) then
			y=getSubStrByFromAndEnd(content,x,"}",""):set q=parseAttr(y)
			l=q("len"):c=q("style"):l=ifthen(isNul(l),5,l):c=ifthen(c="",0,1):Set q=nothing
			content=replace(content,x&y&"}","<script type=""text/javascript"">markVideo({playpage:id},{playpage:diggnum},{playpage:treadnum},{playpage:scorenum},"&l&","&c&");</script>")
		end if
		content=replace(content,"{playpage:digg}","<span id=""digg_num"">{playpage:diggnum}</span><a href=""javascript:void(0)"" onclick=""diggVideo({playpage:id},'digg_num')"">顶一下</a>")
		content=replace(content,"{playpage:tread}","<span id=""tread_num"">{playpage:treadnum}</span><a href=""javascript:void(0)"" onclick=""treadVideo({playpage:id},'tread_num')"">踩一下</a>")
		content=replace(content,"{playpage:reporterr}","<a href=""javascript:void(0)"" onclick=""reportErr({playpage:id})"">报 错</a>")
		content=replace(content,"{playpage:comment}","<div id=""comment_list"">评论加载中..</div><script>viewComment(""/"&sitepath&"comment.asp?id={playpage:id}"","""")</script>")
		content=replace(content,"{playpage:hit}","<span id=""hit"">加载中</span><script>getVideoHit('{playpage:id}')</script>")
	End Sub

	Public Sub parseNewsPageSpecial()
		dim x,y,q,l,c:x="{news:mark"
		if isExistStr(content,x) then
			y=getSubStrByFromAndEnd(content,x,"}",""):set q=parseAttr(y)
			l=q("len"):c=q("style"):l=ifthen(isNul(l),5,l):c=ifthen(c="" OR c="radio",0,1):Set q=nothing
			content=replace(content,x&y&"}","<script type=""text/javascript"">markNews({news:id},{news:diggnum},{news:treadnum},{news:scorenum},"&l&","&c&");</script>")
		end if
		content=replace(content,"{news:digg}","<span id=""digg_num"">{news:diggnum}</span><a href=""javascript:void(0)"" onclick=""diggNews({news:id},'digg_num')"">顶一下</a>")
		content=replace(content,"{news:tread}","<span id=""tread_num"">{news:treadnum}</span><a href=""javascript:void(0)"" onclick=""treadNews({news:id},'tread_num')"">踩一下</a>")
		content=replace(content,"{news:comment}","<div  id=""comment_list"">评论加载中..</div><script>viewComment(""/"&sitepath&"comment.asp?id={news:id}"",""news"")</script>")
		content=replace(content,"{news:hit}","<span id=""hit"">加载中</span><script>getNewsHit('{news:id}')</script>")
	End Sub

	Public Sub parseIf()
		if not isExistStr(content,"{if:") then Exit Sub
		dim matchIf,matchesIf,strIf,strThen,strThen1,strElse1,labelRule2,labelRule3
		dim ifFlag,elseIfArray,elseIfSubArray,elseIfArrayLen,resultStr,elseIfLen,strElseIf,strElseIfThen,elseIfFlag
		labelRule="{if:([\s\S]+?)}([\s\S]*?){end\s+if}":labelRule2="{elseif":labelRule3="{else}":elseIfFlag=false
		regExpObj.Pattern=labelRule
		set matchesIf=regExpObj.Execute(content)
		for each matchIf in matchesIf 
			strIf=matchIf.SubMatches(0):strThen=matchIf.SubMatches(1)
			if instr(strThen,labelRule2)>0 then
				elseIfArray=split(strThen,labelRule2):elseIfArrayLen=ubound(elseIfArray):elseIfSubArray=split(elseIfArray(elseIfArrayLen),labelRule3)
				resultStr=elseIfSubArray(1)
				Execute("if "&strIf&" then resultStr=elseIfArray(0)")
				for elseIfLen=1 to elseIfArrayLen-1
					strElseIf=getSubStrByFromAndEnd(elseIfArray(elseIfLen),":","}","")
					strElseIfThen=getSubStrByFromAndEnd(elseIfArray(elseIfLen),"}","","start")
					Execute("if "&strElseIf&" then resultStr=strElseIfThen")
					Execute("if "&strElseIf&" then elseIfFlag=true else  elseIfFlag=false")
					if elseIfFlag then exit for
				next
				Execute("if "&getSubStrByFromAndEnd(elseIfSubArray(0),":","}","")&" then resultStr=getSubStrByFromAndEnd(elseIfSubArray(0),""}"","""",""start""):elseIfFlag=true")
				content=replace(content,matchIf.value,resultStr)
			else 
				if instr(strThen,"{else}")>0 then
					strThen1=split(strThen,labelRule3)(0)
					strElse1=split(strThen,labelRule3)(1)
					Execute("if "&strIf&" then ifFlag=true else ifFlag=false")
					if ifFlag then content=replace(content,matchIf.value,strThen1) else content=replace(content,matchIf.value,strElse1)
				else
					Execute("if "&strIf&" then ifFlag=true else ifFlag=false")
					if ifFlag then content=replace(content,matchIf.value,strThen) else content=replace(content,matchIf.value,"")
				end if
			end if
			elseIfFlag=false
		next
		set matchesIf=nothing
	End Sub
End Class


Class MainClass_DataPage
	Public pagesize
	Private aPage,rCount,Qu

	Private Sub Class_Initialize()
		pagesize=10:aPage=1:rCount=0:Qu=""
	End Sub

	Public Property LET absolutepage(ByVal iPage)
		aPage=ifthen(iPage>0,iPage,1)
	End Property

	Public Property GET absolutepage()
		absolutepage=aPage
	End Property

	Public Property GET pagecount()
		pagecount=Int(rCount / pagesize)+ifthen(rCount MOD pagesize > 0,1,0)
	End Property

	Public Property GET recordcount()
		recordcount=rCount
	End Property

	Public Sub Query(ByVal sql)
		Qu=sql
	End Sub

	Public Function GetRows()
		Dim rs,ret,offset:redim ret(-1,-1):SET rs=Conn.db(Qu,"records1")
		rCount=rs.recordcount:aPage=ifthen(aPage>pagecount,pagecount,aPage)
		if not rs.eof AND pagesize>0 then
			offset=(aPage-1) * pagesize
			rs.move(offset)
			if rCount-offset>0 then
				GetRows=rs.getRows(pagesize)
			else
				GetRows=ret
			end if
		else
			GetRows=ret
		end if
		rs.close:SET rs=nothing
	End Function
End Class


Class MainClass_Xml
	Public xmlDomObj,xmlstr
	Private xmlDomVer,xmlFileSavePath

	Public Sub Class_Initialize()
		xmlDomVer=getXmlDomVer()
		createXmlDomObj
	End Sub

	Public Sub Class_Terminate()
		If IsObject(xmlDomObj) Then Set xmlDomObj=Nothing
	End Sub

	Public Function getXmlDomVer()
		dim i,xmldomVersions,xmlDomVersion
		getXmlDomVer=false
		xmldomVersions=Array("Microsoft.2MLDOM","MSXML2.DOMDocument","MSXML2.DOMDocument.3.0","MSXML2.DOMDocument.4.0","MSXML2.DOMDocument.5.0")
		for i=0 to ubound(xmldomVersions)
			xmlDomVersion=xmldomVersions(i)
			if isInstallObj(xmlDomVersion) then getXmlDomVer=xmlDomVersion:Exit Function
		next
	End Function

	Private Sub createXmlDomObj()
		set xmlDomObj=server.CreateObject(xmlDomVer)
		xmlDomObj.validateonparse=true 
		xmlDomObj.async=false 
	End Sub

	Public Sub load(Byval xml,Byval xmlType)
		dim xmlUrl,xmlfilePath
		select case xmlType 
			case "xmlfile"
				xmlfilePath=server.mappath(xml)   
		 		xmlDomObj.load(xmlfilePath)   
			case "xmldocument"
				xmlUrl=xml
				xmlstr=getRemoteContent(xmlUrl,"text")
				If left(xmlstr, 5) <> "<?xml" then die err_xml else xmlDomObj.loadXML(xmlstr)
			case "transfer"
				xmlUrl=xml
				xmlstr=bytesToStr(getRemoteContent(xmlUrl,"body"),"gbk")
				If left(xmlstr, 5) <> "<?xml" then die err_xml else xmlDomObj.loadXML(xmlstr)
		end select
	End Sub

	Public Function isExistNode(nodename)
        dim node
        isExistNode=True
        set node=xmlDomObj.getElementsByTagName(nodename)
        If node.Length=0 Then isExistNode=False:set node=nothing
    End Function

	Public Function getNodeValue(nodename, itemId)
		if isNul(itemId) then itemId=0
		getNodeValue=xmlDomObj.getElementsByTagName(nodename).Item(itemId).Text
	End Function

	Public Function getNodeLen(nodename)
		getNodeLen=xmlDomObj.getElementsByTagName(nodename).Length
	End Function
	
	Public Function getNodes(nodename)
		Set getNodes=xmlDomObj.getElementsByTagName(nodename)
	End Function
	
	Public Function getNode(nodename, itemId)
		Set getNode=xmlDomObj.getElementsByTagName(nodename).Item(itemId)
	End Function

	Public Function getAttributes(nodeName, attrName, itemId)
	dim xmlAttributes, i
		if isNul(itemId) then itemId=0
		err.clear:on error resume next
		getAttributes=xmlDomObj.getElementsByTagName(nodeName).Item(itemId).getAttributeNode(attrName).nodevalue
		if err then getAttributes="":err.clear
	End Function

	Public Function getAttributesByNode(node, attrName)
		err.clear:on error resume next
		getAttributesByNode=node.getAttributeNode(attrName).nodevalue
		if err then getAttributesByNode="":err.clear
	End Function

	Public Sub setXmlNodeValue(Byval nodename, Byval itemId, Byval str,Byval savePath)
	dim node
		xmlFileSavePath=savePath
		Set node=xmlDomObj.getElementsByTagName(nodename).Item(itemId)
		node.childNodes(0).text=str
		xmlDomObj.save Server.MapPath(xmlFileSavePath)
		set node=nothing
	End Sub

End Class

%>
<!--#include file="config.asp"-->
<!--#include file="CommonFun.asp"-->
<!--#include file="lang.asp"-->
<!--#include file="md5.asp"-->
<%
dim mainClassObj
set mainClassObj=New MainClass

dim conn
set conn=mainClassobj.createObject("MainClass.DB") 
conn.dbType=ifthen(databaseType =0,"acc","sql")

dim objFso,objStream
initializeAllObjects

dim cacheObj
set cacheObj=mainClassObj.createObject("MainClass.Cache")
dim currentTypeId:currentTypeId=-444
dim currenttopicid:currenttopicid=-444
dim pageUrlStyle,currentEnname,currentDatetime,currentId

%>