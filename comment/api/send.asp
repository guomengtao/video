<!--#include file="../../inc/MainClass.asp"-->
<%
Const key_time="zz_ltime"
Const key_count="zz_rtime"
Dim timeSpan:timeSpan=commentTime				'���ۼ��������
Dim SavePath,isUpload:SavePath="../upload"		'�ϴ�Ŀ¼

Dim ac,id,itype,cparent,anony,vote,ppath,utmpname,captcha:ac=getForm("action","both"):captcha=getForm("captcha","both"):isUpload=InStr(":"&request.ServerVariables("HTTP_CONTENT_TYPE"),"multipart/form-data;")>0
if not isUpload then
	id=getForm("gid","both"):cparent=getForm("cparent","post"):itype=getForm("ctype","post"):anony=getForm("anony","post"):vote=ifthen(getForm("vote","post")="1",1,0):ppath=getForm("ppath","post"):utmpname=getForm("utmpname","post")
	if not isNum(id) then:id=0:die "":else:id=Clng(id):id=ifthen(id<0,0,id):end if
	if not isNum(cparent) then:cparent=0:else:cparent=Clng(cparent):cparent=ifthen(cparent<0,"",cparent):end if
	if not isNum(itype) then:itype=1:else:itype=Clng(itype):end if
end if

Select Case ac
	Case "1":if isUpload then:startUpload:else:addComment:end if
	Case "2":addAgree
	Case "3":addAnti
	Case "4":addVote
	'Case else:
End Select

Sub startUpload
	CallBack false,"","��վδ�����ϴ�����":response.end
	if ""&Session("GetCode")<>captcha OR isNul(captcha) then:CallBack false,"","�ϴ�ͼƬʧ��,��֤�����":die "":end if
	upload
End Sub

Sub CallBack(ok,Fn,msg)
	response.write "<script>try{parent.onSendBack("&LCase(ok=true)&",'"&fn&"','"&msg&"')}catch(e){alert('δ�����ϴ��ص�����onSendBack(boolean uped,string filename,string msg)')}</script>"
End Sub

Function ifthen(a,b,c)
	if a=true then:ifthen=b:else:ifthen=c:end if
End Function

Sub addAgree()
	CheckMark()
	conn.db "UPDATE {pre}review SET m_agree=m_agree+1 WHERE m_id="&id,"execute"
	delfile "../../webcache/review/"&itype&"/"&conn.db("SELECT m_videoid FROM {pre}review WHERE m_id="&id,"execute")(0)&".js"
End Sub

Sub addAnti()
	CheckMark()
	conn.db "UPDATE {pre}review SET m_anti=m_anti+1 WHERE m_id="&id,"execute"
	delfile "../../webcache/review/"&itype&"/"&conn.db("SELECT m_videoid FROM {pre}review WHERE m_id="&id,"execute")(0)&".js"
End Sub

Sub addVote()
	CheckMark()
	conn.db "UPDATE {pre}review SET m_vote=m_vote+1 WHERE m_id="&id,"execute"
	delfile "../../webcache/review/"&itype&"/"&conn.db("SELECT m_videoid FROM {pre}review WHERE m_id="&id,"execute")(0)&".js"
End Sub

Function getBanWords()
	on error resume next:getBanWords=BanWords
End Function

Sub CheckBanWords(m_content)
	if ""&getBanWords="" OR m_content="" then Exit Sub
	Dim Ban,i,l:Ban=Split(getBanWords,","):l=UBound(Ban)
	for i=0 to l
		if Ban(i)<>"" then
			if InStr(" "&m_content,Ban(i))>0 then CallBack false,"","ϵͳ��æ�����Ժ����ԣ�":die ""
		end if
	next
End Sub

Function getBanIPS()
	on error resume next:getBanIPS=BanIPS
End Function

