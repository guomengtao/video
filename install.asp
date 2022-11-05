<!-- #include file="inc/MainClass.asp" -->
<!--#include file="inc/pinyin.asp"-->
<% die "��ͣ��װ<br>(*^__^*) �������Ѿ���װ���ˣ�����Ҫ�ٴΰ�װ����ɾ�����ļ��ĵ����д��뼴��" '******************************************************************************************
' Software name: Max(����˹) Content Management System ' Version:4.0
' Web: http://www.maxcms.net ' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ���� ' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
' ****************************************************************************************** Const
	CONFIGPATH="inc/config.asp" Const INDEXPATH="index.asp" Const INSTALLPATH="install.asp" Const
	PLAYERJSPATH="js/play.js" Dim ac,go:ac=getForm("action","both"):go=getForm("go","both") Dim
	gConn,gCols(1),timeStr:timeStr=ifthen(databaseType=0,"now()","getdate()") Select Case ac Case "one" :One Case "two"
	:two Case "three" :three Case "four" :four Case else:Main End Select if isObject(gConn) then Set gConn=nothing Sub
	Head(title,tips,step) Dim cur(4):cur(step)=" class=""cur""" %>
	<!DOCTYPE html
		PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
		<title>վ�㰲װ - <%=title%>
		</title>
		<meta name="robots" content="nofollow" />
		<meta name="googlebot" content="nofollow" />
		<style type="text/css">
			body {
				text-align: center
			}

			p {
				padding: 3px 0;
				margin: 0
			}

			hr,
			h3 {
				border-bottom: 1px solid #C4E1FF;
				color: #333;
				margin-top: 0
			}

			hr {
				height: 1px
			}

			h3 {
				font-size: 18px;
				font-family: "����";
				font-weight: 300;
				text-indent: 25px
			}

			label {
				display: inline-block
			}

			input {
				border-width: 0
			}

			.inpt {
				border: 1px solid #CCC;
				height: 18px;
				line-height: 15px;
				width: 200px;
				background: #F9F9F9 none
			}

			textarea {
				border: 1px solid;
				border-color: #666 #ccc #ccc #666;
				background: #F9F9F9;
				color: #333;
				padding: 5px 1px
			}

			#installbox {
				background-color: white;
				border: 1px solid #1B76B7;
				margin: 0 auto;
				width: 600px;
				text-align: left;
				margin-top: 2em
			}

			.msgtitle {
				padding: 3px 3px;
				color: white;
				font-weight: 700;
				line-height: 21px;
				height: 25px;
				font-size: 12px;
				border-bottom: 1px solid #1B76B7;
				text-indent: 3px;
				background-color: #1B76B7
			}

			#msgbody {
				font-size: 12px;
				line-height: 25px;
				padding-top: 1em;
			}

			#msgbottom {
				text-align: center;
				height: 20px;
				line-height: 20px;
				font-size: 12px;
				background-color: #1b76b7;
				color: #FFF
			}

			.btn {
				margin: 3px 0;
				padding: 2px 5px;
				*padding: 4px 5px 1px;
				border: 1px solid;
				border-color: #ddd #666 #666 #ddd;
				background: #DDD;
				color: #000;
				cursor: pointer;
				vertical-align: middle
			}

			.step {
				width: 592px;
				margin: 2px auto
			}

			.step span {
				display: inline-block;
				background-color: #eee;
				width: 146px;
				border: solid 1px #fff;
				font-size: 12px;
				text-align: center
			}

			.step span b {
				font-size: 18px
			}

			.step span.cur {
				background-color: #62C0FF;
				width: 146px;
				color: #fff
			}

			.ac {
				text-align: center
			}

			.blue {
				color: blue
			}

			.fl {
				float: left
			}

			.fr {
				float: right
			}

			.clear {
				clear: both
			}

			.hide {
				display: none
			}
		</style>
		<script type="text/javascript">
			var $ = function (id) { return document.getElementById(id) }
		</script>
	</head>

	<body>
		<div id='installbox'>
			<div class='msgtitle'>Maxcms5.2��װ�� &gt;&gt; <%=title%>
			</div>
			<div class="step">
				<% echo "<span" &cur(1)&"><b>1.</b>��������</span>
					<span"&cur(2)&"><b>2.</b>���ݿ�����</span>
						<span"&cur(3)&"><b>3.</b>���ݿ�����</span>
							<span"&cur(4)&"><b>4.</b>��ɰ�װ</span>"
								%>
			</div>
			<div id='msgbody'>
				<h3 style="clear:both;">
					<%=tips%>
				</h3>
				<% End Sub Sub Foot %>
			</div>
			<div id='msgbottom'>Powered By<%=siteName%>
			</div>
		</div>
	</body>

	</html>
	<% End Sub Sub Main() Head "����Э��" ,"����˹CMSʹ������Э��",0 %>
		<div class="ac"><textarea style="width:560px;border:4px solid #C8E9FF;font-size:12px;" rows="15" readonly>
&nbsp;&nbsp;&nbsp;&nbsp;����ʹ�ñ�����ǰ������ϸ�Ķ�������Ϣ������Э������ȷ�����û���Ȩ��������Ȩ�����������������ͬ����������ʹ������Э�飬����Ӧע��/���ر���������ֹͣʹ�ã�����������ĵ�����ɾ����

&nbsp;&nbsp;&nbsp;&nbsp;��Э�����Ե�ǰ�汾��MaxCMS��V5.1������Ч�����������л����񹲺͹�������Ȩ������������Ȩ��Լ������֪ʶ��Ȩ������Լ�ı�����������֪ʶ��Ȩ��MAXCMS���С�

