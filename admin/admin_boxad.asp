<!--#include file="admin_inc.asp"-->
<!-- u_a_zones<->m_c_aid     u_a_client<->m_c_uid -->
<% 
'******************************************************************************************
' Software name: Max(马克斯) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: 石头(maxcms2008@qq.com),yuet,长明,酒瓶
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************
checkPower
dim regExpObj : set regExpObj= new RegExp : regExpObj.ignoreCase = true : regExpObj.Global = true 
dim templateobj,playerJsPath,playerzones : set templateobj = mainClassObj.createObject("MainClass.template")
playerJsPath="../js/play.js" 
dim configStr:configStr=loadFile(playerJsPath) 
dim action : action = getForm("action", "get") 
select case action
	case "up"  call up
	case "del" call del
	case else call main
end select
%>
<% sub main 
dim tabletitle,submittext,helptext
if clng(regexFind(configStr,"var\s+m_c_aid='(\d*?)'"))>0 then 
	tabletitle = "修改盒子广告&nbsp;&nbsp;&nbsp;&nbsp;<a href=""?action=del"">删除盒子广告</a>"
	submittext = "修改"
	helptext = "在此填写盒子广告代码"
else
	tabletitle = "添加盒子广告"
	submittext = "添加"
	helptext = "在此填写盒子广告代码"
end if%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=gbk" />
<title>盒子广告-MaxCms后台管理</title>
<link href="imgs/admin.css" rel="stylesheet" type="text/css" />
<script src="../js/common.js" type="text/javascript"></script>
<script src="img/main.js" type="text/javascript"></script>
<script type="text/javascript">
window.onload=function()
{
$('jsform').onsubmit = function(){	if ($('jscoder').value.length==0) {alert('请正确填写代码！');return false} }
$('jscoder').onfocus = function(){if($('isload').value == '1'){$('jscoder').innerHTML='';$('isload').value = '0'}} 
}
</script>
</head>
<body>

<div class="container" id="cpcontainer">
<!--当前导航-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(7,0)%>&nbsp;&raquo;&nbsp;盒子计划广告设置';</script>
<form id="jsform" name="jsform" method="post" action="?action=up">
<input type="hidden" name="isload" id="isload"  value="1"/>
<table width="400" class="tb">
  <tr class="thead">
    <td colspan="2"><%= tabletitle%> </td>
    </tr>
  <tr>
    <td width="10%">盒子广告代码</td>
    <td width="90%">&nbsp;
      <textarea name="jscoder" id="jscoder" cols="90" rows="10"><%= helptext %></textarea><br /></td>
  </tr>
  <tr>
    <td colspan="2"><input type="submit" class="btn" name="button" id="button" value=" <%=submittext %> " /> 
    <a href="http://bbs.bokecc.com/viewthread.php?tid=93853" target="_blank">申请马克斯盒子广告前，请查看<font color="red">广告招募要求</font></a></td>
    </tr>
</table>
</form>

</div>
</body>
</html>
<% end sub 
'**************************************************
'函数名：getformvalue
'作  用：通过正则检索上一页面文本域的特殊值
'参  数：textname-----文本域  vreg-------正则
'注意：本函数返回$1 如做其他需求请更改，并本函数依赖本页面全局变量
'**************************************************
function getformvalue(textname,vreg)
	dim matches,match
	dim str : str = getForm(textname,"post")
	regExpObj.Pattern = vreg
	set matches = regExpObj.Execute(str)
	if (matches.count)> 0 then
		for each match in matches 
			getformvalue = match.submatches(0)
		next
	else
		getformvalue = ""
	end if 
end function
'**************************************************
'函数名：add
'作  用：在paly.js文件中寻找特定字段，替换或添加
'参  数：vobject-----字段名  vreg-------正则   vvalue --------值  vcomment ---注释
'注意：本函数依赖本页面全局变量
'**************************************************
function add(vobject,vreg,vvalue,vcomment)
	dim playerzones : playerzones=regexFind(configStr,vreg)
	if not(isnul(playerzones))  then
		configStr=templateobj.regExpReplace(configStr,vreg,"var "&vobject&"='"&vvalue&"'")
	else
		configStr = "var "&vobject&"='"&vvalue&"';//"&vcomment&vbcrlf&configStr
	end if 
end function
'**************************************************
'函数名：downflash
'作  用：下载远端文件
'参  数：vurl-----远端文件地址  vpath-------路径
'注意：本函数依赖本页面全局变量
'**************************************************
sub downflash(vurl,vpath)
	dim imgStream : imgStream=getRemoteContent(vurl,"body")
	createStreamFile imgStream,vpath
end sub

sub del
	configStr=templateobj.regExpReplace(configStr,"var\s+m_c_aid='(\d*?)';\s*\/\/盒子计划 广告ID"&vbcrlf,"")
	configStr=templateobj.regExpReplace(configStr,"var\s+m_c_uid='(\d*?)';\s*\/\/盒子计划 用户ID"&vbcrlf,"")
	createTextFile configStr,playerJsPath,""
	alertMsg "盒子广告删除成功","admin_boxad.asp" 
end sub
'**************************************
'修改js文件
'**************************************
sub up
	dim m_c_aid : m_c_aid = getformvalue("jscoder","u_a_zones=""(\d*?)""")
	dim m_c_uid : m_c_uid =  getformvalue("jscoder","u_a_client=""(\d*?)""")
	if (m_c_uid = "" or m_c_aid = "")and getForm("action","get")="up" then
		echoErr "错误的参数","未知id","您填写的js代码不规范！" 
	end if 
	'添加或替换参数
	add "m_c_aid","var\s+m_c_aid='(\d*?)'",m_c_aid,"盒子计划 广告ID"
	add "m_c_uid","var\s+m_c_uid='(\d*?)'",m_c_uid,"盒子计划 用户ID"
	'写入js文件
	createTextFile configStr,playerJsPath,""
	set templateobj = nothing
	'call downflash("http://www.chyip.gov.cn/images/banner.swf","../inc/a.swf")
	alertMsg "盒子广告添加成功","admin_boxad.asp" 
end sub

%>