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
viewHead "站点配置" & "-" & menuList(8,0)

dim action : action = getForm("action", "get")
Const SearchCacheDir="../webcache/"

dim templateobj: set templateobj = mainClassobj.createObject("MainClass.template")
Select case action
	case "edit" : editConfig
	case "clearsearch":clearSearch
	case else : main
End Select
viewFoot

Sub main
'on error resume next
dim i,ay
%>
<div class="container" id="cpcontainer">
<!--当前导航-->
<script type="text/JavaScript">if(parent.$('admincpnav')) parent.$('admincpnav').innerHTML='后台首页&nbsp;&raquo;&nbsp;<%=menuList(8,0)%>&nbsp;&raquo;&nbsp;站点配置';</script>
<form method="post" action="?action=edit">
<input type="hidden" name="isalertwin_old" value="<%=isAlertWin%>"/>
<table class="tb">
<tr class="thead"><td colspan="2">站点配置</td></tr>
<tr class="thead2">
  <td colspan="2"><strong>网站基本设置</strong></td>
</tr>
<tr>
	<td width="10%">网站模式：</td>
	<td valign="top">
		<ul id="makeHtmlTab" style="padding:0">
			<li id="li.v" class="hover" onclick="toogletab('0');" style="cursor:pointer">视频</li>
			<li id="li.n" onclick="toogletab('1');" style="cursor:pointer">新闻</li>
		</ul>
		<table class="tb">
			<tbody id="video" style="display:.none;">
				<tr>
					<td>
					<select name="runmode" id="runmode" onChange="selecRunMode(this.options[this.selectedIndex].value)">
						<option value="dynamic" <% if RunMode="dynamic" then Response.Write "selected"%>>动态模式</option>
						<option value="static" <% if RunMode="static" then Response.Write "selected"%>>静态模式</option>
						<option value="forgedStatic" <% if RunMode="forgedStatic" then Response.Write "selected"%>>伪静态模式</option>
					</select> 伪静态模式,因很多虚拟主机不能完美支持,建议熟练者或有独立服务器者使用</td>
				</tr>
				<tr id="static" <%if RunMode<>"static" then echo "style=""display:none""" end if%>>
					<td>生成时间间隔：<input type="text" name="maketimespan" size="15" value="<%=makeTimeSpan%>">&nbsp;&nbsp;秒&nbsp;&nbsp;
					  目录选择：
					  <select name="makemode" onchange="selecMakeMode(this.options[this.selectedIndex].value)" id="makemode">
					  <option value="dir1" <% if makeMode="dir1" then Response.Write "selected"%>>目录1：/typeEnname/vid/</option>
					  <option value="dir3" <% if makeMode="dir3" then Response.Write "selected"%>>目录3：/typeEnname/date/vid</option>
					  <option value="dir5" <% if makeMode="dir5" then Response.Write "selected"%>>目录5：/typeEnname/vEnName/</option>
					  <option value="dir7" <% if makeMode="dir7" then Response.Write "selected"%>>目录7：/typeEnname/date/vEnName</option>
					  <option value="dir2" <% if makeMode="dir2" then Response.Write "selected"%>>目录2：/[dir]/[page]id</option>
					  <option value="dir4" <% if makeMode="dir4" then Response.Write "selected"%>>目录4：/[dir]/date/[page]id</option>
					  <option value="dir6" <% if makeMode="dir6" then Response.Write "selected"%>>目录6：/[dir]/[page]EnName</option>
					  <option value="dir8" <% if makeMode="dir8" then Response.Write "selected"%>>目录8：/[dir]/date/[page]EnName</option>
					</select>
					&nbsp;&nbsp;md5加密id：开启<input type="radio" name="md5Content" value="1" <% if md5Content=1 then echo "checked" end if%> class="radio"> 关闭<input type="radio" name="md5Content" value="0" <% if md5Content=0 then echo "checked" end if%> class="radio">
					</td>
				</tr>
				<tr><td height="25">文件的后缀名：<select name="filesuffix" style="width:110px">
				<%
					ay=split(".html|.htm|.asp|.shtml|.shtm|.wml","|")
					for i=0 to UBound(ay)
						if ay(i)=fileSuffix then
							echo "<option value="""&ay(i)&""" selected>"&ay(i)&"</option>"
						else
							echo "<option value="""&ay(i)&""">"&ay(i)&"</option>"
						end if
					next
				%>
				</select>&nbsp;&nbsp;URL传参方式：<input type="radio" class="radio" id="paramset1" name="paramset" onclick="hide('urlparamset');view('paramsetbdy');" value="0"<%if paramset=0 then:echo " checked":end if%>>1-0-0.html&nbsp;&nbsp;<input type="radio" class="radio" id="paramset2" name="paramset" onclick="hide('paramsetbdy');view('urlparamset')" value="1"<%if paramset=1 then:echo " checked":end if%>><span id="paramsetbdy"<%=ifthen(paramset=0,""," style=""display:none""")%>><%=paramid%>=1&amp;<%=parampage%>=2&amp;<%=paramindex%>=3</span><span id="urlparamset"<%=ifthen(paramset=1,""," style=""display:none""")%>><input type="text" style="height:12px" size="5" name="paramid" onchange="onTxtChange(this)" value="<%=paramid%>">=1&amp;<input type="text" style="height:12px" size="5" name="parampage" onchange="onTxtChange(this)" value="<%=parampage%>">=2&amp;<input type="text" style="height:12px" size="5" name="paramindex" onchange="onTxtChange(this)" value="<%=paramindex%>">=3</span></td></tr>

				<tr id="dynamic" <%if  RunMode<>"dynamic" then echo "style=""display:none""" end if%>>
					<td> 栏目页目录名：<input type="text" name="channeldirname1" size="15" value="<%=channelDirName1%>"/>&nbsp;&nbsp;内容页目录名：<input type="text" size="15" name="contentdirname1" value="<%=contentDirName1%>"/>&nbsp;&nbsp;播放页目录名：<input type="text" size="15" name="playdirname1" value="<%=playDirName1%>"/></td>
				</tr>
				<tr id="forgedStatic" <%if  RunMode<>"forgedStatic" then echo "style=""display:none""" end if%>>
					<td> 栏目页目录名：<input type="text" name="channeldirname4" size="15" value="<%=channelDirName4%>"/>&nbsp;&nbsp;内容页目录名：<input type="text" size="15" name="contentdirname4" value="<%=contentDirName4%>"/>&nbsp;&nbsp;播放页目录名：<input type="text" size="15" name="playdirname4" value="<%=playDirName4%>"/>&nbsp;<br/>
					栏目页文件名：<input type="text" name="channelpagename4" value="<%=channelPageName4%>" size="15">&nbsp;&nbsp;内容页文件名：<input type="text" name="contentpagename4" value="<%=contentPageName4%>" size="15">&nbsp;&nbsp;播放页文件名：<input type="text" name="playpagename4" value="<%=playPageName4%>" size="15">
					</td>
				</tr>
				<tr id="dir1" <%if not(Instr("#dir1,dir3,dir5,dir7#",makeMode)>0 and RunMode="static") then echo "style=""display:none""" end if%>>
					<td>
					<span style="display:none;">
					栏目页文件名：<input type="text" size="15" name="channelpagename2" value="index">&nbsp;&nbsp;
					内容页文件名：<input type="text" size="15" name="contentpagename2" value="index">&nbsp;&nbsp;</span>
					播放页文件名：<input type="text" size="15" name="playpagename2" value="<%=playPageName2%>">
					</td>
				</tr>
				<tr id="dir2" <%if not(Instr("#dir2,dir4,dir6,dir8#",makeMode)>0 and RunMode="static") then echo "style=""display:none""" end if%>>
					<td>
					栏目页目录名：<input type="text" name="channeldirname3" value="<%=channelDirName3%>" size="15">&nbsp;&nbsp;内容页目录名：<input type="text" name="contentdirname3" value="<%=contentDirName3%>" size="15">&nbsp;&nbsp;播放页目录名：<input type="text" name="playdirname3" value="<%=playDirName3%>" size="15"/>&nbsp;&nbsp;<br/>
					栏目页文件名：<input type="text" name="channelpagename3" value="<%=channelPageName3%>" size="15">&nbsp;&nbsp;内容页文件名：<input type="text" name="contentpagename3" value="<%=contentPageName3%>" size="15">&nbsp;&nbsp;播放页文件名：<input type="text" name="playpagename3" value="<%=playPageName3%>" size="15"/>
					</td>
				</tr>
				<tr>
					<td id="zt">专题主目录名：<input type="text" size="15" name="topicdirname" value="<%=topicDirName%>">&nbsp;&nbsp;专题页目录名：<input type="text" size="15" name="topicpagedirname" value="<%=topicpageDirName%>"></td>
				</tr>
				<tr id="ismakeplaytr" <%if RunMode<>"static" then echo "style=""display:none""" end if%>>
					<td>生成播放网页：<select name="ismakeplay" id="ismakeplay" style="width:100px;" onchange="selectMakeplay(this.options[this.selectedIndex].value)"><option value="0" <%=ifthen(ismakeplay=0,"selected","")%>>动态不生成</option><option value="1" <%=ifthen(ismakeplay=1,"selected","")%>>生成静态</option><option value="3" <%=ifthen(ismakeplay=3,"selected","")%>>生成每集静态</option><option value="2" <%=ifthen(ismakeplay=2,"selected","")%>>生成动态</option></select> 访问量大的站点、建议生成播放页；如选动态可在播放页支持集名称标签{playpage:part}</td>
				</tr>
				<tr>
					<td>
					是否弹窗播放：<input type="radio" name="isalertwin" onClick="selectAlertWin(this.value)" value="1" <% if isAlertWin=1 then echo "checked" end if%> class="radio">弹窗
						<div id="alertwinset" <%if isAlertWin=0 then %>style="display:none"<%end if%>>宽： <input type="text" name="alertwinw" size="5" value="<%=alertWinW%>"> px    &nbsp;&nbsp;高 <input type="text" name="alertwinh" size="5" value="<%=alertWinH%>"/> px</div>
						<input type="radio" name="isalertwin" onclick="selectAlertWin(this.value)" value="0" <% if isAlertWin=0 then echo "checked" end if%> class="radio">不弹窗  &nbsp;&nbsp;&nbsp;&nbsp;弹窗播放模式,获得更好的播放体验
					</td>
				</tr>
			</tbody>
			<tbody id="news" style="display:none;">
				<tr>
					<td>
					<select name="newsrunmode" id="newsrunmode" onChange="selecNewsRunMode(this.options[this.selectedIndex].value)">
						<option value="dynamic" <% if NewsRunMode="dynamic" then Response.Write "selected"%>>动态模式</option>
						<option value="static" <% if NewsRunMode="static" then Response.Write "selected"%>>静态模式</option>
						<option value="forgedStatic" <% if NewsRunMode="forgedStatic" then Response.Write "selected"%>>伪静态模式</option>
					</select>  伪静态模式,因很多虚拟主机不能完美支持,建议熟练者或有独立服务器者使用</td>
				</tr>
				<tr id="newsstatic" <%if NewsRunMode<>"static" then echo "style=""display:none""" end if%>>
					<td>生成时间间隔：<input type="text" name="newsmaketimespan" size="15" value="<%=newsMakeTimeSpan%>">&nbsp;&nbsp;秒&nbsp;&nbsp;
					  目录选择：
					  <select name="newsmakemode" onchange="selecNewsMakeMode(this.options[this.selectedIndex].value)" id="newsmakemode">
					  <option value="dir1" <% if NewsMakeMode="dir1" then Response.Write "selected"%>>目录1：/typeEnname/id/</option>
					  <option value="dir3" <% if NewsMakeMode="dir3" then Response.Write "selected"%>>目录3：/typeEnname/date/id</option>
					  <option value="dir5" <% if NewsMakeMode="dir5" then Response.Write "selected"%>>目录5：/typeEnname/EnName/</option>
					  <option value="dir7" <% if NewsMakeMode="dir7" then Response.Write "selected"%>>目录7：/typeEnname/date/EnName</option>
					  <option value="dir2" <% if NewsMakeMode="dir2" then Response.Write "selected"%>>目录2：/[dir]/[page]id</option>
					  <option value="dir4" <% if NewsMakeMode="dir4" then Response.Write "selected"%>>目录4：/[dir]/date/[page]id</option>
					  <option value="dir6" <% if NewsMakeMode="dir6" then Response.Write "selected"%>>目录6：/[dir]/[page]EnName</option>
					  <option value="dir8" <% if NewsMakeMode="dir8" then Response.Write "selected"%>>目录8：/[dir]/date/[page]EnName</option>
					</select>
					&nbsp;&nbsp;md5加密id：开启<input type="radio" name="newsmd5Content" value="1" <% if newsmd5Content=1 then echo "checked" end if%> class="radio"> 关闭<input type="radio" name="newsmd5Content" value="0" <% if newsmd5Content=0 then echo "checked" end if%> class="radio">
					</td>
				</tr>
				<tr><td height="25">文件的后缀名：<select name="newsfilesuffix" style="width:110px">
				<%
					ay=split(".html|.htm|.asp|.shtml|.shtm|.wml","|")
					for i=0 to UBound(ay)
						if ay(i)=newsFileSuffix then
							echo "<option value="""&ay(i)&""" selected>"&ay(i)&"</option>"
						else
							echo "<option value="""&ay(i)&""">"&ay(i)&"</option>"
						end if
					next
				%>
				</select>&nbsp;&nbsp;URL传参方式：<input type="radio" class="radio" id="newsparamset1" name="newsparamset" onclick="hide('newsurlparamset');view('newsparamsetbdy');" value="0"<%if newsparamset=0 then:echo " checked":end if%>>1-0-0.html&nbsp;&nbsp;<input type="radio" class="radio" id="newsparamset2" name="newsparamset" onclick="hide('newsparamsetbdy');view('newsurlparamset')" value="1"<%if newsparamset=1 then:echo " checked":end if%>><span id="newsparamsetbdy"<%=ifthen(newsparamset=0,""," style=""display:none""")%>><%=paramid%>=1&amp;<%=parampage%>=2&amp;<%=paramindex%>=3</span><span id="newsurlparamset"<%=ifthen(newsparamset=1,""," style=""display:none""")%>><input type="text" style="height:12px" size="5" name="newsparamid" onchange="onTxtChange(this)" value="<%=newsparamid%>">=1&amp;<input type="text" style="height:12px" size="5" name="newsparampage" onchange="onTxtChange(this)" value="<%=parampage%>">=2&amp;<input type="text" style="height:12px" size="5" name="newsparamindex" onchange="onTxtChange(this)" value="<%=newsparamindex%>">=3</span></td></tr>

				<tr id="newsdynamic" <%if NewsRunMode<>"dynamic" then echo "style=""display:none""" end if%>>
					<td>新闻主目录名：<input type="text" size="15" name="newsdirname1" value="<%=newsDirName1%>"/>&nbsp;&nbsp;栏目页目录名：<input type="text" name="partdirname1" size="15" value="<%=partDirName1%>"/>&nbsp;&nbsp;文章页目录名：<input type="text" size="15" name="articledirname1" value="<%=articleDirName1%>"/></td>
				</tr>
				<tr id="newsforgedStatic" <%if  NewsRunMode<>"forgedStatic" then echo "style=""display:none""" end if%>>
					<td>新闻主目录名：<input type="text" size="15" name="newsdirname4" value="<%=newsdirname4%>"/>&nbsp;&nbsp;栏目页目录名：<input type="text" name="partdirname4" size="15" value="<%=partDirName4%>"/>&nbsp;&nbsp;内容页目录名：<input type="text" size="15" name="articledirname4" value="<%=articleDirName4%>"/><br/>
						新闻页文件名：<input type="text" size="15" name="newspagename4" value="<%=newsPageName4%>"/>&nbsp;&nbsp;栏目页文件名：<input type="text" name="partpagename4" value="<%=partPageName4%>" size="15">&nbsp;&nbsp;内容页文件名：<input type="text" name="articlepagename4" value="<%=articlePageName4%>" size="15">
					</td>
				</tr>
				<tr id="newsdir1" <%if not(Instr("#dir1,dir3,dir5,dir7#",NewsMakeMode)>0 and NewsRunMode="static") then echo "style=""display:none""" end if%>>
					<td>新闻主目录名：<input type="text" size="15" name="newsdirname2" value="<%=newsDirName2%>"/>&nbsp;&nbsp;新闻页文件名：<input type="text" size="15" name="newspagename2" value="<%=newspagename2%>"/>
					<span style="display:none;">栏目页文件名：<input type="text" size="15" name="partpagename2" value="index">&nbsp;&nbsp;文章页文件名：<input type="text" size="15" name="articlepagename2" value="index"></span>
					</td>
				</tr>
				<tr id="newsdir2" <%if not(Instr("#dir2,dir4,dir6,dir8#",NewsMakeMode)>0 and NewsRunMode="static") then echo "style=""display:none""" end if%>>
					<td>新闻主目录名：<input type="text" size="15" name="newsdirname3" value="<%=newsDirName3%>"/>&nbsp;&nbsp;栏目页目录名：<input type="text" name="partDirName3" value="<%=partDirName3%>" size="15">&nbsp;&nbsp;文章页目录名：<input type="text" name="articledirname3" value="<%=articleDirName3%>" size="15"><br/>
						新闻页文件名：<input type="text" size="15" name="newspagename3" value="<%=newsPageName3%>"/>&nbsp;&nbsp;栏目页文件名：<input type="text" name="partPageName3" value="<%=channelPageName3%>" size="15">&nbsp;&nbsp;文章页文件名：<input type="text" name="articlepagename3" value="<%=articlePageName3%>" size="15">
					</td>
				</tr>
			</tbody>
		</table>
	</td>