&nbsp;&nbsp;&nbsp;&nbsp;��������Ʒ�������������ڱ�������Ʒ���������κ�ͼ����Ƭ��������¼��¼�������֡����ֺ͸��ӳ���(dll��exe��)�����渽�İ������ϡ�����������Ʒ���κθ�����һ������Ȩ��֪ʶ��Ȩ������MAXCMSӵ�С��û����õ������ƺ��޸���Щ���ϡ� 

&nbsp;&nbsp;&nbsp;&nbsp;�û����öԱ�������Ʒ���з��򹤳̣�reverse engineer����������루decompile���򷴻�ࣨdisassemble����Υ��������Ȩ��Ϊ�������ге��ɴ˲����Ĳ�������� 

&nbsp;&nbsp;&nbsp;&nbsp;��������ƷΪ����������û����Է���ҵ�Ե����ء���װ�����ƺ�ɢ����������Ʒ���������������ڴ���Υ���й����񹲺͹���ط�������ֹ�Ļ��MAXCMS�����û�����ʹ�ñ���������Υ������е��κ����Σ��������������������Ρ��������Ρ��������Σ��������Ҫ������ҵ�Ե����ۡ����ƺ�ɢ������������Ԥװ�����󣬱�����MAXCMS����Ȩ�����ɡ� 

&nbsp;&nbsp;&nbsp;&nbsp;�����û��������Ӳ�������Ĳ����Ժ͸����ԣ����������ṩ�ĸ���ܲ����ܱ�֤���κ�����¶�������ִ�л�ﵽ�û��������Ľ�����û�ʹ�ñ�������������һ�к����MAXCMS���е��κ����Ρ� 

&nbsp;&nbsp;&nbsp;&nbsp;�����������Զ��������ܣ��Ա㼰ʱΪ�û��ṩ�¹��ܺ����������е�BUG��ͬʱMAXCMS��֤������������ģ���в������κ�ּ���ƻ��û�����������ݺͻ�ȡ�û���˽��Ϣ�Ķ�����룬�������κθ��١������û�������ͻ������Ϊ�Ĺ��ܴ��룬�������û����ϡ����µ���Ϊ��й©�û���˽�� 

&nbsp;&nbsp;&nbsp;&nbsp;������Ϊ��Ѳ�Ʒ��MAXCMSΪ��������Ʒ�ṩEmail/Web����ʽ�Ĳ�Ʒ֧�֡� 

&nbsp;&nbsp;&nbsp;&nbsp;������������ϸ�Ĳ��ԣ������ܱ�֤�����е���Ӳ��ϵͳ��ȫ���ݡ�������ֲ����ݵ�������û���ͨ�������ʼ����������MAXCMS����ü���֧�֡�����޷�������������⣬�û�����ж�ر�����������������������������ȱ���⣬MAXCMS���κ�������ԭ����ʹ�ñ�����ʱ���ܶ��û���ɵ��𺦲������Σ���Щ�𺦿������������û���װʹ�õ����������ĳ�ͻ�������ڲ���ʹ�ñ���Ʒ����ɵ��𺦣��������������ڣ�ֱ�ӻ��ӵĸ����𺦡���ҵӮ����ɥʧ��ó���жϡ���ҵ��Ϣ�Ķ�ʧ���κ�������Ǯ��ʧ�����۷������������ 

&nbsp;&nbsp;&nbsp;&nbsp;���ڱ�������Ʒ����ͨ�������;�����ء����������ڴӷ�MAXCMSָ��վ�����صı�������Ʒ�Լ��ӷ�MAXCMS���еĽ����ϻ�õı�������Ʒ��MAXCMS�޷���֤�������Ƿ��Ⱦ������������Ƿ�������αװ��������ľ��������ߺڿ����������е��ɴ������ֱ�Ӻͼ�������Ρ� 

