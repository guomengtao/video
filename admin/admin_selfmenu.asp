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
viewHead "�Զ����ݲ˵�" & "-" & menuList(3,0)

dim action : action = getForm("action", "get")

Select  case action
	case "modify" : modifyMenu
	case else : main
End Select 
viewFoot

Sub main
	dim menuStr : menuStr=replaceStr(mid(getSelfMenu(clng(rCookie("m_level"))),2),"|",vbcrlf)
%>
<div id="append_parent"></div>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(3,0)%>&nbsp;&raquo;&nbsp;�Զ����ݲ˵� ';</script>
 <table class="tb">
<tr class="thead"><th colspan="2">�Զ����ݲ˵�</th></tr>
<tr><td width="25%">1.��ʽ���˵�����,�˵����ӵ�ַ</td>
<td width="75%">2.ÿ����ݲ˵���ռһ��</td>
</tr>
  <form action="?action=modify" method="post"  >
   
    <tr>
      <td colspan="2"><textarea  name="menustr" style="width:100%;font-family: Arial, Helvetica, sans-serif;font-size: 14px;" rows="20" dataType="Require" msg="����д����"><%=menuStr%></textarea></td>
    </tr>
    <tr>
      <td> <input type="submit" name="Submit" value="��  ��" class="btn" /> <input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></td><td ></td>
    </tr>
  </form>
</table>
<%
End Sub

Sub modifyMenu
	dim menustr,xmlstr,menuNode,menuNodeArray,singleNodeArray,menuNodeStr,path:path=selfMenuXml
	menustr=trimOuterStr(getForm("menustr","post"),vbcrlf) : menustr=replaceStr(menustr,vbcrlf,"|")
	menuNodeArray=split(menustr,"|")
	for each menuNode in menuNodeArray
		menuNodeStr=menuNodeStr&"<menu>"&vbcrlf
		if not isNul(menuNode) then 
			singleNodeArray=split(replaceStr(menuNode,"��",","),",")
			menuNodeStr=menuNodeStr&"<name><![CDATA["&singleNodeArray(0)&"]]></name>"&vbcrlf&_
									"<link><![CDATA["&singleNodeArray(1)&"]]></link>"&vbcrlf
		else
			menuNodeStr=menuNodeStr&"<name></name>"&vbcrlf&_
									"<link></link>"&vbcrlf
		end if
		menuNodeStr=menuNodeStr&"</menu>"&vbcrlf
	next
	xmlstr="<?xml version=""1.0"" encoding=""gbk""?>"&vbcrlf&_
			"<maxcms2>"&vbcrlf&_
					"<menulist>"&vbcrlf&_
						menuNodeStr&_
					"</menulist>"&vbcrlf&_
			"</maxcms2>"&vbcrlf
	if clng(rCookie("m_level"))=1 then path=customMenuXml
	createTextFile  xmlstr,path,""
	echo "<script>alert('�޸ĳɹ�');top.location.href='index.asp';</script>"
End Sub
%>