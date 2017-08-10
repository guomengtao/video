<!--#include file="admin_inc.asp"-->
<%
'******************************************************************************************
' Software name: Max(马克斯) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: 石头(maxcms2008@qq.com),yuet,长明,酒瓶
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************

viewHead "专题管理" & "-" & menuList(1,0)

dim action,keyword,id:action = getForm("action", "get"):keyword=ReplaceStr(getForm("keyword", "both"),"'","")
Const topicPath="../pic/zt/"

Select  case action
	case "last" : moveToLast
	case "next" : moveToNext
	case "del" : delTopic
	case "delall" : delAll
	case "edit" : editTopic
	case "editone" : editOneTopic
	case "add" : addTopic
	case else : main : popTopicWin
End Select 
viewFoot

Sub main
	dim Qe,Ary,i,n,m_id,page:id=getForm("id","get"):page=getForm("page","get")
	if isNul(page) then page=1
	if page<1 then page=1 else page=clng(page)
	SET Qe=mainClassobj.createObject("MainClass.DataPage")
	Qe.Query("SELECT m_id,m_name,m_sort,m_template,m_enname,m_pic,m_des,(select count(*) as m_count from {pre}data d where d.m_topic=t.m_id),'' as m_bigpic FROM {pre}topic as t "&ifthen(keyword<>"","WHERE m_name LIKE '%"&ReplaceStr(keyword,"*","%")&"%'","")&" ORDER BY m_sort asc,m_id asc")
	Qe.pagesize=10
	Qe.absolutepage=page
	Ary=Qe.GetRows()
	if page>Qe.pagecount then page=Qe.pagecount
%>
<script type="text/javascript">
function upformone(i){
	$('id').value=i,
	$('m_name').value=$('m_name'+i).value,
	$('m_pic').value=$('m_pic'+i).value,
	//$('m_bigpic').value=$('m_bigpic'+i).value,
	$('m_template').value=$('m_template'+i).value,
	$('m_enname').value=$('m_enname'+i).value,
	$('m_sort').value=$('m_sort'+i).value;
	$('form1').submit()
}
var _1;
function onUpClick(tg,el){
	_1=el;openWindow2(101,320,25,0);
	var msgDiv=$("msg");
	var _t = tg.offsetTop;
    var _l = tg.offsetLeft;
    while (tg = tg.offsetParent){_t+=tg.offsetTop; _l+=tg.offsetLeft;}
    msgDiv.style.cssText+="border:1px solid #55BBFF;background: #C1E7FF;padding:3px 0px 3px 4px;"
	msgDiv.style.top = (_t-1)+"px";
    msgDiv.style.left = (_l-1)+"px";
	msgDiv.innerHTML='<button type="button" class="btn" style="margin:0 6px 0 0;height:23px;float:right;padding:0;" onclick="closeWin()">关闭</button><iframe src="fckeditor/maxcms_upload.htm?iszt=1" scrolling="no" topmargin="0" width="270" height="25" marginwidth="0" marginheight="0" frameborder="0" align="center"></iframe>';
}

function onUploadBack(fn){
	if(!!_1) _1.value=fn;
	closeWin();
}
</script>
<div id="append_parent"></div>
<div class="container" id="cpcontainer">
<!--当前导航-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;专题管理';</script>
<form action="admin_topic.asp?action=editone" id="form1" name="form1" method="post">
<input type="hidden" name="m_id" id="id" value="" />
<input type="hidden" name="m_name" id="m_name" value="" />
<input type="hidden" name="m_pic" id="m_pic" value="" />
<input type="hidden" name="m_bigpic" id="m_bigpic" value="" />
<input type="hidden" name="m_template" id="m_template" value="" />
<input type="hidden" name="m_enname" id="m_enname" value="" />
<input type="hidden" name="m_sort" id="m_sort" value="" />
</form>
<form method="post" name="topicform">
<table class="tb">
<tr class="thead"><th colspan="9"><em style="font-weight:bold">专题管理</em><em style="color:#000;">&nbsp;&nbsp;&nbsp;关键字：<input name="keyword" type="text" id="keyword" size="20" value="<%=keyword%>"> <input type="submit" name="selectBtn" value="查 询..." class="btn" onclick="location.href='?action=<%=action%>&keyword='+escape($('keyword').value);" /></em></th></tr>
    <TR align="center">
		<TD width="7%">ID</TD>
		<TD width="17%">专题名称</TD>
		<TD width="13%">专题封面</TD>
		<!--<TD width="13%">专题大图</TD>-->
		<TD width="12%">专题模板</TD>
		<TD width="12%">专题别名</TD>
		<TD width="6%">描述</TD>
		<TD width="7%">排序</TD>
		<TD width="14%">操作</TD>
    </TR>
