<!-- #include file="admin_inc.asp" -->
<%
'******************************************************************************************
' Software name: Max(����˹) Gather EScript Engine
' Version:4.0
' Web: http://www.maxcms.net
' Author: ʯͷ(maxcms2008@qq.com),yuet,����
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ����
' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
'******************************************************************************************
viewHead "���ݹ���" & "-" & menuList(4,0)
'�����滻��
Const RepWordFile="imgs/repword.txt"
'αԭ��,�ı���
Const TextSegmentFile="../inc/textsegment.xml"

dim action:action=getForm("action", "get")
Select case LCASE(action)
	Case "saverepword":saverepword
	Case "doreplace":doreplace
	Case "del":delTextsegment
	Case "read":getTextsegment
	Case "save":saveTextsegment
	case else : main
End Select
viewFoot

Sub main
Dim txt,i,A:txt="":A=getTextsegments()
if isExistFile(RepWordFile) then
	txt=LoadFile(RepWordFile)
else
	txt="����=�в�"&vbcrlf&"��=�ݶ�"&vbcrlf&"����=����"
end if
%>
<div class="container" id="cpcontainer">
<form  method="post" action="?action=saverepword">
<table class="tb">
	<tr class="thead"><td colspan="2">αԭ��-ͬ��������滻(������ֻ�滻���ݽ���)</td></tr>
	<tr><td width="12%">�滻�ַ����ã�</td>
	<td width="88%"><textarea name="txt" style="width:500px;height:100px;">
<%=txt%></textarea></td></tr>
	<tr><td width="12%">������ʼID��</td><td width="88%"><input type="text" name="iStart" value="����" /> �� <input type="text" name="iEnd" value="����" /> <input type="submit" class="btn" value="ִ���ִ��滻" /></td></tr>
	<tr><td colspan="2">����˵����<br />&nbsp;&nbsp;1.ÿ��Ҫ�滻���ִ�ռһ��&nbsp;&nbsp;2.��ʽ��<font color="blue">Ҫ�滻=�滻��</font>,&nbsp;&nbsp;<font color="red">�����ı������ڵ��滻�ַ�Ϊ����,��ɾ����������Ҫ��������</font><br />&nbsp;&nbsp;2.�ɼ�����������̫ͬ�࣬���ױ�����������¼�������ñ����ܰ�һЩ�ض��Ĵ��滻���Լ��Ĵʣ����滻���Լ��ķ��Ի�ͬ��� <br />
	&nbsp;&nbsp;3.�ٸ����ӣ�<font color="blue">�㶫��(Ϊʲô=���)</font>&nbsp;&nbsp;<font color="blue">�㶫̨ɽ��(Ϊʲô=����)</font>,�����滻���������վӵ�ж��صķ��<br />ע������:<br>&nbsp;&nbsp;<font color=red>�����������滻���ַ��ͻ������滻�Ҳ��ɻָ�����С�Ĵ�����</font></td></tr>
</table>
</form>
<br />

<table class="tb">
	<tr class="thead"><td colspan="2">αԭ��-�������<a name="texts" /></td></tr>
	<%for i=0 to UBound(A)%>
		<tr><td width="90%"><%echo (i+1)&"."&left(A(i),60)&ifthen(len(A(i))>60,"...","")%></td><td><a href="?action=read&id=<%=(i+1)%>" target="hiddensubmit">�޸�</a> <a href="?action=del&id=<%=(i+1)%>">ɾ��</a></td></tr>
	<%next%>
<form method="post" action="?action=save" target="hiddensubmit">
<input type="hidden" name="id" value="" />
	<tr class="thead"><td colspan="2" id="newhit">����</td></tr>
	<tr><td colspan="2"><textarea name="newtxt" style="width:100%;height:100px;"></textarea><br /><input type="submit" class="btn" value="ȷ��" /> <input type="reset" class="btn" value="ȡ��" onclick="$('newhit').innerHTML='����';"/></td></tr>
	<tr><td colspan="2"><p>ע�⣺</p>
	  <p>1.�����¼�Ѿ��ǳ����ã�����ʹ�ñ�����<br>
	    2.��һ��������20������αԭ���ı���,������20��Ц������д��̫�������鲻����300�֣�ע����һ����������Ӧ��Ŀ��֮��Ҫ���������޸ġ�ɾ���ı���<br>
	      <font color="red">3</font><font color="red">.��ñ𾭳��Ķ��ı�������(���ӡ��޸Ļ�ɾ��)���������������ǳ����С����������ÿ������¼�����ݶ���һ������Ӱ����¼��Ȩ<br />
	        4.ÿ��������ϵͳ��������������뵽�����ײ���β�������м䣬���Ҳ����Ķ����ݿ⣬Ҳ����ÿ�ζ�����ı�</font></p></td></tr>
