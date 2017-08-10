<!--#include file="inc/MainClass.asp"-->
<%
'******************************************************************************************
' Software name: Max(马克斯) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: 石头(maxcms2008@qq.com),yuet,长明,酒瓶
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************
dim searchLimitFlag,searchtime:searchLimitFlag=0:searchtime=5'searchLimitFlag为显示搜索控制标识(0不开启,1开启),searchtime为搜索间隔秒数
dim action : action = getForm("action", "get")
dim searchTemplatePath
dim searchword,searchType,page,Keyword : Keyword=getForm("searchword","both") : searchType=getForm("searchtype","both") : page=getForm("page","both"):searchword=Keyword
'控制缓存前几页
Const CachePage=3

Function GetSearchPage
	dim i,cacheName,pSize,rsObj,whereStr,curTypeId,pCount,searchTemplateName,tempStr,searchPageStr
	'if  isNul(searchword) then  echoMsgAndGo "请输入搜索关键字",searchtime:die ""
	if searchLimitFlag=1 then checkSearchTimes
	searchTemplateName="newssearch.html"
	searchTemplatePath = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&searchTemplateName
	pSize = getPageSizeOnCache(searchTemplatePath,"newssearch","") : if isNul(pSize) then pSize=12
	dim x:x=EscapeSql(searchword)
	select case clng(searchType)
		case -1 : whereStr=" where m_recycle=0 AND m_title like '%"&x&"%' or m_keyword like '%"&x&"%'"
		case 0 : whereStr=" where m_recycle=0 AND m_title like '%"&x&"%'"
		case 1 : whereStr=" where m_recycle=0 AND m_author like '%"&x&"%'"
		case 2 : whereStr=" where m_recycle=0 AND m_from like '%"&x&"%'"
		case 3 : whereStr=" where m_recycle=0 AND m_outline like '%"&x&"%'"
		case 4 : whereStr=" where m_recycle=0 AND m_letter='"&UCase(searchword)&"'"
	end select
	if ""&searchword="" then whereStr=" where 1=2"
	set rsObj = conn.db("select m_id from {pre}news "&whereStr,"records1")
	rsObj.pagesize = pSize
	cacheName="parse_newssearch_"
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then
			templateObj.content = cacheObj.getCache(cacheName)
		else 
			parseSearchPart
			cacheObj.setCache cacheName,templateObj.content
		end if
	else
		parseSearchPart
	end if
	tempStr = templateObj.content: pCount = rsObj.pagecount
	tempStr=replaceStr(tempStr,"{maxcms:newssearchword}",Keyword):tempStr=replaceStr(tempStr,"{newssearchpage:page}",page): tempStr=replaceStr(tempStr,"{maxcms:newssearchnum}",rsObj.recordcount)
	with templateObj : .content=tempStr : .parseNewsPartList "",page,pCount,"newssearch":.parseIf() : searchPageStr = .content : end with
	GetSearchPage=searchPageStr
	rsObj.close:set rsObj = nothing
End Function

Sub parseSearchPart
	with templateObj
		.load(searchTemplatePath) : .parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList()
	end with
End Sub

Sub checkSearchTimes
	if not isNul(getForm("searchword", "post")) then
		if rCookie("maxcms2_newssearch")="ok" then echoMsgAndGo "搜索限制为"&searchtime&"秒一次",searchtime,true:die ""
		wCookieInTime "maxcms2_newssearch","ok","s",searchtime
		'echo "<script>alert(document.cookie)<//script>"
	end if
End Sub

function getCacheFlag()
	dim s,d:s=UCase(ReplaceStr(Server.URLEncode(searchword),"%","")):d=s&"-"
	getCacheFlag="news_"&Left(d,1)&"/"&searchType&"_"&s&"_"&page
end function


if isNul(searchType) then 
	searchType=-1
else 
	if isNum(searchType) then searchType=clng(searchType) else echoSaveStr "safe"
end if

if isNul(page) then 
	page=1 
else 
	if isNum(page) then page=clng(page) else echoSaveStr "safe"
end if

searchword=preventSqlin(filterStr(searchword,"html"),"") : if len(searchword)>20 then searchword=left(searchword,20)
Dim fg:fg=getCacheFlag
if page<=CachePage then tryDieCacheFile 0,fg
dim templateobj,temp:set templateobj = mainClassobj.createObject("MainClass.template"):temp=GetSearchPage:if page<=CachePage then WriteCacheFile 0,fg,temp
echo replaceStr(temp,"{maxcms:runinfo}",getRunTime())
set templateobj=nothing : terminateAllObjects
%>
