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
server.scripttimeout=99999

viewHead "���ݿ���ز���" & "-" & menuList(4,0)

dim action,table:action = getForm("action", "get"):table=getForm("table","both")
dim sql : sql = getForm("sql","post")
dim errIds
'ȫ��RegExp
Dim gRegExp:gRegExp=null

Select  case action
	case "sql" : executeSql
	case "result" : executeSql : executeResult
	case "japan" : killJapan
	case "kill" : killJapanSubmit
	case "batch" : batchReplace
	case "batchsubmit" : batchReplaceSubmit
	case "randomset" : randomset
	case "dorandomset" : dorandomset
	case "downpic" : sitePic=ifthen(table="news","newspic",sitePic)&"/"&Year(now())&"-"&Month(now()):downPic
	case "checkpic" : checkPic
	case "sumitcheck" : sumitCheckPic
	case "delvideoform":delvideoform
	case "delByFrom":delByFrom
	case "repairplaydata":repairplaydata
	case "existpic":existpic
	case "repeat":repeat
End Select 
viewFoot

Sub repeat
%>
<div class="container" id="cpcontainer">
<form  method="post" action="?action=result">
<table class="tb">
    <tr class="thead"><td>ͬ�����ݼ��</td></tr>
    <tr><td>��ⳤ�ȣ�<input type="text" name="rlen" id="rlen" size="5" value="2" maxlength="1" onkeyup="this.value=this.value.replace(/\D/g,'')"> <input type="button" class="btn" onclick="location.href='admin_video.asp?repeat=ok&order=m_name&rlen='+$('rlen').value;" value="��ѯ"></td></tr>
	</table>
</form></div>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(4,0)%>&nbsp;&raquo;&nbsp;SQL�߼�����';</script>
<%
End Sub

Sub existpic
	Dim x,y,rs:x=ifthen(table="news","news","data"):y=getForm("offset","both")
	if not isNum(y) then y=0 else y=Clng(y)
	if x="news" then
		set rs=conn.db("SELECT m_id,m_title AS m_name,m_pic FROM {pre}news WHERE m_pic LIKE 'pic/%'","records3")
	else
		set rs=conn.db("SELECT m_id,m_name,m_pic FROM {pre}data WHERE m_pic LIKE 'pic/%'","records3")
	end if
	if y>0 AND not rs.eof then rs.move y-1
	if rs.eof then
		alertMsg "��ϲ���Ѿ��㶨","admin_datarelate.asp?action=checkpic"
	else
		while(y MOD 1001 <> 1000 AND not rs.eof)
			if not isExistFile("../"&rs("m_pic")) then
				echo "��� <font color='red'>id:"&rs("m_id")&" "&rs("m_name")&"</font><br/>"
				rs("m_pic")=""
				rs.update
			else
				echo "���� <font color='blue'>id:"&rs("m_id")&" "&rs("m_name")&"</font><br/>"
			end if
			rs.movenext
			y=y+1
		wend
		y=y+1
		echo "<br>��ͣ1����������<script language=""javascript"">setTimeout(function (){location.href='?action="&action&"&table="&x&"&offset="&y&"';},1000);</script>"
	end if
End Sub

Sub executeSql
%><div class="container" id="cpcontainer">
<form  method="post" action="?action=result">
<table class="tb">
    <tr class="thead"><td>SQL�߼�����</td></tr>
    <tr><td><input  type="text" name="sql" size="90" value="<%=sql%>"> <input type="submit" class="btn"  value="ִ��SQL���">  <input type="reset" value="���" class="btn"></td></tr>
	<tr><td>
	1: �г���������  select * from m_data<br/>
	2: ɾ����������  delete  from m_data<br/>
	3: �г�ĳһ��Ŀ����  select  *  from m_data where m_type =(select m_id from m_type where m_name = 'Ƶ��1') <br/>
	4: ɾ��ĳһ��Ŀ����  delete  from m_data where m_type =(select m_id from m_type where m_name = 'Ƶ��1') <br/>
	5: �г�ĳһר�������  select  *  from m_data where m_type =(select m_id from m_topic where m_name = '���˱ؿ�ʮ��')<br/>
	6: ɾ�� ĳһר�������  delete   from m_data where m_type =(select m_id from m_topic where m_name = '���˱ؿ�ʮ��')<br/><br/>
    <a href="http://bbs.bokecc.com/viewthread.php?tid=91557" target="_blank">��ʾ������sql���Ӧ�ý̳�</a>
	</td></tr>
	</table>
</form></div>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(4,0)%>&nbsp;&raquo;&nbsp;SQL�߼�����';</script>
<%	
End Sub

Sub executeResult
	dim isSelect,resultRs,errorFlag,errObj,fieldObj,i,exeResultNum,n : n=0
	if not isNul(sql) then
		isSelect = (lcase(left(trim(Sql),6)) = "select")
		on error resume next
		if isSelect = true then Set resultRs = conn.dbConn.execute(sql,exeResultNum) else conn.dbConn.execute sql,exeResultNum
		If conn.dbConn.Errors.count<>0 then errorFlag = true : set resultRs = conn.dbConn.Errors else errorFlag = False
		if errorFlag then
%>
<table class="tb">
<tr> <td> �����</td><td> ��Դ</td><td> ����</td><td>����</td><td> �����ĵ�</td> </tr>
<%
			for i=1 To conn.dbConn.Errors.count
				set errObj=conn.dbConn.Errors(i-1)
%>
<tr> <td> <% = errObj.Number %> </td><td> <% = errObj.Description %> </td><td>  <% = errObj.Source %> </td><td>  <% = errObj.Helpcontext %> </td><td> <% = errObj.HelpFile %> </td></tr>
<%
			next
