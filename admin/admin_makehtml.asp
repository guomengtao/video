<!--#include file="admin_inc.asp"-->
<%
'******************************************************************************************
' Software name: Max(����˹) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ����
' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
'******************************************************************************************
response.CacheControl="no-cache":server.scripttimeout=99999

viewHead "����ѡ��" & "-" & menuList(2,0)
dim action:action = getForm("action", "get")
dim makenum,flag: flag=getForm("flag","get"): makenum=getForm("makenum","get"):if isNul(flag) then flag=0 else  flag=clng(flag)
dim templateObj,templatePath,channelStr,channelTemplatePath,contentTemplatePath,playTemplatePath,topicTemplatePath,customLink,mareplaycount:mareplaycount=0
dim curTypeIndex,currentPage,topicpageName
set templateobj = mainClassobj.createObject("MainClass.template")
Select case action
	case "custom":  makecustom
 	case "allcustom"  :makeAllCustom
	case "baidu":makeBaidu
	case "google":makeGoogle
	case "rss":makeRss
'video
	case "index":checkRunMode(runMode):makeIndex
	case "map":makeAllmovie
	case "js":makeVideoJs
	case "channel":checkRunMode(runMode):makeChannel
	case "allchannel":checkRunMode(runMode):makeAllChannel
	case "channelbyids":checkRunMode(runMode):makeChannelByIDS
	case "content":checkRunMode(runMode):makeContent
	case "allcontent":checkRunMode(runMode):makeAllContent
	case "topicindex":checkRunMode(runMode):makeTopicIndex
	case "topic":checkRunMode(runMode):makeTopic
	case "alltopic":checkRunMode(runMode):makeAllTopic
	case "site":checkRunMode(runMode):makeSite
	case "day":checkRunMode(runMode):makeDay
	case "single":checkRunMode(runMode):makeSingle
	case "selected":checkRunMode(runMode):makeSelected
	case "lengthchannel" :checkRunMode(runMode):makelengthchannel
	case "daysview" :checkRunMode(runMode):makeDaysview
'news
	case "newsindex":checkRunMode(newsrunMode):makeNewsIndex
	case "newsmap":makeAllnews
	case "newsjs":makeNewsJs
	case "newschannel":checkRunMode(newsrunMode):makeNewsPart
	case "newsallchannel":checkRunMode(newsrunMode):makeAllNewsPart
	case "newschannelbyids":checkRunMode(newsrunMode):makeNewsPartByIDS
	case "newscontent":checkRunMode(newsrunMode):makeArticle
	case "newsallcontent":checkRunMode(newsrunMode):makeAllArticle
	case "newssite":checkRunMode(newsrunMode):makenewsSite
	case "newsday":checkRunMode(newsrunMode):makenewsDay
	case "newssingle":checkRunMode(newsrunMode):makenewsSingle
	case "newsselected":checkRunMode(newsrunMode):makenewsSelected
	case "newslengthchannel" :checkRunMode(newsrunMode):makenewslengthchannel
	case "newsdaysview" :checkRunMode(newsrunMode):makenewsDaysview
	case else:main
End Select 
set templateobj=nothing
if not isNul(action) and not  action="main"  then viewFoot

Sub checkRunMode(mode)
	if mode<>"static" then  die "<div style='width:50%;margin-top:50px;background:#66CCCC;font-size:13px;'><br><font color='red'>��վ����ģʽ�Ǿ�̬������������</font><br><br></div>"
End Sub

Sub main
dim i
%>
<div id="append_parent"></div>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(3,0)%>&nbsp;&raquo;&nbsp;����ѡ��';</script>
<ul id="makeHtmlTab">
<li id="li.v" onclick="toogletab('0')" style="cursor:pointer">������Ƶ���</li>
<li id="li.n" onclick="toogletab('1')" style="cursor:pointer">�����������</li>
<li id="li.o" onclick="toogletab('2')" style="cursor:pointer">��������</li>
</ul>
<table class="tb">
	<tbody id="news" style="display:none;">
		<tr>
		<td><input type="button" value="����������ҳ" class="btn" onClick="javascript:window.open('?action=newsindex','msg');"<%=ifthen(newsRunMode="static",""," disabled")%>>&nbsp;&nbsp;<input type="button" value="���ɵ�ͼҳ" class="btn" onClick="javascript:window.open('?action=newsmap','msg');">&nbsp;<input type="button" class="btn" value="����JS����" onClick="javascript:window.open('?action=newsjs','msg');">&nbsp;<input type="button" class="btn" value="һ������ȫվ" onClick="javascript:window.open('?action=newssite&action3=newssite','msg');"<%=ifthen(newsRunMode="static",""," disabled")%>>&nbsp;<input type="button" class="btn" value="һ�����ɵ���" onClick="javascript:window.open('?action=newsday','msg');"<%=ifthen(newsRunMode="static",""," disabled")%>></td>
		</tr>
		<tr><td>
		<form action="?action=newschannel" method="post" target="msg" id="newscform">
		<select name="channel" id="channel" style="width:121px">
		<option value="">��ѡ�����</option>
		<%makeNewsTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
		</select>
		&nbsp;<input type="submit" class="btn" value="������Ŀҳ" onclick="$('newscform').action='?action=newschannel';"<%=ifthen(newsRunMode="static",""," disabled")%>>
		<input type="button" class="btn" value="����ȫ����Ŀҳ" onClick="javascript:window.open('?action=newsallchannel','msg');"<%=ifthen(newsRunMode="static",""," disabled")%>>
		��ʼҳ����<input type="text" id="startpage" name="startpage" value='1' size="3" maxlength="3"/>����ҳ����<input type="text" id="endpage" name="endpage" value='1' size="3" maxlength="6"/>
		<input type="button" class="btn" value="���ɲ�����Ŀҳ" onclick="newssubmitform()"<%=ifthen(newsRunMode="static",""," disabled")%>>
		</form>
		</td></tr>
		<tr><td>
		<form action="?action=newscontent" method="post" target="msg" id="newsviewform"<%=ifthen(newsRunMode="static",""," disabled")%>>
		<select name="channel" id="channel" style="width:121px">
		<option value="">��ѡ�����</option>
		<%makeNewsTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
		</select>
		&nbsp;<input type="submit" class="btn" value="��������ҳ" onclick="$('newsviewform').action='?action=newscontent';"<%=ifthen(newsRunMode="static",""," disabled")%>>
		<input type="button" class="btn" value="����ȫ������ҳ" onClick="javascript:window.open('?action=newsallcontent&action2=newsallcontent','msg');"<%=ifthen(newsRunMode="static",""," disabled")%>>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" class="btn" value="����" onClick="newssubmitvform()"<%=ifthen(newsRunMode="static",""," disabled")%>>
		<select name="days" id="days">
		<%
		for i = 1 to 7
		%>
		<option value="<%= i %>"><%= i %></option>
		<% next %>

		</select>
		��������ҳ 
		</form>
		</td></tr>
	</tbody>
	<tbody id="other" style="display:none;">
		<tr><td>
		<form action="?action=topic" method="post" target="msg">
		<%echoTopicSelect%>
		<input type="submit" class="btn" value="����ר���ҳ"<%=ifthen(RunMode="static",""," disabled")%>>
		<input type="button" class="btn" value="����ר����ҳ�б�" onClick="javascript:window.open('?action=topicindex','msg');"<%=ifthen(RunMode="static",""," disabled")%>>
		<input type="button" class="btn" value="һ������ȫ��ר��" onClick="javascript:window.open('?action=alltopic&action2=alltopic&action3=topicindex','msg');"<%=ifthen(RunMode="static",""," disabled")%>>
		</form>
		</td></tr>
		<tr><td>
			<form action="?action=custom" method="post" target="msg" id="customform">
			<select name="custom" id="custom">
			<option value="">��ѡ���Զ���ģ���ļ�</option>
			<% getCustomList %>
			</select>
			<input type="submit" class="btn" value="�����Զ���ҳ" >
			<input type="button" class="btn" value="����ȫ���Զ���ҳ" onClick="submitcform()">
			</form>
		</td></tr>
	</tbody>
	<tbody id="video">
		<tr><td><input type="button" value="������Ƶ��ҳ" class="btn" onClick="javascript:window.open('?action=index','msg');"<%=ifthen(RunMode="static",""," disabled")%>>&nbsp;&nbsp;<input type="button" value="���ɵ�ͼҳ" class="btn" onClick="javascript:window.open('?action=map','msg');">&nbsp;<input type="button" value="����JS����" class="btn" onClick="javascript:window.open('?action=js','msg');">&nbsp;<input type="button" value="һ������ȫվ" class="btn" onClick="javascript:window.open('?action=site&action3=site','msg');"<%=ifthen(RunMode="static",""," disabled")%>>&nbsp;<input type="button" value="һ�����ɵ���" class="btn" onClick="javascript:window.open('?action=day','msg');"<%=ifthen(RunMode="static",""," disabled")%>>
		</td>
		</tr>
		<tr><td>
		<form action="?action=channel" method="post" target="msg" id="cform">
		<select name="channel" id="channel" style="width:121px">
		<option value="">��ѡ�����</option>
		<%makeTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
		</select>
		&nbsp;<input type="submit" class="btn" value="������Ŀҳ" onclick="$('cform').action='?action=channel';"<%=ifthen(RunMode="static",""," disabled")%>>
		<input type="button" class="btn" value="����ȫ����Ŀҳ" onClick="javascript:window.open('?action=allchannel','msg');"<%=ifthen(RunMode="static",""," disabled")%>>
		��ʼҳ����<input type="text" id="startpage" name="startpage" value='1' size="3" maxlength="3"/>����ҳ����<input type="text" id="endpage" name="endpage" value='1' size="3" maxlength="6"/>
		<input type="button"  class="btn"  value="���ɲ�����Ŀҳ" onclick="submitform()"<%=ifthen(RunMode="static",""," disabled")%>>
		</form>
		</td></tr>
		<tr><td>
		<form action="?action=content" method="post" target="msg" id="viewform"<%=ifthen(RunMode="static",""," disabled")%>>
		<select name="channel" id="channel" style="width:121px">
		<option value="">��ѡ�����</option>
		<%makeTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
		</select>
		&nbsp;<input type="submit" class="btn" value="��������ҳ" onclick="$('viewform').action='?action=content';"<%=ifthen(RunMode="static",""," disabled")%>>
		<input type="button" class="btn" value="����ȫ������ҳ" onClick="javascript:window.open('?action=allcontent&action2=allcontent','msg');"<%=ifthen(RunMode="static",""," disabled")%>>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" class="btn" value="����" onClick="submitvform()"<%=ifthen(RunMode="static",""," disabled")%>>
		<select name="days" id="days">
		<%
		for i = 1 to 7
		%>
		<option value="<%= i %>"><%= i %></option>
		<% next %>

		</select>
		��������ҳ 
		</form>
		<br />
		ע�⣺��վ�ھ�̬ģʽ�£����<a href="admin_config.asp" target="main"><font color="blue">��վ����</font></a>��ѡ����<font color="red">"���ɲ���ҳ"</font>����ô��������ҳ��ͬʱ���������ɲ���ҳ
		</td></tr>
	</tbody>
