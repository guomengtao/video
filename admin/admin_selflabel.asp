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
viewHead "�Զ����ǩ����" & "-" & menuList(2,0)

dim action,keyword : action = getForm("action", "get")

dim id,page,errorInfo,errorSelflabel : errorInfo="��Ϣ��д������������":errorSelflabel="�Ѿ����ڴ˱�ǩ�����������"

Select  case action
	case "add" : addSelfLabel
	case "del" : delSelfLabel
	case "delall" : delAll
	case "edit" : editSelfLabel
	case "editsave" : editSave
	case "addsave" : addSave
	case else : main : popDiv
End Select 
viewFoot

Sub main
	dim dl,linkArray,i,n,m_id
	id=getForm("id","get"):page=getForm("page","get") 
	if isNul(page) then page=1
	if page<1 then page=1 else page=clng(page)
	set dl = mainClassobj.createObject("MainClass.DataPage")
	dl.Query "SELECT m_id,m_name,m_content,m_des,m_addtime FROM {pre}selflabel ORDER BY m_id DESC"
	dl.absolutepage=page:dl.pagesize=30
	linkArray = dl.GetRows()
	if page > dl.pagecount then page=dl.pagecount
%>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(2,0)%>&nbsp;&raquo;&nbsp;�Զ����ǩ����';</script>

<table align="left"><tr><td><input type="button" value="�����Զ����ǩ" onClick="location.href='?action=add'" class="btn" /></td></tr></table>
<%
	if dl.recordcount>0 then
		n=ubound(linkArray,2) 
%>
<form name="selflabelform" method="post">
<table class="tb">
<tr class="thead"><th colspan="6">�Զ����ǩ����</th></tr>
    <TR align="center">
      <TD>ID</TD>
      <TD>����</TD>
       <TD>��ǩ����</TD>
       <TD>����</TD>
       <TD>����ʱ��</TD>
      <TD>����</TD>
    </TR>
    <%
		for i=0 to n
			m_id= trim(linkArray(0,i))
	%>
    <TR id="adtr<%=m_id%>" name="adtr" <%if id=m_id then %> class="editlast"<%end if%> align="center">
      <TD><input type="checkbox" value="<%=m_id%>" name="m_id"  class="checkbox" /><%=m_id%></TD>
      <TD><%=linkArray(1,i)%></TD>
      <TD><%="{self:"&linkArray(1,i)&"}"%></TD>
      <TD><%=linkArray(3,i)%></TD>
      <TD><%isCurrentDay(linkArray(4,i))%></TD>
      <TD><a href="#" onclick="viewCurrentAdTr('<%=m_id%>');copyToClipboard('<%="{self:"&linkArray(1,i)&"}"%>');">���ñ�ǩ</a> <a href="#" onClick="viewCurrentAdTr('<%=m_id%>');openSelfLabelWin('selflabel','<%=m_id%>')">�鿴����</a>&nbsp;&nbsp;<a href="?action=edit&page=<%=page%>&id=<%=m_id%>">�༭</a>&nbsp;&nbsp;<a  onclick="if(confirm('ȷ��Ҫɾ����')){return true;}else{return false;}" href="?action=del&id=<%=m_id%>">ɾ��</a></TD>
    </TR>
    <%
		next
	%>
    <tr bgcolor="#FFFFFF"align="center">
    <td  colspan="6"><div class="cuspages center"><div class="pages">ȫѡ<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />��ѡ<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" /><input type="submit" value="����ɾ��" onclick="if(confirm('ȷ��Ҫɾ����')){selflabelform.action='?action=delall';}else{return false}" class="btn"  />&nbsp;&nbsp;ҳ��<%=page%>/<%=dl.pagecount%> ÿҳ<%=dl.pagesize%>����¼������<%=dl.recordcount%> <a href="?page=1">��ҳ</a> <a href="?page=<%=(page-1)%>">��һҳ</a> <%=makePageNumber(page, 15, dl.pagecount, "selflabellist")%><a href="?page=<%=(page+1)%>">��һҳ</a> <a href="?page=<%=dl.pagecount%>">βҳ</a></div></div></td></tr>
</TABLE>
</form>
<%
	else
		echo "<table class='tb'><tr><td>û���Զ����ǩ</td></tr></table>"		
	end if	
%>
</div>
<%
	set dl = nothing
End Sub

Sub popDiv
%>
<div id="selflabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('selflabel').style.display='none'" />�Զ����ǩ·�� </div>
    <div class="popbody"><div><textarea cols="80" rows="14" id="labelcontent" style="width:516px"></textarea></div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>
<%	
End Sub

