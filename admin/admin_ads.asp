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
viewHead "������" & "-" & menuList(5,0)

dim action,keyword:action = getForm("action", "get")

dim id,page,errorInfo : errorInfo="��Ϣ��д������������"

Select  case action
	case "add" : addAds : popHtmlToJS
	case "del" : delAds
	case "delall" : delAll
	case "edit" : editAds : popHtmlToJS
	case "editsave" : editSave
	case "addsave" : addSave
	case "single" : makeSingleAd
	case "viewads" : viewAds
	case else : main : popDiv
End Select 
viewFoot

Sub main
	dim Qe,linkArray,i,n,m_id:id=getForm("id","get"):page=getForm("page","get") 
	if isNul(page) then page=1
	if page<1 then page=1 else page=clng(page)
	set Qe = mainClassobj.createObject("MainClass.DataPage")
	Qe.Query "SELECT m_id,m_name,m_enname,m_des,m_addtime FROM {pre}ads ORDER BY m_id DESC"
	Qe.absolutepage=page
	Qe.pagesize=20
	linkArray = Qe.GetRows()
	if page > Qe.pagecount then page=Qe.pagecount
%>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(5,0)%>&nbsp;&raquo;&nbsp;������';</script>
<!--
<table align="left"><tr><td><input type="button" value="���ӹ��" onClick="location.href='?action=add'" class="btn" /></td></tr></table>
-->
<%
	if Qe.recordcount>0 then
		n=ubound(linkArray,2)
%>
<form action="?action=delall" method="post">
<table class="tb nobdt">
    <tr class="thead"><td colspan="15">������</td></tr>
    <TR>
      <TD width="10%"  align="left">ID</TD>
      <TD width="30%" align="left">����</TD>
       <TD width="15%" align="left">��ʶ(�ļ���)</TD>
       <!--<TD width="10%" align="center">����</TD>-->
       <TD width="8%"  align="center">�ļ�����?</TD>
       <TD width="7%"  align="center">����ʱ��</TD>
      <TD width="20%"   align="center">����</TD>
    </TR>
    <%
	for i=0 to n
		m_id= trim(linkArray(0,i))
	%>
    <tr id="adtr<%=m_id%>" name="adtr" <%if id=m_id then %>  class="editlast"<%end if%> >
      <td align="left"><input type="checkbox" value="<%=m_id%>" name="m_id" class="checkbox" /><%=m_id%></TD>
      <td align="left"><%=linkArray(1,i)%></TD>
      <td align="left"><%=linkArray(2,i)%></TD>
      <!--<td align="center" ><%=linkArray(3,i)%></TD>-->
            <td align="center"><%isAdsFileExist linkArray(2,i),m_id%></TD>
      <td align="center"><%isCurrentDay(linkArray(4,i))%></TD>
      <td align="center"><a href="?action=viewads&id=<%=m_id%>">Ԥ��</a>&nbsp;&nbsp;<a href="javascript:" onClick="viewCurrentAdTr('<%=m_id%>');openAdWin('callad','../js/{maxcms:adfolder}/<%=linkArray(2,i)%>.js','/{maxcms:sitepath}')">���ù��</a>&nbsp;&nbsp;<a href="?action=edit&page=<%=page%>&id=<%=m_id%>">�༭</a>&nbsp;&nbsp;<a  href="?action=del&id=<%=m_id%>" onclick="if(confirm('ȷ��Ҫɾ����')){return true;}else{return false;}">ɾ��</a></TD>
    </tr>
    <%
	next
	%>
    <tr>
    <td colspan="7"><div class="cuspages"><div class="pages">ȫѡ<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','m_id')" />��ѡ<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','m_id')" /><input type="submit" value="����ɾ��" onclick="if(confirm('ȷ��Ҫ����ɾ����')){return true}else{return false}" class="btn"  />&nbsp;&nbsp; ҳ��<%=page%>/<%=Qe.pagecount%> ÿҳ<%=Qe.pagesize%>����¼������<%=Qe.recordcount%> <a href="?page=1">��ҳ</a> <a href="?page=<%=(page-1)%>">��һҳ</a> <%=makePageNumber(page, 15, Qe.pagecount, "adslist")%><a href="?page=<%=(page+1)%>">��һҳ</a> <a href="?page=<%=Qe.pagecount%>">βҳ</a></div></div></td></tr>
</TABLE>
</form> 
<%
	else
		echo "<table class='tb'><tr><td>û�й��</td></tr></table>"
	end if
%>
</div>

<%
	set Qe = nothing
End Sub



Sub popDiv
%>
<div id="callad" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('callad').style.display='none'" />������·�� </div>
    <div class="popbody"><div>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td  width="60" valign="top">���ô���</td>
          <td><textarea cols="75" rows="4" id="adpath" onfocus="this.select();" ></textarea></td>
        </tr>
       <tr><td align="center" colspan="2"><font color="red">���ֶ����������ı����еĹ����ô��룬ճ����ģ���ļ���Ӧλ�ü���</font></td></tr>
        </table>
    </div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>