<%
	if Qe.recordcount>0 then
		n=ubound(Ary,2):keyword=Server.URLEncode(keyword)
		for i=0 to n
			m_id= trim(Ary(0,i))
	%>
	<TR <%if id=m_id then %> class="editlast"<%end if%> name="topictr" id="topictr<%=m_id%>" align="center">
		<td align="left"><input type="checkbox" value="<%=m_id%>" name="m_id"  checked="checked"  class="checkbox" /><%=m_id%></td>
		<td align="left"><input type="text" name="m_name<%=m_id%>" id="m_name<%=m_id%>" value="<%=Ary(1,i)%>" size="15"/>(<font color="red"><%=Ary(7,i)%></font>)</td>
		<td><input type="text" name="m_pic<%=m_id%>" id="m_pic<%=m_id%>" value="<%=Ary(5,i)%>" size="10"/>&nbsp;<button type="button" class="btn" style="width:50px;height:22px;" onclick="onUpClick(this,this.form.elements['m_pic<%=m_id%>'])">浏览..</button></td>
		<!--<td><input type="text" name="m_bigpic<%=m_id%>" id="m_bigpic<%=m_id%>" value="<%=Ary(8,i)%>" size="10"/>&nbsp;<button type="button" class="btn" style="width:50px;height:22px;" onclick="onUpClick(this,this.form.elements['m_bigpic<%=m_id%>'])">浏览..</button></td>-->
		<td><input type="text" name="m_template<%=m_id%>" id="m_template<%=m_id%>" value="<%=Ary(3,i)%>" size="10"/></td>
		<td><input type="text" name="m_enname<%=m_id%>" id="m_enname<%=m_id%>" value="<%=Ary(4,i)%>" size="10"/></td>
		<td><img <% if not isNul(Ary(6,i)) then%>src='imgs/modify1.gif'<%else%>src='imgs/modify.gif'<%end if%>  title='修改专题描述' style="cursor:pointer" onClick="viewCurrentTopicTr('<%=m_id%>');openTopicDesWin('topicdes','<%=m_id%>')" /></td>
		<td><input name="m_sort<%=m_id%>" id="m_sort<%=m_id%>" type="text" value="<%=Ary(2,i)%>"  size="3"/></td>
		<td><a href="?action=last&id=<%=m_id%>">上移</a> <a href="?action=next&id=<%=m_id%>">下移</a> <a href="javascript:upformone(<%=m_id%>)">修改</a> <a onclick="if(confirm('确定要删除吗')){return true;}else{return false;}" href="?action=del&id=<%=m_id%>">删除</a></td>
    </TR>
    <%
		next
	%>
    <tr><td colspan="9">全选<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />反选<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" /><input type="submit" value="批量删除" onclick="if(confirm('确定要删除吗')){topicform.action='?action=delall';}else{return false}" class="btn"  />&nbsp;&nbsp;<input type="submit" value="批量修改选中专题" name="Submit" class="btn" onclick="topicform.action='?action=edit';" /></td></tr>
	<tr>
		<td colspan="9"><div class="cuspages"><div class="pages">页次<%=page%>/<%=Qe.pagecount%> 每页<%=Qe.pagesize%>总收录数据<%=Qe.recordcount%>条 <a href="?page=1&action=<%=action%>&keyword=<%=keyword%>">首页</a> <a href="?page=<%=(page-1)%>&action=<%=action%>&keyword=<%=keyword%>">上一页</a> <%=makePageNumber(page, 10, Qe.pagecount, "adminlist")%><a href="?page=<%=(page+1)%>&action=<%=action%>&keyword=<%=keyword%>">下一页</a> <a href="?page=<%=Qe.pagecount%>&action=<%=action%>&keyword=<%=keyword%>">尾页</a>&nbsp;&nbsp;跳转<input type="text" id="skip" value="" onkeyup="this.value=this.value.replace(/[^\d]+/,'')" style="width:40px"/>&nbsp;&nbsp;<input type="button" value="确定" class="btn" onclick="location.href='?page='+$('skip').value+'&action=<%=action%>&keyword=<%=keyword%>';"/></div></div></td>
	</tr>