Sub CheckBanIP(m_ip)
	if ""&getBanIPS="" OR m_ip="" then Exit Sub
	dim x,y,i,l,Ban:Ban=Split(ReplaceStr(getBanIPS," ",""),","):l=UBound(Ban)
	if InStr(" ,"&getBanIPS&",",","&m_ip&",")>0 then CallBack false,"","ϵͳ��æ�����Ժ����ԣ�":die ""
	for i=0 to l
		if InStr(" "&Ban(i),"*")>0 then
			x=Split(Ban(i),"."):y=Split(m_ip,".")
			if UBound(x)=3 then
				if (x(0)=y(0) OR x(0)="*") AND (x(1)=y(1) OR x(1)="*") AND (x(2)=y(2) OR x(2)="*") AND (x(3)=y(3) OR x(3)="*") then
					CallBack false,"","ϵͳ��æ�����Ժ����ԣ�":die ""
				end if
			end if
		elseif Ban(i)=m_ip then
			CallBack false,"","ϵͳ��æ�����Ժ����ԣ�":die ""
		end if
	next
End Sub

Function getSendCount()
	dim c:c=rCookie(key_count)
	if isNul(c) OR not isNumeric(c) then
		c=0
	else
		c=Clng(c)
	end if
	getSendCount=c
End Function

Sub CheckMark()
	if getTimeSpan("lastCommentTime")<timeSpan then
		CallBack false,"","ϵͳ��æ�����Ժ����ԣ�":die ""
	else
		SetSendLimit
	end if
End Sub

Sub CheckSendLimit()
	if getTimeSpan("lastCommentTime")<timeSpan then
		CallBack false,"","ϵͳ��æ�����Ժ����ԣ�":die ""
	else
		if ""&Session("GetCode")<>captcha OR isNul(captcha) then
			CallBack false,"","��֤�����":die ""
		end if
		dim s,c:s=getTimeSpan(key_time):c=getSendCount
		if c=-1 then
			CallBack false,"","ϵͳ��æ�����Ժ����ԣ�":die ""
		elseif s<30*60 AND c>=10 then
			setSession key_count,-1
			CallBack false,"","ϵͳ��æ�����Ժ����ԣ�":die ""
		end if
	end if
End Sub

Sub SetSendLimit
	Dim c:c=getSendCount
	if c=0 then setSession key_time,now
	setSession key_count,1+c:setSession "lastCommentTime",now
End Sub

Sub addComment
	CheckSendLimit()
	dim m_author,m_content,m_ip,m_reply
	m_ip=preventSqlin(getIp(),"filter")
	if computeStrLen(m_ip)>15 then m_ip=getStrByLen(m_ip,15)
	CheckBanIP m_ip
	m_content=trim(encodeHtml(filterDirty(preventSqlin(getForm("talkwhat","post"),"filter"))))
	if computeStrLen(m_content)<3 then CallBack false,"","�����������̫����":die "":Session("GetCode")=""
	if computeStrLen(m_content)>500 then m_content=getStrByLen(m_content,500)
	CheckBanWords m_content:m_content=replacedirtyWords(m_content)
	on error resume next
	if ""&anony="1" then
		utmpname=trim(encodeHtml(filterDirty(preventSqlin(utmpname,"filter"))))
		if utmpname<>"" then
			CheckBanWords utmpname:m_author=replacedirtyWords(utmpname)
		else
			m_author=""
		end if
	else
		m_author=""
	end if
	if computeStrLen(m_author)>20 then m_author=getStrByLen(m_author,20)
	conn.db "insert into {pre}review(m_reply,m_author,m_type,m_videoid,m_content,m_ip,m_addtime,m_agree,m_anti,m_pic,m_vote,m_check) values ("&cparent&",'"&m_author&"',"&itype&","&id&",'"&m_content&"','"&m_ip&"','"&now()&"',0,0,'"&ReplaceStr(ppath,"'","")&"',"&vote&","&ifthen(ppath<>"","0","1")&")","execute"
	'conn.db "UPDATE {pre}data SET m_reply=m_reply+1 WHERE m_id="&id,"execute"
	SetSendLimit()
	if err then CallBack false,"","ϵͳ�ڲ���������ʧ�ܣ�������":die "" else CallBack true,"",""
	delfile "../../webcache/review/"&itype&"/"&id&".js"
End Sub
terminateAllObjects
%>