</tr>
<script type="text/JavaScript">
function toogletab(to){
	if(to!='1'){
		hide('news');view('video');$('li.v').className='hover';$('li.n').className='';
	}else{
		hide('video');view('news');$('li.n').className='hover';$('li.v').className='';
	}
	setCookie('Config_tab',to,365*24);
}
if(getCookie('Config_tab')=='1'){
	toogletab('1');
}
</script>
<tr><td>网站名称：</td><td width="661"><input type="text" name="sitename" size="30" value="<%=siteName%>"> 请尽快修改网站名称</td></tr>
<tr><td>网站地址：</td><td ><input type="text" name="siteurl" size="30" value="<%=siteUrl%>">
不含http://,如填写:www.maxcms.co</td>
</tr>
<tr><td>网站路径：</td><td ><input type="text" name="sitepath" size="30" value="<%=sitePath%>"> 
1.安装在根目录下这里设置为空 2.安装二级目录填写为:二级目录名/</td>
</tr>

<tr><td>数据库选择：</td><td ><select name="databasetype" onChange="selectDataBase(this.options[this.selectedIndex].value)">a<option value="1" <%if databaseType=1 then echo "selected" end if%>>MS-SqlServer</option><option value="0"  <%if databaseType=0 then echo "selected" end if%>>Access</option></select></td></tr>
<tbody id="mssql"<%=ifthen(databaseType=0," style=""display:none""","")%>>
<tr><td>SQL服务器名称：</td><td><input type="text" name="databaseserver" size="30" value="<%=databaseServer%>"> SQL服务器名称或IP地址</td></tr>
<tr><td>SQL数据库名称：</td><td><input type="text" name="databasename" size="30" value="<%=databaseName%>"></td></tr>
<tr><td>SQL数据表用户：</td><td><input type="text" name="tableuser" size="30" value="<%=tableuser%>"> 可不填，只有迁服务器时还原备份的表才带有表用户</td></tr>
<tr><td>SQL数据库帐号：</td><td><input type="text" name="databaseuser" size="30" value="<%=databaseUser%>"></td></tr>
<tr><td>SQL数据库密码：</td><td><input type="text" name="databasepwd" size="30" value="<%=databasePwd%>"></td></tr>
</tbody>
<tr id="acc" <%if databaseType=1 then%>style="display:none"<%end if%>>
  <td>ACC路径：</td>
  <td><input type="text" name="accessfilepath" size="20" value="<%=accessFilePath%>"> 