</form>
</table>
</div>
<iframe frameborder="0" scrolling="no" height="0" width="0" name="hiddensubmit" id="hiddensubmit" src="about:blank"></iframe>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='��̨��ҳ&nbsp;&raquo;&nbsp;<%=menuList(4,0)%>&nbsp;&raquo;&nbsp;αԭ������';</script>
<%End Sub

Sub saverepword()
	Dim WordText,iStart,iEnd,WHERE(),result:result=trim(getForm("result","get")):result=ifthen(result<>"",result,request.ServerVariables("HTTP_REFERER")):WordText=trim(getForm("txt","post")):iStart=Str2Num(getForm("iStart","post")):iEnd=Str2Num(getForm("iEnd","post"))
	dim i,j,P,A,Words():A = split(trim(WordText),vbcrlf)
	for i=0 to UBound(A)
		P = inStr(A(i),"=")
		if P > 0 then
			A(i) = Array(Mid(A(i),1,P-1),Mid(A(i),P+1))
			if A(i)(0)<>"" AND A(i)(0)<>A(i)(1) then
				Push Words,Join(A(i),"=")
			end if
		end if
	next
	CreateTextFile trim(Join(Words,vbcrlf)),RepWordFile,"gbk"
	echo "<script>location.href='?action=doReplace&iStart="&iStart&"&iEnd="&iEnd&"&result="&Server.URLEncode(result)&"';</script>"
End Sub

Sub doReplace
dim i,j,P,rCount,pCount,page,Text,sText,Words,WHERE,iStart,iEnd,result:result=trim(getForm("result","get")):result=ifthen(result<>"",result,request.ServerVariables("HTTP_REFERER"))
if isExistFile(RepWordFile) then
	Text=trim(LoadFile(RepWordFile))
	if Text<>"" then
		WHERE=array():Words=split(Text,vbcrlf):iStart=Str2Num(getForm("iStart","get")):iEnd=Str2Num(getForm("iEnd","get")):rCount=Str2Num(getForm("rCount","get")):pCount=Str2Num(getForm("pCount","get")):page=Cint(Str2Num(GetForm("page","get"))):page=Ifthen(page<1,1,page)
		if iStart>0 then:Push WHERE,"m_id>"&iStart-1:end if
		if iEnd>0 then:Push WHERE,"m_id<"&iEnd+1:end if
		WHERE=trim(Join(WHERE," AND "))
		Dim tRs:SET tRs=Conn.db("SELECT m_id,m_name,m_des FROM m_data"&ifthen(WHERE<>""," WHERE "&WHERE,""),"records3")
		tRs.PageSize=1000:rCount = ifthen(rCount>0,rCount,tRs.recordcount):pCount= ifthen(pCount>0,pCount,tRs.pagecount)
		if NOT tRs.EOF then:tRs.absolutepage = page:end if
		if NOT tRs.EOF then
			echo "<div class=""container"" id=""cpcontainer"">�����滻,��ǰ�ǵ�<font color='red'>"&page&"</font>ҳ,��<font color='red'>"&pCount&"</font>ҳ,��<font color='red'>"&rCount&"</font>������<hr style=""border:1px solid #DEEFFA""/>"
			for i=0 to tRs.PageSize
				Text=tRs("m_des"):sText=Text
				for j=0 to UBound(Words)
					P = inStr(Words(j),"=")
					if P > 0 then
						Text=ReplaceStr(Text,Mid(Words(j),1,P-1),Mid(Words(j),P+1))
					end if
				next
				if Text<>sText then
					echo "<font color=blue>�ɹ��滻 ID:"&tRs("m_id")&"	"&tRs("m_name")&"</font><br>"
					tRs("m_des")=Text:tRs.Update
				else
					echo "<font color=red>�����滻 ID:"&tRs("m_id")&"	"&tRs("m_name")&"</font><br>"
				end if
				tRs.Movenext
				if tRs.EOF then:exit for:end if
			next
			echo "<br>��ͣ3�������滻</div><script language=""javascript"">setTimeout(function (){location.href='?action="&action&"&page="&(Page+1)&"&pcount="&pCount&"&rcount="&rCount&"&iStart="&iStart&"&iEnd="&iEnd&"&result="&Server.URLEncode(result)&"';},3000);</script>"
		else
			alertMsg "�������",result
		end if
		tRs.Close:SET tRs=Nothing
	else
		alertMsg "�������",result
	end if
