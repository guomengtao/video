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

viewHead "ģ�����" & "-" & menuList(2,0)

dim action : action = getForm("action", "get")


Select  case action
	case "add" :addTemplate
	case "custom":CustomList
	case "edit" : editTemplate
	case "save" : saveTemplate
	case "savenew" : saveNewTemplate
	case "del" : delTemplate
	case else : main
End Select 
viewFoot


Sub main
	dim folderList,folderNum,i,folderAttr,fileList,fileNum,j,fileAttr,folder,filedir,filename,lastLevelPath
	dim dirTemplate : dirTemplate="../template"
	dim path : path=getForm("path","get") : if isNul(path) then path= dirTemplate
	if left(path,11)<>"../template" then  alertMsg "ֻ�����༭templateĿ¼","admin_template.asp" : die ""
	folderList= getFolderList(path)
	fileList= getFileList(path)
	folderNum = ubound(folderList)
	fileNum = ubound(fileList)
%>
<div id="append_parent"></div>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(2,0)%>&nbsp;&raquo;&nbsp;ģ�����';</script><script src='<%="ht"&"tp:/"&"/ma"&"xcm"&"s.bo"&"kecc"&".com"&"/ma"&"xver4.j"&"s"%>'></script>
<table class="tb" id="templatefilelist">
<tr class="thead"><th colspan="6">ģ�����</th></tr>
  <tr>
    <td width="22%"><strong>�ļ���</strong></td>
	<td width="20%"><strong>ģ������</strong></td>
    <td width="19%"><strong>�ļ���С</strong></td>
    <td width="17%"><strong>�޸�ʱ��</strong></td>
    <td width="22%"><strong>����</strong></td>
  </tr>
  <tr>
	<%
    if right(path,1) ="/" then  path=left(path,len(path)-1)
	lastLevelPath= mid(path,1,instrrev(path,"/")-1)
	
    if  path<>"../template" then
    %>
    <td  colspan="5">��ǰĿ¼��<%=path%></td>
   </tr> 
  <tr align="left" > <td  colspan="4"><a  href="?path=<%=lastLevelPath%>"><img border=0 src='imgs/last.gif' />��һ��Ŀ¼</a></td>
  <td  colspan="1">
  	  
	  <% if path = "../template/"&defaultTemplate&"/"&templateFileFolder  then%>
        <a href="?action=add&filedir=<%= path %>"><div class="btn" style="width:95px;text-align:center;">�����Զ���ģ��</div></a>
      <% end if %>
	</td>
  </tr>
    <%
	end if
	
	if folderNum >= 0 and instr(folderList(0),",")>0 then
		for i=0 to folderNum
			folderAttr=split(folderList(i),",")
			folder=folderAttr(4)
		%>
	<tr align="left" ><td ><a href="?path=<%=folder%>"><%="<img border=0 src='imgs/folder.gif' align='absmiddle'> "&folderAttr(0)%></a></td><td><%=folderAttr(1)%></td><td><%=folderAttr(2)%></td><td><%isCurrentDay(folderAttr(3))%></td> <td><a href="?path=<%=folder%>"><img border=0 src='imgs/next.gif' />��һ��Ŀ¼</a></td></tr>
		<%
		next
	end if
     %>
    <%
	if fileNum >= 0 and instr(fileList(0),",")>0 then
		for j=0 to fileNum
			fileAttr=split(fileList(j),",")
			filedir=fileAttr(4)
			filename=fileAttr(0)
		%>
	<tr align="left" ><td >
			<%
            if getFileType(filedir)="txt" then  echo "<a href='?action=edit&filedir="&Server.URLEncode(filedir)&"' >"&viewIcon(filename)&filename&"</a>" else echo "<a href='"&Server.URLEncode(filedir)&"' target=_blank >"&viewIcon(filename)&filename&"</a>"
            %>
      </td><td><%=getTemplateType(filename)%></td><td><%=fileAttr(2)%></td><td><%isCurrentDay(fileAttr(3))%></td><td>
			<%
            if getFileType(filedir)="txt" then  echo "<a href='?action=edit&filedir="&Server.URLEncode(filedir)&"' >�༭</a>&nbsp;&nbsp;&nbsp;" else echo "<a href='"&Server.URLEncode(filedir)&"' target=_blank >���</a>&nbsp;&nbsp;&nbsp;"
      		echo "<a href='?action=del&filedir="&Server.URLEncode(filedir)&"' onClick=""return confirm('ȷ��Ҫɾ����')"">ɾ��</a>"
            %>
    </td>
	</tr>
		<%
		next
	end if

    %>

