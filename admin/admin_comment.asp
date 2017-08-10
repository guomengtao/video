<!--#include file="admin_inc.asp"-->
<!--#include file="FCKeditor/fckeditor.asp" -->
<%
'******************************************************************************************
' Software name: Max(马克斯) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: 石头(maxcms2008@qq.com),yuet,长明,酒瓶
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************
viewHead "评论管理" & "-" & menuList(1,0)

dim action : action = getForm("action", "get")

dim page,id,where,keyword:keyword=ReplaceStr(getForm("keyword", "both"),"'",""):where = getForm("where","get")
if isNum(where) then
	where=Clng(where)
else
	where=1
end if
checkColorField
Select  case action
	case "del" : delReview
	case "delall" : delAll
	case "comment" : comment
	case "deltotalcomment":delTotalComment
	case "viewinfo":viewInfo
	case "verifypic":verifypic
	case else : main
End Select
viewFoot

Function DeMessage(Str)
	DeMessage=showFace(""&Str)
End Function

Function showFace(m_content)
	dim templateobj : set templateobj=mainClassObj.createObject("MainClass.template")
	m_content=templateobj.regExpReplace(m_content,"\[em:(\d+?):\]","<img src=""../comment/images/cmt/$1.gif"" border=0/>")
	set templateobj=nothing
	showFace=m_content
End Function

Sub main
	dim Qe,Ary,i,n,m_id,m_title,m_videoname,m_content,m_check,x:id=getForm("id","get"):page=getForm("page","get")
	if isNul(page) then page=1
	if page<1 then page=1 else page=clng(page)
	set Qe =  mainClassobj.createObject("MainClass.DataPage")
	Qe.Query "SELECT m_id,m_pic,m_author,m_addtime,m_ip,m_content,m_videoid,m_reply,m_agree,m_type,m_check FROM {pre}review WHERE m_type="&where&ifthen(keyword<>""," AND (m_content LIKE '%"&keyword&"%' OR m_ip LIKE '"&ReplaceStr(keyword,"*","%")&"')","")&" ORDER BY m_id DESC"
	Qe.absolutepage=page
	Qe.pagesize=30
	Ary = Qe.GetRows()
	if page > Qe.pagecount then page=Qe.pagecount
%>
<div id="append_parent"></div>
<div class="container" id="cpcontainer">
<!--当前导航-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;评论管理';</script>
<table class="tb">
<tr class="thead"><th colspan="8"><em style="font-weight:bold">评论管理</em><em style="color:#000;">&nbsp;&nbsp;&nbsp;关键字：<input name="keyword" type="text" id="keyword" size="20" value="<%=keyword%>"> <input type="submit" name="selectBtn" value="查 询..." class="btn" onclick="location.href='?action=<%=action%>&where=<%=where%>&keyword='+escape($('keyword').value);" /><%if where<>"" then:echo "&nbsp;&nbsp;搜索IP:192.168.1.*":end if%></em></th></tr>
<form name="newslistform" method="post">
	<tr>
		<td>ID</td>
		<td>评论内容</td>
		<td>评论数据名称(ID)</td>
		<td>截图</td>
		<td>时间</td>
		<td>评论者IP</td>
		<td>操作</td>
	</tr>
