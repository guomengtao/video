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
Function GetNewsIndex()
	dim cacheName,indexStr,x : cacheName="parsed_news_index"
	x="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/newsindex.html"
	if cacheStart=1 then 
		if cacheObj.chkCache(cacheName) then indexStr = cacheObj.getCache(cacheName) else parseNewsIndex(x):indexStr=templateObj.content:cacheObj.setCache cacheName,indexStr
	else
		parseNewsIndex(x):indexStr=templateObj.content
	end if
	GetNewsIndex=indexStr
End Function

Sub parseNewsIndex(x)
	with templateObj:.content=loadFile(x):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():.parseLinkList():.parseIf():end with
End Sub


if newsRunMode="static"  then
	response.Redirect(getNewsIndexLink())
else
	tryDieCacheFile 0,"#news"
	dim templateobj,temp:set templateobj = mainClassobj.createObject("MainClass.template"):temp=GetNewsIndex()
	WriteCacheFile 0,"#news",temp:echo replaceStr(temp,"{maxcms:runinfo}",getRunTime())
	set templateobj=nothing:terminateAllObjects
end if
%>