else
	alertMsg "�ļ�������: "&RepWordFile,result
end if
End Sub

Sub delTextsegment
	Dim i,l,id,ts,xmlstr,tmp:ts=getTextsegments():l=UBound(ts):id=Str2Num(getForm("id","get"))-1
	if id<=l AND l<>-1 AND id<>-1 then
		xmlstr="<?xml version=""1.0"" encoding=""gbk"" ?><root>%s</root>":tmp=""
		for i=0 to l
			if i<>id then:tmp=tmp&"<item><![CDATA["&ts(i)&"]]></item>":end if
		next
		xmlstr=Replace(xmlstr,"%s",tmp)
		CreateTextFile xmlstr,TextSegmentFile,"gbk"
	end if
	alertMsg "ɾ���ɹ�",getRefer()&"#texts"
End Sub

Sub getTextsegment()
	Dim i,id,ts:ts=getTextsegments():i=UBound(ts):id=Str2Num(getForm("id","get"))-1
	if id>i OR i=-1 OR id=-1 then
		alertMsg "��ȡ����ʧ��,���ݿ����ѱ�ɾ��,��ˢ��ҳ��",""
	else%>
<script language="javascript">
parent.$('newhit').innerHTML='�޸�';
parent.$('id').value='<%=id+1%>';
parent.$('newtxt').value='<%=replace(replace(replace(replace(ts(id),"\","\\"),"'","\'"),chr(13),""),chr(10),"\n")%>';
</script>
<%	end if
End Sub

Sub saveTextsegment()
	Dim i,l,id,ts,xmlstr,tmp,newtxt:ts=getTextsegments():l=UBound(ts):id=Str2Num(getForm("id","post"))-1:newtxt=getForm("newtxt","post")
	if newtxt="" then
		alertMsg "����������","":die ""
	elseif id>l AND l=-1 then
		alertMsg "�޸�ʧ��,��ЧID","":die ""
	elseif id>-1 then
		ts(id)=newtxt
	else
		push ts,newtxt
	end if
	xmlstr="<?xml version=""1.0"" encoding=""gbk"" ?><root>%s</root>":tmp=""
	for i=0 to UBound(ts)
		tmp=tmp&"<item><![CDATA["&ts(i)&"]]></item>"
	next
	xmlstr=replace(xmlstr,"%s",tmp)
	CreateTextFile xmlstr,TextSegmentFile,"gbk"
%>
<script language="javascript">
alert('����ɹ�');
parent.$('newhit').innerHTML='����';
parent.$('id').value='';
parent.$('newtxt').value='';
parent.location.href='<%=getRefer()%>?'+Math.random()+'#texts';
</script>
<%
End Sub

Sub Push(ByRef Arr,ByRef Val)
	on Error resume next
	Dim l:l=UBound(Arr)+1:l=ifthen(err,0,l):ReDim Preserve Arr(l)
	if isObject(Val) then:SET Arr(l)=Val:else:Arr(l)=Val:end if
End Sub

Function ifthen(ByVal B,ByVal aVal,ByVal bVal)
	if B=true then
		ifthen=aVal
	else
		ifthen=bVal
	end if
End Function

Dim gReg
Function trim(ByVal str)
	if NOT isObject(gReg) then:SET gReg=New RegExp:end if
	gReg.Pattern="(^\s*)|(\s*$)":gReg.Global=true:trim=gReg.replace(Str,"")
End Function

Function Str2Num(ByVal sNum):if not isNumeric(sNum) then:Str2Num=0:exit function:end if:dim x:x=CDBL(sNum):if InStr(" "&sNum,".")>0 OR (x<-2147483647 AND x>2147483647) then:Str2Num=CDbl(sNum):exit function:end if:if x>-32768 AND x<32768 then:Str2Num=CInt(sNum):else:Str2Num=CLng(sNum):end if:End Function
SET gReg=Nothing
%>