<%	
End Sub

Sub popHtmlToJS
%>
<div id="htmltojs" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('htmltojs').style.display='none'" />HTMLתJS </div>
    <div class="popbody"><div>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td  width="60" valign="top">HTML����</td>
          <td><textarea cols="75" rows="8" id="htmlstr" onkeyup="htmlToJs('htmlstr','jsstr')" onfocus="htmlToJs('htmlstr','jsstr')"></textarea></td>
        </tr>
         <tr>
          <td  width="60" valign="top">JS����</td>
          <td><textarea cols="75" rows="8" id="jsstr" ></textarea></td>
        </tr>
       <tr><td align="center" colspan="2"><input type="button" value="��  ��"  class="btn" onclick="insertHtmlToJsWin('htmltojs','m_content','jsstr')" /></td></tr>
        </table>
    </div></div>
</div>
<div id="jstohtml" style="top:100px; display:none;" class="popdiv">
	<div class="poptitie"><img src="../pic/btn_close.gif" alt="�ر�" onClick="$('jstohtml').style.display='none'" />JSתHTML</div>
    <div class="popbody"><div>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td  width="60" valign="top">JS����</td>
          <td><textarea cols="75" rows="8" id="jsstr2" onkeyup="jstohtml('jsstr2','htmlstr2')" onfocus="jstohtml('jsstr2','htmlstr2')"></textarea></td>
        </tr>
         <tr>
          <td  width="60" valign="top">HTML����</td>
          <td><textarea cols="75" rows="8" id="htmlstr2" ></textarea></td>
        </tr>
       <tr><td align="center" colspan="2"><input type="button" value="��  ��"  class="btn" onclick="insertHtmlToJsWin('jstohtml','m_content','jsstr2')" /></td></tr>
        </table>
    </div></div>
</div>
<script type="text/javascript" src="imgs/drag.js"></script>
<%	
End Sub


Sub addAds
%>
<div class="container" id="cpcontainer">
<form action="?action=addsave" method="post" >
<table class="tb nobdt">
<tr class="thead"><th colspan="2">���ӹ��</th></tr>
    <TR>
      <TD vAlign=center width="11%" >������ƣ�</TD>
      <TD width="89%" ><input type="text" size="50" name="m_name" /><font color="red">��</font></TD>
    </TR>
    <TR>
      <TD >����ʶ��</TD>
      <TD ><input type="text" size="50" name="m_enname" /><font color="red">��</font></TD>
    </TR>
    <TR style="display:none">
      <TD >���������</TD>
      <TD ><input type="text" size="100" name="m_des" /></TD>
    </TR>
    <TR>
       <TD >������ݣ�<br />(<font color="red">��дjs����</font>)<br /><input type="button" value="HTMLתJS"  onclick="openHtmlToJsWin('htmltojs')" class="btn"/><br/><input type="button" value="JSתHTML"  onclick="openHtmlToJsWin('jstohtml')" class="btn"/></TD>
      <TD ><textarea name="m_content" id="m_content"  style="width:98%;font-family: Arial, Helvetica, sans-serif;font-size: 14px;" rows="20"  ></textarea><font color="red">��</font></TD>
    </TR>
    <TR>
      <td></td><TD ><input type="submit" value="�� �� �� ��" class="btn" />
      &nbsp;<input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></TD>
    </TR>
</td></tr></table>
</form>
</div>
<%
End Sub

Sub viewAds
%>
<div class="container" id="cpcontainer">
<form action="?action=addsave" method="post" >
<table class="tb nobdt">
<tr class="thead"><th colspan="2">Ԥ�����</th></tr>
<tr><td style="text-align:center">
<table  style="border:#BBDDFF solid 2px;"><tr><td>
<% 	dim cid : cid= clng(getForm("id","get")) 
	dim rsObj:set rsObj=conn.db("select m_content from {pre}ads where m_id="&cid,"records1")
	echo ("<script>")
	echo replacestr(decodeHtml(rsobj("m_content")),"+sitePath+","+'"&sitePath&"'+")
	echo ("</script>")
	rsObj.close 
	set rsObj=nothing
%>
</td></tr></table>
</td></tr>
<tr><td><input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></td></tr></table>
</form>
</div>
<%
End Sub

Sub editAds
	id=getForm("id","get") : page = getForm("page","get")
	dim rsObj : set rsObj=conn.db("select * from {pre}ads where m_id="&id,"execute")