&nbsp;&nbsp;&nbsp;&nbsp;����û��ڰ�װ��ʾ�����ʱ������ǡ����������û�����MAXCMS����Ըѡ��װ�������������ܱ�Э�������������û������ܱ�Э�飬��Ը��װ����������������
</textarea>
			<p><input type="checkbox" id="compact" onClick="$('xy').disabled=this.checked ? '' : 'disabled';"><label
					for="compact">��������Э��</label></p>
			<p><input id="xy" type="submit" class="btn" style=" width:120px;height:30px;"
					onclick="if($('compact').checked) location.href='?action=one';" value="��ʼ��װ" disabled="disabled">
			</p>
		</div>
		<% Foot End Sub Sub One() Head "��������" ,"������Ϣ",1 if writeRole=false then
			alertMsg "����ǰ����վû��дȨ�޲�����ɰ�װ�����޸�Ȩ��" ,"":exit sub if go="save" then dim
			rg,text:sitename=getForm("sitename","post"):siteurl=getForm("siteurl","post"):sitepath=getForm("sitepath","post")
			Set rg=mainClassObj.createObject("MainClass.template"):text=loadFile(CONFIGPATH)
			text=rg.regExpReplace(text,"sitePath="" (\S*?)""","sitePath="""&sitepath&"""")
	text=rg.regExpReplace(text," siteName="" .*""","siteName="""&siteName&"""")
	text=rg.regExpReplace(text," siteUrl="" .*""","siteUrl="""&siteUrl&"""")
	Set rg=nothing
	if InstallCreateTextFile(text,CONFIGPATH,"") then alertMsg ""," ?action=two" else dim
			x:x=Request.ServerVariables("path_info"):x=split(x,"install.asp")(0):x=mid(x,2,len(x)-1)
			sitePath=x:siteUrl=Request.ServerVariables("HTTP_HOST") %>
			<div style="width:560px;margin:0 auto">
				<form action="?action=<%=ac%>&go=save" method="post" enctype="application/x-www-form-urlencoded">
					<input class="inpt" type="hidden" name="sitepath" value="<%=sitePath%>" />
					<p>��վ���ƣ�<input type="text" class="inpt" name="sitename" value="<%=siteName%>" /></p>
					<p>��վ��ַ��<input type="text" class="inpt" name="siteurl" value="<%=siteUrl%>" /> <span
							class="blue">(�Զ���ȡ,����������޸�)</span></p>
					<p class="blue"><br />ע�⣺��װMaxcms5.2����Ҫ����վĿ¼�����޸ġ�д��Ȩ�ޡ�</p>
					<p><input type="button" class="btn fl" value="&lt;&lt;��һ��"
							onclick="location.href='?action=main';" /><input type="submit" class="btn fr"
							value="��һ��&gt;&gt;" /></p>
					<div class="clear"><br /></div>
				</form>
			</div>
			<% end if Foot End Sub Sub two() Head "���ݿ�����" ,"���ݿ���������",2 if go="save" then DataBase else Dim
				x(1),y(1),z:x(databaseType)=" selected" :y(databaseType)=" class=""hide""" if not
				isExistFile(accessFilePath) then z=split(accessFilePath,"/") if ubound(z)>2 then
				z(1)=sitepath
				else
				z(0)="/"&sitepath
				end if
				accessFilePath=replace(join(z,"/"),"//","/")
				end if
				%>
				<div style="width:560px;margin:0 auto">
					<form action="?action=<%=ac%>&go=save" method="post" enctype="application/x-www-form-urlencoded">
						<p>���ݿ����ͣ�<select name="databasetype" onchange="toogle()">
								<% echo "<option value=""0""" &x(0)&">Access</option>"
									echo "<option value="" 1"""&x(1)&">MS-SqlServer</option>"
									%>
							</select></p>
						<div id="acc">
							<p>ACCESS·����<input type="text" class="inpt" name="accessfilepath"
									value="<%=accessfilepath%>" /></p>
							<p><span class="blue">1.����װ�ڸ�Ŀ¼�£� /inc/datas.asp</span></p>
							<p><span class="blue">2.����Ŀ¼�£� /����Ŀ¼��/inc/datas.asp</span></p>
						</div>
						<div id="sql">
							<p>���������ƣ�<input class="inpt" type="text" name="databaseserver"
									value="<%=databaseServer%>" />
								<font color=red>*</font>SQL������IP��ַ������
							</p>
							<p>���ݿ����ƣ�<input class="inpt" type="text" name="databasename"
									value="<%=databaseName%>" /></p>
							<p>���ݱ��û���<input class="inpt" type="text" name="tableuser" value="<%=tableuser%>" />
								�ɲ���,ֻ��Ǩ������ʱ��ԭ���ݵı��Ŵ��б��û�</p>
							<p>���ݿ��ʺţ�<input class="inpt" type="text" name="databaseuser" value="<%=databaseUser%>" />
							</p>
							<p>���ݿ����룺<input class="inpt" type="text" name="databasepwd" value="<%=databasePwd%>" />
							</p>
							<p><span class="blue">(���ֽ���ʹ��ACCESS���ݿ⣻SqlServer�ʺ���һ��������վ��)</span></p>
						</div>
						<p><input type="button" class="btn fl" value="&lt;&lt;��һ��"
								onclick="location.href='?action=one';" /><input type="submit" class="btn fr"
								value="��һ��&gt;&gt;" /></p>
						<div class="clear"><br /></div>
					</form>
				</div>
				<script type="text/javascript">
					function toogle() {
						var x = document.getElementsByName('databasetype')[0], id = ['acc', 'sql'];
						for (var i = 0; i < id.length; i++) {
							$(id[i]).style.display = i != x.selectedIndex ? 'none' : '';
						}
					}
					toogle();
				</script>
				<% end if Foot End Sub Sub three() Dim i:Head "У�����ݿ�" ,"���ݿ�����",3
					echo "<div style=""width:560px;margin:0 auto""><textarea style=""width:552px;border:4px solid #C8E9FF;font-size:12px;"" rows=""15"" readonly>" 'on error resume next:err.clear
if not isNumeric(go) then
	for i=0 to 2
		Select Case i
			Case 0:CreateTable
			Case 1:CreateField
			Case 2:CreateIndexs
			Case else:exit for
		End Select
		if err then echo "����" & err.description:exit for
	next
end if
if go<>"0" then DoUPDATA

echo "</textarea><p><input type=""button"" class=""btn fl"" value=""&lt;&lt;��һ��"" onclick=""location.href='
					?action=two';"" /><input type="" button"" class="" btn fr"" value="" ��һ��&gt;&gt;""
					onclick="""&ifthen(err.number<>0," alert('�������ݿ�����з��ִ�������');","location.href='?action=four'
					;")&""" /></p>
				<div class="" clear""><br /></div>
				</div>"
				if go<>"0" then echo "
					<script type=""
						text/javascript"">window.setTimeout(function (){location.href='?action=three&go="&go&"'},1000);</script>
					"
					Foot
					End Sub

					Sub four()
					dim rs:Head "��ɰ�װ","��ɰ�װ",4
					if go="save" then
					Dim
					un,p1,p2,sitemode,playermode,text,rg:un=getForm("un","post"):p1=getForm("pw1","post"):p2=getForm("pw2","post"):sitemode=getForm("sitemode","post"):playermode=getForm("playermode","post")
					if isNul(sitemode) or isNul(playermode) then alertMsg "��ѡ����վģʽ�Ͳ���ģʽ","":last:die ""
					if isNul(un) then alertMsg "�����˺Ų���Ϊ��","":last:die ""
					if isNul(p1) then alertMsg "�������벻��Ϊ��","":last:die ""
					if p1<>p2 then alertMsg "�����������벻һ��","":last:die ""
						set rs=conn.db("SELECT * FROM m_manager WHERE m_username='"&un&"'","records3")
						if rs.eof then
						rs.addnew
						rs("m_username")=un:rs("m_level")=0:rs("m_state")=1
						end if
						rs("m_pwd")=md5(p1,32)
						rs.update
						rs.close:set rs=nothing
						Set rg = mainClassObj.createObject("MainClass.template")
						text=loadFile(CONFIGPATH)
						text=rg.regExpReplace(text,"runMode=""(\S+?)"""&vbcrlf,"runMode="""&sitemode&""""&vbcrlf)
						text=rg.regExpReplace(text,"gbookPwd=""(\S+?)"""&vbcrlf,"gbookPwd="""&replaceStr(p1,"""","")&""""&vbcrlf)
						InstallCreateTextFile text,CONFIGPATH,""

						text=loadFile(PLAYERJSPATH)
						text=rg.regExpReplace(text,"var\sautoPlay=""\d+"";","var autoPlay="""&playermode&""";")
						InstallCreateTextFile text,PLAYERJSPATH,""

						text=loadFile(INDEXPATH)
						text=rg.regExpReplace(text,"<"&"%"&vbcrlf&"alertMsg ""
							���Ȱ�װ����������ת����װ�ļ�""\,""install\.asp""","<"&"%") InstallCreateTextFile
							text,INDEXPATH,"" text=loadFile(INSTALLPATH) text=rg.regExpReplace(text,"-->"&vbcrlf&"
							<"&"%"&vbcrlf,"-->"&vbcrlf&"<"&"%"&vbcrlf&"die "" ��ͣ��װ<br>(*^__^*)
									�������Ѿ���װ���ˣ�����Ҫ�ٴΰ�װ����ɾ�����ļ��ĵ����д��뼴��"""&vbcrlf)
									InstallCreateTextFile text,INSTALLPATH,""
									set rg=nothing
									echo "<div style="" width:300px;height:50px;margin:50px auto"">
										<p><input type="" button"" class="" btn"" style="" width:120px;height:30px;""
												value="" ������վ��ҳ"" onclick="" javascript:location.href='index.asp'
												;"" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="" button""
												class="" btn"" style="" width:120px;height:30px;"" value="" ��½��վ��̨""
												onclick="" javascript:location.href='admin/index.asp' ;"" /></p>
										<br /><br />
									</div>"
									else
									set rs = conn.db("SELECT * FROM m_manager","records1")
									%>
									<div style="width:560px;margin:0 auto">
										<form action="?action=<%=ac%>&go=save" id="form1" method="post"
											enctype="application/x-www-form-urlencoded">
											<p>��վģʽ��<input type="radio" name="sitemode" id="sitemode0" value="dynamic"
													checked /><label for="sitemode0">��̬ģʽ</label> <input type="radio"
													name="sitemode" id="sitemode1" value="static" /><label
													for="sitemode1">��̬ģʽ</label> ��<font color="blue">
													��ϸ�������½ϵͳ��̨վ������</font>��</p>
											<p>����ģʽ��<input type="radio" name="playermode" id="m0" value="1" /><label
													for="m0">վ�ڲ�����(<font color="blue">���Զ����ţ�������</font>
													)</label> <input type="radio" name="playermode" id="m1"
													value="0" /><label for="m1">վ�ⲥ����(<font color="blue">ָ��Ƶվ�ṩ���õ�ַ
													</font>)</label></p>
											<p>1.���ಥ��������������վ��̨��<font color="red">"����������"</font>���޸�</p>
											<hr />
											<% if not rs.eof then echo "<p>ѡ������˺ţ�<select name=""un"" id=""un"">" do
												while(not rs.eof) echo "<option value=""" &rs("m_username")&""">
												"&rs("m_username")&"</option>"
												rs.movenext
												loop
												echo "</select></p>"
												else
												echo "<p>���ù����˺ţ�<input class="" inpt"" type="" text"" name="" un""
														id="" un"" value="""" /></p>"
												end if
												rs.close:set rs=nothing
												%>
												<p>���ù������룺<input class="inpt" type="password" name="pw1" id="pw1"
														value="" /></p>
												<p>ȷ�Ϲ������룺<input class="inpt" type="password" name="pw2" id="pw2"
														value="" /></p>
												<p><input type="button" class="btn fl" value="&lt;&lt;��һ��"
														onclick="location.href='?action=three';" /><input type="button"
														class="btn fr" value="��ɰ�װ" onclick="chform()" /></p>
												<div class="clear"><br /></div>
										</form>
									</div>
									<script type="text/javascript">
										function chform() {
											var un = $('un'), val = un.nodeName.toUpperCase() == 'SELECT' ? un.options[un.selectedIndex].value : un.value, p1 = $('pw1').value, p2 = $('pw2').value;
											if (!$('m0').checked && !$('m1').checked) {
												$('m1').parentNode.style.backgroundColor = '#eee';
												alert('��ѡ�񲥷�ģʽ');
											} else if (val.replace(/(^\s*)|(\s*$)/ig, '') == '') {
												alert('�����˺Ų���Ϊ��');
											} else if (p1 == '') {
												alert('�������벻��Ϊ��');
											} else if (p1 != p2) {
												alert('�����������벻һ��');
											} else {
												$('form1').submit();
											}
										}
									</script>
									<% end if Foot End Sub Sub DataBase Dim
										dt,ap,ip,db,tu,du,dp:dt=getForm("databasetype","post"):ap=getForm("accessfilepath","post"):ip=getForm("databaseserver","post"):db=getForm("databasename","post"):tu=getForm("tableuser","post"):du=getForm("databaseuser","post"):dp=getForm("databasepwd","post")
										Dim rg,text:databaseType=Cint(dt) Select Case databaseType Case 0: if isNul(ap)
										then alertMsg "Access���ݿ��ַ����Ϊ��" ,"":last:exit sub if not
										isExistFile(accessFilePath) then accessFilePath=ap if accessFilePath<>ap then
										if isExistFile(accessFilePath) AND not isExistFile(ap) then moveFile
										accessFilePath,ap,"del"
										accessFilePath=ap
										end if
										if not isExistFile(accessFilePath) then CreateDataBase
										Set rg =
										mainClassObj.createObject("MainClass.template"):text=loadFile(CONFIGPATH)
										text=rg.regExpReplace(text,"databaseType=(\S*\d?)","databaseType="&dt&"")
										text=rg.regExpReplace(text,"accessFilePath=""\S*""","accessFilePath="""&
										accessFilePath &"""")
										Set rg=nothing
										if InstallCreateTextFile(text,CONFIGPATH,"") then alertMsg "","?action=three"
										Case 1:
										if isNul(ip) then alertMsg "SQL��������ַ����Ϊ��","":last:exit sub
										if isNul(db) then alertMsg "SQL���ݿ�������Ϊ��","":last:exit sub
										if isNul(du) then alertMsg "SQL���ݿ��û�������Ϊ��","":last:exit sub
										on error resume next
										Dim CC,e:Set CC=Server.CreateObject(CONN_OBJ_NAME)
										CC.ConnectionTimeout=3:CC.open "Provider=Sqloledb;Data Source="&ip&";Initial
										Catalog="&db&";User ID="&du&";Password="&dp&";"
										if CC.Errors.count>0 then
										e=CC.Errors(0).NativeError:CC.close:Set CC = nothing
										Select Case e
										Case "17":alertMsg "���������ƴ���","":last
										Case "4060":databaseServer=ip:databaseName=db:databaseUser=du:databasePwd=dp:on
										error goto 0:CreateDataBase 'alertMsg "���ݿ����ƴ���",""
										Case "18456":alertMsg "���ݿ��ʺŻ��������","":last
										Case else:alertMsg "SQL ���ݿ����ô���","":last
										End Select
										else
										CC.close:Set CC = nothing
										end if
										Set rg =
										mainClassObj.createObject("MainClass.template"):text=loadFile(CONFIGPATH)
										text=rg.regExpReplace(text,"databaseType=(\S*\d?)","databaseType="&dt&"")
										text=rg.regExpReplace(text,"databaseServer=""\S*""","databaseServer="""& ip
										&"""")
										text=rg.regExpReplace(text,"databaseName=""\S*""","databaseName="""& db &"""")
										text=rg.regExpReplace(text,"tableUser=""\S*""","tableUser="""& tu &"""")
										text=rg.regExpReplace(text,"databaseUser=""\S*""","databaseUser="""& du &"""")
										text=rg.regExpReplace(text,"databasePwd=""\S*""","databasePwd="""& dp &"""")
										Set rg=nothing
										if InstallCreateTextFile(text,CONFIGPATH,"") then alertMsg "","?action=three"
										End Select
										End Sub

										Function InstallCreateTextFile(Byval content,Byval fileDir,Byval code)
										dim errid,errdes,fileobj,fileCode : fileDir=replace(fileDir, "\", "/")
										if isNul(code) then fileCode="gbk" else fileCode=code
										call createfolder(fileDir,"filedir")
										on error resume next:err.clear
										set fileobj=objFso.CreateTextFile(server.mappath(fileDir),True)
										if IsObject(fileobj) then fileobj.Write(content):set fileobj=nothing
										if err or not isNul(code) then
										errid=err.number:errdes=err.description:err.clear
										With objStream
										.Charset=fileCode:.Type=2:.Mode=3:.Open:.Position=0
										.WriteText content:.SaveToFile Server.MapPath(fileDir), 2
										.Close
										End With
										end if
										if err Then
										dim h:h=LCase(Hex(err.number)):InstallCreateTextFile=false
										echo "<font face="" ����"" size=2>"&vbcrlf&_
											"<p>Microsoft VBScript ����ʱ����</font>
										<font face="" ����"" size=2>���� '800a"&Left("0000",4-Len(h))&h&"'</font>
										"&vbcrlf&_
										"<p>"&vbcrlf&_
											"<font face="" ����"" size=2>FSO:"&errid&" "&errdes&"</font>"&vbcrlf&_
											"
										<p>"&vbcrlf&_
											"<font face="" ����"" size=2>STM:"&err.number&" "&err.description&"</font>
											"&vbcrlf&_
											"
										<p>"&vbcrlf&_
											"<font face="" ����"" size=2>�������:
												���inc/config.asp�ļ����ԣ�����Ϊֻ������������վĿ¼��д��Ȩ��</font>"&vbcrlf
											else
											InstallCreateTextFile=true
											end if
											err.clear
											End Function

											'-----------------------------------------
											'�������ݿ���躯��
											'-----------------------------------------

											Function getConn()
											if Not isObject(gConn) then
											Dim connStr
											if databaseType=1 then
											connStr="Provider=Sqloledb;Data Source="&databaseServer&";Initial
											Catalog="&databaseName&";User ID="&databaseUser&";Password="&databasePwd&";"
											elseif databaseType=0 then
											connStr="Provider=Microsoft.Jet.OLEdb.4.0;Data
											Source="&server.mappath(accessFilePath)
											end if
											set gConn=server.CreateObject(CONN_OBJ_NAME)
											gConn.open connStr
											end if
											SET getConn=gConn
											End Function

											Function GetAllColumnName(ByVal table)
											if gCols(0)<>table then
												dim rsObj,i,ret:ret=" ,":set rsObj = conn.db("select top 1 * from
												m_"&table&" where 1=1","records1")
												for i=0 to rsObj.Fields.count-1:ret=ret&rsObj.Fields(i).name&",":next
												rsObj.close:set rsObj = nothing:gCols(1)=ret:gCols(0)=table
												end if
												GetAllColumnName=gCols(1)
												End Function

												Function isExistTable(tName)
												dim tables:set tables =
												getConn().OpenSchema(20,array(empty,empty,tName,"table")):isExistTable=tables.eof
												= false:set tables = nothing
												End Function

												Function isExistField(ByVal stable,ByVal sCol)
												isExistField=InStr(GetAllColumnName(stable),","&sCol&",")>0
												End Function

												Function isExistIndex(tName,sIndexName)
												Dim Indexs:SET
												Indexs=getConn().OpenSchema(12,array(empty,empty,sIndexName,empty,tName)):isExistIndex=Indexs.eof
												= false:SET Indexs=Nothing
												End Function

												Sub CreateDataBase
												Dim x
												if databaseType=0 then
												SET x=Server.CreateObject("ADOX.Catalog"):x.Create
												"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" &
												server.mappath(accessFilePath):SET x=Nothing
												else
												set x=server.CreateObject(CONN_OBJ_NAME)
												x.ConnectionTimeout=3:x.open "Provider=Sqloledb;Data
												Source="&databaseServer&";Initial Catalog=;User
												ID="&databaseUser&";Password="&databasePwd&";"
												x.execute "CREATE DATABASE "&databaseName
												on error resume next
												x.execute "ALTER DATABASE "&databaseName&" MODIFY FILE(NAME =
												"&databaseName&"_log,MAXSIZE = 100 MB)"
												x.close:SET x=Nothing:err.clear
												end if
												End Sub

												Sub CreateTable()
												if not isExistTable("m_manager") then
												getConn().execute "create table m_manager(m_id int identity(1,1) not
												null primary key,m_username varchar(20),m_pwd varchar(50),m_state
												tinyint default 1,m_logintime datetime ,m_loginip varchar(15),m_level
												tinyint default 0,m_random varchar(40))"
												echo "�������ݱ� m_manager" & vbcrlf
												end if

												if not isExistTable("m_data") then
												getConn().execute "create table m_data(m_id int identity(1,1) not null
												primary key,m_name varchar(120),m_type int default 0,m_state int default
												0,m_pic varchar(200),m_hit int default 0,m_digg int default 0,m_actor
												varchar(255),m_note text,m_des text,m_topic int default 0,m_color
												varchar(10),m_commend tinyint default 0,m_wrong tinyint default
												0,m_addtime datetime default "&timeStr&",m_publishyear int default
												0,m_publisharea varchar(20),m_playdata text,m_downdata text,m_isunion
												tinyint default 0,m_letter varchar(1),m_keyword text,m_tread int default
												0,m_director varchar(50),m_lang varchar(30),m_dayhit int default
												0,m_weekhit int default 0,m_monthhit int default 0,m_enname
												varchar(120),m_datetime datetime default "&timeStr&",m_recycle tinyint
												default 0,m_score int default 0)"
												echo "�������ݱ� m_data" & vbcrlf
												end if

												if not isExistTable("m_news") then
												getConn().execute "create table m_news(m_id int identity(1,1) not null
												primary key,m_type int default 0,m_vid int default 0,m_title
												varchar(255),m_author varchar(80),m_color varchar(20),m_pic
												varchar(200),m_from varchar(50),m_keyword text,m_outline text,m_content
												text,m_commend tinyint default 0,m_hit int default 0,m_dayhit int
												default 0,m_weekhit int default 0,m_monthhit int default 0,m_note
												tinyint default 0,m_topic int default 0,m_digg int default 0,m_tread int
												default 0,m_entitle varchar(120),m_letter varchar(1),m_addtime datetime
												default "&timeStr&",m_datetime datetime default "&timeStr&",m_recycle
												tinyint default 0,m_score int default 0)"
												echo "�������ݱ� m_news" & vbcrlf
												end if

												if not isExistTable("m_type") then
												getConn().execute "create table m_type(m_id int identity(1,1) not null
												primary key,m_name varchar(60),m_enname varchar(40),m_sort int default
												0,m_upid int default 0,m_hide tinyint default 0,m_template
												varchar(150),m_unionid varchar(255),m_keyword text,m_description
												text,m_type tinyint default 0,m_subtemplate varchar(150))"
												echo "�������ݱ� m_type" & vbcrlf
												end if

												if not isExistTable("m_link") then
												getConn().execute "create table m_link(m_id int identity(1,1) not null
												primary key,m_type varchar(10),m_name varchar(100),m_pic
												varchar(200),m_url varchar(200),m_des varchar(255),m_sort int default
												0)"
												echo "�������ݱ� m_link" & vbcrlf
												end if

												if not isExistTable("m_selflabel") then
												getConn().execute "create table m_selflabel(m_id int identity(1,1) not
												null primary key,m_name varchar(40),m_content text,m_des
												varchar(255),m_addtime datetime default "&timeStr&")"
												getConn().execute "INSERT INTO m_selflabel
												(m_name,m_content,m_des)VALUES('areasearch','','��������')"
												getConn().execute "INSERT INTO m_selflabel
												(m_name,m_content,m_des)VALUES('yearsearch','','��������ݲ鿴��Ӱ')"
												getConn().execute "INSERT INTO m_selflabel
												(m_name,m_content,m_des)VALUES('actorsearch','','��Ա����')"
												getConn().execute "INSERT INTO m_selflabel
												(m_name,m_content,m_des)VALUES('nav_bottom_banner','','�������·�ͨ�����')"
												echo "�������ݱ� m_selflabel" & vbcrlf
												end if

												if not isExistTable("m_topic") then
												getConn().execute "create table m_topic(m_id int identity(1,1) not null
												primary key,m_name varchar(100),m_sort int default 0,m_template
												varchar(255),m_enname varchar(60),m_pic varchar(255),m_des text)"
												echo "�������ݱ� m_topic" & vbcrlf
												end if

												if not isExistTable("m_ads") then
												getConn().execute "create table m_ads(m_id int identity(1,1) not null
												primary key,m_name varchar(100),m_enname varchar(60),m_des
												varchar(255),m_content text,m_addtime datetime default "&timeStr&")"
												echo "�������ݱ� m_ads" & vbcrlf
												end if

												if not isExistTable("m_info") then
												getConn().execute "create table m_info(m_id int identity(1,1) not null
												primary key,m_author varchar(80),m_title varchar(255),m_type
												varchar(20),m_videoid int default 0,m_content text,m_ip
												varchar(20),m_addtime datetime default "&timeStr&",m_color
												varchar(20),m_hit int default 0)"
												echo "�������ݱ� m_info" & vbcrlf
												end if

												if not isExistTable("m_review") then
												getConn().execute "create table m_review(m_id int identity(1,1) not null
												primary key,m_author varchar(80),m_type tinyint default 0,m_videoid int
												default 0,m_content text,m_ip varchar(20),m_addtime datetime default
												"&timeStr&",m_reply int default 0,m_agree int default 0,m_anti int
												default 0,m_pic text,m_vote int default 0,m_check tinyint default 0)"
												echo "�������ݱ� m_review" & vbcrlf
												end if

												if not isExistTable("m_leaveword") then
												getConn().execute "create table m_leaveword(m_id int identity(1,1) not
												null primary key,m_replyid int default 0,m_author varchar(80),m_qq
												varchar(30),m_mail varchar(50),m_content text,m_ip varchar(20),m_addtime
												datetime default "&timeStr&")"
												echo "�������ݱ� m_leaveword" & vbcrlf
												end if

												if not isExistTable("m_temp") then
												getConn().execute "create table m_temp(m_id int identity(1,1) not null
												primary key,m_name varchar(120),m_type int default 0,m_state int default
												0,m_pic varchar(200),m_actor varchar(255),m_des text,m_addtime datetime
												default "&timeStr&",m_playdata text,m_publishyear int default
												0,m_publisharea varchar(50),m_director varchar(50),m_lang varchar(30))"
												echo "�������ݱ� m_temp" & vbcrlf
												end if

												if not isExistTable("nodownload") AND databaseType=0 then
												getConn().execute "create table nodownload(notdown image)"
												getConn().execute "insert into nodownload (notdown) values ('���ᝡ��')"
												echo "�������ݱ� nodownload" & vbcrlf
												end if
												End Sub

												Sub CreateField
												if isExistField("data","m_keyword")=false then getConn().execute "ALTER
												TABLE m_data ADD m_keyword text":getConn().execute "UPDATE m_data SET
												m_keyword=''":echo "�����ֶ� m_data.m_keyword" & vbcrlf
												if isExistField("data","m_letter")=false then getConn().execute "ALTER
												TABLE m_data ADD m_letter varchar(1)":getConn().execute "UPDATE m_data
												SET m_letter=''":echo "�����ֶ� m_data.m_letter" & vbcrlf
												if isExistField("data","m_enname")=false then getConn().execute "ALTER
												TABLE m_data ADD m_enname varchar(120)":getConn().execute "UPDATE m_data
												SET m_enname=''":echo "�����ֶ� m_data.m_enname" & vbcrlf
												if isExistField("data","m_director")=false then getConn().execute "ALTER
												TABLE m_data ADD m_director varchar(50)":getConn().execute "UPDATE
												m_data SET m_director=''":echo "�����ֶ� m_data.m_director" & vbcrlf
												if isExistField("data","m_lang")=false then getConn().execute "ALTER
												TABLE m_data ADD m_lang varchar(30)":getConn().execute "UPDATE m_data
												SET m_lang=''":echo "�����ֶ� m_data.m_lang" & vbcrlf
												if isExistField("data","m_tread")=false then getConn().execute "ALTER
												TABLE m_data ADD m_tread int default 0":getConn().execute "UPDATE m_data
												SET m_tread=0":echo "�����ֶ� m_data.m_tread" & vbcrlf
												if isExistField("data","m_dayhit")=false then getConn().execute "ALTER
												TABLE m_data ADD m_dayhit int default 0":getConn().execute "UPDATE
												m_data SET m_dayhit=0":echo "�����ֶ� m_data.m_dayhit" & vbcrlf
												if isExistField("data","m_weekhit")=false then getConn().execute "ALTER
												TABLE m_data ADD m_weekhit int default 0":getConn().execute "UPDATE
												m_data SET m_weekhit=0":echo "�����ֶ� m_data.m_weekhit" & vbcrlf
												if isExistField("data","m_monthhit")=false then getConn().execute "ALTER
												TABLE m_data ADD m_monthhit int default 0":getConn().execute "UPDATE
												m_data SET m_monthhit=0":echo "�����ֶ� m_data.m_monthhit" & vbcrlf
												if isExistField("data","m_datetime")=false then getConn().execute "ALTER
												TABLE m_data ADD m_datetime datetime default
												"&timeStr&"":getConn().execute "UPDATE m_data SET
												m_datetime=m_addtime":echo "�����ֶ� m_data.m_datetime" & vbcrlf
												if isExistField("data","m_recycle")=false then getConn().execute "ALTER
												TABLE m_data ADD m_recycle tinyint default 0":getConn().execute "UPDATE
												m_data SET m_recycle=0":echo "�����ֶ� m_data.m_recycle" & vbcrlf
												if isExistField("data","m_score")=false then getConn().execute "ALTER
												TABLE m_data ADD m_score int default 0":getConn().execute "UPDATE m_data
												SET m_score=0":echo "�����ֶ� m_data.m_score" & vbcrlf

												if isExistField("temp","m_director")=false then getConn().execute "ALTER
												TABLE m_temp ADD m_director varchar(50)":getConn().execute "UPDATE
												m_temp SET m_director=''":echo "�����ֶ� m_temp.m_director" & vbcrlf
												if isExistField("temp","m_lang")=false then getConn().execute "ALTER
												TABLE m_temp ADD m_lang varchar(30)":getConn().execute "UPDATE m_temp
												SET m_lang=''":echo "�����ֶ� m_temp.m_lang" & vbcrlf

												if isExistField("type","m_type")=false then getConn().execute "ALTER
												TABLE m_type ADD m_type tinyint default 0":getConn().execute "UPDATE
												m_type SET m_type=0":echo "�����ֶ� m_type.m_type" & vbcrlf
												if isExistField("type","m_keyword")=false then getConn().execute "ALTER
												TABLE m_type ADD m_keyword text":echo "�����ֶ� m_type.m_keyword" &
												vbcrlf
												if isExistField("type","m_description")=false then getConn().execute
												"ALTER TABLE m_type ADD m_description text":echo "�����ֶ�
												m_type.m_description" & vbcrlf
												if isExistField("type","m_subtemplate")=false then getConn().execute
												"ALTER TABLE m_type ADD m_subtemplate varchar(150)":getConn().execute
												"UPDATE m_type SET m_subtemplate='content.html' WHERE
												m_type=0":getConn().execute "UPDATE m_type SET m_subtemplate='news.html'
												WHERE m_type=1":echo "�����ֶ� m_type.m_subtemplate" & vbcrlf

												if isExistField("info","m_hit")=false then getConn().execute "ALTER
												TABLE m_info ADD m_hit int default 0":getConn().execute "UPDATE m_info
												SET m_hit =0 where m_type='news'":echo "�����ֶ� m_info.m_hit" & vbcrlf
												End Sub

												Sub CreateIndexs
												if Not isExistIndex("m_data","m_type") then getConn().execute "CREATE
												INDEX m_type ON m_data (m_type)":echo "�������� m_data.m_type" & vbcrlf
												if Not isExistIndex("m_data","m_topic") then getConn().execute "CREATE
												INDEX m_topic ON m_data (m_topic)":echo "�������� m_data.m_topic" &
												vbcrlf
												if Not isExistIndex("m_data","m_commend") then getConn().execute "CREATE
												INDEX m_commend ON m_data (m_commend)":echo "�������� m_data.m_commend"
												& vbcrlf
												if Not isExistIndex("m_data","m_wrong") then getConn().execute "CREATE
												INDEX m_wrong ON m_data (m_wrong)":echo "�������� m_data.m_wrong" &
												vbcrlf
												if Not isExistIndex("m_data","m_letter") then getConn().execute "CREATE
												INDEX m_letter ON m_data (m_letter)":echo "�������� m_data.m_letter" &
												vbcrlf
												if Not isExistIndex("m_data","m_recycle") then getConn().execute "CREATE
												INDEX m_recycle ON m_data (m_recycle)":echo "�������� m_data.m_recycle"
												& vbcrlf

												if Not isExistIndex("m_news","m_type") then getConn().execute "CREATE
												INDEX m_type ON m_news (m_type)":echo "�������� m_news.m_type" & vbcrlf
												if Not isExistIndex("m_news","m_vid") then getConn().execute "CREATE
												INDEX m_vid ON m_news (m_vid)":echo "�������� m_news.m_vid" & vbcrlf
												if Not isExistIndex("m_news","m_topic") then getConn().execute "CREATE
												INDEX m_topic ON m_news (m_topic)":echo "�������� m_news.m_topic" &
												vbcrlf
												if Not isExistIndex("m_news","m_commend") then getConn().execute "CREATE
												INDEX m_commend ON m_news (m_commend)":echo "�������� m_news.m_commend"
												& vbcrlf
												if Not isExistIndex("m_news","m_letter") then getConn().execute "CREATE
												INDEX m_letter ON m_news (m_letter)":echo "�������� m_news.m_letter" &
												vbcrlf
												if Not isExistIndex("m_news","m_recycle") then getConn().execute "CREATE
												INDEX m_recycle ON m_news (m_recycle)":echo "�������� m_news.m_recycle"
												& vbcrlf

												if Not isExistIndex("m_review","m_type") then getConn().execute "CREATE
												INDEX m_type ON m_review (m_type)":echo "�������� m_review.m_type" &
												vbcrlf
												if Not isExistIndex("m_review","m_videoid") then getConn().execute
												"CREATE INDEX m_videoid ON m_review (m_videoid)":echo "��������
												m_review.m_videoid" & vbcrlf
												if Not isExistIndex("m_review","m_reply") then getConn().execute "CREATE
												INDEX m_reply ON m_review (m_reply)":echo "�������� m_review.m_reply" &
												vbcrlf

												if Not isExistIndex("m_info","m_videoid") then getConn().execute "CREATE
												INDEX m_videoid ON m_info (m_videoid)":echo "�������� m_info.m_videoid"
												& vbcrlf
												End Sub

												Sub DoUPDATA()
												Dim rs,i,t,ary,conn:SET conn=getConn():SET
												rs=server.CreateObject(RECORDSET_OBJ_NAME)
												rs.open "SELECT top 1001 m_id,m_name FROM m_data WHERE m_enname='' OR
												m_letter=''",conn,1,1
												if not rs.eof then ary=rs.getRows()
												rs.close:set rs=nothing
												if isArray(ary) then
												go=UBound(ary,2)
												for i=0 to go
												t=MoviePinYin(ary(1,i)):echo ary(0,i) & "=" & t &vbcrlf
												conn.execute "UPDATE m_data SET
												m_enname='"&t&"',m_letter='"&left(t,1)&"' WHERE m_id="&ary(0,i)
												next
												else
												echo "....................�������...................." & vbcrlf:go=0
												end if
												conn.close
												End Sub
												%>