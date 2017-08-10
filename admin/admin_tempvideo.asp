<!--#include file="admin_inc.asp"-->
<!--#include file="../inc/pinyin.asp"-->
<%
'******************************************************************************************
' Software name: Max(马克斯) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: 石头(maxcms2008@qq.com),yuet,长明,酒瓶
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************
viewHead "临时数据管理" & "-" & menuList(3,0)

dim action,keyword:action = getForm("action", "get")

dim id,page,errorInfo : errorInfo="信息填写不完整，请检查"

Select  case action
	case "import" : importTempData
	case "del" : delTempData
	case "delall" : delAll
	case else : main
End Select 
viewFoot

Sub main
	dim dl,linkArray,i,n,m_id:page=getForm("page","get") 
	if isNul(page)  then page=1
	if page<1 then page=1 else page=clng(page)
	set dl = mainClassobj.createObject("MainClass.DataPage")
	dl.Query "SELECT m_id,m_name,m_type,m_actor,m_addtime FROM {pre}temp ORDER BY m_id DESC"
	dl.absolutepage=page
	dl.pagesize=50
	linkArray = dl.GetRows()
	if page > dl.pagecount then page=dl.pagecount
	if dl.recordcount>0 then
		n=ubound(linkArray,2)
%>
<div class="container" id="cpcontainer">
<!--当前导航-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(3,0)%>&nbsp;&raquo;&nbsp;临时表管理';</script>
<form action="?action=delall" method="post" name="tempdataform">

<table class="tb nobdt">
    <tr class="thead"><td colspan="15">临时表管理&nbsp;&nbsp;<a href="?action=delall&do=all" onclick="if(confirm('确定要删除所有吗')){return true;}else{return false;}"><u>清空临时表</u></a></td></tr>
    <TR>
      <TD  align="center">ID</TD>
      <TD align="center">名称</TD>
       <TD align="center">演员</TD>
       <TD  align="center">添加时间</TD>
      <TD   align="center">操作</TD>
    </TR>
    <%
		for i=0 to n
			m_id= trim(linkArray(0,i))
	%>
    <tr id="adtr<%=m_id%>" name="adtr" <%if id=m_id then %>  class="editlast"<%end if%> >
      <td  align="center"><input type="checkbox" value="<%=m_id%>" name="m_id"    /><%=m_id%></TD>
      <td align="center"><%=linkArray(1,i)%></TD>
      <td  align="center" title="<%=linkArray(3,i)%>" ><%=left(linkArray(3,i),20)%><%if len(linkArray(3,i))>20 then echo "..." end if%></TD>
      <td  align="center"><%isCurrentDay(linkArray(4,i))%></TD>
      <td   align="center"><a href="?action=del&id=<%=m_id%>" onclick="if(confirm('确定要删除吗')){return true;}else{return false;}">删除</a></TD>
    </tr>
    <%
		next
	%>
    <tr>
    <td colspan="7"><div class="cuspages"><div class="pages">全选<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />反选<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" />
    <select name="type" id="type"  ><option value="">请选择数据分类</option>
    <% makeTypeOption 0,"&nbsp;|&nbsp;&nbsp;" %>
	</select>
    
    <input type="submit" value="导入到数据表" onclick="tempdataform.action='?action=import';" class="btn"  />
	<input type="submit" value="批量删除" onclick="if(confirm('确定要批量删除吗')){return true}else{return false}" class="btn"  />
    &nbsp;&nbsp; 页次<%=page%>/<%=dl.pagecount%> 每页<%=dl.pagesize%>总收录数据条<%=dl.recordcount%> <a href="?page=1">首页</a> <a href="?page=<%=(page-1)%>">上一页</a> <%=makePageNumber(page, 15, dl.pagecount, "templist")%><a href="?page=<%=(page+1)%>">下一页</a> <a href="?page=<%=dl.pagecount%>">尾页</a></div></div></td></tr>
    <%
	else
	%>
    <tr><td colspan="6">对不起，无记录</td></tr>
    <%
	end if
	%>
</TABLE>
</form> 
</div>

<%
	set dl = nothing
End Sub