%>
<div class="container" id="cpcontainer">
<form action="?action=editsave&id=<%=id%>&page=<%=page%>" method="post" >
<table class="tb nobdt">
<tr class="thead"><th colspan="2">�޸Ĺ��</th></tr>
    <TR>
      <TD vAlign=center width="11%" >������ƣ�</TD>
      <TD width="89%" ><input type="text" size="50" name="m_name" value="<%=rsObj("m_name")%>" /><font color="red">��</font></TD>
    </TR>
    <TR>
      <TD >����ʶ��</TD>
      <TD ><input type="text" size="50" name="m_enname" value="<%=rsObj("m_enname")%>" /><font color="red">��</font></TD>
    </TR>
    <TR style="display:none">
      <TD >���������</TD>
      <TD ><input type="text" size="100" name="m_des" value="<%=rsObj("m_des")%>" /></TD>
    </TR>
    <TR>
        <TD >������ݣ�<br />(<font color="red">��дjs����</font>)<br /><input type="button" value="HTMLתJS"  onclick="openHtmlToJsWin('htmltojs')" class="btn"/><br/><input type="button" value="JSתHTML"  onclick="openHtmlToJsWin('jstohtml')" class="btn"/></TD>
      <TD ><textarea name="m_content" style="width:98%;font-family: Arial, Helvetica, sans-serif;font-size: 14px;" rows="20" ><%=decodeHtml(rsObj("m_content"))%></textarea><font color="red">��</font></TD>
    </TR>
    <TR  >
      <td></td><TD ><input type="submit" value="�� �� �� ��" class="btn" />
      &nbsp;<input type="button" value="��   ��"  class="btn" onClick="javascript:history.go(-1)" /></TD>
    </TR>
</td></tr></table>
</form>
</div>
<%
	set rsObj=nothing
End Sub

Sub addSave
	dim m_name,m_enname,m_des,m_content,m_encontent,sqlStr
	m_name = getForm("m_name","post"):m_enname = getForm("m_enname","post"):m_des = getForm("m_des","post"):m_content=getForm("m_content","post")
	m_encontent=encodeHtml(m_content)
	if   isNul(m_name)  or isNul(m_enname)  then  die errorInfo
	sqlStr = "insert into  {pre}ads(m_name,m_enname,m_des,m_content,m_addtime) values ('"&m_name&"','"&m_enname&"','"&m_des&"','"&m_encontent&"','"&now()&"')"
	conn.db sqlStr,"execute" 
	createTextFile  m_content,"../js/"&siteAd&"/"&m_enname&".js",""
	alertMsg "���ӳɹ�","admin_ads.asp"
End Sub

Sub delAll
	dim ids,idArray,idsLen,i,filename
	ids = replaceStr(getForm("m_id","post")," ","")
	idArray=split(ids,",") : idsLen=ubound(idArray)
	for i=0 to idsLen
		filename = conn.db("select m_enname from {pre}ads where m_id="&idArray(i),"execute")(0)
		conn.db  "delete from {pre}ads where m_id="&idArray(i),"execute"
		delFile "../js/"&siteAd&"/"&filename&".js"
	next
	alertMsg "","admin_ads.asp"
End Sub

Sub delAds
	dim filename
	id = getForm("id","get")
	filename = conn.db("select m_enname from {pre}ads where m_id="&id,"execute")(0)
	conn.db  "delete from {pre}ads where m_id="&id,"execute"
	delFile "../js/"&siteAd&"/"&filename&".js"
	alertMsg "ɾ���ɹ�","admin_ads.asp"
End Sub


Sub editSave
	dim m_name,m_enname,m_des,m_content,m_encontent,sqlStr
	id=getForm("id","get") : page=getForm("page","get") : m_name = getForm("m_name","post"):m_enname = getForm("m_enname","post"):m_des = getForm("m_des","post"):m_content=getForm("m_content","post")
	m_encontent=encodeHtml(m_content)
	if   isNul(m_name)  or isNul(m_enname)  then  die errorInfo
	sqlStr = "update {pre}ads set m_name='"&m_name&"',m_enname='"&m_enname&"',m_des='"&m_des&"',m_content='"&m_encontent&"',m_addtime='"&now()&"' where m_id="&id
	conn.db sqlStr,"execute" 
	createTextFile  m_content,"../js/"&siteAd&"/"&m_enname&".js",""
	alertMsg "�޸ĳɹ�","admin_ads.asp?id="&id&"&page="&page
End Sub

Sub isAdsFileExist(filename,id)
	dim adFile : adFile="../js/"&siteAd&"/"&filename&".js"
	if isExistFile(adFile) then echo "<a href='"&adFile&"'><img src='imgs/yes.gif' border='0'/></a>" else  echo "<a href='?action=single&id="&id&"'><img src='imgs/no.gif' border='0'/></a>"
End Sub

Sub makeSingleAd
	dim m_content,rsObj
	id = getForm("id","get")
	set rsObj = conn.db("select m_enname,m_content from {pre}ads where m_id="&id,"execute")
	createTextFile  decodeHtml(rsObj(1)),"../js/"&siteAd&"/"&rsObj(0)&".js",""
	set rsObj=nothing
	alertMsg "","admin_ads.asp"
End Sub
%>