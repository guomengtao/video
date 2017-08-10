<!-- #include file="admin_inc.asp" -->
<%
'******************************************************************************************
' Software name: Max(马克斯) Gather EScript Engine
' Version:4.0
' Web: http://www.maxcms.net
' Author: 石头(maxcms2008@qq.com),yuet,长明
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************
viewHead "数据管理" & "-" & menuList(4,0)
'内容替换表
Const RepWordFile="imgs/repword.txt"
'伪原创,文本段
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
	txt="逮捕=拘捕"&vbcrlf&"恶毒=狠毒"&vbcrlf&"暗算=暗害"
end if
%>
<div class="container" id="cpcontainer">
<form  method="post" action="?action=saverepword">
<table class="tb">
	<tr class="thead"><td colspan="2">伪原创-同义词批量替换(本功能只替换数据介绍)</td></tr>
	<tr><td width="12%">替换字符设置：</td>
	<td width="88%"><textarea name="txt" style="width:500px;height:100px;">
<%=txt%></textarea></td></tr>
	<tr><td width="12%">数据起始ID：</td><td width="88%"><input type="text" name="iStart" value="不限" /> 到 <input type="text" name="iEnd" value="不限" /> <input type="submit" class="btn" value="执行字词替换" /></td></tr>
	<tr><td colspan="2">功能说明：<br />&nbsp;&nbsp;1.每个要替换的字词占一行&nbsp;&nbsp;2.格式：<font color="blue">要替换=替换后</font>,&nbsp;&nbsp;<font color="red">以上文本区域内的替换字符为范例,请删除并根据需要自行设置</font><br />&nbsp;&nbsp;2.采集来的内容雷同太多，不易被搜索引擎收录。可以用本功能把一些特定的词替换成自己的词，如替换成自己的方言或同义词 <br />
	&nbsp;&nbsp;3.举个例子：<font color="blue">广东话(为什么=点解)</font>&nbsp;&nbsp;<font color="blue">广东台山话(为什么=几解)</font>,经过替换，就让你的站拥有独特的风格。<br />注意事项:<br>&nbsp;&nbsp;<font color=red>程序遇到待替换的字符就会立即替换且不可恢复，请小心处理。</font></td></tr>
</table>
</form>
<br />

<table class="tb">
	<tr class="thead"><td colspan="2">伪原创-随机内容<a name="texts" /></td></tr>
	<%for i=0 to UBound(A)%>
		<tr><td width="90%"><%echo (i+1)&"."&left(A(i),60)&ifthen(len(A(i))>60,"...","")%></td><td><a href="?action=read&id=<%=(i+1)%>" target="hiddensubmit">修改</a> <a href="?action=del&id=<%=(i+1)%>">删除</a></td></tr>
	<%next%>
<form method="post" action="?action=save" target="hiddensubmit">
<input type="hidden" name="id" value="" />
	<tr class="thead"><td colspan="2" id="newhit">添加</td></tr>
	<tr><td colspan="2"><textarea name="newtxt" style="width:100%;height:100px;"></textarea><br /><input type="submit" class="btn" value="确定" /> <input type="reset" class="btn" value="取消" onclick="$('newhit').innerHTML='添加';"/></td></tr>
	<tr><td colspan="2"><p>注意：</p>
	  <p>1.如果收录已经非常良好，无需使用本功能<br>
	    2.请一次性添加20条以上伪原创文本段,可以是20段笑话。别写得太长，建议不超过300字，注意是一次性添加相应数目、之后不要再新增、修改、删除文本段<br>
	      <font color="red">3</font><font color="red">.最好别经常改动文本段设置(添加、修改或删除)。搜索引擎对这个非常敏感。如果它发现每次来收录的内容都不一样，会影响收录或降权<br />
	        4.每段内容由系统随机抽出并随机插入到简介的首部、尾部、或中间，而且并不改动数据库，也不会每次都随机改变</font></p></td></tr>
</form>
</table>
</div>
<iframe frameborder="0" scrolling="no" height="0" width="0" name="hiddensubmit" id="hiddensubmit" src="about:blank"></iframe>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(4,0)%>&nbsp;&raquo;&nbsp;伪原创工具';</script>
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
			echo "<div class=""container"" id=""cpcontainer"">正在替换,当前是第<font color='red'>"&page&"</font>页,共<font color='red'>"&pCount&"</font>页,共<font color='red'>"&rCount&"</font>部数据<hr style=""border:1px solid #DEEFFA""/>"
			for i=0 to tRs.PageSize
				Text=tRs("m_des"):sText=Text
				for j=0 to UBound(Words)
					P = inStr(Words(j),"=")
					if P > 0 then
						Text=ReplaceStr(Text,Mid(Words(j),1,P-1),Mid(Words(j),P+1))
					end if
				next
				if Text<>sText then
					echo "<font color=blue>成功替换 ID:"&tRs("m_id")&"	"&tRs("m_name")&"</font><br>"
					tRs("m_des")=Text:tRs.Update
				else
					echo "<font color=red>跳过替换 ID:"&tRs("m_id")&"	"&tRs("m_name")&"</font><br>"
				end if
				tRs.Movenext
				if tRs.EOF then:exit for:end if
			next
			echo "<br>暂停3秒后继续替换</div><script language=""javascript"">setTimeout(function (){location.href='?action="&action&"&page="&(Page+1)&"&pcount="&pCount&"&rcount="&rCount&"&iStart="&iStart&"&iEnd="&iEnd&"&result="&Server.URLEncode(result)&"';},3000);</script>"
		else
			alertMsg "操作完成",result
		end if
		tRs.Close:SET tRs=Nothing
	else
		alertMsg "操作完成",result
	end if
else
	alertMsg "文件不存在: "&RepWordFile,result
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
	alertMsg "删除成功",getRefer()&"#texts"
End Sub

Sub getTextsegment()
	Dim i,id,ts:ts=getTextsegments():i=UBound(ts):id=Str2Num(getForm("id","get"))-1
	if id>i OR i=-1 OR id=-1 then
		alertMsg "读取数据失败,内容可能已被删除,请刷新页面",""
	else%>
<script language="javascript">
parent.$('newhit').innerHTML='修改';
parent.$('id').value='<%=id+1%>';
parent.$('newtxt').value='<%=replace(replace(replace(replace(ts(id),"\","\\"),"'","\'"),chr(13),""),chr(10),"\n")%>';
</script>
<%	end if
End Sub

Sub saveTextsegment()
	Dim i,l,id,ts,xmlstr,tmp,newtxt:ts=getTextsegments():l=UBound(ts):id=Str2Num(getForm("id","post"))-1:newtxt=getForm("newtxt","post")
	if newtxt="" then
		alertMsg "请输入内容","":die ""
	elseif id>l AND l=-1 then
		alertMsg "修改失败,无效ID","":die ""
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
alert('保存成功');
parent.$('newhit').innerHTML='添加';
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