<!--#include file="../inc/MainClass.asp"-->
<%
'******************************************************************************************
' Software name: Max(����˹) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ����
' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
'******************************************************************************************
Function GetTopicById(ByVal page)
	dim i,rsObj,pSize,cacheName,pCount,channelLink,x,y
	x = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/topicindex.html"
	set rsObj = conn.db("select m_name,m_id,m_pic,m_enname,m_des from {pre}topic order by m_sort asc","records1")
	pSize = getPageSizeOnCache(x,"topicindex","topindex.html"):if isNul(pSize) then pSize=12
	rsObj.pagesize = pSize:cacheName = "parse_tp_"
	if cacheStart=1 then 
		if cacheObj.chkCache(cacheName) then
			templateObj.content = cacheObj.getCache(cacheName) 
		else 
			parseTopicIndex x:cacheObj.setCache cacheName,templateObj.content
		end if
	else
		parseTopicIndex x
	end if
	pCount = rsObj.pagecount
	with templateObj:.content=replaceStr(.content,"{topicindexlist:page}",page):.parseTopicIndex page,pCount:.parseIf():end with
	GetTopicById=templateObj.content
	rsObj.close:set rsObj = nothing
End Function

Sub parseTopicIndex(x)
	with templateObj:.content=loadFile(x):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.content=replaceTopicId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():end with
End Sub

'���ƻ���ǰ��ҳ
Const CachePage=3
dim page

if paramset=0 OR runmode="forgedStatic" then
	dim paras:paras=replaceStr(request.QueryString,fileSuffix,"")
	page=paras
else
	page=getForm(parampage,"both")
end if

if isNul(page) then
	page=1
else
	if isNum(page) then page=clng(page) else echoSaveStr "safe"
end if

if page<=CachePage then tryDieCacheFile 0,"topic/"&page
dim templateobj,temp:set templateobj = mainClassobj.createObject("MainClass.template"):temp=GetTopicById(page)
WriteCacheFile 0,"topic/"&page,temp:echo replaceStr(temp,"{maxcms:runinfo}",getRunTime())
set templateobj =nothing:terminateAllObjects
%>