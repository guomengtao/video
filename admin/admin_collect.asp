<!-- #include file="admin_inc.asp" -->
<!-- #include file="collect/engine.cls.asp" -->
<!--#include file="../inc/pinyin.asp"-->
<!--#include file="FCKeditor/fckeditor.asp" -->
<%
'******************************************************************************************
' Software name: Max(马克斯) Collect Engine
' Version:4.0
' Web: http://maxcms.bokecc.com
' Author: 石头(maxcms2008@qq.com),yuet,长明
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************

Const ENGINEDIR="collect/":Const ESCDIR = "items/video/":Const ESCACHEDIR = "cache/video/":Server.scripttimeout=600
Const gatherWaitTime=0.5 '采集每页数据间隔时间
Dim action:action=UCASE(GetForm("action", "get"))
Dim playerArray,downArray:playerArray = getPlayerKinds("../inc/playerKinds.xml")
Dim Page,gES,GP,TK1,TK2:gES=null
Dim filename,index:filename=replaceStr(getForm("filename","both")," ",""):index=getForm("index","both")

checkPower

Select Case action
	Case "ITEMS":
	Case "WIZARD","EDIT":Header:WIZARD:Footer
	Case "WIZARD2SAVE":WIZARD2SAVE
	Case "GHOST":GHOST
	Case "REMOVE":REMOVEESFILE
	Case "TEMPDATABASE":Header:tempdatabase:Footer
	Case "EDITVIDEO":Header:editVideo:popDiv:Footer
	Case "SAVEVIDEO":saveVideo
	Case "IMPORT":Header:import:Footer
	Case "IMPORTTXT":Header:importtxt:Footer
	Case "EXPORTTXT":Header:exporttxt:Footer
	Case "KILL":Header:killJapanSubmit:Footer
	Case "DELALLTEMPDATA":delallTempData
	Case "DELTEMPDATA":delTempData
	Case "CUSTOMERCLS":Header:customercls:Footer
	Case "CUSTOMERNEWCLS":customernewcls
	Case "CUSTOMERSAVECLS":customersavecls
	Case "CUSTOMERDELCLS":customerdelcls
	Case "CUSTOMERDELALLCLS":customerdelallcls
	Case "FILTERS":Header:filtersDictionary:Footer
	Case "FILTERSADD","FILTERSEDIT":Header:EditOrAdd:Footer
	Case "SAVEEDITORADD":SaveEditOrAdd
	Case "FILTERSBAN":filtersban
	Case "FILTERSDEL":filtersdel
	Case "FILTERSDELALL":filtersdelall
	Case "PROXY":Proxy
	Case "TEST_HTTP_REFERER":die ifthen(TEST_HTTP_REFERER=true,"恭喜你，您的主机支持破解防盗链","很抱歉，你的主机不支持破解防盗链")
	Case "COMPRESS":compress
	Case "EXEC","DEMO":Demo
	Case else:Header:ITEMLIST:Footer
End Select

Sub Demo
Dim ids,i:ids = split(ReplaceStr(filename," ",""),",")
	if isArray(ids) then
		For i=0 to UBound(ids)
			ids(i)=ParseJsonFile(ENGINEDIR&ESCDIR&ids(i))("itemname")
		Next
		ids=join(ids,",")
	else
		ids=filename
	end if
	alertMsg "","collect/do.asp?"&request.querystring&"&itemname="&ids
End Sub

Function getTimeFileName(ByVal ext)
		Dim t,Y,M,D,H,N,S:t=now():Y=Year(t):M=Month(t):D=Day(t):H=Hour(t):N=Minute(t):S=Second(t):getTimeFileName=Y&Right("00"&M,2)&Right("00"&D,2)&Right("00"&H,2)&Right("00"&N,2)&Right("00"&S,2)&ext
End Function

Sub Proxy()
	Dim txt
	on Error Resume next
	txt = GetHttpTextFile(GetForm("url", "get"),GetForm("charset", "get"))
	if Err.number>0 then
		echo "err"
	else
		echo IfThen(GetForm("result", "get")="false", "OK", txt)
	end if
End Sub

Sub importtxt()
	Dim base64,x:base64=getForm("base64","both")
	if getForm("do","both")="save" then
		x=base64Decode(StrSliceB(base64,"BASE64:",":END"))
		if LCase(typename(ParseJson(x)))<>"dictionary" then
			alertMsg "无法识别的采集规则",""
		else
			Dim referer:filename=getTimeFileName(".txt"):referer=getForm("referer","both")
			CreateTextFile x,ENGINEDIR&ESCDIR&filename,"gb2312"
			die "<script type=""text/javascript"">if(confirm('保存成功，是否自动跳转到预览界面?\n\n点[确定]跳转预览界面，[取消]返回项目列表')){self.location.href='?action=demo&filename="&filename&"&result="&Server.URLEncode(referer)&"';}else{self.location.href='?ChildDir="&StrSliceB(filename,"","/")&"';}</script>"
		end if
	end if
%>
<form name="wizardform" id="wizardform" method="post" action="?action=importtxt&do=save" enctype="application/x-www-form-urlencoded">
<input type="hidden" name="referer" value="<%=request.ServerVariables("HTTP_REFERER")%>" />
<table class="tb">
	<thead>
		<tr class="thead"><th>&nbsp;导入采集脚本： <a href="?childdir=<%=StrSliceB(filename,"","/")%>">管理采集规则</a> | <a href="?action=wizard">添加采集规则</a> | <a href="?action=importtxt">导入采集规则</a> | 支持破解防盗链：<span class="red"><a href="?action=TEST_HTTP_REFERER" target="_blank">测试</a></span></th></tr>
	</thead>
	<tbody>
		<tr>
			<td><textarea name="base64" cols="100" rows="20" style="height:400px;font-family:Fixedsys"><%=base64%></textarea></td>
		</tr>
		<tr>
			<td><input type="submit" class="btn" value="保  存"/>&nbsp;&nbsp;<input type="button" class="btn" name="back" value="管理采集规则" onclick="location.href='?childdir=';" /></td>
		</tr>
	</tbody>
</table>
</form>
<%
End Sub

Sub exporttxt()
Dim txt:txt="BASE64:"&base64Encode(LoadFile(ENGINEDIR&ESCDIR&filename))&":END"
%>
<table class="tb">
	<thead>
		<tr class="thead"><th>&nbsp;导出采集脚本： <a href="?childdir=<%=StrSliceB(filename,"","/")%>">管理采集规则</a> | <a href="?action=wizard">添加采集规则</a> | <a href="?action=importtxt">导入采集规则</a> | 支持破解防盗链：<span class="red"><a href="?action=TEST_HTTP_REFERER" target="_blank">测试</a></span></th></tr>
	</thead>
	<tbody>
		<tr>
			<td><textarea cols="100" rows="20" style="height:400px;font-family:Fixedsys" readonly><%=txt%></textarea></td>
		</tr>
	</tbody>
</table>
<%
End Sub

Sub Header%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<!--2010-06-17 12:36-->
<title>MaxCMS智能采集工具</title>
<link href="imgs/admin.css" rel="stylesheet" type="text/css" />
<script src="../js/common.js" type="text/javascript"></script>
<script src="imgs/main.js" type="text/javascript"></script>
<script>if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;视频采集工具';</script>
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
<div align=center>Copyright 2014 All rights reserved. <a target="_blank" href="http://www.maxcms.co/">Maxcms.Co</a></div>
<div style="display:none"><script language="javascript" src="http://maxcms.bokecc.com/update/max4.0/maxcms_tool.js"></script></div>
</body>
<iframe frameborder="0" scrolling="no" height="0" width="0" name="hiddensubmit" id="hiddensubmit" src="about:blank"></iframe>
</html>
<%
End Sub

Sub WIZARD2SAVE
	'response.AddHeader "Content-Type","text/plain"
	Dim MOL,txt:SET MOL=Object()
	Dim bHas:bHas = Array("autocls","reverse","isspecialmlink","splay","isspecial","getpart")
	Dim iHas:iHas = Array("into","pageset","classid","istart","iend","picmode","playgetsrc","getherday")
	Dim rCrlf:rCrlf = Array("pageurl2","listA","listB","mlinkA","mlinkB","mlinkRF","mlinkRR","nameA","nameB","picvar","plistA","plistB","playlinkA","playlinkB","linkRF","linkRR","msrcA","msrcB","partA","partB")
	Dim tHas:tHas = Array("itemname","siteurl","charset","playfrom","pageurl0","pageurl1")
	Dim i,t:t=split(trimall(request.Form("fields")),",")
	For i=0 to UBound(t):Push rCrlf,t(i)&"A":Push rCrlf,t(i)&"B":Next
	For i=0 to UBound(bHas):MOL(bHas(i))=ifthen(request.Form(bHas(i))="1",true,false):Next
	For i=0 to UBound(iHas):MOL(iHas(i))=Str2Num(request.Form(iHas(i))):Next
	For i=0 to UBound(rCrlf):MOL(rCrlf(i))=DeCrlf(request.Form(rCrlf(i))):Next
	For i=0 to UBound(tHas):MOL(tHas(i))=trim(request.Form(tHas(i))):Next
	MOL("pageurl2")=DeCrlf(trim(request.Form("pageurl2")))
	MOL("removecode")=replace(trimAll(request.Form("removecode")),",","|"):txt=Json.var2json(MOL):SET MOL=Nothing

	Dim Path,cPath,filename,referer:filename=getForm("filename","post"):Path=ENGINEDIR&ESCDIR:referer=getForm("referer","post")
	if not isExistFile(Path&filename) then
		filename=getTimeFileName(".txt")
	end if
	cPath=ENGINEDIR&ESCACHEDIR&filename
	if isExistFile(cPath&".json") then:delFile cPath&".json":end if
	if isExistFile(cPath&".tmp") then:delFile cPath&".tmp":end if
	if cacheStart=1 then:cacheObj.clearCache("json://"&ESCDIR&filename):end if
	CreateTextFile txt,Path&filename,"gb2312"
	die "<script type=""text/javascript"">if(confirm('保存成功，是否自动跳转到预览界面?\n\n点[确定]跳转预览界面，[取消]返回项目列表')){self.location.href='?action=demo&filename="&filename&"&result="&Server.URLEncode(referer)&"';}else{self.location.href='?ChildDir="&StrSliceB(filename,"","/")&"';}</script>"
End Sub

Sub WIZARD
Dim t,a,i,isEdit,Path,filename:Path=ENGINEDIR&ESCDIR:filename=getForm("filename","get"):isEdit=action="EDIT"
Dim enable,autocls,pageset,picmode,getherday:getherday=0

if isEdit then
	if NOT isExistFile(Path&filename) then alertMsg "找不到采集规则文件："&ESCDIR&filename,"" : echo "<script>self.location.href='?';</script>":exit Sub
	SET gES=ParseJsonFile(ENGINEDIR&ESCDIR&filename)
	autocls=gES("autocls"):getherday=Str2Num(gES("getherday")):pageset=gES("pageset"):picmode=Str2Num(gES("picmode"))
else
	SET gEs=Object()
end if
%>
<table class="tb">
	<thead>
		<tr class="thead"><th>&nbsp;操作选项： <a href="?childdir=<%=StrSliceB(filename,"","/")%>">管理采集规则</a> | <a href="?action=wizard">添加采集规则</a> | <a href="?action=importtxt">导入采集规则</a> | 支持破解防盗链：<span class="red"><a href="?action=TEST_HTTP_REFERER" target="_blank">测试</a></span></th></tr>
	</thead>
	<tbody>
		<tr>
			<td><%=ifthen(filename="","1. 通过本向导将传统的采集规则转换成采集规则文件","1.修改采集规则文件：<span class=""red"">"&filename&"</span>")%></td>
		</tr>
	</tbody>
</table>

<table class="tb2">
	<thead>
		<tr>
			<th colspan="2" height="20"><span id="showurl"></span></th>
		</tr>
		<tr id="htmltable" style="display:none">
			<th colspan="2"><textarea id="htmlcode" style="width:99%;height:200px;font-family:Fixedsys" wrap="off" readonly></textarea></th>
		</tr>
		<tr>
			<th colspan="2" class="thc">使用采集规则向导生成采集规则文件</th>
		</tr>
		<tr>
			<th colspan="2" class="thr"><font id="stephit1" color="red">１. 设置基本参数</font>&nbsp;&nbsp;<font id="stephit2">２. 采集列表连接设置</font>&nbsp;&nbsp;<font id="stephit3">３. 采集内容与数据地址设置</font>&nbsp;&nbsp;<font id="stephit4">４. 在线模拟预览结果</font>&nbsp;&nbsp;<font id="stephit5">５. 完成向导并真实演示</font></th>
		</tr>
	</thead>
