<!--#include file="admin_inc.asp"-->
<!--#include file="FCKeditor/fckeditor.asp" -->
<%
'******************************************************************************************
' Software name: Max(����˹) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ����
' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
'******************************************************************************************
viewHead "���Ź���" & "-" & menuList(1,0)

dim action : action = getForm("action", "get")

dim m_title,m_content,m_author,m_color,m_hit
dim errStr : errStr="��Ϣ��д������"
dim page,id,where,keyword:keyword=ReplaceStr(getForm("keyword", "both"),"'","")
checkColorField
Select  case action
	case "add" : addNews
	case "addsave" : addSave
	case "edit" : editNews
	case "editsave" : editSave
	case "del" : delNews
	case "delgbook" : delGbook
	case "handled" : delHandled
	case "delall" : delAll
	case "delallgbook" :  delAllGbook
	case "reporterror" : reportError
	case "comment" : comment
	case "deltotalgbook": delTotalGbook
	case "deltotalcomment":delTotalComment
	case "viewinfo":viewInfo
	case else : main
End Select
viewFoot

Sub main
	dim Qe,newsArray,i,n,m_id,m_title,m_videoname,sWhere:id=getForm("id","get"):page=getForm("page","get") 
	if isNul(page) then page=1
	if page<1 then page=1 else page=clng(page)
	if isNul(where) then
		sWhere="m_type='news'"
	elseif where = "gbook" then
		sWhere="m_replyid=0"
	else
		sWhere="m_type='"&where&"'"
	end if
	if keyword<>"" then
		if where <> "gbook" then
			sWhere = sWhere & " AND (m_title LIKE '%"&keyword&"%' OR m_content LIKE '%"&keyword&"%' OR m_ip LIKE '"&ReplaceStr(keyword,"*","%")&"')"
		else
			sWhere = sWhere & " AND (m_content LIKE '%"&keyword&"%' OR m_ip LIKE '"&ReplaceStr(keyword,"*","%")&"')"
		end if
	end if
	Set Qe =  mainClassobj.createObject("MainClass.DataPage")
	Qe.Query "SELECT "&ifthen(where = "gbook","m_id,m_author,m_content,m_addtime,m_ip FROM {pre}leaveword","m_id,m_author,m_title,m_addtime,m_ip,m_content,m_videoid,m_color,m_hit,m_type FROM {pre}info")&" WHERE "&sWhere&" ORDER BY m_id DESC"
	Qe.absolutepage=page
	Qe.pagesize=30
	newsArray = Qe.GetRows()
	if page > Qe.pagecount then page=Qe.pagecount
%>
<div id="append_parent"></div>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;<%echoNewsType(where)%>';</script>
<%
	if isNul(where) then
%>
<table align="left"><tr><td><input type="button" value="��������" onClick="location.href='?action=add'" class="btn" /></td></tr></table>
<%
	end if
