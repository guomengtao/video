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
dim action,url,xmlobj,gHttpObj,result
checkPower
response.Charset = "gbk"
server.scripttimeout=99999
action = getForm("action", "get") : url=getForm("url","get")
Select  case action
	case "gather"
		gather : if err then echo "err"
End Select
terminateAllObjects

Sub gather
	set xmlobj = mainClassobj.createObject("MainClass.Xml")
	if isNul(url) then die ""
	'on error resume next
	if instr(url,"youku.com")>0 then gatherYouku url
	if instr(url,"www.tudou.com")>0 then gatherTudou url
	if instr(url,"hd.tudou.com")>0 then gatherTudouHd url
	if instr(url,"you.video.sina.com.cn")>0 OR instr(url,"video.sina.com.cn")>0 then gatherSina url
	if instr(url,"movie.video.sina.com.cn")>0 then gatherSinaHd url
	if instr(url,"hd.openv.com")>0 then gatherOpenvHd url
	if instr(url,"v.blog.sohu.com")>0 OR  instr(url,"my.tv.sohu.com")>0 then
		gatherSohu url
	elseif instr(url,"tv.sohu.com")>0 then
		gatherSohuHd url
	end if
	if instr(url,"www.56.com")>0 then gather56 url
	if instr(url,"tv.56.com")>0 then gather56Hd url
	if instr(url,"video.qq.com")>0 then gatherQQ url
	if instr(url,"6.cn")>0 then gather6Room url
	if instr(url,"youtube.com")>0 then gatherYouTuBe url
	if instr(url,"hd.ku6.com")>0 then gatherKu6Hd url
	if instr(url,"v.ku6.com")>0 then gatherKu6 url
	if instr(url,"joy.cn")>0 then gatherJoy url
	if instr(url,"qiyi.com")>0 then gatherQiyi url
	if ""&result="" then gatherCC url
	set xmlobj=nothing
	err.clear
	echo result
End Sub

Sub gatherYouTuBe(url)
	dim title,id,pageStr
	id=StrSlice(url&"&","v=","&")
	pageStr = getRemoteContent(url,"text")	
	title=StrSlice(pageStr,"<title>YouTube - ","</title>")
	result = title&"$"&id&"$youtube"
End Sub