</table>
<form name="wizardform" id="wizardform" method="post" action="?action=WIZARD2SAVE" enctype="application/x-www-form-urlencoded">
<input type="hidden" name="referer" value="<%=request.ServerVariables("HTTP_REFERER")%>" />
<%
if isEdit=true then
	echo "<input type=""hidden"" name=""filename"" value="""&filename&""" />"
end if
%>
<table class="tb2" id="step1" style="display:.none">
	<tbody>
		<tr>
			<td class="label">站点名称：</td>
			<td><input type="text" class="txt" name="itemname" value="<%=gES("itemname")%>" /></td>
		</tr>
<%t=Str2Num(gES("into"))%>
		<tr style="display:none">
			<td class="label">入库方式：</td>
			<td><input type="radio" class="radio" name="into" value="0" <%=ifthen(t=0,"checked","")%> /><span class="red">临时库</span> <input type="radio" class="radio" name="into" value="1" <%=ifthen(t=0,"","checked")%>/>直接入库(不建议使用，会损成数据库很大 或 损坏)</td>
		</tr>
		<tr style="display:none">
			<td class="label">只采集最近：</td>
			<td><select name="getherday" onchange="if(this.value=='0'){hide('datebody')}else{show('datebody')}"><option value="0">不限</option><%for i=1 to 31:echo "<option value="""&i&""""&ifthen(getherday=i," selected","")&">"&i&"</option>":next%></select> 天 * 选择天数还要填写第3步的 <span class="red">数据日期 开始 和 结束</span>才有效</td>
		</tr>
		<tr>
			<td class="label">目标站点网址：</td>
			<td><input type="text" class="txt" name="siteurl" value="<%=gES("siteurl")%>" /></td>
		</tr>
		<tr>
			<td class="label">网页编码：</td>
			<td><input type="text" name="charset" value="<%=gES("charset")%>" style="width: 85px" />&nbsp;&nbsp;<font color="#0000FF">请选择编码→</font><select onchange="this.form.charset.value=this.value"><option value="">请选择编码</option><option value="GB2312">GB2312</option><option value="GBK">GBK</option><option value="BIG5">BIG5</option><option value="UTF-8">UTF-8</option></select></td>
		</tr>
		<tr>
			<td class="label">播放来源：</td>
			<td><select name='playfrom'><option value=''>暂没有数据</option><%=makePlayerSelect(gES("playfrom"))%></select></td>
		</tr>
		<tr>
			<td class="label red">数据分类设置：</td>
			<td><input type="radio" class="radio" name="autocls" value="0" onclick="hide('autoclsbody');show('selcls');" <%=ifthen(autocls=true,"","checked")%>/>固定分类<input type="radio" class="radio" name="autocls" value="1" onclick="hide('selcls');show('autoclsbody');"<%=ifthen(autocls=true,"checked","")%>/>智能归类</td>
		</tr>
		<tr id="selcls" style="<%=ifthen(autocls=true,"display:none","")%>">
			<td class="label">所属分类：</td>
			<td><select name="classid"><option value="">请选择数据分类</option><% makeTypeOptionSelected 0,"&nbsp;|&nbsp;&nbsp;",gES("classid") %></select></td>
		</tr>
		<tr>
			<td class="label">分页设置：</td>
			<td>
			<input type="radio" class="radio" name="pageset" value="0" onclick="hide('page_0','page_1','page_2');show('page_0');"<%=ifthen(pageset=0,"checked","")%>/>不分页
			<input type="radio" class="radio" name="pageset" value="1" onclick="hide('page_0','page_1','page_2');show('page_1');"<%=ifthen(pageset=1,"checked","")%>/>批量分页
			<input type="radio" class="radio" name="pageset" value="2" onclick="hide('page_0','page_1','page_2');show('page_2');"<%=ifthen(pageset=2,"checked","")%>/>手动分页
			<input type="radio" class="radio" name="pageset" value="3" onclick="hide('page_0','page_1','page_2');show('page_1');"<%=ifthen(pageset=3,"checked","")%>/>直接采集内容页
			</td>
		</tr>
		<tr id="page_0" style="<%=ifthen(pageset=0,"","display:none")%>">
			<td class="label">采集网址：</td>
			<td><input type="text" class="txt" name="pageurl0" value="<%=gES("pageurl0")%>" /></td>
		</tr>
		</tbody>
		<tbody id="page_1" style="<%=ifthen(pageset=1 OR pageset=3,"","display:none")%>">
		<tr>
			<td class="label">批量生成采集网址：</td>
			<td><input type="text" class="txt" name="pageurl1" value="<%=gES("pageurl1")%>" />&nbsp;ID变量<font color="red">{$ID}</font></td>
		</tr>
		<tr>
			<td class="label">起始ID：</td>
			<td>标准格式：Http://www.damin.com/list/list_{$ID}.html<br />开始：<input type="text" name="istart" value="<%t=Str2Num(gES("istart")):echo ifthen(t<1,1,t)%>" style="width: 60px"/> - 结束：<input type="text" name="iend" value="<%t=Str2Num(gES("iend")):echo ifthen(t<1,1,t)%>" style="width: 60px" />&nbsp;例如：1 - 10 或者 10 - 1</td>
		</tr>
		</tbody>
		<tbody id="page_2" style="<%=ifthen(pageset=2,"","display:none")%>">
		<tr>
			<td class="label">手动分页：</td>
			<td><textarea name="pageurl2" rows="6" cols="80"><%=HTMLEncode(gESCrlf("pageurl2"))%></textarea></td>
		</tr>
		</tbody>
		<tbody>
		<tr>
			<td class="label">采集方式：</td>
			<td><input type="checkbox" class="checkbox" name="reverse" value="1"<%=ifthen(gES("reverse")=true,"checked","")%>/>倒序采集</td>
		</tr>
		<tr>
			<td class="label">内容过滤设置：</td>
			<td>
			<%
				a=split("IFRAME|OBJECT|BUTTON|CLASS|HTML|SPAN|DIV|P|SCRIPT|APPLET|STRONG|STYLE|TABLE|FONT|IMG|A","|")
				t="|"&ifthen(isEdit=true,trimAll(gES("removecode")),"IFRAME|OBJECT|BUTTON|CLASS|DIV|SCRIPT|APPLET|STRONG|STYLE|TABLE|A")&"|"
				for i=0 to UBound(a)
					echo "<input type=""checkbox"" class=""checkbox"" name=""removecode"" value="""&a(i)&""""&ifthen(jsIndexOf(t,"|"&a(i)&"|")<>-1,"checked","")&"/>"&a(i)
					if a(i)="P" then echo "<br>"
				next
			%>
			</td>
		</tr>
		</tbody>
	</tbody>
</table>
<table class="tb2" id="step2" style="display:none">
	<tbody>
		<tr>
			<td class="label">列表开始：</td>
			<td><textarea name="listA" rows="6" cols="80"><%=HTMLEncode(gESCrlf("listA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">列表结束：</td>
			<td><textarea name="listB" rows="6" cols="80"><%=HTMLEncode(gESCrlf("listB"))%></textarea></td>
		</tr>
		<tbody>
		<tr>
			<td class="label red">获取数据图片方式：</td>
			<td><input type="radio" class="radio" name="picmode" value="1" onclick="show('picbody');$('step2').insertBefore($('picbody'),parentNode.parentNode.parentNode.nextSibling);$('piccheckbox').checked=true;"<%=ifthen(picmode=1,"checked","")%>/>在列表页<input type="radio" class="radio" name="picmode" value="0" onclick="$('step3').insertBefore($('picbody'),$('desbody'));"<%=ifthen(picmode=1,"","checked")%>/>在内容页</td>
		</tr>
		</tbody>
<%if picmode=1 then%>
		<tbody id="picbody">
			<tr>
				<td class="label">图片开始：</td>
				<td><textarea name="picA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("picA"))%></textarea></td>
			</tr>
			<tr>
				<td class="label">图片结束：</td>
				<td><textarea name="picB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("picB"))%></textarea></td>
			</tr>
			<tr>
				<td class="label">图片替换变量：</td>
				<td><input type="radio" class="radio" name="0" value="0" onclick="hide('picvardc');"<%=ifthen(t=true,"","checked")%>/>不作设置<input type="radio" class="radio" name="0" value="1" onclick="show('picvardc')"<%=ifthen(t=true,"checked","")%>/>替换变量</td>
			</tr>
			<tr id="picvardc" style="<%=ifthen(gES("picvar")="","display:none","")%>">
				<td class="label">替换变量：<p class="red">图片开始加 [变量]<br />图片结束 [变量]</p></td>
				<td><textarea name="picvar" rows="4" cols="80"><%=HTMLEncode(gESCrlf("picvar"))%></textarea></td>
			</tr>
		</tbody>
<%end if%>
		<tbody>
		<tr>
			<td class="label">链接开始：</td>
			<td><textarea name="mlinkA" rows="6" cols="80"><%=HTMLEncode(gESCrlf("mlinkA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">链接结束：</td>
			<td><textarea name="mlinkB" rows="6" cols="80"><%=HTMLEncode(gESCrlf("mlinkB"))%></textarea></td>
		</tr>
<%t=gES("isspecialmlink")%>
		<tr>
			<td class="label red">特殊链接处理：</td>
			<td><input type="radio" class="radio" name="isspecialmlink" value="0" onclick="hide('specialmlinkbody');"<%=ifthen(t=true,"","checked")%>/>不作设置<input type="radio" class="radio" name="isspecialmlink" value="1" onclick="show('specialmlinkbody')"<%=ifthen(t=true,"checked","")%>/>替换地址<br>对于使用了JavaScript跳转形式的连接请使用此功能</td>
		</tr>
	</tbody>
	<tbody id="specialmlinkbody" style="<%=ifthen(t=true,"","display:none")%>">
		<tr>
			<td class="label">要替换的地址：</td>
			<td><p class="red">要替换的连接:/channel/[变量]/[变量].html</p><textarea name="mlinkRF" rows="4" cols="80"><%=HTMLEncode(gESCrlf("mlinkRF"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">替换为的地址：</td>
			<td><p class="red">实际连接:/list/?$1-$2.html ($1至$99对应[变量]的出现位置)<br>/list/?[变量]-[变量].html中的[变量]等同$1</p><textarea name="mlinkRR" rows="4" cols="80"><%=HTMLEncode(gESCrlf("mlinkRR"))%></textarea></td>
		</tr>
	</tbody>
</table>
<table class="tb2" id="step3" style="display:none">
	<tbody>
		<tr>
			<td class="label">可选采集字段</td>
			<td>
				<input type="checkbox" class="checkbox" name="fields" id="piccheckbox" value="pic" onclick="if(this.checked){show('picbody')}else{hide('picbody')}"<%=ifthen(gES("picA")&gES("picB")<>""," checked","")%>/><label for="piccheckbox">图片</label>
				<input type="checkbox" class="checkbox" name="fields" id="cls" value="cls" onclick="if(this.checked){show('autoclsbody')}else{hide('autoclsbody')}"<%=ifthen(autocls=true OR gES("clsA")&gES("clsB")<>""," checked","")%>/><label for="cls">分类</label>
				<input type="checkbox" class="checkbox" name="fields" id="actor" value="actor" onclick="if(this.checked){show('actorbody')}else{hide('actorbody')}"<%=ifthen(gES("actorA")&gES("actorB")<>""," checked","")%>/><label for="actor">演员</label>
				<input type="checkbox" class="checkbox" name="fields" id="director" value="director" onclick="if(this.checked){show('directorbody')}else{hide('directorbody')}"<%=ifthen(gES("directorA")&gES("directorB")<>""," checked","")%>/><label for="director">导演</label>
				<input type="checkbox" class="checkbox" name="fields" id="state" value="state" onclick="if(this.checked){show('statebody')}else{hide('statebody')}"<%=ifthen(gES("stateA")&gES("stateB")<>""," checked","")%>/><label for="state">连载</label>
				<input type="checkbox" class="checkbox" name="fields" id="note" value="note" onclick="if(this.checked){show('notebody')}else{hide('notebody')}"<%=ifthen(gES("noteA")&gES("noteB")<>""," checked","")%>/><label for="note">备注</label>
				<input type="checkbox" class="checkbox" name="fields" id="keys" value="keys" onclick="if(this.checked){show('keysbody')}else{hide('keysbody')}"<%=ifthen(gES("keysA")&gES("keysB")<>""," checked","")%>/><label for="keys">关键词</label>
				<input type="checkbox" class="checkbox" name="fields" id="year" value="year" onclick="if(this.checked){show('yearbody')}else{hide('yearbody')}"<%=ifthen(gES("yearA")&gES("yearB")<>""," checked","")%>/><label for="year">年份</label>
				<input type="checkbox" class="checkbox" name="fields" id="lang" value="lang" onclick="if(this.checked){show('langbody')}else{hide('langbody')}"<%=ifthen(gES("langA")&gES("langB")<>""," checked","")%>/><label for="lang">语言</label>
				<input type="checkbox" class="checkbox" name="fields" id="area" value="area" onclick="if(this.checked){show('areabody')}else{hide('areabody')}"<%=ifthen(gES("areaA")&gES("areaB")<>""," checked","")%>/><label for="area">地区</label>
				<input type="checkbox" class="checkbox" name="fields" id="des" value="des" onclick="if(this.checked){show('desbody')}else{hide('desbody')}"<%=ifthen(gES("desA")&gES("desB")<>""," checked","")%>/><label for="des">介绍</label>
				<input type="checkbox" class="checkbox" name="fields" id="date" value="date" onclick="if(this.checked){show('datebody')}else{hide('datebody')}"<%=ifthen(getherday>0 OR gES("dateA")&gES("dateB")<>""," checked","")%>/><label for="date">改变日期</label>
			</td>
		</tr>
	</tbody>
	<tbody id="namebody">
		<tr>
			<td class="label red">名称开始：</td>
			<td><textarea name="nameA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("nameA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">名称结束：</td>
			<td><textarea name="nameB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("nameB"))%></textarea></td>
		</tr>
	</tbody>
<%if picmode<>1 then%>
	<tbody id="picbody" style="<%=ifthen(gES("picA")&gES("picB")="","display:none","")%>">
		<tr>
			<td class="label">图片开始：</td>
			<td><textarea name="picA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("picA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">图片结束：</td>
			<td><textarea name="picB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("picB"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">图片替换变量：</td>
			<td><input type="radio" class="radio" name="0" value="0" onclick="hide('picvardc');"<%=ifthen(t=true,"","checked")%>/>不作设置<input type="radio" class="radio" name="0" value="1" onclick="show('picvardc')"<%=ifthen(t=true,"checked","")%>/>替换变量</td>
		</tr>
		<tr id="picvardc" style="<%=ifthen(gES("picvar")="","display:none","")%>">
			<td class="label">替换变量：<p class="red">图片开始加 [变量]<br />图片结束 [变量]</p></td>
			<td><textarea name="picvar" rows="4" cols="80"><%=HTMLEncode(gESCrlf("picvar"))%></textarea></td>
		</tr>
	</tbody>
<%end if%>
	<tbody id="autoclsbody" style="<%=ifthen(autocls=true OR gES("clsA")&gES("clsB")<>"","","display:none")%>">
		<tr>
			<td class="label">分类开始：</td>
			<td><textarea name="clsA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("clsA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">分类结束：</td>
			<td><textarea name="clsB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("clsB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody id="actorbody" style="<%=ifthen(gES("actorA")&gES("actorB")="","display:none","")%>">
		<tr>
			<td class="label">演员开始：</td>
			<td><textarea name="actorA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("actorA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">演员结束：</td>
			<td><textarea name="actorB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("actorB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody id="directorbody" style="<%=ifthen(gES("directorA")&gES("directorB")="","display:none","")%>">
		<tr>
			<td class="label">导演开始：</td>
			<td><textarea name="directorA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("directorA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">导演结束：</td>
			<td><textarea name="directorB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("directorB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody id="statebody" style="<%=ifthen(gES("stateA")&gES("stateB")="","display:none","")%>">
		<tr>
			<td class="label">连载开始：</td>
			<td><textarea name="stateA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("stateA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">连载结束：</td>
			<td><textarea name="stateB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("stateB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody id="notebody" style="<%=ifthen(gES("noteA")&gES("noteB")="","display:none","")%>">
		<tr>
			<td class="label">备注开始：</td>
			<td><textarea name="noteA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("noteA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">备注结束：</td>
			<td><textarea name="noteB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("noteB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody id="keysbody" style="<%=ifthen(gES("keysA")&gES("keysB")="","display:none","")%>">
		<tr>
			<td class="label">关键词开始：</td>
			<td><textarea name="keysA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("keysA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">关键词结束：</td>
			<td><textarea name="keysB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("keysB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody id="yearbody" style="<%=ifthen(gES("yearA")&gES("yearB")="","display:none","")%>">
		<tr>
			<td class="label">年份开始：</td>
			<td><textarea name="yearA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("yearA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">年份结束：</td>
			<td><textarea name="yearB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("yearB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody id="langbody" style="<%=ifthen(gES("langA")&gES("langB")="","display:none","")%>">
		<tr>
			<td class="label">语言开始：</td>
			<td><textarea name="langA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("langA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">语言结束：</td>
			<td><textarea name="langB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("langB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody id="areabody" style="<%=ifthen(gES("areaA")&gES("areaB")="","display:none","")%>">
		<tr>
			<td class="label">地区开始：</td>
			<td><textarea name="areaA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("areaA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">地区结束：</td>
			<td><textarea name="areaB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("areaB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody id="datebody" style="<%=ifthen(getherday>0 OR gES("dateA")&gES("dateB")<>"","","display:none")%>">
		<tr>
			<td class="label">日期开始：</td>
			<td><textarea name="dateA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("dateA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">日期结束：</td>
			<td><textarea name="dateB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("dateB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody id="desbody" style="<%=ifthen(gES("desA")&gES("desB")="","display:none","")%>">
		<tr>
			<td class="label">介绍开始：</td>
			<td><textarea name="desA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("desA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">介绍结束：</td>
			<td><textarea name="desB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("desB"))%></textarea></td>
		</tr>
	</tbody>
<%t=gES("splay")%>
	<tbody>
		<tr>
			<td class="label red">播放列表范围：</td>
			<td><input type="radio" class="radio" name="splay" value="0" onclick="hide('plistbody');"<%=ifthen(t=true,"","checked")%>/>关闭<input type="radio" class="radio" name="splay" value="1" onclick="show('plistbody')"<%=ifthen(t=true,"checked","")%>/>开启</td>
		</tr>
	</tbody>
	<tbody id="plistbody" style="<%=ifthen(t=true,"","display:none")%>">
		<tr>
			<td class="label">播放列表开始：</td>
			<td><textarea name="plistA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("plistA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">播放列表结束：</td>
			<td><textarea name="plistB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("plistB"))%></textarea></td>
		</tr>
	</tbody>
<%t=Str2Num(gES("playgetsrc"))%>
	<tbody>
		<tr>
			<td class="label red">获取数据地址方式：</td>
			<td><input type="radio" class="radio" name="playgetsrc" value="1" onclick="show('playlinkbody')"<%=ifthen(t=1,"checked","")%>/>播放页获取单个数据地址<input type="radio" class="radio" name="playgetsrc" value="2" onclick="show('playlinkbody')"<%=ifthen(t=2,"checked","")%>/>播放页获取所有数据地址<input type="radio" class="radio" name="playgetsrc" value="0" onclick="hide('playlinkbody');clearvalue('playlinkA','playlinkB');"<%=ifthen(t=0,"checked","")%>/>内容页直接获取数据地址</td>
		</tr>
	</tbody>
	<tbody id="playlinkbody" style="<%=ifthen(t=1 OR t=2,"","display:none")%>">
		<tr>
			<td class="label">播放链接开始：</td>
			<td><textarea name="playlinkA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("playlinkA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">播放链接结束：</td>
			<td><textarea name="playlinkB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("playlinkB"))%></textarea></td>
		</tr>
	</tbody>
	<tbody>
<%t=gES("isspecial")%>
		<tr>
			<td class="label red">特殊链接处理：</td>
			<td><input type="radio" class="radio" name="isspecial" value="0" onclick="hide('specialbody');"<%=ifthen(t=true,"","checked")%>/>不作设置<input type="radio" class="radio" name="isspecial" value="1" onclick="show('specialbody')"<%=ifthen(t=true,"checked","")%>/>替换地址<br>对于使用了JavaScript:openwindow形式的连接请使用此功能</td>
		</tr>
	</tbody>
	<tbody id="specialbody" style="<%=ifthen(t=true,"","display:none")%>">
		<tr>
			<td class="label">要替换的地址：</td>
			<td><p class="red">要替换的连接:javaScript:OpenWnd([变量])</p><textarea name="linkRF" rows="4" cols="80"><%=HTMLEncode(gESCrlf("linkRF"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">替换为的地址：</td>
			<td><p class="red">实际连接:play.asp?id=$1</p><textarea name="linkRR" rows="4" cols="80"><%=HTMLEncode(gESCrlf("linkRR"))%></textarea></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td class="label">数据地址开始：</td>
			<td><textarea name="msrcA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("msrcA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">数据地址结束：</td>
			<td><textarea name="msrcB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("msrcB"))%></textarea></td>
		</tr>
<%t=gES("getpart")%>
		<tr>
			<td class="label red">采集数据分集名称：</td>
			<td><input type="radio" class="radio" name="getpart" value="0" onclick="hide('getpartbody');"<%=ifthen(t=true,"","checked")%>/>系统预设<input type="radio" class="radio" name="getpart" value="1" onclick="show('getpartbody')"<%=ifthen(t=true,"checked","")%>/>截取分集名称</td>
		</tr>
	</tbody>
	<tbody id="getpartbody" style="<%=ifthen(t=true,"","display:none")%>">
		<tr>
			<td class="label">分集名称开始：</td>
			<td><textarea name="partA" rows="4" cols="80"><%=HTMLEncode(gESCrlf("partA"))%></textarea></td>
		</tr>
		<tr>
			<td class="label">分集名称结束：</td>
			<td><textarea name="partB" rows="4" cols="80"><%=HTMLEncode(gESCrlf("partB"))%></textarea></td>
		</tr>
	</tbody>
</table>
<div id="step4" style="display:none">
</div>
<div id="step5" style="display:none">
</div>
<table class="tb2">
	<tbody>
		<tr>
			<td class="label"></td>
			<td><%if isEdit=true then echo "<input type=""submit"" class=""btn"" value=""快速保存""/>&nbsp;&nbsp;"%><input type="button" class="btn" name="back" value="返回上一步" onclick="prestep()" />&nbsp;&nbsp;<input type="button" class="btn" name="next" value="下一步" onclick="nextstep()" />&nbsp;&nbsp;<input type="checkbox" class="checkbox" name="showcode" id="showcode" value="1"/>下一步显示源码 &nbsp;&nbsp;<a href="?action=exec&step=1&filename=<%=filename%>">不保存当前设置,立即采集</a></td>
		</tr>
	</tbody>
</table>
</form>
<script type="text/javascript">
function setHtmlCode(str){
	$('htmlcode').value=(""+str).replace(/([^\r])\n([^\r])/ig,"$1\\n$2");
}

function trim(s){
	return (""+s).replace(/(^\s*)|(\s*$)/g,"");
}

function trimall(s){
	return (""+s).replace(/(\s*)/g,"");
}

function addcslashes(str){
	return (""+str).replace(/\\n/g,"\n").replace(/\\r/g,"\r").replace(/([\(\)\[\]\""\'\.\?\+\*\/\\\^\$])/ig,"\\$1").replace(/\n/g,"\\n").replace(/\r/g,"\\r");
}

function StrSlice(Str,sStr,eStr){
	if(eStr=='') return false;
	var tStr=Str.toLowerCase(),iPos=tStr.indexOf(sStr.toLowerCase()),sLen=sStr.length;
	if(iPos==-1) return false;
	iPos=sLen>0 ? iPos+sLen : 0;
	return Str.substr(iPos,tStr.slice(iPos).indexOf(eStr.toLowerCase()));
}

function StrSliceB(Str,sStr,eStr){
	if(sStr+eStr=="") return Str;
	var tStr=Str.toLowerCase(),iPos=tStr.indexOf(sStr.toLowerCase()),sLen=sStr.length;
	if(iPos==-1) return false;
	iPos=sLen>0 ? iPos+sLen : 0;
	if(eStr==""){
		return Str.slice(iPos);
	}else{
		return Str.substr(iPos,tStr.slice(iPos).lastIndexOf(eStr.toLowerCase()));
	}
}
function ReCrlf(Str){
	return Str.replace(/\\t/g,'\u0009').replace(/\\n/g,'\u000a').replace(/\\r/g,'\u000d');
}
//分割文件段
function StrSplits(Str,sStr,eStr){
	if(eStr=="" || Str=="") return [];
	var ret=[],tStr=Str.toLowerCase(),str=Str;
	sStr=sStr.toLowerCase(),eStr=eStr.toLowerCase();
	var sLen=sStr.length,eLen=eStr.length,iPos,ePos;
	while(true){
		iPos=tStr.indexOf(sStr);
		if(iPos==-1) break;
		iPos=sLen>0 ? iPos+sLen : 0,tStr=tStr.slice(iPos),ePos=tStr.indexOf(eStr);
		if(ePos==-1) break;
		ret[ret.length]=str.substr(iPos,ePos),tStr=tStr.slice(ePos+eLen),str=str.slice(iPos+ePos+eLen)
	}
	return ret;
}

function paseAbsURI(aLink,currUrl){
	var b,t,H,i,j,k,siteUrl,rg=/^\s*[\/\\]/i,ab=/^http:\/\//i,qt=/\\([\\\/])/ig;
	currUrl=trim(currUrl).replace(qt,"/"),siteUrl=currUrl.replace(/(https?\:\/\/)((\w+)(\.\w+)*(:\d+)?)\/.*/i,"$1$2"),currUrl=currUrl.replace(siteUrl,"")
	for(var i=0;i<aLink.length;i++){
		H=""+aLink[i];
		if(ab.test(H)){
		}else if(rg.test(H)){
			aLink[i]=siteUrl+H
		}else{
			j=H.split("../").length,t=currUrl.split("/"),k=t.length
			t.length=j<k ? k-j : 0
			aLink[i]=siteUrl+t.join("/")+"/"+H.replace(/([\.]{2}\/)/g,"")
		}
	}
	return aLink;
}

function speciallink(sLink,fLink,rLink){
	var a=fLink.split('[变量]');
	rLink=rLink.split('[变量]').join("$1");
	for(var i=0;i<a.length;i++){
		a[i]=addcslashes(a[i]);
	};
	var rg=new RegExp(a.join("([\\w\\W]+)"),"ig");
	return a.length>1 ? sLink.replace(rg,rLink) : sLink;
}

function removeHTMLCode(Str,cHas){
	if(cHas=="" || Str===false) return Str;
	cHas=cHas.toUpperCase().split("|"),Str=""+Str;
	for(var i=0;i<cHas.length;i++){
		switch(cHas[i]){
			case "TABLE":
				Str=Str.replace(/<\/?(table|thead|tbody|tr|th|td).*>/ig,"");
			break;
			case "OBJECT":
				Str=Str.replace(/<\/?(object|param|embed).*>/ig,"");
			break;
			case "SCRIPT":
				Str=Str.replace(new RegExp("<scr"+"ipt.*>[\\w\\W]+?<\\/scr"+"ipt>","ig"),"").replace(new RegExp("\\son[\\w]+=[\\'\\\"].+?[\\'\\\"](\\s|>)(\\s|\\>)","ig"),"$1");
			break;
			case "STYLE":
				Str=Str.replace(/<style.*>[\w\W]+?<\/style>/ig,"");
				Str=Str.replace(/\sstyle=.+(\s|\>)/ig,"$1");
			break;
			case "CLASS":
				Str=Str.replace(/\sclass=.+(\s|\>)/ig,"$1");
			break;
			default:
				Str=removeHTMLCode(removeHTMLCode(Str,"SCRIPT"),"STYLE").replace(new RegExp("<.*?>","ig"),"");
			break;
		}
	}
	return Str
}

var f=$('wizardform'),hurl={1:"",2:"",3:"",4:""},url,cache={},step=[],stephit=[],istep=1;
for(var i=1;i<6;i++){
	step.push($("step"+i));
	stephit.push($("stephit"+i));
}

function clearvalue(){
	var arg=arguments;
	for(var i=0;i<arg.length;i++){
		try{f.elements[arg[i]].value='';}catch(ignore){}
	}
};

function showBody(n){
	n--;
	for(var i=0;i<step.length;i++){
		step[i].style.display= n!=i ? "none" : "";
		stephit[i].color= n==i ? "red" : "";
	};
}

function prestep(){
	if(istep>1){
		showurl(url=hurl[--istep]);
		showBody(istep);
		if(url!="") request(url,function (Q){setHtmlCode(Q.responseText)});
	}else{
		if(confirm("确实要离开该页面吗？\n\n这将会导致规则页面上未保存的数据丢失，确定？\n\n按“确定”继续，或按“取消”留在当前页面。")){
			history.go(-1);
		}
	}
}

function request(url,fun){
	url="admin_collect.asp?action=proxy&result=true&charset="+f.elements['charset'].value+"&url="+escape(url);
	if(cache[url]==undefined || cache[url]!=''){
		ajax.get(url,function (Q){
			var txt=Q.responseText;
			if(txt!="err" && txt!="ok") cache[url]=txt;
			fun(Q);
		});
	}else{
		fun({responseText:cache[url]})
	}
};

function _nextstep(Q){
	var txt=Q.responseText;
	if(txt!="err"){
		showBody(++istep);
		$('htmltable').style.display=$('showcode').checked ? '' : 'none'
		if(txt!="OK") setHtmlCode(txt);
	}else{
		alert("err")
	}
}
function showurl(s){
	$('showurl').innerHTML="&nbsp;&nbsp;当前采集地址：<font color=red>"+s+"</font>";
}
var hPic="",rg=/\[\u53d8\u91cf\]/g;
function nextstep(){
	var es=f.elements,showcode=es['showcode'].checked;
	if(trim(es["charset"].value)==""){alert("请选择网页编码");return;}
	if(istep==1){
		for(var i=0,ps;i<es['pageset'].length;i++){
			if(es['pageset'][i].checked){
				ps=i;
				break;
			}
		};
		if(ps==0){
			url = es['pageurl0'].value
		}else if(ps==1 || ps==3){
			var _s=parseInt(es['istart'].value),_e=parseInt(es['iend'].value);
			if(_s>_e){
				es['istart'].value=_e,es['iend'].value=_s,es['reverse'].checked=true;
			}
			url = es['pageurl1'].value.replace("{$ID}",trim(es['istart'].value));
		}else if(ps==2){
			url = trim(es['pageurl2'].value).split("\r\n")[0]
		}else{
			alert("请选择分类设置")
		};
		if(es['playfrom'].value==""){
			alert("请选择播放来源");
			return;
		};
		if(es['autocls'][0].checked && es['classid'].value==""){
			alert("请选择所属分类");
			return;
		};
		if(trim(url) == ""){
			alert("请输入采集列表网址");
			return;
		};
		showurl(hurl[2]=url);
		request(url,function (Q){
				if(ps==3) istep=2;
				_nextstep(Q);
		});
	}else if(istep == 2){
		request(url,function (Q){
			var txt=Q.responseText,ls=StrSliceB(txt,ReCrlf(es["listA"].value),ReCrlf(es["listB"].value));
			if(ls===false){if(!confirm("截取 列表开始~列表结束 失败\n\n点[确定]忽略这错误提示，[取消]返回修改")){return;}}
			var mlink=StrSlice(ls,ReCrlf(es["mlinkA"].value),ReCrlf(es["mlinkB"].value));
			if(mlink===false){if(!confirm("截取 链接开始~链接结束 失败\n\n点[确定]忽略这错误提示，[取消]返回修改")){return;}}
			if(es['isspecialmlink'][1].checked) mlink=speciallink(mlink,es["mlinkRF"].value,es["mlinkRR"].value);
			if(es['picmode'][0].checked){
				var sa=ReCrlf(es["picA"].value),sb=ReCrlf(es["picB"].value),t=ReCrlf(es['picvar'].value);
				if(t!=""){
					hPic = sa+sb!='' ? (rg.test(sa) ? t : '')+StrSlice(ls,sa.replace(rg,""),sb.replace(rg,""))+((rg.test(sb) ? t : '')) : '-';
				}else{
					hPic = sa+sb!='' ? StrSlice(ls,sa,sb) : '-';
				};
				if(hPic===false){
						if(!confirm("截取 图片开始 ~ 图片结束 失败\n\n点[确定]忽略这错误提示，[取消]返回修改")){
							return;
						}
				};
			}
			mlink=paseAbsURI([mlink],url);
			setHtmlCode(mlink);
			showurl(hurl[3]=url=mlink);
			request(url,function (W){
				_nextstep(W);
			});
		});
	}else if(istep == 3){
		request(url,function (Q){
			var t,sa,sb,ttxt,txt=Q.responseText,val={},has={'name':"名称",'actor': "演员",'director':'导演','cls': '分类','date': '日期','year': '年份','lang': '语言','area': '地区','note': '备注','state': '连载','keys': '关键词'};
			ttxt = txt;
			for(var k in has){
				try{
					t=document.getElementById(k);
					if(k=='name' || t && t.checked){
						sa=ReCrlf(es[k+"A"].value),sb=ReCrlf(es[k+"B"].value);
						val[k] = sa+sb!='' ? removeHTMLCode(StrSlice(ttxt,sa,sb),"SCRIPT|STYLE|*") : '-';
					}
				}catch(ignore){}
			};
			if(!es['picmode'][0].checked){
				sa=ReCrlf(es["picA"].value),sb=ReCrlf(es["picB"].value),t=ReCrlf(es['picvar'].value);
				if(t!=""){
					val['pic'] = sa+sb!='' ? (rg.test(sa) ? t : '')+StrSlice(ttxt,sa.replace(rg,""),sb.replace(rg,""))+((rg.test(sb) ? t : '')) : '-';
				}else{
					val['pic'] = sa+sb!='' ? StrSlice(ttxt,sa,sb) : '-';
				};
			}else{
				val['pic']=hPic;
			}
			if(es["autocls"][1].checked && val['cls']=="-"){
				if(!confirm("截取 "+has['cls']+"开始 ~ "+has['cls']+"结束 失败\n\n点[确定]忽略这错误提示，[取消]返回修改")){
					return;
				}
			}
			sa=ReCrlf(es["desA"].value),sb=ReCrlf(es["desB"].value);
			val['des'] = sa+sb!='' ? StrSlice(txt,sa,sb) : "-";
			has['des']='介绍',has['pic']='图片',has['msrc']='数据地址',has['plist']='播放列表',has['playlink']='播放链接',has['linkR']='特殊链接处理';
			var ch=function (R){
			var txt=R.responseText;
				sa=ReCrlf(es["msrcA"].value),sb=ReCrlf(es["msrcB"].value);
				val['msrc']=StrSplits(txt,sa,sb).join("\r\n");
				if(val['msrc']=='') val['msrc']=false;
				for(var k in has){
					if(val[k]===false){
						if(!confirm("截取 "+has[k]+"开始 ~ "+has[k]+"结束 失败\n\n点[确定]忽略这错误提示，[取消]返回修改")){
							return;
						}
					};
				};
				if(val['pic']!='-') val['pic']=paseAbsURI([val['pic']],url).join();
				var te=es["removecode"],removecode=[];
				for(var i=0;i<te.length;i++){
					if(te[i].checked) removecode.push(te[i].value);
				};
				removecode=removecode.join("|");
				if(removecode!="") for(k in val){val[k]=removeHTMLCode(val[k],removecode);}
				var dc=$('step4');
var s="\
名  称："+trim(val['name'] || '')+"\r\n\
图  片："+trim(val['pic'] || '')+"\r\n\
分  类："+trim(val['cls'] || '')+"\r\n\
演  员："+trimall(val['actor'] || '')+"\r\n\
导  演："+trimall(val['director'] || '')+"\r\n\
连  载："+trim(val['state'] || '')+"\r\n\
备  注："+trim(val['note'] || '')+"\r\n\
关键词："+trimall(val['keys'] || '')+"\r\n\
年  份："+trim(val['year'] || '')+"\r\n\
语  言："+trim(val['lang'] || '')+"\r\n\
地  区："+trim(val['area'] || '')+"\r\n\
时  间："+trim(val['date'] || '')+"\r\n\
地  址：\r\n"+trim(val['msrc'] || '')+"\r\n\r\n\
介  绍："+trim(val['des'] || '')+"\r\n\
";
				dc.innerHTML="<pre>"+s.replace(/\</g,"&lt;").replace(/\>/g,"&gt;")+"</pre>";
				_nextstep(R);
			};
			if(es['splay'][1].checked){
				k='plist',sa=ReCrlf(es[k+"A"].value),sb=ReCrlf(es[k+"B"].value);
				val[k] = sa+sb!='' ? StrSlice(txt,sa,sb) : '-';
				txt= val[k];
			}
			if(es['playgetsrc'][0].checked || es['playgetsrc'][1].checked){
				k='playlink',sa=ReCrlf(es[k+"A"].value),sb=ReCrlf(es[k+"B"].value);
				val[k] = sa+sb!='' ? StrSlice(txt,sa,sb) : '-';
				if(val[k]===false){
					if(!confirm("截取 "+has[k]+"开始 ~ "+has[k]+"结束 失败\n\n点[确定]忽略这错误提示，[取消]返回修改")){
						return;
					}
				};
				if(es['isspecial'][1].checked) val[k]=speciallink(val[k],ReCrlf(es["linkRF"].value),ReCrlf(es["linkRR"].value));
				showurl(hurl[4]=paseAbsURI([val[k]],url).join());
				request(hurl[4],function (R){
					setHtmlCode(R.responseText);
					ch(R);
				});
			}else{
				ch({'responseText':txt});
			}
		});
	}else if(istep == 4){
		f.submit()
	}
}
</script>
<%End Sub

Sub ITEMLIST()
	dim pagesize,iStart,iEnd,pCount,ChildDir:pagesize=10:ChildDir=replace(trim(getForm("ChildDir","get")),"\","/")
	page=Cint(Str2Num(GetForm("page","get"))):page=Ifthen(page<1,1,page)
	Dim fileAttr,filename,i,Path:Path=RegReplace(ENGINEDIR&ESCDIR,"/([\\|\/]+$)/ig",""):if not isExistFolder(Path) then CreateFolder Path,"folderdir"
	Dim folderList,folderNum,fileList,fileNum:folderList=getFolderList(Path&ifthen(ChildDir<>"","/","")&ChildDir):if trim(folderList(0))="" then:redim folderList(-1):end if:fileList=getFileList(Path&ifthen(ChildDir<>"","/","")&ChildDir):if trim(fileList(0))="" then:redim fileList(-1):end if:fileList=concat(folderList,fileList):folderNum=UBound(folderList):fileNum=UBound(fileList)
%>
<form name="form1" action="?action=exec" method="get">
<input type="hidden" name="action" value="exec" />
<input type="hidden" name="clear" value="true" />
<table class="tb">
	<tr class="thead"><th colspan="7">采集规则列表：<a href="?">管理采集规则</a> | <a href="?action=wizard">添加采集规则</a> | <a href="?action=importtxt">导入采集规则</a> | 支持破解防盗链：<span class="red"><a href="?action=TEST_HTTP_REFERER" target="_blank">测试</a></span></th></tr>
	<tr><td colspan="7">当前目录：<span class="red"><%=Server.MapPath(Path&ifthen(ChildDir<>"","/","")&ChildDir)%></span> &nbsp;&nbsp;<img width="16" height="16" src="imgs/icon_01.gif" align="absmiddle"/> <a href="javascript:void(0);" onclick="location.reload();">刷新目录</a>&nbsp;&nbsp;<%
	if ChildDir<>"" then
	%>
	<img width="16" height="16" src="imgs/last.gif" align="absmiddle"/> <a href="?childdir=<%=StrSliceB(childdir,"","/")%>">上级目录</a>
	<%
	end if
	%></td></tr>
	<%
	if fileNum >= 0 and UBound(fileList)>-1 then
	fileNum=fileNum+1:pCount=int(Str2Num(fileNum/pagesize))+ifthen(fileNum MOD pagesize>0,1,0):page=ifthen(page>pCount,pCount,page)
	Dim b1,b2:b1=false:b2=false:iStart=(page-1)*pagesize:iEnd=iStart+pagesize:iEnd=ifthen(iEnd>fileNum,fileNum,iEnd)-1
		for i=iStart to iEnd
			fileAttr=split(fileList(i),",")
			filename=ChildDir&ifthen(ChildDir<>"","/","")&fileAttr(0)
			if i<=folderNum then
				if b1=false then
				b1=true
	%>
	<tr class="thead">
		<th colspan="3">目录名称</th>
		<th width="200">目录大小</th>
		<th width="135">最后修改</th>
		<th width="165" colspan="2"></th>
	</tr>
	<%
				end if
	%>
	<tr>
		<td colspan="3"><img width="16" height="16" src="imgs/folder.gif" align="absmiddle"/> <a href="?ChildDir=<%=filename%>"><%=fileAttr(0)%></a></th>
		<td><%=fileAttr(2)%></td>
		<td><%isCurrentDay(fileAttr(3))%></td>
		<td colspan="2"><a href="#" onclick="if(confirm('确定要永久删除<%=filename%>采集规则吗？')) $('hiddensubmit').src='?action=remove&filename=<%=filename%>'">删除</a></td>
	</tr>
	<%
			else
				if b2=false then
				b2=true
	%>
	<tr class="thead">
		<th width="180">采集名称</td>
		<th width="120" colspan="2">播放器/分类</th>
		<th width="200">目标站点</th>
		<th width="135">文件名/最后修改</th>
		<th width="165" colspan="2">操作</th>
	</tr>
	<%			end if
				if isObject(gES) then gES.RemoveAll()
				SET gES=ParseJsonFile(Path&"/"&filename)
	%>
	<tr align="left">
		<td><input type="checkbox" class="checkbox" name="filename" value="<%=filename%>" align="absmiddle"/> <%=gES("itemname")%></td>
		<td colspan="2"><%
		echo gES("playfrom")&"<br />"
		if gES("autocls")=true AND Str2Num(gES("classid"))<>0 then
			echo "<font color=red>智能归类</font>"
		else
			echo ClassID2Name(gES("classid"))
		end if
		%></td>
		<td><a href="javascript:void(0);" onclick="window.open('<%=gES("siteurl")%>','_blank');" title="<%=gES("siteurl")%>"><%=left(gES("siteurl"),25)%></a></td>
		<td><a href="?action=exporttxt&filename=<%=filename%>" title="导出此脚本"><%=fileAttr(0)%></a><br><%isCurrentDay(fileAttr(3))%></td>
		<td colspan="2"><a href="?action=exec&clear=true&filename=<%=filename%>">采集</a> <a href="?action=demo&filename=<%=filename%>">预览</a> <a href="?action=ghost&from=<%=filename%>">克隆</a> <a href="?action=edit&filename=<%=filename%>">编辑</a> <a href="#" onclick="if(confirm('确定要永久删除<%=filename%>采集规则吗？')) $('hiddensubmit').src='?action=remove&filename=<%=filename%>'">删除</a></td>
	</tr>
	<%
			end if
		next
	%>
	<tr><td colspan="7"><div class="cuspages"><div class="pages">全选<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','filename')" />反选<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','filename')" /><input type="submit" value="采集选中脚本" class="btn"/></div></div></td></tr>
	<tr><td colspan="7"><div class="cuspages"><div class="pages">&nbsp;&nbsp; 页次<%=page%>/<%=pCount%> 每页<%=pagesize%> 脚本文件总数<%=fileNum%> <a href="?childdir=<%=childdir%>&page=1">首页</a> <a href="?childdir=<%=childdir%>&page=<%=(page-1)%>">上一页</a> <a href="?childdir=<%=childdir%>&page=<%=(page+1)%>">下一页</a> <a href="?childdir=<%=childdir%>&page=<%=pCount%>">尾页</a> 转到<input type="text" class="txt" id="toPage" value="<%=page%>" style="width:30px"/><button onclick="location.href='?childdir=<%=childdir%>&page='+$('toPage').value">跳转</button></div></div></td></tr>
<%
	SET gES=nothing
	end if%>
</table>
</form>
<%End Sub

Sub tempdatabase
Dim i,inbase,keyword,m_type,playfrom,QWHERE,tRs,rCount,pCount,o_type,m_typename:QWHERE=Array():inbase=GetForm("inbase","get"):keyword=GetForm("keyword","both"):m_type=GetForm("type","both"):m_typename=GetForm("typename","both"):playfrom=GetForm("playfrom","both")
page=Str2Num(GetForm("page","get")):page=Ifthen(page<1,1,page)
if not isNul(inbase) then Push QWHERE,"m_inbase="&Cbool(inbase)
if isNumeric(m_type) then
	if Str2Num(m_type)=0 then
		Push QWHERE,"m_type in (0)"
	else
		Push QWHERE,"m_type in ("&getTypeIdOnCache(m_type)&")"
	end if
end if
if not isNul(m_typename) then Push QWHERE,"m_typeName='"&m_typename&"'"
if not isNul(keyword) then Push QWHERE,"m_name like '%"&keyword&"%' or m_actor like '%"&keyword&"%'"
if not isNul(playfrom) then Push QWHERE,"m_playdata like '%"&playfrom&"$$%'"
QWHERE=Join(QWHERE," AND "):QWHERE=IfThen(QWHERE<>""," WHERE ","")&QWHERE
if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
SET tRs=tConn.db("SELECT m_id,m_name,m_inbase,m_state,m_type,m_typename,m_addtime,m_playdata,m_note FROM {pre}tempdata"&QWHERE&" ORDER BY m_addtime DESC","records1"):o_type=tConn.db("SELECT m_typename FROM {pre}tempdata WHERE m_typename<>'' GROUP BY m_typename","array")
tRs.pageSize=30:rCount = tRs.recordcount:pCount= tRs.pagecount
if page>pCount then page=pCount
%>
<table class="tb">
	<tr class="thead"><th colspan="5">&nbsp;管理临时库：<a href="?action=tempdatabase&inbase=true">显示已入库的</a> | <a href="?action=tempdatabase&inbase=false">显示未入库的</a> | <a href="?action=tempdatabase&type=0">显示未分类的</a> | <a href="?action=tempdatabase">显示所有</a> | <a href="?action=kill">清除内存溢出</a> | <a href="?action=compress" onclick="if(confirm('有可能会造成数据库损坏，是否继续?')){return true;}else{return false;}">压缩临时库</a> | <a href="?action=delallTempData&do=all" onclick="if(confirm('确定要删除所有吗')){return true;}else{return false;}"><u>清空临时库</u></a></th><th colspan="4"></th></tr>
	<form action="?action=tempdatabase" method="post">
	<tr>
		<td align="left" colspan="9">
		关键字<input name="keyword" type="text" id="keyword" size="20">
		<select name="type" id="type"><option value="">请选择数据分类</option><% makeTypeOption 0,"&nbsp;|&nbsp;&nbsp;" %></select>
		<input type="submit" name="selectBtn"  value="查 询..." class="btn" />&nbsp;
		<select onchange="self.location.href='?action=tempdatabase&inbase=<%=inbase%>&type='+this.options[this.selectedIndex].value"><option value="">按数据分类查看</option><% makeTypeOptionSelected 0,"&nbsp;|&nbsp;&nbsp;",m_type %></select>
		<select id='m_playfrom' name='m_playfrom' style="width:120px" onChange="self.location.href='?action=tempdatabase&inbase=<%=inbase%>&playfrom='+this.options[this.selectedIndex].value"><option value=''>按视频来源查看</option><%=makePlayerSelect("")%></select>
		<select onchange="self.location.href='?action=tempdatabase&inbase=<%=inbase%>&typename='+this.options[this.selectedIndex].value">
		<option value="">按旧分类名查看</option>
		<%
			if isArray(o_type) then
				for i=0 to UBound(o_type,2)
					echo "<option value="""&o_type(0,i)&""">"&o_type(0,i)&"</option>"
				next
			end if
		%>
		</select>
		</td>
	</tr>
</form>
<%
if rCount=0 then
	if not isNul(keyword) then echo "<tr align='center'><td>关键字  <font color=red>"""&keyword&"""</font>   没有记录</td></tr>" 
else  
	tRs.absolutepage = page
	if not isNul(keyword) then
%>
  <tr><td colspan="9">关键字  <font color=red> <%=keyword%> </font>   的记录如下</td></tr>
<%
	end if
%>
	<tr>
		<td width="50">编号</td>
		<td>数据名称</td>
		<td width="50">状态</td>
		<td width="80">播放器</td>
		<td width="80">绑定分类</td>
		<td width="80">旧分类名</td>
		<td width="60">采集时间</td>
		<td width="100" colspan="2" align="center">操作</td>
	</tr>
	<form method="post" name="tempdataform" action="?action=delallTempData">
	<input type="hidden" name="typename" value="<%=m_typename%>" />
<%
	dim m_id
	for i = 0 to tRs.pageSize
	m_id=tRs(0)
%>
	<tr>
		<td><input type="checkbox" value="<%=m_id%>" name="m_id" class="checkbox" /><%=m_id%></td>
		<td><%=tRs(1)%><font color="red"><%=tRs(8)%></font></td>
		<td><%=ifthen(tRs(2)=true,"已入库","未入库")%></td>
		<td><%echo getFromStr(tRs(7))%></td>
		<td><%
			if Str2Num(tRs(4))<>0 then
				echo ClassID2Name(tRs(4))
			else
				echo "<font color=red>没找到相关分类</font>"
			end if
		%></td>
		<td><%=ifthen(tRs(5)<>"","<a href=""?action=tempdatabase&inbase="&inbase&"&typename="&Server.UrlEncode(tRs(5))&""">"&tRs(5)&"</a>","")%></td>
		<td><span title="<%=tRs(6)%>"><%isCurrentDay(formatdatetime(tRs(6),2))%></span></td>
		<td colspan="2" align="center"><a href="?action=editVideo&id=<%=m_id%>">编辑</a> <a href="?action=delTempData&id=<%=m_id%>" onClick="return confirm('确定要删除吗')">删除</a></td>
	</tr>