%>
<table class="tb">
<tr class="thead"><th colspan="8"><em style="font-weight:bold"><%echoNewsType(where)%></em><em style="color:#000;">&nbsp;&nbsp;&nbsp;�ؼ��֣�<input name="keyword" type="text" id="keyword" size="20" value="<%=keyword%>"> <input type="submit" name="selectBtn" value="�� ѯ..." class="btn" onclick="location.href='?action=<%=action%>&where=<%=where%>&keyword='+escape($('keyword').value);" /><%if where<>"" then:echo "&nbsp;&nbsp;����IP:192.168.1.*":end if%></em></th></tr>
<form name="newslistform" method="post">
<tr><td>ID </td><td><%if isNul(where) then%>���ű���<%elseif where="comment" then%>��������<%elseif where="reporterror" then%>��������<%elseif where="gbook" then%>��������<%end if%> </td>
<%if isNul(where) then%><td>�����</td><% end if%>
<%if where="reporterror"  then%><td>������������(ID)</td><%elseif where="comment"  then%><td>������������(ID)</td><%end if %>
<%if where="comment" then%><td>������IP </td><%elseif where="reporterror" then%><td>����IP </td><%elseif where="gbook" then%><td>������IP </td><%end if%>
<td>ʱ�� </td><td><% if where="reporterror" then%>������<%elseif where="comment" then%>������<%elseif where="gbook" then%>������<%else%>��ɫ<%end if%></td> <td>����</td> </tr>
<%
	if Qe.recordcount>0 then
		n=ubound(newsArray,2)
        for i=0 to n
            m_id= trim(newsArray(0,i))
            m_title= trim(newsArray(2,i))
			if where<>"gbook" then m_color= trim(newsArray(7,i))
			if where <>"gbook" then 
		%>
    <tr bgcolor="#ffffff" ><td><input type="checkbox" value="<%=m_id%>" name="m_id"  class="checkbox" /><%=m_id%> </td><%if not isNul(where) then%><td >
			<%=showFace(getStrByLen(trim(newsArray(5,i)),40))%>  <a href="?action=viewinfo&type=<%=where%>&m_id=<%=newsArray(0,i)%>">�鿴����</a> 
    </td><%else%><td><a href="<%="../"&newsDirName&"/?"&m_id&filesuffix%>" target="_blank"><%=showFace(getStrByLen(m_title,40))%></a></td><%end if%>
	<%
			else
	%>
	<tr bgcolor="#ffffff" ><td><input type="checkbox" value="<%=m_id%>" name="m_id"  class="checkbox" /><%=m_id%> </td><td title="<%=trim(newsArray(2,i))%>"><%=showFace(getStrByLen(newsArray(2,i),40))%> </td>
	<%
			end if 
	
			if isNul(where) then%><td><%= trim(newsArray(8,i)) %></td><% end if%>
	<%
			if where="reporterror" or where="comment" then
				%><td><%
				on error resume next
				dim newsRsObj,m_typeId : set newsRsObj = conn.db("select m_name,m_type,m_enname,m_datetime from {pre}data where m_id="&newsArray(6,i),"execute")
				m_videoname = newsRsObj(0)
				m_typeId = newsRsObj(1)
				if err  then m_videoname="" : err.clear
				if not isNul(m_videoname) then
					if where="reporterror" then 
				%>
				<a href='<%=getPlayLink2(m_typeId,newsArray(6,i),newsRsObj(2),newsRsObj(3),0,0)%>' target='_blank'><%=m_videoname%></a>
				(<%=newsArray(6,i)%>)<a href='admin_video.asp?action=edit&id=<%=newsArray(6,i)%>'> <font color="#FF0000">����</font></a></td>
				<%
					else
						echo "<a href='"&getContentLink(newsArray(6,i),m_typeId,newsRsObj(2),newsRsObj(3),"")&"' target='_blank' >"&m_videoname&"("&newsArray(6,i)&")</a></td>"
					end if
				else
					echo "��������ɾ��</td>"
				end if
				newsRsObj.close:SET newsRsObj=nothing
			end if 
	%>
	<%		if where="comment" OR where="reporterror" OR where="gbook" then%><td><%=newsArray(4,i)%></td><%end if%><td><%isCurrentDay(newsArray(3,i))%> </td><td><%
			if where="" then 
%>
<select name="m_color"  style="width:100px" disabled="disabled">
		<option style="background-color:<%=m_color%>;color: <%=m_color%>" value="<%=m_color%>"><%=m_color%></option>
        <option style="background-color:#FF0000;color: #FF0000" value="#FF0000">��ɫ</option> 
        <option style="background-color:#FF33CC;color: #FF33CC" value="#FF33CC">�ۺ�</option>  
        <option style="background-color:#00FF00;color: #00FF00" value="#00FF00">��ɫ</option>
        <option style="background-color:#0000CC;color: #0000CC" value="#0000CC">����</option>
        <option style="background-color:#FFFF00;color: #FFFF00" value="#FFFF00">��ɫ</option>
        <option style="background-color:#660099;color: #660099" value="#660099">��ɫ</option>
		</select>
