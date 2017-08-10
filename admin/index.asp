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
dim action
action = getForm("action", "get")
Select case action
	case "login" : login
	case "check" : checkLogin
	case "logout" : clearPower
	case "notice" : notice
	case else : main
End Select
terminateAllObjects

Sub getCurrVersion()
	on error resume next
	dim xmlobj:SET xmlobj=mainClassobj.createObject("MainClass.Xml"):xmlobj.load "imgs/version.xml","xmlfile"
	Dim CurrVersion:CurrVersion = trim(xmlobj.getNodeValue("maxcms/version", ""))
	echo "<script type=""text/javascript"">var MAXCMSVERSION='"&CurrVersion&"',BACKMSG='False';function backcall(){window.setTimeout(function (){checkNewVersionCallBack({responseText:BACKMSG})},1000)}</script>"&vbcrlf&"<script language=""javascript"" src="""&updateUrl&"/ma"&"xcmsv"&"er2"&".5.js?t="&timer()&""" charset=""gbk""></script>"&vbcrlf&"<script type=""text/javascript"">backcall();</script>"
	SET xmlobj=Nothing
End Sub

Sub notice
	checkPower
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>后台管理中心-MaxCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<meta name="robots" content="noindex,nofollow" />
<link href="imgs/admin.css" rel="stylesheet" type="text/css" />
<script src="../js/common.js" type="text/javascript"></script>
<script src="imgs/main.js" type="text/javascript"></script>
<script src="imgs/drag.js" type="text/javascript"></script>
</head>
<body>
<div class="container" id="cpcontainer">
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页';</script>
    <table class="tb">
        <tr class="thead"><td colspan="4"><script type="text/javascript" src="http://u.maxcms.co/htad/htad01.js"></script></td></tr>
    	<tr class="thead"><td colspan="4">升级信息</td></tr>
    	<tr><td colspan="4"><div style="float:left">当前使用版本：Maxcms5.2.&nbsp;&nbsp;</div><a href="http://www.maxcms.co/forum-2-1.html" target="_blank">查看最新版程序</a></td></tr>
        <tr class="thead"><td colspan="4">站点信息</td></tr>
        <tr>
            <td width="90">服务器类型：</td><td width="400"><%=Request.ServerVariables("OS")%>(IP:<%=Request.ServerVariables("LOCAL_ADDR")%>)</td>
            <td width="90">脚本解释引擎：</td><td><%=ScriptEngine & "/"& ScriptEngineMajorVersion &"."&ScriptEngineMinorVersion&"."& ScriptEngineBuildVersion %></td>
        </tr>
        <tr>
            <td>站点物理路径：</td><td><%=request.ServerVariables("APPL_PHYSICAL_PATH")&replaceStr(sitePath,"/","\")%></td>
            <td>服务器名：</td><td><%=Request.ServerVariables("SERVER_NAME")%></td>
        </tr>
        <tr>
            <td>FSO对象：</td><td><%If Not isInstallObj(FSO_OBJ_NAME) Then%><font color="#FF0066"><b>×</b></font><%else%><b>√</b><%end if%></td>
            <td>数据库使用：</td><td><%If Not isInstallObj(CONN_OBJ_NAME) Then%><font color="#FF0066"><b>×</b></font><%else%><b>√</b><%end if%></td>
        </tr>
		<tr>
            <td>Stream对象：</td><td><%If Not isInstallObj(STREAM_OBJ_NAME) Then%><font color="#FF0066"><b>×</b></font><%else%><b>√</b><%end if%></td>
            <td>Dictionary对象：</td><td><%If Not isInstallObj(DICTIONARY_OBJ_NAME) Then%><font color="#FF0066"><b>×</b></font><%else%><b>√</b><%end if%></td>
        </tr>
			<tr>
            <td>Persits.jpeg ：</td><td><%If Not isInstallObj(JPEG_OBJ_NAME) Then%><font color="#FF0066"><b>×</b></font><%else%><b>√</b><%end if%></td>
            <td>XMLDOM版本：</td><td><%=mainClassObj.createobject("MainClass.xml").getXmlDomVer()%></td>
        </tr>
        </tr>
		<tr style="display:none">
            <td>最后更新人气：</td>
			<td><script language="javascript" src="imgs/last_clear_lock.js?<%=timer()%>"></script>
				<script language="javascript">
				var x=window.HitLastUpdateTime,d=new Date();
					if(!x){
						document.write('从未更新');
						(new Image()).src='admin_ajax.asp?action=cleartophit&do=d';
					}else{
						var ld=new Date(x),ad=parseInt((d.getTime()-ld.getTime()) / 84000000);
						document.write(ld.toLocaleString());
						if(ld.toLocaleDateString()!=d.toLocaleDateString()){
							(new Image()).src='admin_ajax.asp?action=cleartophit&do=d'+(ld.getDay()==0 || ad>7 ? 'w' : '')+(d.getDate()==0 || ad>30 ? 'm' : '');
						}
					}
				</script></td>
            <td></td><td></td>
        </tr>
    </table>
   
    <h4 class="mt20">☆★☆</h4>
    <ul class="news pub_ulist"><script type="text/javascript" src="http://u.maxcms.co/htad/htad02.js"></script></ul>
</div>
<%
	if rcookie("m_level")=0 then:getCurrVersion:end if
	viewFoot
End Sub

Sub checkLogin
	dim username,pwd,bRem,ip,errStr,rsObj,random,errFlag,agent
	agent=getAgent : errFlag = false : errStr="<br>"
	if isOutSubmit then  errFlag = true : errStr = errStr&"非法外部提交被禁止<br>"
	username = replaceStr(getForm("input_name","post"),"'","") : pwd = replaceStr(getForm("input_pwd","post"),"'","") : ip = getIp : bRem=getForm("input_rem","post")="true"
	if isNul(username) or isNul(pwd) then errFlag = true : errStr = errStr&"用户名或密码为空<br>"
	set rsObj = conn.db("select * from {pre}manager where m_username='"&username&"'","records1")
	if rsObj.eof then 
		 errFlag = true : errStr = errStr&"用户名或密码不正确<br>"
	else
		if clng(rsObj("m_state")) = 0 then errFlag = true : errStr = errStr&"管理员被锁定<br>"
		if len(rsObj("m_pwd"))>25 then  pwd=md5(pwd,32) else pwd=pwd
		if trim(rsObj("m_pwd")) <> pwd then errFlag = true : errStr = errStr&"用户名或密码不正确<br>"
		if not errFlag then
			randomize
			random = md5(rnd*99999999,32)
			conn.db "update {pre}manager set m_logintime='"&now()&"',m_loginip='"&ip&"',m_random='"&random&"' where m_username='"&username&"'","execute"
			if bRem then
				wCookieInTime "m_username",rsObj("m_username"),"d",365
				wCookieInTime "m_id",rsObj("m_id"),"d",365
				wCookieInTime "m_level",rsObj("m_level"),"d",365
				wCookieInTime "check"&rCookie("m_username"),md5(agent&ip&random,32),"d",365
			else
				wCookie "m_username",rsObj("m_username")
				wCookie "m_id",rsObj("m_id")
				wCookie "m_level",rsObj("m_level")
				wCookie "check"&rCookie("m_username"),md5(agent&ip&random,32)
			end if
			if clng(rsObj("m_level"))=0 then 
				if selfManageDir="admin/" then alertMsg "您的后台目录名为admin，具有很大安全隐患，请尽快更改后台目录名以保证安全!\n\n建议：目录名设为6位以上、尽量复杂一些！",""
			end if
			echo "<script>top.location.href='index.asp';</script>"
		end if
	end if
	echoErr "登陆错误","自定义错误",errStr
End Sub

Sub login
if rCookie("m_username")<>"" then
	die "<script>top.location.href='index.asp';</script>"
end if
%>
<html>
<head>
<title>后台登陆中心</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<meta name="robots" content="noindex,nofollow" />
<style>
html,body,div,form,fieldset,input{margin:0;padding:0}
body{text-align:center;background-color:#001e3b;overflow:hidden;text-align:center}
.wrap{width:1003px;margin:0 auto;clear:both;background:url(imgs/login_01.jpg) no-repeat center top;text-align:center}
img,fieldset	{border:none}
input{background-color:transparent;border:none;cursor:pointer;font-size:14px;padding-top:4px;color:#88D2EB;font-weight:600}
#lay01{height:80px}
#lay02{background-image:url(imgs/login_02.jpg);height:90px}
#lay03{background-image:url(imgs/login_03.jpg);height:126px}
#lay04{background-image:url(imgs/login_04.jpg);height:123px}
	#layform{width:645px;height:123px;margin:0 auto;position:relative;}
		#input_name	{left:196px;position:absolute;top:40px;width:166px;height:26px;}
		#input_pwd	{left:196px;position:absolute;top:91px;width:166px;height:26px}
		#input_remdiv {left:420px;position:absolute;top:100px;color:#FFF;font-size:14px;}
		#input_sub	{left:423px;position:absolute;top:56px;width:153px;height:39px;background:url(imgs/login_btn.png) no-repeat;text-indent:-20em}
#lay05{background-image:url(imgs/login_05.jpg);height:78px}
#lay06{background-image:url(imgs/login_06.jpg);height:87px}
#lay07{background-image:url(imgs/login_07.jpg);height:77px}
</style>
</head>
<body>
<div class="wrap" id="lay01"></div>
<div class="wrap" id="lay02"></div>
<div class="wrap" id="lay03"></div>
<div class="wrap" id="lay04">
	<div id="layform">
		<form method="post" action="?action=check" name="formsearch">
		<fieldset>
			<input name="input_name" type="text" id="input_name" tabindex="1" />
			<input name="input_pwd" type="password" id="input_pwd" tabindex="2" />
			<div id="input_remdiv">
				<input name="input_rem" type="checkbox" id="input_rem" value="true" tabindex="3" /><label for="input_rem">记住登陆</label>
			</div>
			<input name="input_sub" type="submit" id="input_sub" value="登录" tabindex="4" />
		</fieldset>
		</form>
	</div>
</div>
<div class="wrap" id="lay05"></div>
<div class="wrap" id="lay06"></div>
<div class="wrap" id="lay07"></div>
<script src="imgs/admin.js" type="text/javascript"></script>
<script type="text/javascript">focusLogin();</script>
</body>
</html>
<%
End Sub

Sub main
	checkPower
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>后台管理中心-MaxCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<meta name="robots" content="noindex,nofollow" />
<link rel="stylesheet" href="imgs/admin.css" type="text/css" media="all" />
<script src="../js/common.js" type="text/javascript"></script>
<script src="imgs/admin.js" type="text/javascript"></script>
<script src="imgs/main.js" type="text/javascript"></script>
<script src="imgs/drag.js" type="text/javascript"></script>
<style type="text/css">
#gMenuMap{text-align:left;}
#gMenuMap a{color:#666;}
.fm3,.fm4{background:url(imgs/34.gif) no-repeat;width:7px;display:block;cursor:pointer}
.fm4{background-position:-6px 0}
.menutd2{background:#DEECF6 url(imgs/leftbg.png) repeat-y -171px 0}
</style>
</head>
<body style="margin: 0px" scroll="no">
<table cellpadding="0" cellspacing="0" width="100%" height="100%">
  <tr>
    <td colspan="3" height="90"><div class="header">
        <div class="logo" onclick="window.open('../');" style="cursor:pointer;">后台管理中心-MaxCMS</div>
        <div class="pannel">
          <p>您好<em><%=rCookie("m_username")%></em><% if clng(rCookie("m_level"))=0 then %>(系统管理员)<% else %>(网站编辑)<%end if%>&nbsp;&nbsp;&nbsp;&nbsp;<em><span onclick="clearCache()" style="cursor:pointer"><font color="#FF0000">[更新缓存]</font></span></em><span id="upcacheresult" style="color:#FF0000"></span>&nbsp;&nbsp;<a href="http://www.maxcms.co" target="_blank"><font color="red">[Maxcms.co]</font></a> [<a href="index.asp?action=logout" target="_top">退出</a>] [<a href="../" target="_blank">网站首页</a>]&nbsp;&nbsp;<a href="javascript:void(0);" onclick="view('gMenuMap');selfLabelWindefault('gMenuMap');"><img width="72"  height="18"  src="imgs/btn_map.gif" title="系统功能地图"  style="margin-bottom:-4px;"  /></a></p>
         </div>
        <div class="navbg"></div>
        <div class="nav">
          <!--上部菜单 changeMenu(左侧菜单id号后部分，右侧默认打开的url)-->
          <ul id="topmenu">
            <%
				dim bigMenuArray,bigMenuI,bigMenuFlag,bigMenuNum,bigMenuFlagStr : bigMenuArray=getBigMenuInfo(rCookie("m_level"))
				bigMenuNum=ubound(bigMenuArray,1)
				for bigMenuI=0 to bigMenuNum
					bigMenuFlag=bigMenuArray(bigMenuI,1)
					if bigMenuI=0 then bigMenuFlagStr="'"&bigMenuFlag&"'" else bigMenuFlagStr=bigMenuFlagStr&","&"'"&bigMenuFlag&"'"
			%>
            <li><em><a href="#" id="header_<%=bigMenuFlag%>" onClick="changeMenu('<%=bigMenuFlag%>', '<%=bigMenuArray(bigMenuI,2)%>');"><%=bigMenuArray(bigMenuI,0)%></a></em></li>
            <%
				next
			%>
          </ul>
          <!--当前所在位置导航 js动态插入-->
          <div class="iamhere">
            <p id="admincpnav">　</p>
          </div>
          <div class="navbd"></div>
        </div>
      </div></td>
  </tr>
  <tr>
    <td class="menutd" id="menutd" valign="top" width="171"><div id="leftmenu" class="menu" style="width:171px">
        <!--左菜单 ul id号为menu_XXXX形式，XXXX与上部导航菜单传递参数、JS中topMenus数组一至，li a中的链接与上部导航菜单传递参数一至-->
        <%
			dim smallMenuArray,smallMenuNum,smallMenuI,sSmallMenuArr,sSmallMenuArr2,sSmallMenuArrLen
			smallMenuArray=getSmallMenuInfo(rCookie("m_level"))
			for bigMenuI=0 to bigMenuNum 
				bigMenuFlag=bigMenuArray(bigMenuI,1)
		%>
        <ul id="menu_<%=bigMenuFlag%>" style="display: none">
        <%
				sSmallMenuArr=split(smallMenuArray(bigMenuI),"|")
				sSmallMenuArrLen=ubound(sSmallMenuArr)
				for smallMenuI=0 to sSmallMenuArrLen
					if isNul(sSmallMenuArr(smallMenuI)) then 
                    	echo "<li class=""menuspace""><a></a></li>"
					else
						sSmallMenuArr2=split(sSmallMenuArr(smallMenuI),",")
		%>
          <li><a href="<%=sSmallMenuArr2(1)%>" target="main"><%=sSmallMenuArr2(0)%></a></li>
        <%
		 			end if 
				next
		%>
        </ul>
        <%
			next
		%>
      </div>
		<div class="footer">
		  <p>Powered by <a href="http://www.rinuo.com" target="_blank">Rinuo.Co</a></p>
		</div>
	  </td>
	<td class="menutd2" valign="middle" width="9"><span id="fm" class="fm3" onclick="tooglemenutd(this)" title="点此伸缩左侧菜单栏"> </span></td>
	<td valign="top" class="maincontent"><iframe src="?action=notice" name="main" width="100%" height="100%" frameborder="0"scrolling="yes" style="overflow: visible;"></iframe></td>
 </tr>
</table>
<div id="gMenuMap" class="popdiv" style="width:900px;top:100px;z-index:1000; display:none;">
</div>
<script type="text/JavaScript">
	var dc=$('menutd');
	var topMenus = new Array(<%=bigMenuFlagStr%>);//大菜单参数数组
	var menu_key = initMenu('leftmenu');//初始化
	changeMenu(menu_key ? menu_key : 'index');
	//初始化左侧菜单高度
	var tt=0
	$("leftmenu").style.height=document.body.clientHeight-90-7-33+"px";
	var  resizeTimer = null;
	function doResize(){
	  $("leftmenu").style.height=document.body.clientHeight-90-7-33+"px";;resizeTimer=null
	}
	window.onresize = function(){
	   if(resizeTimer==null){
			resizeTimer = setTimeout("doResize()",300);
		}
	}
	function MarkMenuMap(){
		var hrefs, s;
		s = '<div class="poptitie"><img src="../pic/btn_close.gif" onClick="hide(\'gMenuMap\');" />后台功能地图</div><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb2"  ><tr>';
		s += '<td width="10" valign="top"><h4>&nbsp;</h4></td>';
		for(var i=0;i<topMenus.length;i++){
			s += '<td valign="top" width="150"><ul class="cmblock"><li><h4>' + $('header_' + topMenus[i]).innerHTML + '</h4></li>';
			hrefs = $('menu_' + topMenus[i]).getElementsByTagName('a');
			for(var j = 0; j < hrefs.length; j++) {
				s += hrefs[j].innerHTML!='' ? '<li><a href="'+hrefs[j].href+'" onclick="hide(\'gMenuMap\');changeMenu(\'' + topMenus[i] + '\',\''+hrefs[j].href+'\')" target="' + hrefs[j].target + '">' + hrefs[j].innerHTML + '</a></li>' : '';
			}
			s += '<li>&nbsp;</li></ul></td>';
		}
		s += '</tr></table>';
		return s;
	}
	function getClientWidth(){
		return document.body.clientWidth;
	}
	function selfLabelWindefault(divid){
		$(divid).style.left=(getClientWidth()-$(divid).offsetWidth)/2+"px";
		$(divid).style.top=(getScroll()+100)+"px";
	}
	$('gMenuMap').innerHTML=MarkMenuMap();
	function tooglemenutd(){
		dc.style.display = dc.style.display != 'none' ? 'none' : '';
		$('fm').className = dc.style.display != 'none' ? 'fm3' : 'fm4';
		setCookie('MENUON',dc.style.display != 'none' ? '' : '1',365*24);
	}
	if(getCookie('MENUON')=='1'){
		dc.style.display = 'none';
		$('fm').className = 'fm4';
	}
</script>

</body>
</html>
<%
End Sub
%>