<%
	tRs.movenext
	if tRs.eof then exit for
	next
%>
	<tr>
		<td colspan="9">同名更新：
			<input type="checkbox" class="checkbox" name="fields" value="playdata" checked>播放地址
			<input type="checkbox" class="checkbox" name="fields" value="name">名称
			<input type="checkbox" class="checkbox" name="fields" value="actor" checked>演员
			<input type="checkbox" class="checkbox" name="fields" value="area" checked>地区
			<input type="checkbox" class="checkbox" name="fields" value="state" checked>连载
			<input type="checkbox" class="checkbox" name="fields" value="note" checked>备注
			<input type="checkbox" class="checkbox" name="fields" value="pic" checked>图片
			<input type="checkbox" class="checkbox" name="fields" value="year" checked>年份
			<input type="checkbox" class="checkbox" name="fields" value="des" checked>介绍
			<input type="checkbox" class="checkbox" name="fields" value="director">导演
			<input type="checkbox" class="checkbox" name="fields" value="leng">语言
			<input type="checkbox" class="checkbox" name="fields" value="keyword">关键词
			<input type="checkbox" class="checkbox" name="fields" id="now" value="now" onclick="$('addtime').checked=false;">使用现在时间
			<input type="checkbox" class="checkbox" name="fields" id="addtime" value="addtime" onclick="$('now').checked=false;">使用采集时间
		</td>
	</tr>
	<tr>
		<td colspan="9">播放地址：
			<input type="radio" class="radio" name="gatherset" value="0" checked/>智能覆盖
			<input type="radio" class="radio" name="gatherset" value="1" />地址头部追加
			<input type="radio" class="radio" name="gatherset" value="2" />地址尾部追加
			<input type="radio" class="radio" name="gatherset" value="3" />覆盖地址
			<input type="radio" class="radio" name="gatherset" value="4" />新增数据
			<input type="radio" class="radio" name="gatherset" value="5" />仅更新地址以外的信息
		</td>
	</tr>
	<tr>
		<td colspan="9">全选<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />反选<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" />&nbsp;&nbsp;<input type="submit" value="批量删除" onclick="if(confirm('确定要批量删除吗')){return true}else{return false}" class="btn" />&nbsp;<select name="type" id="type"><option value="">智能识别分类</option><%makeTypeOption 0,"&nbsp;|&nbsp;&nbsp;" %></select>&nbsp;<input type="submit" value="导入选中数据" onclick="this.form.action='?action=import';" class="btn" style="width:85px"/>&nbsp;<input type="submit" value="导入全部数据" onclick="this.form.action='?action=import&smode=all';" class="btn" style="width:85px"/>&nbsp;<input type="submit" value="导入未入库" onclick="this.form.action='?action=import&smode=noinbase';" class="btn" style="width:85px"/></td>
	</tr>
	<tr>
	<td colspan="9"><div class="cuspages" style="float:right"><div class="pages">
	&nbsp;&nbsp; 页次<%=page%>/<%=pCount%> 每页<%=tRs.pageSize%>总收录数据条<%=rCount%> <a href="?action=tempdatabase&inbase=<%=inbase%>&type=<%=m_type%>&typename=<%=Server.UrlEncode(m_typename)%>&playfrom=<%=playfrom%>&keyword=<%=keyword%>&page=1">首页</a> <a href="?action=tempdatabase&inbase=<%=inbase%>&type=<%=m_type%>&typename=<%=Server.UrlEncode(m_typename)%>&playfrom=<%=playfrom%>&keyword=<%=keyword%>&page=<%=(page-1)%>">上一页</a> <a href="?action=tempdatabase&inbase=<%=inbase%>&type=<%=m_type%>&typename=<%=Server.UrlEncode(m_typename)%>&playfrom=<%=playfrom%>&keyword=<%=keyword%>&page=<%=(page+1)%>">下一页</a> <a href="?action=tempdatabase&inbase=<%=inbase%>&type=<%=m_type%>&typename=<%=Server.UrlEncode(m_typename)%>&playfrom=<%=playfrom%>&keyword=<%=keyword%>&page=<%=pCount%>">尾页</a> 转到<input type="text" class="txt" id="toPage" value="<%=page%>" style="width:30px"/><button onclick="location.href='?action=tempdatabase&inbase=<%=inbase%>&type=<%=m_type%>&typename=<%=Server.UrlEncode(m_typename)%>&playfrom=<%=playfrom%>&keyword=<%=keyword%>&page='+$('toPage').value">跳转</button></div></div></td></tr>
