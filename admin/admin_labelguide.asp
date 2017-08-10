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
viewHead "标签向导" & "-" & menuList(2,0)

dim action : action = getForm("action", "get")

Select case action
	case "videolist" : main : createVideoList
	case "menulist" : main : createMenuList
	case "arealist" : main : createAreaList
	case "linklist" : main : createLinkList
	case "channellist" : main : createChannelList
	case "topiclist" : main : createTopicList
	case "newslist" : main : createNewsList
	case "newspagelist" : main : createNewsPageList
	case "topicpagelist" : main : createtopicpagelist
	case else : main
End Select 

viewFoot

Sub main
%>
<script type="text/javascript">
if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(2,0)%>&nbsp;&raquo;&nbsp;标签向导';
Array.prototype.push=function (){
	var arg=arguments;
	for(var i=0;i<arg.length;i++){
		this[this.length]=arg[i];
	}
	return this;
}
String.prototype.stick=function (val){
	return (','+this+',').indexOf(','+val+',')!=-1 ? this : this.split(',').push(val).join(',');
}
</script>
<div id="append_parent"></div>
<div class="container" id="cpcontainer">
	<table class="tb">
		<tr class="thead"><th>标签向导</th></tr>
		<tr><td>
			<input type="button" class="btn" value="menulist(菜单导航标签)" style="width:250px;" onclick="self.location.href='?action=menulist'"/><br>
			<input type="button" class="btn" value="videolist(数据列表标签)" style="width:250px;" onclick="self.location.href='?action=videolist'" /><br>
			<input type="button" class="btn" value="arealist(双重循环列表标签)" style="width:250px;" onClick="self.location.href='?action=arealist'"/><br>
			<input type="button" class="btn" value="channellist(分页列表标签)" style="width:250px;" onClick="self.location.href='?action=channellist'"/><br>
			<input type="button" class="btn" value="topiclist(专题列表标签)" style="width:250px;" onclick="self.location.href='?action=topiclist'"/><br>
			<input type="button" class="btn" value="linklist(友情链接列表标签)" style="width:250px;" onclick="self.location.href='?action=linklist'"/><br>
			<input type="button" class="btn" value="newslist(新闻列表标签)" style="width:250px;" onclick="self.location.href='?action=newslist'"/><br>
			<input type="button" class="btn" value="newspagelist(新闻分页列表标签)" style="width:250px;" onclick="self.location.href='?action=newspagelist'"/><br>
			<input type="button" class="btn" value="topicpagelist(专题分页列表标签)" style="width:250px;" onclick="self.location.href='?action=topicpagelist'"/><br>
		</td></tr>
	</table>
<%
End Sub

Sub createVideoList
dim i
%>
<script type="text/javascript">
	function viewSelectedType(el,txtid){
		var v=el.options[el.selectedIndex].value;
		if ($(txtid).value.indexOf("all")>-1 || v=='all'){
			$(txtid).value=v;
		}else{
			$(txtid).value=$(txtid).value.stick(v);
		}
		videolist_create();
	}
	function videolist_create(){
		var wherestr=""
		if (isNaN($("num").value)){alert('调用数据数必须为数字');wherestr+=" num=10"}else{if($("num").value!=10){wherestr+=" num="+$("num").value}}
		if (isNaN($("start").value)){alert('起点必须为数字');wherestr+=" start=1"}else{if($("start").value>1){wherestr+=" start="+$("start").value}}
		if ($("order").options[$("order").selectedIndex].value!='time'){wherestr+=" order="+$("order").options[$("order").selectedIndex].value}
		if ($("typetext").value!="all"){wherestr+=" type="+$("typetext").value}
		if ($("lettxt").value!="all"){wherestr+=" letter="+$("lettxt").value}
		if ($("topic").options[$("topic").selectedIndex].value!=''){wherestr+=" topic="+$("topic").options[$("topic").selectedIndex].value}
		if ($("time").options[$("time").selectedIndex].value!=0){wherestr+=" time="+$("time").options[$("time").selectedIndex].value}
		if ($("commend").options[$("commend").selectedIndex].value!=''){wherestr+=" commend="+$("commend").options[$("commend").selectedIndex].value}else{wherestr+=""}
		wherestr="<b>标签说明:调用视频列表</b><br>{maxcms:videolist"+wherestr+"}<br>"
		if($("vname").checked){
			if (isNaN($("vnamelen").value)){
				alert('长度必须为数字')
			}else{
				if ($("vnamelen").value!=10){wherestr+="&nbsp;&nbsp;[videolist:name len="+$("vnamelen").value+"]表示数据名<br>"}else{wherestr+="&nbsp;&nbsp;[videolist:name]表示数据名<br>"}
			}
		}
		if($("vcolorname").checked){
			if (isNaN($("vcolornamelen").value)){
				alert('长度必须为数字')
			}else{
				if ($("vcolornamelen").value!=10){wherestr+="&nbsp;&nbsp;[videolist:colorname len="+$("vcolornamelen").value+"]表示彩色数据名<br>"}else{wherestr+="&nbsp;&nbsp;[videolist:colorname]表示彩色数据名<br>"}
			}
		}
		if($("actor").checked){
			if (isNaN($("actorlen").value)){
				alert('长度必须为数字')
			}else{
				if ($("actorlen").value!=10){wherestr+="&nbsp;&nbsp;[videolist:actor len="+$("actorlen").value+"]表示主演<br>"}else{wherestr+="&nbsp;&nbsp;[videolist:actor]表示主演<br>"}
			}
		}
		if($("des").checked){
			if (isNaN($("deslen").value)){
				alert('长度必须为数字')
			}else{
				if ($("deslen").value!=10){wherestr+="&nbsp;&nbsp;[videolist:des len="+$("deslen").value+"]表示数据描述<br>"}else{wherestr+="&nbsp;&nbsp;[videolist:des]表示数据描述<br>"}
			}
		}
		if($("addtime").checked){
			if ($("timestyle").options[$("timestyle").selectedIndex].value!='y-m-d'){wherestr+="&nbsp;&nbsp;[videolist:time style="+$("timestyle").options[$("timestyle").selectedIndex].value+"]表示添加时间<br>"}else{wherestr+="&nbsp;&nbsp;[videolist:time]表示添加时间<br>"}
		}
		if($("i").checked){wherestr+="&nbsp;&nbsp;[videolist:i]表示排序位<br>"}
		if($("typename").checked){wherestr+="&nbsp;&nbsp;[videolist:typename]表示排序位<br>"}
		if($("typelink").checked){wherestr+="&nbsp;&nbsp;[videolist:typelink]表示分类链接<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[videolist:link]表示视频链接<br>"}
		if($("pic").checked){wherestr+="&nbsp;&nbsp;[videolist:pic]表示图片<br>"}
		if($("hit").checked){wherestr+="&nbsp;&nbsp;[videolist:hit]表示点击量 <br>"}
		if($("note").checked){wherestr+="&nbsp;&nbsp;[videolist:note]表示备注<br>"}
		if($("state").checked){wherestr+="&nbsp;&nbsp;[videolist:state]表示状态<br>"}
		if($("vcommend").checked){wherestr+="&nbsp;&nbsp;[videolist:commend]表示推荐级别<br>"}
		if($("vfrom").checked){wherestr+="&nbsp;&nbsp;[videolist:from]表示来源<br>"}
		if($("publisharea").checked){wherestr+="&nbsp;&nbsp;[videolist:publisharea]表示发行地区<br>"}
		if($("publishtime").checked){wherestr+="&nbsp;&nbsp;[videolist:publishtime]表示发行日期<br>"}
		wherestr=wherestr+"{/maxcms:videolist}"
		set($("labelcontent"),wherestr)
	}
