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

viewHead "�������" & "-" & menuList(1,0)

dim action: action = getForm("action", "get")

Select  case action
	case "del" : delNewsType
	case "delall" : delAll
	case "edit" : editNewsType
	case "hide" : hideNewsType
	case "nohide" : nohideNewsType
	case "add" : addNewsType
	case "merge" : mergeNewsType
	case "move" : moveNewsType
	case else : main : popDiv
End Select

viewFoot

dim i,n : n=0 
Sub main
%>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;�������';</script>
<form method="post"  name="editform">
<table class="tb2">
<tr class="thead"><th colspan="9">���ŷ������(<font color='red'>��</font>Ϊ����,����ѡ��)</th></tr>	
<tr align="center">
			<td align="left" width="21%">ID.��������(��������)</td>
			<td width="10%">������</td>
			<td width="10%">Ӣ����</td>
			<td width="10%">Ƶ��ģ��</td>
			<td width="10%">����ģ��</td>
			<td width="10%">�ؼ���</td>
			<td width="10%">����</td>
			<td width="6%">����</td>
			<td width="13%">&nbsp;����</td>
</tr>
</table>
<%
	newsTypeList(0)
%>
<table class="tb"><tr><td>ȫѡ<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />��ѡ<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" /><input type="submit" value="����ɾ��" onclick="if(confirm('ȷ��Ҫɾ����')){editform.action='?action=delall';}else{return false}" class="btn"  /><input type="submit" value="�����޸�ѡ�з���" class="btn" onclick="editform.action='?action=edit';" />&nbsp;&nbsp;&nbsp;�ƶ���
      <select name="m_upid_to"><option value="0">��������</option>
    <%makeNewsTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
	</select><input type="submit" value="�����ƶ�����" name="Submit" class="btn" onclick="editform.action='?action=move';"/></td></tr></table>
</form>

<table class="tb mt20">
<tr class="thead"><th colspan="9">���ӷ���</th></tr>	
<form method="post" action="?action=add"  name="addform" onSubmit="return validateform()">
<tr align="center">
    <td width="160" align=left>
    ѡ��㼶��
      <select name="m_upid"><option value="0">��������</option>
    <%makeNewsTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
	</select><font color='red'>��</font>
    </td>
    <td width="160">������<font color='red'>��</font><br />
      <input type="text" size="10" name="m_name"></td>
    <td width="160">Ӣ����<font color='red'>��</font><br />
      <input type="text" size="10" name="m_enname"></td>
    <td width="140">Ƶ��ģ��<br />
      <input type="text" size="10" name="m_template"></td>
    <td width="140">����ģ��<br />
      <input type="text" size="10" name="m_subtemplate"></td>
    <td width="140">�ؼ���<br />
      <input type="text" size="10" maxlength="255" name="m_keyword"></td>
    <td width="140">����<br />
      <input type="text" size="10" maxlength="255" name="m_description"></td>
    <td width="136">����<br />
      <input type="text" size="3" name="m_sort"></td>
    <td width="175"><br />
<input type="submit" value="�� ��" name="Submit" class="btn" /></td>
</tr>
</form>
</table>
<table class="tb mt20">
<tr class="thead"><th>�ϲ�����</th></tr>
<form method="post" action="?action=merge">
<tr><td width="100%">�����ࣺ<%makeNewsTypeSelect("leftSelect")%>�����ݺϲ�����<%makeNewsTypeSelect("rightSelect")%><input type="submit" value="ȷ�Ϻϲ�" class="btn" /><br /><font color=#FF0000>ע�⣬����ǰ��ķ������ݺϲ������������ɾ��֮ǰ�������ɵ�HTML,������ɾ���÷��ࡣ</font></td></tr>
</form>
</table>
<%	
End Sub

Sub popDiv
%>
<div id="unionarea" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('unionarea').style.display='none'" />ƽ̨�����б�</div>
    <div class="popbody"><div>
      <div id="unionids"></div>
    </div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>
<%	
End Sub

Sub mergeNewsType
	dim rightSelect,leftSelect,typePath
	leftSelect = getForm("leftSelect","post") : if isNul(leftSelect) then die "��ѡ�����"
	rightSelect = getForm("rightSelect","post") : if isNul(rightSelect) then die "��ѡ�����"
	typePath = getTypePath(leftSelect,"news")
	conn.db "update {pre}news set m_type="&rightSelect&" where m_type="&leftSelect,"execute":clearTypeCache
	if makeMode<>"dir2" then
		If not isNul(typePath) Then  delfolder "../"&typePath Else  alertMsg "���������ʧ���Է³���ɾ����Ŀ¼����������������","admin_newstype.asp"  : die
	end if
	alertMsg "","admin_newstype.asp"
End Sub