Sub importTempData
	dim ids,idsArray,idsLen,i,rsObjArray,rsObj,vtype,sql,m_sql,title,m_where,m_i,titleArray,m_playdata,m_enname
	ids = replaceStr(getForm("m_id","post")," ","") : vtype=getForm("type","post")
	if isNul(ids) then die "请选择数据"
	if isNul(vtype) then die "请选择导入的分类"
	idsArray=split(ids,",") : idsLen=ubound(idsArray)
	for i=0 to idsLen
		m_where=""		
		rsObjArray=conn.db("select top 1 m_id,m_name,m_type,m_state,m_pic,m_actor,m_des,m_playdata,m_publishyear,m_publisharea from {pre}temp where m_id="&idsArray(i),"array")
		title=rsObjArray(1,0)
		titleArray=split(title,"/")
		for m_i=0 to ubound(titleArray)
			if not isNul(titleArray(m_i)) then m_where=m_where&" or '/'+m_name+'/' like '%/"&titleArray(m_i)&"/%' "
		next
		m_where=trimOuterStr(m_where," or")
		m_sql="select top 1 m_id,m_playdata from {pre}data where "&m_where
		set rsObj=conn.db(m_sql,"execute")
		if rsObj.eof then
			m_enname=MoviePinYin(title)
			sql="insert into {pre}data(m_name,m_type,m_state,m_pic,m_actor,m_des,m_playdata,m_isunion,m_publishyear,m_publisharea,m_letter,m_enname) values('"&rsObjArray(1,0)&"',"&vtype&","&rsObjArray(3,0)&",'"&rsObjArray(4,0)&"','"&rsObjArray(5,0)&"','"&rsObjArray(6,0)&"','"&rsObjArray(7,0)&"',1,"&rsObjArray(8,0)&",'"&rsObjArray(9,0)&"','"&Left(m_enname,1)&"','"&m_enname&"')"
		else
			select case gatherSet
				case 0,1,2,3
					m_playdata = gatherIntoLibTransfer(rsObj("m_playdata"),rsObjArray(7,0),gatherSet):m_enname=MoviePinYin(title)
					sql="update {pre}data  set m_name='"&rsObjArray(1,0)&"',m_type="&vtype&",m_state="&rsObjArray(3,0)&",m_playdata='"&m_playdata&"',m_isunion=1,m_addtime='"&now()&"',m_letter='"&Left(m_enname,1)&"',m_enname='"&m_enname&"' where m_id="&rsObj("m_id")
				case 4
					m_enname=MoviePinYin(title)
					sql="insert into {pre}data(m_name,m_type,m_state,m_pic,m_actor,m_des,m_playdata,m_isunion,m_publishyear,m_publisharea) values('"&rsObjArray(1,0)&"',"&vtype&","&rsObjArray(3,0)&",'"&rsObjArray(4,0)&"','"&rsObjArray(5,0)&"','"&rsObjArray(6,0)&"','"&rsObjArray(7,0)&"',1,"&rsObjArray(8,0)&",'"&rsObjArray(9,0)&"','"&Left(m_enname,1)&"','"&m_enname&"')"
				case 5
					sql="update {pre}data set m_pic='"&rsObjArray(4,0)&"',m_actor='"&rsObjArray(5,0)&"',m_des='"&rsObjArray(6,0)&"',m_publishyear="&rsObjArray(8,0)&",m_publisharea='"&rsObjArray(9,0)&"',m_addtime='"&now()&"' where m_id="&rsObj("m_id")
			end select			
		end if
		rsObj.close : set rsObj=nothing
		conn.db sql,"execute"
		conn.db "delete from {pre}temp where m_id="&idsArray(i),"execute"
		echo "数据"&rsObjArray(1,0)&"导入成功<br>"	
	next
	alertMsg "","admin_tempvideo.asp"
End Sub

Sub delAll
	if getForm("do","get")="all" then
		conn.db  "delete from {pre}temp","execute"
	else
		dim ids:ids = replaceStr(getForm("m_id","post")," ","")
		conn.db  "delete from {pre}temp where m_id in("&ids&")","execute"
	end if
	alertMsg "","admin_tempvideo.asp"
End Sub

Sub delTempData
	dim back
	back = request.ServerVariables("HTTP_REFERER")
	id = getForm("id","get")
	conn.db  "delete from {pre}temp where m_id ="&id,"execute" 
	alertMsg "",back
End Sub

%>