</form>
<%end if%>
</table>
<%
tRs.close:set tRs = nothing
End Sub

Sub editVideo
	dim id,sqlStr,rsObj,playArray,downArray,playTypeCount,downTypeCount,i,j,m,n,vtype
	id=clng(getForm("id","get"))
	downArray = getDownKinds("../inc/downKinds.xml")
	sqlStr = "SELECT * FROM {pre}tempdata where m_id="&id
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	set rsObj = tConn.db(sqlStr,"records1")
	if rsObj.eof then die "没找到记录"
	vtype = rsObj("m_type")
%>
<div class="container" id="cpcontainer">
<form action="?action=saveVideo&acttype=edit" method="post" name="editform" id="editform">
<table class="tb">
<tr class="thead"><th colspan="2">修改数据(<font color='red'>＊</font>为必填,其它选填)</th></tr>
	<tr> 
		<td height="22" align="right">来源：</td>
		<td><a href="javascript:void(0);" onclick="window.open('<%=rsObj("m_fromurl") %>','_blank');"><%=rsObj("m_fromurl") %></a></td>
	</tr>
	<tr>
		<td align="right" height="22" width="73">名称：</td>
		<td><input id="m_name" name="m_name" size="23" autocomplete="off" value="<%=rsObj("m_name")%>"/>&nbsp;<font color='red'>＊</font><label>连载？<input type="checkbox" onclick="isViewState()" class="checkbox"  id="m_statebox"  <%if not rsObj("m_state")=0 then %>checked<%end if%>/></label><span id="m_statespan"   <%if rsObj("m_state")=0 then%>style="display:none"<%end if%>>到第<input name="m_state" id="m_state" value="<%=rsObj("m_state")%>" type="text" size="5" />集</span>
		<span id="m_name_ok"></span>类 型：<select name="m_type" id="m_type"  ><option value="">请选择数据分类</option>
	<% makeTypeOptionSelected 0,"&nbsp;|&nbsp;&nbsp;",rsObj("m_type") %>
	</select>&nbsp;&nbsp;<font color='red'>＊</font>&nbsp;<input type="checkbox" name="isupdatetime" value="1" checked class="checkbox" />更新时间</td>
	</tr>
	<tr> 
		<td height="22" align="right">图片地址：</td>
		<td><input type="text" size="30" name="m_pic" id="m_pic" value="<%=rsObj("m_pic")%>">&nbsp;←<input size="10" value="清除" type="button" onClick="javascript:document.editform.m_pic.value=''" class="btn" />&nbsp;</td>
	</tr>
	<tr>
		<td align="right" height="22">主 演：</td>
		<td><input type="text" size="30" name="m_actor" value="<%=rsObj("m_actor")%>">&nbsp;导&nbsp;&nbsp;&nbsp;演：<input type="text" size="30" name="m_director" value="<%=rsObj("m_director")%>"> 主演、导演用逗号或空格隔开</td>
	</tr>
	<tr>
		<td align="right" height="22">备 注：</td>
		<td><input type="text" size="30" name="m_note" value="<%if not isNul(rsObj("m_note")) then echo decodeHtml(rsObj("m_note"))%>">&nbsp;关键词：<input type="text" size="30" name="keyword" value="<%= rsObj("m_keyword") %>"> 备注如：高清,无水印 (配合标题一起显示)</td>
	</tr>
	<tr>
		<td align="right" height="22">发行年份：</td>
		<td><input type="text" size="10" name="m_publishyear" value="<%=rsObj("m_publishyear")%>">&nbsp;语言：<input type="text" size="10" name="m_lang" value="<%=rsObj("m_lang")%>">&nbsp;发行地区：<%echo getAreaSelect("m_publisharea","选择地区",rsObj("m_publisharea"))%>&nbsp;&nbsp;点击率：<input type="text" size="5" name="m_hit" id="m_hit" maxlength="9" value="<%=rsObj("m_hit") %>"></td>
	</tr>
	<tr><td colspan="2" style="padding:0" class="noborder"><div style="" id="m_playarea"><%
	playArray=getPlayurlArray(rsObj("m_playdata"))
	playTypeCount=ubound(playArray)
	dim playfrom,playUrl,playStr,playArray2
	if playTypeCount>-1 then
		for i=0 to playTypeCount
			m=i+1
			playStr=playArray(i)
			playArray2=split(playStr,"$$") : playfrom=playArray2(0)
			playUrl=replace(playArray2(1),chr(10),"")
			playUrl=replace(playUrl,"#",chr(13))
		%>
		<table width='100%' id='playfb<%=m%>'><tr><td align='right' height='22'  width='70'>播放来源<%=m%>：</td><td>
		<select id='m_playfrom<%=m%>' name='m_playfrom'>
		<option value=''>暂没有数据<%=m%></option>
	   <%=makePlayerSelect(playfrom)%>
		</select>
		<input type='button' class='btn' value='WEB采集' onclick='viewGatherWin(<%=m%>);selectTogg();'/>&nbsp;&nbsp;<img onclick="var tb=$('playfb<%=m%>');tb.parentNode.removeChild(tb);" src='imgs/btn_dec.gif' class='pointer' alt="删除播放来源<%=m%>" align="absmiddle"/>&nbsp;&nbsp;<font color='red'>＊</font>&nbsp;&nbsp;<a href="javascript:moveTableUp($('playfb<%=m%>'))">上移</a>&nbsp;&nbsp;<a href="javascript:moveTableDown($('playfb<%=m%>'))">下移</a></td></tr><tr><td align='right' height='22'>数据地址<%=m%>：<br/><input type='button' value='校正' title='校正右侧文本框中的数据格式' class='btn' onclick='repairUrl(<%=m%>)' /></td><td><textarea id='m_playurl<%=m%>' name='m_playurl' rows='8' cols='100'><%=playUrl%></textarea>&nbsp;&nbsp;<font color='red'>＊</font></td></tr>
		</table>
		<%
		next
	end if	
	%>
	</div></td></tr>
	<tr><td colspan='2'>&nbsp;<img onclick="expendPlayArea(<%=m+1%>,escape('<%=replaceStr(makePlayerSelect(""),"'","\'")%>'),0)" src='imgs/btn_add.gif' class='pointer' align="absmiddle"/>&nbsp;&nbsp;<font color="red">您可以单击前面的按钮添加一组播放来源</font></td></tr>

	<tr><td colspan="2" style="padding:0" class="noborder"><div style="" id="m_downarea">
	 <%
	downArray=getPlayurlArray(rsObj("m_downdata"))
	downTypeCount=ubound(downArray)
	dim downfrom,downUrl,downStr,downArray2
	if downTypeCount>-1 then
		for j=0 to downTypeCount
			n=j+1
			downStr=downArray(j)
			downArray2=split(downStr,"$$") : downfrom=downArray2(0)
			downUrl=replace(downArray2(1),chr(10),"") : downUrl=replace(downUrl,"#",chr(13))
		%>
		<table width="100%" id='downfb<%=n%>'><tr><td align='right' height='22'  width='70'>下载来源<%=n%>：</td><td>
		<select id='m_downfrom<%=n%>' name='m_downfrom'>
		<option value=''>暂无数据<%=n%></option>
		<%=makeDownSelect(downfrom)%>
		</select>
		&nbsp;&nbsp;<img onclick="var tb=$('downfb<%=n%>');tb.parentNode.removeChild(tb);" src='imgs/btn_dec.gif' class='pointer' alt="删除下载来源<%=n%>" align="absmiddle"/>&nbsp;&nbsp;
		</td></tr><tr><td align='right' height='22'>下载地址<%=n%>：</td><td><textarea id='m_downurl<%=n%>' name='m_downurl' rows='8' cols='100'><%=downUrl%></textarea></td></tr>
		</table>
		<%
		next
	end if
	%>
	</div></td></tr> 
	<tr><td colspan='2'>&nbsp;<img onclick="expendDownArea(<%=n+1%>,escape('<%=replaceStr(makeDownSelect(""),"'","\'")%>'),0)" src='imgs/btn_add.gif' class='pointer' align="absmiddle"/>&nbsp;&nbsp;<font color="red">您可以单击前面的按钮添加一组下载来源</font></td></tr>
	<tr>
		<td align="right" height="22"></td>
		<td>说明:程序默认每行为一个播放地址，多集请分行，不能有空行</td>
	</tr>
	<tr>
		<td align="right" height="22">相关介绍：</td>
		<td>
  <%Dim oFCKeditor:Set oFCKeditor = New FCKeditor:oFCKeditor.BasePath="fckeditor/":oFCKeditor.ToolbarSet="maxcms":oFCKeditor.Width="640":oFCKeditor.Height="250":oFCKeditor.Value=decodeHtml(rsObj("m_des")):oFCKeditor.Create "m_des"%>
  		</td>
	</tr>
	<tr><input type="hidden" name="m_id" value="<%=id%>"><input type="hidden" name="m_back" value="<%=request.ServerVariables("HTTP_REFERER")%>" />
	<td></td><td class="forumRow"><input type=Submit class="btn" value="确认保存" name=Submit onClick="if($('m_name').value.length==0){alert('请填写名称');return false;};if($('m_type').value.length==0){alert('请选择分类');return false;};if($('m_publishyear').value.length>0){if(isNaN($('m_publishyear').value)){alert('年份请填写数字');return false;}}">&nbsp;<input type=reset name=Submit2 class="btn" value="清 除">&nbsp;<input type=button class="btn" value="返　回" onClick="javascript:history.go(-1);"></td>
  </tr>
