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
viewHead "扩展模块" & "-" & menuList(7,0)
dim action : action = getForm("action", "get")
Const slidePath="../pic/slide/"

Select Case action:
	Case "modifyside" : modifyside
	Case "addside":addside
	Case "delside":delside
	case "sidemoveup":sidemoveup
	case "sidemovedown":sidemovedown
	Case Else:main
End Select

Sub main
Dim i,A:A=getItems()
%>
<script type="text/javascript">
function upformone(i){
	$('id').value=i,$('item_url').value=$('item_url'+i).value,$('link').value=$('link'+i).value,$('title').value=$('title'+i).value,$('desc').value=$('desc'+i).value;
	$('form1').submit();
}
var _1;
function onUpClick(tg,el){
	_1=el;openWindow2(101,320,25,0);
	var msgDiv=$("msg");
	var _t = tg.offsetTop;
    var _l = tg.offsetLeft;
    while (tg = tg.offsetParent){_t+=tg.offsetTop; _l+=tg.offsetLeft;}
    msgDiv.style.cssText+="border:1px solid #55BBFF;background: #C1E7FF;padding:3px 0px 3px 4px;"
	msgDiv.style.top = (_t-1)+"px";
    msgDiv.style.left = (_l-1)+"px";
	msgDiv.innerHTML='<button type="button" class="btn" style="margin:0 6px 0 0;height:23px;float:right;padding:0;" onclick="closeWin()">关闭</button><iframe src="fckeditor/maxcms_upload.htm?isslide=1" scrolling="no" topmargin="0" width="270" height="25" marginwidth="0" marginheight="0" frameborder="0" align="center"></iframe>';
}

function onUploadBack(fn){
	if(!!_1) _1.value=fn;
	closeWin();
}
</script>
<div class="container" id="cpcontainer">
<table class="tb">
	<tr class="thead"><td colspan="6">幻灯片管理(<em style="color:red">幻灯图片请放在pic/slide目录下，只需将图片名填进来,不需要再填路径</em>)</td></tr>
	<tr>
		<td width="35">ID</td>
		<td width="205">图片</td>
		<td width="145">链接</td>
		<td width="100">标题</td>
		<td width="205">说明</td>
		<td>操作</td>
	</tr>
<form id="form1" name="form1" method="post" action="?action=modifyside" target="hiddensubmit">
<input type="hidden" name="id" id="id" value="" />
<input type="hidden" name="item_url" id="item_url" value="" />
<input type="hidden" name="link" id="link" value="" />
<input type="hidden" name="title" id="title" value="" />
<input type="hidden" name="desc" id="desc" value="" />
</form>
<form id="form2" name="form2" method="post" action="?action=modifyside&method=all">
	<%for i=0 to UBound(A,2)%>
	<tr>
		<td><input type="checkbox" value="<%=i%>" name="id" class="checkbox" /><%=i+1%></td>
		<td><input type="text" name="item_url<%=i%>" value="<%=A(0,i)%>" />&nbsp;<button type="button" class="btn" style="width:60px;height:22px;" onclick="onUpClick(this,this.form.elements['item_url<%=i%>'])">浏览...</button></td>
		<td><input type="text" name="link<%=i%>" value="<%=A(1,i)%>" /></td>
		<td><input type="text" name="title<%=i%>" value="<%=A(2,i)%>" style="width:100px"/></td>
		<td><input type="text" name="desc<%=i%>" value="<%=A(3,i)%>" style="width:200px"/></td>
		<td><a href="?action=sidemoveup&id=<%=i%>" target="hiddensubmit">上移</a> <a href="?action=sidemovedown&id=<%=i%>" target="hiddensubmit">下移</a> <a href="javascript://" onclick="upformone(<%=i%>)">修改</a> <a href="?action=delside&id=<%=i%>" onClick="return confirm('确定要删除吗')">删除</a></td>
	</tr>
	<%next%>
	<tr class="thead"><td colspan="6"><input type="checkbox" class="checkbox" id="chkall" onclick="checkAll(this.checked,'input','id')"/>全选 <input type="submit" name="submit" value="修改选中项" class="btn" /></td></tr>
</form>
<form id="form3" name="form3" method="post" action="?action=addside">
	<tr>
		<td>新增</td>
		<td><input type="text" name="item_url" value="" />&nbsp;<button type="button" class="btn" style="width:60px;height:22px;" onclick="onUpClick(this,this.form.elements['item_url'])">浏览...</button></td>
		<td><input type="text" name="link" value="" /></td>
		<td><input type="text" name="title" value="" style="width:100px"/></td>
		<td><input type="text" name="desc" value="" style="width:200px"/></td>
		<td><input type="submit" name="submit" value="确定" class="btn" /></td>
	</tr>
</form>
</table>
</div>
<iframe frameborder="0" scrolling="no" height="0" width="0" name="hiddensubmit" id="hiddensubmit" src="about:blank"></iframe>
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(7,0)%>&nbsp;&raquo;&nbsp;扩展模块';</script>
<%End Sub

Sub Push(ByRef Arr,ByRef Val)
	on Error resume next
	Dim l:l=UBound(Arr)+1:l=ifthen(err,0,l):ReDim Preserve Arr(l)
	if isObject(Val) then:SET Arr(l)=Val:else:Arr(l)=Val:end if
End Sub

Function enSpecial(Str)
	enSpecial=ReplaceStr(Str,"&","&amp;")
End Function

Function unSpecial(Str)
	unSpecial=ReplaceStr(Str,"&amp;","&")
End Function

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