%>
</table>		
<%		
		else
%>
<table class="tb">
<%
			if isSelect = true then
%>
<tr> 
<%
					for each fieldObj in resultRs.Fields
%>
					  <td nowrap class=forumrow> <% = fieldObj.name %></td>
<%
					next
%>
					</tr>
<%
					do while Not resultRs.Eof
						n=n+1 : if n>100 then exit do
%>
					<tr > 
<%
						for each fieldObj In resultRs.Fields
%>
					  <td nowrap class=forumrow>
<%
							if  isNul(fieldObj.value) then 
								echo "&nbsp;"
							else
								if len(fieldObj.value)>50 then echo left(filterStr(fieldObj.value,"html"),10)&"..." else echo fieldObj.value						
							end if
%>
						</td>
					  <%
						next
			%>
					</tr>
					<%
						resultRs.MoveNext
					loop
			else
			%>
					<tr> <td>ִ�н��</td></tr>
					<tr> <td> <% = exeResultNum & "����¼��Ӱ��"%></td></tr>
		  <%end if%>
			  </table>
<%			
		end if	 
	end if
	Set resultRs = Nothing
End Sub

Sub killJapan
%>
<div class="container" id="cpcontainer">
<table class="tb">
<tr class="thead"><td colspan="15"  align="left" >�ڴ��������</td></tr>
<tr><td><input type="button" class="btn" value="����ڴ��������" onClick="javascript:location.href='?action=kill';" ><br><br>����ǰ�뱸�����ݿ⣬������������ɲ�����ת����ʧ��</td></tr></table></div>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(4,0)%>&nbsp;&raquo;&nbsp;�ڴ��������';</script>
<%	
End Sub

Sub killJapanSubmit
	dim i,rsObj,m_name,m_actor,m_playdata,m_downdata,m_pic,m_director,m_keyword,isExist : isExist=false
	set rsObj=conn.db("select m_id,m_name,m_actor,m_playdata,m_downdata,m_pic,m_director,m_keyword from {pre}data","records1")
	echo "<table class=""tb""><tr class=""thead"" align='left'><td colspan=""3"">�Ѵ�������</td></tr><tr><td>���</td><td>����</td><td>����</td></tr>"
	for i=1 to rsObj.recordcount
		m_name=rsObj(1) : m_actor=rsObj(2) : m_playdata=rsObj(3) : m_downdata=rsObj(4) : m_pic = rsObj(5) : m_director = rsObj(6) : m_keyword = rsObj(7)
		m_name=japanEncode(m_name) : m_actor=japanEncode(m_actor) : m_playdata=japanEncode(m_playdata) : m_downdata=japanEncode(m_downdata) : m_pic=japanEncode(m_pic) : m_director=japanEncode(m_director) : m_keyword=japanEncode(m_keyword)
		if m_name<>rsObj(1) or m_actor<>rsObj(2) or m_playdata<>rsObj(3) or m_downdata<>rsObj(4) or m_pic<>rsObj(5) or m_director<>rsObj(6) or m_keyword<>rsObj(7) then isExist=true else isExist=false
		'echo"--"&isExist&"<br>"
		if isExist then conn.db "update {pre}data set m_name='"&m_name&"',m_actor='"&m_actor&"',m_playdata='"&m_playdata&"',m_downdata='"&m_downdata&"',m_pic='"&m_pic&"',m_director='"&m_director&"',m_keyword='"&m_keyword&"' where m_id="&rsObj(0),"execute" : echo  "<tr><td>"&rsObj(0)&"</td><td>"&m_name&"</td><td>"&m_actor&"</td></tr>" 
		rsObj.movenext
		if rsObj.eof then exit for
	next
	echo "</table>"
	rsObj.close
	set rsObj=nothing
End Sub

Sub batchReplaceSubmit
	dim i,rsObj,m_str1,m_str2,m_field : m_field=getForm("m_field","post") : m_str1=getForm("m_str1","post") : m_str2=getForm("m_str2","post")
	set rsObj=conn.db("select m_id,"&m_field&" from {pre}data where "&m_field&" like '%"&m_str1&"%'","records1")
	echo "<table class=""tb""><tr class=""thead"" align='left'><td>�Ѵ�������</td></tr><tr><td>���</td></tr>"
	for i=1 to rsObj.recordcount
		conn.db "update {pre}data set "&m_field&"='"&replaceStr(rsObj(1),m_str1,m_str2)&"' where m_id="&rsObj(0),"execute" : echo  "<tr><td>IDΪ"&rsObj(0)&"�������滻�ɹ�</td></tr>" 
		rsObj.movenext
		if rsObj.eof then exit for
	next
	echo "</table>"
	rsObj.close
	set rsObj=nothing
End Sub

Sub batchReplace
%>
<div class="container" id="cpcontainer">
<form action="?action=batchsubmit" method="post">
<table class="tb">
<tr class="thead"><td colspan="15"  align="left" >���������滻</td></tr>
<tr><td>���ֶΣ�<select name="m_field" style="width:150px"><%echoFieldOptions%></select>�е��ַ���<input type="text" size="25" name="m_str1" /> �滻�ɣ�<input type="text" size="25" name="m_str2" /> <input class="btn" type="submit" value="ȷ���滻" /><br><br><font color=#FF0000>ע�⣬�����������滻���ַ��ͻ������滻�Ҳ��ɻָ�����С�Ĵ�����</font>
</td></tr></table>
</form>
</div>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(4,0)%>&nbsp;&raquo;&nbsp;���������滻';</script>
<%	
End Sub

