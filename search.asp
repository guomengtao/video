<!--#include file="inc/MainClass.asp"-->
<%
'******************************************************************************************
' Software name: Max(����˹) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ����
' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
'******************************************************************************************
dim searchLimitFlag,searchtime:searchLimitFlag=0:searchtime=5'searchLimitFlagΪ��ʾ�������Ʊ�ʶ(0������,1����),searchtimeΪ�����������
dim action : action = getForm("action", "get")
dim searchTemplatePath
dim searchword,searchType,page:searchword=getForm("searchword","both") : searchType=getForm("searchtype","both") : page=getForm("page","both")
'���ƻ���ǰ��ҳ
Const CachePage=3

Function GetSearchPage
	dim i,cacheName,pSize,rsObj,whereStr,curTypeId,pCount,searchTemplateName,tempStr,searchPageStr
	'if  isNul(searchword) then  echoMsgAndGo "�����������ؼ���",searchtime:die ""
	if searchLimitFlag=1 then checkSearchTimes
	searchTemplateName="search.html"
	searchTemplatePath = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&searchTemplateName
	pSize = getPageSizeOnCache(searchTemplatePath,"search","") : if isNul(pSize) then pSize=12
	dim x:x=EscapeSql(searchword)
	select case clng(searchType)
		case -1 : whereStr=" where m_recycle=0 AND (m_name like '%"&x&"%' OR m_actor like '%"&x&"%' OR  m_director like '%"&x&"%')"
		case 0 : whereStr=" where m_recycle=0 AND m_name like '%"&x&"%'"
		case 1 : whereStr=" where m_recycle=0 AND (m_actor like '%"&x&"%' OR m_director like '%"&x&"%')"
		case 2 : whereStr=" where m_recycle=0 AND m_publisharea like '%"&x&"%'"
		case 3 : whereStr=" where m_recycle=0 AND m_publishyear like '%"&x&"%'"
		case 4 : whereStr=" where m_recycle=0 AND m_letter = '"&UCase(searchword)&"'"
		case 5 : whereStr=" where m_recycle=0 AND m_lang like '%"&x&"%'"
	end select
	if ""&searchword="" then whereStr=" where 1=2"
	set rsObj = conn.db("select m_id from {pre}data "&whereStr,"records1")
	rsObj.pagesize = pSize
	cacheName="parse_search_"
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
	tempStr=replaceStr(tempStr,"{maxcms:searchword}",searchword):tempStr=replaceStr(tempStr,"{searchpage:page}",page): tempStr=replaceStr(tempStr,"{maxcms:searchnum}",rsObj.recordcount)
	with templateObj : .content=tempStr : .ParsePageList "",page,pCount,"search":.parseIf() : searchPageStr = .content : end with
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
		if rCookie("maxcms2_search")="ok" then echoMsgAndGo "��������Ϊ"&searchtime&"��һ��",searchtime,true:die ""
		wCookieInTime "maxcms2_search","ok","s",searchtime
		'echo "<script>alert(document.cookie)<//script>"
	end if
End Sub

function getCacheFlag()
	dim s,d:s=UCase(ReplaceStr(Server.URLEncode(searchword),"%","")):d=s&"-"
	getCacheFlag="_"&Left(d,1)&"/"&searchType&"_"&s&"_"&page
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