</table>
</div>
<script type="text/javascript">
function submitcform()
{
	$('customform').action="?action=allcustom"
	$('customform').submit()
}
function submitvform()
{
	$('viewform').action="?action=daysview"
	$('viewform').submit()
}
function submitform()
{
	$('cform').action="?action=lengthchannel"
	$('cform').submit()
}
function newssubmitvform()
{
	$('newsviewform').action="?action=newsdaysview"
	$('newsviewform').submit()
}
function newssubmitform()
{
	$('newscform').action="?action=newslengthchannel"
	$('newscform').submit()
}
var k='Makehtml_tab';
function toogletab(to){
	var a=['li.v','li.n','li.o'],b=['video','news','other'];
	var x=[[1,0,0],[0,1,0],[0,0,1]][to];
	for(var i=0;i<x.length;i++){
		$(a[i]).className = x[i]==1 ? 'hover':'';
		$(b[i]).style.display = x[i]==1 ? '':'none';
	}
	//setCookie(k,to,365*24);
}
toogletab(getCookie(k) | 0);
</script>
<iframe style="Z-INDEX: 1; VISIBILITY: inherit; WIDTH: 100%; HEIGHT: 305px;" name="msg"  frameBorder=0 scrolling=yes></iframe>
<%
End Sub

Sub makeSingle
	dim id,back,from:id=getForm("id","get"):back=getRefer:from=getForm("from","get")
	makeContentById id
	if isnul(from) then  alertMsg "",back else  alertMsg "",from
End Sub

Sub makenewsSingle
	dim id,back,from:id=getForm("id","get"):back=getRefer:from=getForm("from","get")
	makeArticleById id
	if isnul(from) then  alertMsg "",back else  alertMsg "",from
End Sub

Sub makeSelected
	dim i,m,ids,idsArray,back:ids=replaceStr(getForm("m_id","both")," ",""):back=getRefer
	idsArray=split(ids,","):m=ubound(idsArray)
	for i=m to 0 step -1
		m=m-1:makeContentById idsArray(i)
		if mareplaycount>1000 then exit for
	next
	if m>0 then
		redim Preserve idsArray(m)
		echo "<br>��ͣ"&makeTimeSpan&"����������<script language=""javascript"">setTimeout(""makeNextPage();"","&makeTimeSpan&"000);function makeNextPage(){location.href='?action="&action&"&m_id="&Join(idsArray,",")&"&REFERER="&server.urlencode(back)&"';}</script>"
	else
		alertMsg "",back
	end if
End Sub

Sub makenewsSelected
	dim i,m,ids,idsArray,back:ids=replaceStr(getForm("m_id","both")," ",""):back=getRefer
	idsArray=split(ids,","):m=ubound(idsArray)
	for i=0 to m
		makeArticleById idsArray(i)
	next
	alertMsg "",back
End Sub

Sub makeIndex
	dim indexStr
	templatePath="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/index.html"
	with templateObj:.load(templatePath):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():.parseLinkList:.parseIf():indexStr = .content:end with
	createTextFile indexStr,"/"&sitePath&"index"&fileSuffix,""
	echo "��ҳ������� <a target='_blank' href='/"&sitePath&"index"&fileSuffix&"'><font color=red>�����ҳ</font></a><br>" 	
End Sub

Sub makeNewsIndex
	dim x,y:y=getNewsIndexLink()
	x="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/newsindex.html"
	with templateObj:.load(x):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():.parseLinkList():.parseIf():x=.content:end with
	createTextFile x,y,""
	echo "��ҳ������� <a target='_blank' href='"&y&"'><font color=red>���������ҳ</font></a><br>" 	
End Sub

Sub makeAllmovie
	dim mapStr
	templatePath="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/map.html"
	with templateObj:.load(templatePath):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():.parseLinkList():.parseIf():mapStr = replaceStr(.content,"{maxcms:runinfo}",""):end with
	createTextFile mapStr,"/"&sitePath&"allmovie"&fileSuffix,""
	echo "��ͼҳ������� <a target='_blank' href='/"&sitePath&"allmovie"&fileSuffix&"'><font color=red>�����ͼҳ</font></a><br>" 	
End Sub

Sub makeAllnews
	dim mapStr,x:x="/"&sitePath&ifthen(InStr("#dir2#dir4#dir6#dir8",newsMakeMode)>0,newsdirname3,newsdirname2)&"/allnews"&newsFileSuffix
	templatePath="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/newsmap.html"
	with templateObj:.load(templatePath):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():.parseLinkList():.parseIf():mapStr = replaceStr(.content,"{maxcms:runinfo}",""):end with
	createTextFile mapStr,x,""
	echo "��ͼҳ������� <a target='_blank' href='"&x&"'><font color=red>������ŵ�ͼҳ</font></a><br>" 	
End Sub

Sub makeAllCustom
	dim i
	dim folderList:folderList = getFileList("/"&sitepath&"template/"&defaultTemplate&"/"&templateFileFolder)
	dim folderNum:folderNum = ubound(folderList)
	for i = 0 to folderNum
		if left(split(folderList(i),",")(0),5) = "self_" then
			makeCustomInfo(split(folderList(i),",")(0))
		end if 
	next 
End Sub

Sub makeCustom
	dim customtemplate,i,x:customtemplate = replace(getForm("custom", "both")," ","")
	if customtemplate ="" then die "��ѡ��ģ��"
	x=split(customtemplate,",")
	for i=0 to UBound(x)
		makeCustomInfo x(i)
	next
End Sub

Sub makeCustomInfo(templatename)
	dim i,cacheName,pCount,Link,tempStr,ext:pCount=0:ext=getFileFormat(templatename)
	if ext<>".html" AND ext<>".htm" AND ext<>".js" AND ext<>".xml" AND ext<>".wml" then exit sub
	customLink="/"&sitePath&Replace(Replace(split(templatename,".")(0),"self_",""),"#","/")&"<page>"&ext
	templatePath = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&templatename
	cacheName = "parse_customvideo_"&templatename
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then 
			templateObj.content = cacheObj.getCache(cacheName)  
		else 
			parseCachePart "customvideo":cacheObj.setCache cacheName,templateObj.content
		end if
	else
		parseCachePart "customvideo"
	end if
	tempStr = templateObj.content
	if InStr(tempStr,"{/customvideolist}")<1 then pCount=1
	for i=1 to 100
		Link = getCustomLink(i)
		with templateObj:.content=replaceStr(replaceStr(tempStr,"{customvideo:page}",i),"{customvideopage:page}",i):.ParsePageList 0,i,pCount,"customvideo":.parseIf():channelStr = .content:end with
		createTextFile channelStr,Link,""
		echo "�Զ����ļ�<font color=red>"&Link&"</font>������� <a target='_blank' href='"&Link&"'><font color=red>���ҳ��</font></a><br>"
		if i>=pCount then exit for
	next
End Sub

Sub getCustomList
	dim i
	dim folderList:folderList = getFileList("../template/"&defaultTemplate&"/"&templateFileFolder)
	dim folderNum:folderNum = ubound(folderList)
	for i = 0 to folderNum
		if left(split(folderList(i),",")(0),5) = "self_" then
			echo "<option value='"&split(folderList(i),",")(0)&"'>"&split(folderList(i),",")(0)&"</option>"
		end if
	next
End Sub

Sub makeVideoJs
	dim jsStr:templatePath="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/js.html"
	with templateObj:.content=loadFile(templatePath):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():.parseIf():jsStr = .content:end with
	createTextFile jsStr,"/"&sitePath&"js.js",""
	echo "����JS�����ļ�������� <a target='_blank' href='/"&sitePath&"js.js"&"'><font color=red>�  ��</font></a><br>" 
End Sub

Sub makeNewsJs
	dim jsStr,x:x="/"&sitePath&ifthen(InStr("#dir2#dir4#dir6#dir8",newsMakeMode)>0,newsdirname3,newsdirname2)&"/news.js"
	templatePath="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/newsjs.html"
	with templateObj:.content=loadFile(templatePath):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():.parseIf():jsStr = .content:end with
	createTextFile jsStr,x,""
	echo "����JS�����ļ�������� <a target='_blank' href='/"&sitePath&"news.js"&"'><font color=red>�  ��</font></a><br>" 
End Sub

Sub makeTopic
	dim channel:channel = replaceStr(getForm("channel","both")," ",""):curTypeIndex=getForm("index","get"):if isNul(channel) then die "��ѡ������"
	if isNum(curTypeIndex) then curTypeIndex=Clng(curTypeIndex) else curTypeIndex=0
	makeTopicById channel:if curTypeIndex<1 then echoChannelSuspend3 channel,curTypeIndex,makeTimeSpan
End Sub

Sub	makeTopicById(Byval topicId)
	dim i,n,m,topicEnname,pSize,curTypeId,cacheName,pCount,nCount,rCount,topicpageLink,tempStr,topicArray
	currentPage= getForm("page","get"):if isNum(currentPage) then currentPage=Clng(currentPage) else currentPage=1
	topicArray = conn.db("select top 1 m_id,m_name,m_template,m_enname from {pre}topic where m_id ="&topicId,"array")
	if not isArray(topicArray) then die "�����ڴ�ר��"
	if isNul(topicArray(2,0)) then topicArray(2,0)="topicpage.html" end if
	topicTemplatePath="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&topicArray(2,0)
	pSize = getPageSizeOnCache(topicTemplatePath,"topicpage",topicArray(2,0)):if isNul(pSize) then pSize=12
	rCount = conn.db("select count(*) from {pre}data where m_topic="&topicId&" AND m_recycle=0","array")(0,0)
	m = rCount mod pSize
	n = int(rCount / pSize)
	if m = 0 then pCount = n else pCount = n + 1
	topicpageName=topicArray(1,0):topicEnname=topicArray(3,0):currentTopicId = topicArray(0,0)
	echoBegin topicpageName,"topicpage"
	cacheName = "parse_topicpage_"&topicId
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then 
			templateObj.content = cacheObj.getCache(cacheName)  
		else 
			parseCachePart "topicpage":cacheObj.setCache cacheName,templateObj.content
		end if
	else
		parseCachePart "topicpage"
	end if
	tempStr = templateObj.content
	if rCount=0 then
		topicpageLink = getTopicPageLink(currentTopicId,1,topicEnname)
		tempStr = replaceStr(tempStr,"{topicpagelist:page}",1)
		with templateObj:.content=tempStr:.parsePageList currentTopicId,i,pCount,"topicpage":.parseIf():channelStr = .content:end with
		createTextFile channelStr,topicpageLink,"":echoEach topicpageName,i,topicpageLink,"topicpage"
	end if
	if InStr(tempStr,"{/maxcms:topicpagelist}")=0 then pCount=1
	if currentPage<1 then currentPage=1
	nCount=200+currentPage-1:if pCount<nCount then:nCount=pCount:end if
	for i=currentPage to nCount
		topicpageLink = getTopicPageLink(currentTopicId,i,topicEnname)
		with templateObj:.content=replaceStr(tempStr,"{topicpagelist:page}",i):.parsePageList currentTopicId,i,pCount,"topicpage":.parseIf():channelStr = .content:end with
		createTextFile channelStr,topicpageLink,"":echoEach topicpageName,i,topicpageLink,"topicpage"
	next
	currentPage=i
	if nCount>=pCount then
		curTypeIndex=curTypeIndex+1:currentPage=1
	end if
End Sub

