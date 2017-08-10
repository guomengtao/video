<!--#include file="admin_inc.asp"-->
<%
'******************************************************************************************
' Software name: Max(马克斯) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: 石头(maxcms2008@qq.com),yuet,长明,酒瓶
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************
viewHead "播放器相关配置" & "-" & menuList(8,0)

dim action : action = getForm("action", "get")
dim playerWidth,playerHeight,playerSkin,playerType,playerList,playerLogo,playerBeforeAdUrl,playerBeforeAdUrl2,playerBeforeTime,playerFont,viewFull,isRefresh,templateobj,playerJsPath,alertWinValue,playerset
set templateobj = mainClassObj.createObject("MainClass.template"):playerJsPath="../js/play.js"
Select  case action
	case "edit" : editPlayerConfig
	case "modifyalert":modifyAlertWinValue
	case "boardsource":boardsource
	case "modifysource":modifysource
	case "modifysourceban":modifysourceban
	case else : getPlayerParas:main
End Select
set templateobj = nothing 
viewFoot

Sub main
%>
<script>
var ColorHex=new Array('00','33','66','99','CC','FF')
var SpColorHex=new Array('FF0000','00FF00','0000FF','FFFF00','00FFFF','FF00FF')
var current=null
var targetElement = null;
function intocolor(){
	var colorTable=''
	for (i=0;i<2;i++){
	for (j=0;j<6;j++){
		colorTable=colorTable+'<tr height=12>'
		colorTable=colorTable+'<td width=11 style="background-color:#000000">'
		if (i==0){
			colorTable=colorTable+'<td width=11 style="background-color:#'+ColorHex[j]+ColorHex[j]+ColorHex[j]+'">'
		}else{
			colorTable=colorTable+'<td width=11 style="background-color:#'+SpColorHex[j]+'">'
		}
		colorTable=colorTable+'<td width=11 style="background-color:#000000">'
		for (k=0;k<3;k++)
		{
			for (l=0;l<6;l++){colorTable=colorTable+'<td width=11 style="background-color:#'+ColorHex[k+i*3]+ColorHex[l]+ColorHex[j]+'">'}
		}
	}
}
colorTable='<table width=253 border="0" cellspacing="0" cellpadding="0" style="border:1px #000000 solid;border-bottom:none;border-collapse: collapse" bordercolor="000000">'
		   +'<tr height=30><td colspan=21 bgcolor=#cccccc>'
		   +'<table cellpadding="0" cellspacing="1" border="0" style="border-collapse: collapse">'
		   +'<tr><td width="3"><td><input type="text" name="DisColor" size="6" disabled style="border:solid 1px #000000;background-color:#ffff00"></td>'
		   +'<td width="3"><td><input type="text" name="HexColor" size="7" style="border:inset 1px;font-family:Arial;" value="#000000"></td></tr></table></td></table>'
		   +'<table border="1" cellspacing="0" cellpadding="0" style="border-collapse: collapse" bordercolor="000000" onmouseover="doOver()" onmouseout="doOut()" onclick="doclick()" style="cursor:hand;">'
		   +colorTable+'</table>';
colorpanel.innerHTML=colorTable
}

function doOver() {
	  if ((event.srcElement.tagName=="TD") && (current!=event.srcElement)) {
		if (current!=null){current.style.backgroundColor = current._background}
		event.srcElement._background = event.srcElement.style.backgroundColor
		DisColor.style.backgroundColor = event.srcElement.style.backgroundColor
		HexColor.value = event.srcElement.style.backgroundColor.toUpperCase();
		event.srcElement.style.backgroundColor = "white"
		current = event.srcElement
	  }
}

function doOut() {
	if (current!=null) current.style.backgroundColor = current._background.toUpperCase();
}

