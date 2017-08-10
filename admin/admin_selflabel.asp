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
viewHead "自定义标签管理" & "-" & menuList(2,0)

dim action,keyword : action = getForm("action", "get")

dim id,page,errorInfo,errorSelflabel : errorInfo="信息填写不完整，请检查":errorSelflabel="已经存在此标签，请更换名称"

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
<!--当前导航-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(2,0)%>&nbsp;&raquo;&nbsp;自定义标签管理';</script>

<table align="left"><tr><td><input type="button" value="添加自定义标签" onClick="location.href='?action=add'" class="btn" /></td></tr></table>
<%
	if dl.recordcount>0 then
		n=ubound(linkArray,2) 
%>
<form name="selflabelform" method="post">
<table class="tb">
<tr class="thead"><th colspan="6">自定义标签管理</th></tr>
    <TR align="center">
      <TD>ID</TD>
      <TD>名称</TD>
       <TD>标签代码</TD>
       <TD>描述</TD>
       <TD>添加时间</TD>
      <TD>操作</TD>
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
      <TD><a href="#" onclick="viewCurrentAdTr('<%=m_id%>');copyToClipboard('<%="{self:"&linkArray(1,i)&"}"%>');">调用标签</a> <a href="#" onClick="viewCurrentAdTr('<%=m_id%>');openSelfLabelWin('selflabel','<%=m_id%>')">查看内容</a>&nbsp;&nbsp;<a href="?action=edit&page=<%=page%>&id=<%=m_id%>">编辑</a>&nbsp;&nbsp;<a  onclick="if(confirm('确定要删除吗')){return true;}else{return false;}" href="?action=del&id=<%=m_id%>">删除</a></TD>
    </TR>
    <%
		next
	%>
    <tr bgcolor="#FFFFFF"align="center">
    <td  colspan="6"><div class="cuspages center"><div class="pages">全选<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />反选<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" /><input type="submit" value="批量删除" onclick="if(confirm('确定要删除吗')){selflabelform.action='?action=delall';}else{return false}" class="btn"  />&nbsp;&nbsp;页次<%=page%>/<%=dl.pagecount%> 每页<%=dl.pagesize%>总收录数据条<%=dl.recordcount%> <a href="?page=1">首页</a> <a href="?page=<%=(page-1)%>">上一页</a> <%=makePageNumber(page, 15, dl.pagecount, "selflabellist")%><a href="?page=<%=(page+1)%>">下一页</a> <a href="?page=<%=dl.pagecount%>">尾页</a></div></div></td></tr>
</TABLE>
</form>
<%
	else
		echo "<table class='tb'><tr><td>没有自定义标签</td></tr></table>"		
	end if	
%>
</div>
<%
	set dl = nothing
End Sub

Sub popDiv
%>
<div id="selflabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('selflabel').style.display='none'" />自定义标签路径 </div>
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
<tr class="thead"><th colspan="2">添加自定义标签</th></tr>
    <TR>
      <TD vAlign=center width="11%" >自定义标签名称：</TD>
      <TD width="89%" ><input type="text" size="50" name="m_name" />(请填写英文字母或数字)<font color="red">＊</font></TD>
    </TR>
 
    <TR>
      <TD >自定义标签描述：</TD>
      <TD ><input type="text" size="100" name="m_des" /></TD>
    </TR>
    <TR>
      <TD >自定义标签内容： </TD>
      <TD ><textarea name="m_content"  cols="100" rows="20" ></textarea><font color="red">＊</font><br />
      如果希望同时多个内容随机显示，请使用$$$隔开 
      </TD>
    </TR>
    <TR >
      <td></td><TD><input type="submit" value="添加自定义标签" class="btn" />
      &nbsp;<input type="button" value="返   回"  class="btn" onClick="javascript:history.go(-1)" /></TD>
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
	<tr class="thead"><th colspan="2">编辑自定义标签</th></tr>
	<tr>
      <TD width="15%">自定义标签名称：</TD>
      <TD><input type="text" size="50" name="m_name" value="<%=rsObj("m_name")%>" /><font color="red">＊</font></TD>
    </TR>

    <TR>
      <TD >自定义标签描述：</TD>
      <TD ><input type="text" size="100" name="m_des" value="<%=rsObj("m_des")%>" /></TD>
    </TR>
    <TR>
      <TD >自定义标签内容：</TD>
      <TD ><textarea name="m_content"  cols="100" rows="20" ><%=decodeHtml(rsObj("m_content"))%></textarea><font color="red">＊</font><br />
      如果希望同时多个内容随机显示，请使用$$$隔开 </TD>
    </TR>
    <TR >
    <td></td> <TD ><input type="submit" value="修改自定义标签" class="btn" />
      &nbsp;<input type="button" value="返   回"  class="btn" onClick="javascript:history.go(-1)" /></TD>
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
	alertMsg "添加成功","admin_selflabel.asp"
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
	alertMsg "修改成功","admin_selflabel.asp?id="&id&"&page="&page
End Sub
%>
</div>