Sub makeTopicIndex
	dim i,rsObj,pSize,curTypeId,cacheName,pCount,nCount,topicindexLink,tempStr
	currentPage= getForm("page","get"):if isNum(currentPage) then currentPage=Clng(currentPage) else currentPage=1
	topicTemplatePath="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/topicindex.html"
	pSize = getPageSizeOnCache(topicTemplatePath,"topicindex","topicindex.html"):if isNul(pSize) then pSize=12
	echoBegin "","topicindex"
	set rsObj = conn.db("select m_name,m_id,m_pic,m_enname,m_des from {pre}topic order by m_sort asc","records1")
	rsObj.pagesize = pSize:cacheName = "parse_tp_"
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then 
			templateObj.content = cacheObj.getCache(cacheName)  
		else 
			parseCachePart "topicindex":cacheObj.setCache cacheName,templateObj.content
		end if
	else
		parseCachePart "topicindex"
	end if
	tempStr = templateObj.content:pCount = rsObj.pagecount
	if rsObj.recordcount=0 then
		topicindexLink = getTopicIndexLink(1)
		tempStr = replaceStr(tempStr,"{topicindexlist:page}",1)
		with templateObj:.content=tempStr:.parseTopicIndex i,pCount:.parseIf():channelStr = .content:end with
		createTextFile channelStr,topicindexLink,"":echoEach "",i,topicindexLink,"topicindex"
	end if
	if InStr(tempStr,"{/maxcms:topicindexlist}")=0 then pCount=1
	if currentPage<1 then currentPage=1
	nCount=200+currentPage-1:if pCount<nCount then:nCount=pCount:end if
	for i=currentPage to nCount
		topicindexLink = getTopicIndexLink(i)
		with templateObj:.content=replaceStr(tempStr,"{topicindexlist:page}",i):.parseTopicIndex i,pCount:.parseIf():channelStr = .content:end with
		createTextFile channelStr,topicindexLink,"":echoEach "",i,topicindexLink,"topicindex"
	next
	rsObj.close:set rsObj = nothing:currentPage=i
	if nCount>=pCount then
		dim action3:action3=getForm("action3","get")
		if isNul(action3) then  
			alertMsg "��ϲ�㣬�����б��������","":terminateAllObjects:die ""
		elseif action3="topicindex" then
			alertMsg "һ�����������б�ȫ���㶨","":terminateAllObjects:die ""
		end if
	else
		echoChannelSuspend2 "","","",makeTimeSpan
	end if
End Sub

Sub makeAllTopic
	dim topicIdArray,i,topicId,topicIdArrayLen,action3:curTypeIndex=getForm("index","get"):action3=getForm("action3","get")
	topicIdArray = getTopicIdArrayBySortOnCache()
	topicIdArrayLen = ubound(topicIdArray)
	if isNul(curTypeIndex) then
		curTypeIndex=0
	else
		if clng(curTypeIndex)>clng(topicIdArrayLen) then
			if isNul(action3) then  
				alertMsg "����ȫ��������ҳ���","":terminateAllObjects:die ""
			elseif action3="topicindex" then
				echo "<script language='javascript'>self.location='?action=topicindex&action3="&action3&"';</script>" 
			end if
		end if
	end if
	topicId = topicIdArray(curTypeIndex)
   	if isNul(topicId) then die "���ඪʧ" else makeTopicById topicId:echoChannelSuspend curTypeIndex,action3,makeTimeSpan
End Sub

Sub makeSite
	dim action3:action3 = getForm("action3","get")
	echo "<script language='javascript'>self.location='?action=allcontent&action2=allcontent&action3="&action3&"';</script>"
End Sub

Sub makenewsSite
	dim action3:action3 = getForm("action3","get")
	echo "<script language='javascript'>self.location='?action=newsallcontent&action2=newsallcontent&action3="&action3&"';</script>"
End Sub

Sub makeDay
	dim sqlStr,whereStr,channel,page,rsObj,i,j,k,l,row,ids,rCount:page=getForm("page","get")
	sqlStr = "select m_id from {pre}data where m_recycle=0 AND m_wrong=0"
	whereStr = " and year(m_addtime)="&Year(date)&" and month(m_addtime)="&month(date)&" and day(m_addtime)="&day(date)
	sqlStr = sqlStr & whereStr
	set rsObj = conn.db(sqlStr,"records1"):rCount=rsObj.recordcount
	if rCount=0 then die  "����û����Ƶ<br>"
	if isNul(page) then page=0 else page=clng(page)
	echoBegin "���ڿ�ʼ���ɵ�������,��ǰ������<font color='red'>"&(page+1)&"</font> �� <font color='red'>"&(page+ifthen(rCount<100,rCount,100))&"</font>ҳ,��<font color='red'>"&rCount&"</font>ҳ<br>","content"
	rsObj.move(page)
	for i=1 to 100
		if not rsObj.eof then
			makeContentById(rsObj(0)):page=page+1:rsObj.movenext
		else
			row=conn.db(Replace(sqlStr,"m_id","m_type")&" GROUP BY m_type","array"):ids=""
			if isArray(row) then
				for j=0 to UBound(row,2)
					if not isTypeHide(row(0,j)) then
						if ids="" then
							ids=row(0,j)
						else
							ids=ids&","&row(0,j)
						end if
					end if
				next
				if ids<>"" then
					row=getTypeLists():k=getTypeIndex("m_id"):l=getTypeIndex("m_upid")
					for j=0 to UBound(row,2)
						if InStr(" ,"&ids&",",","&row(k,j)&",")>0 then
							if Clng(row(l,j))>0 AND InStr(" ,"&ids&",",","&row(l,j)&",")=0 then
								ids=row(l,j)&","&ids
							end if
						end if
					next
				end if
			end if
			if ids<>"" then
				echo "���ɵ������ݸ㶨<script language='javascript'>self.location='?action=channelbyids&ids="&ids&"&action3=site';</script>":Exit Sub
			else
				alertMsg "һ������ȫ���㶨","":echoRunTime:terminateAllObjects:die ""
			end if
		end if
	next
	echoDaySuspend page,0,makeTimeSpan
	rsObj.close
	set rsObj=nothing
End Sub

Sub makenewsDay
	dim sqlStr,whereStr,channel,page,rsObj,i,j,k,l,row,ids:page=getForm("page","get")
	sqlStr = "select m_id from {pre}news where m_recycle=0"
	whereStr = " and year(m_addtime)="&Year(date)&" and month(m_addtime)="&month(date)&" and day(m_addtime)="&day(date)
	sqlStr = sqlStr & whereStr
	set rsObj = conn.db(sqlStr,"records1")
	if rsObj.recordcount=0 then
		die  "����û������<br>"
	end if
	rsObj.pagesize=100
	if isNul(page) then page=1 else page=clng(page)
	if page>rsObj.pagecount then page=rsObj.pagecount
	rsObj.absolutepage= page 
	echoBegin "���ڿ�ʼ���ɵ�������,��ǰ�ǵ�<font color='red'>"&page&"</font>ҳ,��<font color='red'>"&rsObj.pagecount&"</font>ҳ<br>","content"
	for i=1 to rsObj.pagesize
		makeArticleById(rsObj(0))
		rsObj.movenext
		if rsObj.eof  then
			row=conn.db(Replace(sqlStr,"m_id","m_type")&" GROUP BY m_type","array"):ids=""
			if isArray(row) then
				for j=0 to UBound(row,2)
					if not isNewsTypeHide(row(0,j)) then
						if ids="" then
							ids=row(0,j)
						else
							ids=ids&","&row(0,j)
						end if
					end if
				next
				if ids<>"" then
					row=getNewsTypeLists():k=getTypeIndex("m_id"):l=getTypeIndex("m_upid")
					for j=0 to UBound(row,2)
						if InStr(" ,"&ids&",",","&row(k,j)&",")>0 then
							if Clng(row(l,j))>0 AND InStr(" ,"&ids&",",","&row(l,j)&",")=0 then
								ids=row(l,j)&","&ids
							end if
						end if
					next
				end if
			end if
			if ids<>"" then
				echo "���ɵ������ݸ㶨<script language='javascript'>self.location='?action=newschannelbyids&ids="&ids&"&action3=newssite';</script>":Exit Sub
			else
				alertMsg "һ������ȫ���㶨","":echoRunTime:terminateAllObjects:die ""
			end if
		end if
	next
	echoDaySuspend page+1,0,newsmakeTimeSpan
	rsObj.close
	set rsObj=nothing
End Sub

Sub echoDaySuspend(curPage,days,sleep)
	echo "<br>��ͣ"&sleep&"����������<script language=""javascript"">setTimeout(""makeNextPage();"","&sleep&"000);function makeNextPage(){location.href='?action="&action&"&page="&curPage&"&days="&days&"';}</script>"
End Sub

Sub makeAllContent
	dim typeIdArray,i,typeId,typeIdArrayLen,action3:curTypeIndex=getForm("index","get"):action3=getForm("action3","get")
	typeIdArray = getTypeIdArrayBySortOnCache(0)
	typeIdArrayLen = ubound(typeIdArray)
	if isNul(curTypeIndex) then 
		curTypeIndex=0 
	else 
		if clng(curTypeIndex)>clng(typeIdArrayLen) then
			if isNul(action3) then  
				alertMsg "����ȫ������ҳ���","":terminateAllObjects:die ""
			elseif action3="site" then
				echo "<script language='javascript'>self.location='?action=allchannel&action3="&action3&"';</script>" 
			end if
		end if
	end if
	typeId = typeIdArray(curTypeIndex)
   	if isNul(typeId) then die "���ඪʧ" else makeContentByChannel typeId,false
End Sub

Sub makeAllArticle
	dim typeIdArray,i,typeId,typeIdArrayLen,action3:curTypeIndex=getForm("index","get"):action3=getForm("action3","get")
	typeIdArray = getNewsTypeIdArrayBySortOnCache(0)
	typeIdArrayLen = ubound(typeIdArray)
	if isNul(curTypeIndex) then 
		curTypeIndex=0 
	end if
	if clng(curTypeIndex)>clng(typeIdArrayLen) then
		if isNul(action3) then  
			alertMsg "����ȫ������ҳ���","":terminateAllObjects:die ""
		elseif action3="newssite" then
			echo "<script language='javascript'>self.location='?action=newsallchannel&action3="&action3&"';</script>" 
		end if
	end if
	typeId = typeIdArray(curTypeIndex)
   	if isNul(typeId) then die "���ඪʧ" else makeArticleByChannel typeId,false
End Sub

Sub makeContent
	dim channel:channel = getForm("channel","both"):if isNul(channel) then die "��ѡ�����"
	makeContentByChannel channel,false
End Sub

Sub makeArticle
	dim channel:channel = getForm("channel","both"):if isNul(channel) then die "��ѡ�����"
	makeArticleByChannel channel,false
End Sub

Function isTypeHide(Byval channel)
	isTypeHide=InStr(" ,"&getHideTypeIDS()&",",","&trim(channel)&",")>0
End Function

Function isNewsTypeHide(Byval channel)
	isNewsTypeHide=InStr(" ,"&getHideNewsTypeIDS()&",",","&trim(channel)&",")>0
End Function