</table>
</form>
<script type="text/javascript">$('editform').m_name.focus();var siteurl='<%=siteurl%>';</script>
</div>
<%
	set rsObj = nothing
End Sub

Sub popDiv
%>
<div id="gathervideo" style="top:100px; display:none;" class="popdiv">
<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('gathervideo').style.display='none';selectTogg()" />WEB采集助手</div>
	<div class="popbody"><div>
	<table ><tr><td><input name='areaid' id='areaid' type='hidden' value=""><input type="text" name="gatherurl" id="gatherurl" size="60" /> <input type="button" onclick="gather()"   class="btn" value="分   析"/><span id="loading" style="display:none"><img src="imgs/loading2.gif" width="16" height="16"><font color="#FF0000">分析数据中</font></span></td></tr>
	<tr><td><textarea id="gathercontent" cols="72" rows="9"></textarea></td></tr>
	<tr><td><input type="button" onclick="insertResult(1);selectTogg()"   class="btn" value="添  加"/> <input type="button" value="倒 序" style="margin-left:30px;margin-right:10px" onclick="reverseOrder()" class="btn"   />将<input type="text" size="10" id='replace1' />替换成<input type="text" id='replace2' size="10" />&nbsp;
	<input type="button" value="替 换"  onclick="replaceStr()" class="btn" /></td></tr>
	</table>
	 </div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>