<%			else 
				echo newsArray(1,i) 
			end if
	%> </td><td> 
	<%if isNul(where) then%> 
    	<a href="?action=edit&id=<%=m_id%>&where=<%=where%>">�༭</a> 
    <%end if%>
    <a onClick="if(confirm('ȷ��Ҫɾ����')){return true;}else{return false;}" <% if where = "gbook" then %>href="?action=delgbook&id=<%=m_id%>" <%else%>href="?action=del&id=<%=m_id%>"<%end if%> >ɾ��</a></td></tr>
		<%
        next
        %>
    <tr>
    <td colspan="8">ȫѡ<input type="checkbox" name="chkall" id="chkall" class="checkbox" onClick="checkAll(this.checked,'input','m_id')" />��ѡ<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onClick="checkOthers('input','m_id')" /><input type="submit" value="����ɾ��" onClick="if(confirm('ȷ��Ҫɾ����')){newslistform.action='?<% if where = "gbook" then %>action=delallgbook'<%else%>action=delall'<%end if %>;}else{return false}" class="btn"  />
    <% 
	if where = "gbook" then %>
    <input type="submit" value="ȫ��ɾ��" onClick="if(confirm('ȷ��Ҫɾ��ȫ����')){newslistform.action='?action=deltotalgbook'}" class="btn"/>
	<%elseif where = "comment" then %>
	<input type="submit" value="ȫ��ɾ��" onClick="if(confirm('ȷ��Ҫɾ��ȫ����')){newslistform.action='?action=deltotalcomment'}" class="btn"/>
    <% end if%>
	<%if where="reporterror" then%><!--<input type="submit" value="ɾ���Ѵ�������" onclick="newslistform.action='?action=handled';" class="btn"  />--><%end if%>
	</td></tr>
	<tr>
    <td colspan="8"><div class="cuspages"><div class="pages">ҳ��<%=page%>/<%=Qe.pagecount%> ÿҳ<%=Qe.pagesize%>����¼����<%=Qe.recordcount%>�� <a href="?page=1&where=<%=where%>&action=<%=action%>&keyword=<%=keyword%>">��ҳ</a> <a href="?page=<%=(page-1)%>&where=<%=where%>&action=<%=action%>&keyword=<%=keyword%>">��һҳ</a> <%=makePageNumber(page, 10, Qe.pagecount, "newslist")%><a href="?page=<%=(page+1)%>&where=<%=where%>&action=<%=action%>&keyword=<%=keyword%>">��һҳ</a> <a href="?page=<%=Qe.pagecount%>&where=<%=where%>&action=<%=action%>&keyword=<%=keyword%>">βҳ</a>&nbsp;&nbsp;��ת<input type="text" id="skip" value="" onkeyup="this.value=this.value.replace(/[^\d]+/,'')" style="width:40px"/>&nbsp;&nbsp;<input type="button" value="ȷ��" class="btn" onclick="location.href='?page='+$('skip').value+'&where=<%=where%>&action=<%=action%>&keyword=<%=keyword%>';"/></div></div>
    </td></tr>
<%	else
		dim back
		if keyword<>"" then back=",<a href='javascript:history.go(-1)'><u>������һҳ</u></a>"
		echo "<tr><td colspan=""8"" align=""center"">û�м�¼"&back&"</td></tr>"
	end if
%>
</form>
</table>
<%
	set Qe = nothing
End Sub

Sub addNews
%>
<div class="container" id="cpcontainer">
<form action="?action=addsave" method="post">
<table class="tb" >
<tr class="thead"><th colspan="2"><%echoNewsType(where)%></th></tr>
<tr><td width="14%">���ű��⣺</td><td><input type="text" size="100"  name="m_title"  /><font color="red">��</font></td></tr>
<tr><td >���ű�����ɫ��</td><td > <select name="m_color" style="width:100px">
		<option value="" selected>������ɫ</option>
        <option style="background-color:#FF0000;color: #FF0000" value="#FF0000">��ɫ</option> 
        <option style="background-color:#FF33CC;color: #FF33CC" value="#FF33CC">�ۺ�</option>  
        <option style="background-color:#00FF00;color: #00FF00" value="#00FF00">��ɫ</option>
        <option style="background-color:#0000CC;color: #0000CC" value="#0000CC">����</option>
        <option style="background-color:#FFFF00;color: #FFFF00" value="#FFFF00">��ɫ</option>
        <option style="background-color:#660099;color: #660099" value="#660099">��ɫ</option>
        <option style="" value="">��  ɫ</option>
		</select></td></tr>
