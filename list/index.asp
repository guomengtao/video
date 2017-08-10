<!--#include file="../inc/MainClass.asp"-->
<%
'******************************************************************************************
' Software name: Max(马克斯) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: 石头(maxcms2008@qq.com),yuet,长明,酒瓶
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************
Function GetChannelById(Byval typeId,ByVal page)
	dim i,typeIds,rsObj,pSize,curTypeId,cacheName,pCount,channelLink,x,y,z:y = split(getTypeNameTemplateArrayOnCache(clng(typeId)),",")
	if isNul(y(1)) then z="channel.html" else z=y(1)
	x = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&z
	if InStr(" ,"&getHideTypeIDS()&",",","&typeId&",")>0 then OutNotFound("channel")
	pSize = getPageSizeOnCache(x,"channel",z):if isNul(pSize) then pSize=12
	typeIds = getTypeIdOnCache(typeId)
	set rsObj = conn.db("select m_id,m_name,m_type from {pre}data where m_recycle=0 AND m_type in ("&typeIds&")","records1")
	rsObj.pagesize = pSize : currentTypeId = typeId : cacheName = "parse_channel_"&currentTypeId
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then
			templateObj.content = cacheObj.getCache(cacheName)
		else 
			parseChannelPart x,y(0):cacheObj.setCache cacheName,templateObj.content
		end if
	else
		parseChannelPart x,y(0)
	end if
	pCount = rsObj.pagecount
	with templateObj:.content=replaceStr(.content,"{channelpage:page}",page):.parsePageList typeIds,page,pCount,"channel":.parseIf():GetChannelById=.content:end with
	rsObj.close:set rsObj = nothing
End Function

Sub parseChannelPart(x,y)
	dim z:z=getTypeField(currentTypeId,"m_keyword,m_description","")
	with templateObj:.content=loadFile(x):.parseTopAndFoot():.parseSelf():.parseGlobal():.content = replaceStr(replaceCurrentTypeId(.content),"{channelpage:typename}",y):.content = replaceStr(replaceStr(.content,"{channelpage:keywords}",z(0)),"{channelpage:description}",z(1)):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():.content= replaceStr(.content,"{channelpage:typetext}",getTypeTextOnCache(currentTypeId)):end with
End Sub

'控制缓存前几页
Const CachePage=3
dim id,page

if paramset=0 OR runmode="forgedStatic" then
	dim paras,parasArray:paras=replaceStr(request.QueryString,fileSuffix,"")
	if instr(paras,"-")>0 then
		parasArray=split(paras,"-"):id=parasArray(0):page=parasArray(1)
	else
		id=paras:page=1
	end if
else
	id=getForm(paramid,"both"):page=getForm(parampage,"both")
end if

if isNul(id) then 
	echoSaveStr "null" 
else 
	if isNum(id) then id=clng(id) else echoSaveStr "safe"
end if
if isNul(page) then
	page=1
else
	if isNum(page) then page=clng(page) else echoSaveStr "safe"
end if

if page<=CachePage then tryDieCacheFile id,"_"&page
dim templateobj,temp:set templateobj = mainClassobj.createObject("MainClass.template"):temp=GetChannelById(id,page)
WriteCacheFile id,"_"&page,temp:echo replaceStr(temp,"{maxcms:runinfo}",getRunTime())
set templateobj =nothing:terminateAllObjects
%>