<%
End Sub

Sub customercls
page=Str2Num(GetForm("page","get")):page=Ifthen(page<1,1,page)
dim tRs,pCount,rCount,i,id
if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
SET tRs=tConn.db("SELECT id,clsName,sysClsID FROM {pre}cls","records1")
tRs.pageSize=20:rCount = tRs.recordcount:pCount= tRs.pagecount
if page>pCount then page=pCount
%>
<table class="tb">
	<tr class="thead"><th colspan="4">自定义分类</th></tr>
	<tr>
		<td>ID</td>
		<td>要转换的分类名</td>
		<td>影射到系统分类</td>
		<td>操作</td>
	</tr>
<%if rCount=0 then%>
	<tr>
		<td colspan="4" align="center">没找到自定义分类</td>
	</tr>
<%
else
tRs.absolutepage = page
%>
<form action="?action=customersavecls" method="post" name="form1">
<%	for i = 0 to tRs.pageSize
	id=tRs(0)
%>
	<tr>
		<td><input type="checkbox" value="<%=id%>" name="id" class="checkbox"/><%=id%></td>
		<td><input type="text" name="clsName<%=id%>" value="<%=tRs(1)%>" /></td>
		<td><select name="m_type<%=id%>"><option value="">请选择数据分类</option><% makeTypeOptionSelected 0,"&nbsp;|&nbsp;&nbsp;",tRs(2) %></select></td>
		<td><a href="?action=customerdelcls&id=<%=id%>">删除</a></td>
	</tr>
<%
	tRs.movenext
	if tRs.eof then exit for
	next
%>
	<tr>
		<td colspan="4"><div class="cuspages"><div class="pages"><label>全选<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','id')" /></label><label>反选<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','id')" /></label><input type="submit" value="批量删除" onclick="if(confirm('确定要删除吗')){this.form.action='?action=customerdelallcls';}else{return false}" class="btn"/>&nbsp;&nbsp;<input type="submit" value="批量修改选中分类" name="Submit" class="btn" onclick="this.form.action='?action=customersavecls';"/>页次<%=page%>/<%=pCount%> 每页<%=tRs.pageSize%>总收录数据条<%=rCount%> <a href="?action=customercls&page=1">首页</a> <a href="?action=customercls&page=<%=(page-1)%>">上一页</a> <a href="?action=customercls&page=<%=(page+1)%>">下一页</a> <a href="?action=customercls&page=<%=pCount%>">尾页</a><input type="text" class="txt" id="toPage" value="<%=page%>" style="width:30px"/><button onclick="location.href='?action=customercls&page='+$('toPage').value">跳转</button></div></div></td>
	</tr>
</form>
<%end if%>
	<tr class="thead"><th colspan="4"></th></tr>
<form action="?action=customernewcls" method="post" name="form2">
	<tr>
		<td>添加</td>
		<td><input type="text" name="clsName" value="" /></td>
		<td><select name="m_type" id="m_type"><option value="">请选择数据分类</option><% makeTypeOption 0,"&nbsp;|&nbsp;&nbsp;" %></select></td>
		<td><input type="submit" value="确定" name="Submit" class="btn"/></td>
	</tr>
</form>
</table>
<%
tRs.close:set tRs = nothing
End Sub

Sub filtersDictionary
page=Str2Num(GetForm("page","get")):page=Ifthen(page<1,1,page)
dim tRs,pCount,rCount,i,id
if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
SET tRs=tConn.db("SELECT * FROM {pre}fWord","records1")
tRs.pageSize=30:rCount = tRs.recordcount:pCount= tRs.pagecount
if page>pCount then page=pCount
%>
<table class="tb">
	<tr class="thead"><th colspan="6">过滤字典: <a href="?action=filters">字典列表</a> | <a href="?action=filtersadd">添加过滤</a></th></tr>
	<tr>
		<td>ID</td>
		<td>过滤名称</td>
		<td>过滤字段</td>
		<td>过滤模式</td>
		<td>状态</td>
		<td>操作</td>
	</tr>
<%if rCount=0 then%>
	<tr>
		<td colspan="6" align="center">没找到内容</td>
	</tr>
<%
else
tRs.absolutepage = page
%>
<form action="" method="post" name="form1">
<%	for i = 0 to tRs.pageSize
	id=tRs(0)
%>
	<tr>
		<td><input type="checkbox" value="<%=id%>" name="id" class="checkbox"/><%=id%></td>
		<td><%=tRs("name")%></td>
		<td><%=ifthen(tRs("rColumn")=0,"标题替换","剧情替换")%></td>
		<td><%=ifthen(tRs("uesMode")=0,"简单替换","高级替换")%></td>
		<td><%=ifthen(tRs("Flag")=true,"√","<font color=red>×</font>")%></td>
		<td><a href="?action=filtersban&id=<%=id%>"><%=ifthen(tRs("Flag")=true,"禁用","启用")%></a> <a href="?action=filtersedit&id=<%=id%>">编缉</a> <a href="?action=filtersdel&id=<%=id%>">删除</a></td>
	</tr>
<%
	tRs.movenext
	if tRs.eof then exit for
	next
%>
	<tr>
		<td colspan="6"><div class="cuspages"><div class="pages"><label>全选<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','id')" /></label><label>反选<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','id')" /></label><input type="submit" value="批量删除" onclick="if(confirm('确定要删除吗')){this.form.action='?action=filtersdelall';}else{return false}" class="btn"/>页次<%=page%>/<%=pCount%> 每页<%=tRs.pageSize%>总收录数据条<%=rCount%> <a href="?action=filters&page=1">首页</a> <a href="?action=filters&page=<%=(page-1)%>">上一页</a> <a href="?action=filters&page=<%=(page+1)%>">下一页</a> <a href="?action=filters&page=<%=pCount%>">尾页</a><input type="text" class="txt" id="toPage" value="<%=page%>" style="width:30px"/><button onclick="location.href='?action=filters&page='+$('toPage').value">跳转</button></div></div></td>
	</tr>
</form>
<%end if%>
</table>
<%
tRs.close:set tRs = nothing
End Sub

Sub EditOrAdd
Dim aRs(9),tRs,id,i:aRs(2)=-1:aRs(3)=-1:aRs(8)=true:id=Str2Num(getForm("id","get"))
if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
if id>0 then tRs=tConn.db("SELECT top 1 ID,Name,rColumn,uesMode,sFind,sStart,sEnd,sReplace,Flag FROM {pre}fWord WHERE id="&id,"array")
if isArray(tRs) then
	for i=0 to 8
		aRs(i)=tRs(i,0)
	next
end if
%>
<table class="tb">
	<tr class="thead"><th colspan="2">过滤字典: <a href="?action=filters">字典列表</a> | <a href="?action=filtersadd">添加过滤</a></th></tr>
	<form action="?action=SaveEditOrAdd" method="post" name="form1">
	<input type="hidden" name="id" value="<%=id%>" />
	<tr>
		<td class="label">过滤器名称</td>
		<td><input type="text" class="txt" name="name" value="<%=aRs(1)%>" /></td>
	</tr>
	<tr>
		<td class="label">过滤字段</td>
		<td><select name="rColumn"><option value="0"<%=ifthen(aRs(2)=1,""," selected")%>>数据名称</option><option value="1"<%=ifthen(aRs(2)=1," selected","")%>>数据简介</option></select></td>
	</tr>
	<tr>
		<td class="label">过滤模式</td>
		<td><input type="radio" class="radio" name="uesMode" value="0" onclick="hide('sStartBody','sEndBody');show('sFindBody');"<%=ifthen(aRs(3)=1,"","checked")%>/>简单替换 <input type="radio" class="radio" name="uesMode" value="1" onclick="hide('sFindBody');show('sStartBody','sEndBody');"<%=ifthen(aRs(3)=1,"checked","")%>/>高级替换</td>
	</tr>
	<tr id="sFindBody" style="<%=ifthen(aRs(3)=1,"display:none","")%>">
		<td class="label">查找</td>
		<td><textarea name="sFind" rows="4" cols="80"><%=HTMLEncode(aRs(4))%></textarea></td>
	</tr>
	<tr id="sStartBody" style="<%=ifthen(aRs(3)=1,"","display:none")%>">
		<td class="label">开始标记</td>
		<td><textarea name="sStart" rows="4" cols="80"><%=HTMLEncode(aRs(5))%></textarea></td>
	</tr>
	<tr id="sEndBody" style="<%=ifthen(aRs(3)=1,"","display:none")%>">
		<td class="label">结束标记</td>
		<td><textarea name="sEnd" rows="4" cols="80"><%=HTMLEncode(aRs(6))%></textarea></td>
	</tr>
	<tr>
		<td class="label">替换</td>
		<td><textarea name="sReplace" rows="4" cols="80"><%=HTMLEncode(aRs(7))%></textarea></td>
	</tr>
	<tr>
		<td class="label">启用</td>
		<td><input type="radio" class="radio" name="Flag" value="1"<%=ifthen(aRs(8)=true," checked","")%>/>启用 <input type="radio" class="radio" name="Flag" value="0"<%=ifthen(aRs(8)=true,""," checked")%>/>禁用</td>
	</tr>
	<tr>
		<td colspan=2><input  type="submit" class="btn" name="Submit" value="确&nbsp;&nbsp;定" >&nbsp;&nbsp;&nbsp;&nbsp;<input name="Cancel" class="btn" type="button" id="Cancel" value="取&nbsp;&nbsp;消" onClick="window.location.href='?action=filters'"></td>
	</tr>
	</form>
