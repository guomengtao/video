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
viewHead "��ǩ��" & "-" & menuList(2,0)

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
if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(2,0)%>&nbsp;&raquo;&nbsp;��ǩ��';
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
		<tr class="thead"><th>��ǩ��</th></tr>
		<tr><td>
			<input type="button" class="btn" value="menulist(�˵�������ǩ)" style="width:250px;" onclick="self.location.href='?action=menulist'"/><br>
			<input type="button" class="btn" value="videolist(�����б���ǩ)" style="width:250px;" onclick="self.location.href='?action=videolist'" /><br>
			<input type="button" class="btn" value="arealist(˫��ѭ���б���ǩ)" style="width:250px;" onClick="self.location.href='?action=arealist'"/><br>
			<input type="button" class="btn" value="channellist(��ҳ�б���ǩ)" style="width:250px;" onClick="self.location.href='?action=channellist'"/><br>
			<input type="button" class="btn" value="topiclist(ר���б���ǩ)" style="width:250px;" onclick="self.location.href='?action=topiclist'"/><br>
			<input type="button" class="btn" value="linklist(���������б���ǩ)" style="width:250px;" onclick="self.location.href='?action=linklist'"/><br>
			<input type="button" class="btn" value="newslist(�����б���ǩ)" style="width:250px;" onclick="self.location.href='?action=newslist'"/><br>
			<input type="button" class="btn" value="newspagelist(���ŷ�ҳ�б���ǩ)" style="width:250px;" onclick="self.location.href='?action=newspagelist'"/><br>
			<input type="button" class="btn" value="topicpagelist(ר���ҳ�б���ǩ)" style="width:250px;" onclick="self.location.href='?action=topicpagelist'"/><br>
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
		if (isNaN($("num").value)){alert('��������������Ϊ����');wherestr+=" num=10"}else{if($("num").value!=10){wherestr+=" num="+$("num").value}}
		if (isNaN($("start").value)){alert('������Ϊ����');wherestr+=" start=1"}else{if($("start").value>1){wherestr+=" start="+$("start").value}}
		if ($("order").options[$("order").selectedIndex].value!='time'){wherestr+=" order="+$("order").options[$("order").selectedIndex].value}
		if ($("typetext").value!="all"){wherestr+=" type="+$("typetext").value}
		if ($("lettxt").value!="all"){wherestr+=" letter="+$("lettxt").value}
		if ($("topic").options[$("topic").selectedIndex].value!=''){wherestr+=" topic="+$("topic").options[$("topic").selectedIndex].value}
		if ($("time").options[$("time").selectedIndex].value!=0){wherestr+=" time="+$("time").options[$("time").selectedIndex].value}
		if ($("commend").options[$("commend").selectedIndex].value!=''){wherestr+=" commend="+$("commend").options[$("commend").selectedIndex].value}else{wherestr+=""}
		wherestr="<b>��ǩ˵��:������Ƶ�б�</b><br>{maxcms:videolist"+wherestr+"}<br>"
		if($("vname").checked){
			if (isNaN($("vnamelen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("vnamelen").value!=10){wherestr+="&nbsp;&nbsp;[videolist:name len="+$("vnamelen").value+"]��ʾ������<br>"}else{wherestr+="&nbsp;&nbsp;[videolist:name]��ʾ������<br>"}
			}
		}
		if($("vcolorname").checked){
			if (isNaN($("vcolornamelen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("vcolornamelen").value!=10){wherestr+="&nbsp;&nbsp;[videolist:colorname len="+$("vcolornamelen").value+"]��ʾ��ɫ������<br>"}else{wherestr+="&nbsp;&nbsp;[videolist:colorname]��ʾ��ɫ������<br>"}
			}
		}
		if($("actor").checked){
			if (isNaN($("actorlen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("actorlen").value!=10){wherestr+="&nbsp;&nbsp;[videolist:actor len="+$("actorlen").value+"]��ʾ����<br>"}else{wherestr+="&nbsp;&nbsp;[videolist:actor]��ʾ����<br>"}
			}
		}
		if($("des").checked){
			if (isNaN($("deslen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("deslen").value!=10){wherestr+="&nbsp;&nbsp;[videolist:des len="+$("deslen").value+"]��ʾ��������<br>"}else{wherestr+="&nbsp;&nbsp;[videolist:des]��ʾ��������<br>"}
			}
		}
		if($("addtime").checked){
			if ($("timestyle").options[$("timestyle").selectedIndex].value!='y-m-d'){wherestr+="&nbsp;&nbsp;[videolist:time style="+$("timestyle").options[$("timestyle").selectedIndex].value+"]��ʾ����ʱ��<br>"}else{wherestr+="&nbsp;&nbsp;[videolist:time]��ʾ����ʱ��<br>"}
		}
		if($("i").checked){wherestr+="&nbsp;&nbsp;[videolist:i]��ʾ����λ<br>"}
		if($("typename").checked){wherestr+="&nbsp;&nbsp;[videolist:typename]��ʾ����λ<br>"}
		if($("typelink").checked){wherestr+="&nbsp;&nbsp;[videolist:typelink]��ʾ��������<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[videolist:link]��ʾ��Ƶ����<br>"}
		if($("pic").checked){wherestr+="&nbsp;&nbsp;[videolist:pic]��ʾͼƬ<br>"}
		if($("hit").checked){wherestr+="&nbsp;&nbsp;[videolist:hit]��ʾ����� <br>"}
		if($("note").checked){wherestr+="&nbsp;&nbsp;[videolist:note]��ʾ��ע<br>"}
		if($("state").checked){wherestr+="&nbsp;&nbsp;[videolist:state]��ʾ״̬<br>"}
		if($("vcommend").checked){wherestr+="&nbsp;&nbsp;[videolist:commend]��ʾ�Ƽ�����<br>"}
		if($("vfrom").checked){wherestr+="&nbsp;&nbsp;[videolist:from]��ʾ��Դ<br>"}
		if($("publisharea").checked){wherestr+="&nbsp;&nbsp;[videolist:publisharea]��ʾ���е���<br>"}
		if($("publishtime").checked){wherestr+="&nbsp;&nbsp;[videolist:publishtime]��ʾ��������<br>"}
		wherestr=wherestr+"{/maxcms:videolist}"
		set($("labelcontent"),wherestr)
	}
</script>
<div id="videolistlabel" style="top:100px; display:none;" class="popdiv">
<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('videolistlabel').style.display='none'" />����videolist(�����б���ǩ)</div>
<div class="popbody"><div>
<table class="tb" onClick="videolist_create()">
<tr>
	<td colspan="2"><font color="#FF0000">���ñ�ǩ����</font></td>
</tr>
<tr>
	<td>��������������<input type="text" id="num" size="8" value="10"/>Ĭ��(10)</td>
	<td>��㣺<input type="text" id="start" size="8" value="1"/>Ĭ��(�ӵ�1����ʼ��)</td>
</tr>
<tr>
	<td>����˳��<select id="order" onchange="videolist_create()">
<script type="text/javascript">
	var o={time: "ʱ��",id: "����ID",commend: "�Ƽ��Ǽ�",hit: "�����",digg: "���Ĵ���",'random': "���",dayhit: "��������",weekhit: "�ܵ����",monthhit: "�µ����",score: "�ܵ÷�"};
	for(var i in o){
		document.write('<option value="'+i+'">'+o[i]+'</option>');
	}
</script>
</select>Ĭ��(��ʱ��) </td><td >���ࣺ <select name="type" id="type" style="width:100px;" onChange="viewSelectedType(this,'typetext')"><option value="all">����</option>
	<%makeTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
	</select><input id="typetext" value="all" size="8" />Ĭ��(����) </td>
</tr>
<tr>
	<td>ר�⣺<% 
	dim topicArray : topicArray = conn.db("select m_id,m_name from {pre}topic order by m_id asc","array")
	echo makeTopicSelect("topic",topicArray,"δѡ��ר��","")
	%>Ĭ��(��ѡ��) </td>
	<td>ʱ�䣺<select id="time" onchange="videolist_create()"><option value="0">δѡ��ʱ��</option><option value="day">����</option><option value="week">����</option><option value="month">����</option></select>Ĭ��(��ѡ��)</td>
</tr>
<tr>
	<td>�Ƽ�����<select id="commend" onchange="videolist_create()"><option value="">ȡ��</option><option value="all">�����Ƽ�</option><option value="1">1��</option><option value="2">2��</option><option value="3">3��</option><option value="4">4��</option><option value="5">5��</option></select></td>
	<td>��ƴ��ĸ��<select id="letter" onchange="viewSelectedType(this,'lettxt')"><option value="all">����</option>
	<%
	for i=65 to 90
		echo "<option value="""&chr(i)&""">"&chr(i)&"</option>"
	next
	%>
	</select><input type="text" id="lettxt" name="lettxt" size="10" value="all"/></td>
</tr>
<tr>
	<td colspan="2"><font color="#FF0000">ѡ���ǩ����</font></td>
</tr>
<tr>
	<td>��Ƶ��<input type="checkbox" value="1" name="vname" id="vname" class="radio" />&nbsp;&nbsp;����<input type="text" id="vnamelen" name="vnamelen" size="4" value="10" /></td>
	<td>��ɫ��Ƶ��<input type="checkbox" value="1" name="vcolorname" id="vcolorname" class="radio" />&nbsp;&nbsp;����<input type="text" id="vcolornamelen" name="vcolornamelen" size="4" value="10" /></td>
</tr>
<tr>
	<td>����<input id="actor" name="actor" type="checkbox" value="1" class="radio" />&nbsp;&nbsp;���ݳ���<input type="text" id="actorlen" name="actorlen" size="4" value="10"/></td>
	<td>����<input type="checkbox" value="1" name="des" id="des" class="radio" />&nbsp;&nbsp;��������<input type="text" id="deslen" name="deslen" size="4" value="40"/></td>
</tr>
<tr>
	<td colspan="2">����ʱ��<input id="addtime" name="addtime" type="checkbox" value="1" class="radio" />&nbsp;&nbsp;ʱ���ʽ<select id="timestyle" onchange="videolist_create()"><option value="y-m-d">��(��д)-��-��</option><option value="yy-m-d">��-��-��</option><option value="m-d">��-��</option></select></td>
</tr>
<tr><td colspan="2">
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />����λ</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="typename" name="typename" class="radio" />������</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="typelink" name="typelink" class="radio" />��������</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="link" name="link" class="radio" />��Ƶ����</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="pic" name="pic" class="radio" />ͼƬ</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="hit" name="hit" class="radio" />�����</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="note" name="note" class="radio" />��ע</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="state" name="state" class="radio" />״̬</label><br />
<label><input type="checkbox" value="1" id="vcommend" name="vcommend" class="radio" />�Ƽ�����</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="vfrom" name="vfrom" class="radio" />��Դ</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="publisharea" name="publisharea" class="radio" />���е���</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="publishtime" name="publishtime" class="radio" />��������</label>
</td></tr>
<!--
<tr><td colspan="2"><input type="button" class="btn" value="�����������õ��������ɱ�ǩ" onclick="videolist_create()"/></td></tr>
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
	wherestr="<b>��ǩ˵��:���ò˵��б�</b><br>{maxcms:menulist"+wherestr+"}<br>"
	if($("i").checked){wherestr+="&nbsp;&nbsp;[menulist:i]��ʾ����λ<br>"}
	if($("typename").checked){wherestr+="&nbsp;&nbsp;[menulist:typename]��ʾ�˵�������<br>"}
	if($("typeid").checked){wherestr+="&nbsp;&nbsp;[menulist:typeid]��ʾ�˵���id<br>"}
	if($("upid").checked){wherestr+="&nbsp;&nbsp;[menulist:upid]��ʾ���˵���id<br>"}
	if($("link").checked){wherestr+="&nbsp;&nbsp;[menulist:link]��ʾ�˵�������<br>"}
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
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('menulistlabel').style.display='none'" />����menulist(�˵�����ǩ)</div>
 <div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb" onClick="menulist_create()">
<tr><td colspan="2"><font color="#FF0000">���ñ�ǩ����</font> <input type="radio" class="radio" name="by" id="byv" value="video" onclick="hide('typeids2');view('typeids');$('typetext').value='top';" checked/>��Ƶ <input type="radio" class="radio" name="by" id="byn" onclick="hide('typeids');view('typeids2');$('typetext').value='top';" value="news"/>����</td></tr>
<tr>
	<td><span>���ͣ�<select id="type" name="type" onchange="menulist_create()"><option value="top">һ���˵�����</option><option value="all">���в˵�����</option><option value="son">�Ӳ˵�����</option><option value="id">�Զ������ID</option></select></span>
	<span id="id" style="display:none">
	<select id="typeids" style="width:100px;" onChange="viewSelectedType()"><option value="top">һ���˵�����</option><%makeTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%></select><select id="typeids2" style="width:100px;" onChange="viewSelectedType()" style="display:none"><option value="top">һ���˵�����</option><%makeNewsTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%></select>&nbsp;<input type="text" name="typetext" id="typetext" value="top"/></span> Ĭ��(һ���˵�����)</td>
	<td></td>
</tr>
<tr><td colspan="2"><font color="#FF0000">ѡ���ǩ����</font></td></tr>
 <tr><td colspan="2">
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />����λ</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="typename" name="typename" class="radio" />�˵�������</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="typeid" id="typeid" class="radio"/>�˵���id</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="upid" id="upid" class="radio"/>���˵���id</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="radio" />�˵�������</label></td></tr>
<!--
<tr bgcolor="ffffff"><td colspan="2"><input type="button" value="�����������õ��������ɱ�ǩ" class="btn" onClick="menulist_create()"/></td></tr>
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
		wherestr="<b>��ǩ˵��:������Ƶ�����б�</b><br>{maxcms:arealist"+wherestr+"}<br>"
		if($("i").checked){wherestr+="&nbsp;&nbsp;[arealist:i]��ʾ����λ<br>"}
		if($("typename").checked){wherestr+="&nbsp;&nbsp;[arealist:typename]��ʾ��������<br>"}
		if($("count").checked){wherestr+="&nbsp;&nbsp;[arealist:count]��ʾ��������Ƶ����<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[arealist:link]��ʾ��������<br>"}
		
		wherestr=wherestr+"&nbsp;&nbsp;{maxcms:videolist type=areatype}{/maxcms:videolist}��ʾǶ�׵���Ƶ�б�<br>{/maxcms:arealist}"
		set($("labelcontent"),wherestr)
	}
</script>
<div id="arealistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('arealistlabel').style.display='none'" />����arealist(ѭ�������ǩ)</div>
<div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb">
<tr><td colspan="2"><font color="#FF0000">���ñ�ǩ����</font></td></tr>
<tr><td >���ࣺ <select name="type" id="type" style="width:180px;" onChange="viewSelectedType()"><option value="all">����</option>
 <%makeTypeOption(0),"&nbsp;|&nbsp;&nbsp;"%>
	</select><input id="typetext" value="all" size="20" />Ĭ��(����) </td><td ></td></tr>
<tr><td colspan="2"><font color="#FF0000">ѡ���ǩ����</font></td></tr>
 <tr><td colspan="2"> 
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />����λ</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="typename" name="typename" class="radio" />��������</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="count" id="count" class="radio" />��������Ƶ����</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="radio" />��������</label></td></tr>
 <tr bgcolor="ffffff"><td colspan="2"><input type="button" value="�����������õ��������ɱ�ǩ" class="btn" onClick="arealist_create()"/></td></tr>
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
		wherestr="<b>��ǩ˵��:�������������б�</b><br>{maxcms:linklist"+wherestr+"}<br>"
		
		if($("name").checked){
			if (isNaN($("namelen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("namelen").value!=10){wherestr+="&nbsp;&nbsp;[linklist:name len="+$("namelen").value+"]��ʾ��������<br>"}else{wherestr+="&nbsp;&nbsp;[linklist:name]��ʾ��������<br>"}
			}
		}
		
		if($("des").checked){
			if (isNaN($("namelen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("deslen").value!=50){wherestr+="&nbsp;&nbsp;[linklist:des len="+$("deslen").value+"]��ʾ��������<br>"}else{wherestr+="&nbsp;&nbsp;[linklist:des]��ʾ��������<br>"}
			}
		}
		
		if($("i").checked){wherestr+="&nbsp;&nbsp;[linklist:i]��ʾ����λ<br>"}
		if($("pic").checked){wherestr+="&nbsp;&nbsp;[linklist:pic]��ʾ����ͼƬ<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[linklist:link]��ʾ���ӵ�ַ<br>"}
		
		wherestr=wherestr+"{/maxcms:linklist}"
		set($("labelcontent"),wherestr)
	}
</script>
<div id="linklistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('linklistlabel').style.display='none'" />����linklist(�������ӱ�ǩ)</div>
<div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb">
<tr><td colspan="2"><font color="#FF0000">���ñ�ǩ����</font></td></tr>
<tr><td>���ͣ�<select id="type" name="type"><option value="pic">ͼƬ��������</option><option value="font">������������</option></select>Ĭ��(ͼƬ��������) </td><td ></td></tr>
<tr><td colspan="2"><font color="#FF0000">ѡ���ǩ����</font></td></tr>
<tr><td > ��������
 <input type="checkbox" value="1" name="name" id="name" class="checkbox" />
 &nbsp;&nbsp;
 ����
 <input type="text" id="namelen" name="namelen" size="4" value="10" /></td>
 <td >��������
 <input id="des" name="des" type="checkbox" value="1" class="checkbox" />
 &nbsp;&nbsp;���ݳ���
 <input type="text" id="deslen" name="desrlen" size="4" value="50"/></td></tr>
 
 <tr><td colspan="2"> 
<label><input type="checkbox" value="1" id="i" name="i" class="checkbox" />����λ</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="pic" name="pic" class="checkbox" />����ͼƬ</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="checkbox" />���ӵ�ַ</label></td></tr>
 <tr bgcolor="ffffff"><td colspan="2"><input type="button" value="�����������õ��������ɱ�ǩ" class="btn" onClick="linklist_create()"/></td></tr>
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
		if (isNaN($("size").value)){alert('ÿҳ������������Ϊ����');wherestr+=" size=10"}else{if($("size").value!=10){wherestr+=" size="+$("size").value}}
		if ($("order").options[$("order").selectedIndex].value!='time'){wherestr+=" order="+$("order").options[$("order").selectedIndex].value}
		wherestr="<b>��ǩ˵��:����Ƶ����ҳ�б�</b><br>{maxcms:channellist"+wherestr+"}<br>"
		if($("vname").checked){
			if (isNaN($("vnamelen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("vnamelen").value!=10){wherestr+="&nbsp;&nbsp;[channellist:name len="+$("vnamelen").value+"]��ʾ������<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:name]��ʾ������<br>"}
			}
		}
		if($("vcolorname").checked){
			if (isNaN($("vcolornamelen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("vcolornamelen").value!=10){wherestr+="&nbsp;&nbsp;[channellist:colorname len="+$("vcolornamelen").value+"]��ʾ��ɫ������<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:colorname]��ʾ��ɫ������<br>"}
			}
		}
		if($("actor").checked){
			if (isNaN($("actorlen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("actorlen").value!=10){wherestr+="&nbsp;&nbsp;[channellist:actor len="+$("actorlen").value+"]��ʾ����<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:actor]��ʾ����<br>"}
			}
		}
		if($("des").checked){
			if (isNaN($("deslen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("deslen").value!=10){wherestr+="&nbsp;&nbsp;[channellist:des len="+$("deslen").value+"]��ʾ����<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:des]��ʾ����<br>"}
			}
		}
		if($("addtime").checked){
			if ($("timestyle").options[$("timestyle").selectedIndex].value!='y-m-d'){wherestr+="&nbsp;&nbsp;[channellist:time style="+$("timestyle").options[$("timestyle").selectedIndex].value+"]��ʾ����ʱ��<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:time]��ʾ����ʱ��<br>"}
		}
		if($("i").checked){wherestr+="&nbsp;&nbsp;[channellist:i]��ʾ����λ<br>"}
		if($("typename").checked){wherestr+="&nbsp;&nbsp;[channellist:typename]��ʾ������<br>"}
		if($("typelink").checked){wherestr+="&nbsp;&nbsp;[channellist:typelink]��ʾ��������<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[channellist:link]��ʾ��Ƶ����<br>"}
		if($("pic").checked){wherestr+="&nbsp;&nbsp;[channellist:pic]��ʾͼƬ<br>"}
		if($("hit").checked){wherestr+="&nbsp;&nbsp;[channellist:hit]��ʾ�����<br>"}
		if($("state").checked){wherestr+="&nbsp;&nbsp;[channellist:state]��ʾ״̬<br>"}
		if($("vcommend").checked){wherestr+="&nbsp;&nbsp;[channellist:commend]��ʾ�Ƽ�����<br>"}
		if($("vfrom").checked){wherestr+="&nbsp;&nbsp;[channellist:from]��ʾ��Դ<br>"}
		if($("publisharea").checked){wherestr+="&nbsp;&nbsp;[channellist:publisharea]��ʾ���е���<br>"}
		if($("publishtime").checked){wherestr+="&nbsp;&nbsp;[channellist:publishtime]��ʾ��������<br>"}
		wherestr=wherestr+"{/maxcms:channellist}"
		
		if($("pagelist").checked){
			if (isNaN($("pagelistlen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("pagelistlen").value!=10){wherestr+="<br>&nbsp;&nbsp;[channellist:pagenumber len="+$("pagelistlen").value+"]��ʾҳ���б�(ѭ����)<br>"}else{wherestr+="<br>&nbsp;&nbsp;[channellist:pagenumber]��ʾҳ���б�(ѭ����)<br>"}
			}
		}
		set($("labelcontent"),wherestr)
	}
</script>
<div id="channellistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('channellistlabel').style.display='none'" />����channellist(��ҳ�б���ǩ)</div>
<div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb">
<tr><td colspan="2"><font color="#FF0000">���ñ�ǩ����</font></td></tr>
<tr>
 <td >ÿҳ����������
 <input type="text" id="size" size="8" value="10"/>Ĭ��(10) </td>
 <td>��������˳��
 <select id="order"><option value="time">ʱ��</option><option value="hit">�����</option><option value="id">����ID</option><option value="digg">���Ĵ���</option></select>Ĭ��(��ʱ��) </td></tr>

<tr><td colspan="2"><font color="#FF0000">ѡ���ǩ����</font></td></tr>
  <tr><td > ������
 <input type="checkbox" value="1" name="vname" id="vname" class="radio" />&nbsp;&nbsp;����<input type="text" id="vnamelen" name="vnamelen" size="4" value="10" /></td><td > ��ɫ������
 <input type="checkbox" value="1" name="vcolorname" id="vcolorname" class="radio" />&nbsp;&nbsp;����<input type="text" id="vcolornamelen" name="vcolornamelen" size="4" value="10" /></td></tr>
 <tr><td >����
 <input id="actor" name="actor" type="checkbox" value="1" class="radio" />
 &nbsp;&nbsp;���ݳ���
 <input type="text" id="actorlen" name="actorlen" size="4" value="10"/></td><td > ����
 <input type="checkbox" value="1" name="des" id="des" class="radio" />
 &nbsp;&nbsp;��������
 <input type="text" id="deslen" name="deslen" size="4" value="40"/></td></tr>
 <tr><td >����ʱ��
  <input id="addtime" name="addtime" type="checkbox" value="1" class="radio" />
  &nbsp;&nbsp;ʱ���ʽ
  <select id="timestyle"><option value="y-m-d">��(��д)-��-��</option><option value="yy-m-d">��-��-��</option><option value="m-d">��-��</option></select></td><td></td></tr>
 <tr><td colspan="2">
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />����λ&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="typename" name="typename" class="radio" />������</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="typelink" id="typelink" class="radio" />��������</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="radio" />��Ƶ����</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="pic" name="pic" class="radio" />ͼƬ</label>&nbsp;&nbsp; 
<label><input id="hit" name="hit" type="checkbox" value="1" class="radio" />�����</label>&nbsp;&nbsp; <br />
<label><input type="checkbox" id="state" name="state" value="1" class="radio" />״̬</label>&nbsp;&nbsp; &nbsp;&nbsp;
<label><input type="checkbox" id="vcommend" name="vcommend" value="1" class="radio" />�Ƽ�����</label>&nbsp;&nbsp;
<label><input type="checkbox" id="vfrom" name="vfrom" value="1" class="radio" />��Դ</label>&nbsp;&nbsp;
<label><input id="publisharea" name="publisharea" type="checkbox" value="1" class="radio" />���е���</label>&nbsp;&nbsp; 
<label><input id="publishtime" name="publishtime" type="checkbox" value="1" class="radio" />��������</label>
</td></tr>
 <tr><td colspan="2"><font color="#FF0000">ҳ���б�</font>(�ɷ�����channellist�ⲿ) <input id="pagelist" name="pagelist" checked type="checkbox" value="1" class="radio" />����<input type="text" id="pagelistlen" name="pagelistlen" size="4" value="10" /></td></tr>
 <tr bgcolor="ffffff"><td colspan="2"><input type="button" value="�����������õ��������ɱ�ǩ" class="btn" onClick="channellist_create()"/></td></tr>
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
		wherestr="<b>��ǩ˵��:����ר���б�</b><br>{maxcms:topiclist"+wherestr+"}<br>"
		if($("i").checked){wherestr+="&nbsp;&nbsp;[topiclist:i]��ʾ����λ<br>"}
		if($("name").checked){wherestr+="&nbsp;&nbsp;[topiclist:name]��ʾר������<br>"}
		if($("pic").checked){wherestr+="&nbsp;&nbsp;[topiclist:pic]��ʾר��ͼƬ<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[topiclist:link]��ʾר������<br>"}
		if($("des").checked){wherestr+="&nbsp;&nbsp;[topiclist:des]��ʾר������<br>"}
		wherestr=wherestr+"{/maxcms:topiclist}"
		set($("labelcontent"),wherestr)
	}
</script>
<div id="topiclistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('topiclistlabel').style.display='none'" />����topiclist(ר���б���ǩ)</div>
<div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb">
<tr><td colspan="2"><font color="#FF0000">���ñ�ǩ����</font></td></tr>
<tr><td >ר��ѡ��
	<% 
	dim topicArray : topicArray = conn.db("select m_id,m_name from {pre}topic order by m_id asc","array")
	%>
 <select name="topic" id="topic" onChange="viewSelectedtopic()">
 <option value='all'>����</option>
	<%
	echo makeTopicOptions(topicArray,"δѡ��ר��")
	%>
 </select>
 <input id="topictext" value="all" size="20" />Ĭ��(����) </td><td ></td></tr>
<tr><td colspan="2"><font color="#FF0000">ѡ���ǩ����</font></td></tr>
 <tr><td colspan="2"> 
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />����λ</label>&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="name" name="name" class="radio" />ר������</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="pic" id="pic" class="radio" />ר��ͼƬ</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="radio" />ר������</label>
<label><input type="checkbox" value="1" name="des" id="des" class="radio" />ר������</label>
</td></tr>
 <tr bgcolor="ffffff"><td colspan="2"><input type="button" value="�����������õ��������ɱ�ǩ" class="btn" onClick="topiclist_create()"/></td></tr>
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
		if (isNaN($("num").value)||$("num").value.length==0){alert('��������������Ϊ����');wherestr+=" num=10"}else{if($("num").value!=10){wherestr+=" num="+$("num").value}}
		if (isNaN($("start").value)||$("start").value.length==0){alert('������Ϊ����');wherestr+=" start=1"}else{if($("start").value>1){wherestr+=" start="+$("start").value}}
		wherestr="<b>��ǩ˵��:���������б�</b><br>{maxcms:newslist"+wherestr+"}<br>"
		if($("i").checked){wherestr+="&nbsp;&nbsp;[newslist:i]��ʾ����λ<br>"}
		if($("name").checked){wherestr+="&nbsp;&nbsp;[newslist:title len="+$("namelen").value+"]��ʾ���ű���<br>"}
		if($("vcontent").checked){wherestr+="&nbsp;&nbsp;[newslist:content]��ʾ��������<br>"}
		if($("vnewslink").checked){wherestr+="&nbsp;&nbsp;[newslist:newslink]��ʾ��������<br>"}
		if($("addtime").checked){wherestr+="&nbsp;&nbsp;[newslist:addtime style="+$("timestyle").value+"]��ʾ��������ʱ��<br>"}
		wherestr=wherestr+"{/maxcms:newslist}"
		set($("labelcontent"),wherestr)
	}
	</script>
<div id="newslistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('newslistlabel').style.display='none'" />����newslist(�����б���ǩ)</div>
 <div class="popbody"><div>
<table class="tb">
	<tr><td colspan="2"><font color="#FF0000">���ñ�ǩ����</font></td></tr>
	<tr>
 	<td>��������������<input type="text" id="num" size="8" value="10"/>Ĭ��(10)</td>
 	<td>��㣺<input type="text" id="start" size="8" value="1"/>Ĭ��(�ӵ�1����ʼ��)</td>
  </tr>
<tr><td colspan="2"><font color="#FF0000">ѡ���ǩ����</font></td></tr>
  <tr><td > ���ű���
 <input type="checkbox" value="1" name="name" id="name" class="radio" />&nbsp;&nbsp;����<input type="text" id="namelen" name="namelen" size="4" value="10" /></td><td >˳���
 <input type="checkbox" value="1" name="i" id="i" class="radio" />&nbsp;&nbsp;</td></tr>
   <tr><td > ��������
 <input type="checkbox" value="1" name="vcontent" id="vcontent" class="radio" />&nbsp;&nbsp;</td><td >��������
 <input type="checkbox" value="1" name="vnewslink" id="vnewslink" class="radio" />&nbsp;&nbsp;</td></tr>
  <tr><td >����ʱ��
  <input id="addtime" name="addtime" type="checkbox" value="1" class="radio" />
  &nbsp;&nbsp;ʱ���ʽ
  <select id="timestyle"><option value="y-m-d">��(��д)-��-��</option><option value="yy-m-d">��-��-��</option><option value="m-d">��-��</option></select></td><td></td></tr>
 
 <tr><td colspan="2"><input type="button" class="btn" value="�����������õ��������ɱ�ǩ" onclick="newslist_create()"/></td></tr>
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
		if (isNaN($("num").value)||$("num").value.length==0){alert('��������������Ϊ����')}else{if($("num").value!=10){wherestr+=" num="+$("num").value}}
		if (isNaN($("start").value)||$("start").value.length==0){alert('������Ϊ����')}else{if($("start").value>1){wherestr+=" start="+$("start").value}}
		if (isNaN($("size").value)){alert('������Ϊ����');wherestr+=" size=10"}else{if($("size").value>1){wherestr+=" size="+$("size").value}}
		wherestr=wherestr+=" order="+$("order").value;
		wherestr="<b>��ǩ˵��:���������б�</b><br>{maxcms:newspagelist"+wherestr+"}<br>"
		if($("i").checked){wherestr+="&nbsp;&nbsp;[newspagelist:i]��ʾ����λ<br>"}
		if($("hit").checked){wherestr+="&nbsp;&nbsp;[newspagelist:hit]��ʾ�����<br>"}
		if($("name").checked){wherestr+="&nbsp;&nbsp;[newspagelist:title len="+$("namelen").value +"]��ʾ���ű���<br>"}
		if($("vcontent").checked){wherestr+="&nbsp;&nbsp;[newspagelist:content]��ʾ��������<br>"}
		if($("vnewslink").checked){wherestr+="&nbsp;&nbsp;[newspagelist:newslink]��ʾ��������<br>"}
		if($("addtime").checked){wherestr+="&nbsp;&nbsp;[newspagelist:addtime style="+$("timestyle").value+"]��ʾ��������ʱ��<br>"}
		wherestr=wherestr+"{/maxcms:newspagelist}"
		if($("pagelist").checked){
			if (isNaN($("pagelistlen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("pagelistlen").value!=10){wherestr+="<br>&nbsp;&nbsp;[newspagelist:pagenumber len="+$("pagelistlen").value+"]��ʾҳ���б�(ѭ����)<br>"}else{wherestr+="<br>&nbsp;&nbsp;[newspagelist:pagenumber]��ʾҳ���б�(ѭ����)<br>"}
			}
		}
		set($("labelcontent"),wherestr)
	}
	</script>
<div id="newspagelistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('newspagelistlabel').style.display='none'" />����newspagelist(���ŷ�ҳ�б���ǩ)</div>
 <div class="popbody"><div>
<table class="tb">
	<tr><td colspan="2"><font color="#FF0000">���ñ�ǩ����</font></td></tr>
	<tr>
 	<td>��������������<input type="text" id="num" size="8" value="10"/> </td>
 	<td>��㣺<input type="text" id="start" size="8" value="1"/>Ĭ��(�ӵ�1����ʼ��)</td>
  </tr>
  <tr>
 	<td>��������˳��
 <select id="order"><option value="hit">�����</option><option value="id">����ID</option><option value="title">���Ĵ���</option></select>Ĭ��(��ʱ��)</td>
 	<td>ÿҳ����������
 <input type="text" id="size" size="8" value="10"/>Ĭ��(10)</td>
  </tr>
<tr><td colspan="2"><font color="#FF0000">ѡ���ǩ����</font></td></tr>
  <tr><td > ���ű���
 <input type="checkbox" value="1" name="name" id="name" class="radio" />&nbsp;&nbsp;����<input type="text" id="namelen" name="namelen" size="4" value="10" /></td><td >˳���
 <input type="checkbox" value="1" name="i" id="i" class="radio" />&nbsp;&nbsp;</td></tr>
   <tr><td > ��������
 <input type="checkbox" value="1" name="vcontent" id="vcontent" class="radio" />&nbsp;&nbsp;
 �����
 <input type="checkbox" value="1" name="hit" id="hit" class="radio" />&nbsp;&nbsp;
 </td><td >��������
 <input type="checkbox" value="1" name="vnewslink" id="vnewslink" class="radio" />&nbsp;&nbsp;</td></tr>
  <tr><td >����ʱ��
  <input id="addtime" name="addtime" type="checkbox" value="1" class="radio" />
  &nbsp;&nbsp;ʱ���ʽ
  <select id="timestyle"><option value="y-m-d">��(��д)-��-��</option><option value="yy-m-d">��-��-��</option><option value="m-d">��-��</option></select></td><td></td></tr>
 <tr><td colspan="2"><font color="#FF0000">ҳ���б�</font>(�ɷ�����newspagelist�ⲿ) <input id="pagelist" name="pagelist" checked type="checkbox" value="1" class="radio" />����<input type="text" id="pagelistlen" name="pagelistlen" size="4" value="10" /></td></tr>
 <tr><td colspan="2"><input type="button" class="btn" value="�����������õ��������ɱ�ǩ" onclick="newspagelist_create()"/></td>
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
		if (isNaN($("size").value)||$("size").value.length==0){alert('ÿҳ������������Ϊ����');wherestr+=" size=10"}else{if($("size").value!=10){wherestr+=" size="+$("size").value}}
		if ($("order").options[$("order").selectedIndex].value!='time'){wherestr+=" order="+$("order").options[$("order").selectedIndex].value}
		wherestr="<b>��ǩ˵��:����Ƶ����ҳ�б�</b><br>{maxcms:topicpagelist"+wherestr+"}<br>"
		if($("vname").checked){
			if (isNaN($("vnamelen").value)||$("vnamelen").value.length==0){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("vnamelen").value!=10){wherestr+="&nbsp;&nbsp;[topicpagelist:name len="+$("vnamelen").value+"]��ʾ������<br>"}else{wherestr+="&nbsp;&nbsp;[topicpagelist:name]��ʾ������<br>"}
			}
		}
		if($("vcolorname").checked){
			if (isNaN($("vcolornamelen").value)||$("vcolornamelen").value.length==0){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("vcolornamelen").value!=10){wherestr+="&nbsp;&nbsp;[topicpagelist:colorname len="+$("vcolornamelen").value+"]��ʾ��ɫ������<br>"}else{wherestr+="&nbsp;&nbsp;[topicpagelist:colorname]��ʾ��ɫ������<br>"}
			}
		}
		if($("actor").checked){
			if (isNaN($("actorlen").value)||$("actorlen").value.length==0){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("actorlen").value!=10){wherestr+="&nbsp;&nbsp;[topicpagelist:actor len="+$("actorlen").value+"]��ʾ����<br>"}else{wherestr+="&nbsp;&nbsp;[topicpagelist:actor]��ʾ����<br>"}
			}
		}
		if($("des").checked){
			if (isNaN($("deslen").value)||$("deslen").value.length==0){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("deslen").value!=10){wherestr+="&nbsp;&nbsp;[topicpagelist:des len="+$("deslen").value+"]��ʾ����<br>"}else{wherestr+="&nbsp;&nbsp;[channellist:des]��ʾ����<br>"}
			}
		}
		if($("addtime").checked){
			if ($("timestyle").options[$("timestyle").selectedIndex].value!='y-m-d'){wherestr+="&nbsp;&nbsp;[topicpagelist:time style="+$("timestyle").options[$("timestyle").selectedIndex].value+"]��ʾ����ʱ��<br>"}else{wherestr+="&nbsp;&nbsp;[topicpagelist:time]��ʾ����ʱ��<br>"}
		}
		if($("i").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:i]��ʾ����λ<br>"}
		if($("typename").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:typename]��ʾ������<br>"}
		if($("typelink").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:typelink]��ʾ��������<br>"}
		if($("link").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:link]��ʾ��Ƶ����<br>"}
		if($("pic").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:pic]��ʾͼƬ<br>"}
		if($("hit").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:hit]��ʾ�����<br>"}
		if($("state").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:state]��ʾ״̬<br>"}
		if($("vcommend").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:commend]��ʾ�Ƽ�����<br>"}
		if($("vfrom").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:from]��ʾ��Դ<br>"}
		if($("publisharea").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:publisharea]��ʾ���е���<br>"}
		if($("publishtime").checked){wherestr+="&nbsp;&nbsp;[topicpagelist:publishtime]��ʾ��������<br>"}
		wherestr=wherestr+"{/maxcms:topicpagelist}"
		
		if($("pagelist").checked){
			if (isNaN($("pagelistlen").value)){
				alert('���ȱ���Ϊ����')
			}else{
				if ($("pagelistlen").value!=10){wherestr+="<br>&nbsp;&nbsp;[topicpagelist:pagenumber len="+$("pagelistlen").value+"]��ʾҳ���б�(ѭ����)<br>"}else{wherestr+="<br>&nbsp;&nbsp;[topicpagelist:pagenumber]��ʾҳ���б�(ѭ����)<br>"}
			}
		}
		set($("labelcontent"),wherestr)
	}
</script>
<div id="channellistlabel" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('channellistlabel').style.display='none'" />����topicpagelist(ר���ҳ�б���ǩ)</div>
<div class="popbody"><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb">
<tr><td colspan="2"><font color="#FF0000">���ñ�ǩ����</font></td></tr>
<tr>
 <td >ÿҳ����������
 <input type="text" id="size" size="8" value="10"/>Ĭ��(10) </td>
 <td>��������˳��
 <select id="order"><option value="time">ʱ��</option><option value="hit">�����</option><option value="id">����ID</option><option value="digg">���Ĵ���</option></select>Ĭ��(��ʱ��) </td></tr>

<tr><td colspan="2"><font color="#FF0000">ѡ���ǩ����</font></td></tr>
  <tr><td > ������
 <input type="checkbox" value="1" name="vname" id="vname" class="radio" />&nbsp;&nbsp;����<input type="text" id="vnamelen" name="vnamelen" size="4" value="10" /></td><td > ��ɫ������
 <input type="checkbox" value="1" name="vcolorname" id="vcolorname" class="radio" />&nbsp;&nbsp;����<input type="text" id="vcolornamelen" name="vcolornamelen" size="4" value="10" /></td></tr>
 <tr><td >����
 <input id="actor" name="actor" type="checkbox" value="1" class="radio" />
 &nbsp;&nbsp;���ݳ���
 <input type="text" id="actorlen" name="actorlen" size="4" value="10"/></td><td > ����
 <input type="checkbox" value="1" name="des" id="des" class="radio" />
 &nbsp;&nbsp;��������
 <input type="text" id="deslen" name="deslen" size="4" value="40"/></td></tr>
 <tr><td >����ʱ��
  <input id="addtime" name="addtime" type="checkbox" value="1" class="radio" />
  &nbsp;&nbsp;ʱ���ʽ
  <select id="timestyle"><option value="y-m-d">��(��д)-��-��</option><option value="yy-m-d">��-��-��</option><option value="m-d">��-��</option></select></td><td></td></tr>
 <tr><td colspan="2">
<label><input type="checkbox" value="1" id="i" name="i" class="radio" />����λ&nbsp;&nbsp;
<label><input type="checkbox" value="1" id="typename" name="typename" class="radio" />������</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="typelink" id="typelink" class="radio" />��������</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" name="link" id="link" class="radio" />��Ƶ����</label>&nbsp;&nbsp; 
<label><input type="checkbox" value="1" id="pic" name="pic" class="radio" />ͼƬ</label>&nbsp;&nbsp; 
<label><input id="hit" name="hit" type="checkbox" value="1" class="radio" />�����</label>&nbsp;&nbsp; <br />
<label><input type="checkbox" id="state" name="state" value="1" class="radio" />״̬</label>&nbsp;&nbsp; &nbsp;&nbsp;
<label><input type="checkbox" id="vcommend" name="vcommend" value="1" class="radio" />�Ƽ�����</label>&nbsp;&nbsp;
<label><input type="checkbox" id="vfrom" name="vfrom" value="1" class="radio" />��Դ</label>&nbsp;&nbsp;
<label><input id="publisharea" name="publisharea" type="checkbox" value="1" class="radio" />���е���</label>&nbsp;&nbsp; 
<label><input id="publishtime" name="publishtime" type="checkbox" value="1" class="radio" />��������</label>
</td></tr>
 <tr><td colspan="2"><font color="#FF0000">ҳ���б�</font>(�ɷ�����topicpagelist�ⲿ) <input id="pagelist" name="pagelist" checked type="checkbox" value="1" class="radio" />����<input type="text" id="pagelistlen" name="pagelistlen" size="4" value="10" /></td></tr>
 <tr bgcolor="ffffff"><td colspan="2"><input type="button" value="�����������õ��������ɱ�ǩ" class="btn" onClick="channellist_create()"/></td></tr>
<tr><td colspan="2" ><div name="labelcontent" id="labelcontent" ></div></td>
</tr>
</table>	
 </div></div>
</div>	
<script type="text/javascript" src="imgs/drag.js"></script>	
<script>view("channellistlabel");selfLabelWindefault("channellistlabel");	</script>
<%End Sub%>