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
viewHead "�������ӹ���" & "-" & menuList(5,0)

dim action : action = getForm("action", "get")
dim errorInfo,errorSort : errorInfo="��Ϣ��д������������" : errorSort="�������Ϊ����"
dim keyword:keyword=ReplaceStr(getForm("keyword", "both"),"'","")

Select  case action
	case "last" : moveToLast
	case "next" : moveToNext
	case "del" : delLink
	case "delall" : delAll
	case "editall" : editAllLink
	case "edit" : main : edit
	case "save" : saveEdit
	case "add" : addLink
	case "hide" : hideLink
	case else : main : add
End Select 
viewFoot

dim id
Sub main
	dim Qe,linkArray,i,n,m_id:id=getForm("id","get")
	Set Qe =  mainClassobj.createObject("MainClass.DataPage")
	Qe.Query "SELECT * FROM {pre}link "&ifthen(keyword<>"","WHERE m_name LIKE '%"&keyword&"%' OR m_des LIKE '%"&keyword&"%' OR m_url LIKE '%"&keyword&"%'","")&" ORDER BY m_sort ASC"
	Qe.pagesize=1000
	linkArray = Qe.GetRows()
%>
<div id="append_parent"></div>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(5,0)%>&nbsp;&raquo;&nbsp;�������ӹ���';</script>
<%
	if Qe.recordcount>0 then  
		n=ubound(linkArray,2)
%>
<form action="" method="post" name="linkform">
<table class="tb">
<tr class="thead"><th colspan="7"><em style="font-weight:bold">�������ӹ���</em>&nbsp;&nbsp;<em style="color:#000;">�ؼ��֣�<input name="keyword" type="text" id="keyword" size="20" value="<%=keyword%>"> <input type="submit" name="selectBtn" value="�� ѯ..." class="btn" onclick="location.href='?keyword='+escape($('keyword').value);" /></em></th></tr>
    <TR align="center">
	  <TD>&nbsp;</TD>
      <TD width="6%">ID</TD>
      <TD>����</TD>
      <TD>��ַ</TD>
      <TD>����</TD>
      <TD>����</TD>
      <TD>����</TD>
    </TR>
	<%
	for i=0 to n
		m_id= trim(linkArray(0,i))
	%>
     <TR align="center" <%if id=m_id then %> class="editlast"<%end if%>>
	  <TD>&nbsp;</TD>
      <TD><input type="checkbox" value="<%=m_id%>" name="m_id" class="checkbox" /><%=m_id%></TD>
      <TD><input type="text" name="m_name<%=m_id%>" value="<%=linkArray(2,i)%>" size="20"/></TD>
      <TD><input name="m_url<%=m_id%>" type="text" value="<%=linkArray(4,i)%>"  size="30"/></TD>
      <td><% if linkArray(1,i)="font" then%>��������<%elseif linkArray(1,i)="pic" then%>ͼƬ����<%elseif InSTr(linkArray(1,i),"hide")>0 then%><font color=red>�ѱ�����</font><%end if%></td>
      <TD><input name="m_sort<%=m_id%>" type="text" value="<%=linkArray(6,i)%>"  size="10"/></TD>
      <TD><a href="?action=last&id=<%=m_id%>">����</a> <a href="?action=next&id=<%=m_id%>">����</a> <a href="?action=edit&id=<%=m_id%>">�༭</a> <a  onclick="if(confirm('ȷ��Ҫɾ����')){return true;}else{return false;}" href="?action=del&id=<%=m_id%>">ɾ��</a>&nbsp;<a href="?action=hide&id=<%=m_id%>&m_type=<%=linkArray(1,i)%>"><%if InSTr(linkArray(1,i),"hide")>0 then%>��ʾ<%else%>����<%end if%></a></TD>
    </TR>
		<%
        next
        %>
    <tr><td  colspan="6"><label>ȫѡ<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" /></label><label>��ѡ<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" /></label><input type="submit" value="����ɾ��" onclick="if(confirm('ȷ��Ҫɾ����')){linkform.action='?action=delall';}else{return false}" class="btn"  />&nbsp;&nbsp;<input type="submit" value="�����޸�ѡ����������" name="Submit"  class="btn"  onclick="linkform.action='?action=editall';"/></td></tr>
</TABLE>
</form> 
	<%
	else 
		echo "<table lass='tb'  ><tr><td><font color='red'>û���κμ�¼</font></td></tr></table>"
	end if
	set Qe = nothing
End Sub