Sub downPic
	dim i,rsObj,sql,page,fileName,FileExt,filePath,picUrl,downType,isDownOk,vid:isDownOk=false
	downType=getForm("downtype","get")
	if table="news" then
		select case downType
			case "all"
				sql="select m_id,m_title AS m_name,m_pic from {pre}news where m_pic like 'http://%' order by m_addtime desc"
			case else
				sql="select m_id,m_title AS m_name,m_pic from {pre}news where m_pic like '%bokecc.com%' or m_pic like '%cmsplugin.net%'  order by m_addtime desc"
		end select
	else
		select case downType
			case "all"
				sql="select m_id,m_name,m_pic from {pre}data where m_pic like 'http://%' order by m_addtime desc"
			case else
				sql="select m_id,m_name,m_pic from {pre}data where m_pic like '%bokecc.com%' or m_pic like '%cmsplugin.net%'  order by m_addtime desc"
		end select
	end if
	set rsObj=conn.db(sql,"records1")
	if rsObj.recordcount=0 then alertMsg "��ϲ������ͼƬ�Ѿ��ɹ����ص�����",ifthen(table="news","admin_news.asp","admin_video.asp"):die ""
	rsObj.pagesize=30
	page=getForm("page","get")
	if isNul(page) then page=1 else page=clng(page)
	if page>rsObj.pagecount then page=rsObj.pagecount
	if page=1 then session("m_pic_page") = rsObj.pagecount
	rsObj.absolutepage=page
	echo "<font color=red>��"&session("m_pic_page")&"ҳ,���ڿ�ʼ���ص�"&page&"ҳ���ݵĵ�ͼƬ</font><br>"
	for i=1 to rsObj.pagesize
		picUrl=rsObj("m_pic"):vid=rsObj("m_id")
		filename=mid(picUrl,instrrev(picUrl,"/")+1):fileext=getFileFormat(filename)
		if fileext="" then:fileext=".jpg":end if
		filePath = "../pic/"&sitePic&"/"&vid&fileext
		if not isExistFile(filePath) then
			isDownOk=downSinglePic(picUrl,vid,rsObj("m_name"),filePath,"down")
		else
			echo "����<font color=red>"&rsObj("m_name")&"</font>��ͼƬ�Ѿ����� <a target=_blank href="&filePath&">Ԥ��ͼƬ</a><br>"
			isDownOk=true
		end if
		if isDownOk then 
			updatePicUrl vid,replaceStr(filePath,"../","")
			if waterMark=1 and isInstallObj(JPEG_OBJ_NAME) then  writeFontWaterPrint filePath,waterMarkLocation
		else
			updatePicUrl vid,""
		end if
		rsObj.movenext
		if rsObj.eof  then exit for
	next

	rsObj.close : set rsObj=nothing
	echo "<br>��ͣ5����������<script language=""javascript"">setTimeout(""gatherNextPagePic();"",5000);function gatherNextPagePic(){location.href='?action=downpic&downtype="&downType&"&table="&table&"&page="&(page+1)&"';}</script>"
End Sub

Sub updatePicUrl(id,pic)
	conn.db "update {pre}"&ifthen(table="news","news","data")&" set m_pic='"&pic&"' where m_id="&id,"execute"
End Sub

Function japanEncode(Byval str)
	dim i,existJapan,japanStr
	dim japanArray
	japanArray=array("��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��")
	if isNul(str)  then japanEncode="" : Exit Function
	japanStr=str
  	for i=0 to 25
		if instr(japanStr,japanArray(i))>0 then japanStr=replaceStr(japanStr,japanArray(i),"")
	next
	japanEncode = japanStr
End Function

