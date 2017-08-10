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

viewHead "分类管理" & "-" & menuList(1,0)

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
<!--当前导航-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;分类管理';</script>
<form method="post"  name="editform">
<table class="tb2">
<tr class="thead"><th colspan="9">新闻分类管理(<font color='red'>＊</font>为必填,其它选填)</th></tr>	
<tr align="center">
			<td align="left" width="21%">ID.分类名称(文章数量)</td>
			<td width="10%">中文名</td>
			<td width="10%">英文名</td>
			<td width="10%">频道模板</td>
			<td width="10%">内容模板</td>
			<td width="10%">关键词</td>
			<td width="10%">描述</td>
			<td width="6%">排序</td>
			<td width="13%">&nbsp;操作</td>
</tr>
</table>
<%
	newsTypeList(0)
%>
<table class="tb"><tr><td>全选<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />反选<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" /><input type="submit" value="批量删除" onclick="if(confirm('确定要删除吗')){editform.action='?action=delall';}else{return false}" class="btn"  /><input type="submit" value="批量修改选中分类" class="btn" onclick="editform.action='?action=edit';" />&nbsp;&nbsp;&nbsp;移动到
      <select name="m_upid_to"><option value="0">顶级分类</option>
    <%makeNewsTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
	</select><input type="submit" value="批量移动分类" name="Submit" class="btn" onclick="editform.action='?action=move';"/></td></tr></table>
</form>

<table class="tb mt20">
<tr class="thead"><th colspan="9">添加分类</th></tr>	
<form method="post" action="?action=add"  name="addform" onSubmit="return validateform()">
<tr align="center">
    <td width="160" align=left>
    选择层级：
      <select name="m_upid"><option value="0">顶级分类</option>
    <%makeNewsTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
	</select><font color='red'>＊</font>
    </td>
    <td width="160">中文名<font color='red'>＊</font><br />
      <input type="text" size="10" name="m_name"></td>
    <td width="160">英文名<font color='red'>＊</font><br />
      <input type="text" size="10" name="m_enname"></td>
    <td width="140">频道模板<br />
      <input type="text" size="10" name="m_template"></td>
    <td width="140">内容模板<br />
      <input type="text" size="10" name="m_subtemplate"></td>
    <td width="140">关键词<br />
      <input type="text" size="10" maxlength="255" name="m_keyword"></td>
    <td width="140">描述<br />
      <input type="text" size="10" maxlength="255" name="m_description"></td>
    <td width="136">排序<br />
      <input type="text" size="3" name="m_sort"></td>
    <td width="175"><br />
<input type="submit" value="添 加" name="Submit" class="btn" /></td>
</tr>
</form>
</table>
<table class="tb mt20">
<tr class="thead"><th>合并分类</th></tr>
<form method="post" action="?action=merge">
<tr><td width="100%">将分类：<%makeNewsTypeSelect("leftSelect")%>的数据合并到：<%makeNewsTypeSelect("rightSelect")%><input type="submit" value="确认合并" class="btn" /><br /><font color=#FF0000>注意，程序将前面的分类数据合并到后面分类后会删除之前分类生成的HTML,但不会删除该分类。</font></td></tr>
</form>
</table>
<%	
End Sub

Sub popDiv
%>
<div id="unionarea" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('unionarea').style.display='none'" />平台分类列表</div>
    <div class="popbody"><div>
      <div id="unionids"></div>
    </div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>
<%	
End Sub

Sub mergeNewsType
	dim rightSelect,leftSelect,typePath
	leftSelect = getForm("leftSelect","post") : if isNul(leftSelect) then die "请选择分类"
	rightSelect = getForm("rightSelect","post") : if isNul(rightSelect) then die "请选择分类"
	typePath = getTypePath(leftSelect,"news")
	conn.db "update {pre}news set m_type="&rightSelect&" where m_type="&leftSelect,"execute":clearTypeCache
	if makeMode<>"dir2" then
		If not isNul(typePath) Then  delfolder "../"&typePath Else  alertMsg "分类别名丢失，以仿程序删除根目录，此请求不允许操作","admin_newstype.asp"  : die
	end if
	alertMsg "","admin_newstype.asp"
End Sub

Sub moveNewsType
	dim fromid,topid,ids,idArray,idsLen,subTypeList
	topid = getForm("m_upid_to","post")
	ids = replaceStr(getForm("m_id","post")," ","")
	if isNul(ids) then alertMsg "请选择需要移动的分类","":last:die ""
	idArray=split(ids,",") : idsLen=ubound(idArray)
	for i=0 to idsLen
		subTypeList=","&getNewsTypeIdOnCache(idArray(i))&","
		if not isExistStr(subTypeList,","&topid&",") then  conn.db "update m_type set m_upid ="&topid&" where m_id ="&idArray(i),"execute"
	next
	clearTypeCache:alertMsg "已经成功移动分类！","admin_newstype.asp"
End Sub

Sub addNewsType
	dim m_name,m_enname,m_sort,m_template,m_keyword,m_description,unionidArray,arrayLen,m_upid,m_subtemplate
	m_name = getForm("m_name","post")
	m_upid = getForm("m_upid","post")
	m_enname = getForm("m_enname","post")
	m_template = getForm("m_template","post") : if isNul(m_template) then m_template = "newspage.html"
	m_subtemplate = getForm("m_subtemplate","post") : if isNul(m_subtemplate) then m_subtemplate = "news.html"
	if isNul(m_name) or isNul(m_enname)   then  alertMsg "信息填写不完整，请检查",getRefer:die ""
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
		alertMsg "分类别名丢失，以防程序删除根目录，此请求不允许操作","admin_newstype.asp" : die ""
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
		alertMsg "请先删除该分类的子类","admin_newstype.asp" 
	else		
		if isExistSub(id,"news")=true  then alertMsg "请先删除该子类下的所有文章，并检查回收站","admin_newstype.asp" : die ""
		conn.db  "delete from {pre}type where m_id="&id, "execute":clearTypeCache
		if not isNul(typePath) Then
			if isExistFolder("../"&typePath)  then delFolder "../"&typePath
		else  
			alertMsg "分类别名丢失，以防程序删除根目录，此请求不允许操作","admin_newstype.asp" : die ""
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
		if isNul(id) or  isNul(m_name) or isNul(m_enname)   then  alertMsg "信息填写不完整，请检查",getRefer:die ""
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
		<td width="13%"><input type="button" value="删除" onClick="javascript:location.href='?action=del&m_id=<%=TL(l,i)%>';" name="Input" class="btn" /><%if TL(getTypeindex("m_hide"),i)=1 then %><input type="button" value="取消隐藏" onClick="javascript:location.href='?action=nohide&m_id=<%=TL(l,i)%>';" name="Input2" class="btn" style="width:60px"/><%elseif TL(getTypeindex("m_hide"),i)=0 then%><input type="button" value="隐藏" onClick="location.href='?action=hide&m_id=<%=TL(l,i)%>';" name="Input2" class="btn" style="width:60px"/> <%end if%></td>
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