Sub add
%>
<form action="?action=add" method="post" >
<table class="tb mt20">
<tr class="thead"><th colspan="2">������������</th></tr>
    <TR>
      <TD vAlign=center width="20%" >��վ���ƣ�</TD>
      <TD ><input type="text" size="50" name="m_name" /><font color="red">��</font></TD>
    </TR>
    <TR>
      <TD >��վ��ַ��</TD>
      <TD ><input type="text" size="50" name="m_url" /><font color="red">��</font></TD>
    </TR>
    <TR>
      <TD >�������ͣ�</TD>
      <TD ><select name="m_type"  style=" width:100px"  onChange="selectPicLink(this,'pic');">
        <option value="font">��������</option>
        <option value="pic">ͼƬ����</option>
      </select><font color="red">��</font></TD>
    </TR>
    <TR id="tr_m_pic" style="display:none">
      <TD >LOGO��ַ��</TD>
      <TD ><input type="text" size="50" name="m_pic" /></TD>
    </TR>
    <TR>
      <TD >����</TD>
      <TD ><input type="text" size="20" name="m_sort"/></TD>
    </TR>
    <TR>
      <TD >��վ���ܣ�</TD>
      <TD ><textarea name="m_des" cols="50" rows="4" ></textarea></TD>
    </TR>
    <TR  >
      <TD></TD> <TD><input type="submit" value="������������" class="btn" />
      &nbsp;<input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></TD>
    </TR>
</td></tr></table>
</form>
<%
End Sub

Sub edit
	id=getForm("id","get")
	dim rsObj : set rsObj=conn.db("select * from {pre}link where m_id="&id,"execute")
%>
<form action="?action=save&id=<%=id%>" method="post" name="editlink" >
<table class="tb mt20">
<tr class="thead"><th colspan="2">�༭��������</th></tr>
    <TR>
      <TD vAlign=center width="20%" >��վ���ƣ�</TD>
      <TD ><input type="text" size="50" name="m_name"  value="<%=rsObj("m_name")%>"/><font color="red">��</font></TD>
    </TR>
    <TR>
      <TD >��վ��ַ��</TD>
      <TD ><input type="text" size="50" name="m_url" value="<%=rsObj("m_url")%>"/><font color="red">��</font></TD>
    </TR>
    <TR>
      <TD >�������ͣ�</TD>
      <TD ><select name="m_type"  style=" width:100px"  onChange="selectPicLink(this,'pic');">
        <option value="font<%if InStr(rsObj("m_type"),"-hide")>0 then%>-hide<%end if%>" <%if InStr(rsObj("m_type"),"font")>0 then%>selected<%end if%>>��������</option>
        <option value="pic<%if InStr(rsObj("m_type"),"-hide")>0 then%>-hide<%end if%>" <%if InStr(rsObj("m_type"),"pic")>0 then%>selected<%end if%>>ͼƬ����</option>
      </select><font color="red">��</font></TD>
    </TR>
    <TR id="tr_m_pic" <%if rsObj("m_type")="pic" then%>style="display:block"<%else%>style="display:none"<%end if%>>
      <TD >LOGO��ַ��</TD>
      <TD ><input type="text" size="50" name="m_pic" value="<%=rsObj("m_pic")%>"/></TD>
    </TR>
    <TR>
      <TD >����</TD>
      <TD ><input type="text" size="20" name="m_sort" value="<%=rsObj("m_sort")%>"/></TD>
    </TR>
    <TR>
      <TD >��վ���ܣ�</TD>
      <TD ><textarea name="m_des" cols="50" rows="4" ><%=rsObj("m_des")%></textarea></TD>
    </TR>
    <TR >
      <td></td><TD><input type="submit" value="�޸���������" class="btn" name="m_eidtlinksubmit" />
      &nbsp;<input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></TD>
    </TR>
</td></tr></table>
</form>
<script>editlink.m_eidtlinksubmit.focus()</script>
<%
End Sub

Sub moveToLast
	id=getForm("id","get")
	dim cur,cou,flag
	cur=conn.db("select m_sort from {pre}link where m_id="&id,"execute")(0)
	cou=conn.db("select count(*) from {pre}link  where m_sort<"&cur,"execute")(0)
	if cou>0 then 
		flag=conn.db("select top 1 m_sort from {pre}link  where m_sort<"&cur&" order by m_sort desc","execute")(0)
		conn.db "update {pre}link set m_sort="&flag&" where m_id="&id,"execute" 
	else
		conn.db "update {pre}link set m_sort=m_sort-1 where m_id="&id,"execute" 
	end if
	alertMsg "","admin_link.asp?id="&id