<tr><td >���ŵ���ʣ�</td><td>
<input type="text" maxlength="9"  name="m_hit" value="0">
</td></tr>
<tr><td>�������ݣ�</td><td>  
  <%Dim oFCKeditor:Set oFCKeditor = New FCKeditor:oFCKeditor.BasePath="fckeditor/":oFCKeditor.ToolbarSet="maxcms":oFCKeditor.Width="640":oFCKeditor.Height="300":oFCKeditor.Create "m_content"%><font color="red">��</font>
</td></tr>
<tr><td></td><td><input type="submit" value="��   ��" class="btn" />&nbsp;<input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></td></tr>
</table>
</form>
<%	
End Sub

Sub editNews
	id=getForm("id","get") : page = getForm("page","get") : where = getForm("where","get")
	dim rsObj : set rsObj=conn.db("select * from {pre}info where m_id="&id,"records1")
	m_color=rsObj("m_color")
%>
<div class="container" id="cpcontainer">
<form action="?action=editsave&id=<%=id%>&where=<%=where%>" method="post">
<table class="tb">
<tr class="thead"><th colspan="2"><%echoNewsType(where)%></th></tr>
<tr><td width="14%">���ű��⣺</td><td><input type="text" size="80"  name="m_title" value="<%=rsObj("m_title")%>" /><font color="red">��</font></td></tr>
<tr><td>���ű�����ɫ��</td><td>
		<select name="m_color" style="width:100px">
		<option style="background-color:<%=m_color%>;color: <%=m_color%>" value="<%=m_color%>"><%=m_color%></option>
        <option style="background-color:#FF0000;color: #FF0000" value="#FF0000">��ɫ</option> 
        <option style="background-color:#FF33CC;color: #FF33CC" value="#FF33CC">�ۺ�</option>  
        <option style="background-color:#00FF00;color: #00FF00" value="#00FF00">��ɫ</option>
        <option style="background-color:#0000CC;color: #0000CC" value="#0000CC">����</option>
        <option style="background-color:#FFFF00;color: #FFFF00" value="#FFFF00">��ɫ</option>
        <option style="background-color:#660099;color: #660099" value="#660099">��ɫ</option>
        <option style="" value="">��  ɫ</option>
		</select>
</td></tr>
<tr><td >���ŵ���ʣ�</td><td>
<input type="text"  maxlength="9"  name="m_hit" value="<%= rsObj("m_hit")%>">
</td></tr>
<tr><td>�������ݣ�</td><td> 
  <%Dim oFCKeditor:Set oFCKeditor = New FCKeditor:oFCKeditor.BasePath="fckeditor/":oFCKeditor.ToolbarSet="maxcms":oFCKeditor.Width="640":oFCKeditor.Height="300":oFCKeditor.Value=decodeHtml(rsObj("m_content")):oFCKeditor.Create "m_content"%>
  <font color="red">��</font>
  </td></tr>
<tr><td></td><td ><input type="hidden"  value="<%=getRefer()%>" name="refer"/><input type="submit" value="��    ��" class="btn" />&nbsp;<input type="button" value="��    ��" onClick="self.location.href='<%=getRefer()%>'" class="btn" /></td></tr>
</table>
</form>
<%
	rsObj.close
	set rsObj=nothing
End Sub

Sub viewInfo
	dim id,viewType : id=getForm("m_id","get"):viewType=getForm("type","get")
   	dim rsObj:set rsObj=conn.db("select m_content from {pre}info where m_id="&id,"records1")
