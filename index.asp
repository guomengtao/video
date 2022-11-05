<!--#include file="inc/MainClass.asp"-->
<% '******************************************************************************************
' Software name: Max(����˹) Content Management System ' Version:4.0
' Web: http://www.maxcms.net ' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ���� ' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
' ****************************************************************************************** Function GetIndex() dim
	cacheName,indexStr,x : cacheName="parsed_index" x="/"
	&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/index.html" if cacheStart=1 then if
	cacheObj.chkCache(cacheName) then indexStr=cacheObj.getCache(cacheName) else
	parseIndex(x):indexStr=templateObj.content:cacheObj.setCache cacheName,indexStr else
	parseIndex(x):indexStr=templateObj.content end if GetIndex=indexStr End Function Sub parseIndex(x) with
	templateObj:.content=loadFile(x):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():.parseLinkList:.parseIf():end
	with End Sub if runMode="static" then response.Redirect("/"&sitePath&"index"&fileSuffix) else tryDieCacheFile
	0,"#video" dim templateobj,temp: set templateobj=mainClassobj.createObject("MainClass.template"):temp=GetIndex()
	WriteCacheFile 0,"#video",temp:echo replaceStr(temp,"{maxcms:runinfo}",getRunTime()) set templateobj=nothing :
	terminateAllObjects end if %>