</table>
<%End Sub
Sub filtersban
	dim back,id:back = request.ServerVariables("HTTP_REFERER"):id = Str2Num(getForm("id","get"))
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	if id>0 then tConn.db "UPDATE {pre}fWord SET Flag=(not Flag) WHERE id ="&id,"execute"
	alertMsg "",back
End Sub

Sub filtersdel
	dim back,id:back = request.ServerVariables("HTTP_REFERER"):id = Str2Num(getForm("id","get"))
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	tConn.db  "DELETE FROM {pre}fWord WHERE id ="&id,"execute" 
	alertMsg "",back
End Sub

Sub filtersdelall
	dim ids:ids = replaceStr(getForm("id","post")," ","")
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	if ids<>"" then tConn.db  "delete from {pre}fWord where id in("&ids&")","execute" 
	alertMsg "","?action=filters"
End Sub

Sub SaveEditOrAdd
	Dim id,Name,rColumn,uesMode,sFind,sStart,sEnd,sReplace,Flag:id=Str2Num(getForm("id","post"))
	Name=filterQuote(getForm("Name","post")):rColumn=Str2Num(getForm("rColumn","post")):uesMode=Str2Num(getForm("uesMode","post"))
	sFind=filterQuote(request.form("sFind")):sStart=filterQuote(request.form("sStart")):sEnd=filterQuote(request.form("sEnd")):sReplace=filterQuote(request.form("sReplace"))
	Flag=Str2Num(getForm("Flag","post"))=1
	if trim(Name)="" then alertMsg "请填写过滤器名称","javascript:history.go(-1)":die ""
	if uesMode=0 AND Len(sFind)=0 then alertMsg "请填写查找的字符","javascript:history.go(-1)":die ""
	if uesMode=1 AND Len(sStart)=0 then alertMsg "请填写开始标记","javascript:history.go(-1)":die ""
	if uesMode=1 AND Len(sEnd)=0 then alertMsg "请填写结束标记","javascript:history.go(-1)":die ""
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	if id>0 then
		tConn.db "UPDATE {pre}fWord SET Name='"&Name&"',rColumn="&rColumn&",uesMode="&uesMode&",sFind='"&sFind&"',sStart='"&sStart&"',sEnd='"&sEnd&"',sReplace='"&sReplace&"',Flag="&Flag&" WHERE id="&id,"execute"
	else
		tConn.db "INSERT INTO {pre}fWord (Name,rColumn,uesMode,sFind,sStart,sEnd,sReplace,Flag)VALUES('"&Name&"',"&rColumn&","&uesMode&",'"&sFind&"','"&sStart&"','"&sEnd&"','"&sReplace&"',"&Flag&")","execute"
	end if
	alertMsg "","?action=filters"
End Sub

Sub customernewcls
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	dim clsName,m_type:clsName = getForm("clsName","post"):m_type=getForm("m_type","post")
	if isNul(clsName) then alertMsg "要转换有分类名还没填写","javascript:history.go(-1)":die ""
	if not isNum(m_type) then alertMsg "未选择影射到系统分类","javascript:history.go(-1)":die ""
	tConn.db "INSERT INTO {pre}cls (clsName,sysClsID)VALUES('"&clsName&"',"&m_type&")","execute"
	alertMsg "","?action=customercls"
End Sub

Sub customersavecls
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	dim ids,id,clsName,m_type:ids = split(replaceStr(getForm("id","post")," ",""),",")
	For Each id In ids
		clsName = getForm("clsName"&id,"post")
		if isNul(clsName) then alertMsg "ID为"&id&" 要转换有分类名还没填写","javascript:history.go(-1)":die ""
		m_type = getForm("m_type"&id,"post")
		if not isNum(m_type) then alertMsg "ID为"&id&" 未选择影射到系统分类","javascript:history.go(-1)":die ""
		tConn.db "UPDATE {pre}cls SET clsName='"&clsName&"',sysClsID="&m_type&" WHERE id="&id,"execute"
	Next
	alertMsg "","?action=customercls"
End Sub

Sub customerdelallcls
	dim ids:ids = replaceStr(getForm("id","post")," ","")
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	if ids<>"" then tConn.db  "delete from {pre}cls where id in("&ids&")","execute" 
	alertMsg "","?action=customercls"
End Sub

Sub customerdelcls
	dim back,id:back = request.ServerVariables("HTTP_REFERER"):id = Str2Num(getForm("id","get"))
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	tConn.db  "delete from {pre}cls where id ="&id,"execute" 
	alertMsg "",back
End Sub

Sub saveVideo
	dim actType : actType = getForm("acttype","get")
	dim updateSql,insertSql
	dim m_name:m_name=getForm("m_name","post")
	dim m_keyword : m_keyword = replace(replace(getForm("keyword","post"),chr(13),""),chr(10),"")
	dim m_enname : m_enname = MoviePinYin(m_name)
	dim m_hit : m_hit =  getForm("m_hit","post"):if not isNum(m_hit) then m_hit=0
	dim m_back:m_back=getForm("m_back","post")
	dim m_color:m_color=getForm("m_color","post")
	dim m_state:m_state=getForm("m_state","post") : if isNul(m_state) then m_state=0
	dim m_type:m_type=getForm("m_type","post"):if  isNul(m_type) then die "请选择分类" 
	dim m_pic:m_pic=getForm("m_pic","post")
	dim m_actor:m_actor=getForm("m_actor","post")
	dim m_note:m_note=replaceSpecial(getForm("m_note","post"))
	dim m_des:m_des=replaceSpecial(getForm("m_des","post"))
	dim m_addtime:m_addtime=getForm("m_addtime","post")
	dim m_publishyear:m_publishyear=getForm("m_publishyear","post"):if  isNul(m_publishyear) then m_publishyear=0
	dim m_publisharea:m_publisharea=getForm("m_publisharea","post"):if  isNul(m_publisharea) then m_publisharea=""
	dim m_director:m_director=getForm("m_director","post")
	dim m_lang:m_lang=getForm("m_lang","post")
	dim m_playfrom:m_playfrom=getForm("m_playfrom","post")
	dim m_playurl:m_playurl=getForm("m_playurl","post")
	if not(isnul(m_playurl)) then
		m_playurl = repairUrlForm(m_playurl,m_playfrom)
	end if 
	dim m_playdata:m_playdata=transferUrl(m_playfrom,m_playurl)
	dim m_downfrom:m_downfrom=getForm("m_downfrom","post")
	dim m_downurl:m_downurl=getForm("m_downurl","post")
	if not (isnul(m_downurl)) then
		m_downurl = repairDownUrl(m_downurl,m_downfrom)
	end if
	dim m_downdata:m_downdata=transferUrl(m_downfrom,m_downurl)
	dim isupdatetime:isupdatetime=getForm("isupdatetime","post")
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	select case  actType
		case "edit"
			dim m_id:m_id=clng(getForm("m_id","post"))
			updateSql = "m_letter = '"&left(m_enname,1)&"',m_keyword='"&m_keyword&"', m_hit="&m_hit&",m_name='"&m_name&"',m_state="&m_state&",m_type="&m_type&",m_pic='"&m_pic&"',m_actor='"&m_actor&"',m_note='"&m_note&"',m_des='"&m_des&"',m_publishyear="&m_publishyear&",m_publisharea='"&m_publisharea&"',m_playdata='"&m_playdata&"',m_downdata='"&m_downdata&"',m_director='"&m_director&"',m_lang='"&m_lang&"',m_enname='"&m_enname&"'"
			if not isNul(isupdatetime) then  updateSql = updateSql&",m_addtime='"&now()&"'"
			updateSql = "update {pre}tempdata set "&updateSql&" where m_id="&m_id
			tConn.db  updateSql,"execute"
			alertMsg "",m_back
	end select
End Sub

Sub delallTempData
	dim ids:ids = replaceStr(getForm("m_id","post")," ","")
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	if getForm("do","get")="all" then
		tConn.db "delete from {pre}tempdata","execute"
	else
		if ids<>"" then tConn.db "delete from {pre}tempdata where m_id in("&ids&")","execute"
	end if
	alertMsg "","?action=tempdatabase"
End Sub

Sub delTempData
	dim back,id:back = request.ServerVariables("HTTP_REFERER"):id = getForm("id","get")
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	tConn.db  "delete from {pre}tempdata where m_id ="&id,"execute" 
	alertMsg "",back
End Sub

Sub import
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	dim ids,idsArray,i,tRs,vtype,sMode,rCount,pCount,result,m_typename,fields,QWHERE,gatherSet:QWHERE=array():result=trim(getForm("result","both")):result=ifthen(result<>"",result,request.ServerVariables("HTTP_REFERER")):sMode=UCase(getForm("sMode","both")):vtype=Str2Num(getForm("type","post")):rCount=Str2Num(getForm("rCount","both")):pCount=Str2Num(getForm("pCount","both")):m_typename=getForm("typename","both"):gatherSet=Str2Num(getForm("gatherSet","both")):fields=","&ReplaceStr(getForm("fields","both")," ","")&","
	if sMode<>"" then
		page=Cint(Str2Num(GetForm("page","both"))):page=Ifthen(page<1,1,page)
		if sMode<>"ALL" then Push QWHERE,"m_inbase=false"
		if not isNul(m_typename) then Push QWHERE,"m_typename='"&m_typename&"'"
		QWHERE=Join(QWHERE," AND "):QWHERE=IfThen(QWHERE<>""," WHERE ","")&QWHERE
		idsArray=array():SET tRs=tConn.db("SELECT m_id FROM {pre}tempdata"&QWHERE,"records1")
		tRs.pageSize=250:rCount = ifthen(rCount>0,rCount,tRs.recordcount):pCount= ifthen(pCount>0,pCount,tRs.pagecount)
		if not tRs.EOF then
			tRs.absolutepage = page
			for i=1 to tRs.pageSize
				if tRs.EOF then:exit for:end if
				Push idsArray,Clng(tRs("m_id")):tRs.movenext
			next
		end if
		tRs.Close:SET tRs=Nothing
		if UBound(idsArray)<>-1 then
			echo "正在导入数据,当前是第<font color='red'>"&page&"</font>页,共<font color='red'>"&pCount&"</font>页,共<font color='red'>"&rCount&"</font>部数据<hr />"
			import2Base idsArray,vtype,fields,gatherSet
			echo "<br>暂停3秒后继续导入<script language=""javascript"">setTimeout(function (){location.href='?action="&action&"&sMode="&sMode&"&type="&vtype&"&typename="&Server.URLEncode(m_typename)&"&page="&(Page+1)&"&pcount="&pCount&"&rcount="&rCount&"&result="&Server.URLEncode(result)&"';},3000);</script>"
		else
			alertMsg "导入完成",result
		end if
	else
		ids = replaceStr(getForm("m_id","post")," ","")
		if isNul(ids) then:alertMsg "请选择数据",result:die "":end if
		import2Base split(ids,","),vtype,fields,gatherSet
		alertMsg "",result
	end if
End Sub

Function getTypeAllId()
	Dim TS,i,j,r:TS=getTypeLists():r="":j=getTypeIndex("m_id")
	for i=0 to UBound(TS,2)
		if r="" then
			r=TS(j,i)
		else
			r=r&","&TS(j,i)
		end if
	next
	getTypeAllId=r
End Function