Sub echoFieldOptions
	dim fieldOptionArray(16,1),i,arrayLen
	fieldOptionArray(0,0)="��Ƶ����" : fieldOptionArray(0,1)="m_name"
	fieldOptionArray(1,0)="��ƵͼƬ" : fieldOptionArray(1,1)="m_pic"
	fieldOptionArray(2,0)="��Ƶ����" : fieldOptionArray(2,1)="m_actor"
	fieldOptionArray(3,0)="��Ƶ���" : fieldOptionArray(3,1)="m_des"
	fieldOptionArray(4,0)="��Ƶ����ʱ��" : fieldOptionArray(4,1)="m_addtime"
	fieldOptionArray(5,0)="��Ƶ������ɫ" : fieldOptionArray(5,1)="m_color"
	fieldOptionArray(6,0)="��Ƶ�������" : fieldOptionArray(6,1)="m_publishyear"
	fieldOptionArray(7,0)="��Ƶ���е���" : fieldOptionArray(7,1)="m_publisharea"
	fieldOptionArray(8,0)="��Ƶ����ID" : fieldOptionArray(8,1)="m_type"
	fieldOptionArray(9,0)="��Ƶ�Ƽ�" : fieldOptionArray(9,1)="m_commend"
	fieldOptionArray(10,0)="��Ƶ�����" : fieldOptionArray(10,1)="m_hit"
	fieldOptionArray(11,0)="���ŵ�ַ" : fieldOptionArray(11,1)="m_playdata"
	fieldOptionArray(12,0)="���ص�ַ" : fieldOptionArray(12,1)="m_downdata"
	fieldOptionArray(13,0)="��Ƶ��ע" : fieldOptionArray(13,1)="m_note"
	fieldOptionArray(14,0)="�ؼ���" : fieldOptionArray(14,1)="m_keyword"
	fieldOptionArray(15,0)="��Ƶ����" : fieldOptionArray(15,1)="m_director"
	fieldOptionArray(16,0)="��Ƶ����" : fieldOptionArray(16,1)="m_lang"
	arrayLen=ubound(fieldOptionArray,1)
	for i=0 to arrayLen
		echo "<option value="""&fieldOptionArray(i,1)&""">["&fieldOptionArray(i,0)&"]</option>"
	next
End Sub
Sub checkPic
%>
<div class="container" id="cpcontainer"> 
<table class="tb">
<tr class="thead"><td colspan="15"  align="left" >��Ч����ͼƬ�������</td></tr>
<tr><td><input type="button" class="btn" value="��ѯ��ͼƬ������" onClick="location.href='admin_video.asp?action=nullpic';">&nbsp;&nbsp;<input type="button" class="btn" value="�������ͼƬ�����ڵ�ַ" onClick="location.href='?action=existpic';" style="width:140px">&nbsp;&nbsp;<input type="button" class="btn" value="ɾ����������ͼƬ" onClick="if(confirm('ע�⣺ʹ�ô˹���ǰ,���ȷ������ͼƬ�ļ�����/pic/<%=sitePic%>/')){location.href='?action=sumitcheck';}else{return false}"></td></tr>
<tr><td><input type="button" class="btn" value="��ѯ��ͼƬ������" onClick="location.href='admin_news.asp?action=nullpic';">&nbsp;&nbsp;<input type="button" class="btn" value="�������ͼƬ�����ڵ�ַ" onClick="location.href='?action=existpic&table=news';" style="width:140px">&nbsp;&nbsp;<input type="button" class="btn" value="ɾ����������ͼƬ" onClick="if(confirm('ע�⣺ʹ�ô˹���ǰ,���ȷ������ͼƬ�ļ�����/pic/newspic/')){location.href='?action=sumitcheck&table=news';}else{return false}"></td></tr>
<tr><td>˵�����Ա����ݿ���ͼƬ���ƣ�ɾ������ͼƬ�ļ�����ʡ�������ռ䣡<br />ע�⣺ʹ�ô˹���ǰ,���ȷ������ͼƬ�ļ�����/pic/<%=sitePic%>/</td></tr>
</table></div>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(4,0)%>&nbsp;&raquo;&nbsp;��ЧͼƬ�������';</script>	
<%	
End Sub

Sub  sumitCheckPic
%>
<div align="center">
<%
	viewFileAndFolder "../pic/"&sitePic
%>
</div>
<%
End Sub

Sub viewFileAndFolder(folder)
	dim i,j,folderFlag,fileFlag,folderList,fileList,folderNum,fileNum,subFolder,fileArray,filePath,rsObj,delFlag,echostr : folderList=getFolderList(folder) : fileList=getFileList(folder) : folderNum=ubound(folderList) : fileNum=ubound(fileList) : folderFlag=false : fileFlag=false : delFlag=false : echostr=""
	echostr = "�ļ���<a href='"&folder&"'><font color=red>"&folder&"</font></a>�°���"
	conn.db "update m_data SET m_pic = '' where right(m_pic,1)='/'","execute"
	if folderNum >= 0 and instr(folderList(0),",")>0 then
		folderFlag=true : echostr =echostr & "<font color=red>"&(folderNum+1)&"</font>���ļ���&nbsp;&nbsp;"
	else
		echostr = echostr & "<font color=red>0</font>���ļ���&nbsp;&nbsp;"
	end if
	if fileNum >= 0 and instr(fileList(0),",")>0 then
		fileFlag=true : echostr = echostr & "<font color=red>"&(fileNum+1)&"</font>��ͼƬ�ļ�&nbsp;&nbsp;"
	else
		echostr = echostr & "<font color=red>0</font>��ͼƬ�ļ�&nbsp;&nbsp;"
	end if
	echostr = echostr & "ռ�ÿռ�<font color=red>"&objFso.GetFolder(server.MapPath(folder)).size/1000&"</font>k&nbsp;&nbsp;�����޸�ʱ��Ϊ<font color=red>"&objFso.GetFolder(server.MapPath(folder)).DateLastModified&"</font>"
	echostr = echostr & "&nbsp;&nbsp;<br/>"
	echo echostr
	if fileFlag then 
		for j=0 to fileNum
			echostr=""
			fileArray=split(fileList(j),",")
			filePath=fileArray(4)
			if instr(filePath,"Thumbs.db")<1 then
				if Instr(",.jpg,.jpeg,.gif,.bmp,.swf,.png,",LCase(fileArray(1)))=0 then  delFile filePath : delFlag=true : echostr =  "&nbsp;&nbsp;&nbsp;&nbsp;�ļ�<font color=red>"&fileArray(0)&"</font>&nbsp;&nbsp;��СΪ<font color=red>"&fileArray(2)&"</font>����޸�ʱ��Ϊ<font color=red>"&fileArray(3)&"</font>Ϊ�Ƿ��ļ�,�Ѿ�ɾ��<br/>"
				if not delFlag then
					set rsObj=conn.db("select m_id from {pre}data where m_pic = '"&replace(filePath,"../","")&"'","execute")
					if rsObj.eof then
						delFile filePath : echostr = "&nbsp;&nbsp;&nbsp;&nbsp;	�ļ�<font color=red>"&fileArray(0)&"</font>&nbsp;&nbsp;��С<font color=red>"&fileArray(2)&"</font>����޸�ʱ��<font color=red>"&fileArray(3)&"</font>Ϊ��Ч�ļ�,�Ѿ�ɾ��<br/>"
					end if
				end if
			end if
			echo echostr
			delFlag=false
		next
	end if
	if folderFlag then 
		for i=0 to folderNum
			subFolder=split(folderList(i),",")(4)
			viewFileAndFolder subFolder
		next
	end if
End Sub

Sub delvideoform
%>
<div class="container" id="cpcontainer">
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(4,0)%>&nbsp;&raquo;&nbsp;ɾ��ָ����Դ';</script>

<table class="tb">
<tr class="thead"><td colspan="15"  align="left" >ɾ��ָ����Դ</td></tr>
<form method="post" id="delsubmit" action="?">

<tr><td>
ѡ����Դ��<select  name="from" id="from">
<option value="">��ѡ��ɾ������Դ</option>
<%=makePlayerSelect("")%>
</select></td></tr>
<tr><td>����ÿҳ���ݼ��ʱ�䣺<input type="text" name="wtime" size="5" value="5" />��&nbsp;(Ĭ��5)</td></tr>
<tr><td>������ɾ����<input type="text" name="domain" class="txt" value="" /> ��ʾ������Ϊ�����ƣ�����������ַ���������������ַ�����</td></tr>
<tr><td><input type="button" value="ȷ��ɾ��"  class="btn" onclick="var delsubmit=document.getElementById('delsubmit'),from=document.getElementById('from'),fromvalue=from.options[from.selectedIndex].value;if(fromvalue!=''){delsubmit.action='?action=delByFrom';delsubmit.submit();}else{alert('��ѡ��ɾ������Դ!')}"/> </td></tr>
<tr><td> <br />ע�⣺Ϊ�˷�ֹ���⡢�����ǰ����ȱ������ݿ� </td></tr>
</table>

<%
End Sub

Sub delByFrom
	dim from,id,regstr,templateobj,rsobj,page,i,playdata,wtime,domain:domain=preventSqlin(trim(getForm("domain","both")),"filter")
	from=preventSqlin(getForm("from","both"),"filter"):id=getReferedId(from):page=getForm("page","get"):wtime=getForm("wtime","both")
	if isNul(wtime) then wtime="5"
	set templateobj = mainClassObj.createObject("MainClass.template")
	regstr=from&".+"&(ifthen(domain<>"","("&addcslashes(domain)&").+",""))&"\$"&id
	'die "select m_name,m_playdata from {pre}data where m_playdata like '%$"&id&"%'"
	set rsobj=conn.db("select m_id,m_name,m_playdata from {pre}data where m_playdata like '%"&(ifthen(domain<>"",domain&"%",""))&"$"&id&"%'","records1")
	if rsobj.eof then
		alertMsg "��ϲ���Ѿ��㶨","admin_datarelate.asp?action=delvideoform"
	else 
		rsobj.pagesize=30
		if isNul(page) then page=1 else page=clng(page)
		if page=1 then session("delfrompcount")=rsobj.pagecount
		if page<1 then page=1
		if page>rsobj.pagecount then page=rsobj.pagecount
		rsobj.absolutepage=page
		echo "<style>body{font-size: 12px;}</style>����׼��ɾ��<font color='red' >"&from&"</font>��Դ,��<font color='red' >"&session("delfrompcount")&"</font>ҳ����ǰ<font color='red' >"&(page&"")&"</font>ҳ��ÿҳ<font color='red' >"&rsobj.pagesize&"</font>��<br/>"
		for i=1 to rsobj.pagesize
			playdata = rsobj("m_playdata"):playdata=replace(replace(trimOuterStr(templateobj.regExpReplace(playdata,regstr,""),"$$$"),"$$$$$$","$$$"),"$$$$$$","$$$")
			conn.db "UPDATE {pre}data SET m_playdata='"&playdata&"' WHERE m_id="&rsobj("m_id"),"execute"
			echo "����<font color='red' >"&rsobj("m_name")&"</font>��<font color='red' >"&from&"</font>��Դɾ���ɹ�<br/>"
			rsobj.movenext
			if rsobj.eof then exit for
		next
		echo "<br>��ͣ"&wtime&"������<script language=""javascript"">setTimeout(""transNextPage();"","&wtime&"*1000);function transNextPage(){location.href='?action=delByFrom&page="&(page+1)&"&wtime="&wtime&"&from="&from&"&domain="&Server.URLEncode(domain)&"';}</script>"
	end if
	rsobj.close:set rsobj=nothing
	set templateobj=nothing
End Sub

Sub repairplaydata
	if getForm("do","both")<>"true" then%>
<div class="container" id="cpcontainer">
<form method="post" action="?action=repairplaydata">
<input type="hidden" name="do" value="true" />
<table class="tb">
    <tr class="thead"><td>�޸���������</td></tr>
    <tr><td><input type="submit" class="btn"  value="�޸���������"></td></tr>
	<tr><td>ע�⣺Ϊ�˷�ֹ���⡢�����ǰ����ȱ������ݿ�</td></tr>
</table>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(4,0)%>&nbsp;&raquo;&nbsp;�޸���������';</script>
<%	else
		dim sPlay,rCount,pCount,page:rCount=Str2Num(getForm("rCount","get")):pCount=Str2Num(getForm("pCount","get")):page=Cint(Str2Num(GetForm("page","get"))):page=Ifthen(page<1,1,page)
		dim i,j,x,dd,dl,ff,fs,li,ul,ol,lt,result,change,fined:fined=false:result=trim(getForm("result","get")):result=ifthen(result<>"",result,request.ServerVariables("HTTP_REFERER"))
		dim tRs:SET tRs=Conn.db("SELECT m_id,m_name,m_playdata FROM {pre}data","records1")
		tRs.PageSize=500:rCount = ifthen(rCount>0,rCount,0):pCount= ifthen(pCount>0,pCount,tRs.pagecount)
		if NOT tRs.EOF then:tRs.absolutepage = page:end if
		if NOT tRs.EOF then
			Dim rg:SET rg=jsRegExp("/^[^\$]+\$\$[^\$#]+\$[^\$]+\$[\w\s_]+(#[^\$#]+\$[^\$]+\$[\w\s_]+)*((\$\$\$)[^\$]+\$\$[^\$#]+\$[^\$]+\$[\w\s_]+(#[^\$#]+\$[^\$]+\$[\w\s_]+)*)*$/ig")
			Dim rg2:SET rg2=jsRegExp("/^[^\$]+\$\$[^\$#]+\$[^\$]+\$[\w\s_]+(#[^\$#]+\$[^\$]+\$[\w\s_]+)*$/ig")
			Dim rg3:fs="hd_tudou|hd_iask|hd_sohu|hd_openv|hd_56|youku|tudou|sohu|iask|6rooms|qq|youtube|ku6|flv|swf|real|media|qvod|pps|gvod|wp2008|cc|ppvod|pipi|56|17173|joy":SET rg3=jsRegExp("/(\$("&fs&"))\s*(\$("&fs&"))*#+/ig")
			echo "<div class=""container"" id=""cpcontainer"">���ڼ��鲢�޸�����,��ǰ�ǵ�<font color='red'>"&page&"</font>ҳ,��<font color='red'>"&pCount&"</font>ҳ,�ѳɹ��޸�<font color='red'>"&rCount&"</font>������<hr style=""border:1px solid #DEEFFA""/>"
			for i=0 to tRs.PageSize
				sPlay=trim(""&tRs("m_playdata")):change=false
				if sPlay<>"" then
					if right(sPlay,1)="#" then
						sPlay=Left(sPlay,Len(sPlay)-1):change=true
					end if
					if not rg.test(sPlay) then
						change=true:sPlay=trimOuterStr(Replace(Replace(Replace(Replace(Replace(Replace(sPlay,"#$$$","$$$"),"$$$#","$$$#"),"$$$$$$","$$$"),"$$$$$","$$$qvod$$"),"$$$$","$qvod$$$"),"'",""),"$$$")
						if not rg.test(sPlay) then
							dd=Split(sPlay,"$$$"):dl=UBound(dd)
							Redim dy(-1)
							for j=0 to dl
								dd(j)=rg3.replace(dd(j),"$1#")
								if not rg2.test(dd(j)) then
									ff=Split(dd(j),"$$")
									if UBound(ff)>0 then
										ul=Split(ff(1),"#"):ol=UBound(ul):lt=array()
										for x=0 to ol
											if ul(x)<>"" then
												li=Split(ul(x),"$")
												if UBound(li)<>2 then
													ReDim Preserve li(2)
												end if
												if Instr(li(0),"://")>0 then li(2)=li(1):li(1)=li(0):li(0)=""
												if Instr(" "&fs,trim(li(2)))=0 then li(2)=""
												if li(1)<>"" then
													if li(2)="" then li(2)=ifthen(InStr(" "&li(1),"qvod://")>0,"qvod",ifthen(InStr(" "&li(1),"gvod://")>0,"gvod",getReferedId(ff(0))))
													if li(0)="" then li(0)=ifthen(ol>0,"��"&ifthen(x<9,"0","")&(x+1)&"��","ȫ��")
													li(0)=Left(li(0),50)
													Push lt,Join(li,"$")
												end if
											end if
										next
										ff(1)=Join(lt,"#")
									end if
									dd(j)=Join(ff,"$$")
									if rg2.test(dd(j)) then
										Push dy,dd(j)
									end if
								else
									Push dy,dd(j)
								end if
							next
							sPlay=Join(dy,"$$$"):sPlay=ifthen(rg.test(sPlay),sPlay,"")
						end if
					end if
				end if
				if change then
					rCount=rCount+1:fined=true
					Conn.db "UPDATE {pre}data SET m_playdata='"&sPlay&"' WHERE m_id="&tRs("m_id"),"execute"
					echo "IDΪ:<font color=red>"&tRs("m_id")&"</font>,����Ϊ<font color=red>"&tRs("m_name")&"</font>�������޸��ɹ�<br>"
				else
					'echo "IDΪ:<font color=blue>"&tRs("m_id")&"</font>,����Ϊ<font color=blue>"&tRs("m_name")&"</font>�����ݲ����޸�<br>"
				end if
				tRs.Movenext
				if tRs.EOF then:exit for:end if
			next
			if fined<>true then echo "û�з��ָ�ʽ���������<br><br>"
			echo "<br>��ͣ3���������鲢�޸�����</div><script language=""javascript"">setTimeout(function (){location.href='?action="&action&"&do=true&page="&(Page+1)&"&pcount="&pCount&"&rcount="&rCount&"&result="&Server.URLEncode(result)&"';},3000);</script>"
			SET rg=nothing:SET rg2=nothing:SET rg3=nothing
		else
			Dim temp_type:temp_type=conn.db("select m_id from {pre}type","array")(0,0)
			conn.db "update {pre}data set m_type="&temp_type&" where m_type=0","execute"
			alertMsg "�������",result
		end if
		tRs.Close:SET tRs=Nothing
	end if
End Sub

Sub randomset
%>
<div class="container" id="cpcontainer">
<form  method="get" action="?">
<input type="hidden" name="action" value="dorandomset" />
<table class="tb">
    <tr class="thead"><td colspan="2">����������ݵ����</td></tr>
	<!--tr><td width="12%">����ʼֹID��</td><td width="88%"><input type="text" name="iStart" value="����" /> �� <input type="text" name="iEnd" value="����" /></td></tr>
	<tr><td width="12%">�Ǽ�����</td><td width="88%"><input type="checkbox" class="checkbox" name="bComm" id="bComm" value="1" onclick="$('bComm').checked=false" disabled/><label for="bComm">�������</label>&nbsp;&nbsp;<input type="checkbox" class="checkbox" name="bComm" id="bComm2" value="2" onclick="$('bComm').checked=false" /><label for="bComm2">�������</label>&nbsp;&nbsp;<span>0 �� <input type="text" name="maxComm" value="5" maxlength="1" readOnly></span>&nbsp;&nbsp;<input type="submit" class="btn"  value="ִ��"></td></tr-->
	<tr><td width="12%">��������䣺<!--/td><td width="88%"--><div style="display:none"><input type="checkbox" class="checkbox" name="bHit" id="bHit" value="1" onclick="$('bHit2').checked=false"/><label for="bHit">�������</label>&nbsp;&nbsp;<input type="checkbox" class="checkbox" name="bHit" id="bHit2" value="2" onclick="$('bHit').checked=false" checked/><label for="bHit2">�������</label>&nbsp;&nbsp;</div><span>0 �� <input type="text" name="maxHit" value="1000" maxlength="4"></span>&nbsp;&nbsp;<input type="submit" class="btn"  value="ִ��"></td></tr>
	<!--tr><td width="12%">��������</td><td width="88%"><input type="checkbox" class="checkbox" name="bDigg" id="bDigg" value="1" onclick="$('bDigg2').checked=false"/><label for="bDigg">�������</label>&nbsp;&nbsp;<input type="checkbox" class="checkbox" name="bDigg" id="bDigg2" value="2" onclick="$('bDigg').checked=false" /><label for="bDigg2">�������</label>&nbsp;&nbsp;<span>0 �� <input type="text" name="maxDigg" value="200" maxlength="3"></span>&nbsp;&nbsp;<input type="submit" class="btn"  value="ִ��"></td></tr>
	<tr><td width="12%">�ȴ�����</td><td width="88%"><input type="checkbox" class="checkbox" name="bTread" id="bTread" value="1" onclick="$('bTread2').checked=false"/><label for="bTread">�������</label>&nbsp;&nbsp;<input type="checkbox" class="checkbox" name="bTread" id="bTread2" value="2" onclick="$('bTread').checked=false" /><label for="bTread2">�������</label>&nbsp;&nbsp;<span>0 �� <input type="text" name="maxTread" value="200" maxlength="3"></span>&nbsp;&nbsp;<input type="submit" class="btn"  value="ִ��"></td></tr>
	<tr><td colspan="2">������� ˵���� �µ���� = ����� + �����<br />������� ˵���� �µ���� = �����<br />��������㼼�ɣ����� ������裬�����ֵ��Ϊ 0</td></tr>
    <tr><td colspan="2"><input type="submit" class="btn"  value="ִ��"></td></tr-->
</table>
</form>
</div>
<%
End Sub

Sub doRandomset
dim i,j,P,rCount,pCount,page,WHERE,iStart,iEnd,result,setary:WHERE=array():setary=array():result=trim(getForm("result","get")):result=ifthen(result<>"",result,request.ServerVariables("HTTP_REFERER"))
dim iHit,iDigg,iTread,bComm,maxComm,bHit,maxHit,bDigg,maxDigg,bTread,maxTread
	bComm=getForm("bComm","get"):maxComm=Str2Num(getForm("maxComm","get"))
	bHit=getForm("bHit","get"):maxHit=Str2Num(getForm("maxHit","get"))
	bDigg=getForm("bDigg","get"):maxDigg=Str2Num(getForm("maxDigg","get"))
	bTread=getForm("bTread","get"):maxTread=Str2Num(getForm("maxTread","get"))
	iStart=Str2Num(getForm("iStart","get")):iEnd=Str2Num(getForm("iEnd","get")):rCount=Str2Num(getForm("rCount","get")):pCount=Str2Num(getForm("pCount","get")):page=Cint(Str2Num(GetForm("page","get"))):page=Ifthen(page<1,1,page)
	if bComm<>"" OR bHit<>"" OR bDigg<>"" OR bTread<>"" then
		if iStart>0 then:Push WHERE,"m_id>"&iStart-1:end if
		if iEnd>0 then:Push WHERE,"m_id<"&iEnd+1:end if
		WHERE=trim(Join(WHERE," AND "))
		Dim tRs:SET tRs=Conn.db("SELECT m_id,m_name,m_hit,m_commend,m_digg,m_tread FROM {pre}data"&ifthen(WHERE<>""," WHERE "&WHERE,""),"records1")
		tRs.PageSize=1000:rCount = ifthen(rCount>0,rCount,tRs.recordcount):pCount= ifthen(pCount>0,pCount,tRs.pagecount)
		if NOT tRs.EOF then:tRs.absolutepage = page:end if
		if NOT tRs.EOF then
			echo "<div class=""container"" id=""cpcontainer"">���ڸ���,��ǰ�ǵ�<font color='red'>"&page&"</font>ҳ,��<font color='red'>"&pCount&"</font>ҳ,��<font color='red'>"&rCount&"</font>������<hr style=""border:1px solid #DEEFFA""/>"
			for i=0 to tRs.PageSize
				iHit=tRs("m_hit"):iDigg=tRs("m_digg"):iTread=tRs("m_tread")
				ReDim Preserve setary(-1)
				if bComm="2" then Push setary,"m_commend="&Int(Random()*maxComm)
				if bHit="2" then
					iHit=Int(Random()*maxHit):Push setary,"m_hit="&iHit
				elseif bHit="1" then
					iHit=iHit+Int(Random()*maxHit):Push setary,"m_hit="&iHit
				end if

				if bDigg="2" AND iHit>iDigg then
					iDigg=Min(Int(Random()*maxDigg),iHit):Push setary,"m_digg="&iDigg
				elseif bDigg="1" AND iHit>iDigg then
					iDigg=Min(iDigg+Int(Random()*maxDigg),iHit):Push setary,"m_digg="&iDigg
				end if

				if bTread="2" AND iHit-iDigg>iTread then
					iTread=Min(Int(Random()*maxTread),iHit-iDigg):Push setary,"m_tread="&iTread
				elseif bTread="1" AND iHit-iDigg>iTread then
					iTread=Min(iTread+Int(Random()*maxTread),iHit-iDigg):Push setary,"m_tread="&iTread
				end if
				if Ubound(setary)>-1 then Conn.db "UPDATE m_data SET "&Join(setary,",")&" WHERE m_id="&tRs("m_id"),"execute"
				echo "�ɹ����� ID:"&tRs("m_id")&"	<font color=red>"&tRs("m_name")&"</font> �����:"&iHit&"<br>"
				tRs.Movenext
				if tRs.EOF then:exit for:end if
			next
			echo "<br>��ͣ3����������</div><script language=""javascript"">setTimeout(function (){location.href='?action="&action&"&page="&(Page+1)&"&pcount="&pCount&"&rcount="&rCount&"&iStart="&iStart&"&iEnd="&iEnd&"&bComm="&bComm&"&bHit="&bHit&"&bDigg="&bDigg&"&bTread="&bTread&"&maxComm="&maxComm&"&maxHit="&maxHit&"&maxDigg="&maxDigg&"&maxTread="&maxTread&"&result="&Server.URLEncode(result)&"';},3000);</script>"
		else
			alertMsg "�������",result
		end if
		tRs.Close:SET tRs=Nothing
	else
		alertMsg "�������",result
	end if
End Sub

Function Random()
	Randomize():Random=Rnd
End Function

Function Min(iInt1,iInt2)
	Min=ifthen(iInt1<iInt2,iInt1,iInt2)
End Function

Sub Push(ByRef Arr,ByRef Val)
	on Error resume next
	Dim l:l=UBound(Arr)+1:l=ifthen(err,0,l):ReDim Preserve Arr(l)
	if isObject(Val) then:SET Arr(l)=Val:else:Arr(l)=Val:end if
End Sub

Function Str2Num(ByVal sNum)
	if not isNumeric(sNum) then:Str2Num=0:exit function:end if
	dim x:x=CDBL(sNum)
	if InStr(" "&sNum,".")>0 OR x<-2147483647 OR x>2147483647 then:Str2Num=CDbl(sNum):exit function:end if
	if x>-32768 AND x<32768 then:Str2Num=CInt(sNum):else:Str2Num=CLng(sNum):end if
End Function

Function makePlayerSelect(flag)
	dim i,playerinfo,selectstr,allstr,playerArray
	playerArray = getPlayerKinds("../inc/playerKinds.xml")
	for i= 0 to ubound(playerArray)
		playerinfo = split(playerArray(i),"__")
		if flag = playerinfo(0) then selectstr=" selected " else selectstr=""
		allstr =allstr&"<option value='"&playerinfo(0)&"' "&selectstr&">"&playerinfo(0)&"--"&playerinfo(1)&"</option>"
	next
	makePlayerSelect = allstr
End Function

Function getPlayerKinds(xmlfile)
	dim xmlobj,nodeLen,i
	set xmlobj = mainClassobj.createObject("MainClass.Xml")
	xmlobj.load xmlfile,"xmlfile"
	nodeLen = xmlobj.getNodeLen("playerkinds/player")
	redim playerArray(nodeLen-1)
	for i=0 to nodeLen-1
			playerArray(i)=xmlobj.getAttributes("playerkinds/player","flag",i)&"__"&xmlobj.getAttributes("playerkinds/player","des",i)
	next
	set xmlobj = nothing
    getPlayerKinds = playerArray
End Function

Function addcslashes(ByVal str)
	dim rg:SET rg=New RegExp:rg.Global=true:rg.Pattern="([\(\)\[\]\""\'\.\?\+\-\*\/\\\^\$])":if rg.test(str) then:addcslashes=rg.Replace(str,"\$1"):else:addcslashes=str:end if:SET rg=Nothing
End Function

Function ifthen(ByVal Bol,ByVal val,ByVal val2)
	if Bol=true then
		ifthen=val
	else
		ifthen=val2
	end if
End Function

Function getGRegExp(ByVal Pattern)
	if typename(gRegExp) <> "RegExp" then:SET gRegExp=new RegExp:end if
	SetRegExpAttribute gRegExp,jsPattern(Pattern)
	SET getGRegExp=gRegExp
End Function

Sub SetRegExpAttribute(ByRef oRegExp,ByVal aAtt)
	dim e,pattern:pattern=aAtt(0):e=" "&aAtt(1):with oRegExp:.IgnoreCase=inStr(e,"i")>0:.Global=inStr(e,"g")>0:.Multiline=inStr(e,"m")>0:.Pattern=pattern:end with
End Sub

Function jsPattern(ByVal Pattern)
	Dim rp,mt:rp=InstrRev(Pattern,"/"):mt=right(Pattern,len(Pattern)-rp):Pattern=Mid(Pattern,2,rp-2)
	jsPattern=array(Pattern,mt)
End Function

Function jsRegExp(ByVal Pattern)
	SET jsRegExp=new RegExp:SetRegExpAttribute jsRegExp,jsPattern(Pattern)
End Function

'�����滻
Function RegReplace(ByVal Str, ByVal Pattern, ByVal rStr)
	on Error resume next
	if Str="" then:RegReplace="":exit function:end if
	Dim rg,m,ms:SET rg=getGRegExp(Pattern)
	if rg.test(Str) then
		RegReplace=rg.Replace(Str,rStr)
	else
		RegReplace=Str
	end if
End Function
%>