Sub moveNewsType
	dim fromid,topid,ids,idArray,idsLen,subTypeList
	topid = getForm("m_upid_to","post")
	ids = replaceStr(getForm("m_id","post")," ","")
	if isNul(ids) then alertMsg "��ѡ����Ҫ�ƶ��ķ���","":last:die ""
	idArray=split(ids,",") : idsLen=ubound(idArray)
	for i=0 to idsLen
		subTypeList=","&getNewsTypeIdOnCache(idArray(i))&","
		if not isExistStr(subTypeList,","&topid&",") then  conn.db "update m_type set m_upid ="&topid&" where m_id ="&idArray(i),"execute"
	next
	clearTypeCache:alertMsg "�Ѿ��ɹ��ƶ����࣡","admin_newstype.asp"
End Sub

Sub addNewsType
	dim m_name,m_enname,m_sort,m_template,m_keyword,m_description,unionidArray,arrayLen,m_upid,m_subtemplate
	m_name = getForm("m_name","post")
	m_upid = getForm("m_upid","post")
	m_enname = getForm("m_enname","post")
	m_template = getForm("m_template","post") : if isNul(m_template) then m_template = "newspage.html"
	m_subtemplate = getForm("m_subtemplate","post") : if isNul(m_subtemplate) then m_subtemplate = "news.html"
	if isNul(m_name) or isNul(m_enname)   then  alertMsg "��Ϣ��д������������",getRefer:die ""
	m_sort = getForm("m_sort","post") : if isNul(m_sort) then m_sort=conn.db("select max(m_sort)+1 from {pre}type","execute")(0)
	if not isNum(m_sort) then m_sort=1
	m_keyword = getStrByLen(getForm("m_keyword","post"),255)
	m_description = getStrByLen(getForm("m_description","post"),255)
	conn.db "insert into {pre}type(m_name,m_enname,m_sort,m_template,m_upid,m_keyword,m_description,m_type,m_subtemplate)values('"&m_name&"','"&m_enname&"',"&m_sort&",'"&m_template&"',"&m_upid&",'"&m_keyword&"','"&m_description&"',1,'"&m_subtemplate&"')","execute"
	clearTypeCache:alertMsg "","admin_newstype.asp"
End Sub

Sub delTypeFirstPage(Byval typeid)
	dim channelFirstPage:channelFirstPage=getChannelPagesLink(typeid,1)
	if not isNul(channelFirstPage) then delFile channelFirstPage
End Sub

Sub hideNewsType
	dim id : id=getForm("m_id","get")
	dim typePath : typePath = getTypePath(id,"news")
	delTypeFirstPage id
	conn.db "update {pre}type set m_hide=1 where m_id="&id, "execute"
	if not isNul(typePath) Then
		if isExistFolder("../"&typePath)  then delFolder "../"&typePath
	else
		alertMsg "���������ʧ���Է�����ɾ����Ŀ¼����������������","admin_newstype.asp" : die ""
	end if
	clearTypeCache:alertMsg "","admin_newstype.asp"
End Sub 

Sub nohideNewsType
	dim id:id=getForm("m_id","get")
	conn.db "update {pre}type set m_hide=0 where m_id="&id, "execute"
	clearTypeCache:alertMsg "","admin_newstype.asp"
End Sub

Sub delAll
	dim ids,idArray,idsLen,i,filename
	ids = replaceStr(getForm("m_id","post")," ","")
	idArray=split(ids,",") : idsLen=ubound(idArray)
	for i=0 to idsLen
		delNewsTypeById idArray(i)
	next
	clearTypeCache:alertMsg "","admin_newstype.asp"
End Sub

Sub delNewsType
	dim id : id=getForm("m_id","get")
	delNewsTypeById id
	alertMsg "","admin_newstype.asp"
End Sub

Sub delNewsTypeById(id)
	dim m_pic,m_enname,rsObj
	dim typePath : typePath = getTypePath(id,"news")
	if isExistSub(id,"type")=true  then
		alertMsg "����ɾ���÷��������","admin_newstype.asp" 
	else		
		if isExistSub(id,"news")=true  then alertMsg "����ɾ���������µ��������£���������վ","admin_newstype.asp" : die ""
		conn.db  "delete from {pre}type where m_id="&id, "execute":clearTypeCache
		if not isNul(typePath) Then
			if isExistFolder("../"&typePath)  then delFolder "../"&typePath
		else  
			alertMsg "���������ʧ���Է�����ɾ����Ŀ¼����������������","admin_newstype.asp" : die ""
		end if
	end if	
End Sub