</script>
<div id="videolistlabel" style="top:100px; display:none;" class="popdiv">
<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('videolistlabel').style.display='none'" />创建videolist(数据列表标签)</div>
<div class="popbody"><div>
<table class="tb" onClick="videolist_create()">
<tr>
	<td colspan="2"><font color="#FF0000">设置标签属性</font></td>
</tr>
<tr>
	<td>调用数据条数：<input type="text" id="num" size="8" value="10"/>默认(10)</td>
	<td>起点：<input type="text" id="start" size="8" value="1"/>默认(从第1条开始调)</td>
</tr>
<tr>
	<td>排列顺序：<select id="order" onchange="videolist_create()">
<script type="text/javascript">
	var o={time: "时间",id: "数据ID",commend: "推荐星级",hit: "点击量",digg: "顶的次数",'random': "随机",dayhit: "当天点击量",weekhit: "周点击量",monthhit: "月点击量",score: "总得分"};
	for(var i in o){
		document.write('<option value="'+i+'">'+o[i]+'</option>');
	}
</script>
</select>默认(按时间) </td><td >分类： <select name="type" id="type" style="width:100px;" onChange="viewSelectedType(this,'typetext')"><option value="all">所有</option>
	<%makeTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
	</select><input id="typetext" value="all" size="8" />默认(所有) </td>
</tr>
<tr>
	<td>专题：<% 
	dim topicArray : topicArray = conn.db("select m_id,m_name from {pre}topic order by m_id asc","array")
	echo makeTopicSelect("topic",topicArray,"未选择专题","")
	%>默认(不选择) </td>
	<td>时间：<select id="time" onchange="videolist_create()"><option value="0">未选择时间</option><option value="day">当天</option><option value="week">当周</option><option value="month">当月</option></select>默认(不选择)</td>
