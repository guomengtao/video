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
viewHead "����Ա����" & "-" & menuList(8,0)

dim action : action = getForm("action", "get")
dim errorInfo,errorPwd : errorInfo="��Ϣ��д������������" : errorPwd="�������벻һ��"
Select  case action
	case "del" : delmanager
	case "delall" : delAll
	case "edit" : main : edit
	case "save" : saveEdit
	case "add" : addManager
	case else : main : add
End Select 
viewFoot

dim id
Sub main
	dim Qe,managerArray,i,n,m_id
	id=getForm("id","get")
	set Qe =  mainClassobj.createObject("MainClass.DataPage")
	Qe.Query "SELECT * FROM {pre}manager ORDER BY m_logintime DESC"
	managerArray = Qe.GetRows()
	if Qe.recordcount then
		n=ubound(managerArray,2)
%>
<div id="append_parent"></div>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(8,0)%>&nbsp;&raquo;&nbsp;����Ա����';</script>
<form  method="post" name="managerform">
<table class="tb">
<tr class="thead"><th colspan="7">����Ա����</th></tr>
    <TR align="center">
      <TD>ID</TD>
      <TD>�û���</TD>
       <TD>�����¼ʱ��</TD>
       <TD>�����½IP</TD>
       <TD>����Ա����</TD>
       <TD>״̬</TD>
      <TD>����</TD>
    </TR>
		<%
        for i=0 to n
            m_id= trim(managerArray(0,i))
        %>
     <TR<%if id=m_id then %> class="editlast"<%end if%> align="center">
      <TD><input type="checkbox" value="<%=m_id%>" name="m_id"   class="checkbox" /><%=m_id%></TD>
      <TD><%=managerArray(1,i)%></TD>
      <TD><%isCurrentDay(managerArray(4,i))%></TD>
      <TD><%=managerArray(5,i)%> </TD>
      <TD><%=getManagerLevel(managerArray(6,i))%></TD>
      <TD><%=getManagerState(managerArray(3,i))%></TD>
      <TD><a   href="?action=edit&id=<%=m_id%>">�༭</a>&nbsp;&nbsp;<a onclick="if(confirm('ȷ��Ҫɾ����')){return true;}else{return false;}"  href="?action=del&id=<%=m_id%>">ɾ��</font></TD>
    </TR>
		<%
        next
        %>
          <tr><td colspan="7">ȫѡ<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />��ѡ<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" /><input type="submit" value="����ɾ��" onclick="if(confirm('ȷ��Ҫ����ɾ����')){managerform.action='?action=delall';}else{return false}" class="btn"  />&nbsp;&nbsp;</td></tr>
</TABLE>
</form> 
<%
	else
		echo "<table align='center' width='90%'><tr><td><font color='red'>û���κμ�¼</font></td></tr></table>"
	end if
	set Qe = nothing
End Sub

Sub add
%>
<form action="?action=add" method="post" >
<table class="tb mt20">
<tr class="thead"><th colspan="2">���ӹ���Ա</th></tr>
    <TR>
      <TD vAlign=center width="20%" >�û�����</TD>
      <TD ><input type="text" size="30" name="m_username" id="m_username"  onBlur="isExistUsername('')"/><span id="checkmanagername" style="color:#FF0000"><font color="red">��</font></span></TD>
    </TR>
    <TR>
      <TD >���룺</TD>
      <TD ><input type="password" size="30" name="m_pwd" /><font color="red">��</font></TD>
    </TR>
   
   <TR>
      <TD >����ȷ�ϣ�</TD>
      <TD ><input type="password" size="30" name="m_pwd2" /><font color="red">��</font></TD>
    </TR>
    <TR>
      <TD >����Ա����</TD>
      <TD ><label><input type="radio" size="20" name="m_level"  value="0" checked class="radio"/>ϵͳ����Ա(<font color="red">ӵ��ȫ��Ȩ��</font>)</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><input type="radio" size="20" name="m_level" value="1" class="radio" />��վ�༭(<font color="red">ֻӵ�����ݹ���Ȩ��</font>)</label><font color="red">��</font></TD>
    </TR>
    
    <TR align="center"  >
    <TD align="left" ></TD>
      <TD align="left" ><input type="submit" value="���ӹ���Ա" class="btn" />
      &nbsp;<input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></TD>
    </TR>
</td></tr></table>
</form>
<%
End Sub

Sub edit
	id=getForm("id","get")
	dim rsObj : set rsObj=conn.db("select * from {pre}manager where m_id="&id,"execute")