Sub gatherQQ(url)
	dim purl,itemCount,i,pageStr,title,id,regObj,match,matches,vid,pcount
	if instr(url,"group?g")>0 then
		vid = subStr(url&"#","g=","#")
		pageStr = getRemoteContent(url,"text")
		itemCount = subStr(pageStr,"专辑所有视频<font>(",")")
		if itemCount <= 10 then 
			pcount = 1
		else
			if itemCount mod 10 = 0 then pcount = clng(itemCount / 10) else pcount = clng((itemCount) / 10 ) + 1
		end if
		for i = 1 to itemCount
			if IsConnected=false then exit for
			purl = "http://video.qq.com/v1/group/video?p="&i&"&g="&vid
			pageStr = getRemoteContent(purl,"text")				
			set regObj = New regExp : regObj.Global = true
			regObj.Pattern = "<a onClick=""playVideo\('(.+?)'\)"">(.+?)</a>" : set matches = regObj.Execute(pageStr)
			for each match in matches
				result = result&match.SubMatches(1)&"$"&match.SubMatches(0)&"$qq"&vbcrlf
			next
		next
	else
		pageStr = getRemoteContent(url,"text")	
		title=StrSlice(pageStr,"vp_title=""视频：","""")
		id=StrSlice(pageStr,"vp_vid=""","""")
		result = title&"$"&id&"$qq"
	end if
End Sub

Sub gather56(url)
	dim allstr,pageurl,id,idArray,title,vid,substring1,paras
	if inStr(url,"/album")>0 then
		substring1 = StrSlice(url,"http://","album")
		vid=StrSlice(url,"-aid-",".")
		dim regObj,match,matches,playurl : set regObj = New RegExp
		regObj.ignoreCase = true : regObj.Global = true
		playurl = "http://"&substring1&"album_v2/album_videolist.phtml?callback=albumV2.callback&aid="&vid&"&o=0"
		allstr = bytesToStr(getRemoteContent(playurl,"body"),"gbk")
		regObj.Pattern = """video_id"":""(.+?)"",""video_title"":""(.+?)""" : set matches = regObj.Execute(allstr)
		for each match in matches
			result = result&match.SubMatches(1)&"$"&match.SubMatches(0)&"$hd_56"&vbcrlf
		next
		result = trimOuterStr(result,vbcrlf)
	elseif inStr(url,"/play_album-")>0 then
		allstr = GetHttpTextFile(url,"utf-8")
		paras =  StrSlice(allstr,"img_host=","'")
		title = trim(StrSlice(allstr,"tit=","&"))
		result = result&title&"$"&StrSlice(paras,"&vid=","&")&"$hd_56"&vbcrlf
	else
		allstr = GetHttpTextFile(url,"utf-8")
		title = trim(decodeSohu(StrSlice(allstr,"""Subject"":""","""")))
		id=StrSlice(url,"/v_",".html")
		if id<>"" then
			result = title&"$"&id&"$hd_56"
		else
			id = StrSlice(allstr,"var _oFlv_o = '","'")
			result = title&"$"&de56(id)&"$hd_56"
		end if
	end if
End Sub

Sub gather56Hd(url)
	dim pageStr,id,title,itemCount,i,vPageStr,playlistid,pageurl,paras,title2
	dim regObj,match,matches,playurl : set regObj = New RegExp
	regObj.ignoreCase = true : regObj.Global = true
	pageStr = bytesToStr(getRemoteContent(url,"body"),"gbk")
	regObj.Pattern = "<li><a href=""(.+?)"">(.+?)</a></li>" : set matches = regObj.Execute(pageStr)
	for each match in matches
		if IsConnected=false then exit for
		title = match.SubMatches(1)
		pageurl = match.SubMatches(0)
		pageStr = bytesToStr(getRemoteContent(pageurl,"body"),"gbk")
		title2 = StrSlice(pageStr,"<title>","-")
		title = replace(title,"【播放】",title2)
		paras = StrSlice(pageStr,"flashvars=""img_host=","""")
		id = StrSlice(paras,"host=",".")&"_/"&StrSlice(paras,"pURL=","&")&"_/"&StrSlice(paras,"sURL=","&")&"_/"&StrSlice(paras,"user=","&")&"_/"&StrSlice(paras,"URLid=","&")
		result = result&title&"$"&id&"$hd_56"&vbcrlf
	next
	result = trimOuterStr(result,vbcrlf)
End Sub

Function getTudouHdPage(vid)
	dim i,pagestr,pagestr2,pageurl
	pageurl = "http://hd.tudou.com/ajax/albumVideos.html?videoId="&vid&"&pageNumer="
	for i = 1 to 20
		if IsConnected=false then exit for
		pagestr = left(getRemoteContent(pageurl&i,"text"),100) : pagestr2 = left(getRemoteContent(pageurl&(i+1),"text"),100)
		if pagestr = pagestr2 then  getTudouHdPage=i : Exit Function
	next
End Function

Sub gatherTudouHd(url)
	dim pageStr,id,title,itemCount,i,vPageStr,playlistid,pagenum,pageurl
	playlistid = StrSlice(url&"/","program/","/")
	pagenum = getTudouHdPage(playlistid)
	dim regObj,match,matches,playurl : set regObj = New RegExp
	regObj.ignoreCase = true : regObj.Global = true
	for i=1 to pagenum
		pageStr = getRemoteContent("http://hd.tudou.com/ajax/albumVideos.html?videoId="&playlistid&"&pageNumer="&i,"text")
		regObj.Pattern = "<a href=""(.+?)""" : set matches = regObj.Execute(pageStr)
		for each match in matches
			if IsConnected=false then exit for
			pageurl = "http://hd.tudou.com"&match.SubMatches(0)
			pageStr = getRemoteContent(pageurl,"text")
			id = StrSlice(pageStr,"iid: ""","""") : title = StrSlice(pageStr,"title: ""","""")
			result = result&title&"$"&id&"$hd_tudou"&vbcrlf
		next
	next
	result = trimOuterStr(result,vbcrlf)
End Sub

Sub gatherSohuHd(url)
	dim pageStr,id,title,itemCount,i,topicId,vPageStr,playlistid
	pageStr = bytesToStr(getRemoteContent(url,"body"),"gbk")
	result=gatherSohuHdPlay(pageStr)
	if instr(pageStr,"<div id=""roll"" class=""area"">")>0 then
		playlistid = split(result,"$")(1)
		result = ""
		pageStr = bytesToStr(getRemoteContent("http://hot.vrs.sohu.com/vrs_videolist.action?vid="&playlistid,"body"),"gbk")
		dim regObj,match,matches,pattern,playurl : set regObj = New RegExp
		regObj.ignoreCase = true : regObj.Global = true
		pattern = """videoName"":""([\s\S]+?)"".+?""videoId"":(\d+?),"""
		regObj.Pattern = pattern : set matches = regObj.Execute(pageStr)
		for each match in matches
			id = match.SubMatches(1)
			title = match.SubMatches(0)
			result = result&title&"$"&id&"$hd_sohu"&vbcrlf
		next
		result = trimOuterStr(result,vbcrlf)
	else
		result=result
	end if
End Sub

Function gatherSohuHdPlay(pageStr)
	dim id,title
	id=StrSlice(pageStr,"var vid=""","""")
	if id="" then id=StrSlice(allstr,"var _videoId = ",";")
	title=StrSlice(allstr,"<h3 id=""titleEle"">","</h3>")
	'title=StrSlice(allstr,"<title>","</title>"):title=replace(replace(left(title,instr(title,"-搜狐视频")-1),"《",""),"》","")
	gatherSohuHdPlay=title&"$"&id&"$hd_sohu"
End Function

Sub gatherOpenvHd(url)
	dim pageStr,id,title,itemCount,i,topicId,vPageStr
	if instr(url,"/tv_show")>0 then 
		pageStr = getRemoteContent(url,"text")
		dim regObj,match,matches,pattern,playurl : set regObj = New RegExp
		regObj.ignoreCase = true : regObj.Global = true
		pattern = "<li><a href=""(.+?)"">(.+?)</a></li>"
		regObj.Pattern = pattern
		if  not regObj.Test(pageStr) then regObj.Pattern = "<a class=""alink""[\s]href=""tv_play-(\S+?)html"">(.+?)</a>"
		set matches = regObj.Execute(pageStr)
		for each match in matches
			If InStr(match.SubMatches(0),"cartoon")>0 Then 
				id = "hdcartoon_"&StrSlice(match.SubMatches(0),"n_",".")
			elseif InStr(match.SubMatches(0),"hddoc_")>0 Then 
				id = "hddoc_"&StrSlice(match.SubMatches(0),"c_",".")
			Else 
				id = "hdteleplay_"&StrSlice(match.SubMatches(0),"y_",".")
			End If 
			title = match.SubMatches(1)
			result = result&title&"$"&id&"$hd_openv"&vbcrlf
		next
		result = trimOuterStr(result,vbcrlf)
	else
		result=gatherOpenvHdPlay(url)
	end if
End Sub

Function gatherOpenvHdPlay(url)
	dim pageStr,id,title
	pageStr = getRemoteContent(url,"text")
	If InStr(url,"clips")>0 Then 
		id="hdmovieclips_"&StrSlice(url,"s_",".")
		title=StrSlice(pageStr,"<title>","</title>") : title=left(title,instr(title,"-高清电影")-1)
	elseif InStr(url,"prog_")>0 Then
		id="CTIYuLeprog_"&StrSlice(url,"g_",".")
		title=StrSlice(pageStr,"<title>","</title>") : title=left(title,instr(title,"-高清电视节目")-1) 
	Else 
		id="hdmovie_"&StrSlice(url,"e_",".")
		title=StrSlice(pageStr,"<title>","</title>") : title=left(title,instr(title,"-高清电影")-1)
	End If 
	gatherOpenvHdPlay=title&"$"&id&"$hd_openv"
End Function

Function gatherSinaHdPlay(url)
	dim allstr,id,title
	allstr = GetHttpTextFile(url,"utf-8")
	id=StrSlice(allstr,"vid:'","'")
	title=StrSlice(allstr,"episode:'","'")
	gatherSinaHdPlay="第"&title&"集"&"$"&id&"$hd_iask"
End Function

Sub gatherSinaHd(url)
	dim allstr,id,i,x,y,getstr
	if Instr(url,"/movie/detail/")>0 then  '判断url里有没有 /movie/detail/  这个字符串 有就等于0，没有返回0
		allstr = GetHttpTextFile(url,"utf-8"):getstr=StrSlice(allstr,"分集点播 begin","分集点播 end")
		x=paseAbsURI(StrSplits(getstr,"<div class=""pic""><a href=""",""""),url)
		for i=0 to UBound(x)
			x(i)=gatherSinaHdPlay(x(i))
		next
		result = Join(x,vbcrlf)
	end if
End Sub

Sub gatherSina(url)
	dim sinaUrl,allVideos,allstr,pages,i,regObj,match,matches,j,url1,url2,paraArray,title,id
	url=ReplaceStr(url,"/playlist/","/a/")
	if Instr(url,"/movie/detail/")>0 then
		gatherSinaHd(url)
	elseif Instr(url,"/m/")>0 and Instr(url,"/m/2")=0 then
		result=gatherSinaHdPlay(url)
	elseif instr(url,"/a/")>0 then
		paraArray = split(StrSlice(url,"/a/",".html"),"-")
		url1="http://you.video.sina.com.cn/api/catevideoList.php?uid="&paraArray(1)&"&tid="&paraArray(0)
		allstr = left(getRemoteContent(url1,"text"),40)
		allVideos = regexFind(allstr,""":{""count"":""(\d+)"",?")
		url2=url1&"&pagesize="&allVideos
		allstr = getRemoteContent(url2,"text")
		set regObj = New regExp : regObj.Global = true
		regObj.Pattern = """vid"":""(\d+?)"",""uid"":""(\d+?)"",""nick"":"".+?"",""name"":""(.+?)""," : set matches = regObj.Execute(allstr)
		for each match in matches
			on error resume next
			result = result & decodeSohu(match.SubMatches(2))&"$"&match.SubMatches(0)&"&uid="&match.SubMatches(1)&"$iask"&vbcrlf
			if err then exit for : err.clear
		next
	elseif instr(url,"/p/")>0 then
		allstr=GetHttpTextFile(url,"utf-8")
		title=StrSlice(allstr,"<title>","</title>")
		id=StrSlice(allstr,"vid :'","'")
		result = title&"$"&id&"$iask"&vbcrlf
	elseif instr(url,"/v/b/")>0 then
		paraArray = split(StrSlice(url,"/v/b/",".html"),"-")
		url1=url'"http://rv.sinajs.cn/related_video?key="&paraArray(0)&"_"&paraArray(1)&"&show=18&varname=interfix.relaVideoJson&rad=1276408261264"
		allstr = StrSlice(GetHttpTextFile(url1,"utf-8"),"<div id=""Interfix"">","</ul>")
		matches=strSplits(allstr,"<a class=""plicon"" href=""/v/b/",".html"""):match=strSplits(allstr," alt=""","""")
		for i=0 to UBound(matches)
			result = result & match(i)&"$"&replace(matches(i),"-","&uid=")&"$iask"&vbcrlf
		next
	elseif instr(url,"/pg/")>0 then
		allstr = getRemoteContent(url,"text")	
		pages=StrSlice(allstr,"var scope","}"):pages=StrSlice(pages,"""$tid"":""","""")&"&uid="&StrSlice(pages,"""$uid"":""","""")
		if pages<>"&uid=" then
			url="http://you.video.sina.com.cn/api/catevideoList.php?tid="&pages&"&page=1&pagesize=1000"
			allstr=GetHTTPTextFile(url,"utf-8")
			set regObj = New regExp : regObj.Global = true
			regObj.Pattern = """vid"":""(\d+?)"",""uid"":""(\d+?)"",""nick"":"".+?"",""name"":""(.+?)""," : set matches = regObj.Execute(allstr)
			for each match in matches
				on error resume next
				result = result & decodeSohu(match.SubMatches(2))&"$"&match.SubMatches(0)&"&uid="&match.SubMatches(1)&"$iask"&vbcrlf
				if err then exit for : err.clear
			next
		end if
	else
		allstr = getRemoteContent(url,"text")
		result = regexFind(allstr,"<title>([\s\S]*?)_")&"$"&StrSlice(url,"/b/","-")&"&uid="&StrSlice(url,"-",".html")&"$iask"
	end if
	if right(result,1)=vbcrlf then result=left(result,len(result)-1)
End Sub

Sub gatherCC(url)
	dim allstr,id,title
	allstr=GetHttpTextFile(url,"utf-8")
	title=StrSlice(allstr,"<title>","</title>")
	id=regexFind(allstr,"vid\s*=\s*(\w+)")
	result = title&"$"&id&"$cc"
End Sub

Sub gatherYoukuTV(url)
	dim allstr,id,tmp,itemCount,i,getstr,getname
	id=StrSlice(url,"id_",".html")
	if id<>"" then
		allstr=GetHttpTextFile(url,"utf-8")
		if Instr(allstr,"剧集列表")<1 then
		'/show_page/id_
			id=StrSlice(StrSlice(allstr,"<span class=""action"">","</a>"),"/v_show/id_",".html")
			result=StrSlice(allstr,"<span class=""name"">","</span>")&"$"&id&"$youku"
		else
			url="/show_eplist/showid_"&id&"_type_pic_from_ajax_page_1.html"
			while Instr(url,"_type_pic_from_ajax_page_")>0
				tmp=GetHttpTextFile("http://www.youku.com" & url,"utf-8"):getstr =getstr & tmp
				url=trim(StrSlice(tmp,"<li class=""next"" title=""下一页""><a onclick=""nova_update('eplist',this.href);return false;"" href=""",""""))
			wend
			getname=StrSplits(getstr,"alt=""",""""):getstr=StrSplits(getstr,"v_show/id_",".html")
			getstr=array_unique(getstr):ReDim Preserve getname(Ubound(getstr))
			for i=0 to UBound(getstr)
				if getname(i)="" then getname(i)="第"&ifthen(i>8,"","0")&(i+1)&"集" else getname(i)=mtrim(RemoveHTMLCode(getname(i),"*"))
				getstr(i)=getname(i)&"$"&getstr(i)&"$youku"
			next
			result=Join(getstr,vbcrlf)
		end if
	end if
End Sub

Sub gatherYouku(url)
	dim youkuRss,xmlstr,itemCount,i,allstr,title,id
	if instr(url,"playlist_show")>0 then
		youkuRss = "http://www.youku.com/playlist/rss/id/"&StrSlice(url,"id_",".html")
		xmlstr = bytesToStr(getRemoteContent(youkuRss,"body"),"utf-8")
		If left(xmlstr, 5) <> "<?xml" then die err_xml else xmlobj.xmlDomObj.loadXML(xmlstr)
		if xmlobj.xmlDomObj.parseError=0 then
			itemCount=xmlobj.getNodeLen("channel/item")
			for i=0 to itemCount-1
				if i=itemCount-1 then
					result = result&xmlobj.getNodeValue("item/title",i)&"$"&xmlobj.getNodeValue("item/guid",i)&"$youku"
				else
					result = result&xmlobj.getNodeValue("item/title",i)&"$"&xmlobj.getNodeValue("item/guid",i)&"$youku"&vbcrlf
				end if
			next
		else
			xmlstr=StrSliceB(xmlstr,"</image>","")
			dim getstrArray,partnames:getstrArray=StrSplits(xmlstr,"<title>","</title>"):partnames=StrSplits(xmlstr,"<guid>","</guid>")
			l=UBound(getstrArray)
			l=ifthen(l>UBound(partnames),l,UBound(partnames))
			for i=0 to l
				result = result&partnames(i)&"$"&getstrArray(i)&"$youku"&ifthen(i<l,vbcrlf,"")
			next
		end if
	elseif instr(url,"show_page")>0 then
		gatherYoukuTV(url)
	elseif instr(url,"v_show")>0 OR instr(url,"v_playlist")>0 then
		allstr = bytesToStr(getRemoteContent(url,"body"),"utf-8")
		if InStr(allstr,"<span class=""name"">")>0 then
			title=StrSlice(allstr,"<span class=""name"">","</span>")
		else
			title=Replace(StrSlice(allstr,"<title>","</title>")," ","")
			if InStr(title,"集")>3 then title=StrSliceB(title,"","集")&"集"
			if InStr(title,"-电视剧")>0 then title=StrSliceB(title,"","-电视剧")
			if InStr(title,"-视频")>0 then title=StrSliceB(title,"","-视频")
			if InStr(title,"-综艺")>0 then title=StrSliceB(title,"","-综艺")
		end if
		id=regexFind(allstr,"var\svideoId\s=\s'(\d{3,}?)';")
		result = title&"$"&id&"$youku"
	else
		'alertMsg "不支持你输入的优酷网址，请看清楚本工具下面列出来的范例",""
	end if
End Sub

Sub gatherTudou(url)
	dim tudouRss,itemCount,i,allstr,getser,title,id,r,p:url=trim(url)
	if instr(url,"/playlist/album/")>0 then
		allstr=getRemoteContent2(url,"text"):getser=StrSlice(allstr,"<div class=""pack pack_video_card""><div class=""pic"">","</div><div class=""page_nav""")
		r=StrSplits(getser,"<a target=""new"" title=""第1集"" href="" ",""""):p=StrSplits(getser,"target=""new"" title=""","""")
		if Instr(r(0),"/playlist/p/") then
			gatherTudou(r(0)):exit sub
		else
			for i=0 to UBound(r)
				r(i)=p(i)&"$"&StrSliceB(r(i),"?iid=","")&"$tudou"
			next
		end if
		result=join(r,vbcrlf)
	elseif instr(url,"playlist/playindex")>0 OR instr(url,"playlist/id/")>0 then
		if InStr(url,"playindex.do?lid=")>0 then url=Replace(url,"playindex.do?lid=","id/")
		if right(url,5)=".html" then url=Replace(Replace(url,"/playlist/id","/playlist/id/"),".html","")
		tudouRss = "http://www.tudou.com/playlist/rss.do?lid="&StrSlice(url&"/","/id/","/")
		xmlobj.load tudouRss,"xmldocument"
		itemCount=xmlobj.getNodeLen("channel/item")
		for i=0 to itemCount-1
			if i=itemCount-1 then
				result = result&xmlobj.getNodeValue("item/title",i)&"$"&xmlobj.getAttributes("tudou:info","id",i)&"$tudou"
			else
				result = result&xmlobj.getNodeValue("item/title",i)&"$"&xmlobj.getAttributes("tudou:info","id",i)&"$tudou"&vbcrlf
			end if  
		next
	elseif instr(url,"playlist/p/")>0 then
		allstr=getRemoteContent2(url,"text"):getser=strSlice(allstr,"listData = [{","}]"):title=strSlice(allstr,"<title>","_")
		r=StrSplits(getser,"iid:",","):p=StrSplits(getser,",title:""","""")
		for i=0 to UBound(r)
			'die title
			'die mtrim(r(i))
			r(i)=title&" "&p(i)&"$"&mtrim(r(i))&"$tudou"
		next
		result = join(r,vbcrlf)
	else
		allstr=getRemoteContent2(url,"text")
		title=ReplaceStr(ReplaceStr(regexFind(allstr,"kw\s*=\s*""?(([^\\][^""\r\n])+)"),"""",""),"\","") : id=regexFind(allstr,"\s+,iid\s*=\s*(\d{3,})[\r\n]")
		'die Server.HTMLENCODE(allstr)
		result = title&"$"&id&"$tudou"
	end if
End Sub

Sub gatherSohu(url)
	dim sohuDataUrl,itemCount,i,pageStr,title,id,regObj,match,matches
	if instr(url,"/pw/")>0 then
		id=subStr(url&"/","/pw/","/")
		sohuDataUrl = "http://v.blog.sohu.com/playlistVideo.jhtml?outType=3&from=2&m=viewlist&playlistId="&id&"&size=300"
		pageStr = getRemoteContent(sohuDataUrl,"text")
		set regObj = New regExp : regObj.Global = true
		regObj.Pattern = """,""id"":(\d+?),""title"":""(.*?)"",""" : set matches = regObj.Execute(pageStr)
		for each match in matches
			on error resume next
			result = result&decodeSohu(match.SubMatches(1))&"$"&match.SubMatches(0)&"$sohu"&vbcrlf
			if err then exit for : err.clear
		next
	else
		pageStr = getRemoteContent(url,"text")	
		if InStr(pageStr,"页面不存在")=0 then
			title=regexFind(pageStr,"\<title\>(.+?)\s-\s") : id=subStr(url&"/","/vw/","/")
			result = title&"$"&id&"$sohu"
		end if
	end if
	if right(result,1)=vbcrlf then result=left(result,len(result)-1)
End Sub

Sub gather6Room(url)
	dim pageStr,id,title,itemCount,i,topicId,vPageStr
	pageStr = bytesToStr(getRemoteContent(url,"body"),"utf-8")
	if instr(url,"playlist/")>0 then
		topicId=subStr(url&"/","playlist/","/")
		itemCount=regexFind(pageStr,"<em class=""hit"">([\d]+?)<\/em>")
		for i=0 to itemCount-1
			if IsConnected=false then exit for
			vPageStr=bytesToStr(getRemoteContent("http://6.cn/plist/"&topicId&"/"&i&".html","body"),"utf-8")
			id=regexFind(vPageStr,"pageMessage.evid\s*=\s*'(.+?)'\s*;")
			title=regexFind(vPageStr,"<h2 class=""pvt"">(.+?)</h2>")
			result = result&title&"$"&id&"$6rooms"&vbcrlf
		next
	else
		id=subStr(pageStr,"pageMessage.evid = '","' ;"&vbcrlf&"pageMessage.")
		title=subStr(pageStr,"<title>","</title>") : title=left(title,instr(title," - 视频")-1)
		result=title&"$"&id&"$6rooms"
	end if
	if right(result,1)=vbcrlf then result=left(result,len(result)-1)
End Sub

Sub gatherKu6Hd(url)
	dim pageStr,id,title,m,ms,rg
	pageStr = getRemoteContent(url,"text")
	if instr(pageStr,"分集：")>0 then 
		pageStr=subStr(pageStr,"分集：","</script>")
		SET rg = new RegExp:rg.Global = true:rg.pattern = "\/show\/([\w_-]+?)\.html\""[^>]*>([^<]+?)<\/a>": set ms = rg.Execute(pageStr)
		for each m in ms
			on error resume next
			result = result&m.SubMatches(1)&"$"&m.SubMatches(0)&"$ku6"&vbcrlf
			if err then exit for : err.clear
		next
	else
		id=subStr(pageStr,"{ id: """,""", uid: ")
		title=subStr(pageStr,"<title>","</title>") : title=left(title,instr(title," - 高清")-1)
		result=title&"$"&id&"$ku6"
	end if
	if right(result,1)=vbcrlf then result=left(result,len(result)-1)
End Sub

Sub gatKu6List(lid,p)
	dim allstr,url,id,title,itemCount,i,vallstr,Nn
		url="http://v.ku6.com/playlistVideo.htm?t=list&playlistId="&lid&"&p="&p&"&s=8"
		allstr = getRemoteContent(url,"text")
		itemCount=Clng(regexFind(allstr,"""count""\s*:\s*(\d+)"))
		vallstr=StrSplits(allstr,"""vid"":""",""""):Nn=StrSplits(allstr,"""title"":""","""")
		for i=0 to UBound(vallstr)
			result = result&decodeSohu(Nn(i))&"$"&decodeSohu(vallstr(i))&"$ku6"&vbcrlf
		next
		if 8*p < itemCount AND itemCount <1000 then
			p=p+1
			gatKu6List lid,p
		end if
End Sub

Sub gatherKu6(url)
	dim pageStr,id,title,itemCount,i,topicId,vPageStr
	if instr(url,"playlist/")>0 then
		topicId=StrSlice(url,"index_",".html")
		gatKu6List topicId,1
	else
		pageStr = getRemoteContent(url,"text")
		if pageStr<>"" then
			if instr(url,"playlist/")>0 then 
				'topicId=regexFind(url,"(index_[\d]+)(_[\d]+)?.html")
				'itemCount=regexFind(pageStr,topicId&"_(\d+)\.html\"">末页<\/a>")+1
				'dim rg,m,ms : set rg = New RegExp:rg.ignoreCase=true:rg.Global=true
				'rg.Pattern = "title=\""([^\""]+?)\""\shref=\""[^\""]+/([^\""]+?)\.html\""><img"
				'for i=1 to itemCount-1
				'	vPageStr=getRemoteContent("http://v.ku6.com/playlist/"&topicId&"_"&i&".html","text")
				'	vPageStr = substr(vPageStr,"<div class=""innerViewLeft"">","</div>")
				'	set ms = rg.Execute(vPageStr)
				'	for each m in ms
				'		on error resume next
				'		result = result&m.SubMatches(0)&"$"&m.SubMatches(1)&"$ku6"&vbcrlf
				'		if err then exit for : err.clear
				'	next
				'next
			else
				id=regexFind(pageStr,"\"",\s*id\s*:\s*\""(.+)\"",\s*uid:")
				title=StrSlice(pageStr,"<title>","</title>") : title=left(title,instr(title," 在线观看")-1)
				result=title&"$"&id&"$ku6"
			end if
		end if
	end if
	if right(result,1)=vbcrlf then result=left(result,len(result)-1)
End Sub

Sub gatherJoy(url)
	dim allstr,title,id,i,lid,x,l
	if Instr(LCase(url),"/album/")>0 then
		lid=StrSlice(url,"/album/","/")
		if not isNum(lid) then lid=StrSlice(url,"/album/",".htm")
		if not isNum(lid) then die "无法识别的lid"
		allstr = GetHttpTextFile("http://you.joy.cn/play.do?method=albumvideolist&id="&lid&"&sort=","utf-8")
		x=StrSplits(allstr,ifthen(Instr(allstr,"""playUrl"": """)>0,"""playUrl"": ""","""playUrl"":"""),""""):l=UBound(x)
		for i=0 to l
			gatherJoy(x(i))
		next
	elseif Instr(LCase(url),"/tvplay/")>0 OR Instr(LCase(url),"/teleplay/detail/")>0 then
		lid=StrSlice(url,"/tvplay/","/")
		if not isNum(lid) then lid=StrSlice(url,"/tvplay/",".htm")
		if not isNum(lid) then lid=StrSlice(url,"/teleplay/detail/",".htm")
		if not isNum(lid) then lid=StrSlice(url,"/teleplay/detail/","/")
		if not isNum(lid) then die "无法识别的tvid"
		allstr = GetHttpTextFile(url,"utf-8")
		title=StrSlice(allstr,"<h1 title=""",""""):x=StrSplits(allstr,"videoId:""",""""):l=UBound(x)
		if l=0 then
			result= title & " 全集$2_2_1_57_"&lid&"_"&x(0)&"$joy"
		else
			for i=0 to l
				result= result&ifthen(result<>"",vbcrlf,"") & "第"& ifthen(i<9,"0","")& (i+1) & "集 "& title &"$2_2_1_57_"&lid&"_"&x(i)&"$joy"
			next
		end if
	elseif Instr(LCase(url),"/movie/")>0 OR Instr(LCase(url),"/movie/detail/")>0 then
		lid=StrSlice(url,"/movie/","/")
		if not isNum(lid) then lid=StrSlice(url,"/movie/",".htm")
		if not isNum(lid) then lid=StrSlice(url,"/movie/detail/",".htm")
		if not isNum(lid) then die "无法识别的tvid"
		allstr = GetHttpTextFile(url,"utf-8")
		title=StrSlice(allstr,"<h1 title=""",""""):x=StrSplits(allstr,"videoId:""",""""):l=UBound(x)
		if l=0 then
			result= title & " 全集$2_2_1_51_"&lid&"_"&x(0)&"$joy"
		else
			for i=0 to l
				result= result&ifthen(result<>"",vbcrlf,"") & "第"& ifthen(i<9,"0","")& (i+1) & "集 "& title &"$2_2_1_51_"&lid&"_"&x(i)&"$joy"
			next
		end if
	elseif Instr(LCase(url),"/video/")>0 then
		allstr = GetHttpTextFile(url,"utf-8")
		title=StrSlice(allstr,"og:description"" content=""",""""):lid=StrSlice(allstr,"programId:""",""""):if not isNum(lid) then lid=0
		id=StrSlice(allstr,"videoType:""","""")&"_"&StrSlice(allstr,"playerMode:""","""")&"_1_"&StrSlice(allstr,"channelId:""","""")&"_"&lid&"_"&StrSlice(allstr,"videoId:""","""")
		result= result&ifthen(result<>"",vbcrlf,"")& title & "$" & id & "$joy"
	else
		allstr = GetHttpTextFile(url,"utf-8")
		title=StrSlice(allstr,"<h1 title=""","""")
		x=StrSlice(allstr,"programId:""",""""):if isNul(x) then x=0
		
		id=StrSlice(allstr,"videoType:""","""")&"_"&StrSlice(allstr,"playerMode:""","""")&"_1_"&StrSlice(allstr,"channelId:""","""")&"_"&x&"_"&StrSlice(allstr,"videoId:""","""")
		result= result&ifthen(result<>"",vbcrlf,"")& title & "$" & id & "$joy"
	end if
End Sub

Sub gatherQiyi(url)
	dim allstr,albid,pid,ptype,tmp,videos,videoNames,i,l:allstr = GetHttpTextFile(url,"utf-8"):result=""
	if Instr(allstr,"-firstEpisodeUrl""")>0 then
		url=mtrim(replace(StrSlice(allstr,"-firstEpisodeUrl""",""" title="""),"href=""",""))
		allstr = GetHttpTextFile(url,"utf-8")
		pid=Clng(StrSlice(allstr,"pid : ""","""")):ptype=Clng(StrSlice(allstr,"ptype : ""","""")):albid=Clng(StrSlice(allstr,"albumId : """,""""))
		tmp=GetHttpTextFile("http://cache.video.qiyi.com/l/"&pid&"/"&ptype&"/"&albid,"utf-8")
		videos=StrSplits(tmp,"""videoUrl"":""",""""):videoNames=StrSplits(tmp,"""videoName"":""",""""):l=UBound(videos):tmp=""
		for i=0 to l
			allstr=GetHttpTextFile(videos(i),"utf-8")
			pid=Clng(StrSlice(allstr,"pid : ""","""")):ptype=Clng(StrSlice(allstr,"ptype : ""","""")):albid=Clng(StrSlice(allstr,"albumId : """,""""))
			videos(i)=videoNames(i)&"$vid="&strslice(allstr,"videoId : ""","""")&"-pid="&pid&"-ptype="&ptype&"-albumId="&albid&"-tvId="& Clng(StrSlice(allstr,"tvId : """,""""))&"$qiyi"
		next
		result=join(videos,vbcrlf)
	else
		pid=Clng(StrSlice(allstr,"pid : ""","""")):ptype=Clng(StrSlice(allstr,"ptype : ""","""")):albid=Clng(StrSlice(allstr,"albumId : """,""""))
		result=StrSlice(allstr,"title : ""","""") & "$vid="&trim(StrSlice(allstr,"videoId : """,""""))&"-pid="&pid&"-ptype="&ptype&"-albumId="&albid&"-tvId="& Clng(StrSlice(allstr,"tvId : ""","""")) &"$qiyi"&vbcrlf
	end if
End Sub

Function subStr(str,startStr,endStr)
	subStr=split(split(str,startStr)(1),endStr)(0)
End Function

Function decodeSohu(Byval str) 
    dim i,tempStr,char
    tempStr="" 
	str = replaceStr(str,"\u","%u")
    for i=1 to len(str) 
        char=mid(str,i,1) 
        if mid(str,i,2)="%u" and i<=len(str)-5 then 
            if isNum("&H" & mid(str,i+2,4)) then tempStr = tempStr & chrw(clng("&H" & mid(str,i+2,4))) : i = i+5  else tempStr = tempStr & char 
        elseif char="%" and i<=len(str)-2 then 
            if isNum("&H" & mid(str,i+1,2)) then tempStr = tempStr & chrw(clng("&H" & mid(str,i+1,2))) : i = i+2  else  tempStr = tempStr & char 
        else 
            tempStr = tempStr & char 
        end if 
    next 
    decodeSohu = tempStr 
End Function 

'/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~采集核心程序~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/
Function mTrim(ByVal sStr)
	mTrim=RegReplace(sStr,"/(^\s*)|(\s*$)/ig","")
End Function
'符值
Function SetValue(ByRef Var,ByVal Val)
	if isObject(val) then
		if isObject(Var) then:SET Var=nothing:end if
		SET Var=Val:SET SetValue=Val
	else
		Var=Val:SetValue=Val
	end if
End Function

'比较2个变量是否相同
Function varComp(ByVal var1,ByVal var2)
	if typename(var1)<>typename(var2) then:varComp=false:exit function:end if
	if typename(var1)="Object" then:varComp=var1 is var2:exit function:end if
	if typename(var1)="Variant()" then:varComp=join(var1,"$")=join(var2,"$"):else:varComp=var1=var2:end if
End Function

Function Random()
	Randomize():Random=Rnd
End Function

Sub Push(ByRef Arr,ByRef Val)
	on Error resume next
	Dim l:l=UBound(Arr)+1:l=ifthen(err,0,l):ReDim Preserve Arr(l)
	if isObject(Val) then:SET Arr(l)=Val:else:Arr(l)=Val:end if
End Sub

Function Pop(ByRef Arr)
	dim l:l=UBound(Arr)
	on Error resume next
	SetValue Pop,Arr(l)
	ReDim Preserve Arr(l-1)
End Function

Function unShift(ByRef Arr)
	dim i,t:t=array()
	on Error resume next
	SetValue unShift,Arr(0)
	For i=1 to UBound(Arr):Push t,Arr(i):Next:ReDim Arr(-1):Arr=t
End Function

Function concat(ByVal Arr1,ByVal Arr2)
	dim i
	for i=0 to Ubound(Arr2)
		Push Arr1,Arr2(i)
	next
	concat = Arr1
End Function

'弹出成员	Start开始位置	弹出个数
Function Splice(ByRef Arr,ByVal Start,ByVal Length)
	Splice=jsSplice(Arr,Start,Length,null)
End Function

Function jsSplice(ByRef Arr,ByVal Start,ByVal Length,ByVal arg)
	Dim ret,i,t,al,iEnd:iEnd=Start+Length:al=Ubound(Arr):t=array():ret=array()
	for i=Start to iEnd-1:Push ret,Arr(i):next
	for i=iEnd to al:Push t,Arr(i):next
	ReDim Preserve Arr(Start-1)
	if IsArray(arg) then:for i=0 to UBound(arg):Push Arr,arg(0):next:end if
	for i=0 to UBound(t):Push Arr,t(i):next
	jsSplice=ret
End Function

Function array_unique(ByVal arr)
	dim i,j,ret,bol:ret=array()
	for i=0 to UBound(arr)
		bol=true
		for j=UBound(ret) to 0 step -1
			if varComp(arr(i),ret(j)) then
				bol=false
				exit for
			end if
		next
		if bol then
			Push ret,arr(i)
		end if
	next
	array_unique=ret
End Function

Function array_reverse(ByVal arr)
	dim i,ret:ret=array()
	for i=UBound(arr) to 0 step -1
		Push ret,arr(i)
	next
	array_reverse=ret
End Function

Function getFileTime(Byval Path)
	Path=Server.MapPath(Path)
	if objFso.FileExists(Path) then
		Dim f:SET f=objFso.getFile(Path)
		getFileTime=f.DateLastModified:SEt f=nothing
	else
		getFileTime="N/A"
	end if
End Function

Function jsCharAt(ByVal Str,ByVal iIndex)
	jsCharAt=jsSubstr(Str,iIndex,1)
End Function

Function jsCharAtCode(ByVal Str,ByVal iIndex)
	jsCharAtCode=Asc(jsSubstr(Str,iIndex,1))
End Function

Function jsIndexOf(ByVal Str,ByVal substr)
	Dim Pos:Pos=inStr(chr(0)&Str,substr):jsIndexOf=IfThen(Pos=0,-1,Pos-1)
End Function

Function jsSubstr(ByVal Str,ByVal Start,ByVal Length)
	jsSubstr=Mid(Str,Start+1,IfThen(Length<0,0,Length))
End Function

Function jsSlice(ByVal Str,ByVal Start,ByVal iEnd)
	jsSlice=jsSubstr(Str,Start,IfThen(iEnd<1,len(Str)+iEnd,iEnd-1))
End Function

Function isString(ByVal Val)
	isString=typename(Val)="String"
End Function

Function isBool(ByVal Val)
	isBool=typename(Val)="Boolean"
End Function

Function IfThen(ByVal Bool, Byval A,ByVal B)
	if Bool then
		SetValue IfThen,A
	else
		SetValue IfThen,B
	end if
End Function

'全局RegExp
Dim gRegExp:gRegExp=null
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

Function jsRegExpExec(ByVal Str,ByVal Pattern)
	jsRegExpExec=array()
	on Error resume next
	Dim i,m:SET m=getGRegExp(Pattern).execute(Str).item(0)
	jsRegExpExec=array(m.value)
	for i=0 to m.submatches.count-1:Push jsRegExpExec,m.submatches(i):next
End Function

Function RegExpExec(ByVal Str,ByVal Pattern)
	Dim i,m,ms:RegExpExec=array()
	on Error resume next
	SET ms=getGRegExp(Pattern).execute(Str)
	for each m in ms
		for i=0 to m.submatches.count-1:Push RegExpExec,m.submatches(i):next
	next
End Function

Function RegMatchesCount(ByVal Str,ByVal Pattern)
	RegMatchesCount=getGRegExp(Pattern).execute(Str).count
End Function

'规则替换
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

'规则替换E
'参数FuncHas: 是 TObject 或 Array 类型
'符加说明: FuncHas(0)="FuncName" or FuncHas("$0")="FuncName"	设置默认处理函数
Function RegReplaceE(ByVal Str, ByVal Pattern, ByVal FuncHas)
	'on Error resume next
	if Str="" then:RegReplaceE="":exit function:end if
	Dim rg,i,m,ms,tFuncHas
	if isObject(Pattern) then:SET rg=Pattern:else:SET rg=jsRegExp(Pattern):end if
	if rg.test(Str) then
		if isObject(FuncHas) then
			SET tFuncHas=FuncHas
		else
			SET tFuncHas=Object()
			if isArray(FuncHas) then:for i=0 to UBound(FuncHas):tFuncHas("$"&i)=FuncHas(i):next:end if
		end if
		dim tStr,tmp,arg,Pos,pStart,pEnd,Func,tFunc:SET ms=rg.Execute(Str):Pos=0:tStr=Str:Func=""
		for each m in ms
			arg=array(m.value):Func="":tmp=""
			for i=0 to m.submatches.count-1
				Push arg,m.submatches(i)
				if Func="" then
					tFunc=tFuncHas("$"&(i+1))
					if m.submatches(i)<>"" AND tFunc<>Empty then:Func=tFunc:end if
				end if
			next
			Func=IfThen(Func="",trim(tFuncHas("$0")),Func)
			if Func<>"" then
				if UCASE(Func)="NOREPLACE" then
					tmp=arg(0)
				else
					tmp=callUserFunc(Func,arg)
				end if
			end if
			pStart=Pos+jsIndexOf(jsSlice(tStr,Pos,0),arg(0))-1:pEnd=pStart+len(arg(0))
			tStr=jsSubstr(tStr,0,pStart)&tmp&jsSlice(tStr,pEnd,0):Pos=pStart+len(tmp)
		next
		RegReplaceE=tStr
	else
		RegReplaceE=Str
	end if
	SET rg=nothing
End Function

Function fCallUserFunc(ByVal FunName, ByVal Arg)
	dim i,vbCall,result:vbCall="":FunName=RegReplace(FunName,"/\'\(\)\,\:/g","")
	if isArray(Arg) then 
		For i=0 to Ubound(Arg)
		vbCall=vbCall & IfThen(vbCall<>"",", ","") & "Arg("&i&")"
		Next
	else
		vbCall=Arg
	end if
	execute("result="&FunName&"("&vbCall&")")
	fCallUserFunc=result
End Function

Function callUserFunc(ByVal FunName, ByVal Arg)
	Dim i,result:i=0:result=""
	on Error resume next
	result=fCallUserFunc(FunName,Arg)
	if err.number=0 then
		callUserFunc=result
		exit function
	end if
	if err.number=450 then
		err.clear
		callUserFunc=fCallUserFunc(FunName,null)
		Dim nArg:nArg=array()
		do while err.number=450 AND i<100
			i=i+1:Push nArg,UnShift(Arg)
			callUserFunc=fCallUserFunc(FunName,nArg)
			if err.number<>450 then:exit do:end if
		loop
	end if
	if err.number>1000 AND err.number<3000 then
		die err.description
	end if
	err.clear
End Function

'附加功能函数
'斜杠转义
Function addcslashes(ByVal str)
	addcslashes=RegReplace(str,"/([\(\)\[\]\""\'\.\?\+\*\/\\\^\$])/ig","\$1")
End Function

Function stripcslashes(ByVal str)
	stripcslashes=RegReplace(str,"/\\([\(\)\[\]\""\'\.\?\+\*\/\\\^\$])/ig","$1")
End Function

Function TrimAll(ByVal Str)
	TrimAll=regReplace(Str,"/(\s*)/g","")
End Function

'比较文本
Function StrComp(ByVal Str1,ByVal Str2,ByVal bool)
		Str1=IfThen(CBool(bool)<>true,UCase(Str1),Str1):Str2=IfThen(CBool(bool)<>true,UCase(Str2),Str2)
		StrComp=IfThen(Str1>Str2,1,IfThen(Str1<Str2,-1,0))
End Function

'截取文本中间区分大小写
Function StrSliceI(ByVal Str,ByVal sStr,ByVal eStr)
	if sStr&eStr="" then:StrSliceI="":exit function:end if
	Dim iPos:iPos=JsIndexOf(Str,sStr):StrSliceI=""
	if iPos=-1 then:exit function:end if
	iPos=ifthen(sStr<>"",iPos+Len(sStr),1):StrSliceI=jsSubstr(Str,iPos-1,JsIndexOf(jsSlice(Str,iPos,0),eStr))
End Function

'截取文本中间
Function StrSlice(ByVal Str,ByVal sStr,ByVal eStr)
	if sStr&eStr="" then:StrSlice="":exit function:end if
	Dim tStr,iPos:tStr=UCase(Str):iPos=JsIndexOf(tStr,UCase(sStr)):StrSlice=""
	if iPos=-1 then exit function:end if
	iPos=ifthen(sStr<>"",iPos+Len(sStr),1):StrSlice=jsSubstr(Str,iPos-1,JsIndexOf(jsSlice(tStr,iPos-1,0),UCase(eStr))-1)
End Function

'截取文本中间B 最大范围
Function StrSliceB(ByVal Str,ByVal sStr,ByVal eStr)
	if sStr&eStr="" then:StrSliceB=Str:exit function:end if
	Dim tStr,iPos:tStr=UCase(Str):iPos=JsIndexOf(tStr,UCase(sStr)):StrSliceB=""
	if iPos=-1 then:exit function:end if
	iPos=ifthen(sStr<>"",iPos+Len(sStr),1):StrSliceB=jsSubstr(Str,iPos-1,InstrRev(jsSlice(tStr,iPos-1,0),UCase(eStr)))
End Function

'分割文本段
Function StrSplits(ByVal Str,ByVal sStr,ByVal eStr)
	StrSplits=RegExpExec(Str,"/"&addcslashes(sStr)&"([\w\W]+?)"&addcslashes(eStr)&"/ig")
End Function

Function executevbs(ByVal vbscript)
	if BANVBSCRIPT then
		echo "安全保护提示: 系统禁止执行VB脚本":response.end
	else
		execute(vbscript)
	end if
End Function

Function HTMLEncode(ByVal HTMLStr)
	HTMLEncode = Server.HTMLEncode(HTMLStr)
ENd Function

'HTTP读文件
Function GetHttpFile(ByVal url)
	url=Replace(url,"&amp;","&"):if not isObject(gHttpObj) then:SET gHttpObj=tryXmlHttp():end if:gHttpObj.open "GET",url,False:gHttpObj.setRequestHeader "referer",RegReplace(url,"/(https?\:\/\/\w+)((\.\w+)*(:\d+)?)\/.*/i","$1$2"):gHttpObj.send:GetHttpFile=gHttpObj.responseBody
	'die Server.HTMLENCODE(GetHttpFile)
End Function

'HTTP读文本文件
Function GetHttpTextFile(ByVal url,ByVal charset)
	GetHttpTextFile=bytesToStr(GetHttpFile(url),ifThen(charset<>"",charset,"gbk"))
End Function

Function paseAbsURI(ByVal Links,ByVal currUrl)
	Links=ifthen(isArray(Links),Links,Array(Links))
	on Error Resume Next
	Dim t,H,i,j,k,rg,ab,qt,Pb,siteUrl
	SET rg=jsRegExp("/^\s*[\/\\]/i"):SET ab=jsRegExp("/^http:\/\//i"):SET qt=jsRegExp("/\\([\\\/])/ig"):
	currUrl=qt.replace(trim(currUrl),"/"):siteUrl=RegReplace(currUrl,"/(https?\:\/\/)((\w+)(\.\w+)*(:\d+)?)\/.*/i","$1$2"):currUrl=replace(currUrl,siteUrl,"")
	for i=0 to Ubound(Links)
		H=CStr(Links(i))
		if not ab.test(H) then
			if rg.test(H) then:Links(i)=siteUrl&H:else:j=UBound(split(H,"../"))+1:t=Split(currUrl,"/"):k=Ubound(t)+1:j=ifthen(j<k,k-j,0)-1:ReDim Preserve t(j):Links(i)=siteUrl&Join(t,"/")&"/"&RegReplace(H,"/([\.]{2}\/)/g",""):end if
		end if
	next
	paseAbsURI=Links
	SET rg=nothing:SET ab=nothing:SET pb=nothing:SET qt=nothing
End Function

Function iDec(ByRef Var)
	iDec=Var:Var=Var-1
End Function

Function iDec2(ByRef Var)
	Var=Var-1:iDec=Var
End Function

Function iInc(ByRef Var)
	iInc=Var:Var=Var+1
End Function

Function iInc2(ByRef Var)
	Var=Var+1:iInc=Var
End Function

Function Str2Num(ByVal sNum)
	if not isNumeric(sNum) then:Str2Num=0:exit function:end if
	dim x:x=CDBL(sNum)
	if jsIndexOf(sNum,".")<>-1 OR (x<-2147483647 AND x>2147483647) then:Str2Num=CDbl(sNum):exit function:end if
	if x>-32768 AND x<32768 then:Str2Num=CInt(sNum):else:Str2Num=CLng(sNum):end if
End Function

Function MakeBatchUrl(ByVal Url,Byval ValStr, ByVal iStart, ByVal iEnd, ByVal Order)
	dim i,ret()
	if Order = true then
		for i=iEnd to iStart step -1
			Push ret,Replace(Url,ValStr,i)
		next
	else
		for i=iStart to iEnd
			Push ret,Replace(Url,ValStr,i)
		next
	end if
	MakeBatchUrl=ret
End Function

'特殊链接
Function SpecialLink(ByVal sLink,ByVal fLink,ByVal rLink)
	Dim t,i:t=split(fLink,"[变量]")
	if UBound(t)<1 then
		SpecialLink=sLink
	else
		rLink=join(split(rLink,"[变量]"),"$1")
		For i=0 to UBound(t):t(i)=addcslashes(t(i)):Next
		SpecialLink=RegReplace(sLink,"/"&Join(t,"([\w\W]+)")&"/ig",rLink)
	end if
End Function

Function SpecialLinks(ByVal aLinks,ByVal fLink,ByVal rLink)
	Dim t,i:t=split(fLink,"[变量]")
	if UBound(t)<1 then
		SpecialLinks=aLinks
	else
		rLink=Join(split(rLink,"[变量]"),"$1")
		For i=0 to UBound(t):t(i)=addcslashes(t(i)):Next
		fLink=Join(t,"([\w\W]+)")
		for i=0 to UBound(aLinks)
			aLinks(i)=RegReplace(aLinks(i),"/"&fLink&"/ig",rLink)
		next
		SpecialLinks=aLinks
	end if
End Function

Function RemoveHTMLCode(ByVal Str,ByVal cHas)
	if cHas="" OR Str="" then:RemoveHTMLCode=Cstr(Str):exit function:end if
	Dim i:cHas=split(trimall(UCASE(cHas)),"|")
	for i=0 to UBound(cHas)
		SELECT CASE cHas(i)
			CASE "TABLE":Str=RegReplace(Str,"/<\/?(table|thead|tbody|tr|th|td).*>/ig","")
			CASE "OBJECT":Str=RegReplace(Str,"/<\/?(object|param|embed).*>/ig","")
			CASE "SCR"&"IPT":Str=RegReplace(Str,"/<scr"&"ipt.*>[\w\W]+?<\/scr"&"ipt>/ig",""):Str=RegReplace(Str,"/on[\w]+=[\'\""].+?[\'\""](\s|>)/ig","$1")
			CASE "STYLE":Str=RegReplace(Str,"/<style.*>[\w\W]+?<\/style>/ig","")
			CASE "CLASS":Str=RegReplace(Str,"/\sclass=.+?(\s|>)/ig","")
			CASE "*":Str=Replace(Replace(RegReplace(Str,"/<.*?>/ig",""),"<","&lt;"),">","&gt;")
			CASE ELSE:Str=RegReplace(Str,"/<\/?"&addcslashes(cHas(i))&".*?>/ig","")
		End SELECT
	next
	RemoveHTMLCode=Replace(Str,"&nbsp;"," ")
End Function

function IsConnected()
	IsConnected=response.IsClientConnected
end function

Function getRemoteContent2(Byval url,Byval returnType)
	dim tudougXmlObjVer,tudouXmlObj
	tudougXmlObjVer=getXmlHttpVer()
	set tudouXmlObj=Server.CreateObject(tudougXmlObjVer)
	tudouXmlObj.open "GET",url,False
	tudouXmlObj.send()
	select case returnType
		case "text"
			getRemoteContent2=tudouXmlObj.responseText
		case "body"
			getRemoteContent2=tudouXmlObj.responseBody
	end select
End Function
%>