<%
	else
		echo "<tr><td colspan=""9"" align=""center"">暂无专题"&ifthen(keyword<>"",",<a href='javascript:history.go(-1)'><u>返回上一页</u></a>","")&"</td></tr>"
	end if	
%>
</TABLE>
</form>
<form action="?action=add" method="post">
	<table class="tb mt20">
		<tr class="thead"><th colspan="9">添加专题</th></tr>
		<tr align="center">
			<TD width="7%">&nbsp;</TD>
		  <TD width="19%">名称<font color='red'>＊</font><br>
	      <input type="text" size="15" name="m_name" /></TD>
			<TD width="13%">封面<font color='red'>＊</font><br><input type="text" name="m_pic" size="10"/>&nbsp;<button type="button" class="btn" style="width:50px;height:22px;" onclick="onUpClick(this,this.form.elements['m_pic'])">浏览..</button></TD>
			<!--<TD width="13%">大图<font color='red'>＊</font><br><input type="text" name="m_bigpic" size="10"/>&nbsp;<button type="button" class="btn" style="width:50px;height:22px;" onclick="onUpClick(this,this.form.elements['m_bigpic'])">浏览..</button></TD>-->
			<TD width="12%">模板<br><input type="text" name="m_template" size="10"/></TD>
			<TD width="12%">别名<font color='red'>＊</font><br><input type="text" name="m_enname" size="10"/></TD>			
			<TD width="6%">&nbsp;</td>
			<TD width="7%">排序<br><input type="text" size="3" name="m_sort"/></TD>
			<TD width="10%">&nbsp;<br>
		  &nbsp;<input type="submit" value="添加专题" class="btn" /></TD>
	  </tr>
	</table>
</form>
<%
	SET Qe=nothing
End Sub

Sub popTopicWin
%>
<div id="topicdes" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('topicdes').style.display='none'" />自定义标签路径 </div>
    <div class="popbody"><div>
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
<form id="f_des"  action="admin_ajax.asp?action=submittopicdes" method="post">
<tr>
  <td width="554" >专题简介：<br>
  <input type="hidden" name="f_m_id"   >
  <textarea cols="72"  rows="14"  name="f_m_des"></textarea></td><td></td>
</tr>
<tr><td><input type="button" onClick="submitTopicDes('topicdes')" value="修     改" class="btn" /></td></tr>
</form>
</table>
</div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>
<%	
End Sub

Sub moveToLast
	id=getForm("id","get")
	dim cur,cou,flag
	cur=conn.db("select m_sort from {pre}topic where m_id="&id,"execute")(0)
	cou=conn.db("select count(*) from {pre}topic  where m_sort<"&cur,"execute")(0)
	if cou>0 then 
		flag=conn.db("select top 1 m_sort from {pre}topic  where m_sort<"&cur&" order by m_sort desc","execute")(0)
		conn.db "update {pre}topic set m_sort="&flag&" where m_id="&id,"execute" 
	else
		conn.db "update {pre}topic set m_sort=m_sort-1 where m_id="&id,"execute" 
	end if
	alertMsg "","admin_topic.asp?id="&id
End Sub


Sub moveToNext
	id=getForm("id","get")
	dim cur,cou,flag
	cur=conn.db("select m_sort from {pre}topic where m_id="&id,"execute")(0)
	cou=conn.db("select count(*) from {pre}topic  where m_sort>"&cur,"execute")(0)
	if cou>0 then 
		flag=conn.db("select top 1 m_sort from {pre}topic  where m_sort>"&cur&" order by m_sort asc","execute")(0)
		conn.db "update {pre}topic set m_sort="&flag&" where m_id="&id,"execute" 
	else
		conn.db "update {pre}topic set m_sort=m_sort+1 where m_id="&id,"execute" 
	end if
	alertMsg "","admin_topic.asp?id="&id
End Sub

Sub delAll
	dim ids,id,idary : ids=replaceStr(getForm("m_id","post")," ",""):idary=split(ids,",")
	for each id in idary
		DelOldPic id,"",""
	next
	conn.db "delete from {pre}topic where m_id in ("&ids&")","execute" 
	conn.db "update {pre}data set m_topic=0 where m_topic in("&ids&")","execute"
	alertMsg "","admin_topic.asp"
End Sub

Sub delTopic
	id=getForm("id","get")
	DelOldPic id,"",""
	conn.db "delete from {pre}topic where m_id="&id,"execute"
	conn.db "update {pre}data set m_topic=0 where m_topic="&id,"execute"
	alertMsg "","admin_topic.asp?id="&id