Sub makeContentByChannel(channel,isIncludeSub)
	dim rsObj,typeIds,typeZnName,i,sqlStr,action2,action3,rCount: action2=getForm("action2","get"):action3=getForm("action3","get")
	currentPage= getForm("page","get"):curTypeIndex=getForm("index","get")
	if isNul(curTypeIndex) then curTypeIndex=0
	if isIncludeSub then
		typeIds = getTypeIdOnCache(channel)
		sqlStr="select m_id from {pre}data where m_type in ("&typeIds&")"&" AND m_recycle=0"
	else
		typeIds=channel
		sqlStr="select m_id from {pre}data where m_type="&typeIds&" AND m_recycle=0"
	end if
	typeZnName=split(getTypeNameTemplateArrayOnCache(clng(channel)),",")(0)
	set rsObj = conn.db(sqlStr,"records1"):rCount=rsObj.recordcount
	if isTypeHide(channel)=true or rCount=0 then
		if isNul(action2) then
			echo "�÷���<font color='red'>"&typeZnName&"</font>����Ƶ������<br>":Exit Sub
		elseif action2="allcontent" then
			echo "�÷���<font color='red'>"&typeZnName&"</font>����Ƶ������<br>":echoContentSuspendPerChannel curTypeIndex+1,action2,action3,ifthen(isMakePlay=3,"0.5",makeTimeSpan):Exit Sub
		end if
	end if
	if isNul(currentPage) then currentPage=0 else currentPage=clng(currentPage)
	echoBegin "���ڿ�ʼ������Ŀ<font color='red'>"&typeZnName&"</font>������ҳ,��ǰ������<font color='red'>"&(currentPage+1)&"</font> �� <font color='red'>"&(currentPage+ifthen(rCount<100,rCount,100))&"</font>ҳ,��<font color='red'>"&rCount&"</font>ҳ<br>","content"
	rsObj.move(currentPage)
	for i=1 to 100
		if not rsObj.eof then
			makeContentById(rsObj(0)):currentPage=currentPage+1:rsObj.movenext
			if mareplaycount>1000 then exit for
		else
			if isNul(action2) then
				echo "��ϲ�˷���㶨":Exit Sub
			elseif action2="allcontent" then
				echo "��ϲ�˷���㶨":echoContentSuspendPerChannel curTypeIndex+1,action2,action3,makeTimeSpan:Exit Sub
			end if
		end if
	next
	echoContentSuspend curTypeIndex,currentPage,channel,action2,action3,makeTimeSpan
	rsObj.close
	set rsObj=nothing
End Sub

Sub makeArticleByChannel(channel,isIncludeSub)
	dim rsObj,typeIds,typeZnName,i,sqlStr,action2,action3: action2=getForm("action2","get"):action3=getForm("action3","get")
	currentPage= getForm("page","get"):curTypeIndex=getForm("index","get")
	if isNul(curTypeIndex) then curTypeIndex=0
	if isIncludeSub then
		typeIds = getNewsTypeIdOnCache(channel)
		sqlStr="select m_id from {pre}news where m_type in ("&typeIds&") AND m_recycle=0"
	else
		typeIds=channel
		sqlStr="select m_id from {pre}news where m_type="&typeIds&" AND m_recycle=0"
	end if
	typeZnName=split(getNewsTypeNameTemplateArrayOnCache(clng(channel)),",")(0)
	if isNul(currentPage) then currentPage=1 else currentPage=clng(currentPage)
	set rsObj = conn.db(sqlStr,"records1")
	if isNewsTypeHide(channel)=true or rsObj.recordcount=0 then
		if isNul(action2) then 
			echo "�÷���<font color='red'>"&typeZnName&"</font>�����Ż�����<br>":Exit Sub
		elseif action2="newsallcontent" then
			echo "�÷���<font color='red'>"&typeZnName&"</font>�����Ż�����<br>":echoContentSuspendPerChannel curTypeIndex+1,action2,action3,newsmakeTimeSpan:Exit Sub
		end if	
	end if
	rsObj.pagesize=100
	rsObj.absolutepage=currentPage
	echoBegin "���ڿ�ʼ������Ŀ<font color='red'>"&typeZnName&"</font>������ҳ,��ǰ�ǵ�<font color='red'>"&currentPage&"</font>ҳ,��<font color='red'>"&rsObj.pagecount&"</font>ҳ<br>","content"
	for i=1 to rsObj.pagesize
		makeArticleById(rsObj(0))
		rsObj.movenext
		if rsObj.eof then
			if  isNul(action2) then
				echo "��ϲ�˷���㶨":Exit Sub
			elseif action2="newsallcontent" then
				echo "��ϲ�˷���㶨":echoContentSuspendPerChannel curTypeIndex+1,action2,action3,newsmakeTimeSpan:Exit Sub
			end if
		end if
	next
	echoContentSuspend curTypeIndex,currentPage+1,channel,action2,action3,newsmakeTimeSpan
	rsObj.close
	set rsObj=nothing
End Sub

Sub echoContentSuspend(typeIdIndex,page,channel,action2,action3,sleep)
	echo "<br>��ͣ"&sleep&"����������<script language=""javascript"">setTimeout(""makeNextPage();"","&sleep&"000);function makeNextPage(){location.href='?action="&action&"&index="&typeIdIndex&"&channel="&channel&"&page="&page&"&action2="&action2&"&action3="&action3&"';}</script>"
End Sub

Sub echoContentSuspendPerChannel(typeIdIndex,action2,action3,sleep)
	echo "<br>��ͣ"&sleep&"����������<script language=""javascript"">setTimeout(""makeNextType();"","&sleep&"000);function makeNextType(){location.href='?action="&action&"&index="&typeIdIndex&"&action2="&action2&"&action3="&action3&"';}</script>"
End Sub

