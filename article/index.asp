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
Function GetArticleById(Byval vId)
	dim i,rsObj,cacheName,vType,venname,vdatetime,contentLink,n,typeFlag,typeText,m_author,m_outline,m_des,m_title,x,y,z
	set rsObj = conn.db("select top 1 m_id,m_title,m_type,m_vid,m_pic,m_hit,m_author,m_content,m_topic,m_color,m_addtime,m_from,m_outline,m_commend,m_letter,m_keyword,m_digg,m_tread,m_entitle,m_datetime,m_note,m_score from {pre}news where m_id="&vId&" AND m_recycle=0","records1")
	if rsObj.recordcount=0 then
		rsObj.close:set rsObj = nothing:OutNotFound("news")
	end if
	vType=rsObj("m_type"):venname=rsObj("m_entitle"):vdatetime=rsObj("m_datetime")
	if InStr(" ,"&getHideNewsTypeIDS()&",",","&vType&",")>0 then
		rsObj.close:set rsObj = nothing:OutNotFound("news")
	end if
	y=split(getNewsTypeNameTemplateArrayOnCache(clng(vType)),","):z=ifthen(isNul(y(4)),"news.html",y(4)):x = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&z
	contentLink = getNewsArticleLink(vType,vId,venname,vdatetime,"link"):typeText = getNewsTypeTextOnCache(vType)
	currentId=vId:currentTypeId=vType:currentEnname=venname:currentDatetime=vdatetime:typeFlag = "parse_article_":cacheName = typeFlag&vType
	if cacheStart=1 then 
		with templateObj
			if cacheObj.chkCache(cacheName) then  
				.content = cacheObj.getCache(cacheName)
			else
				parseArticlePart(x)
				cacheObj.setCache cacheName,.content
			end if
		end with
	else
		parseArticlePart(x)
	end if
	m_author=rsObj("m_author"):m_des=filterStr(decodeHtml(rsObj("m_content")),"jsiframe"):m_outline=rsObj("m_outline")
	with templateObj
		.paresPreNextNews vid,vType:m_title=rsObj("m_title")
		.content = replaceStr(.content,"{news:id}",rsObj("m_id"))
		.content = replaceStr(.content,"{news:encodetitle}",server.URLEncode(rsObj("m_title")))
		.content = replaceStr(.content,"{news:note}",parseNewsNote(rsObj("m_note")))
		.content = replaceStr(.content,"{news:nolinkkeywords}",rsObj("m_keyword"))
		if isExistStr(.content,"{news:keywords}") then .content = replaceStr(.content,"{news:keywords}",replaceStr(getKeywordsList(rsObj("m_keyword"),"&nbsp;&nbsp;"),"search.asp","so.asp"))
		if not isNul(rsObj("m_pic")) then 
			if instr(rsObj("m_pic"),"http://")>0 then  .content = replaceStr(.content,"{news:pic}",rsObj("m_pic")) else .content = replaceStr(.content,"{news:pic}","/"&sitePath&rsObj("m_pic"))
		else
			.content = replaceStr(.content,"{news:pic}","/"&sitePath&"pic/nopic.gif")
		end if
		.content = replaceStr(.content,"{news:author}",m_author)
		.content = replaceStr(.content,"{news:from}",rsObj("m_from"))
		.content = replaceStr(.content,"{news:outline}",m_outline)
		.content = replaceStr(.content,"{news:diggnum}",rsObj("m_digg"))
		.content = replaceStr(.content,"{news:treadnum}",rsObj("m_tread"))
		.content = replaceStr(.content,"{news:scorenum}",rsObj("m_score"))
		.content = replaceStr(.content,"{news:commend}",rsObj("m_commend"))
		.content = replaceStr(.content,"{news:link}",contentLink)
		.content = replaceStr(.content,"{news:url}","http://"&siteurl&contentLink)
		.content = replaceStr(.content,"{news:textlink}",typeText&"&nbsp;&nbsp;&raquo;&nbsp;&nbsp;"&m_title)
		if isExistStr(.content,"{news:subcontent}") OR isExistStr(.content,"{news:subtitle}") OR isExistStr(.content,"{news:subpagenumber") then
			z=parseSubpage(m_des)
			.content = replaceStr(.content,"{news:subtitle}",z(1))
			.content = replaceStr(.content,"{news:subcontent}",z(2))
			x=StrSlice(.content,"{news:subpagenumber","}")
			y=.parseAttr(x)("len"):if isNul(y) then y=10 else y=clng(y)
			if z(0)>0 then
				y=pageNumberLinkInfo(page,y,z(0),"newssubpage",z(0))
			else
				y=""
			end if
			.content = replaceStr(.content,"{news:subpagenumber"&x&"}",y)
		end if
	end with
	parseLabelHaveLen m_author,"author":parseLabelHaveLen m_outline,"outline"
	templateObj.parseNews vid,m_title,rsObj("m_color"),m_des,rsObj("m_addtime"):templateObj.parseIf()
	GetArticleById=templateObj.content
	rsObj.close:set rsObj = nothing
End Function

Function parseSubpage(ByVal Des)
	Dim x,y,i,ret:x=split(Des,"#p#"):ret=array(Ubound(x),"",""):i=page-1
	if i>-1 AND ret(0)>=i then
		if not isExistStr(x(i),"#e#") then x(i)="#e#"&x(i)
		y=split(x(i),"#e#"):ret(1)=y(0):ret(2)=y(1)
	end if
	ret(0)=ret(0)+1
	parseSubpage=ret
End Function

Sub parseArticlePart(x)
	with templateObj
		.content=loadFile(x):.parseNewsPageSpecial():.parseTopAndFoot():.parseSelf():.parseGlobal()
		.content = replaceStr(replaceStr(.content,"{maxcms:currenttypeid}",currentTypeId),"{news:typeid}",currentTypeId)
		if isExistStr(.content,"{news:upid}") then .content = replaceStr(.content,"{news:upid}",getNewsTypeUpid2(currentTypeId))
		if isExistStr(.content,"{news:typename}") then .content = replaceStr(.content,"{news:typename}",split(getNewsTypeNameTemplateArrayOnCache(currentTypeId),",")(0))
		.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList()
	end with
End Sub

dim id,page
if newsparamset=0 OR newsrunmode="forgedStatic" then
	dim paras,parasArray:paras=replaceStr(request.QueryString,newsfileSuffix,"")
	if instr(paras,"-")>0 then
		parasArray=split(paras,"-"):id=parasArray(0):page=parasArray(1)
	else
		id=paras:page=1
	end if
else
	id=getForm(newsparamid,"both") : page=getForm(newsparampage,"both")
end if

if isNul(id) then
	echoSaveStr "null"
else
	if isNum(id) then:id=clng(id):else:echoSaveStr "safe"
end if

if isNul(id) then echoSaveStr "null"
if isNum(id) then id=clng(id) else echoSaveStr "safe"

if isNul(page) then page=1
if isNum(page) then page=clng(page) else echoSaveStr "safe"

tryDieCacheFile id,"#/A"
dim templateobj,temp:set templateobj = mainClassobj.createObject("MainClass.template"):temp=GetArticleById(id)
WriteCacheFile id,"#/A",temp:echo replaceStr(temp,"{maxcms:runinfo}",getRunTime())
set templateobj =nothing:terminateAllObjects
%>