%>
<form action="?action=save&id=<%=id%>" method="post" name="editmanager" >
<table class="tb mt20">
<tr class="thead"><th colspan="2">�༭����Ա</th></tr>
    <TR>
      <TD vAlign=center width="20%" >�û�����</TD>
      <TD ><input type="text" size="30" name="m_username" value="<%=rsObj("m_username")%>" onBlur="isExistUsername('<%=id%>')"/><span id="checkmanagername" style="color:#FF0000"><font color="red">��</font></span></TD>
    </TR>
    <TR>
      <TD >���룺</TD>
      <TD ><input type="password" size="30" name="m_pwd" value="<%=rsObj("m_pwd")%>" /><font color="red">��</font></TD>
    </TR>
   
   <TR>
      <TD >����ȷ�ϣ�</TD>
      <TD ><input type="password" size="30" name="m_pwd2" value="<%=rsObj("m_pwd")%>" /><font color="red">��</font></TD>
    </TR>
    <TR>
      <TD >����Ա����</TD>
      <TD ><label><input type="radio" size="20" name="m_level" class="radio"  value="0" <% if rsObj("m_level")=0 then %> checked <%end if%>/>ϵͳ����Ա(<font color="red">ӵ��ȫ��Ȩ��</font>)</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><input type="radio" class="radio" size="20" name="m_level" value="1"  <% if rsObj("m_level")=1 then %> checked <%end if%> />��վ�༭(<font color="red">ֻӵ�����ݹ���Ȩ��</font>)</label><font color="red">��</font></TD>
    </TR>
     <TR>
      <TD >�Ƿ�����</TD>
      <TD ><label><input type="radio" class="radio" size="20" name="m_state"  value="1" <% if rsObj("m_state")=1 then %> checked <%end if%>/>����</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><input type="radio" class="radio" size="20" name="m_state" value="0"  <% if rsObj("m_state")=0 then %> checked <%end if%> />����</label><font color="red">��</font></TD>
    </TR>
    <TR align="center"  >
    <TD align="left" ></TD>
      <TD align="left" ><input type="submit" value="�޸Ĺ���Ա" name="m_eidtsubmit" class="btn" id="m_eidtsubmit" />
      &nbsp;<input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></TD>
    </TR>
</td></tr></table>
</form>
<script>$("m_eidtsubmit").focus()</script>
<%
End Sub


Sub saveEdit
	dim m_username,m_pwd,m_pwd2,m_level,m_state,sqlStr,num
	m_username = getForm("m_username","post"):m_pwd = getForm("m_pwd","post"): m_pwd2 = getForm("m_pwd2","post") :m_level = getForm("m_level","post") : m_state=getForm("m_state","post") : id=getForm("id","get")
	if   isNul(m_username)  or isNul(m_pwd)  or isNul(m_pwd2)    then  die errorInfo
	if m_pwd<>m_pwd2 then die errorPwd
	if isNul(m_level) then m_level=0
	if isNul(m_state) then m_state=1
	'conn.db "alter table {pre}manager alter  m_pwd varchar(50)","execute"
	num = conn.db("select count(*) from {pre}manager where m_id<>"&id&"  and m_username='"&m_username&"'","execute")(0)
	if num>0 then die "�Ѿ����ڴ˹���Ա�����������"
	sqlStr = "update {pre}manager set m_pwd='"&md5(m_pwd,32)&"' where m_pwd<>'"&m_pwd&"' AND m_id="&id
	conn.db sqlStr,"execute"
	sqlStr = "update {pre}manager set m_username='"&m_username&"',m_level="&m_level&",m_state="&m_state&" where m_id="&id
	conn.db sqlStr,"execute"
	alertMsg "�༭�ɹ�","admin_manager.asp?id="&id 
End Sub


Sub addManager
	dim m_username,m_pwd,m_pwd2,m_level,sqlStr,num
	m_username = getForm("m_username","post"):m_pwd = getForm("m_pwd","post"): m_pwd2 = getForm("m_pwd2","post") :m_level = getForm("m_level","post")
	if   isNul(m_username)  or isNul(m_pwd)  or isNul(m_pwd2)   then  die errorInfo
	if m_pwd<>m_pwd2 then die errorPwd
	if isNul(m_level) then m_level=0
	num = conn.db("select count(*) from {pre}manager where m_username='"&m_username&"'","execute")(0)
	if num>0 then die "�Ѿ����ڴ˹���Ա�����������"
	'conn.db "alter table {pre}manager alter  m_pwd varchar(50)","execute"
	sqlStr = "insert into  {pre}manager(m_username,m_pwd,m_level,m_state) values ('"&m_username&"','"&md5(m_pwd,32)&"',"&m_level&",1)"
	conn.db sqlStr,"execute" 
	alertMsg "���ӳɹ�","admin_manager.asp" 
End Sub

Sub delmanager
	dim m_username
	id=getForm("id","get")
	m_username = conn.db("select m_username from {pre}manager where m_id="&id,"execute")(0)
	if m_username=rCookie("m_username") then 
		alertMsg "����ɾ������","admin_manager.asp?id="&id
	else
		conn.db "delete from {pre}manager where m_id="&id,"execute" 
		alertMsg "","admin_manager.asp"
	end if
End Sub

Sub delAll
	dim ids,num,idsArray,idsArraylen,i,m_username : ids=replaceStr(getForm("m_id","post")," ","")
	idsArray=split(ids,",") : idsArraylen=ubound(idsArray)
	for i=0 to idsArrayLen
		m_username = conn.db("select m_username from {pre}manager where m_id="&idsArray(i),"execute")(0)
		if m_username<>rCookie("m_username") then  conn.db "delete from {pre}manager where m_id="&idsArray(i),"execute" 
		'alertMsg "����ɾ������","admin_manager.asp?id="&idsArray(i)
	next
	alertMsg "","admin_manager.asp"
End Sub

Function getManagerLevel(id)
	if isNul(id) then getManagerLevel="δ֪" : Exit Function
	if id=0 then getManagerLevel="ϵͳ����Ա" : Exit Function
	if id=1 then getManagerLevel="��վ�༭" : Exit Function
End Function

Function getManagerState(id)
	if isNul(id) then getManagerState="δ֪" : Exit Function
	if id=0 then getManagerState="����" : Exit Function
	if id=1 then getManagerState="����" : Exit Function
End Function
%>