1.程序安装在根目录下:/inc/datas.asp  &nbsp;&nbsp;2.二级目录下:/二级目录名/inc/datas.asp
</td>
</tr>

<tr class="thead2"><td colspan="2"><a name="rule"><strong>采集工具设置<a name="rule" id="rule"></a></strong></td>
</tr>
<tr style="display:none">
<td>采集工具：</td>
<td>
 <label for="allowAutoGather0">关闭定时采集功能</label><input type="radio" id="allowAutoGather0" value="0" name="allowAutoGather" <%if AllowAutoGather=0 then%>checked<%end if%>> &nbsp;&nbsp;
 <label for="allowAutoGather1">开启定时采集功能</label><input type="radio" id="allowAutoGather1" value="1" name="allowAutoGather" <%if AllowAutoGather=1 then%>checked<%end if%>>&nbsp;&nbsp;<font color=red>定时采集需要耗费较多系统资源、不建议开启</font>
</td>
</tr>
<tr>
<td >同名数据时：</td>
<td >
 <label for="gatherset0">智能覆盖</label><input type="radio" id="gatherset0" value="0" name="gatherset" <%if gatherSet=0 then%>checked<%end if%>> &nbsp;&nbsp;
 <label for="gatherset1">地址头部追加</label><input type="radio" id="gatherset1" value="1" name="gatherset" <%if gatherSet=1 then%>checked<%end if%>>&nbsp;&nbsp;
 <label for="gatherset2">地址尾部追加</label><input type="radio" id="gatherset2" value="2" name="gatherset" <%if gatherSet=2 then%>checked<%end if%>>&nbsp;&nbsp;
 <label for="gatherset3">覆盖地址</label><input type="radio" value="3" id="gatherset3" name="gatherset" <%if gatherSet=3 then%>checked<%end if%>>&nbsp;&nbsp;
 <label for="gatherset4">新增数据</label><input type="radio" value="4" id="gatherset4" name="gatherset" <%if gatherSet=4 then%>checked<%end if%>>&nbsp;&nbsp;
 <label for="gatherset5">仅更新地址以外的信息</label><input type="radio" id="gatherset5" value="5" name="gatherset" <%if gatherSet=5 then%>checked<%end if%>>
  </td></tr>