%>
<div class="container" id="cpcontainer">
<table class="tb">
<tr class="thead"><th colspan="2"><%if viewType="reporterror" then echo "����" else if viewType="comment" then  echo "����"%>����鿴</th></tr>
<tr><td>
<%
if not rsObj.eof then 
	if viewType="reporterror" then echo replaceStr(rsObj(0),chr(13)&chr(10),"<br/>") else if viewType="comment" then echo showFace(rsObj(0)) 
else
	echo "û���ҵ���¼"
end if
%>
</td></tr>
<tr><td><input type="button" value="��    ��" onClick="self.location.href='<%=getRefer()%>'" class="btn" /></td></tr>
</table>
<%
	rsObj.close:set rsObj=nothing
End Sub

Sub addSave
	m_title =getForm("m_title","post") : m_content =encodeHtml(getForm("m_content","post")) : m_color=getForm("m_color","post"):m_hit = Clng(getForm("m_hit","post"))
	if isNul(m_title) or isNul(m_content) then die errStr
	'if isNul(m_author) then m_author="��վ����Ա"
	conn.db  "insert into {pre}info(m_title,m_type,m_color,m_content,m_addtime,m_hit) values('"&m_title&"','news','"&m_color&"','"&m_content&"','"&now()&"',"&m_hit&")","execute" 
	alertMsg "���ӳɹ�","admin_news.asp" 
End Sub

Sub checkColorField
	'if not checkField("m_color","{pre}info") then conn.db "alter table {pre}info add m_color varchar(20)","execute"
End Sub

Sub delAll
	dim refer : refer=getRefer
	dim ids : ids=replaceStr(getForm("m_id","post")," ","")
	conn.db "delete from {pre}info where m_id in ("&ids&")","execute" 
	alertMsg "",refer
End Sub

'<!--7.02��ʼ-->
Sub delAllGbook
	dim refer : refer=getRefer
	dim ids : ids=replaceStr(getForm("m_id","post")," ","")
	conn.db "delete from {pre}leaveword where m_id in ("&ids&")","execute"
	alertMsg "",refer
End Sub

Sub delTotalGbook
	dim refer : refer=getRefer
	conn.db "delete from {pre}leaveword ","execute"
	alertMsg "",refer
End Sub



Sub delTotalComment
	dim refer : refer=getRefer
	conn.db "delete from {pre}info where m_type='comment'","execute"
	alertMsg "",refer
End Sub
'<!--7.02���� -->
Sub delNews
	dim refer : refer=getRefer
	id = getForm("id","get")
	conn.db "delete from {pre}info where m_id="&id,"execute"
	alertMsg "",refer
End Sub


Sub delGbook
	dim refer : refer=getRefer
	id = getForm("id","get")
	conn.db "delete from {pre}leaveword where m_id="&id,"execute"
	alertMsg "",refer
End Sub

Sub editsave
	dim refer
	id=getForm("id","get") : where = getForm("where","get") : refer=getForm("refer","post") : m_title =getForm("m_title","post") : m_content =encodeHtml(getForm("m_content","post")) : m_color=getForm("m_color","post") :m_hit = Clng(getForm("m_hit","post"))
	if isNul(m_title) or isNul(m_content) then die errStr
	'if isNul(m_author) then m_author="��վ����Ա"
	if isNul(where) then where="news"
	conn.db  "update {pre}info set m_hit = '"&m_hit&"',m_title='"&m_title&"',m_type='"&where&"',m_color='"&m_color&"',m_content='"&m_content&"',m_addtime='"&now()&"' where m_id="&id,"execute" 
	alertMsg "�༭�ɹ�",refer 
End Sub

Sub comment
	where = getForm("where","get")
	main
End Sub

Sub reportError
	where = getForm("where","get")
	main
End Sub

Sub echoNewsType(str)
	if  str="reporterror" then
		echo "��������"
	elseif str="comment" then
		echo "���۹���"
	elseif str="gbook" then
		echo "���Թ���"
	else 
		echo "���Ź���" 
	end if
End Sub


%>