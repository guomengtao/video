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
viewHead "���ݡ�ѹ������ԭ���ݿ�" & "-" & menuList(4,0)

dim action : action = getForm("action", "get")

Select  case action
	case "del" : delBak
	case "bakup" : bakUp
	case "delall" : delAll
	case "restore" : restore
	case "compress" : compress
	case else : main
End Select 
viewFoot


Sub main
	dim path,fileListArray,i,arrayLen,fileAttr
	path = "../inc/databasebak"
	if not isExistFolder(path) then createFolder path,"folderdir"
	fileListArray= getFileList(path)
	arrayLen = ubound(fileListArray)
%>
<div id="append_parent"></div>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(4,0)%>&nbsp;&raquo;&nbsp;���ݡ�ѹ������ԭ���ݿ�';</script>
<%
if instr(fileListArray(0),",")>0 then
%>
<form action="?action=delall" method="post">
<table class="tb">
<tr class="thead"><th colspan="5">���ݡ�ѹ������ԭ���ݿ�(�˹���ֻ��access���ݿ���Ч)</th></tr>
    <TR >
      <TD  align="center">ID</TD>
      <TD align="center">�����ļ���</TD>
      <TD align="center">�ļ���С</TD>
       <TD align="center">����ʱ��</TD>
       <TD  align="center">����</TD>
    </TR>
		<%
        for  i = 0 to arrayLen
            fileAttr=split(fileListArray(i),",")
        %>
      <TR align="center">
      <TD><input type="checkbox" value="<%=fileAttr(4)%>" name="id"  checked="true" class="checkbox" /></TD>
      <TD><%=fileAttr(0)%></TD>
       <TD><%=fileAttr(2)%></TD>
        <TD><% isCurrentDay(fileAttr(3))%></TD>
       <TD><a href="?action=restore&path=<%=fileAttr(4)%>">��ԭ</a>  <a href="?action=del&path=<%=fileAttr(4)%>">ɾ��</a></TD>
    </TR>
		<%
        next
        %> 
    <tr><td colspan="5"  >ȫѡ<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','id')" />��ѡ<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','id')" /><input type="submit" value="����ɾ��" onclick="if(confirm('ȷ��Ҫɾ����')){return true;}else{return false}" class="btn"  />&nbsp;&nbsp;</td></tr>
</TABLE>
</form> 
    <%
	else
		echo "<table class=""tb""><tr class=""thead""><th colspan=""5"">���ݡ�ѹ������ԭ���ݿ�</th></tr><tr  ><td colspan=""5"" algin=""center"">û�б����ļ�</td></tr></table>"
	end if
	%>
<table>
<tr><td colspan="2">
<input type="button"  onClick="self.location.href='?action=bakup'"  value="�������ݿ�" class="btn" />
<input type="button"  onClick="self.location.href='?action=compress'"  value="ѹ�����ݿ�" class="btn"  />
</td></tr></table>
<%
End Sub

Sub chkType
	if databasetype <> 0 then alertMsg "�������ݿ��access,����ʹ�ô˹���","admin_database.asp":die ""
End Sub

Sub  delBak
	chkType
	dim path
	path = getForm("path","get")
	delFile path
	alertMsg "","admin_database.asp"
End Sub


Sub bakUp
	chkType
	dim timeStr
	timeStr = timeToStr(now())
	moveFile accessFilePath,"../inc/databasebak/"&timeStr&"_bak.asp",""
	alertMsg "���ݳɹ�","admin_database.asp"
End Sub


Sub restore
	chkType
	dim path
	path = getForm("path","get")
	moveFile path,accessFilePath,""
	alertMsg "�ָ��ɹ�","admin_database.asp"
End Sub


Sub compress
	chkType
	dim engineObj,tempDbPath
	tempDbPath = "../inc/maxcms2.asp"
	conn.Class_Terminate
	set engineObj = server.CreateObject("JRO.JetEngine")
	engineObj.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.MapPath(accessFilePath),"Provider=Microsoft.Jet.OLEDB.4.0;Data Source="& server.MapPath(tempDbPath)
	moveFile tempDbPath,accessFilePath,"del" 
	set engineObj = Nothing
	alertMsg "ѹ���ɹ�","admin_database.asp"
End Sub

Sub delAll
	chkType
	dim ids,idsArray,arrayLen,i
	ids=replace(getForm("id","post")," ","")
	idsArray = split(ids,",") : arrayLen=ubound(idsArray)
	for i=0 to arrayLen
		delFile idsArray(i)
	next
	alertMsg "ɾ�����","admin_database.asp"
End Sub


%>