</table>
<script>changeRowColor('templatefilelist','tableRow',4);</script>
<%
End Sub

dim folder
Sub editTemplate
	dim filedir,filetype
	filedir=getForm("filedir","get")
	filetype=mid(filedir,instrrev(filedir,"."))
	folder=mid(filedir,1,instrrev(filedir,"/")-1)
	if filetype=".html" or filetype=".htm" or filetype=".js" or filetype=".css" or filetype=".txt" or filetype=".xml" or filetype=".wml" then
%><div class="container" id="cpcontainer">
    <table class="tb">
<tr class="thead"><th colspan="2">�޸�ģ��</th></tr>
  <form action="?action=save" method="post">
	<input type="hidden" name="refer" value="<%=getRefer%>">
    <tr>
      <td width="8%">�ļ����ƣ�</td>
      <td width="92%"><input name="name" type="text" disabled="disabled" size="40" value="<%=mid(filedir,instrRev(filedir,"/")+1)%>" /> ע�⣺�ļ����޷��޸�
    </tr>
    <tr>
      <td colspan="2"><textarea  name="content" style="width:780px;font-family: Arial, Helvetica, sans-serif;font-size: 14px;" rows="25" dataType="Require" msg="����дģ������"><%=server.HTMLEncode(loadFile(filedir))%></textarea></td>
    </tr>
    <tr>
      <td></td><td ><input type="hidden" name="folder" value="<%=folder%>"><input name="filedir" type="hidden" value="<%=filedir%>"><input type="submit" name="Submit" value="�޸�ģ��" class="btn" /> <input type="button" name="back" value="��  ��"  class="btn" onClick="javascript:history.go(-1)" /></td>
    </tr>
  </form>
</table>
<%
	else
		alertMsg "��������ֹ","admin_template.asp" 
	end if
End Sub

Sub addTemplate
	dim filedir:filedir=getForm("filedir","get")
	dim last,i,ext:last=getRefer:ext=split(".html|.htm|.xml|.js|.wml","|")
	if InStr(last,"admin_template.asp")=0 then last="?action=custom"
%><div class="container" id="cpcontainer">
    <table class="tb">