End Sub


Sub moveToNext
	id=getForm("id","get")
	dim cur,cou,flag
	cur=conn.db("select m_sort from {pre}link where m_id="&id,"execute")(0)
	cou=conn.db("select count(*) from {pre}link  where m_sort>"&cur,"execute")(0)
	if cou>0 then 
		flag=conn.db("select top 1 m_sort from {pre}link  where m_sort>"&cur&" order by m_sort asc","execute")(0)
		conn.db "update {pre}link set m_sort="&flag&" where m_id="&id,"execute" 
	else
		conn.db "update {pre}link set m_sort=m_sort+1 where m_id="&id,"execute" 
	end if
	alertMsg "","admin_link.asp?id="&id
End Sub

Sub delAll
	dim ids : ids=replaceStr(getForm("m_id","post")," ","")
	conn.db "delete from {pre}link where m_id in ("&ids&")","execute" 
	alertMsg "","admin_link.asp"
End Sub

Sub delLink
	id=getForm("id","get")
	conn.db "delete from {pre}link where m_id="&id,"execute" 
	alertMsg "","admin_link.asp?id="&id
End Sub

Sub hideLink
	dim m_t:id=Clng(getForm("id","get")):m_t=ReplaceStr(getForm("m_type","get"),"'","")
	if m_t="" then
		m_t="font-hide"
	elseif InStr(m_t,"-hide")>0 then
		m_t=replace(m_t,"-hide","")
	else
		m_t=m_t&"-hide"
	end if
	conn.db "UPDATE {pre}link SET m_type='"&m_t&"' where m_id="&id,"execute"
	alertMsg "","admin_link.asp?id="&id
End Sub

Sub editAllLink
	dim ids,m_name,m_sort,m_url,sqlStr
	ids = split(replaceStr(getForm("m_id","post")," ",""),",")
	For Each id In ids
		m_name = getForm("m_name"&id,"post")
		if   isNul(m_name)   then  die errorInfo
		m_sort = getForm("m_sort"&id,"post") : if isNul(m_sort) then m_sort=conn.db("select max(m_sort) from {pre}link","execute")(0)+1		
		m_url = getForm("m_url"&id,"post")
		if isNul(m_url) then die errorInfo
		if not isNum(m_sort) then die errorSort
		sqlStr = "update {pre}link set m_name='"&m_name&"',m_url='"&m_url&"',m_sort="&m_sort&" where m_id="&id
		conn.db sqlStr,"execute" 
	Next
	alertMsg "","admin_link.asp" 
End Sub

Sub saveEdit
	dim m_name,m_sort,m_url,m_des,m_type,m_pic,sqlStr : id=getForm("id","get")
	m_name = getForm("m_name","post"):m_url = getForm("m_url","post"):m_type = getForm("m_type","post"):m_des=getForm("m_des","post") : m_pic=getForm("m_pic","post")
	if   isNul(m_name)  or isNul(m_url)  then  die errorInfo
	m_sort = getForm("m_sort","post") : if isNul(m_sort) then m_sort=conn.db("select max(m_sort) from {pre}link","execute")(0)+1
	if not isNum(m_sort) then die errorSort
	sqlStr = "update  {pre}link set m_type='"&m_type&"',m_name='"&m_name&"',m_pic='"&m_pic&"',m_url='"&m_url&"',m_des='"&m_des&"',m_sort="&m_sort&" where m_id="&id
	conn.db sqlStr,"execute" 
	alertMsg "","admin_link.asp" 
End Sub

Sub addLink
	dim m_name,m_sort,m_url,m_des,m_type,m_pic,sqlStr
	m_name = getForm("m_name","post"):m_url = getForm("m_url","post"):m_type = getForm("m_type","post"):m_des=getForm("m_des","post") : m_pic=getForm("m_pic","post")
	if   isNul(m_name)  or isNul(m_url)  then  die errorInfo
	m_sort = getForm("m_sort","post") : if isNul(m_sort) then  m_sort=conn.db("select max(m_sort) from {pre}link","execute")(0)+1
	if not isNum(m_sort) then m_sort=1
	sqlStr = "insert into  {pre}link(m_type,m_name,m_pic,m_url,m_des,m_sort) values ('"&m_type&"','"&m_name&"','"&m_pic&"','"&m_url&"','"&m_des&"',"&m_sort&")"
	conn.db sqlStr,"execute" 
	alertMsg "","admin_link.asp" 
End Sub
%>