Sub import2Base(ByVal idsArray,ByVal vtype,ByVal fields,ByVal gatherSet)
	dim i,rsObjArray,rsObj,sql,m_sql,title,m_where,m_i,titleArray,m_playdata,m_type,m_enname,SETSQL,allid:allid=","&getTypeAllId()&","
	if ubound(idsArray)<>-1 then
		rsObjArray=tConn.db("SELECT m_id,m_name,m_type,m_state,m_pic,m_actor,m_des,m_playdata,m_publishyear,m_publisharea,m_hit,m_note,m_keyword,m_lang,m_director,m_datetime,m_addtime FROM {pre}tempdata WHERE m_id IN ("&Join(idsArray,",")&") ORDER BY m_addtime ASC","array")
		for i=0 to UBound(rsObjArray,2)
			m_where="":sql="":title=rsObjArray(1,i):titleArray=split(title,"/"):SETSQL=array()
			m_type=ifthen(vtype>0,vtype,rsObjArray(2,i))
			for m_i=0 to ubound(titleArray)
				if not isNul(titleArray(m_i)) then m_where=m_where&" or '/'+m_name+'/' like '%/"&titleArray(m_i)&"/%' "
			next
			m_where=trimOuterStr(m_where," or"):m_enname=MoviePinYin(title)
			m_sql="select top 1 m_id,m_playdata,m_state,m_type,m_pic from {pre}data where "&m_where
			set rsObj=conn.db(m_sql,"execute")
			if not rsObj.eof then m_type=ifthen(m_type>0,m_type,rsObj("m_type"))
			if Instr(allid,","&m_type&",")=0 then
				m_type=0
			elseif isNul(m_type) then
				m_type=0
			end if
			if m_type>0 then
				rsObjArray(5,i)=getStrByLen(rsObjArray(5,i),255)
				rsObjArray(14,i)=getStrByLen(rsObjArray(14,i),50)
				rsObjArray(13,i)=getStrByLen(rsObjArray(13,i),30)
				if rsObj.eof then
						sql="insert into {pre}data(m_name,m_type,m_state,m_pic,m_actor,m_des,m_playdata,m_isunion,m_publishyear,m_publisharea,m_letter,m_hit,m_note,m_keyword,m_lang,m_director,m_datetime,m_enname) values('"&rsObjArray(1,i)&"',"&m_type&","&rsObjArray(3,i)&",'"&rsObjArray(4,i)&"','"&rsObjArray(5,i)&"','"&rsObjArray(6,i)&"','"&rsObjArray(7,i)&"',1,"&rsObjArray(8,i)&",'"&rsObjArray(9,i)&"','"&Left(m_enname,1)&"',"&rsObjArray(10,i)&",'"&rsObjArray(11,i)&"','"&rsObjArray(12,i)&"','"&rsObjArray(13,i)&"','"&rsObjArray(14,i)&"','"&rsObjArray(15,i)&"','"&m_enname&"')"
				else
					if gatherSet<>4 then
						rsObjArray(3,i)=ifthen(rsObj("m_state")>rsObjArray(3,i),rsObj("m_state"),rsObjArray(3,i)):rsObjArray(4,i)=ifthen(trim(""&rsObj("m_pic"))="",rsObjArray(4,i),rsObj("m_pic"))
						if InStr(fields,",name,")>0 then:Push SETSQL,"m_name='"&rsObjArray(1,i)&"',m_letter='"&Left(m_enname,1)&"',m_enname='"&m_enname&"'":end if
						if InStr(fields,",actor,")>0 then:Push SETSQL,"m_actor='"&rsObjArray(5,i)&"'":end if
						if InStr(fields,",publishyear,")>0 then:Push SETSQL,"m_publishyear="&rsObjArray(8,i):end if
						if InStr(fields,",publisharea,")>0 then:Push SETSQL,"m_publisharea='"&rsObjArray(9,i)&"'":end if
						if InStr(fields,",state,")>0 then:Push SETSQL,"m_state="&rsObjArray(3,i):end if
						if InStr(fields,",note,")>0 then:Push SETSQL,"m_note='"&rsObjArray(11,i)&"'":end if
						if InStr(fields,",pic,")>0 then:rsObjArray(4,i)=filterQuote(rsObjArray(4,i)):Push SETSQL,"m_pic='"&rsObjArray(4,i)&"'":end if
						if InStr(fields,",des,")>0 then:Push SETSQL,"m_des='"&rsObjArray(6,i)&"'":end if
						if InStr(fields,",director,")>0 then:Push SETSQL,"m_director='"&rsObjArray(14,i)&"'":end if
						if InStr(fields,",leng,")>0 then:Push SETSQL,"m_lang='"&rsObjArray(13,i)&"'":end if
						if InStr(fields,",keyword,")>0 then:Push SETSQL,"m_keyword='"&rsObjArray(12,i)&"'":end if
						if InStr(fields,",now,")>0 then:Push SETSQL,"m_addtime='"&now()&"'":end if
						if InStr(fields,",addtime,")>0 then:Push SETSQL,"m_addtime='"&rsObjArray(16,i)&"'":end if
						if InStr(fields,",playdata,")>0 AND gatherSet<>5 then:m_playdata = gatherIntoLibTransfer(rsObj("m_playdata"),rsObjArray(7,i),gatherSet):Push SETSQL,"m_playdata='"&m_playdata&"'":end if
					end if
					select case gatherSet
						case 0,1,2,3,5
							sql=Join(SETSQL,","):sql=ifthen(sql<>"",",","")&sql
							sql="update {pre}data set m_type="&m_type&",m_isunion=1"&sql&" where m_id="&rsObj("m_id")
						case 4
							sql="insert into {pre}data(m_name,m_type,m_state,m_pic,m_actor,m_des,m_playdata,m_isunion,m_publishyear,m_publisharea,m_hit,m_note,m_keyword,m_lang,m_director,m_datetime,m_enname) values('"&rsObjArray(1,i)&"',"&m_type&","&rsObjArray(3,i)&",'"&rsObjArray(4,i)&"','"&rsObjArray(5,i)&"','"&rsObjArray(6,i)&"','"&rsObjArray(7,i)&"',1,"&rsObjArray(8,i)&",'"&rsObjArray(9,i)&"',"&rsObjArray(10,i)&",'"&rsObjArray(11,i)&"','"&rsObjArray(12,i)&"','"&rsObjArray(13,i)&"','"&rsObjArray(14,i)&"','"&rsObjArray(15,i)&"','"&m_enname&"')"
					end select
				end if
				conn.db sql,"execute"
				tConn.db "UPDATE {pre}tempdata SET m_inbase=true,m_type="&m_type&" where m_id="&rsObjArray(0,i),"execute"
				echo "<font color=blue>导入成功 ID:"&rsObjArray(0,i)&"	"&rsObjArray(1,i)&"</font><br>"
			else
				echo "<font color=red>没选择分类</font> 导入失败 ID:"&rsObjArray(0,i)&"	"&rsObjArray(1,i)&"<br>"
			end if
			rsObj.close
		next
		set rsObj=nothing
	end if
End Sub

Function makeDownSelect(flag)
	dim i,downinfo,selectstr,allstr
	for i= 0 to ubound(downArray)
		downinfo = split(downArray(i),"__")
		if flag = downinfo(0) then selectstr=" selected " else selectstr=""
		allstr =allstr&"<option value='"&downinfo(0)&"' "&selectstr&">"&downinfo(0)&"--"&downinfo(1)&"</option>"
	next
	makeDownSelect = allstr
End Function

Function getPlayerKinds(xmlfile)
	dim xmlobj,nodeLen,i
	set xmlobj = mainClassobj.createObject("MainClass.Xml")
	xmlobj.load xmlfile,"xmlfile"
	nodeLen = xmlobj.getNodeLen("playerkinds/player")
	redim playerArray(nodeLen-1)
	for i=0 to nodeLen-1
			playerArray(i)=xmlobj.getAttributes("playerkinds/player","flag",i)&"__"&xmlobj.getAttributes("playerkinds/player","des",i)
	next
	set xmlobj = nothing
	getPlayerKinds = playerArray
End Function

Function getDownKinds(xmlfile)
	dim xmlobj,nodeLen,i
	set xmlobj = mainClassobj.createObject("MainClass.Xml")
	xmlobj.load xmlfile,"xmlfile"
	nodeLen = xmlobj.getNodeLen("downkinds/source")
	redim downArray(nodeLen-1)
	for i=0 to nodeLen-1
			downArray(i)=xmlobj.getAttributes("downkinds/source","flag",i)&"__"&xmlobj.getAttributes("downkinds/source","des",i)
	next
	set xmlobj = nothing
	getDownKinds = downArray
End Function

Function getAreaSelect(selectName,strSelect,areaId)
	dim  str,i,selectedStr,xmlobj,j,areaNodes,areaNode
	j=0 : redim areaArray(0)
	str = "<select   name='"&selectName&"' >"
	if not isNul(strSelect) then  str = str & "<option value=''>"&strSelect&"</option>"
	set xmlobj = mainClassobj.createObject("MainClass.Xml")
	xmlobj.load "../inc/areaKinds.xml","xmlfile"
	set areaNodes=xmlobj.getNodes("areakinds/area")
	set xmlobj=nothing
	for each areaNode in areaNodes
		redim preserve areaArray(j) : areaArray(j)=areaNode.text : j=j+1
	next
	set areaNodes=nothing
	for  i = 0 to ubound(areaArray,1)
		if not isNul(areaId) then
			if  trim(areaArray(i)) = trim(areaId)  then   selectedStr = "selected" else  selectedStr = "" 
		end if
		str = str &"<option value='"&areaArray(i)&"' "&selectedStr&">"&areaArray(i)&"</option>"
	next
	str = str & "</select>"
	getAreaSelect = str
End Function

Function makePlayerSelect(flag)
	dim i,playerinfo,selectstr,allstr
	for i= 0 to ubound(playerArray)
		playerinfo = split(playerArray(i),"__")
		if flag = playerinfo(0) then selectstr=" selected " else selectstr=""
		allstr =allstr&"<option value='"&playerinfo(0)&"' "&selectstr&">"&playerinfo(0)&"--"&playerinfo(1)&"</option>"
	next
	makePlayerSelect = allstr
End Function

Function getAllFileList(ByVal sDir)
	Dim i,aLt,aFl:aLt=getFileList(sDir):aFl=getFolderList(sDir):if trim(aLt(0))="" then:aLt=array():end if
	for i=0 to UBound(aFl)
		if trim(aFl(i))<>"" then
			aLt=Concat(aLt,getAllFileList(replace(Split(aFl(i),",")(4),"//","/")))
		end if
	next
	getAllFileList=aLt
End Function

Sub GHOST
	dim fromPath:fromPath=replace(ENGINEDIR&ESCDIR&getForm("from","get"),"\","/")
	if NOT isExistFile(fromPath) then alertMsg "克隆失败,目标采集规则文件不存在","" : die "<script>self.location.href='"&request.ServerVariables("HTTP_REFERER")&"';</script>"
	moveFile fromPath,StrSliceB(fromPath,"","/")&"/"&getTimeFileName(".txt"),"COPY"
	alertMsg "克隆成功","" : die "<script>self.location.href='"&request.ServerVariables("HTTP_REFERER")&"';</script>"
End Sub

Sub REMOVEESFILE
	dim filename,path,cachepath:filename=trim(getForm("filename","get")):path=ENGINEDIR&ESCDIR&filename:cachepath=ENGINEDIR&ESCACHEDIR&filename
	if not isExistFolder(path) then
		delFile path
	else
		if isExistFolder(cachepath) then:delFolder cachepath:end if
		if isExistFolder(path) then:delFolder path:end if
	end if
	die "<script>parent.location.reload();</script>"
End Sub

Function base64Encode(sString)
    If sString = "" Or IsNull(sString) Then
        base64Encode = ""
        Exit Function
    End If

    Dim xml_dom, Node
    Set xml_dom = CreateObject("Microsoft.XMLDOM")

    With xml_dom
        .loadXML ("<?xml version='1.0' ?> <root/>")
        Set Node = xml_dom.createElement("MyText")
        With Node
            .dataType = "bin.base64"
            .nodeTypedValue = Gb2312_Stream(sString)
            base64Encode = ReplaceStr(ReplaceStr(.Text,chr(10),""),chr(13),"")
        End With
        xml_dom.documentElement.appendChild Node
    End With
    Set xml_dom = Nothing
End Function

Function base64decode(sString)
    If sString = "" Or IsNull(sString) Then
        base64decode = ""
        Exit Function
    End If
    Dim xml_dom, Node
    Set xml_dom = CreateObject("Microsoft.XMLDOM")
    With xml_dom
        .loadXML ("<?xml version='1.0' ?> <root/>")
        Set Node = xml_dom.createElement("MyText")
        With Node
            .dataType = "bin.base64"
            .Text = sString
            base64decode = Stream_GB2312(.nodeTypedValue)
        End With
        xml_dom.documentElement.appendChild Node
    End With
    Set xml_dom = Nothing
End Function

Function Gb2312_Stream(sString)
    Dim dr
    Set dr = CreateObject("ADODB.Stream")
    With dr
        .Mode = 3
        .Type = 2
        .open
        .Charset = "utf-8"
        .WriteText sString
        .position = 0
        .Type = 1
        Gb2312_Stream = .Read
        .Close
    End With
    Set dr = Nothing
End Function

Function Stream_GB2312(sStream)
    Dim dr
    Set dr = CreateObject("ADODB.Stream")
    With dr
        .Mode = 3
        .Type = 1
        .open
        .Write sStream
        .position = 0
        .Type = 2
        .Charset = "utf-8"
        Stream_GB2312 = .ReadText
        .Close
    End With
    Set dr = Nothing
End Function

Function gESCrlf(ByVal key)
	gESCrlf=Replace(Replace(ReplaceStr(gES(key),chr(10),"\n"),chr(13),"\r"),"\r\n",vbcrlf)
End Function

Sub compress
	dim engineObj,tempDbPath,targetPath
	tempDbPath = ENGINEDIR&TEMPDATABASEFILENAME&".tmp":targetPath = ENGINEDIR&TEMPDATABASEFILENAME
	if isObject(tConn) then:tConn.Class_Terminate:end if
	set engineObj = server.CreateObject("JRO.JetEngine")
	engineObj.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.MapPath(targetPath),"Provider=Microsoft.Jet.OLEDB.4.0;Data Source="& server.MapPath(tempDbPath)
	moveFile tempDbPath,targetPath,"del"
	set engineObj = Nothing
	alertMsg "压缩成功","?action=tempdatabase"
end sub

Sub killJapanSubmit
	dim i,rsObj,m_name,m_actor,m_playdata,m_downdata,m_pic,m_director,m_keyword,isExist : isExist=false
	if NOT isObject(tConn) then SET tConn=ConnectTempDataBase()
	set rsObj=tConn.db("select m_id,m_name,m_actor,m_playdata,m_downdata,m_pic,m_director,m_keyword from m_tempdata","records1")
	echo "<table class=""tb""><tr class=""thead"" align='left'><td colspan=""3"">已处理数据</td></tr><tr><td>编号</td><td>标题</td><td>主演</td></tr>"
	for i=1 to rsObj.recordcount
		m_name=rsObj(1) : m_actor=rsObj(2) : m_playdata=rsObj(3) : m_downdata=rsObj(4) : m_pic = rsObj(5) : m_director = rsObj(6) : m_keyword = rsObj(7)
		m_name=japanEncode(m_name) : m_actor=japanEncode(m_actor) : m_playdata=japanEncode(m_playdata) : m_downdata=japanEncode(m_downdata) : m_pic=japanEncode(m_pic) : m_director=japanEncode(m_director) : m_keyword=japanEncode(m_keyword)
		if m_name<>rsObj(1) or m_actor<>rsObj(2) or m_playdata<>rsObj(3) or m_downdata<>rsObj(4) or m_pic<>rsObj(5) or m_director<>rsObj(6) or m_keyword<>rsObj(7) then isExist=true else isExist=false
		'echo"--"&isExist&"<br>"
		if isExist then tConn.db "update {pre}tempdata set m_name='"&m_name&"',m_actor='"&m_actor&"',m_playdata='"&m_playdata&"',m_downdata='"&m_downdata&"',m_pic='"&m_pic&"',m_director='"&m_director&"',m_keyword='"&m_keyword&"' where m_id="&rsObj(0),"execute" : echo  "<tr><td>"&rsObj(0)&"</td><td>"&m_name&"</td><td>"&m_actor&"</td></tr>" 
		rsObj.movenext
		if rsObj.eof then exit for
	next
	echo "</table>"
	rsObj.close
	set rsObj=nothing
End Sub

Function japanEncode(Byval str)
	dim i,existJapan,japanStr
	dim japanArray
	japanArray=array("ガ","ギ","グ","ゲ","ゴ","ザ","ジ","ズ","ゼ","ゾ","ダ","ヂ","ヅ","デ","ド","バ","ビ","ブ","ベ","ボ","パ","ピ","プ","ペ","ポ","ヴ")
	if isNul(str)  then japanEncode="" : Exit Function
	japanStr=str
  	for i=0 to 25
		if instr(japanStr,japanArray(i))>0 then japanStr=replaceStr(japanStr,japanArray(i),"")
	next
	japanEncode = japanStr
End Function
%>