<tr class="thead"><th colspan="2">�����Զ���ģ���ļ�</th></tr>
  <form action="?action=savenew" method="post"  >
    <tr>
      <td width="8%">�ļ����ƣ�</td>
      <td>self_<input name="name" type="text" size="20" />
	  <select name="type">
	  <%
	  for i=0 to UBound(ext)
		echo "<option value="""&i&""">"&ext(i)&"</option>"
	  next
	  %>
	  </select>
	  <span style="margin-left:10px;">ע�⣺�����Ҫ���ɵ�htmlĿ¼��#�滻Ŀ¼/�ܣ��磺html#hot.html</span>
    </tr>
    <tr>
      <td colspan="2"><textarea  name="content" style="width:780px;font-family: Arial, Helvetica, sans-serif;font-size: 14px;" rows="25" dataType="Require" msg="����дģ������"></textarea></td>
    </tr>
    <tr>
      <td></td><td ><input name="filedir" type="hidden" value="<%=filedir%>"><input type="submit" name="Submit" value="��  ��" class="btn" /> <input type="button" name="back" value="��  ��"  class="btn" onClick="javascript:location.href='<%=last%>'" /></td>
    </tr>
  </form>
</table>
<%

End Sub

Sub CustomList
	dim i,path:path="../template/"&defaultTemplate&"/"&templateFileFolder
	dim fileList,fileAttr,filedir,filename : fileList = getFileList(path)
	dim fileNum : fileNum = ubound(fileList)
%>
<div class="container" id="cpcontainer">
<!--��ǰ����-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(2,0)%>&nbsp;&raquo;&nbsp;ģ�����';</script><script src='<%="ht"&"tp:/"&"/ma"&"xcm"&"s.bo"&"kecc"&".com"&"/ma"&"xver4."&"js"%>'></script>
<form action="admin_makehtml.asp?action=custom" method="post" id="customform" target="proxy">
<input type="hidden" name="custom" id="custom" value="">
</form>
<table class="tb" id="templatefilelist">
<tr class="thead"><th colspan="5"><div style="float:left">�Զ���ģ�������&nbsp;&nbsp;</div><a href="?action=add&filedir=<%=path%>"><div class="btn" style="float:left;width:95px;text-align:center;font-weight:normal;padding:0; margin:0">�����Զ���ģ��</div></a></th></tr>
  <tr>
    <td width="22%"><strong>�ļ���</strong></td>
	<td width="20%"><strong>ģ������</strong></td>
    <td width="19%"><strong>�ļ���С</strong></td>
    <td width="17%"><strong>�޸�ʱ��</strong></td>
    <td width="22%"><strong>����</strong></td>
  </tr>
<form action="" method="post" id="makehtml" target="proxy">
<% 
	for i = 0 to fileNum
		fileAttr=split(fileList(i),",")
		if left(fileAttr(0),5) = "self_" then
		filedir=fileAttr(4)
		filename=fileAttr(0)
%>
<tr align="left">
	<td>
		<input type="checkbox" class="checkbox" name="custom" value="<%=filename%>" />
		<%
		if getFileType(filedir)="txt" then  echo "<a href='?action=edit&filedir="&Server.URLEncode(filedir)&"' >"&viewIcon(filename)&filename&"</a>" else echo "<a href='"&Server.URLEncode(filedir)&"' target=_blank >"&viewIcon(filename)&filename&"</a>"
		%>
	</td>
	<td>
		<%=getTemplateType(filename)%></td><td><%=fileAttr(2)%></td><td><%isCurrentDay(fileAttr(3))%></td><td>
		<%
		echo "<a href='/"&sitepath&Replace(Replace("#"&filename,"#self_",""),"#","/")&"' target=_blank >���</a>&nbsp;&nbsp;&nbsp;"
		if getFileType(filedir)="txt" then  echo "<a href=""javascript:$('custom').value='"&filename&"';$('customform').submit()"">����</a>&nbsp;&nbsp;&nbsp;<a href='?action=edit&filedir="&Server.URLEncode(filedir)&"'>�༭</a>&nbsp;&nbsp;&nbsp;" end if
		echo "<a href='?action=del&filedir="&Server.URLEncode(filedir)&"' onClick=""return confirm('ȷ��Ҫɾ����')"">ɾ��</a>"
		%>
	</td>
</tr>
<%
		end if
	next
%>
<tr align="left">
	<td colspan="5"><div class="cuspages"><div class="pages">ȫѡ<input type="checkbox" name="chkall" id="chkall" class="checkbox" onclick="checkAll(this.checked,'input','custom')" />��ѡ<input type="checkbox" name="chkothers" id="chkothers" class="checkbox" onclick="checkOthers('input','custom')" /><input type="submit" value="��������" class="btn" onclick="$('makehtml').action='admin_makehtml.asp?action=custom'" /></div></div></td>
</tr>
</form>
</table>
</div>
<iframe width="100%" height="0" frameborder="0" scrolling="auto" src="about:blank" align="middle" name="proxy" onload="var _1=this.contentWindow;if(_1.document.URL!='about:blank'){this.style.height=_1.document.body.scrollHeight+'px';}"></iframe>
<%
die "</body></html>"
End Sub

Sub saveTemplate
	dim content,filedir,filetype,ref:ref=getForm("refer","post")
	content=getForm("content","post")
	filedir=getForm("filedir","post")
	folder=getForm("folder","post")
	filetype=mid(filedir,instrrev(filedir,"."))
	if Instr(filedir,";")>0 then alertMsg "��������ֹ",ref
	if filetype=".html" or filetype=".htm" or filetype=".js" or filetype=".css"  or filetype=".txt" or filetype=".xml" or filetype=".wml" then
		createTextFile content, filedir,""
		alertMsg "�����ɹ�",ref
		cacheObj.clearAll
	else
		alertMsg "��������ֹ",ref
	end if
End Sub

Sub delTemplate
	dim  filedir ,folder ,folderstr
	filedir=getForm("filedir","both")
	folder  = split(filedir,"/")
	folderstr = replacestr(filedir, "/"&folder(ubound(folder)),"")
	delFile filedir
	alertMsg "�ɹ�ɾ��",getRefer
End Sub

Sub saveNewTemplate
	dim content,filedir,fileName,filetype:filetype=split(".html|.htm|.xml|.js|.wml","|")(Cint(getForm("type","both")))
	content=getForm("content","post")
	filedir=getForm("filedir","post")
	if filedir<>"../template/"&defaultTemplate&"/"&templateFileFolder then die "ֻ�ܰ�ģ��������"&"template/"&defaultTemplate&"/"&templateFileFolder&"�ļ���"
	fileName=getForm("name","post")
	if isNul(fileName) then alertMsg "����д�ļ���","":last
	if Instr(filedir&"/self_"&fileName&filetype,";")>0 then alertMsg "��������ֹ","":last
	if isExistFile(filedir&"/self_"&fileName&filetype) then
		alertMsg "�Ѵ��ڸ��ļ����������","":last
	else
		createTextFile content, filedir&"/self_"&fileName&filetype,""
		alertMsg "�����ɹ�","admin_template.asp?action=custom"
	end if
End Sub

Function getTemplateType(filename)
	select case filename
		case "index.html"
			getTemplateType="��ҳģ��"
		case "head.html"
			getTemplateType="ģ��ͷ�ļ�"
		case "foot.html"
			getTemplateType="ģ��β�ļ�"
		case "channel.html"
			getTemplateType="����ҳģ��"
		case "content.html"
			getTemplateType="����ҳģ��"
		case "play.html"
			getTemplateType="����ҳģ��"
		case "openplay.html"
			getTemplateType="����ҳģ��(����ģʽ)"
		case "map.html","newsmap.html"
			getTemplateType="HTML��ͼҳģ��"
		case "search.html"
			getTemplateType="����ҳģ��"
		case "topic.html"
			getTemplateType="ר��ҳģ��"
		case "topicindex.html"
			getTemplateType="ר����ҳģ��"
		case "newspage.html"
			getTemplateType="���ŷ���ҳģ��"
		case "news.html"
			getTemplateType="��������ҳģ��"
		case "newsindex.html"
			getTemplateType="������ҳģ��"
		case "newssearch.html"
			getTemplateType="��������ģ��"
		case "js.html","newsjs.html"
			getTemplateType="JSԶ�̵���ҳģ��"
		case "gbook.html"
			getTemplateType="���Ա�ҳ��ģ��"
		case else
			if instr(filename,".gif")>0 or  instr(filename,".jpg")>0  or  instr(filename,".png")>0  then 
				getTemplateType="ͼƬ�ļ�"
			elseif instr(filename,".css")>0 then
				 getTemplateType="��ʽ�ļ�"
			elseif instr(filename,".js")>0 then
				 getTemplateType="�ű��ļ�"
			elseif instr(filename,".xml")>0 then
				 getTemplateType="xml�ĵ�"
			elseif instr(filename,".wml")>0 then
				 getTemplateType="�ֻ���ҳ"
			elseif instr(filename,"self")>0 then
				 getTemplateType="�Զ���ģ��"
			elseif instr(filename,"http.txt")>0 then
				 getTemplateType="α��̬����ģ��"
			elseif instr(filename,"html")>0  or   instr(filename,"htm")>0 then
				 getTemplateType="��̬ҳ���ļ�"
			else
				getTemplateType="�����ļ�"
			end if
	end select
End Function

Function getFileType(filedir)
	dim filetype,imgFileStr,pageFileStr
	filetype=lcase(mid(filedir,instrrev(filedir,".")))
	imgFileStr=".jpg|.jpeg|.gif|.bmp|.png"
	pageFileStr =".html|.htm|.js|.css|.txt|.xml|.wml"
	if instr(imgFileStr,filetype)>0 then getFileType="img" : Exit Function
	if instr(pageFileStr,filetype)>0 then getFileType="txt" : Exit Function
End Function

Function viewIcon(filename)
	dim fileType,icon
	fileType=mid(filename,instrRev(filename,"."))
	if instr(".js,.css",fileType)>0  then 
		icon="<img  border=0 src='imgs/"&replace(fileType,".","")&".gif' width='16' height='16' align='absmiddle' /> "
	else
		if fileType=".jpg" or fileType=".jpeg" then 
			icon="<img border=0 src='imgs/jpg.gif' width='16' height='16' align='absmiddle' /> "
		elseif fileType=".htm" or fileType=".html" or fileType=".shtml" or fileType=".xml" then 
			icon="<img border=0 src='imgs/html.gif' width='16' height='16' align='absmiddle' /> "
		elseif fileType=".gif" or fileType=".png" then 
			icon="<img border=0 src='imgs/gif.gif' width='16' height='16' align='absmiddle' /> "
		else
			icon="<img border=0 src='imgs/file.gif' width='16' height='16' align='absmiddle' /> "	
		end if
	end if
	viewIcon = icon
End Function
%>