<%
	if Qe.recordcount>0 then
	n=ubound(Ary,2):keyword=Server.URLEncode(keyword)
	for i=0 to n
		m_id= trim(Ary(0,i))
		m_title= trim(Ary(2,i))
		m_check=Ary(10,i)
		m_content= DeMessage(Ary(5,i))
	%>
	<tr bgcolor="#ffffff" >
		<td><input type="checkbox" value="<%=m_id%>" name="m_id"  class="checkbox" /><%=m_id%></td>
		<td> <%=m_content%> <a href="?action=viewinfo&type=1&m_id=<%=m_id%>">查看详情</a></td>
		<td><%
		on error resume next
		dim newsRsObj
		if where=2 then
			set newsRsObj = conn.db("select m_title,m_type,m_entitle,m_datetime from {pre}news where m_id="&Ary(6,i),"execute")
		else
			set newsRsObj = conn.db("select m_name,m_type,m_enname,m_datetime from {pre}data where m_id="&Ary(6,i),"execute")
		end if
		m_videoname = newsRsObj(0)
		if err  then m_videoname="" : err.clear
		if not isNul(m_videoname) then
			if where=2 then
				echo "<a href="""&getNewsArticleLink(newsRsObj(1),Ary(6,i),newsRsObj(2),newsRsObj(3),"")&""" target=""_blank"">"&m_videoname&"("&Ary(6,i)&")</a></td>"
			else
				echo "<a href="""&getContentLink(newsRsObj(1),Ary(6,i),newsRsObj(2),newsRsObj(3),"")&""" target=""_blank"">"&m_videoname&"("&Ary(6,i)&")</a></td>"
			end if
		else
			echo "该数据已删除</td>"
		end if
		%></td>
		<td><a href="../comment/upload/<%=Ary(1,i)%>" target="_blank"><%=Ary(1,i)%></a></td>
		<td><span style='font-size:10px'><%=Ary(3,i)%></span></td>
		<td><%=DeMessage(Ary(2,i)) & "("&Ary(4,i)&")"%></td>
		<td><a onClick="if(confirm('确定要删除吗')){return true;}else{return false;}" href="?action=del&m_id=<%=m_id%>" >删除</a><%if m_check=0 then%>&nbsp;<a href="?action=verifypic&m_id=<%=m_id%>">通过审核</a><%end if%></td>
	</tr>
	<%next%>
	<tr>
		<td colspan="8">全选<input type="checkbox" name="chkall" id="chkall" class="checkbox" onClick="checkAll(this.checked,'input','m_id')"/>反选
			<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onClick="checkOthers('input','m_id')"/>
			<input type="submit" value="批量删除" onClick="if(confirm('确定要删除吗')){newslistform.action='?action=delall';}else{return false}" class="btn"/>
			<input type="submit" value="全部删除" onClick="if(confirm('确定要删除全部吗')){newslistform.action='?action=deltotalcomment&where=<%=where%>'}" class="btn"/>
			<!--<input type="submit" value="批量通过审核" onClick="if(confirm('确定要审核吗')){newslistform.action='?action=verifypic';}else{return false}" class="btn"/>--></td>
	</tr>
	<tr>
		<td colspan="8"><div class="cuspages"><div class="pages">页次<%=page%>/<%=Qe.pagecount%> 每页<%=Qe.pagesize%>总收录数据<%=Qe.recordcount%>条 <a href="?page=1&where=<%=where%>&action=<%=action%>&keyword=<%=keyword%>">首页</a> <a href="?page=<%=(page-1)%>&where=<%=where%>&action=<%=action%>&keyword=<%=keyword%>">上一页</a> <%=makePageNumber(page, 10, Qe.pagecount, "newslist")%><a href="?page=<%=(page+1)%>&where=<%=where%>&action=<%=action%>&keyword=<%=keyword%>">下一页</a> <a href="?page=<%=Qe.pagecount%>&where=<%=where%>&action=<%=action%>&keyword=<%=keyword%>">尾页</a>&nbsp;&nbsp;跳转<input type="text" id="skip" value="" onkeyup="this.value=this.value.replace(/[^\d]+/,'')" style="width:40px"/>&nbsp;&nbsp;<input type="button" value="确定" class="btn" onclick="location.href='?page='+$('skip').value+'&where=<%=where%>&action=<%=action%>&keyword=<%=keyword%>';"/></div></div></td>
	</tr>
<%	else
		echo "<tr><td colspan=""8"" align=""center"">没有记录"&ifthen(keyword<>"",",<a href='javascript:history.go(-1)'><u>返回上一页</u></a>","")&"</td></tr>"
	end if
%>
</form>
</table>
<%
	set Qe = nothing
End Sub

Sub viewInfo
	dim id,viewType : id=getForm("m_id","get"):viewType=getForm("type","get")
   	dim rsObj:set rsObj=conn.db("select m_content from {pre}review where m_id="&id,"records1")
%>
<div class="container" id="cpcontainer">
<table class="tb">
<tr class="thead"><th colspan="2">评论详情查看</th></tr>
<tr><td>
<%
if not rsObj.eof then 
	echo DeMessage(rsObj(0)) 
else
	echo "没有找到记录"
end if
%>
</td></tr>
<tr><td><input type="button" value="返    回" onClick="self.location.href='<%=getRefer()%>'" class="btn" /></td></tr>
</table>
<%
	rsObj.close:set rsObj=nothing
End Sub

Sub checkColorField
	'if not checkField("m_color","{pre}info") then conn.db "alter table {pre}info add m_color varchar(20)","execute"
End Sub

Sub delAll
	dim refer : refer=getRefer
	dim ids : ids=replaceStr(getForm("m_id","both")," ",""):UpJson ids:delPic ids
	conn.db "delete from {pre}review where m_id in ("&ids&")","execute"
	alertMsg "",refer
End Sub

'<!--7.02开始-->
Sub delTotalComment
	dim refer,ids,i : refer=getRefer:ids=""
	dim ary:ary=conn.db("select m_id from {pre}review where m_type="&where,"array")
	if isArray(ary) then
		for i=0 to UBound(ary,2)
			ids=ids&","&ary(0,i)
		next
		ids=right(ids,len(ids)-1)
	end if
	if ids<>"" then
		UpJson ids:delPic ids
		conn.db "delete from {pre}review where m_id IN("&ids&")","execute"
	end if
	alertMsg "",refer
End Sub
'<!--7.02结束 -->
Sub delReview
	dim refer : refer=getRefer
	id = getForm("m_id","both"):UpJson id:delPic id
	conn.db "delete from {pre}review where m_id="&id,"execute"
	conn.db "update {pre}review set m_reply=0 where m_reply="&id,"execute"
	alertMsg "",refer
End Sub

Sub comment
	main
End Sub

Sub verifypic
	Dim id,i,dl,l:id=ReplaceStr(getForm("m_id","both")," ","")
	if id<>"" then
		Conn.db "UPDATE {pre}review SET m_check=1 WHERE m_id IN ("&id&")","execute"
		UpJson id
	end if
	alertMsg "",getRefer
End Sub

Sub UpJson(ByVal id)
	Dim i,dl,l
	dl=Conn.db("SELECT m_videoid,m_type FROM {pre}review WHERE m_id IN ("&id&")","array"):l=Ubound(dl,2)
	for i=0 to l
		delFile "../webcache/review/"&dl(1,i)&"/"&dl(0,i)&".js"
	next
End Sub

Sub delPic(ByVal id)
	Dim i,dl,l
	dl=Conn.db("SELECT m_pic FROM {pre}review WHERE m_id IN ("&id&")","array"):l=Ubound(dl,2)
	for i=0 to l
		delFile "../comment/upload/"&dl(0,i)
	next
End Sub
%>