<tr class="thead2"><td colspan="2"><strong>模板与路径设置</strong></td></tr>
<tr><td>模板选择：</td>
<td><select name="defaulttemplate" style="width:150 ">
<%
dim templateFolder,templateFolders,folderName,templateSelected : templateFolders=getFolderList("../template")
for each templateFolder in templateFolders
	folderName= split(templateFolder,",")(0)
	if folderName=defaultTemplate then  templateSelected="selected" else templateSelected=""
	echo "<option value='"&folderName&"' "&templateSelected&">"&folderName&"</option>"
next
%>
</select></td>
</tr>
<tr><td>模板文件所在文件夹：</td><td><input type="text" name="templatefilefolder" size="15" value="<%=templateFileFolder%>"> 防止模板被盗</td></tr>

<tr><td>图片文件夹：</td><td width="661"><input type="text" name="sitepic" size="15" value="<%=sitePic%>"/> 
位于根目录的pic文件夹下</td>
</tr>
<tr><td>JS广告文件夹：</td><td width="661"><input type="text" name="sitegg" size="15" value="<%=siteAd%>"/>   位于根目录的js文件夹下</td>
</tr>
<tr class="thead2">
<td colspan="2"><strong>插件设置</strong></td></tr>
<tr><td>留言开关：</td><td width="661" style="float:left">开启：
  <input type="radio" name="gbookStart" value="1" <% if gbookStart=1 then echo "checked" end if%> class="radio" onclick="$('gbookfont').style.display=''"/>关闭：<input type="radio" name="gbookStart" value="0" <% if gbookStart=0 then echo "checked" end if%> class="radio" onclick="$('gbookfont').style.display='none'"/>
<font <% if gbookStart=0 then%> style="display:none"<% end if %> id="gbookfont">
&nbsp;&nbsp;留言时间间隔<input type="text" name="gbookTime" size="4" value="<%=gbooktime%>"/>秒
&nbsp;&nbsp;留言管理账号<input type="text" name="gbookUser" size="10" value="<%=gbookuser%>"/>
&nbsp;&nbsp;留言密码管理<input type="text" name="gbookPwd" size="10" value="<%=gbookpwd%>"/>
</font>
</td></tr>

<tr><td>评论开关：</td><td width="661">开启：
  <input type="radio" name="commentStart" value="1" <% if commentStart=1 then echo "checked" end if%> class="radio" onclick="$('commentfont').style.display=''"/>关闭：<input type="radio" name="commentStart" value="0" <% if commentStart=0 then echo "checked" end if%> class="radio" onclick="$('commentfont').style.display='none'"/><font id="commentfont"  <% if commentStart=0 then%> style="display:none" <% end if %>>&nbsp;&nbsp; 评论时间间隔<input type="text" name="commentTime" size="4" value="<%=commentTime%>"/></font>秒 &nbsp;&nbsp;在数据库负载过重情况下，可以关闭评论功能</td></tr>

<tr>
  <td >智能报错：</td>
  <td width="661">开启：<input type="radio" name="isAutoCheck" value="1" <% if isAutoCheck=1 then echo "checked" end if%> class="radio">关闭：<input type="radio" name="isAutoCheck" value="0" <% if isAutoCheck=0 then echo "checked" end if%> class="radio"> &nbsp;&nbsp;如开启、将对错误数据自动检测报错；如关闭、将节省部分性能</td></tr>
<tr>
  <td >来源排序：</td>
  <td width="661">开启：<input type="radio" name="isfromsort" value="1" <% if isfromsort=1 then echo "checked" end if%> class="radio">关闭：<input type="radio" name="isfromsort" value="0" <% if isfromsort=0 then echo "checked" end if%> class="radio"> &nbsp;&nbsp;如开启、将对播放来源按设置进行排序；如关闭、将节省部分性能</td></tr>