Sub editNewsType
	dim ids,id,m_name,m_enname,m_template,m_keyword,m_description,m_sort,unionidArray,arrayLen,sqlStr,m_subtemplate
	ids = split(replace(getForm("m_id","post")," ",""),",")
	For Each id In ids
		m_name = getForm("m_name"&id,"post")
		m_enname = getForm("m_enname"&id,"post")
		m_sort = getForm("m_sort"&id,"post") : if isNul(m_sort) then m_sort=conn.db("select max(m_sort)+1 from {pre}type where m_type=1","execute")(0)
		m_template = getForm("m_template"&id,"post") : if isNul(m_template) then m_template = "news.html"
		m_subtemplate = getForm("m_subtemplate"&id,"post") : if isNul(m_subtemplate) then m_subtemplate = "news.html"
		m_keyword = getStrByLen(getForm("m_keyword"&id,"post"),255)
		m_description = getStrByLen(getForm("m_description"&id,"post"),255)
		if isNul(id) or  isNul(m_name) or isNul(m_enname)   then  alertMsg "��Ϣ��д������������",getRefer:die ""
		sqlStr = "update {pre}type set m_name='"&m_name&"',m_enname='"&m_enname&"',m_sort="&m_sort&",m_template='"&m_template&"',m_subtemplate='"&m_subtemplate&"',m_keyword='"&m_keyword&"',m_description='"&m_description&"',m_type=1 where m_id="&id
		conn.db sqlStr,"execute":clearTypeCache
	Next
	alertMsg "","admin_newstype.asp"
End Sub

Sub newsTypeList(topId)
	Dim i,j,k,l,TL:TL=getNewsTypeLists():k=getTypeindex("m_upid"):l=getTypeindex("m_id")
	n = n+4
	for i=0 to UBound(TL,2)
	if Clng(TL(k,i))=topId then
%>
<table class="tb2">
	<tr align="center">
		<td  align="left" width="21%"><%for j=0 to n-4%>&nbsp;<%next%><input type="checkbox" name="m_id" value="<%=TL(l,i)%>"  class="checkbox" /><%=TL(l,i)%>.<a href="admin_news.asp?type=<%=TL(l,i)%>"><%=TL(getTypeindex("m_name"),i)%></a>(<font color="red"><%=getNumPerNewsType(TL(l,i))%></font>)</td>
		<td width="10%"><input type="text" size="10" name="m_name<%=TL(l,i)%>" value="<%=TL(getTypeindex("m_name"),i)%>"></td>
		<td width="10%"><input type="text" size="10" name="m_enname<%=TL(l,i)%>" value="<%=TL(getTypeindex("m_enname"),i)%>"></td>
		<td width="10%"><input type="text" size="10" name="m_template<%=TL(l,i)%>" value="<%=TL(getTypeindex("m_template"),i)%>"></td>
		<td width="10%"><input type="text" size="10" name="m_subtemplate<%=TL(l,i)%>" id="m_subtemplate<%=TL(l,i)%>" value="<%=TL(getTypeindex("m_subtemplate"),i)%>"></td>
		<td width="10%"><input type="text" size="10" maxlength="255" name="m_keyword<%=TL(l,i)%>" value="<%=TL(getTypeindex("m_keyword"),i)%>"></td>
		<td width="10%"><input type="text" size="10" maxlength="255" name="m_description<%=TL(l,i)%>" value="<%=TL(getTypeindex("m_description"),i)%>"></td>
		<td width="6%"><input type="text" size="3" name="m_sort<%=TL(l,i)%>" value="<%=TL(getTypeindex("m_sort"),i)%>"></td>
		<td width="13%"><input type="button" value="ɾ��" onClick="javascript:location.href='?action=del&m_id=<%=TL(l,i)%>';" name="Input" class="btn" /><%if TL(getTypeindex("m_hide"),i)=1 then %><input type="button" value="ȡ������" onClick="javascript:location.href='?action=nohide&m_id=<%=TL(l,i)%>';" name="Input2" class="btn" style="width:60px"/><%elseif TL(getTypeindex("m_hide"),i)=0 then%><input type="button" value="����" onClick="location.href='?action=hide&m_id=<%=TL(l,i)%>';" name="Input2" class="btn" style="width:60px"/> <%end if%></td>
  	</tr>
</table>
<%
		newsTypeList(Clng(TL(l,i)))
	end if
	next
	n = n-4
End Sub

Function isExistSub(bigType,operFlag)
	dim recordsCount
	select case operFlag
		case "type"
			recordsCount=conn.db("select count(*) from {pre}type where m_upid="&bigType,"execute")(0)
		case "news"
			recordsCount=conn.db("select count(*) from {pre}news where m_type="&bigType,"execute")(0)
	end select
	if 	recordsCount>0 then isExistSub=true else isExistSub=false
End Function

Sub clearTypeCache()
	if cacheStart=1 then:cacheObj.clearCache("array_newstype_lists_all"):end if
End Sub
%>