Sub addSelfLabel
%>
<div class="container" id="cpcontainer">
<form action="?action=addsave" method="post" >
<table class="tb">
<tr class="thead"><th colspan="2">�����Զ����ǩ</th></tr>
    <TR>
      <TD vAlign=center width="11%" >�Զ����ǩ���ƣ�</TD>
      <TD width="89%" ><input type="text" size="50" name="m_name" />(����дӢ����ĸ������)<font color="red">��</font></TD>
    </TR>
 
    <TR>
      <TD >�Զ����ǩ������</TD>
      <TD ><input type="text" size="100" name="m_des" /></TD>
    </TR>
    <TR>
      <TD >�Զ����ǩ���ݣ� </TD>
      <TD ><textarea name="m_content"  cols="100" rows="20" ></textarea><font color="red">��</font><br />
      ���ϣ��ͬʱ������������ʾ����ʹ��$$$���� 
      </TD>
    </TR>
    <TR >
      <td></td><TD><input type="submit" value="�����Զ����ǩ" class="btn" />
      &nbsp;<input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></TD>
    </TR>
</td></tr></table>
</form>
</div>
<%
End Sub


Sub editSelfLabel
	id=getForm("id","get") : page = getForm("page","get")
	dim rsObj : set rsObj=conn.db("select * from {pre}selflabel where m_id="&id,"execute")
%>
<div class="container" id="cpcontainer">
<form action="?action=editsave&id=<%=id%>&page=<%=page%>" method="post" >
<table class="tb">
	<tr class="thead"><th colspan="2">�༭�Զ����ǩ</th></tr>
	<tr>
      <TD width="15%">�Զ����ǩ���ƣ�</TD>
      <TD><input type="text" size="50" name="m_name" value="<%=rsObj("m_name")%>" /><font color="red">��</font></TD>
    </TR>

    <TR>
      <TD >�Զ����ǩ������</TD>
      <TD ><input type="text" size="100" name="m_des" value="<%=rsObj("m_des")%>" /></TD>
    </TR>
    <TR>
      <TD >�Զ����ǩ���ݣ�</TD>
      <TD ><textarea name="m_content"  cols="100" rows="20" ><%=decodeHtml(rsObj("m_content"))%></textarea><font color="red">��</font><br />
      ���ϣ��ͬʱ������������ʾ����ʹ��$$$���� </TD>
    </TR>
    <TR >
    <td></td> <TD ><input type="submit" value="�޸��Զ����ǩ" class="btn" />
      &nbsp;<input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></TD>
    </TR></table>
</form></div>
<%
	set rsObj=nothing
End Sub

Sub addSave
	dim m_name,m_des,m_content,sqlStr,num
	m_name = getForm("m_name","post"):m_des = getForm("m_des","post"):m_content=getForm("m_content","post")
	m_content=encodeHtml(m_content)
	if   isNul(m_name)     then  die errorInfo
	num = conn.db("select count(*) from m_selflabel where m_name='"&m_name&"'","execute")(0)
	if num>0 then  die errorSelflabel
	sqlStr = "insert into  {pre}selflabel(m_name,m_des,m_content,m_addtime) values ('"&m_name&"','"&m_des&"','"&m_content&"','"&now()&"')"
	conn.db sqlStr,"execute" 
	alertMsg "���ӳɹ�","admin_selflabel.asp"
End Sub

Sub delAll
	dim ids : ids=replaceStr(getForm("m_id","post")," ","")
	conn.db "delete from {pre}selflabel where m_id in ("&ids&")","execute" 
	alertMsg "","admin_selflabel.asp"
End Sub

Sub delSelfLabel
	dim filename
	id = getForm("id","get")
	conn.db  "delete from {pre}selflabel where m_id="&id,"execute"
	alertMsg "","admin_selflabel.asp"
End Sub


Sub editSave
	dim m_name,m_enname,m_des,m_content,sqlStr,num
	id=getForm("id","get") : page=getForm("page","get") : m_name = getForm("m_name","post"):m_des = getForm("m_des","post"):m_content=getForm("m_content","post")
	m_content=encodeHtml(m_content)
	if   isNul(m_name)    then  die errorInfo
	num = conn.db("select count(*) from m_selflabel where m_name='"&m_name&"' and m_id<>"&id,"execute")(0)
	if num>0 then  die errorSelflabel
	sqlStr = "update {pre}selflabel set m_name='"&m_name&"',m_des='"&m_des&"',m_content='"&m_content&"',m_addtime='"&now()&"' where m_id="&id
	conn.db sqlStr,"execute" 
	alertMsg "�޸ĳɹ�","admin_selflabel.asp?id="&id&"&page="&page
End Sub
%>
</div>