End Sub

Sub editOneTopic
	dim id,m_name,m_sort,sqlStr,m_template,m_enname,m_pic,m_bigpic
	id = Clng(getForm("m_id","post"))
	m_name = getForm("m_name","post") : m_enname = getForm("m_enname","post") : m_pic = getForm("m_pic","post"):m_bigpic=getForm("m_bigpic","post")
	if  isNul(m_name) or isNul(m_enname) or isNul(m_pic) then  alertMsg "信息填写不完整，请检查","":last
	m_template = getForm("m_template","post") : if isNul(m_template) then m_template="topic.html"
	m_sort = getForm("m_sort","post") : if isNul(m_sort) then m_sort=conn.db("select max(m_sort) from {pre}topic","execute")(0)+1		
	if not isNum(m_sort) then alertMsg "排序必须为数字","":last
	DelOldPic id,m_pic,m_bigpic
	sqlStr = "update {pre}topic set m_name='"&m_name&"',m_sort="&m_sort&",m_template='"&m_template&"',m_enname='"&m_enname&"',m_pic='"&m_pic&"' where m_id="&id
	conn.db sqlStr,"execute" 
	alertMsg "","admin_topic.asp" 
End Sub

Sub editTopic
	dim ids,idsArray,id,m_name,m_sort,sqlStr,m_template,m_enname,m_pic,m_bigpic
	ids = replace(getForm("m_id","post")," ","")
	idsArray = split(ids,",")
	For Each id In idsArray
		id=Clng(id)
		m_name = getForm("m_name"&id,"post") : m_enname = getForm("m_enname"&id,"post") : m_pic = getForm("m_pic"&id,"post"):m_bigpic=getForm("m_bigpic"&id,"post")
		if  isNul(m_name) or isNul(m_enname) or isNul(m_pic) then alertMsg "信息填写不完整，请检查","":last
		m_template = getForm("m_template"&id,"post") : if isNul(m_template) then m_template="topic.html"
		m_sort = getForm("m_sort"&id,"post") : if isNul(m_sort) then m_sort=conn.db("select max(m_sort) from {pre}topic","execute")(0)+1		
		if not isNum(m_sort) then alertMsg "排序必须为数字","":last
		DelOldPic id,m_pic,m_bigpic
		sqlStr = "update {pre}topic set m_name='"&m_name&"',m_sort="&m_sort&",m_template='"&m_template&"',m_enname='"&m_enname&"',m_pic='"&m_pic&"' where m_id="&id
		conn.db sqlStr,"execute" 
	Next
	alertMsg "","admin_topic.asp" 
End Sub

Sub DelOldPic(ByVal m_id,ByVal newpic,ByVal newbigpic)
	dim rs:rs=conn.db("SELECT TOP 1 m_pic,'' as m_bigpic FROM {pre}topic WHERE m_id="&m_id,"array")
	if not isArray(rs) then exit sub
	if rs(0,0)<>newpic then delTopicPic rs(0,0)
	'if rs(1,0)<>newbigpic then delTopicPic rs(1,0)
End Sub

Sub delTopicPic(ByVal fn)
	fn=trim(fn):if fn="" then exit sub
	if isExistFile(topicPath&fn) then
		delFile(topicPath&fn)
	end if
End Sub

Sub addTopic
	dim m_name,m_sort,sqlStr,m_template,m_enname,m_pic,m_bigpic
	m_name = getForm("m_name"&id,"post") :  m_enname = getForm("m_enname","post") : m_pic = getForm("m_pic","post"):m_bigpic=getForm("m_bigpic","post")
	if  isNul(m_name) or isNul(m_enname) or isNul(m_pic) then  alertMsg "信息填写不完整，请检查","":last
	m_template = getForm("m_template","post") : if isNul(m_template) then m_template="topic.html"
	m_sort = getForm("m_sort","post") : if isNul(m_sort) then m_sort=conn.db("select max(m_sort) from {pre}topic","execute")(0)+1
	if not isNum(m_sort) then m_sort=1
	sqlStr = "insert into {pre}topic(m_name,m_sort,m_template,m_enname,m_pic) values ('"&m_name&"',"&m_sort&",'"&m_template&"','"&m_enname&"','"&m_pic&"')"
	conn.db sqlStr,"execute" 
	alertMsg "","admin_topic.asp"
End Sub
%>