function doclick()
{
	if (event.srcElement.tagName == "TD")
	{
		var clr = event.srcElement._background;
		clr = clr.toUpperCase();
		if (targetElement)
		{
			targetElement.value = clr.replace(/#/g,'');
		}
		DisplayClrDlg(false);
		return clr;
	}
}

function OnDocumentClick()
{
	var srcElement = event.srcElement;
	if (typeof(srcElement.title) != "undefined"&&srcElement.title.indexOf('clrDlg')==0){
		targetElement = event.srcElement;
		DisplayClrDlg(true);
	}
	else
	{
		while (srcElement && srcElement.id!="colorpanel")
		{
			srcElement = srcElement.parentElement;
		}
		if (!srcElement)
		{
			DisplayClrDlg(false);
		}
	}
}

function DisplayClrDlg(display)
{
	var clrPanel = document.getElementById("colorpanel");
	if (display)
	{
		var left = document.body.scrollLeft + event.clientX;
		var top = document.body.scrollTop + event.clientY;
		if (event.clientX+clrPanel.style.pixelWidth > document.body.clientWidth)
		{
			left -= clrPanel.style.pixelWidth;
		}
		if (event.clientY+clrPanel.style.pixelHeight > document.body.clientHeight)
		{
			top -= clrPanel.style.pixelHeight;
		}

		clrPanel.style.pixelLeft = left;
		clrPanel.style.pixelTop = top;
		clrPanel.style.display = "block";
	}
	else
	{
		clrPanel.style.display = "none";
	}
}
</script>
<div class="container" id="cpcontainer">
<!--当前导航-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(8,0)%>&nbsp;&raquo;&nbsp;站点配置';</script>
<form method="post" action="?action=edit">
<table class="tb">
<tr class="thead"><td colspan="2">播放器相关配置</td></tr>
<tr><td width="169" >播放器宽度：</td>
<td width="813" ><input type="text" name="playerwidth" size="10" value="<%=playerWidth%>" />(px)</td></tr>
<tr><td >播放器高度：</td><td><input type="text" name="playerheight" size="10" value="<%=playerHeight%>" />(px)</td>
</tr>
<tr><td>播放器款式：</td><td><select name="playerset"> <option  value="play.swf"  <%if playerset="play.swf" then echo "selected"%>>水晶透明款式</option> <option value="play2.swf"  <%if playerset="play2.swf" then echo "selected"%>>简洁平板款式</option></select> 不断增加更多的播放器款式</td>
</tr>
<tr><td>播放器皮肤：<br />
(皮肤1为默认皮肤)</td>
<td>
<div id="playerskindiv">
<%
dim skinArray,skinArrayLen,skinI
skinArray=split(playerSkin,"|"):skinArrayLen=ubound(skinArray)
for skinI=0 to skinArrayLen
%>
皮肤<%=(skinI+1)%> :背景颜色 #<input type='text' name='playerbgcolor'  title='clrDlg0<%=skinI%>' value="<%=split(skinArray(skinI),",")(0)%>" /> 文字颜色 #<input type='text' name='playerfontcolor'  title='clrDlg1<%=skinI%>' value="<%=split(skinArray(skinI),",")(1)%>"/><br>
<%if skinI=skinArrayLen then%>
<div id='addplayerskin<%=skinI%>'><img  src='imgs/btn_add.gif' onclick='expendPlayerSkin(<%=skinI+1%>)'  style='cursor:pointer'/></div>
<%end if%>
<%
next
%>
</div>

</td>
</tr>
<tr><td  >播放器选择：</td><td><input type="hidden" value="<%=alertWinValue%>" name="alertwin"/>站内：<input type="radio" name="innerplayer" value="1" <%if playerType=1 then echo "checked"%> /> &nbsp;&nbsp;站外：<input type="radio" name="innerplayer"  value="0" <%if playerType=0 then echo "checked"%>/> 
站内播放器可自动播放，可连播、全屏,站外播放器则不能 </td>
</tr>


<tr><td>默认播放列表：</td><td>打开：<input type="radio" name="openlist" value="1" <%if playerList=1 then echo "checked"%>/> &nbsp;&nbsp;收缩：<input type="radio" name="openlist" value="0" <%if playerList=0 then echo "checked"%>/> &nbsp;&nbsp;关闭：<input type="radio" name="openlist" value="2" <%if playerList=2 then echo "checked"%>/>	打开播放器列表,看连续剧更方便；关闭播放列表、加载速度更快</td></tr>

<tr><td>全屏按钮开关：</td><td>显示：<input type="radio" name="viewfull" value="1" <%if viewFull=1 then echo "checked"%>/> &nbsp;&nbsp;隐藏：<input type="radio" name="viewfull" value="0" <%if viewFull=0 then echo "checked"%>/> 支持全屏观看,体验更好</td></tr>

<tr><td>是否刷新播放页：</td><td>刷新：<input type="radio" name="isrefresh" value="1" <%if isRefresh=1 then echo "checked"%>/> &nbsp;&nbsp;不刷新：<input type="radio" name="isrefresh" value="0" <%if isRefresh=0 then echo "checked"%>/> 不刷新播放页,直接在播放器内切换播放,获得绝佳的播放体验,但减少播放页PV</td>
</tr>

<tr ><td>播放器logo：</td><td><input type="text" name="logourl"  size="60" value="<%=playerLogo%>" />
位于<span >根目录的js文件夹下或使用绝对地址</span></td>
</tr>
<tr><td>播放前广告及<br>
qvod加载广告：</td><td><input type="text" name="adbeforeplay" size="60" value="<%=playerBeforeAdUrl%>" />
<span>位于根目录的js文件夹下</span></td>
</tr>
<tr><td>百度影音缓冲<br>
及暂停广告地址：</td><td><input type="text" name="adbeforeplay2" size="60" value="<%=playerBeforeAdUrl2%>" />
<span>位于根目录的js文件夹下</span></td>
</tr>

<tr><td>播放前广告时间：</td><td><input type="text" name="adtimebeforeplay" size="15" value="<%=playerBeforeTime%>" />秒 设置FLV播放器的片头广告时间,P2P播放器以加载时间为准</td>
</tr>
<tr><td>播放器文字设置：</td><td><input type="text" name="playfont" value="<%=playerFont%>" />
  设置播放器底部文字显示</td>
</tr>
<tr><td></td><td><input type="submit" value="确认更新" class="btn" />&nbsp;<input type="button" value="返   回" class="btn" onClick="javascript:history.go(-1)" /></td></tr>
</table>
</form>
<div id="colorpanel" style="position:absolute;display:none;width:253px;height:177px;"></div>
<script type="text/javascript">document.body.onclick = OnDocumentClick;document.body.onload = intocolor;</script>
<%
End Sub

Sub boardsource
dim i,PlayerArray:PlayerArray=getBoardSources()
%>
<script type="text/javascript">
function upformone(i){
	$('id').value=i,$('sort').value=$('sort'+i).value,$('info').value=$('info'+i).value;
	$('form1').submit();
}
</script>
<div class="container" id="cpcontainer">
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(8,0)%>&nbsp;&raquo;&nbsp;播放来源管理';</script>
<form id="form1" name="form1" method="post" action="?action=modifysource" target="hiddensubmit">
<input type="hidden" name="id" id="id" value="" />
<input type="hidden" name="sort" id="sort" value="" />
<input type="hidden" name="info" id="info" value="" />
</form>

<form id="form2" name="form2" method="post" action="?action=modifysource&method=all">
<table class="tb">
	<tr class="thead"><td colspan="4">播放来源管理<font style=" font-weight:200; color:#FF0000" >(播放来源的排序值越大、在前台播放列表中位置越排前)</font></td></tr>
	<tr align="center" bgcolor="#f5fafe">
		<td  align="left" width="106">来源名称</td>
		<td width="225">排序</td>
		<td width="693">来源简介</td>
		<td width="196">操作</td>
	</tr>
<%
	for i=0 to UBound(PlayerArray,2)
%>
	<tr align="center"  bgcolor="#f5fafe">
		<td  align="left" ><input type="checkbox" class="checkbox" id="id<%=i%>" name="id" value="<%=i%>"  checked="checked"/><%=PlayerArray(0,i)%></td>
		<td><input type="text" id="sort<%=i%>" name="sort<%=i%>" value="<%=PlayerArray(2,i)%>" style="width:50px;" maxlength="6" onkeyup="this.value=this.value.replace(/[^\d]/g,'');" onchange="this.onkeyup();"/></td>
		<td><textarea id="info<%=i%>" name="info<%=i%>" cols="80" rows="2"><%=PlayerArray(3,i)%></textarea></td>
		<td><a href="?action=modifysourceban&id=<%=i%>" title="隐藏或显示&#13;所有数据中的 “<%=PlayerArray(0,i)%>” 播放地址"><%if PlayerArray(1,i)="1" then:echo "隐藏":else:echo "<font color=red >显示</font>":end if%></a>&nbsp;&nbsp;<a href="javascript://" onclick="upformone(<%=i%>)">修改</a>
		</td>
	</tr>
<%
	next
%>
	<tr class="thead"><td colspan="4"><input type="checkbox" class="checkbox" id="chkall" onclick="checkAll(this.checked,'input','id')"/>全选 <input type="submit" name="submit" value="修改选中项" class="btn" /></td></tr>
</table>
</form>
<iframe src="about:blank" name="hiddensubmit" width="0" height="0" frameborder="0"scrolling="no" style="display:none"></iframe>
</div>
<%
End Sub

Sub getPlayerParas
	dim configStr
	configStr=loadFile(playerJsPath)
	playerWidth=regexFind(configStr,"var\splayerw\='*""*(\d+?)'*""*\;")
	playerHeight=regexFind(configStr,"var\splayerh\='*""*(\d+?)'*""*\;")
	playerSkin=regexFind(configStr,"var\sskinColor\='*""*(\S+?)'*""*\;")
	playerType=regexFind(configStr,"var\sautoPlay\='*""*(\d+?)'*""*\;")
	playerList=regexFind(configStr,"var\sopenMenu\='*""*(\d+?)'*""*\;")
	viewFull=regexFind(configStr,"var\sshowFullBtn\='*""*(\d+?)'*""*\;")
	alertWinValue=isAlertWin
	isRefresh=regexFind(configStr,"var\srehref\='*""*(\d+?)'*""*\;")
	playerLogo=regexFind(configStr,"var\slogoURL\='*""*(\S+?)'*""*\;")
	playerBeforeAdUrl=regexFind(configStr,"var\sadsPage\='*""*/'*""*\+sitePath\+'*""*js/(\S+?)'*""*\;")
	playerBeforeAdUrl2=regexFind(configStr,"var\sadsPage2\='*""*/'*""*\+sitePath\+'*""*js/(\S+?)'*""*\;")
	playerBeforeTime=regexFind(configStr,"var\sadsTime\=(\d+?)\;")
	playerFont=regexFind(configStr,"var\sbtnName\='*""*(\S+?)'*""*\;")
	playerset=regexFind(configStr,"var\smax_Player_File\='*""*(\S+?)'*""*\;")
	if playerset="" then playerset="play.swf"
End Sub

Sub modifyAlertWinValue
	dim configStr,isalertwin
	configStr=loadFile(playerJsPath)
	isalertwin=getForm("alert","get")
	configStr=templateobj.regExpReplace(configStr,"var\salertwin='*""*\d+'*""*;","var alertwin="""&isalertwin&""";")
	createTextFile configStr,playerJsPath,""
	modifyMoveToCode isalertwin
	alertMsg "配置修改成功","admin_config.asp" 
End Sub

Sub modifyMoveToCode(alertwin)
	dim movestr,movestr2,configStr:configStr=loadFile(playerJsPath)
	movestr="try{top.moveTo(0,0);top.resizeTo(screen.availWidth,screen.availHeight);}catch(e){}":movestr2="//"&movestr
	if alertwin=1 then configStr=replaceStr(configStr,movestr,movestr2) else configStr=replaceStr(replaceStr(configStr,movestr2,movestr),movestr2,movestr)
	createTextFile configStr,playerJsPath,""
End Sub

Sub editPlayerConfig
	dim playerBgColor,playerFontColor,configStr
	playerWidth=getForm("playerwidth","post")
	playerHeight=getForm("playerheight","post")
	playerBgColor=getForm("playerbgcolor","post")
	playerFontColor=getForm("playerfontcolor","post")
	playerSkin=handlePlayerSkinParas(playerBgColor,playerFontColor)
	playerType=getForm("innerplayer","post")
	playerList=getForm("openlist","post")
	viewFull=getForm("viewfull","post")
	isRefresh=getForm("isrefresh","post")
	alertWinValue=isAlertWin
	playerLogo=getForm("logourl","post")
	playerBeforeAdUrl=getForm("adbeforeplay","post")
	playerBeforeAdUrl2=getForm("adbeforeplay2","post")
	playerBeforeTime=getForm("adtimebeforeplay","post")
	playerFont=getForm("playfont","post")
	playerSet=getForm("playerset","post")
	configStr=loadFile(playerJsPath)
	configStr=templateobj.regExpReplace(configStr,"var\splayerw='*""*\d+'*""*;","var playerw='"&playerWidth&"';")
	configStr=templateobj.regExpReplace(configStr,"var\splayerh='*""*\d+'*""*;","var playerh='"&playerHeight&"';")
	configStr=templateobj.regExpReplace(configStr,"var\sskinColor\='*""*(\S+?)'*""*\;","var skinColor="""&playerSkin&""";")
	configStr=templateobj.regExpReplace(configStr,"var\sautoPlay='*""*\d+'*""*;","var autoPlay="""&playerType&""";")
	configStr=templateobj.regExpReplace(configStr,"var\sopenMenu='*""*\d+'*""*;","var openMenu="""&playerList&""";")
	configStr=templateobj.regExpReplace(configStr,"var\sshowFullBtn='*""*\d+'*""*;","var showFullBtn="""&viewFull&""";")
	configStr=templateobj.regExpReplace(configStr,"var\srehref='*""*\d+'*""*;","var rehref="""&isRefresh&""";")
	configStr=templateobj.regExpReplace(configStr,"var\salertwin='*""*\d+'*""*;","var alertwin="""&alertWinValue&""";")
	configStr=templateobj.regExpReplace(configStr,"var\slogoURL\='*""*(\S+?)'*""*\;","var logoURL="""&playerLogo&""";")
	configStr=templateobj.regExpReplace(configStr,"var\sadsPage\='*""*/'*""*\+sitePath\+'*""*js/(\S+?)'*""*\;","var adsPage=""/""+sitePath+""js/"&playerBeforeAdUrl&""";")
	configStr=templateobj.regExpReplace(configStr,"var\sadsTime\=(\d+?)\;","var adsTime="&playerBeforeTime&";")
	configStr=templateobj.regExpReplace(configStr,"var\sbtnName\='*""*(\S+?)'*""*\;","var btnName="""&playerFont&""";")
	if isExistStr(configStr,"var max_Player_File") then 
		configStr=templateobj.regExpReplace(configStr,"var\smax_Player_File\='*""*(\S+?)'*""*\;","var max_Player_File="""&playerSet&""";")
	else
		configStr="var max_Player_File=""play.swf"";//播放器款式"&vbcrlf&configStr
	end if
	if isExistStr(configStr,"var adsPage2") then
	configStr=templateobj.regExpReplace(configStr,"var\sadsPage2\='*""*/'*""*\+sitePath\+'*""*js/(\S+?)'*""*\;","var adsPage2=""/""+sitePath+""js/"&playerBeforeAdUrl2&""";")
	else
	configStr="var adsPage2=""/""+sitePath+""js/loading2.html"";//视频播放前广告页路径"&vbcrlf&configStr
	end if
	createTextFile configStr,playerJsPath,""
	modifyMoveToCode alertWinValue
	alertMsg "编辑成功","admin_player.asp"	
End Sub

Function handlePlayerSkinParas(Byval bgcolor,Byval fontcolor)
	dim bgcolorArray,fontcolorArray,len1,len2,i1,allStr
	'die bgcolor
	bgcolorArray=split(replaceStr(bgcolor," ",""),","):fontcolorArray=split(replaceStr(fontcolor," ",""),",")
	len1=ubound(bgcolorArray):len2=ubound(fontcolorArray)
	if len1<>len2 then die "播放器皮肤参数填写不完整"
	for i1=0 to  len1
		if not isNul(bgcolorArray(i1)) and not isNul(fontcolorArray(i1)) then
			allStr=allStr&bgcolorArray(i1)&","&fontcolorArray(i1)&"|"
		end if
	next
	allStr=trimOuterStr(allStr,"|")
	handlePlayerSkinParas=allStr
End Function

Sub modifysource
	dim method,i,A,back:method=getForm("method","both"):back = request.ServerVariables("HTTP_REFERER")
	dim ids,il:ids=Split(Replace(getForm("id","post")," ",""),","):il=Ubound(ids)
	if il<>-1 then
		A=getBoardSources()
		if method="all" then
			for i=0 to il
				if isNumeric(ids(i)) then
					A(2,ids(i))=Clng(getForm("sort"&ids(i),"post"))
					A(3,ids(i))=getForm("info"&ids(i),"post")
				end if
			next
			alertMsg "修改成功",back
		else
			ids=Join(ids,"")
			if isNumeric(ids) then
					A(2,ids)=Clng(getForm("sort","post"))
					A(3,ids)=getForm("info","post")
			end if
			echo "<script>alert('修改成功');parent.location.reload();</script>"
		end if
		Save2xmlFile(A)
	else
		alertMsg "没选择要修改的项目","javascript:history.go(-1);"
	end if

End Sub

Sub modifysourceban
	dim i,A,back:i=getForm("id","both"):back = request.ServerVariables("HTTP_REFERER")
	if isNumeric(i) then
		A=getBoardSources():A(1,i)=ifthen(trim(A(1,i))="1","0","1")
		Save2xmlFile(A)
	end if
	alertMsg "",back
End Sub

Function getBoardSources()
	Dim i,j,l,tmp,xmlobj,Nodes,Node:SET xmlobj=mainClassobj.createObject("MainClass.Xml"):l=0
	ReDim ret(4,-1)
	xmlobj.load "../inc/playerKinds.xml","xmlfile"
	SET Nodes=xmlobj.getNodes("playerkinds/player")
	for each Node in Nodes
		ReDim Preserve ret(4,l)
		ret(0,l)=xmlobj.getAttributesByNode(Node,"flag")
		ret(1,l)=xmlobj.getAttributesByNode(Node,"open")
		ret(2,l)=xmlobj.getAttributesByNode(Node,"sort")
		ret(2,l)=ifthen(isNum(ret(2,l)),ret(2,l),"0")
		ret(3,l)=Node.text
		ret(4,l)=xmlobj.getAttributesByNode(Node,"des")
		l=l+1
	next
	set xmlobj = nothing:l=l-1
	for i=0 to l
		for j=i+1 to l
			if ret(2,i) < ret(2,j) then
				tmp=ret(0,j):ret(0,j)=ret(0,i):ret(0,i)=tmp
				tmp=ret(1,j):ret(1,j)=ret(1,i):ret(1,i)=tmp
				tmp=ret(2,j):ret(2,j)=ret(2,i):ret(2,i)=tmp
				tmp=ret(3,j):ret(3,j)=ret(3,i):ret(3,i)=tmp
				tmp=ret(4,j):ret(4,j)=ret(4,i):ret(4,i)=tmp
			end if
		next
	next
	getBoardSources=ret
End Function

Sub Save2xmlFile(ByVal aArg)
	dim i,xml:xml="<?xml version=""1.0"" encoding=""gbk"" ?>"&vbcrlf&"<playerkinds>"&vbcrlf&_
	"<!--"&_
	"Maxcms4.0播放器支持格式说明："&vbcrlf&_
	"1.player节点为播放器，不可更改"&vbcrlf&_
	"2.flag属性不能更改，作为来源的标识"&vbcrlf&_
	"3.open属性表示启用或者关闭该来源，open=""1""为开启，open=""0""为关闭"&vbcrlf&_
	"4.intro节点为每个播放器的说明信息，可以自由更改"&vbcrlf&_
	"5.sort排序属性，值为数字,值越大越排前"&vbcrlf&_
	"-->"&vbcrlf
	for i=0 to Ubound(aArg,2)
		xml=xml&"	<player open="""&aArg(1,i)&""" sort="""&aArg(2,i)&""" flag="""&aArg(0,i)&""" des="""&aArg(4,i)&"""><intro><![CDATA["&aArg(3,i)&"]]></intro></player>"&vbcrlf
	next
	xml=xml&"</playerkinds>"
	CreateTextFile xml,"../inc/playerKinds.xml","gbk"
	if cacheStart=1 then:cacheObj.clearCache("array_playlist"):end if
End Sub

Function ifthen(b,a,c)
	if b=true then
		ifthen=a
	else
		ifthen=c
	end if
End Function
%>