</tr>
<tr>
	<td>推荐级别：<select id="commend" onchange="videolist_create()"><option value="">取消</option><option value="all">所有推荐</option><option value="1">1星</option><option value="2">2星</option><option value="3">3星</option><option value="4">4星</option><option value="5">5星</option></select></td>
	<td>首拼字母：<select id="letter" onchange="viewSelectedType(this,'lettxt')"><option value="all">所有</option>
	<%
	for i=65 to 90
		echo "<option value="""&chr(i)&""">"&chr(i)&"</option>"
	next
	%>
	</select><input type="text" id="lettxt" name="lettxt" size="10" value="all"/></td>
</tr>
<tr>
	<td colspan="2"><font color="#FF0000">选择标签变量</font></td>
</tr>
<tr>
	<td>视频名<input type="checkbox" value="1" name="vname" id="vname" class="radio" />&nbsp;&nbsp;长度<input type="text" id="vnamelen" name="vnamelen" size="4" value="10" /></td>
	<td>彩色视频名<input type="checkbox" value="1" name="vcolorname" id="vcolorname" class="radio" />&nbsp;&nbsp;长度<input type="text" id="vcolornamelen" name="vcolornamelen" size="4" value="10" /></td>
</tr>
<tr>
	<td>主演<input id="actor" name="actor" type="checkbox" value="1" class="radio" />&nbsp;&nbsp;主演长度<input type="text" id="actorlen" name="actorlen" size="4" value="10"/></td>
	<td>描述<input type="checkbox" value="1" name="des" id="des" class="radio" />&nbsp;&nbsp;描述长度<input type="text" id="deslen" name="deslen" size="4" value="40"/></td>
</tr>
<tr>
	<td colspan="2">添加时间<input id="addtime" name="addtime" type="checkbox" value="1" class="radio" />&nbsp;&nbsp;时间格式<select id="timestyle" onchange="videolist_create()"><option value="y-m-d">年(缩写)-月-日</option><option value="yy-m-d">年-月-日</option><option value="m-d">月-日</option></select></td>
</tr>
<tr><td colspan="2">
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />排序位</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="typename" name="typename" class="radio" />分类名</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="typelink" name="typelink" class="radio" />分类链接</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="link" name="link" class="radio" />视频链接</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="pic" name="pic" class="radio" />图片</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="hit" name="hit" class="radio" />点击量</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="note" name="note" class="radio" />备注</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="state" name="state" class="radio" />状态</label><br />
<label><input type="checkbox" value="1" id="vcommend" name="vcommend" class="radio" />推荐级别</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="vfrom" name="vfrom" class="radio" />来源</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="publisharea" name="publisharea" class="radio" />发行地区</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="publishtime" name="publishtime" class="radio" />发行日期</label>
</td></tr>
<!--
<tr><td colspan="2"><input type="button" class="btn" value="按上述我设置的条件生成标签" onclick="videolist_create()"/></td></tr>
-->
<tr><td colspan="2" ><div name="labelcontent" id="labelcontent"></div></td>
</tr>
</table>
 </div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>	
<script>view("videolistlabel");selfLabelWindefault("videolistlabel");$('topic').onchange=videolist_create;</script>
<%	
End Sub

Sub createMenuList
%>
<script type="text/javascript">
function menulist_create(){
	var x=$("type"),y=x.options[x.selectedIndex].value,z=$('id').style;
	var wherestr=$("byn").checked ? ' by=news' : '';
	if(y=='id'){
		if(z.display=='none') z.display='';
		wherestr+=" type="+$('typetext').value;
	}else if (y!='top'){
		if(z.display!='none') z.display='none';
		wherestr+=" type="+y;
	}
	wherestr="<b>标签说明:调用菜单列表</b><br>{maxcms:menulist"+wherestr+"}<br>"
	if($("i").checked){wherestr+="&nbsp;&nbsp;[menulist:i]表示排序位<br>"}
	if($("typename").checked){wherestr+="&nbsp;&nbsp;[menulist:typename]表示菜单项名称<br>"}
	if($("typeid").checked){wherestr+="&nbsp;&nbsp;[menulist:typeid]表示菜单项id<br>"}
	if($("upid").checked){wherestr+="&nbsp;&nbsp;[menulist:upid]表示父菜单项id<br>"}
	if($("link").checked){wherestr+="&nbsp;&nbsp;[menulist:link]表示菜单项链接<br>"}
	wherestr=wherestr+"{/maxcms:menulist}"
	set($("labelcontent"),wherestr)
}
function viewSelectedType(){
	var o=getSelect(),x=$("typetext"),v=o.options[o.selectedIndex].value;
	if (x.value.indexOf("top")!=-1 || v=='top'){
		x.value=v;
	}else{
		x.value=x.value.stick(v);
	}
	menulist_create();
}
function getSelect(){
	return $('typeids'+($("byn").checked ? '2' : ''));
}
</script>
<div id="menulistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('menulistlabel').style.display='none'" />创建menulist(菜单栏标签)</div>
 <div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb" onClick="menulist_create()">
<tr><td colspan="2"><font color="#FF0000">设置标签属性</font> <input type="radio" class="radio" name="by" id="byv" value="video" onclick="hide('typeids2');view('typeids');$('typetext').value='top';" checked/>视频 <input type="radio" class="radio" name="by" id="byn" onclick="hide('typeids');view('typeids2');$('typetext').value='top';" value="news"/>新闻</td></tr>
<tr>
	<td><span>类型：<select id="type" name="type" onchange="menulist_create()"><option value="top">一级菜单导航</option><option value="all">所有菜单导航</option><option value="son">子菜单导航</option><option value="id">自定义调用ID</option></select></span>
	<span id="id" style="display:none">
	<select id="typeids" style="width:100px;" onChange="viewSelectedType()"><option value="top">一级菜单导航</option><%makeTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%></select><select id="typeids2" style="width:100px;" onChange="viewSelectedType()" style="display:none"><option value="top">一级菜单导航</option><%makeNewsTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%></select>&nbsp;<input type="text" name="typetext" id="typetext" value="top"/></span> 默认(一级菜单导航)</td>
	<td></td>
</tr>
<tr><td colspan="2"><font color="#FF0000">选择标签变量</font></td></tr>
 <tr><td colspan="2">
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />排序位</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="typename" name="typename" class="radio" />菜单项名称</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="typeid" id="typeid" class="radio"/>菜单项id</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="upid" id="upid" class="radio"/>父菜单项id</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="radio" />菜单项链接</label></td></tr>
<!--
<tr bgcolor="ffffff"><td colspan="2"><input type="button" value="按上述我设置的条件生成标签" class="btn" onClick="menulist_create()"/></td></tr>
-->
<tr><td colspan="2"><div name="labelcontent" id="labelcontent"><br></div></td>
</tr>
</table>
 </div></div>
</div>	
<script type="text/javascript" src="imgs/drag.js"></script>	
<script>view("menulistlabel");selfLabelWindefault("menulistlabel");	</script>
<%
End Sub

Sub createAreaList
%>
<script>
	function viewSelectedType(){
		if ($("typetext").value.indexOf("all")>-1 || $("type").options[$("type").selectedIndex].value=='all'){
			$("typetext").value=$("type").options[$("type").selectedIndex].value;
		}else{
			$("typetext").value+=","+$("type").options[$("type").selectedIndex].value;
		}
		if($("typetext").value.indexOf(",")==0){
			$("typetext").value= $("typetext").value.slice(1,$("typetext").value.length)
		}else if ($("typetext").value.lastIndexOf(",")== $("typetext").value.length-1 ){
			$("typetext").value=$("typetext").value.slice(0,$("typetext").value.length-2)
		}
	}
	function arealist_create(){
		var wherestr=""
		if ($("typetext").value!="all"){wherestr+=" areatype="+$("typetext").value}
		wherestr="<b>标签说明:调用视频区域列表</b><br>{maxcms:arealist"+wherestr+"}<br>"
		if($("i").checked){wherestr+="&nbsp;&nbsp;[arealist:i]表示排序位<br>"}
		if($("typename").checked){wherestr+="&nbsp;&nbsp;[arealist:typename]表示分类名称<br>"}
		if($("count").checked){wherestr+="&nbsp;&nbsp;[arealist:count]表示分类中视频数量<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[arealist:link]表示分类链接<br>"}
		
		wherestr=wherestr+"&nbsp;&nbsp;{maxcms:videolist type=areatype}{/maxcms:videolist}表示嵌套的视频列表<br>{/maxcms:arealist}"
		set($("labelcontent"),wherestr)
	}
</script>
<div id="arealistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('arealistlabel').style.display='none'" />创建arealist(循环区域标签)</div>
<div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb">
<tr><td colspan="2"><font color="#FF0000">设置标签属性</font></td></tr>
<tr><td >分类： <select name="type" id="type" style="width:180px;" onChange="viewSelectedType()"><option value="all">所有</option>
 <%makeTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
	</select><input id="typetext" value="all" size="20" />默认(所有) </td><td ></td></tr>
<tr><td colspan="2"><font color="#FF0000">选择标签变量</font></td></tr>
 <tr><td colspan="2"> 
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />排序位</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="typename" name="typename" class="radio" />分类名称</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="count" id="count" class="radio" />分类中视频数量</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="radio" />分类链接</label></td></tr>
 <tr bgcolor="ffffff"><td colspan="2"><input type="button" value="按上述我设置的条件生成标签" class="btn" onClick="arealist_create()"/></td></tr>
<tr><td colspan="2" ><div name="labelcontent" id="labelcontent" ></div></td>
</tr>
</table>
 </div></div>
</div>	
<script type="text/javascript" src="imgs/drag.js"></script>	
<script>view("arealistlabel");selfLabelWindefault("arealistlabel");	</script>	
<%
End Sub

Sub createLinkList
%>
<script>
	function linklist_create(){
		var wherestr=""
		if ($("type").options[$("type").selectedIndex].value!='pic'){wherestr+=" type="+$("type").options[$("type").selectedIndex].value}
		wherestr="<b>标签说明:调用友情链接列表</b><br>{maxcms:linklist"+wherestr+"}<br>"
		
		if($("name").checked){
			if (isNaN($("namelen").value)){
				alert('长度必须为数字')
			}else{
				if ($("namelen").value!=10){wherestr+="&nbsp;&nbsp;[linklist:name len="+$("namelen").value+"]表示链接名称<br>"}else{wherestr+="&nbsp;&nbsp;[linklist:name]表示链接名称<br>"}
			}
		}
		
		if($("des").checked){
			if (isNaN($("namelen").value)){
				alert('长度必须为数字')
			}else{
				if ($("deslen").value!=50){wherestr+="&nbsp;&nbsp;[linklist:des len="+$("deslen").value+"]表示链接描述<br>"}else{wherestr+="&nbsp;&nbsp;[linklist:des]表示链接描述<br>"}
			}
		}
		
		if($("i").checked){wherestr+="&nbsp;&nbsp;[linklist:i]表示排序位<br>"}
		if($("pic").checked){wherestr+="&nbsp;&nbsp;[linklist:pic]表示链接图片<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[linklist:link]表示链接地址<br>"}
		
		wherestr=wherestr+"{/maxcms:linklist}"
		set($("labelcontent"),wherestr)
	}
</script>
<div id="linklistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('linklistlabel').style.display='none'" />创建linklist(友情链接标签)</div>
<div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb">
<tr><td colspan="2"><font color="#FF0000">设置标签属性</font></td></tr>
<tr><td>类型：<select id="type" name="type"><option value="pic">图片友情链接</option><option value="font">文字友情链接</option></select>默认(图片友情链接) </td><td ></td></tr>
<tr><td colspan="2"><font color="#FF0000">选择标签变量</font></td></tr>
<tr><td > 链接名称
 <input type="checkbox" value="1" name="name" id="name" class="checkbox" />
 &nbsp;&nbsp;
 长度
 <input type="text" id="namelen" name="namelen" size="4" value="10" /></td>
 <td >链接描述
 <input id="des" name="des" type="checkbox" value="1" class="checkbox" />
 &nbsp;&nbsp;主演长度
 <input type="text" id="deslen" name="desrlen" size="4" value="50"/></td></tr>
 
 <tr><td colspan="2"> 
<label><input type="checkbox" value="1" id="i" name="i" class="checkbox" />排序位</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="pic" name="pic" class="checkbox" />链接图片</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="checkbox" />链接地址</label></td></tr>
 <tr bgcolor="ffffff"><td colspan="2"><input type="button" value="按上述我设置的条件生成标签" class="btn" onClick="linklist_create()"/></td></tr>
<tr><td colspan="2" ><div name="labelcontent" id="labelcontent" ></div></td>
</tr>
</table>	
 </div></div>
</div>	
<script type="text/javascript" src="imgs/drag.js"></script>	
<script>view("linklistlabel");selfLabelWindefault("linklistlabel");	</script>	
<%
End Sub

Sub createChannelList
%>
<script>
	function channellist_create(){
		var wherestr="",varstr
		if (isNaN($("size").value)){alert('每页数据条数必须为数字');wherestr+=" size=10"}else{if($("size").value!=10){wherestr+=" size="+$("size").value}}
		if ($("order").options[$("order").selectedIndex].value!='time'){wherestr+=" order="+$("order").options[$("order").selectedIndex].value}
		wherestr="<b>标签说明:调用频道分页列表</b><br>{maxcms:channellist"+wherestr+"}<br>"
		if($("vname").checked){
			if (isNaN($("vnamelen").value)){
				alert('长度必须为数字')
			}else{
				if ($("vnamelen").value!=10){wherestr+="&nbsp;&nbsp;[channellist:name len="+$("vnamelen").value+"]表示数据名<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:name]表示数据名<br>"}
			}
		}
		if($("vcolorname").checked){
			if (isNaN($("vcolornamelen").value)){
				alert('长度必须为数字')
			}else{
				if ($("vcolornamelen").value!=10){wherestr+="&nbsp;&nbsp;[channellist:colorname len="+$("vcolornamelen").value+"]表示彩色数据名<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:colorname]表示彩色数据名<br>"}
			}
		}
		if($("actor").checked){
			if (isNaN($("actorlen").value)){
				alert('长度必须为数字')
			}else{
				if ($("actorlen").value!=10){wherestr+="&nbsp;&nbsp;[channellist:actor len="+$("actorlen").value+"]表示主演<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:actor]表示主演<br>"}
			}
		}
		if($("des").checked){
			if (isNaN($("deslen").value)){
				alert('长度必须为数字')
			}else{
				if ($("deslen").value!=10){wherestr+="&nbsp;&nbsp;[channellist:des len="+$("deslen").value+"]表示描述<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:des]表示描述<br>"}
			}
		}
		if($("addtime").checked){
			if ($("timestyle").options[$("timestyle").selectedIndex].value!='y-m-d'){wherestr+="&nbsp;&nbsp;[channellist:time style="+$("timestyle").options[$("timestyle").selectedIndex].value+"]表示添加时间<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:time]表示添加时间<br>"}
		}
		if($("i").checked){wherestr+="&nbsp;&nbsp;[channellist:i]表示排序位<br>"}
		if($("typename").checked){wherestr+="&nbsp;&nbsp;[channellist:typename]表示分类名<br>"}
		if($("typelink").checked){wherestr+="&nbsp;&nbsp;[channellist:typelink]表示分类链接<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[channellist:link]表示视频链接<br>"}
		if($("pic").checked){wherestr+="&nbsp;&nbsp;[channellist:pic]表示图片<br>"}
		if($("hit").checked){wherestr+="&nbsp;&nbsp;[channellist:hit]表示点击量<br>"}
		if($("state").checked){wherestr+="&nbsp;&nbsp;[channellist:state]表示状态<br>"}
		if($("vcommend").checked){wherestr+="&nbsp;&nbsp;[channellist:commend]表示推荐级别<br>"}
		if($("vfrom").checked){wherestr+="&nbsp;&nbsp;[channellist:from]表示来源<br>"}
		if($("publisharea").checked){wherestr+="&nbsp;&nbsp;[channellist:publisharea]表示发行地区<br>"}
		if($("publishtime").checked){wherestr+="&nbsp;&nbsp;[channellist:publishtime]表示发行日期<br>"}
		wherestr=wherestr+"{/maxcms:channellist}"
		
		if($("pagelist").checked){
			if (isNaN($("pagelistlen").value)){
				alert('长度必须为数字')
			}else{
				if ($("pagelistlen").value!=10){wherestr+="<br>&nbsp;&nbsp;[channellist:pagenumber len="+$("pagelistlen").value+"]表示页码列表(循环外)<br>"}else{wherestr+="<br>&nbsp;&nbsp;[channellist:pagenumber]表示页码列表(循环外)<br>"}
			}
		}
		set($("labelcontent"),wherestr)
	}
</script>
<div id="channellistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('channellistlabel').style.display='none'" />创建channellist(分页列表标签)</div>
<div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb">
<tr><td colspan="2"><font color="#FF0000">设置标签属性</font></td></tr>
<tr>
 <td >每页数据条数：
 <input type="text" id="size" size="8" value="10"/>默认(10) </td>
 <td>数据排列顺序：
 <select id="order"><option value="time">时间</option><option value="hit">点击量</option><option value="id">数据ID</option><option value="digg">顶的次数</option></select>默认(按时间) </td></tr>

<tr><td colspan="2"><font color="#FF0000">选择标签变量</font></td></tr>
  <tr><td > 数据名
 <input type="checkbox" value="1" name="vname" id="vname" class="radio" />&nbsp;&nbsp;长度<input type="text" id="vnamelen" name="vnamelen" size="4" value="10" /></td><td > 彩色数据名
 <input type="checkbox" value="1" name="vcolorname" id="vcolorname" class="radio" />&nbsp;&nbsp;长度<input type="text" id="vcolornamelen" name="vcolornamelen" size="4" value="10" /></td></tr>
 <tr><td >主演
 <input id="actor" name="actor" type="checkbox" value="1" class="radio" />
 &nbsp;&nbsp;主演长度
 <input type="text" id="actorlen" name="actorlen" size="4" value="10"/></td><td > 描述
 <input type="checkbox" value="1" name="des" id="des" class="radio" />
 &nbsp;&nbsp;描述长度
 <input type="text" id="deslen" name="deslen" size="4" value="40"/></td></tr>
 <tr><td >添加时间
  <input id="addtime" name="addtime" type="checkbox" value="1" class="radio" />
  &nbsp;&nbsp;时间格式
  <select id="timestyle"><option value="y-m-d">年(缩写)-月-日</option><option value="yy-m-d">年-月-日</option><option value="m-d">月-日</option></select></td><td></td></tr>
 <tr><td colspan="2">
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />排序位&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="typename" name="typename" class="radio" />分类名</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="typelink" id="typelink" class="radio" />分类链接</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="radio" />视频链接</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="pic" name="pic" class="radio" />图片</label>&nbsp;&nbsp; 
<label><input id="hit" name="hit" type="checkbox" value="1" class="radio" />点击量</label>&nbsp;&nbsp; <br />
<label><input type="checkbox" id="state" name="state" value="1" class="radio" />状态</label>&nbsp;&nbsp; &nbsp;&nbsp;
<label><input type="checkbox" id="vcommend" name="vcommend" value="1" class="radio" />推荐级别</label>&nbsp;&nbsp;
<label><input type="checkbox" id="vfrom" name="vfrom" value="1" class="radio" />来源</label>&nbsp;&nbsp;
<label><input id="publisharea" name="publisharea" type="checkbox" value="1" class="radio" />发行地区</label>&nbsp;&nbsp; 
<label><input id="publishtime" name="publishtime" type="checkbox" value="1" class="radio" />发行日期</label>
</td></tr>
 <tr><td colspan="2"><font color="#FF0000">页码列表</font>(可放置于channellist外部) <input id="pagelist" name="pagelist" checked type="checkbox" value="1" class="radio" />长度<input type="text" id="pagelistlen" name="pagelistlen" size="4" value="10" /></td></tr>
 <tr bgcolor="ffffff"><td colspan="2"><input type="button" value="按上述我设置的条件生成标签" class="btn" onClick="channellist_create()"/></td></tr>
<tr><td colspan="2" ><div name="labelcontent" id="labelcontent" ></div></td>
</tr>
</table>	
 </div></div>
</div>	
<script type="text/javascript" src="imgs/drag.js"></script>	
<script>view("channellistlabel");selfLabelWindefault("channellistlabel");	</script>	
<%
End Sub

Sub createTopicList
%>
<script>
	function viewSelectedtopic(){
		if ($("topictext").value.indexOf("all")>-1 || $("topic").options[$("topic").selectedIndex].value=='all'){
			$("topictext").value=$("topic").options[$("topic").selectedIndex].value;
		}else{
			$("topictext").value+=","+$("topic").options[$("topic").selectedIndex].value;
		}
		if($("topictext").value.indexOf(",")==0){
			$("topictext").value= $("topictext").value.slice(1,$("topictext").value.length)
		}else if ($("topictext").value.lastIndexOf(",")== $("topictext").value.length-1 ){
			$("topictext").value=$("topictext").value.slice(0,$("topictext").value.length-2)
		}
	}
	function topiclist_create(){
		var wherestr=""
		if ($("topictext").value!="all"){wherestr+=" id="+$("topictext").value}
		wherestr="<b>标签说明:调用专题列表</b><br>{maxcms:topiclist"+wherestr+"}<br>"
		if($("i").checked){wherestr+="&nbsp;&nbsp;[topiclist:i]表示排序位<br>"}
		if($("name").checked){wherestr+="&nbsp;&nbsp;[topiclist:name]表示专题名称<br>"}
		if($("pic").checked){wherestr+="&nbsp;&nbsp;[topiclist:pic]表示专题图片<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[topiclist:link]表示专题链接<br>"}
		if($("des").checked){wherestr+="&nbsp;&nbsp;[topiclist:des]表示专题描述<br>"}
		wherestr=wherestr+"{/maxcms:topiclist}"
		set($("labelcontent"),wherestr)
	}
</script>
<div id="topiclistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('topiclistlabel').style.display='none'" />创建topiclist(专题列表标签)</div>
<div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb">
<tr><td colspan="2"><font color="#FF0000">设置标签属性</font></td></tr>
<tr><td >专题选择：
	<% 
	dim topicArray : topicArray = conn.db("select m_id,m_name from {pre}topic order by m_id asc","array")
	%>
 <select name="topic" id="topic" onChange="viewSelectedtopic()">
 <option value='all'>所有</option>
	<%
	echo makeTopicOptions(topicArray,"未选择专题")
	%>
 </select>
 <input id="topictext" value="all" size="20" />默认(所有) </td><td ></td></tr>
<tr><td colspan="2"><font color="#FF0000">选择标签变量</font></td></tr>
 <tr><td colspan="2"> 
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />排序位</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="name" name="name" class="radio" />专题名称</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="pic" id="pic" class="radio" />专题图片</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="radio" />专题链接</label>
<label><input type="checkbox" value="1" name="des" id="des" class="radio" />专题描述</label>
</td></tr>
 <tr bgcolor="ffffff"><td colspan="2"><input type="button" value="按上述我设置的条件生成标签" class="btn" onClick="topiclist_create()"/></td></tr>
<tr><td colspan="2" ><div name="labelcontent" id="labelcontent" ></div></td>
</tr>
</table>
 </div></div>
</div>	
<script topic="text/javascript" src="imgs/drag.js"></script>	
<script>view("topiclistlabel");selfLabelWindefault("topiclistlabel");	</script>	
<%
End Sub
Sub createNewsList
%>
<script>
function newslist_create(){
		var wherestr=""
		if (isNaN($("num").value)||$("num").value.length==0){alert('调用数据数必须为数字');wherestr+=" num=10"}else{if($("num").value!=10){wherestr+=" num="+$("num").value}}
		if (isNaN($("start").value)||$("start").value.length==0){alert('起点必须为数字');wherestr+=" start=1"}else{if($("start").value>1){wherestr+=" start="+$("start").value}}
		wherestr="<b>标签说明:调用新闻列表</b><br>{maxcms:newslist"+wherestr+"}<br>"
		if($("i").checked){wherestr+="&nbsp;&nbsp;[newslist:i]表示排序位<br>"}
		if($("name").checked){wherestr+="&nbsp;&nbsp;[newslist:title len="+$("namelen").value+"]表示新闻标题<br>"}
		if($("vcontent").checked){wherestr+="&nbsp;&nbsp;[newslist:content]表示新闻正文<br>"}
		if($("vnewslink").checked){wherestr+="&nbsp;&nbsp;[newslist:newslink]表示新闻链接<br>"}
		if($("addtime").checked){wherestr+="&nbsp;&nbsp;[newslist:addtime style="+$("timestyle").value+"]表示新闻添加时间<br>"}
		wherestr=wherestr+"{/maxcms:newslist}"
		set($("labelcontent"),wherestr)
	}
	</script>
<div id="newslistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('newslistlabel').style.display='none'" />创建newslist(新闻列表标签)</div>
 <div class="popbody"><div>
<table class="tb">
	<tr><td colspan="2"><font color="#FF0000">设置标签属性</font></td></tr>
	<tr>
 	<td>调用数据条数：<input type="text" id="num" size="8" value="10"/>默认(10)</td>
 	<td>起点：<input type="text" id="start" size="8" value="1"/>默认(从第1条开始调)</td>
  </tr>
<tr><td colspan="2"><font color="#FF0000">选择标签变量</font></td></tr>
  <tr><td > 新闻标题
 <input type="checkbox" value="1" name="name" id="name" class="radio" />&nbsp;&nbsp;长度<input type="text" id="namelen" name="namelen" size="4" value="10" /></td><td >顺序号
 <input type="checkbox" value="1" name="i" id="i" class="radio" />&nbsp;&nbsp;</td></tr>
   <tr><td > 新闻正文
 <input type="checkbox" value="1" name="vcontent" id="vcontent" class="radio" />&nbsp;&nbsp;</td><td >新闻链接
 <input type="checkbox" value="1" name="vnewslink" id="vnewslink" class="radio" />&nbsp;&nbsp;</td></tr>
  <tr><td >添加时间
  <input id="addtime" name="addtime" type="checkbox" value="1" class="radio" />
  &nbsp;&nbsp;时间格式
  <select id="timestyle"><option value="y-m-d">年(缩写)-月-日</option><option value="yy-m-d">年-月-日</option><option value="m-d">月-日</option></select></td><td></td></tr>
 
 <tr><td colspan="2"><input type="button" class="btn" value="按上述我设置的条件生成标签" onclick="newslist_create()"/></td></tr>
<tr><td colspan="2" ><div name="labelcontent" id="labelcontent" ></div></td>
</tr>
</table>
 </div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>	
<script>view("newslistlabel");selfLabelWindefault("newslistlabel");	</script>
<%End Sub

Sub createNewsPageList
%>
<script>
function newspagelist_create(){
		var wherestr=""
		if (isNaN($("num").value)||$("num").value.length==0){alert('调用数据数必须为数字')}else{if($("num").value!=10){wherestr+=" num="+$("num").value}}
		if (isNaN($("start").value)||$("start").value.length==0){alert('起点必须为数字')}else{if($("start").value>1){wherestr+=" start="+$("start").value}}
		if (isNaN($("size").value)){alert('起点必须为数字');wherestr+=" size=10"}else{if($("size").value>1){wherestr+=" size="+$("size").value}}
		wherestr=wherestr+=" order="+$("order").value;
		wherestr="<b>标签说明:调用新闻列表</b><br>{maxcms:newspagelist"+wherestr+"}<br>"
		if($("i").checked){wherestr+="&nbsp;&nbsp;[newspagelist:i]表示排序位<br>"}
		if($("hit").checked){wherestr+="&nbsp;&nbsp;[newspagelist:hit]表示点击量<br>"}
		if($("name").checked){wherestr+="&nbsp;&nbsp;[newspagelist:title len="+$("namelen").value +"]表示新闻标题<br>"}
		if($("vcontent").checked){wherestr+="&nbsp;&nbsp;[newspagelist:content]表示新闻正文<br>"}
		if($("vnewslink").checked){wherestr+="&nbsp;&nbsp;[newspagelist:newslink]表示新闻链接<br>"}
		if($("addtime").checked){wherestr+="&nbsp;&nbsp;[newspagelist:addtime style="+$("timestyle").value+"]表示新闻添加时间<br>"}
		wherestr=wherestr+"{/maxcms:newspagelist}"
		if($("pagelist").checked){
			if (isNaN($("pagelistlen").value)){
				alert('长度必须为数字')
			}else{
				if ($("pagelistlen").value!=10){wherestr+="<br>&nbsp;&nbsp;[newspagelist:pagenumber len="+$("pagelistlen").value+"]表示页码列表(循环外)<br>"}else{wherestr+="<br>&nbsp;&nbsp;[newspagelist:pagenumber]表示页码列表(循环外)<br>"}
			}
		}
		set($("labelcontent"),wherestr)
	}
	</script>
<div id="newspagelistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('newspagelistlabel').style.display='none'" />创建newspagelist(新闻分页列表标签)</div>
 <div class="popbody"><div>
<table class="tb">
	<tr><td colspan="2"><font color="#FF0000">设置标签属性</font></td></tr>
	<tr>
 	<td>调用数据条数：<input type="text" id="num" size="8" value="10"/> </td>
 	<td>起点：<input type="text" id="start" size="8" value="1"/>默认(从第1条开始调)</td>
  </tr>
  <tr>
 	<td>数据排列顺序：
 <select id="order"><option value="hit">点击量</option><option value="id">数据ID</option><option value="title">顶的次数</option></select>默认(按时间)</td>
 	<td>每页数据条数：
 <input type="text" id="size" size="8" value="10"/>默认(10)</td>
  </tr>
<tr><td colspan="2"><font color="#FF0000">选择标签变量</font></td></tr>
  <tr><td > 新闻标题
 <input type="checkbox" value="1" name="name" id="name" class="radio" />&nbsp;&nbsp;长度<input type="text" id="namelen" name="namelen" size="4" value="10" /></td><td >顺序号
 <input type="checkbox" value="1" name="i" id="i" class="radio" />&nbsp;&nbsp;</td></tr>
   <tr><td > 新闻正文
 <input type="checkbox" value="1" name="vcontent" id="vcontent" class="radio" />&nbsp;&nbsp;
 点击量
 <input type="checkbox" value="1" name="hit" id="hit" class="radio" />&nbsp;&nbsp;
 </td><td >新闻链接
 <input type="checkbox" value="1" name="vnewslink" id="vnewslink" class="radio" />&nbsp;&nbsp;</td></tr>
  <tr><td >添加时间
  <input id="addtime" name="addtime" type="checkbox" value="1" class="radio" />
  &nbsp;&nbsp;时间格式
  <select id="timestyle"><option value="y-m-d">年(缩写)-月-日</option><option value="yy-m-d">年-月-日</option><option value="m-d">月-日</option></select></td><td></td></tr>
 <tr><td colspan="2"><font color="#FF0000">页码列表</font>(可放置于newspagelist外部) <input id="pagelist" name="pagelist" checked type="checkbox" value="1" class="radio" />长度<input type="text" id="pagelistlen" name="pagelistlen" size="4" value="10" /></td></tr>
 <tr><td colspan="2"><input type="button" class="btn" value="按上述我设置的条件生成标签" onclick="newspagelist_create()"/></td>
 </tr>
<tr><td colspan="2" ><div name="labelcontent" id="labelcontent" ></div></td>
</tr>
</table>
 </div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>	
<script>view("newspagelistlabel");selfLabelWindefault("newspagelistlabel");	</script>
<%End Sub

Sub createtopicpagelist
%>
<script>
	function channellist_create(){
		var wherestr="",varstr
		if (isNaN($("size").value)||$("size").value.length==0){alert('每页数据条数必须为数字');wherestr+=" size=10"}else{if($("size").value!=10){wherestr+=" size="+$("size").value}}
		if ($("order").options[$("order").selectedIndex].value!='time'){wherestr+=" order="+$("order").options[$("order").selectedIndex].value}
		wherestr="<b>标签说明:调用频道分页列表</b><br>{maxcms:topicpagelist"+wherestr+"}<br>"
		if($("vname").checked){
			if (isNaN($("vnamelen").value)||$("vnamelen").value.length==0){
				alert('长度必须为数字')
			}else{
				if ($("vnamelen").value!=10){wherestr+="&nbsp;&nbsp;[topicpagelist:name len="+$("vnamelen").value+"]表示数据名<br>"}else{wherestr+="&nbsp;&nbsp;[topicpagelist:name]表示数据名<br>"}
			}
		}
		if($("vcolorname").checked){
			if (isNaN($("vcolornamelen").value)||$("vcolornamelen").value.length==0){
				alert('长度必须为数字')
			}else{
				if ($("vcolornamelen").value!=10){wherestr+="&nbsp;&nbsp;[topicpagelist:colorname len="+$("vcolornamelen").value+"]表示彩色数据名<br>"}else{wherestr+="&nbsp;&nbsp;[topicpagelist:colorname]表示彩色数据名<br>"}
			}
		}
		if($("actor").checked){
			if (isNaN($("actorlen").value)||$("actorlen").value.length==0){
				alert('长度必须为数字')
			}else{
				if ($("actorlen").value!=10){wherestr+="&nbsp;&nbsp;[topicpagelist:actor len="+$("actorlen").value+"]表示主演<br>"}else{wherestr+="&nbsp;&nbsp;[topicpagelist:actor]表示主演<br>"}
			}
		}
		if($("des").checked){
			if (isNaN($("deslen").value)||$("deslen").value.length==0){
				alert('长度必须为数字')
			}else{
				if ($("deslen").value!=10){wherestr+="&nbsp;&nbsp;[topicpagelist:des len="+$("deslen").value+"]表示描述<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:des]表示描述<br>"}
			}
		}
		if($("addtime").checked){
			if ($("timestyle").options[$("timestyle").selectedIndex].value!='y-m-d'){wherestr+="&nbsp;&nbsp;[topicpagelist:time style="+$("timestyle").options[$("timestyle").selectedIndex].value+"]表示添加时间<br>"}else{wherestr+="&nbsp;&nbsp;[topicpagelist:time]表示添加时间<br>"}
		}
		if($("i").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:i]表示排序位<br>"}
		if($("typename").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:typename]表示分类名<br>"}
		if($("typelink").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:typelink]表示分类链接<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:link]表示视频链接<br>"}
		if($("pic").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:pic]表示图片<br>"}
		if($("hit").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:hit]表示点击量<br>"}
		if($("state").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:state]表示状态<br>"}
		if($("vcommend").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:commend]表示推荐级别<br>"}
		if($("vfrom").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:from]表示来源<br>"}
		if($("publisharea").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:publisharea]表示发行地区<br>"}
		if($("publishtime").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:publishtime]表示发行日期<br>"}
		wherestr=wherestr+"{/maxcms:topicpagelist}"
		
		if($("pagelist").checked){
			if (isNaN($("pagelistlen").value)){
				alert('长度必须为数字')
			}else{
				if ($("pagelistlen").value!=10){wherestr+="<br>&nbsp;&nbsp;[topicpagelist:pagenumber len="+$("pagelistlen").value+"]表示页码列表(循环外)<br>"}else{wherestr+="<br>&nbsp;&nbsp;[topicpagelist:pagenumber]表示页码列表(循环外)<br>"}
			}
		}
		set($("labelcontent"),wherestr)
	}
</script>
<div id="channellistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="关闭" onClick="$('channellistlabel').style.display='none'" />创建topicpagelist(专题分页列表标签)</div>
<div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb">
<tr><td colspan="2"><font color="#FF0000">设置标签属性</font></td></tr>
<tr>
 <td >每页数据条数：
 <input type="text" id="size" size="8" value="10"/>默认(10) </td>
 <td>数据排列顺序：
 <select id="order"><option value="time">时间</option><option value="hit">点击量</option><option value="id">数据ID</option><option value="digg">顶的次数</option></select>默认(按时间) </td></tr>

<tr><td colspan="2"><font color="#FF0000">选择标签变量</font></td></tr>
  <tr><td > 数据名
 <input type="checkbox" value="1" name="vname" id="vname" class="radio" />&nbsp;&nbsp;长度<input type="text" id="vnamelen" name="vnamelen" size="4" value="10" /></td><td > 彩色数据名
 <input type="checkbox" value="1" name="vcolorname" id="vcolorname" class="radio" />&nbsp;&nbsp;长度<input type="text" id="vcolornamelen" name="vcolornamelen" size="4" value="10" /></td></tr>
 <tr><td >主演
 <input id="actor" name="actor" type="checkbox" value="1" class="radio" />
 &nbsp;&nbsp;主演长度
 <input type="text" id="actorlen" name="actorlen" size="4" value="10"/></td><td > 描述
 <input type="checkbox" value="1" name="des" id="des" class="radio" />
 &nbsp;&nbsp;描述长度
 <input type="text" id="deslen" name="deslen" size="4" value="40"/></td></tr>
 <tr><td >添加时间
  <input id="addtime" name="addtime" type="checkbox" value="1" class="radio" />
  &nbsp;&nbsp;时间格式
  <select id="timestyle"><option value="y-m-d">年(缩写)-月-日</option><option value="yy-m-d">年-月-日</option><option value="m-d">月-日</option></select></td><td></td></tr>
 <tr><td colspan="2">
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />排序位&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="typename" name="typename" class="radio" />分类名</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="typelink" id="typelink" class="radio" />分类链接</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="radio" />视频链接</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="pic" name="pic" class="radio" />图片</label>&nbsp;&nbsp; 
<label><input id="hit" name="hit" type="checkbox" value="1" class="radio" />点击量</label>&nbsp;&nbsp; <br />
<label><input type="checkbox" id="state" name="state" value="1" class="radio" />状态</label>&nbsp;&nbsp; &nbsp;&nbsp;
<label><input type="checkbox" id="vcommend" name="vcommend" value="1" class="radio" />推荐级别</label>&nbsp;&nbsp;
<label><input type="checkbox" id="vfrom" name="vfrom" value="1" class="radio" />来源</label>&nbsp;&nbsp;
<label><input id="publisharea" name="publisharea" type="checkbox" value="1" class="radio" />发行地区</label>&nbsp;&nbsp; 
<label><input id="publishtime" name="publishtime" type="checkbox" value="1" class="radio" />发行日期</label>
</td></tr>
 <tr><td colspan="2"><font color="#FF0000">页码列表</font>(可放置于topicpagelist外部) <input id="pagelist" name="pagelist" checked type="checkbox" value="1" class="radio" />长度<input type="text" id="pagelistlen" name="pagelistlen" size="4" value="10" /></td></tr>
 <tr bgcolor="ffffff"><td colspan="2"><input type="button" value="按上述我设置的条件生成标签" class="btn" onClick="channellist_create()"/></td></tr>
<tr><td colspan="2" ><div name="labelcontent" id="labelcontent" ></div></td>
</tr>
</table>	
 </div></div>
</div>	
<script type="text/javascript" src="imgs/drag.js"></script>	
<script>view("channellistlabel");selfLabelWindefault("channellistlabel");	</script>
<%End Sub%>
