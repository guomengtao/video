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

dim action : action = getForm("action", "get")
response.Charset="GBK"
checkPower

Select case action
	case "topic" : viewVideoTopic
	case "select" : selectTopic
	case "submittopic" : submitVideoTopic
	case "getad" : getAdInfo
	case "getselflabel" : getSelfLabel
	case "checkuser" : checkUserExist
	case "submitstate" : submitState
	case "commend" : commendVideo
	case "commendnews" : commendNews
	case "gettopicdes" : getTopicDes
	case "submittopicdes" : submitTopicDes
	case "updatepic" : checkUpdatePic
	case "cleartophit" : cleartophit
	case "checkrepeat" : checkRepeat
	case "restartcache" : restartCache
	case else : main
End Select
terminateAllObjects

Sub main
End Sub

Sub cleartophit
	dim x:x=getForm("do", "get")
	if x="dwm" then
		conn.db "UPDATE {pre}data SET m_monthhit=m_weekhit+m_dayhit,m_weekhit=m_dayhit,m_dayhit=0","execute"
		conn.db "UPDATE {pre}news SET m_monthhit=m_weekhit+m_dayhit,m_weekhit=m_dayhit,m_dayhit=0","execute"
	elseif x="dw" then
		conn.db "UPDATE {pre}data SET m_monthhit=m_monthhit+m_weekhit+m_dayhit,m_weekhit=m_dayhit,m_dayhit=0","execute"
		conn.db "UPDATE {pre}news SET m_monthhit=m_monthhit+m_weekhit+m_dayhit,m_weekhit=m_dayhit,m_dayhit=0","execute"
	elseif x="d" then
		conn.db "UPDATE {pre}data SET m_weekhit=m_weekhit+m_dayhit,m_dayhit=0","execute"
		conn.db "UPDATE {pre}news SET m_weekhit=m_weekhit+m_dayhit,m_dayhit=0","execute"
	end if
	CreateTextFile "window.HitLastUpdateTime='"&year(date)&"/"&Month(date)&"/"&day(date)&" "&time()&"';","imgs/last_clear_lock.js",""
End Sub

Sub restartCache
	on error resume next
	cacheObj.clearAll
	if err then echo "err" else echo "ok":clearSearch
End Sub

Sub clearSearch
	on error resume next
	if IsCacheSearch=0 AND commentStart= 0 then exit sub
	dim x:x="../webcache/"
	If isExistFolder(x)=True Then  
		objFso.DeleteFolder(server.mappath(x)) 
		if Err then:Err.clear:end if
	end if
End Sub

Sub checkRepeat
	dim m_name,num : m_name=getForm("m_name","get")
	num=conn.db("select count(*) from {pre}data where m_name='"&m_name&"'","execute")(0)
	if num=0 then echo "ok" else echo "err"
End Sub

Sub checkUpdatePic
	dim num : num=conn.db("select count(*) from {pre}data where m_pic like '%bokecc.com%' or m_pic like '%cmsplugin.net%'","execute")(0)
	echo num
End Sub

Sub submitTopicDes
	dim id : id=getForm("f_m_id","post")
	dim topicDes : topicDes=encodeHtml(getForm("f_m_des","post"))
	on error resume next
	conn.db "update {pre}topic set m_des='"&topicDes&"' where m_id="&id,"execute"
	if err then echo "err" else echo "ok"
End Sub

Sub getTopicDes
	dim id : id=getForm("id","get")
	dim topicDes
	topicDes = server.HTMLEncode(decodeHtml(conn.db("select m_des from {pre}topic where m_id="&id,"execute")(0)))
	if err then echo "err" else echo topicDes
End Sub

Sub commendVideo
	dim id : id=getForm("id","get")
	dim commendId : commendId=getForm("commendid","get")
	call conn.db("update {pre}data set m_commend="&commendId&" where m_id="&id,"execute")
	echo "submitok"
End Sub

Sub commendNews
	dim id : id=getForm("id","get")
	dim commendId : commendId=getForm("commendid","get")
	call conn.db("update {pre}news set m_commend="&commendId&" where m_id="&id,"execute")
	echo "submitok"
End Sub

Sub submitState
	dim id : id=getForm("id","get")
	dim vstate : vstate=getForm("state","get")
	call conn.db("update {pre}data set m_state='"&vstate&"' where m_id="&id,"execute")
	echo "submitok"
End Sub

Sub getSelfLabel
	dim id,selfLabelContent,rsObj : id = getForm("id","get")
	on error resume next
	set rsObj=conn.db("select top 1 m_content from {pre}selflabel where m_id="&id,"records1")
	selfLabelContent=server.HTMLEncode(decodeHtml(rsObj("m_content")))
	set rsObj=nothing
	if  err then echo "no" : Exit Sub
	echo selfLabelContent
End Sub


Sub checkUserExist
	dim username,num,id
	username=getForm("username","get")
	id=getForm("id","get")
	on error resume next
	if isNul(id) then
		num = conn.db("select count(*) from {pre}manager where m_username='"&username&"'","execute")(0)
	else
		num = conn.db("select count(*) from {pre}manager where  m_id<>"&id&"  and m_username='"&username&"'","execute")(0)
	end if
	if  err then echo "no" : Exit Sub
	echo num
End Sub


Sub getAdInfo
	dim path,adStr
	on error resume next
	path=getForm("path","get")
	'adStr = server.HTMLEncode("<script type=""text/javascript"" language=""javascript"" >"&loadFile(path)&"<//script>")
	adStr = server.HTMLEncode(decodeHtml(loadFile(path)))
	if err then echo "err" else echo adStr
End Sub

Sub viewVideoTopic
	dim topicName,id
	id = getForm("id","get")
	on error resume next
	topicName = conn.db("select top  1 m_name from {pre}topic where m_id ="&id,"execute")(0)
	if computeStrLen(topicName) > 8 then topicName = getStrByLen(topicName,14)&".."
	if  err then echo "" else echo topicName
End Sub


Sub selectTopic()
	dim id,topicArray,topicId,sss
	id = getForm("id","get"):topicId=getForm("topicid","get")
	topicArray = conn.db("select m_id,m_name from {pre}topic order by m_id asc","array")
	sss=makeTopicSelect("topicselect",topicArray,"...请选择专题...",topicId)
	sss=Replace(sss,"</select>","<option value=""0"">取消专题</option></select>")
	echo sss&"<input type=""button"" value=""确定"" onclick='submitVideoTopic("&id&")' /> <input type=""button"" value=""取消"" onclick='closeWin()' />"
End Sub

Sub submitVideoTopic
	dim id,topic,aaa
	id = getForm("id","get")
	topic = getForm("topic","get")
	call conn.db("update {pre}data set m_topic="&topic&" where m_id="&id,"execute")
	echo "submitok"
End Sub

%>