<tr class="thead2"><td colspan="2"><strong>水印设置</strong></td></tr>
<tr><td>文字水印：</td><td><table class="tdk"><tr><td>开启：<input type="radio" name="watermark" value="1" onClick="selectWaterMark(this.value)"  <%=ifthen(waterMark=1,"checked","")%> class="radio"></td><td>关闭：<input type="radio"   <% if waterMark=0 then echo "checked" end if%>  name="watermark" value="0" onClick="selectWaterMark(this.value)" class="radio"> &nbsp;&nbsp;需要AspJpeg组件支持</td></tr></table></td></tr>
<tr id="watermarkfont"<%=ifthen(waterMark=0," style=""display:none""","")%>><td>水印设置：</td>
<td>
	<table>
	<tr>
		<td>水印文字：</td>
		<td><input type="text" name="watermarkfont" value="<%=waterMarkFont%>"></td>
	</tr>
	<tr>
		<td>水印位置：</td>
		<td>
		<%
			for i=1 to 9
				if Cstr(i)=waterMarkLocation then
					echo "<input type=""radio"" name=""waterlocation"" value="""&i&"""checked/>"
				else
					echo "<input type=""radio"" name=""waterlocation"" value="""&i&"""/>"
				end if
				if i MOD 3=0 then echo "<br>"
			next
		%>
		</td>
	</tr>
	</table>
</td>
</tr>

<tr class="thead2"><td colspan="2"><strong>搜索/动态/缓存设置</strong></td></tr>
<tr><td>缓存开关：</td><td><table class="tdk"><tr><td>开启：<input type="radio" name="cachestart" onClick="selectCache(this.value)" value="1" <%=ifthen(cacheStart=1,"checked","")%> class="radio"></td><td id="cacheset" <% if cacheStart=0 then %> style="display:none"<%end if%>>缓存过期时间：<input type="text" name="cachetime" size="5" value="<%=cacheTime%>">分钟<input type="hidden" name="cacheflag" size="20"  value="<%=cacheFlag%>"/></td><td>关闭：<input type="radio" name="cachestart" onclick="selectCache(this.value)" value="0" <% if cacheStart=0 then echo "checked" end if%> class="radio"></td></tr></table></td></tr>
<tr><td>动态缓存：</td><td width="661"><table class="tdk"><tr><td>开启：<input type="radio" name="IsCacheSearch" onClick="selectCacheSearch(this.value)" value="1" <% if isCacheSearch=1 then echo "checked" end if%> class="radio"></td><td id="CacheSearch"  <% if isCacheSearch=0 then %> style="display:none"<%end if%>>缓存过期时间：<input type="text" name="CacheSearchTime" size="5" value="<%=CacheSearchTime%>">分钟</td><td>关闭：<input type="radio" name="IsCacheSearch" onclick="selectCacheSearch(this.value)" value="0" <% if isCacheSearch=0 then echo "checked" end if%> class="radio">&nbsp;&nbsp;访问量过大建议打开，有效减少前台搜索压力</td></tr></table></td></tr>
<tr><td>缓存目录：</td><td width="661"><a href="?action=clearsearch" class="btn" style="padding-top:2px;color:#000">清空动态缓存目录</a> 本操作会删除程序目录下的webcache目录，必需删除目录权限</td></tr>

<tr class="thead2">
  <td colspan="2"><strong>其它设置</strong></td>
</tr>
<tr><td>过滤留言：</td><td><input type="text" name="dirtywords" size="80" value="<%=dirtyWords%>">请以英文逗号,分离</td></tr>
<tr><td>禁止留言：</td><td><input type="text" name="banwords" size="80" value="<%=BanWords%>">请以英文逗号,分离</td></tr>
<tr><td>禁止IP：</td><td><input type="text" name="banIPS" size="80" value="<%=BanIPS%>">请以英文逗号,分离<br>支持通配符*(例：192.168.1.*)</td></tr>
<tr><td>热门搜索：</td><td><input type="text" name="sitekeywords" size="80" value="<%=siteKeyWords%>"></td></tr>
<tr><td>统计代码：</td><td><input type="text" name="sitevisitejs" size="80" value="<%=siteVisiteJs%>"></td></tr>
<tr><td>站点描述：</td><td width="661"><textarea cols="90" rows="3" name="sitedes"><%=codeTextarea(siteDes,"de")%></textarea></td></tr>
<tr><td   width="79">网站公告：</td>
<td><textarea cols="90" rows="3" name="sitenotice"><%=codeTextarea(siteNotice,"de")%></textarea></td></tr>
<tr><td>网站版权信息</td><td><textarea cols="90" rows="3" name="copyright"><%=codeTextarea(copyRight,"de")%></textarea></td></tr>
<tr><td></td><td><input type="submit" value="确认更新" class="btn"></td></tr>
</table>
</form>
<%
End Sub

Sub chkPic
	dim x:x=getForm("sitepic","post")
	if sitePic<>x AND not isNul(x) then
		dim rsObj:set rsObj = conn.db("SELECT  *  from m_data  where left(m_pic,7) <>'http://'","records3")
		if rsObj.eof  then
			exit Sub
		end if
		while not rsObj.eof 
			rsObj("m_pic")  =  replacestr(rsObj("m_pic"),sitePic,x)
			rsObj.update
			rsObj.movenext
		wend 
		rsObj.close
		set rsObj = nothing
	end if 
End Sub


Sub setforgeStatic
	dim tmpstr : tmpstr = ""
	templateObj.load("/"&sitePath&"inc/RewriteRule.config")
	if getForm("runmode","post")="forgedStatic" then
		tmpstr = templateObj.content
		tmpstr  = replacestr(tmpstr,"{channeldirname1}",getForm("channeldirname1","post"))
		tmpstr  = replacestr(tmpstr,"{contentdirname1}",getForm("contentdirname1","post"))
		tmpstr  = replacestr(tmpstr,"{playdirname1}",getForm("playdirname1","post"))
		tmpstr  = replacestr(tmpstr,"{topicdirname}",getForm("topicdirname","post"))
		tmpstr  = replacestr(tmpstr,"{topicpagedirname}",getForm("topicpagedirname","post"))
		tmpstr  = replacestr(tmpstr,"{channeldirname4}",getForm("channeldirname4","post"))
		tmpstr  = replacestr(tmpstr,"{contentdirname4}",getForm("contentdirname4","post"))
		tmpstr  = replacestr(tmpstr,"{contentdirname1}",getForm("contentdirname1","post"))
		tmpstr  = replacestr(tmpstr,"{partpagename4}",getForm("partpagename4","post"))
		tmpstr  = replacestr(tmpstr,"{playdirname4}",getForm("playdirname4","post"))
		tmpstr  = replacestr(tmpstr,"{channelpagename4}",getForm("channelpagename4","post"))
		tmpstr  = replacestr(tmpstr,"{contentpagename4}",getForm("contentpagename4","post"))
		tmpstr  = replacestr(tmpstr,"{playpagename4}",getForm("playpagename4","post"))
		tmpstr  = replacestr(tmpstr,"{sitePath}",sitePath)
		tmpstr  = replacestr(tmpstr,"{fileSuffix}",getForm("fileSuffix","post"))
	end if

	if getForm("newsrunmode","post")="forgedStatic" then
		tmpstr  = replacestr(tmpstr,"{newsdirname1}",getForm("newsdirname1","post"))
		tmpstr  = replacestr(tmpstr,"{partdirname1}",getForm("partdirname1","post"))
		tmpstr  = replacestr(tmpstr,"{articledirname1}",getForm("articledirname1","post"))
		tmpstr  = replacestr(tmpstr,"{newsdirname4}",getForm("newsdirname4","post"))
		tmpstr  = replacestr(tmpstr,"{newspagename4}",getForm("newspagename4","post"))
		tmpstr  = replacestr(tmpstr,"{partdirname4}",getForm("partdirname4","post"))
		tmpstr  = replacestr(tmpstr,"{partpagename4}",getForm("partpagename4","post"))
		tmpstr  = replacestr(tmpstr,"{articledirname4}",getForm("articledirname4","post"))
		tmpstr  = replacestr(tmpstr,"{articlepagename4}",getForm("articlepagename4","post"))
		tmpstr  = replacestr(tmpstr,"{sitePath}",sitePath)
		tmpstr  = replacestr(tmpstr,"{fileSuffix}",getForm("fileSuffix","post"))
	end if
	tmpstr=replacestr(replacestr(tmpstr,"{","\{"),"}","\}")
	createTextFile tmpstr,"../httpd.ini",""
End Sub

Sub editConfig
	chkPic
	dim configStr,cacheFlagValue
	cacheFlagValue=timeToStr(now())
	setforgeStatic
	configStr="Dim siteName,siteUrl,sitePath,databaseType,databaseServer,databaseName,tableUser,databaseUser,databasepwd,accessFilePath,templateFileFolder,defaultTemplate,gbookStart,commentStart,cacheStart,siteMode,cacheTime,cacheFlag,IsCacheSearch,CacheSearchTime"&vbcrlf& _
	"siteName="""&getForm("sitename","post")&"""  '站点名称"&vbcrlf& _
	"siteUrl="""&getForm("siteurl","post")&"""  '站点网址"&vbcrlf& _
	"sitePath="""&getForm("sitepath","post")&"""  '安装目录(根目录为空；二级目录填写为:二级目录名/)"&vbcrlf& _
	"databaseType="&getForm("databasetype","post")&"  '数据库类型（0为access；1为sqlserver）"&vbcrlf& _
	"databaseServer="""&getForm("databaseserver","post")&"""  'sqlserver数据库地址"&vbcrlf& _
	"databaseName="""&getForm("databasename","post")&"""  'sqlserver数据库名称"&vbcrlf& _
	"tableUser="""&getForm("tableuser","post")&"""  'sqlserver表所属用户"&vbcrlf& _
	"databaseUser="""&getForm("databaseuser","post")&"""  'sqlserver数据库账号"&vbcrlf& _
	"databasepwd="""&getForm("databasepwd","post")&"""  'sqlserver数据库密码"&vbcrlf& _
	"accessFilePath="""&getForm("accessfilepath","post")&"""  'access数据库文件路径(站点在根目录为:/inc/datas.asp；二级目录为：/二级目录名/inc/datas.asp）"&vbcrlf& _
	"templateFileFolder="""&getForm("templatefilefolder","post")&""""&vbcrlf& _
	"defaultTemplate="""&getForm("defaulttemplate","post")&""""&vbcrlf& _
	"gbookStart="&getForm("gbookStart","post")&vbcrlf& _
	"commentStart="&getForm("commentStart","post")&vbcrlf& _
	"cacheStart="&getForm("cachestart","post")&vbcrlf& _
	"siteMode="""&getForm("sitemode","post")&""""&vbcrlf& _
	"cacheTime="&getForm("cachetime","post")&vbcrlf& _
	"cacheFlag=""C"&cacheFlagValue&"_"""&vbcrlf& _
	"IsCacheSearch="&Cint(getForm("IsCacheSearch","post"))&vbcrlf& _
	"CacheSearchTime="&Cint(getForm("CacheSearchTime","post"))&vbcrlf&vbcrlf