Function getItems()
	Dim l,xmlobj,Nodes,Node:SET xmlobj=mainClassobj.createObject("MainClass.Xml")
	ReDim ret(3,-1):l=0
	xmlobj.load slidePath&"slide.xml","xmlfile"
	SET Nodes=xmlobj.getNodes("bcaster/item")
	for each Node in Nodes
		ReDim Preserve ret(3,l)
		ret(0,l)=unSpecial(xmlobj.getAttributesByNode(Node,"item_url"))
		ret(1,l)=unSpecial(xmlobj.getAttributesByNode(Node,"link"))
		ret(2,l)=unSpecial(xmlobj.getAttributesByNode(Node,"title"))
		ret(3,l)=unSpecial(xmlobj.getAttributesByNode(Node,"desc"))
		l=l+1
	next
	set xmlobj = nothing:getItems=ret
End Function

Sub sideMoveUp
	dim id,A,al,x,y:id=Clng(getForm("id","both")):A=getItems():al=UBound(A,2):y=id-1
	if id>0 AND al>0 then
		x=A(0,id):A(0,id)=A(0,y):A(0,y)=x
		x=A(1,id):A(1,id)=A(1,y):A(1,y)=x
		x=A(2,id):A(2,id)=A(2,y):A(2,y)=x
		x=A(3,id):A(3,id)=A(3,y):A(3,y)=x
		echo "<script>parent.location.reload();</script>"
		Save2xmlFile(A)
	end if
End Sub

Sub sideMoveDown
	dim id,A,al,x,y:id=Clng(getForm("id","both")):A=getItems():al=UBound(A,2):y=id+1
	if id<al AND al>0 then
		x=A(0,id):A(0,id)=A(0,y):A(0,y)=x
		x=A(1,id):A(1,id)=A(1,y):A(1,y)=x
		x=A(2,id):A(2,id)=A(2,y):A(2,y)=x
		x=A(3,id):A(3,id)=A(3,y):A(3,y)=x
		echo "<script>parent.location.reload();</script>"
		Save2xmlFile(A)
	end if
End Sub

Sub modifyside
	dim method,i,A,back,t:method=getForm("method","both"):back = request.ServerVariables("HTTP_REFERER")
	dim ids,il:ids=Split(Replace(getForm("id","post")," ",""),","):il=Ubound(ids)
	if il<>-1 then
		A=getItems()
		if method="all" then
			for i=0 to il
				if isNumeric(ids(i)) then
					t=trim(getForm("item_url"&ids(i),"post"))
					if A(0,ids(i))<>t then
						delSidePic(A(0,ids(i)))
					end if
					A(0,ids(i))=t
					A(1,ids(i))=getForm("link"&ids(i),"post")
					A(2,ids(i))=getForm("title"&ids(i),"post")
					A(3,ids(i))=getForm("desc"&ids(i),"post")
				end if
			next
			alertMsg "修改成功",back
		else
			ids=Join(ids,"")
			if isNumeric(ids) then
					t=trim(getForm("item_url","post"))
					if A(0,ids)<>t then
						delSidePic(A(0,ids))
					end if
					A(0,ids)=t
					A(1,ids)=getForm("link","post")
					A(2,ids)=getForm("title","post")
					A(3,ids)=getForm("desc","post")
			end if
			echo "<script>alert('修改成功');parent.location.reload();</script>"
		end if
		Save2xmlFile(A)
	else
		alertMsg "没选择要修改的项目","javascript:history.go(-1);"
	end if
End Sub

Sub delside
	Dim A,nA,id,i,il,l:A=getItems():id=Clng(getForm("id","both")):il=UBound(A,2)
	if id>-1 AND id<=il then
		ReDim nA(3,-1):l=0
		for i=0 to il
			if i<>id then
				ReDim Preserve nA(3,l)
				nA(0,l)=A(0,i)
				nA(1,l)=A(1,i)
				nA(2,l)=A(2,i)
				nA(3,l)=A(3,i)
				l=l+1
			else
				delSidePic(A(0,i))
			end if
		next
		Save2xmlFile(nA)
	end if
	alertMsg "删除成功",getRefer
End Sub

Sub delSidePic(ByVal fn)
	fn=trim(fn):if fn="" then exit sub
	if isExistFile(slidePath&fn) then
		delFile(slidePath&fn)
	end if
End Sub

Sub addside
	Dim A,il:A=getItems():il=UBound(A,2)+1
	ReDim Preserve A(3,il)
	A(0,il)=getForm("item_url","post")
	A(1,il)=getForm("link","post")
	A(2,il)=getForm("title","post")
	A(3,il)=getForm("desc","post")
	Save2xmlFile(A)
End Sub

Sub Save2xmlFile(ByVal aArg)
	dim i,xml:xml="<?xml version=""1.0"" encoding=""utf-8"" ?>"&vbcrlf&"<bcaster>"&vbcrlf&_
	"<!--注意："&vbcrlf&_
	"1.幻灯片图片位于目录/pic/slide/下面"&vbcrlf&_
	"2.幻灯片标签调用方式：例如{maxcms:slide width=500 height=260}"&vbcrlf&_
	"-->"&vbcrlf
	for i=0 to Ubound(aArg,2)
		xml=xml&"	<item item_url="""&enSpecial(aArg(0,i))&""" link="""&enSpecial(aArg(1,i))&""" title="""&enSpecial(aArg(2,i))&""" desc="""&enSpecial(aArg(3,i))&""" />"&vbcrlf
	next
	xml=xml&"</bcaster>"
	CreateTextFile xml,slidePath&"slide.xml","utf-8"
	alertMsg "操作成功","admin_expand.asp"
End Sub
%>