Sub makeContentById(Byval vId)
	dim x,y,i,rsObj,cacheName,vType,vEnname,vDatetime,contentPath,contentLink,playLink,n,typeFlag,typeText,specialFlag,playTemFileName,playn,m_actor,m_director,m_des,cacheFlagPartStr,playORdownData,playl,nameAndTemplateArray,contentTmpName:playn = 0
	set rsObj = conn.db("select top 1 m_id,m_type,m_name,m_state,m_pic,m_hit,m_actor,m_des,m_topic,m_color,m_addtime,m_publishyear,m_publisharea,m_playdata,m_downdata,m_commend,m_note,m_digg,m_tread,m_keyword,m_enname,m_datetime,m_director,m_lang,m_score,m_recycle from {pre}data where m_id="&vId,"records1")
	if rsObj.recordcount=0 then echo "<font color='red'>����ID:"&vId&" �������������౻���أ���������</font><br>":Exit Sub
	if rsObj("m_recycle")=1 then echo "<font color='red'>����ID:"&vId&" �������������౻���أ���������</font><br>":Exit Sub
	vType=rsObj("m_type"):vEnname=rsObj("m_enname"):vDatetime=rsObj("m_datetime"):vId=rsObj("m_id")
	contentPath = getContentLink(vType,vId,vEnname,vDatetime,""):contentLink=getContentLink(vType,vId,vEnname,vDatetime,"link")
	typeText = getTypeTextOnCache(vType):currentTypeId=vType
	if isAlertWin=1 then playTemFileName="openplay.html" else  playTemFileName="play.html"
	nameAndTemplateArray = split(getTypeNameTemplateArrayOnCache(clng(vType)),",")
	if isNul(nameAndTemplateArray(4)) then contentTmpName="content.html" else contentTmpName=nameAndTemplateArray(4)
	contentTemplatePath = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&contentTmpName
	playTemplatePath = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&playTemFileName
	if ismakeplay=0 then playn=1
	for n=playn to 1
		select case n
			case 0:typeFlag = "parse_play_"
			case 1:typeFlag = "parse_content_"
		end select
		cacheName = typeFlag&vType
		if cacheStart=1 then 
			with templateObj
				if cacheObj.chkCache(cacheName) then  
					.content = cacheObj.getCache(cacheName)  
				else 
					parseCachePart typeFlag:cacheObj.setCache cacheName,.content
				end if
			end with
		else
			parseCachePart typeFlag
		end if
		with templateObj
			.parsePlayList vType,vId,vEnname,vDatetime,rsObj("m_playdata"),"play":.parsePlayList vType,vId,vEnname,vDatetime,rsObj("m_downdata"),"down"
			.content = replaceStr(.content,"{playpage:id}",vId)
			.content = replaceStr(.content,"{playpage:name}",rsObj("m_name"))
			.content = replaceStr(.content,"{playpage:desktopurl}","/"&sitepath&"desktop.asp?name={playpage:encodename}&url="&server.urlencode(contentLink))
			.content = replaceStr(.content,"{playpage:encodename}",server.URLEncode(rsObj("m_name")))
			.content = replaceStr(.content,"{playpage:note}",rsObj("m_note"))
			.content = replaceStr(.content,"{playpage:lang}",rsObj("m_lang"))
			.content = replaceStr(.content,"{playpage:diggnum}",rsObj("m_digg"))
			.content = replaceStr(.content,"{playpage:treadnum}",rsObj("m_tread"))
			.content = replaceStr(.content,"{playpage:scorenum}",rsObj("m_score"))
			.content = replaceStr(.content,"{playpage:nolinkkeywords}",rsObj("m_keyword"))
			if isExistStr(.content,"{playpage:keywords}") then .content = replaceStr(.content,"{playpage:keywords}",getKeywordsList(rsObj("m_keyword"),"&nbsp;&nbsp;"))
			if not isNul(rsObj("m_pic")) then
				if instr(rsObj("m_pic"),"http://")>0 then  .content = replaceStr(.content,"{playpage:pic}",rsObj("m_pic")) else .content = replaceStr(.content,"{playpage:pic}","/"&sitePath&rsObj("m_pic"))
			else
				.content = replaceStr(.content,"{playpage:pic}","/"&sitePath&"pic/nopic.gif")
			end if
			m_actor=rsObj("m_actor"):m_director=rsObj("m_director"):m_des=filterStr(decodeHtml(rsObj("m_des")),"jsiframe")
			.content = replaceStr(.content,"{playpage:actor}",getKeywordsList(m_actor,"&nbsp;&nbsp;"))
			.content = replaceStr(.content,"{playpage:nolinkactor}",m_actor)
			.content = replaceStr(.content,"{playpage:director}",getKeywordsList(m_director,"&nbsp;&nbsp;"))
			.content = replaceStr(.content,"{playpage:nolinkdirector}",m_director)
			.content = replaceStr(.content,"{playpage:publishtime}",rsObj("m_publishyear"))
			.content = replaceStr(.content,"{playpage:publisharea}",rsObj("m_publisharea"))
			.content = replaceStr(.content,"{playpage:addtime}",rsObj("m_addtime"))
			.content = replaceStr(.content,"{playpage:state}",rsObj("m_state"))
			.content = replaceStr(.content,"{playpage:commend}",rsObj("m_commend"))
			.content = replaceStr(.content,"{playpage:des}",doPseudo(m_des,vId))
			.content = replaceStr(.content,"{playpage:link}",contentLink)
			.content = replaceStr(.content,"{playpage:url}","http://"&siteUrl&contentLink)
			playLink=getPlayLink2(rsObj("m_type"),rsObj("m_id"),rsObj("m_enname"),rsObj("m_addtime"),0,0)
			if isAlertWin=1 then playLink="javascript:openWin('"&playLink&"',"&(alertWinW+10)&","&(alertWinH+55)&",250,100,1)" end if
			.content = replaceStr(.content,"{playpage:playlink}",playLink)
		end with
		parseLabelHaveLen m_des,"des":parseLabelHaveLen m_actor,"actor":parseLabelHaveLen m_actor,"nolinkactor":parseLabelHaveLen rsObj("m_name"),"name":parseLabelHaveLen rsObj("m_note"),"note"
		select case typeFlag
			case "parse_content_"
				with templateObj: .paresPreNextVideo vid,typeFlag,rsObj("m_type"):.content = replaceStr(.content,"{playpage:textlink}",typeText&"&nbsp;&nbsp;&raquo;&nbsp;&nbsp;"&rsObj("m_name")):.parseIf() : end with
				createTextFile templateObj.content,contentPath,"":echoEach rsObj("m_name"),i,contentLink,"content"
			case "parse_play_"
				cacheFlagPartStr=getRndPlayerurlSpan(1):specialFlag=getRndPlayerurlSpan(2)
				playORdownData=replaceStr(rsObj("m_playdata"),"����CC","FLV����"):y="/"&sitepath&"playdata/"&(vId mod 256)&"/"&vId&".js"
				if IsFromSort=1 then:playORdownData=ResetFromSort(playORdownData):end if:x=PlayData2Json2(playORdownData):templateObj.content = replaceStr(templateObj.content,"{playpage:playurlinfo}","<script type=""text/javascript"" src="""&y&"?"&timer()&"""></script>")
				CreateTextFile "var VideoListJson="&x(0)&",urlinfo='http://'+document.domain+'"&getPlayLink2(vType,vId,venname,vdatetime,"<from>","<pos>")&"';",y,""
				with templateObj:.paresPreNextVideo vid,typeFlag,rsObj("m_type"):.content = replaceStr(.content,"{playpage:textlink}",typeText&"&nbsp;&nbsp;&raquo;&nbsp;&nbsp;<a href='"&contentLink&"'>"&rsObj("m_name")&"</a>"):.content = replaceStr(.content,"{playpage:player}","<script>var param=getHtmlParas('"&fileSuffix&"');viewplay(param[0],param[1])</script>"):.parseIf():end with
				makePlayByData vType,vId,vEnname,vDatetime,x
		end select
	next
	rsObj.close
	set rsObj = nothing
End Sub

Sub makePlayByData(ByVal vType,ByVal vId,ByVal vEnname,ByVal vDatetime,ByVal PlayAry)
	dim temp,x,y,j,i,l,playLink:x=PlayAry
	if ismakeplay=2 then
		if x(1)>-1 then
			temp="on error resume next:Dim ary("&x(1)&"),fo,partname,form:"
			if paramset=0 then
				temp=temp&"dim x:x=split(request.QueryString,""-"")"
			else
				temp=temp&"dim x(2):x(0)=request("""&paramid&"""):x(1)=request("""&parampage&"""):x(2)=request("""&paramindex&""")"
			end if
			temp=temp&vbcrlf&"fo="""&Join(x(3),"$")&""""
			for i=0 to x(1)
				temp=temp&vbcrlf&"ary("&i&")="""&Join(x(2)(i),"$")&""""
			next
			temp=temp&vbcrlf&"form=split(fo,""$"")(x(1))"&vbcrlf&"partname=split(ary(x(1)),""$"")(x(2))"
			temp="<"&"%"&vbcrlf&temp&vbcrlf&"%"&">"&replaceStr(replaceStr(templateObj.content,"{playpage:from}","<"&"%=form%"&">"),"{playpage:part}","<"&"%=partname%"&">")
			playLink = getPlayLink(vType,vId,vEnname,vDatetime)
			createTextFile temp,playLink,""
		end if
	elseif ismakeplay=3 then
		for i=0 to x(1)
			y=x(2)(i):l=UBound(y)
			mareplaycount=mareplaycount+l+1:temp=replaceStr(templateObj.content,"{playpage:from}",x(3)(i))
			for j=0 to l
				playLink = getPlayLink2(vType,vId,vEnname,vDatetime,i,j)
				createTextFile replaceStr(temp,"{playpage:part}",y(j)),playLink,"":echoEach " "&y(j)&" ",i,playLink,"play"
			next
		next
	else
		playLink = getPlayLink(vType,vId,vEnname,vDatetime)
		temp=replaceStr(replaceStr(templateObj.content,"{playpage:part}",""),"{playpage:from}","")
		createTextFile temp,playLink,""
	end if
End Sub

Sub makeArticleById(Byval vId)
	dim rsObj,cacheName,vType,venname,vdatetime,contentPath,contentLink,n,typeFlag,typeText,m_author,m_outline,m_des,m_title,contentTmpName,nameAndTemplateArray
	set rsObj = conn.db("select top 1 m_id,m_title,m_type,m_vid,m_pic,m_hit,m_author,m_content,m_topic,m_color,m_addtime,m_from,m_outline,m_commend,m_letter,m_keyword,m_digg,m_tread,m_entitle,m_datetime,m_note,m_score from {pre}news where m_id="&vId&" AND m_recycle=0","records1")
	if rsObj.recordcount=0 then
		rsObj.close:set rsObj = nothing:echo "<font color='red'>�����ű�ɾ��������</font><br>":exit sub
	end if
	vType=rsObj("m_type"):venname=rsObj("m_entitle"):vdatetime=rsObj("m_datetime")
	if InStr(" ,"&getHideNewsTypeIDS()&",",","&vType&",")>0 then
		rsObj.close:set rsObj = nothing:echo "<font color='red'>����ID:"&vId&" �������������౻���أ���������</font><br>":exit sub
	end if
	nameAndTemplateArray = split(getNewsTypeNameTemplateArrayOnCache(clng(vType)),",")
	if isNul(nameAndTemplateArray(4)) then contentTmpName="news.html" else contentTmpName=nameAndTemplateArray(4)
	contentTemplatePath = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&contentTmpName
	contentPath = getNewsArticleLink(vType,vId,venname,vdatetime,""):contentLink = getNewsArticleLink(vType,vId,venname,vdatetime,"link"):typeText = getNewsTypeTextOnCache(vType)
	currentId=vId:currentTypeId=vType:currentEnname=venname:currentDatetime=vdatetime:typeFlag = "parse_article_":cacheName = typeFlag&vType
	if cacheStart=1 then 
		with templateObj
			if cacheObj.chkCache(cacheName) then  
				.content = cacheObj.getCache(cacheName)  
			else 
				parseCachePart typeFlag:cacheObj.setCache cacheName,.content
			end if
		end with
	else
		parseCachePart typeFlag
	end if
	m_author=rsObj("m_author"):m_des=filterStr(decodeHtml(rsObj("m_content")),"jsiframe"):m_outline=rsObj("m_outline")
	with templateObj
		.paresPreNextNews vid,vType:m_title=rsObj("m_title")
		.content = replaceStr(.content,"{news:id}",rsObj("m_id"))
		.content = replaceStr(.content,"{news:encodetitle}",server.URLEncode(rsObj("m_title")))
		.content = replaceStr(.content,"{news:note}",parseNewsNote(rsObj("m_note")))
		.content = replaceStr(.content,"{news:nolinkkeywords}",rsObj("m_keyword"))
		if isExistStr(.content,"{news:keywords}") then .content = replaceStr(.content,"{news:keywords}",getKeywordsList(rsObj("m_keyword"),"&nbsp;&nbsp;"))
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
		.content = replaceStr(.content,"{news:commend}",rsObj("m_commend"))
		.content = replaceStr(.content,"{news:scorenum}",rsObj("m_score"))
		.content = replaceStr(.content,"{news:link}",contentLink)
		.content = replaceStr(.content,"{news:url}","http://"&siteurl&contentLink)
		.content = replaceStr(.content,"{news:textlink}",typeText&"&nbsp;&nbsp;&raquo;&nbsp;&nbsp;"&m_title)
	end with
	parseLabelHaveLen m_author,"author":parseLabelHaveLen m_outline,"outline"
	templateObj.parseNews vid,m_title,rsObj("m_color"),m_des,rsObj("m_addtime"):templateObj.parseIf()
	with templateObj
		if isExistStr(.content,"{news:subcontent}") OR isExistStr(.content,"{news:subtitle}") OR isExistStr(.content,"{news:subpagenumber") then
			Dim x,y,z,l,i,tmp:x=split(m_des,"#p#"):l=UBound(x)
			for i=0 to l
				tmp=templateObj.content
				if not isExistStr(x(i),"#e#") then x(i)="#e#"&x(i)
				y=split(x(i),"#e#")
				tmp = replaceStr(tmp,"{news:subtitle}",y(0))
				tmp = replaceStr(tmp,"{news:subcontent}",y(1))
				contentPath=formatArticleLink(vType,vId,venname,vdatetime,"",i+1):contentLink=formatArticleLink(vType,vId,venname,vdatetime,"link",i+1)
				echoEach rsObj("m_title")&"  "&y(0),i,contentLink,"news"
				z=StrSlice(tmp,"{news:subpagenumber","}")
				y=.parseAttr(z)("len"):if isNul(y) then y=10 else y=clng(y)
				if l>0 then
					y=pageNumberLinkInfo(i+1,y,l+1,"newssubpage",l+1)
				else
					y=""
				end if
				tmp = replaceStr(tmp,"{news:subpagenumber"&z&"}",y)
				createTextFile tmp,contentPath,""
			next
		else
			createTextFile templateObj.content,contentPath,"":echoEach rsObj("m_title"),i,contentLink,"news"
		end if
	end with
	rsObj.close:set rsObj = nothing
End Sub

Sub MakeNewsSubpage(ByVal content)
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
End Sub

Sub makeChannelByIDS
	dim typeIdArray,i,typeId,typeIdArrayLen,action3,ids:curTypeIndex=getForm("index","get"):action3=getForm("action3","get"):ids=trim(getForm("ids","get"))
	typeIdArray = Split(ids,",")
	typeIdArrayLen = ubound(typeIdArray)
	if isNul(curTypeIndex) then
		curTypeIndex=0
	else
		if clng(curTypeIndex)>clng(typeIdArrayLen) then
			if isNul(action3) then
				alertMsg "����������Ŀȫ���㶨","":terminateAllObjects:die ""
			elseif action3="site" then
				makeIndex:makeAllmovie:alertMsg "һ������ȫ���㶨","":terminateAllObjects:die ""
			end if
		end if
	end if
	typeId = typeIdArray(curTypeIndex)
   	if isNul(typeId) then die "���ඪʧ" else makeChannelById typeId:echoChannelSuspend2 ids,curTypeIndex,action3,makeTimeSpan
End Sub

Sub makeNewsPartByIDS
	dim typeIdArray,i,typeId,typeIdArrayLen,action3,ids:curTypeIndex=getForm("index","get"):action3=getForm("action3","get"):ids=trim(getForm("ids","get"))
	typeIdArray = Split(ids,",")
	typeIdArrayLen = ubound(typeIdArray)
	if isNul(curTypeIndex) then
		curTypeIndex=0
	else 
		if clng(curTypeIndex)>clng(typeIdArrayLen) then
			if isNul(action3) then
				alertMsg "����������Ŀȫ���㶨","":terminateAllObjects:die ""
			elseif action3="newssite" then
				makeNewsIndex:makeAllnews:alertMsg "һ������ȫ���㶨","":terminateAllObjects:die ""
			end if
		end if
	end if
	typeId = typeIdArray(curTypeIndex)
   	if isNul(typeId) then die "���ඪʧ" else makeNewsPartById typeId:echoChannelSuspend2 ids,curTypeIndex,action3,newsmakeTimeSpan
End Sub

Sub echoChannelSuspend2(ids,typeIdIndex,action3,sleep)
	echo "<br>��ͣ"&makeTimeSpan&"����������<script language=""javascript"">setTimeout(""makeNextChannel();"","&makeTimeSpan&"000);function makeNextChannel(){location.href='?action="&action&"&ids="&ids&"&index="&typeIdIndex&"&action3="&action3&"&page="&currentPage&"';}</script>"
End Sub

Sub makeAllChannel
	dim typeIdArray,i,typeId,typeIdArrayLen,action3:curTypeIndex=getForm("index","get"):action3=getForm("action3","get")
	typeIdArray = getTypeIdArrayBySortOnCache(0)
	typeIdArrayLen = ubound(typeIdArray)
	if isNul(curTypeIndex) then
		curTypeIndex=0
	else 
		if clng(curTypeIndex)>clng(typeIdArrayLen) then
			if isNul(action3) then
				alertMsg "����������Ŀȫ���㶨","":terminateAllObjects:die ""
			elseif action3="site" then
				makeIndex:makeAllmovie:alertMsg "һ������ȫ���㶨","":terminateAllObjects:die ""
			end if
		end if
	end if
	typeId = typeIdArray(curTypeIndex)
   	if isNul(typeId) then die "���ඪʧ" else makeChannelById typeId:echoChannelSuspend curTypeIndex,action3,makeTimeSpan
End Sub

Sub makeAllNewsPart
	dim typeIdArray,i,typeId,typeIdArrayLen,action3:curTypeIndex=getForm("index","get"):action3=getForm("action3","get")
	typeIdArray = getNewsTypeIdArrayBySortOnCache(0)
	typeIdArrayLen = ubound(typeIdArray)
	if isNul(curTypeIndex) then
		curTypeIndex=0
	else 
		if clng(curTypeIndex)>clng(typeIdArrayLen) then
			if isNul(action3) then
				alertMsg "����������Ŀȫ���㶨","":terminateAllObjects:die ""
			elseif action3="newssite" then
				makeNewsIndex:makeAllnews:alertMsg "һ������ȫ���㶨","":terminateAllObjects:die ""
			end if
		end if
	end if
	typeId = typeIdArray(curTypeIndex)
   	if isNul(typeId) then die "���ඪʧ" else makeNewsPartById typeId:echoChannelSuspend curTypeIndex,action3,newsmakeTimeSpan
End Sub

Sub echoChannelSuspend(Index,action3,sleep)
	echo "<br>��ͣ"&sleep&"����������<script language=""javascript"">setTimeout(""makeNextChannel();"","&sleep&"000);function makeNextChannel(){location.href='?action="&action&"&index="&Index&"&action3="&action3&"&page="&currentPage&"';}</script>"
End Sub

Function getTopicIdArrayBySortOnCache()
	dim cacheName:cacheName="topicidarraybysort"
	dim x
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then x = cacheObj.getCache(cacheName) else x = split(handleArrayIdStr(getTopicId()),","):cacheObj.setCache cacheName,x
	else
		x = split(handleArrayIdStr(getTopicId()),",")
	end if
	getTopicIdArrayBySortOnCache = x
End Function

Function getTypeIdArrayBySortOnCache(Byval topId)
	dim cacheName:cacheName="typeidarraybysort"&topId
	dim x
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then x = cacheObj.getCache(cacheName) else x = split(handleArrayIdStr(getTypeId(topId)),","):cacheObj.setCache cacheName,x
	else
		x = split(handleArrayIdStr(getTypeId(topId)),",")
	end if
	getTypeIdArrayBySortOnCache = x
End Function

Function getNewsTypeIdArrayBySortOnCache(Byval topId)
	dim cacheName:cacheName="newstypeidarraybysort"&topId
	dim x
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then x = cacheObj.getCache(cacheName) else x = split(handleArrayIdStr(getNewsTypeId(topId)),","):cacheObj.setCache cacheName,x
	else
		x = split(handleArrayIdStr(getNewsTypeId(topId)),",")
	end if
	getNewsTypeIdArrayBySortOnCache = x
End Function

Function handleArrayIdStr(Byval str)
	if left(str,2) = "0," then handleArrayIdStr=right(str,len(str)-2) else handleArrayIdStr=str
End Function

Sub makeChannel
	dim channel:channel = replaceStr(getForm("channel","both")," ",""):curTypeIndex=getForm("index","get"):if isNul(channel) then die "��ѡ�����"
	if isNum(curTypeIndex) then curTypeIndex=Clng(curTypeIndex) else curTypeIndex=0
	makeChannelById channel:if curTypeIndex<1 then echoChannelSuspend3 channel,curTypeIndex,makeTimeSpan
End Sub

Sub makeNewsPart
	dim channel:channel = replaceStr(getForm("channel","both")," ",""):curTypeIndex=getForm("index","get"):if isNul(channel) then die "��ѡ�����"
	if isNum(curTypeIndex) then curTypeIndex=Clng(curTypeIndex) else curTypeIndex=0
	makeNewsPartById channel:if curTypeIndex<1 then echoChannelSuspend3 channel,curTypeIndex,newsmakeTimeSpan
End Sub

Sub echoChannelSuspend3(channel,typeIdIndex,sleep)
	echo "<br>��ͣ"&sleep&"����������<script language=""javascript"">setTimeout(""makeNextChannel();"","&sleep&"000);function makeNextChannel(){location.href='?action="&action&"&channel="&channel&"&index="&typeIdIndex&"&page="&currentPage&"';}</script>"
End Sub

Sub makeLengthchannel
	dim channel:channel = replaceStr(getForm("channel","both")," ",""):if isNul(channel) then die "��ѡ�����"
	dim startPage:startPage = request("startPage")
	if isNul(startPage) then
		die "����д��ʼҳ"
	elseif  not(isNum(startPage)) then
		die "����ȷ��д��ʼҳ"
	end if
	dim endPage:endPage = getForm("endPage","both")
	if isNul(endPage) then
		die "����д����ҳ"
	elseif  not(isNum(endPage)) then 
		die "����ȷ��д����ҳ"
	end if
	startPage = clng(startPage):endPage = clng(endPage)
	if startpage<=0 then die "�������ҳ��С��0"
	if startPage>endpage then die "������Ľ���ҳС�ڿ�ʼҳ"
	makeLengthChannelById channel, startPage,endPage
End Sub

Sub makenewslengthchannel
	dim channel:channel = replaceStr(getForm("channel","both")," ",""):if isNul(channel) then die "��ѡ�����"
	dim startPage:startPage = request("startPage")
	if isNul(startPage) then
		die "����д��ʼҳ"
	elseif  not(isNum(startPage)) then
		die "����ȷ��д��ʼҳ"
	end if
	dim endPage:endPage = getForm("endPage","both")
	if isNul(endPage) then
		die "����д����ҳ"
	elseif  not(isNum(endPage)) then 
		die "����ȷ��д����ҳ"
	end if
	startPage = clng(startPage):endPage = clng(endPage)
	if startpage<=0 then die "�������ҳ��С��0"
	if startPage>endpage then die "������Ľ���ҳС�ڿ�ʼҳ"
	makeLengthPartById channel, startPage,endPage
End Sub

Sub	makeChannelById(Byval typeId)
	dim i,Q,typeIds,rsObj,pSize,curTypeId,cacheName,pCount,nCount,channelLink,channelTmpName,tempStr,nameAndTemplateArray
	currentPage= getForm("page","get"):if isNum(currentPage) then currentPage=Clng(currentPage) else currentPage=1
	nameAndTemplateArray = split(getTypeNameTemplateArrayOnCache(clng(typeId)),",")
	if isNul(nameAndTemplateArray(1)) then channelTmpName="channel.html" else channelTmpName=nameAndTemplateArray(1)
	channelTemplatePath = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&channelTmpName
	pSize = getPageSizeOnCache(channelTemplatePath,"channel",channelTmpName):if isNul(pSize) then pSize=12
	typeIds = getTypeIdOnCache(typeId)
	echoBegin nameAndTemplateArray(0),"channel"
	set rsObj = conn.db("select m_id,m_name,m_type from {pre}data where m_recycle=0 AND m_type in ("&typeIds&")","records1")
	rsObj.pagesize = pSize:currentTypeId = typeId:cacheName = "parse_channel_"&currentTypeId
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then 
			templateObj.content = cacheObj.getCache(cacheName)  
		else 
			parseCachePart "channel":cacheObj.setCache cacheName,templateObj.content
		end if
	else
		parseCachePart "channel"
	end if
	tempStr = templateObj.content:pCount = rsObj.pagecount
	if isTypeHide(typeId)=1 then echo "����<font color=red >"&nameAndTemplateArray(0)&"</font>Ϊ����״̬����������":rsObj.close:set rsObj = nothing:exit sub
	if rsObj.recordcount=0 then
		channelLink = getChannelPagesLink(currentTypeId,1)
		tempStr = replaceStr(tempStr,"{channelpage:page}",1)
		with templateObj:.content=tempStr:.ParsePageList typeIds,1,pCount,"channel":.parseIf():channelStr = .content:end with
		createTextFile channelStr,channelLink,"":echoEach nameAndTemplateArray(0),1,channelLink,"channel"
	end if
	if InStr(tempStr,"{/maxcms:channellist}")=0 then pCount=1
	if currentPage<1 then currentPage=1
	nCount=200+currentPage-1:if pCount<nCount then:nCount=pCount:end if
	for i=currentPage to nCount
		channelLink = getChannelPagesLink(currentTypeId,i)
		with templateObj:.content=replaceStr(tempStr,"{channelpage:page}",i):.ParsePageList typeIds,i,pCount,"channel":.parseIf():channelStr = .content:end with
		createTextFile channelStr,channelLink,"":echoEach nameAndTemplateArray(0),i,channelLink,"channel"
	next
	rsObj.close:set rsObj = nothing:currentPage=i
	if nCount>=pCount then
		curTypeIndex=curTypeIndex+1:currentPage=1
	end if
End Sub

Sub	makeNewsPartById(Byval typeId)
	dim i,Q,typeIds,rsObj,pSize,curTypeId,cacheName,pCount,nCount,channelLink,channelTmpName,tempStr,nameAndTemplateArray
	currentPage= getForm("page","get"):if isNum(currentPage) then currentPage=Clng(currentPage) else currentPage=1
	nameAndTemplateArray = split(getNewsTypeNameTemplateArrayOnCache(clng(typeId)),",")
	if isNul(nameAndTemplateArray(1)) then channelTmpName="newspage.html" else channelTmpName=nameAndTemplateArray(1)
	channelTemplatePath = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&channelTmpName
	pSize = getPageSizeOnCache(channelTemplatePath,"newspage",channelTmpName):if isNul(pSize) then pSize=12
	typeIds = getNewsTypeIdOnCache(typeId)
	echoBegin nameAndTemplateArray(0),"newspage"
	set rsObj = conn.db("select m_id,m_title,m_type from {pre}news where m_recycle=0 AND m_type in ("&typeIds&")","records1")
	rsObj.pagesize = pSize:currentTypeId = typeId:cacheName = "parse_npl_"&currentTypeId
	if cacheStart=1 then
		if cacheObj.chkCache(cacheName) then 
			templateObj.content = cacheObj.getCache(cacheName)  
		else 
			parseCachePart "newspage":cacheObj.setCache cacheName,templateObj.content
		end if
	else
		parseCachePart "newspage"
	end if
	tempStr = templateObj.content:pCount = rsObj.pagecount
	if isNewsTypeHide(typeId)=1 then echo "����<font color=red >"&nameAndTemplateArray(0)&"</font>Ϊ����״̬����������":rsObj.close:set rsObj = nothing:exit sub
	if rsObj.recordcount=0 then
		channelLink = getNewsPartLink(currentTypeId,1)
		tempStr = replaceStr(tempStr,"{newspagelist:page}",1)
		with templateObj:.content=tempStr:.parseNewsPartList typeIds,1,pCount,"newspage":.parseIf():channelStr = .content:end with
		createTextFile channelStr,channelLink,"":echoEach nameAndTemplateArray(0),1,channelLink,"newspage"
	end if
	if InStr(tempStr,"{/maxcms:newspagelist}")=0 then pCount=1
	if currentPage<1 then currentPage=1
	nCount=200+currentPage-1:if pCount<nCount then:nCount=pCount:end if
	for i=currentPage to nCount
		channelLink = getNewsPartLink(currentTypeId,i)
		with templateObj:.content=replaceStr(tempStr,"{newspagelist:page}",i):.parseNewsPartList typeIds,i,pCount,"newspage":.parseIf():channelStr = .content:end with
		createTextFile channelStr,channelLink,"":echoEach nameAndTemplateArray(0),i,channelLink,"newspage"
	next
	rsObj.close:set rsObj = nothing:currentPage=i
	if nCount>=pCount then
		curTypeIndex=curTypeIndex+1:currentPage=1
	end if
End Sub

Sub	makeLengthChannelById(Byval typeId,byval startpage ,byval endPage)
	dim i,typeIds,rsObj,pSize,curTypeId,cacheName,pCount,channelLink,channelTmpName,tempStr,nameAndTemplateArray
	nameAndTemplateArray = split(getTypeNameTemplateArrayOnCache(clng(typeId)),",")
	if isNul(nameAndTemplateArray(1)) then channelTmpName="channel.html" else channelTmpName=nameAndTemplateArray(1)
	channelTemplatePath = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&channelTmpName
	pSize = getPageSizeOnCache(channelTemplatePath,"channel",channelTmpName):if isNul(pSize) then pSize=12
	typeIds = getTypeIdOnCache(typeId)
	echoBegin nameAndTemplateArray(0),"channel"
	set rsObj = conn.db("select m_id,m_name,m_type from {pre}data where m_recycle=0 AND m_type in ("&typeIds&")","records1")
	if rsObj.recordcount=0 then echo "<font color='red'>��Ŀ¼������</font><br>":Exit Sub
	rsObj.pagesize = pSize:currentTypeId = typeId:cacheName = "parse_channel_"&currentTypeId
	if cacheStart=1 then 
		if cacheObj.chkCache(cacheName) then 
			templateObj.content = cacheObj.getCache(cacheName)  
		else 
			parseCachePart "channel":cacheObj.setCache cacheName,templateObj.content
		end if
	else
		parseCachePart "channel"
	end if
	tempStr = templateObj.content:pCount = rsObj.pagecount
	if InStr(tempStr,"{/maxcms:channellist}")=0 then pCount=1
	for i=1 to pCount
		if i>=startpage  and i<=endPage then
			channelLink = getChannelPagesLink(currentTypeId,i)
			with templateObj
				.content=replaceStr(tempStr,"{channelpage:page}",i):.ParsePageList typeIds,i,pCount,"channel":.parseIf():channelStr = .content
			end with
			createTextFile channelStr,channelLink,"":echoEach nameAndTemplateArray(0),i,channelLink,"channel"
		end if
	next
	rsObj.close
	set rsObj = nothing
End Sub

Sub	makeLengthPartById(Byval typeId,byval startpage ,byval endPage)
	dim i,typeIds,rsObj,pSize,curTypeId,cacheName,pCount,channelLink,channelTmpName,tempStr,nameAndTemplateArray
	nameAndTemplateArray = split(getNewsTypeNameTemplateArrayOnCache(clng(typeId)),",")
	if isNul(nameAndTemplateArray(1)) then channelTmpName="newspage.html" else channelTmpName=nameAndTemplateArray(1)
	channelTemplatePath = "/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&channelTmpName
	pSize = getPageSizeOnCache(channelTemplatePath,"newspage",channelTmpName):if isNul(pSize) then pSize=12
	typeIds = getTypeIdOnCache(typeId)
	echoBegin nameAndTemplateArray(0),"newspage"
	set rsObj = conn.db("select m_id,m_title,m_type from {pre}news where m_recycle=0 AND m_type in ("&typeIds&")","records1")
	if rsObj.recordcount=0 then echo "<font color='red'>��Ŀ¼������</font><br>":Exit Sub
	rsObj.pagesize = pSize:currentTypeId = typeId:cacheName = "parse_newspage_"&currentTypeId
	if cacheStart=1 then 
		if cacheObj.chkCache(cacheName) then 
			templateObj.content = cacheObj.getCache(cacheName)  
		else 
			parseCachePart "newspage":cacheObj.setCache cacheName,templateObj.content
		end if
	else
		parseCachePart "newspage"
	end if
	tempStr = templateObj.content:pCount = rsObj.pagecount
	if InStr(tempStr,"{/maxcms:newspagelist}")=0 then pCount=1
	for i=1 to pCount
		if i>=startpage  and i<=endPage then
			channelLink = getNewsPartLink(currentTypeId,i)
			with templateObj
				.content=replaceStr(tempStr,"{newspagelist:page}",i):.parseNewsPartList typeIds,i,pCount,"newspage":.parseIf():channelStr = .content
			end with
			createTextFile channelStr,channelLink,"":echoEach nameAndTemplateArray(0),i,channelLink,"newspage"
		end if
	next
	rsObj.close
	set rsObj = nothing
End Sub

Sub parseCachePart(pageType)
	dim z
	with templateObj
		select case pageType
			case "channel"
				.content=loadFile(channelTemplatePath):.parseTopAndFoot():.parseSelf():.parseGlobal():z=getTypeField(currentTypeId,"m_keyword,m_description","")
				.content = replaceStr(replaceCurrentTypeId(.content),"{channelpage:typetext}",getTypeTextOnCache(currentTypeId))
				.content = replaceStr(replaceStr(.content,"{channelpage:keywords}",z(0)),"{channelpage:description}",z(1))
				.content = replaceStr(.content,"{channelpage:typename}",split(getTypeNameTemplateArrayOnCache(currentTypeId),",")(0))
				.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList()
			case "parse_content_"
				.content=loadFile(contentTemplatePath):.parsePlayPageSpecial:.parseTopAndFoot():.parseSelf():.parseGlobal()
				.content = replaceStr(replaceCurrentTypeId(.content),"{playpage:typeid}",currentTypeId)
				if isExistStr(.content,"{playpage:typename}") then .content=replaceStr(.content,"{playpage:typename}",split(getTypeNameTemplateArrayOnCache(currentTypeId),",")(0))
				if isExistStr(.content,"{playpage:typelink}") then .content = replaceStr(.content,"{playpage:typelink}",getTypeLink(currentTypeId))
				if isExistStr(.content,"{playpage:upid}") then .content = replaceStr(.content,"{playpage:upid}",getTypeUpid(currentTypeId))
				.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList()
			case "parse_play_"
				.content=loadFile(playTemplatePath):.parsePlayPageSpecial:.parseTopAndFoot():.parseSelf():.parseGlobal()
				.content = replaceStr(replaceCurrentTypeId(.content),"{playpage:typeid}",currentTypeId)
				if isExistStr(.content,"{playpage:typename}") then .content=replaceStr(.content,"{playpage:typename}",split(getTypeNameTemplateArrayOnCache(currentTypeId),",")(0))
				if isExistStr(.content,"{playpage:typelink}") then .content = replaceStr(.content,"{playpage:typelink}",getTypeLink(currentTypeId))
				if isExistStr(.content,"{playpage:upid}") then .content = replaceStr(.content,"{playpage:upid}",getTypeUpid(currentTypeId))
				.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList()
			case "topicindex"
				.load(topicTemplatePath):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceCurrentTypeId(.content):.content=replaceTopicId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList()
			case "topicpage"
				.load(topicTemplatePath):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceTopicId(replaceCurrentTypeId(.content)):.content=replaceStr(.content,"{maxcms:topicname}",topicpageName):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList():.parseLinkList
			case "newspage"
				.content=loadFile(channelTemplatePath):.parseTopAndFoot():.parseSelf():.parseGlobal():z=getTypeField(currentTypeId,"m_keyword,m_description","news")
				.content = replaceStr(replaceCurrentTypeId(.content),"{newspagelist:typetext}",getNewsTypeTextOnCache(currentTypeId)):.content = replaceStr(replaceStr(.content,"{newspagelist:keywords}",z(0)),"{newspagelist:description}",z(1))
				.content = replaceStr(.content,"{newspagelist:typename}",split(getNewsTypeNameTemplateArrayOnCache(currentTypeId),",")(0))
				.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList()
			case "parse_article_"
				.content=loadFile(contentTemplatePath):.parseNewsPageSpecial():.parseTopAndFoot():.parseSelf():.parseGlobal()
				.content = replaceStr(replaceCurrentTypeId(.content),"{news:typeid}",currentTypeId)
				if isExistStr(.content,"{news:upid}") then .content = replaceStr(.content,"{news:upid}",getNewsTypeUpid2(currentTypeId))
				if isExistStr(.content,"{news:typename}") then .content = replaceStr(.content,"{news:typename}",split(getNewsTypeNameTemplateArrayOnCache(currentTypeId),",")(0))
				.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList()
			case "customvideo"
				.load(templatePath):.parseTopAndFoot():.parseSelf():.parseGlobal():.content=replaceStr(.content,"{maxcms:runinfo}",""):.content=replaceCurrentTypeId(.content):.content=replaceTopicId(.content):.parseMenuList(""):.parseAreaList():.parseTopicList():.parseVideoList():.parseNewsList()
			end select
	end with
End Sub

Sub echoBegin(Byval str,Byval pType)
	select case pType
		case "channel","newspage"
			echo "���ڿ�ʼ������Ŀ<font color='red'>"&str&"</font>���б�<br>"
		case "content"
			echo str
		case "topicindex"
			echo "���ڿ�ʼ����ר�����б�<br>" 
		case "topicpage"
			echo "���ڿ�ʼ����ר��<font color='red'>"&str&"</font>���б�<br>"
	end select
End Sub

Sub echoEach(Byval str,Byval cur,Byval link,Byval pType)
	select case pType
		case "channel","newspage"
			echo " �ɹ�������Ŀ<font color='red'>"&str&"</font>�ĵ�<font color='red'>"&cur&"</font>ҳ�б���<a href='"&link&"' target='_blank'><font color='red'>"&link&"</font></a><br>"
		case "content"
			echo " �ɹ�����<font color='red'>"&str&"</font>�ĵ�ַ��<a href='"&link&"' target='_blank'><font color='red'>"&link&"</font></a><br>"
		case "play"
			echo " &nbsp;&nbsp;�ɹ�����<font color='blue'>"&str&"</font>���ŵ�ַ��<a href='"&link&"' target='_blank'><font color='blue'>"&link&"</font></a><br>"
		case "news"
			echo " �ɹ���������<font color='red'>"&str&"</font>�ĵ�ַ��<a href='"&link&"' target='_blank'><font color='red'>"&link&"</font></a><br>"
		case "topicindex"
			echo " �ɹ����������б�<font color='red'>"&str&"</font>�ĵ�ַ��<a href='"&link&"' target='_blank'><font color='red'>"&link&"</font></a><br>"
		case "topicpage"
			echo " �ɹ�����������ҳ<font color='red'>"&str&"</font>�ĵ�ַ��<a href='"&link&"' target='_blank'><font color='red'>"&link&"</font></a><br>"
		end select
End Sub

Sub echoTopicSelect
	dim topicArray
	topicArray = conn.db("select m_id,m_name from {pre}topic order by m_id asc","array")
	echo makeTopicSelect("channel",topicArray,"��ѡ��ר��","")
End Sub

Sub makeBaidu
	if flag<>1 then
		echo "<div><b>����baidu��ͼ</b>�� ���������<input type='text' id='allmakenum' value='500'>ÿҳ����<input type='text' id='makenum' value='100'> <input type='button' class='btn' value='��ʼ����' onclick=""javascript:location.href='?action=baidu&flag=1&allmakenum='+$('allmakenum').value+'&makenum='+$('makenum').value"" /></div>"
	else
		if isNul(makenum) then makenum=100 else makenum=clng(makenum)
		allmakenum=getForm("allmakenum","get"):if isNul(allmakenum) then allmakenum=500 else allmakenum=clng(allmakenum)
		dim vDes,vName,i,j,rsObj,baiduStr,allmakenum,pagenum,xmlUrl,dt:set rsObj=conn.db("select top "&allmakenum&" m_id,m_name,m_pic,m_actor,m_des,m_addtime,m_type,m_enname,m_datetime from {pre}data WHERE m_recycle=0 order by m_addtime desc","records1")
		rsObj.pagesize=makenum
		pagenum=rsObj.pagecount
		for i=1 to pagenum
			rsObj.absolutepage=i
			baiduStr =  "<?xml version=""1.0"" encoding=""utf-8"" ?>"&vbcrlf&_
							"<document>"&vbcrlf&_
							"<webSite>http://"&siteUrl&"</webSite>"&vbcrlf&_
							"<webMaster>"&siteName&"</webMaster>"&vbcrlf&_
							"<updatePeri>1800</updatePeri>"&vbcrlf
			for j=1 to rsObj.pagesize
				vDes=rsObj("m_des"):if isNul(vDes) then vDes=""
				vName=rsObj("m_name"):if isNul(vName) then vName=""
				baiduStr = baiduStr & "<item>"&vbcrlf&_
									  "<title>"&server.htmlencode(vName)&"</title>"&vbcrlf&_
									  "<link>http://"&siteUrl&getContentLink(rsObj("m_type"),rsObj("m_id"),rsObj("m_enname"),rsObj("m_datetime"),"link")&"</link>"&vbcrlf&_  
									  "<text>"&server.htmlencode(filterStr(left(vDes, 300),"html"))&"</text>"&vbcrlf
				If left(rsObj("m_pic"), 7) = "http://"  Then
					baiduStr = baiduStr & "<image>"&rsObj("m_pic")&"</image>"&vbcrlf
				Else
					baiduStr = baiduStr & "<image>http://"&siteUrl&"/"&sitePath&rsObj("m_pic")&"</image>"&vbcrlf
				End If
				dt=rsObj("m_addtime")
				baiduStr = baiduStr & "<keywords>"&rsObj("m_name")&","&rsObj("m_actor")&"</keywords>"&vbcrlf&_
									  "<author>"&siteName&"</author>"&vbcrlf&_
									  "<source>"&siteName&"</source>"&vbcrlf&_
									  "<pubDate>"&Year(dt)&"-"&Month(dt)&"-"&Day(dt)&"</pubDate>"&vbcrlf&_
									  "</item>"&vbcrlf
				rsObj.movenext
				if rsObj.eof then exit for
			next
			baiduStr = baiduStr + "</document>"&vbcrlf
			if i=1 then xmlUrl="" else xmlUrl="_"&i
			createTextFile baiduStr,"../baidu"&xmlUrl&".xml","utf-8"
			echo "http://"&siteUrl&"/"&sitePath&"baidu"&xmlUrl&".xml"&" ������� <a target='_blank' href='../baidu"&xmlUrl&".xml'><font color=red>���</font></a><br>"
		next
		rsObj.close:set rsObj=nothing:echo "�������"
		die  "��ͨ��<a href='http://news.baidu.com/newsop.html' target='_blank'>http://news.baidu.com/newsop.html</a>�ύ!"
	end if	
End Sub

Sub makeGoogle
	if flag<>1 then
		echo "<div><b>����google��ͼ</b>�� ���������<input type='text' id='allmakenum' value='500'>ÿҳ����<input type='text' id='makenum' value='100'> <input type='button' class='btn' value='��ʼ����' onclick=""javascript:location.href='?action=google&flag=1&allmakenum='+$('allmakenum').value+'&makenum='+$('makenum').value""/></div>"
	else
		if isNul(makenum) then makenum=100 else makenum=clng(makenum)
		allmakenum=getForm("allmakenum","get"):if isNul(allmakenum) then allmakenum=500 else allmakenum=clng(allmakenum)
		dim i,j,rsObj,googleStr,allmakenum,pagenum,xmlUrl,googleDateArray,googleDate:set rsObj=conn.db("select top "&allmakenum&" m_id,m_name,m_pic,m_actor,m_des,m_addtime,m_type,m_enname,m_datetime from {pre}data WHERE m_recycle=0 order by m_addtime desc","records1")
		rsObj.pagesize=makenum
		pagenum=rsObj.pagecount
		for i=1 to pagenum
			rsObj.absolutepage=i
			googleStr =  "<?xml version=""1.0"" encoding=""UTF-8""?>"&vbcrlf&_
							"<urlset xmlns=""http://www.google.com/schemas/sitemap/0.84"">"&vbcrlf&_
							"<url>"&vbcrlf&_
							"<loc>http://"&siteUrl&"</loc>"&vbcrlf&_
							"</url>"&vbcrlf
			for j=1 to rsObj.pagesize
					googleDateArray=rsObj("m_addtime")
					googleDate=Year(googleDateArray)&"-"&Right("00"&Month(googleDateArray),2)&"-"&Right("00"&Day(googleDateArray),2)&"T"&Right("00"&Hour(googleDateArray),2)&":"&Right("00"&Minute(googleDateArray),2)&":00+00:00"
					googleStr = googleStr & "<url>"&vbcrlf&_
										  "<loc>http://"&siteUrl&getContentLink(rsObj("m_type"),rsObj("m_id"),rsObj("m_enname"),rsObj("m_datetime"),"link")&"</loc>"&vbcrlf&_
										  "<lastmod>"&googleDate&"</lastmod>"&vbcrlf&_
										  "</url>"&vbcrlf
					rsObj.movenext
					if rsObj.eof then exit for
			next
			googleStr = googleStr + "</urlset>"&vbcrlf
			if i=1 then xmlUrl="" else xmlUrl="_"&i
			createTextFile googleStr,"../google"&xmlUrl&".xml","utf-8"			
			echo "http://"&siteUrl&"/"&sitePath&"google"&xmlUrl&".xml"&" ������� <a target='_blank' href='../google"&xmlUrl&".xml'><font color=red>���</font></a><br>"
		next
		rsObj.close:set rsObj=nothing:echo "�������"
		die  "��ͨ��<a href='http://www.google.com/webmasters/tools/' target='_blank'>http://www.google.com/webmasters/tools/</a>�ύ!"
	end if	
End Sub

Sub makeDaysview
	dim days,rsObj,sql,rCount,page,i
	days = getForm("days","both"):page=getForm("page","both")
	if databaseType = 0 then
		sql = "SELECT m_id FROM m_data where m_recycle=0 AND datediff('d',m_addtime,#"&now&"#)<"&days+1
	else
 		sql = "SELECT m_id FROM m_data where m_recycle=0 AND datediff(d,m_addtime,'"&now&"')<"&days+1
	end if
	set rsObj = conn.db(sql,"records1"):rCount=rsObj.recordcount
	if rCount=0 then die  "����û����Ƶ<br>"
	if isNul(page) then page=0 else page=clng(page)
	echoBegin "���ڿ�ʼ���ɵ�������,��ǰ������<font color='red'>"&(page+1)&"</font> �� <font color='red'>"&(page+ifthen(rCount<100,rCount,100))&"</font>ҳ,��<font color='red'>"&rCount&"</font>ҳ<br>","content"
	rsObj.move(page)
	for i=1 to 100
		if not rsObj.eof then
			makeContentById(rsObj(0)):page=page+1:rsObj.movenext
		else
			echo "�������"&days&"��㶨":rsObj.close:set rsObj = nothing:exit sub
		end if
	next
	echoDaySuspend page,days,makeTimeSpan
	rsObj.close:set rsObj = nothing
End Sub

Sub makenewsDaysview
	dim days,rsObj,sql
	days = getForm("days","post")
	if databaseType = 0 then
		sql = "SELECT m_id FROM m_news where m_recycle=0 AND datediff('d',m_addtime,#"&now&"#)<"&days+1
	else
 		sql = "SELECT m_id FROM m_news where m_recycle=0 AND datediff(d,m_addtime,'"&now&"')<"&days+1
	end if
	set rsObj = conn.db(sql,"records1")
	while not rsObj.eof
		makeArticleById rsObj(0)
		rsObj.movenext
	wend
	rsObj.close:set rsObj = nothing
End Sub

Sub makeRss
	if flag<>1 then
		echo "<div><b>����RSS��ͼ</b>�� �������<input type='text' id='makenum' value='100'> <input type='button' class='btn' value='��ʼ����' onclick=""javascript:location.href='?action=rss&flag=1&makenum='+$('makenum').value"" /></div>"
	else
		if isNul(makenum) then makenum=100 else makenum=clng(makenum)
		dim vDes,i,rsArray,rssStr:conn.fetchCount=makenum:rsArray=conn.db("select top "&makenum&" m_id,m_name,m_pic,m_actor,m_des,m_addtime,m_type,m_enname,m_datetime from {pre}data WHERE m_recycle=0 order by m_addtime desc","array"):conn.fetchCount=0
		if isArray(rsArray) then makenum = ubound(rsArray,2) else makenum=-1
		rssStr =  "<?xml version=""1.0"" encoding=""utf-8"" ?>"&vbcrlf&_
						"<rss version='2.0'>"&vbcrlf&_
						"<channel>"&vbcrlf&_
						"<title><![CDATA["&siteName&"]]></title>"&vbcrlf&_
						"<description><![CDATA["&siteDes&"]]></description>"&vbcrlf&_
						"<link>http://"&siteUrl&"</link>"&vbcrlf&_
						"<language>zh-cn</language>"&vbcrlf&_
						"<docs>"&siteName&"</docs>"&vbcrlf&_
						"<generator>Rss Powered By "&siteUrl&"</generator>"&vbcrlf&_
						"<image>"&vbcrlf&_
							"<url>http://"&siteUrl&"/pic/logo.gif</url>"&vbcrlf&_
						"</image>"&vbcrlf
		for i = 0 to makenum
			vDes=rsArray(4,i):if isNul(vDes) then vDes=""
			rssStr = rssStr & "<item>"&vbcrlf&_
								"<title><![CDATA["&rsArray(1,i)&"]]></title>"&vbcrlf&_
								"<link>http://"&siteUrl&getContentLink(rsArray(6,i),rsArray(0,i),rsArray(7,i),rsArray(8,i),"link")&"</link>"&vbcrlf&_
								"<author>"&rsArray(3,i)&"</author>"&vbcrlf&_
								"<pubDate>"&rsArray(5,i)&"</pubDate>"&vbcrlf&_
								"<description><![CDATA["&server.htmlencode(filterStr(left(vDes, 300),"html"))&"]]></description>"&vbcrlf&_		
							   "</item>"&vbcrlf
		next
		rssStr = rssStr & "</channel></rss>"
		createTextFile rssStr,"../rss.xml","utf-8"
		echo "http://"&siteUrl&"/"&sitePath&"rss.xml <a target='_blank' href='../rss.xml'><font color=red>���</font></a><br>"
	end if	
End Sub

Function transTimeFormat(Byval plen,Byval str)
	dim vlen,i,vstr:vstr=str:vlen=len(str)
	for i=1 to (plen-vlen)
		vstr="0"&vstr
	next
	transTimeFormat=vstr
End Function
%>