'视频
	configStr=configStr&"Dim runMode,fileSuffix,makeMode,ismakeplay,makeTimeSpan,md5Content,channelDirName1,contentDirName1,playDirName1,channelPageName2,contentPageName2,playPageName2,channelDirName3,contentDirName3,playDirName3,channelPageName3,contentPageName3,playPageName3,channelpagename4,contentpagename4,playPageName4,channelDirName4,contentDirName4,playDirName4,topicDirName,topicPageDirName,topicDirName4,topicPageDirName4,paramset,paramid,parampage,paramindex"&vbcrlf& _
	"runMode="""&getForm("runmode","post")&""""&vbcrlf& _
	"fileSuffix="""&getForm("filesuffix","post")&""""&vbcrlf& _
	"makeMode="""&getForm("makemode","post")&""""&vbcrlf& _
	"makeTimeSpan="&Clng(getForm("maketimespan","post"))&vbcrlf& _
	"md5Content="""&getForm("md5Content","post")&""""&vbcrlf& _
	"ismakeplay="&getForm("ismakeplay","post")&""&vbcrlf& _
	"channelDirName1="""&getForm("channeldirname1","post")&""""&vbcrlf& _
	"contentDirName1="""&getForm("contentdirname1","post")&""""&vbcrlf& _
	"playDirName1="""&getForm("playdirname1","post")&""""&vbcrlf& _
	"channelPageName2="""&getForm("channelpagename2","post")&""""&vbcrlf& _
	"contentPageName2="""&getForm("contentpagename2","post")&""""&vbcrlf& _
	"playPageName2="""&getForm("playpagename2","post")&""""&vbcrlf& _
	"channelDirName3="""&getForm("channeldirname3","post")&""""&vbcrlf& _
	"contentDirName3="""&getForm("contentdirname3","post")&""""&vbcrlf& _
	"playDirName3="""&getForm("playdirname3","post")&""""&vbcrlf& _
	"channelPageName3="""&getForm("channelpagename3","post")&""""&vbcrlf& _
	"contentPageName3="""&getForm("contentpagename3","post")&""""&vbcrlf& _
	"playPageName3="""&getForm("playpagename3","post")&""""&vbcrlf& _
	"channelpagename4="""&getForm("channelpagename4","post")&""""&vbcrlf& _
	"contentpagename4="""&getForm("contentpagename4","post")&""""&vbcrlf& _
	"playPageName4="""&getForm("playpagename4","post")&""""&vbcrlf& _
	"channelDirName4="""&getForm("channeldirname4","post")&""""&vbcrlf& _
	"contentDirName4="""&getForm("contentdirname4","post")&""""&vbcrlf& _
	"playDirName4="""&getForm("playdirname4","post")&""""&vbcrlf& _
	"topicDirName="""&getForm("topicdirname","post")&""""&vbcrlf& _
	"topicPageDirName="""&getForm("topicpagedirname","post")&""""&vbcrlf& _
	"topicDirName4="""&getForm("topicdirname","post")&""""&vbcrlf& _
	"topicpageDirName4="""&getForm("topicpagedirname","post")&""""&vbcrlf& _
	"paramset="&getForm("paramset","post")&""&vbcrlf& _
	"paramid="""&getForm("paramid","post")&""""&vbcrlf& _
	"parampage="""&getForm("parampage","post")&""""&vbcrlf& _
	"paramindex="""&getForm("paramindex","post")&""""&vbcrlf&vbcrlf
'新闻
	configStr=configStr&"Dim newsRunMode,newsFileSuffix,newsMakeMode,newsMakeTimeSpan,newsmd5Content,newsDirName1,partDirName1,articleDirName1,newsDirName2,newspagename2,partPageName2,articlePageName2,newsdirname3,partDirName3,articleDirName3,newsPageName3,partPageName3,articlePageName3,newsPageName4,partpagename4,articlepagename4,newsDirName4,partDirName4,articleDirName4,newsparamset,newsparamid,newsparampage,newsparamindex"&vbcrlf& _
	"newsRunMode="""&getForm("newsrunmode","post")&""""&vbcrlf& _
	"newsFileSuffix="""&getForm("newsfilesuffix","post")&""""&vbcrlf& _
	"newsMakeMode="""&getForm("newsmakemode","post")&""""&vbcrlf& _
	"newsMakeTimeSpan="&Clng(getForm("newsmaketimespan","post"))&vbcrlf& _
	"newsmd5Content="""&getForm("newsmd5Content","post")&""""&vbcrlf& _
	"newsDirName1="""&getForm("newsdirname1","post")&""""&vbcrlf& _
	"partDirName1="""&getForm("partdirname1","post")&""""&vbcrlf& _
	"articleDirName1="""&getForm("articledirname1","post")&""""&vbcrlf& _
	"newsDirName2="""&getForm("newsdirname2","post")&""""&vbcrlf& _
	"newsPageName2="""&getForm("newspagename2","post")&""""&vbcrlf& _
	"partPageName2="""&getForm("partpagename2","post")&""""&vbcrlf& _
	"articlePageName2="""&getForm("articlepagename2","post")&""""&vbcrlf& _
	"newsDirName3="""&getForm("newsdirname3","post")&""""&vbcrlf& _
	"partDirName3="""&getForm("partdirname3","post")&""""&vbcrlf& _
	"articleDirName3="""&getForm("articledirname3","post")&""""&vbcrlf& _
	"newsPageName3="""&getForm("newspagename3","post")&""""&vbcrlf& _
	"partPageName3="""&getForm("partpagename3","post")&""""&vbcrlf& _
	"articlePageName3="""&getForm("articlepagename3","post")&""""&vbcrlf& _
	"newsPageName4="""&getForm("newspagename4","post")&""""&vbcrlf& _
	"partpagename4="""&getForm("partpagename4","post")&""""&vbcrlf& _
	"articlepagename4="""&getForm("articlepagename4","post")&""""&vbcrlf& _
	"newsDirName4="""&getForm("newsdirname4","post")&""""&vbcrlf& _
	"partDirName4="""&getForm("partdirname4","post")&""""&vbcrlf& _
	"articleDirName4="""&getForm("articledirname4","post")&""""&vbcrlf& _
	"newsparamset="&getForm("newsparamset","post")&""&vbcrlf& _
	"newsparamid="""&getForm("newsparamid","post")&""""&vbcrlf& _
	"newsparampage="""&getForm("newsparampage","post")&""""&vbcrlf& _
	"newsparamindex="""&getForm("newsparamindex","post")&""""&vbcrlf&vbcrlf
'其它
	configStr=configStr&"Dim waterMark,waterMarkFont,waterMarkLocation,sitePic,siteAd,siteVisiteJs,siteKeyWords,siteNotice,siteDes,gatherSet,isAlertWin,alertWinW,alertWinH,isAutoCheck,commentTime,gbookTime,gbookUser,gbookPwd,dirtyWords,allowAutoGather,BanWords,isfromsort,banIPS,copyRight"&vbcrlf& _
	"waterMark="&getForm("watermark","post")&vbcrlf& _
	"waterMarkFont="""&replaceStr(getForm("waterMarkFont","post"),"""","'")&""""&vbcrlf& _
	"waterMarkLocation="""&getForm("waterlocation","post")&""""&vbcrlf& _
	"sitePic="""&getForm("sitepic","post")&""""&vbcrlf& _
	"siteAd="""&getForm("sitegg","post")&""""&vbcrlf& _
	"siteVisiteJs="""&replaceStr(getForm("sitevisiteJs","post"),"""","'")&""""&vbcrlf& _
	"siteKeyWords="""&replaceStr(getForm("sitekeywords","post"),"""","'")&""""&vbcrlf& _
	"siteNotice="""&replaceStr(codeTextarea(getForm("sitenotice","post"),"en"),"""","""""")&""""&vbcrlf& _
	"siteDes="""&replaceStr(codeTextarea(getForm("sitedes","post"),"en"),"""","""""")&""""&vbcrlf& _
	"gatherSet="&getForm("gatherset","post")&""&vbcrlf& _
	"isAlertWin="&getForm("isalertwin","post")&""&vbcrlf& _
	"alertWinW="&getForm("alertwinw","post")&""&vbcrlf& _
	"alertWinH="&getForm("alertwinh","post")&""&vbcrlf& _
	"isAutoCheck="&getForm("isAutoCheck","post")&""&vbcrlf& _
	"commentTime="&getForm("commentTime","post")&""&vbcrlf& _
	"gbookTime="&getForm("gbookTime","post")&""&vbcrlf& _
	"gbookUser="""&getForm("gbookUser","post")&""""&vbcrlf& _
	"gbookPwd="""&getForm("gbookPwd","post")&""""&vbcrlf& _
	"dirtyWords="""&ReplaceStr(getForm("dirtyWords","post"),"""","")&""""&vbcrlf& _
	"allowAutoGather="&getForm("allowAutoGather","post")&vbcrlf& _
	"BanWords="""&ReplaceStr(getForm("BanWords","post"),"""","")&""""&vbcrlf& _
	"isfromsort="&getForm("isfromsort","post")&""&vbcrlf& _
	"banIPS="""&ReplaceStr(getForm("BanIPS","post"),"""","")&""""&vbcrlf& _
	"copyRight="""&replaceStr(codeTextarea(getForm("copyright","post"),"en"),"""","""""")&""""
	autoMoveFolder
	createTextFile "<"&"%"&vbcrlf&configStr&vbcrlf&"%"&">","../inc/config.asp",""
	goPlayerEdit
	cacheObj.clearAll
	alertMsg "配置修改成功","admin_config.asp" 
End Sub

Sub goPlayerEdit
	dim isalertwin_old:isalertwin_old=getForm("isalertwin_old","post")
	dim isalertwin:isalertwin=getForm("isalertwin","post")
	if isalertwin_old<>isalertwin then response.Redirect("admin_player.asp?action=modifyalert&alert="&isalertwin)
End Sub

Sub autoMoveFolder
	dim moveType : moveType=getForm("runmode","post")
	dim moveType2 : moveType2=getForm("makemode","post")
	dim dir_channel,dir_content,dir_play,dir_topic,dir_topicpage,dir_news,dir_part,dir_article,x,y,z
	dir_topic=getForm("topicdirname","post"):dir_topicpage=getForm("topicpagedirname","post"):if isNul(dir_topic) then alertMsg "专题目录名不能为空","javascript:history.go(-1);":die ""
	if topicDirName<>dir_topic then moveFolder "../"&topicDirName&"/","../"&dir_topic&"/"
	if topicpageDirName<>dir_topicpage then moveFolder "../"&topicpageDirName&"/","../"&dir_topicpage&"/"
	select case moveType
		case "dynamic"
			dir_channel=getForm("channeldirname1","post"):if isNul(dir_channel) then alertMsg "栏目页目录名不能为空","javascript:history.go(-1);":die ""
			dir_content=getForm("contentdirname1","post"):if isNul(dir_content) then alertMsg "内容页目录名不能为空","javascript:history.go(-1);":die ""
			dir_play=getForm("playdirname1","post"):if isNul(dir_play) then alertMsg "播放页目录名不能为空","javascript:history.go(-1);":die ""

			dir_news=getForm("newsdirname1","post"):if isNul(dir_news) then alertMsg "新闻主目录名不能为空","javascript:history.go(-1);":die ""
			dir_part=getForm("partdirname1","post"):if isNul(dir_part) then alertMsg "栏目页目录名不能为空","javascript:history.go(-1);":die ""
			dir_article=getForm("articledirname1","post"):if isNul(dir_article) then alertMsg "文章页目录名不能为空","javascript:history.go(-1);":die ""

			if isEqualOther(dir_channel&"|"&dir_content&"|"&dir_play&"|"&dir_topic&"|"&dir_topicpage&"|"&dir_news&"|"&dir_part&"|"&dir_article) then alertMsg "视频和新闻目录名不能存在雷同","javascript:history.go(-1);":die ""

			if channelDirName1<>dir_channel then moveFolder "../"&channelDirName1&"/","../"&dir_channel&"/"
			if contentDirName1<>dir_content then moveFolder "../"&contentDirName1&"/","../"&dir_content&"/"
			if playDirName1<>dir_play then moveFolder "../"&playDirName1&"/","../"&dir_play&"/"

			if newsDirName1<>dir_news then moveFolder "../"&newsDirName1&"/","../"&dir_news&"/"
			if partDirName1<>dir_part then moveFolder "../"&partDirName1&"/","../"&dir_part&"/"
			if articleDirName1<>dir_article then moveFolder "../"&articleDirName1&"/","../"&dir_article&"/"
		case "static"
			if Instr("dir2,dir4,dir6,dir8,",moveType2&",") then
				dir_channel=getForm("channeldirname3","post"):if isNul(dir_channel) then alertMsg "栏目页目录名不能为空","javascript:history.go(-1);":die ""
				dir_content=getForm("contentdirname3","post"):if isNul(dir_content) then alertMsg "内容页目录名不能为空","javascript:history.go(-1);":die ""
				dir_play=getForm("playdirname3","post"):if isNul(dir_play) then alertMsg "播放页目录名不能为空","javascript:history.go(-1);":die ""

				dir_news=getForm("newsdirname3","post"):if isNul(dir_news) then alertMsg "新闻主目录名不能为空","javascript:history.go(-1);":die ""
				dir_part=getForm("partDirName3","post"):if isNul(dir_part) then alertMsg "栏目页目录名不能为空","javascript:history.go(-1);":die ""
				dir_article=getForm("articledirname3","post"):if isNul(dir_article) then alertMsg "文章页目录名不能为空","javascript:history.go(-1);":die ""

				if isEqualOther(dir_channel&"|"&dir_content&"|"&dir_play&"|"&dir_topic&"|"&dir_topicpage&"|"&dir_news&"|"&dir_part&"|"&dir_article) then alertMsg "视频和新闻目录名不能存在雷同","javascript:history.go(-1);":die ""
			end if
	end select
	x=getForm("templatefilefolder","post"):y=getForm("sitepic","post"):z=getForm("sitegg","post")
	if isNul(x) then alertMsg "模板文件所在文件夹不能为空","javascript:history.go(-1);":die ""
	if isNul(y) then alertMsg "图片文件夹不能为空","javascript:history.go(-1);":die ""
	if isNul(z) then alertMsg "JS广告文件夹不能为空","javascript:history.go(-1);":die ""
	if x<>templateFileFolder then moveFolder "../template/"&defaultTemplate&"/"&templateFileFolder&"/","../template/"&defaultTemplate&"/"&x&"/"
	if y<>sitePic then moveFolder "../pic/"&sitePic&"/","../pic/"&y&"/"
	if z<>siteAd then moveFolder "../js/"&siteAd&"/","../js/"&z&"/"
End Sub

Sub  checkIsSelected(str1,str2)
	if str1=str2 then echo "selected" else echo ""
End Sub

Function isEqualOther(str)
	dim strlen,i,strArray:strArray=split(str,"|"):strlen=ubound(strArray)
	isEqualOther=false
	for i=0 to strlen
		if ubound(split("|"&str&"|","|"&strArray(i)&"|"))>1 then isEqualOther=true:Exit Function
	next
End Function

Sub clearSearch
	on error resume next
	If isExistFolder(SearchCacheDir)=True Then  
		objFso.DeleteFolder(server.mappath(SearchCacheDir)) 
		if Err then
			alertMsg "清空缓存目录失败："&err.description,"admin_config.asp"
			Err.clear:die ""
		end if
	end if
	alertMsg "清空缓存目录成功","admin_config.asp"
End Sub
%>