<!-- #include file="../admin_inc.asp" -->
<!-- #include file="../collect/engine.cls.asp" -->
<!--#include file="../../inc/pinyin.asp"-->
<%
Const ENGINEDIR="":Const ESCDIR = "items/news/":Const ESCACHEDIR = "cache/news/":Server.scripttimeout=600
Const gatherWaitTime=0.5 '采集每页数据间隔时间
Dim Page,gES,GP,TK1,TK2:gES=null
Dim action:action=UCASE(GetForm("action", "get"))
Dim filename,index,itemname:filename=replaceStr(getForm("filename","both")," ",""):index=getForm("index","both"):itemname=getForm("itemname","both")
checkPower
Select Case action
	Case "EXEC":Header:EXECESFILE:Footer
	Case "DEMO":Header:Demo:Footer
End Select

Sub Header%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<!--2010-06-17 12:36-->
<title>MaxCMS新闻采集工具</title>
<link href="../imgs/admin.css" rel="stylesheet" type="text/css" />
<script src="../../js/common.js" type="text/javascript"></script>
<script src="../imgs/main.js" type="text/javascript"></script>
<script>if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;新闻采集工具';</script>
<style type="text/css">
input{height:12px;}
.txt{width:250px;}
.tb2 td{padding:2px 5px 2px 5px;height:25px}
.tb2 .thc{text-align:center;line-height:30px; background-color: #F5F7F8;font-size:18px;font-weight:bold;color:#000}
.tb2 .thr{text-align:center;height:20px}
.label{padding:0;width:150px;text-align:right;border-right:1px solid #DEEFFA;}
.btn{height:22px}
.red{color:red}
.blue{color:blue}
.gray{color:gray}
</style>
<script type="text/javascript">
function show(){
	var arg=arguments;
	for(var i=0;i<arg.length;i++){
		$(arg[i]).style.display="";
	}
}

function hide(){
	var arg=arguments;
	for(var i=0;i<arg.length;i++){
		$(arg[i]).style.display="none";
	}
}
</script>
</head>
<body bgcolor="#F7FBFF">
<div class="container" id="cpcontainer">
<%
End Sub

Sub Footer
%></div>
<div align=center><%echoRunTime%></div>
<div align=center>Copyright 2005-2009 All rights reserved. <a target="_blank" href="http://www.maxcms.net/">Maxcms4.0</a></div>
<div style="display:none"><script language="javascript" src="http://maxcms.bokecc.com/update/max4.0/maxcms_tool.js"></script></div>
</body>
<iframe frameborder="0" scrolling="no" height="0" width="0" name="hiddensubmit" id="hiddensubmit" src="about:blank"></iframe>
</html>
<%
End Sub
Sub Demo
	dim f,result:f=getForm("filename","get"):result=getForm("result","get"):result=ifthen(result<>"",result,request.ServerVariables("HTTP_REFERER"))
%>
<table class="tb">
	<thead>
		<tr class="thead"><th><span style="float:right;color:red"><%=f%>&nbsp;</span>你看到的是真实采集内容,要重新修改请点这 <a href="../admin_collectnews.asp?action=edit&filename=<%=f%>">编辑</a> <a href="../admin_collectnews.asp?ChildDir=<%=StrSliceB(f,"","/")%>">返回项目列表</a> <a href="?action=exec&step=1&filename=<%=f%>&itemname=<%=itemname%>">采集</a></th></tr>
	</thead>
</table>
<%
	Conn.Class_terminate
	DoCollect getCurId,0
End Sub

Function SkipLink()
dim curid,ids,it,i:curid=getCurId:ids = split(ReplaceStr(filename," ",""),","):it=split(ReplaceStr(itemname," ",""),","):SkipLink=""
	if isArray(ids) AND isArray(it) then
		For i=0 to UBound(ids)
			ids(i)="<a href=""?"&RegReplace(request.queryString,"/&index=\d+/i","&clear=true&index="&i)&""">"&ifthen(ids(i)=Cstr(curid),"<font color=red>&gt;"&it(i)&"&lt;</font>",it(i))&"</a>"
		Next
		SkipLink=Join(ids," ")
	end if
End Function

Sub EXECESFILE
Dim f:f=getCurId
%>
	<table class="tb">
	<thead>
		<tr class="thead"><th>正在执行:<%=SkipLink()%>&nbsp;&nbsp;<a href="../admin_collectnews.asp">返回项目列表</a></th></tr>
	</thead>
</table>
<%
	DoCollect f,2:echo "<script>setTimeout(function (){location='?action="&action&"&filename="&filename&"&itemname="&itemname&"&index="&index&"'},Math.max("&gatherWaitTime&"*1000,250));</script>"
End Sub

Sub DoCollect(ByVal sfile,ByVal Mode)
	dim Path,cPath:Path=ENGINEDIR&ESCDIR:cPath=ENGINEDIR&ESCACHEDIR&sfile
	if not isExistFile(Path&sfile) then:alertMsg "规则不存在:\n"&Path&sfile,"":exit sub:end if
	if getForm("clear","both")="true" OR Mode=0 then
		'if isExistFile(cPath&".json") then:delFile cPath&".json":end if
		'if isExistFile(cPath&".tmp") then:delFile cPath&".tmp":end if
		if cacheStart=1 then:cacheObj.clearCache("json://"&Path&sfile):end if
	end if
	SET gES=ParseJson(loadFileOnCache("json://",Path&sfile)):SET GP=GatHerProcess(sfile,Mode):SET TK1=GP.CreateTask():SET TK2=GP.CreateTask()
	GP.charset=gES("charset")
	GP.onprogress="GProgress([arguments])"
	GP.oncomplete="GComplete([arguments])"
	TK1.onerror="TKError([arguments])"
	TK1.onsuccess="TK1Success([arguments])"
	TK2.onerror="TKError([arguments])"
	TK2.onsuccess="TK2Success([arguments])"
	GP.init="GInit([arguments])"
	SET TK2=nothing:SET TK1=nothing:SET GP=nothing
End Sub

Function s2time(s)
	dim h,n
	if s=0 then
		s2time="00:00:00"
	else
		h = Clng(s / 3600)
		n = Clng((s MOD 3600) / 60)
		s = Clng(s MOD 3600 MOD 60)
		h=right("00"&h,2)
		n=right("00"&n,2)
		s=right("00"&s,2)
		s2time=h&":"&n&":"&s
	end if
End Function

Sub TKError(n,des,url)
	echo n&","&des&","&url
End Sub

Function getCurId
	dim ids,i:ids = split(filename,",")
	index=Cint(ifthen(isNum(index),index,0))
	if index<=UBound(ids) then
		i=ids(index)
		if right(i,4)=".txt" then
			getCurId=i:exit function
		end if
	end if
	getCurId=-1
End Function

Sub InitTask()
	SELECT Case gES("pageset")
		Case 0:TK1.Add(gES("pageurl0")):GP.Count=TK1.Count
		Case 1:TK1.Add(stepBatchUrl(gES("pageurl1"),"{$ID}",gES("istart"), gES("iend"),10,GP.iPage, gES("reverse"))):GP.iPage=GP.iPage+1:GP.Count=gES("iend")-gES("istart")+1
		Case 2:TK1.Add(Split(gES("pageurl2"),vbcrlf)):GP.Count=TK1.Count
		Case 3:TK2.Add(stepBatchUrl(gES("pageurl1"),"{$ID}",gES("istart"), gES("iend"),20,GP.iPage, gES("reverse"))):GP.iPage=GP.iPage+1:GP.Count=gES("iend")-gES("istart")+1
	End SELECT
End Sub

Sub GInit(G)
	if gEs("picmode") = 1 then
		FreeMappingFile(G.ID)
	end if
	G.startTime=now():InitTask
End Sub

Sub GProgress(a,b,c)
	on error resume next
	dim x,y,z,s,bt,et,bb,d:d=gES("pageset")
	if isDate(GP.startTime) = false then
		GP.startTime=Now()
	end if
	x	= GP.count:x=ifthen(x=0,1,x)
	y	= x - TK1.Count + (GP.itemsize - TK2.count) / GP.itemsize
	z	= Round(y * GP.itemsize / (y / x)) + a
	s	= DateDiff("s", GP.startTime, now())
	bt = s2time(s)
	et = s2time(Clng(Clng(s / b) * (z - b)))
	bb	= Round(b / z * 100)
	echo("<hr style=""border:1px solid #DEEFFA"" /><table><tr><td width=250>项目: <font color='red'>"&gES("itemname")&"</font></td><td>地址: <a href=""javascript:void(0);"" onclick=""window.open('"&c&"','_blank');""><font color='red'>"& c &"</font></a></td></tr></table><table><tr><td width=35>进度:</td><td width=230><table width=150 border=0 cellpadding=0 cellspacing=0 style='float:left'><tr><td bgcolor=#0000FF height=12 align=right width='"&bb&"%'></td><td bgcolor=red width='"&(100-bb)&"%'></td></tr></table> "&bb&"%</td><td width=120>统计：<font color=red>"&b&"/" &z& "</font></td><td width=100>待采列表 <font color=red>"&TK1.count&"</font></td><td width=120>待采影片 <font color=red>"&TK2.count&"</font></td><td width=150>剩余时间 <font color=red>" & et & "</font></td><td width=150>已用时间 <font color=red>" & bt & "</font></td></tr></table><hr style=""border:1px solid #DEEFFA"" />")
	if d=1 OR d=3 then
		if TK2.count=0 then InitTask
	end if
End Sub

Sub GComplete()
	index=Clng(index+1)
	if getCurId=-1 then
		GP.ExitRun("采集完成")
	end if
	if gEs("picmode") = 1 then
		FreeMappingFile(GP.ID)
	end if
	if GP.mode<>0 then echo "<script>setTimeout(function (){location='?action="&action&"&filename="&filename&"&index="&index&"&clear=true'},Math.max("&gatherWaitTime&"*1000,250));</script>"
End Sub

Function ProImage(ByVal txt)
	Dim z,i,l,x,y,a,b:a=gEs("picA"):b=gEs("picB"):y=gEs("picvar"):z=StrSplits(txt, ReplaceStr(a,"[变量]",""), ReplaceStr(b,"[变量]",""))
	if y<>"" then
		l=UBound(z):for i=0 to l
			x = z(i)
			if x<>"" then
				if jsIndexOf(a,"[变量]") <> -1 then
					x = y & x
				end if
				if jsIndexOf(b,"[变量]") <> -1 then
					x = x & y
				end if
			end if
			z(i)=x
		next
	end if
	ProImage=z
End Function

Sub TK1Success(ByVal txt,ByVal url)
	Dim x,y,z,m,p,i,l,zl:x=StrSliceB(txt, gES("listA"), gES("listB"))
	z	= StrSplits(x, gES("mlinkA"), gES("mlinkB"))
	if gES("isspecial")=true then
		z	= SpecialLinks(z, gES("mlinkRF"), gES("mlinkRR"))
	end if
	z	= paseAbsURI(z, url)
	z	= array_unique(z):zl=Ubound(z)
	if gEs("picmode") = 1 AND gEs.Exists("picA")<>"" then
		SET m=CreateMappingFile(GP.ID)
		p	= ProImage(x)
		p	= paseAbsURI(p, url):l=Ubound(p)
		l	= ifthen(l<zl,l,zl)
		for i=0 to l
			m(z(i))=p(i)
		next
		SET m=Nothing
	end if
	y	= zl + 1
	GP.itemsize	= y
	echo("<pre>")
	echo("添加待采集文章：("& y &"篇)"& vbcrlf)
	echo(Join(z,vbcrlf))
	echo("</pre>")
	if gEs("reverse")=true then
		z	= array_reverse(z)
	end if
	TK2.add(z)
End Sub

Sub TK2Success(ByVal txt,ByVal url)
	Dim x,y,z,t,tt,m,txt2,txt3,i:SET x = Object()
	x("来自")	= url
	x("来源")	= gEs("playfrom")
	t=StrSlice(txt, gEs("nameA"), gEs("nameB")):t=filterWord(t, 0):t=RemoveHTMLCode(t,"*")
	x("标题")	= trim(t)
	if gEs.Exists("picB")<>"" then
		t=""
		if gEs("picmode")=1 then
			SET m = CreateMappingFile(GP.ID)
			t = m(url)
			m.remove(url)
			SET m=Nothing
		else
			tt		= ProImage(txt)
			tt		= paseAbsURI(tt,url)
			t		= Pop(tt)
		end if
		x("图片")		= RemoveHTMLCode(t,"*")
	end if
	y=gES("desA"):z=gES("desB")
	if gES.Exists("desB") then
		txt3= RemoveHTMLCode(filterWord(StrSlice(txt, y, z), 1), gES("removecode"))
	else
		txt3=""
	end if
	if gEs("splay")=true then
		txt2 = StrSlice(txt, gEs("plistA"), gEs("plistB"))
		tt = StrSplits(txt2, gEs("plinkA"), gEs("plinkB"))
		if gEs("isspecial") = true then
			tt = SpecialLinks(tt, gEs("linkRF"), gEs("linkRR"))
		end if
		tt = array_unique(paseAbsURI(tt, url)):t	= Ubound(tt)
		if t>-1 then
			echo("正在截取<font color=red>"& (t+1) &"</font>页面上的文章内容，可能要花上1分钟。请稍候...<br />")
			for i=0 to t
				txt3 = txt3 &"#p#第"&(i+2)&"页#e#"& RemoveHTMLCode(filterWord(StrSlice(GetHttpTextFile(tt(i),gEs("charset")), y, z), 1), gES("removecode"))
			next
		end if
	end if
	x("正文")=txt3
	txt2	= "<pre>来源地址: " & url & vbcrlf
	if x("标题")<>"" AND txt3<>"" then
		if gEs("autocls")=false then
			t	= gEs("classid")
			x("分类ID") = t
			x("分类名")	= NewsClassID2Name(t)
		else
			if gES.Exists("clsA") then
				t	= RemoveHTMLCode(StrSlice(txt, gES("clsA"), gES("clsB")),"*")
				x("分类名") = t
			end if
			x("分类ID")	= newssmartGeneralize(t,x("标题"))
		end if
		if gES.Exists("dateA") then
			t=RemoveHTMLCode(StrSlice(txt, gES("dateA"), gES("dateB")),"*")
			if isDate(t) then
				x("日期")=t
			else
				x("日期")=now()
			end if
		else
			x("日期") = now()
		end if
		if gES.Exists("authorA") then
			x("作者")	= RegReplace(RemoveHTMLCode(StrSlice(txt, gES("authorA"), gES("authorB")),"*"),"/(\s+)|[\|\/]/g"," ")
		end if
		if gES.Exists("keysA") then
			x("关键字")	= RegReplace(RemoveHTMLCode(StrSlice(txt, gES("keysA"), gES("keysB")),"*"),"/(\s+)|[\|\/]/g"," ")
		end if
		if gES.Exists("outlineA") then
			x("简述")	= RegReplace(RemoveHTMLCode(StrSlice(txt, gES("outlineA"), gES("outlineB")),"*"),"/(\s+)|[\|\/]/g"," ")
		end if
		if gES.Exists("fromA") then
			x("来源")	= RegReplace(RemoveHTMLCode(StrSlice(txt, gES("fromA"), gES("fromB")),"*"),"/(\s+)|[\|\/]/g"," ")
		end if
		newsStorage x, 0, GP.mode
		txt2 = txt2 & "标  题: " & x("标题") & vbcrlf
		txt2 = txt2 & "分  类: " & x("分类名") & vbcrlf
		txt2 = txt2 & "来  源: " & x("来源") & vbcrlf
		txt2 = txt2 & "作  者: " & x("作者") & vbcrlf
		txt2 = txt2 & "日  期: " & x("日期") & vbcrlf
		txt2 = txt2 & "图  片: " & x("图片") & vbcrlf
		txt2 = txt2 & "关键词: " & x("关键字") & vbcrlf
		txt2 = txt2 & "简  述: " & Server.HTMLEncode(x("简述")) & vbcrlf
		txt2 = txt2 & "正  文: " & Server.HTMLEncode(x("正文")) & vbcrlf
	else
		txt2 = txt2 & "忽略无效文章: " & x("标题") & " 原因: " & ifthen(trimall(x("标题"))="","没有标题","没有文章正文")
	end if
	echo(txt2 & "</pre>")
End Sub

SET gES=nothing
%>