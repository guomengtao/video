<!--#include file="admin_inc.asp"-->
<!-- u_a_zones<->m_c_aid     u_a_client<->m_c_uid -->
<% 
'******************************************************************************************
' Software name: Max(����˹) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ����
' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
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
	tabletitle = "�޸ĺ��ӹ��&nbsp;&nbsp;&nbsp;&nbsp;<a href=""?action=del"">ɾ�����ӹ��</a>"
	submittext = "�޸�"
	helptext = "�ڴ���д���ӹ�����"
else
	tabletitle = "���Ӻ��ӹ��"
	submittext = "����"
	helptext = "�ڴ���д���ӹ�����"
end if%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=gbk" />
<title>���ӹ��-MaxCms��̨����</title>
<link href="imgs/admin.css" rel="stylesheet" type="text/css" />
<script src="../js/common.js" type="text/javascript"></script>
<script src="img/main.js" type="text/javascript"></script>
<script type="text/javascript">
window.onload=function()
{
$('jsform').onsubmit = function(){	if ($('jscoder').value.length==0) {alert('����ȷ��д���룡');return false} }
$('jscoder').onfocus = function(){if($('isload').value == '1'){$('jscoder').innerHTML='';$('isload').value = '0'}} 
}
</script>
</head>
<body>

<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(7,0)%>&nbsp;&raquo;&nbsp;���Ӽƻ��������';</script>
<form id="jsform" name="jsform" method="post" action="?action=up">
<input type="hidden" name="isload" id="isload"  value="1"/>
<table width="400" class="tb">
  <tr class="thead">
    <td colspan="2"><%= tabletitle%> </td>
    </tr>
  <tr>
    <td width="10%">���ӹ�����</td>
    <td width="90%">&nbsp;
      <textarea name="jscoder" id="jscoder" cols="90" rows="10"><%= helptext %></textarea><br /></td>
  </tr>
  <tr>
    <td colspan="2"><input type="submit" class="btn" name="button" id="button" value=" <%=submittext %> " /> 
    <a href="http://bbs.bokecc.com/viewthread.php?tid=93853" target="_blank">��������˹���ӹ��ǰ����鿴<font color="red">�����ļҪ��</font></a></td>
    </tr>
</table>
</form>

</div>
</body>
</html>
<% end sub 
'**************************************************
'��������getformvalue
'��  �ã�ͨ�����������һҳ���ı��������ֵ
'��  ����textname-----�ı���  vreg-------����
'ע�⣺����������$1 ����������������ģ���������������ҳ��ȫ�ֱ���
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
'��������add
'��  �ã���paly.js�ļ���Ѱ���ض��ֶΣ��滻������
'��  ����vobject-----�ֶ���  vreg-------����   vvalue --------ֵ  vcomment ---ע��
'ע�⣺������������ҳ��ȫ�ֱ���
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
'��������downflash
'��  �ã�����Զ���ļ�
'��  ����vurl-----Զ���ļ���ַ  vpath-------·��
'ע�⣺������������ҳ��ȫ�ֱ���
'**************************************************
sub downflash(vurl,vpath)
	dim imgStream : imgStream=getRemoteContent(vurl,"body")
	createStreamFile imgStream,vpath
end sub

sub del
	configStr=templateobj.regExpReplace(configStr,"var\s+m_c_aid='(\d*?)';\s*\/\/���Ӽƻ� ���ID"&vbcrlf,"")
	configStr=templateobj.regExpReplace(configStr,"var\s+m_c_uid='(\d*?)';\s*\/\/���Ӽƻ� �û�ID"&vbcrlf,"")
	createTextFile configStr,playerJsPath,""
	alertMsg "���ӹ��ɾ���ɹ�","admin_boxad.asp" 
end sub
'**************************************
'�޸�js�ļ�
'**************************************
sub up
	dim m_c_aid : m_c_aid = getformvalue("jscoder","u_a_zones=""(\d*?)""")
	dim m_c_uid : m_c_uid =  getformvalue("jscoder","u_a_client=""(\d*?)""")
	if (m_c_uid = "" or m_c_aid = "")and getForm("action","get")="up" then
		echoErr "����Ĳ���","δ֪id","����д��js���벻�淶��" 
	end if 
	'���ӻ��滻����
	add "m_c_aid","var\s+m_c_aid='(\d*?)'",m_c_aid,"���Ӽƻ� ���ID"
	add "m_c_uid","var\s+m_c_uid='(\d*?)'",m_c_uid,"���Ӽƻ� �û�ID"
	'д��js�ļ�
	createTextFile configStr,playerJsPath,""
	set templateobj = nothing
	'call downflash("http://www.chyip.gov.cn/images/banner.swf","../inc/a.swf")
	alertMsg "���ӹ�����ӳɹ�","admin_boxad.asp" 
end sub

%>