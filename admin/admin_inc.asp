<!--#include file="../inc/MainClass.asp"-->
<%
'******************************************************************************************
' Software name: Max(����˹) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ����
' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
'******************************************************************************************
Response.Addheader "Content-Type","text/html; charset=gbk"
dim updateUrl,versionXml
updateUrl = "h"&"ttp"&"://ma"&"xcms.bo"&"kec"&"c.com/update/max4.0"
versionXml ="ht"&"tp://maxc"&"ms.bok"&"ecc.com/update/max4.0/maxcmsver4.0.xml"
const selfMenuXml ="imgs/selfmenu.xml"
const customMenuXml ="imgs/custommenu.xml"
dim menuList : menuList = getBigMenuInfo(0)


Sub viewFoot
	echo "<div align=center>"
	echoRunTime
	terminateAllObjects
	echo "</div><div align=center >Copyright 2014 All rights reserved. <a target=""_blank"" href=""http://www.maxcms.co"">Maxcms.Co</a></div>" & chr(10) & "</body>" & chr(10) & "</html>"
End Sub

Sub viewHead(str)
	checkPower:session("loginflag")=gbookuser&gbookpwd
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=gbk" />
<meta name="robots" content="noindex,nofollow" />
<meta http-equiv="X-UA-Compatible" content="IE=7" />
<TITLE><%=str%>-MaxCMS��̨����</TITLE>
<link href="imgs/admin.css" rel="stylesheet" type="text/css" />
<script src="../js/common.js" type="text/javascript"></script>
<script src="imgs/main.js" type="text/javascript"></script>
<style type="text/css">
.btn{border:1px solid;border-color:#fff #999 #999 #fff;}
</style>
</head>
<body>
<%
End Sub

Function getBigMenuInfo(level)
	redim bigMenu(0,0)
	select case clng(level)
		case 0
			redim bigMenu(8,2)
			bigMenu(0,0)="��ҳ" : bigMenu(0,1)="common" : bigMenu(0,2)="index.asp?action=notice"
			bigMenu(1,0)="����" : bigMenu(1,1)="content" : bigMenu(1,2)="admin_video.asp?action=else"
			bigMenu(2,0)="ģ��" : bigMenu(2,1)="template" : bigMenu(2,2)="admin_template.asp?action=main"
			bigMenu(3,0)="����" : bigMenu(3,1)="make" : bigMenu(3,2)="admin_makehtml.asp?action=main"
			bigMenu(4,0)="����" : bigMenu(4,1)="tool" : bigMenu(4,2)="admin_datarelate.asp?action=repeat"
			bigMenu(5,0)="���" : bigMenu(5,1)="ads" : bigMenu(5,2)="admin_ads.asp?action=main"
			bigMenu(6,0)="�ɼ�" : bigMenu(6,1)="gathersoft" : bigMenu(6,2)="admin_collect.asp?action=main"
			bigMenu(7,0)="��չ" : bigMenu(7,1)="webhelper" : bigMenu(7,2)="admin_gbook.asp?action=comment&where=gbook"
			bigMenu(8,0)="ϵͳ" : bigMenu(8,1)="system" : bigMenu(8,2)="admin_config.asp"
		case 1
			redim  bigMenu(0,2)
			bigMenu(0,0)="���ݹ���" : bigMenu(0,1)="common" : bigMenu(0,2)="admin_video.asp?action=else"
	end select
	getBigMenuInfo = bigMenu
End Function

Function getSmallMenuInfo(level)
	redim smallMenu(0)
	select case clng(level)
		case 0
			redim  smallMenu(8)
			smallMenu(0)="��̨��ҳ,index.asp?action=notice|��ݲ˵�,admin_selfmenu.asp|"&getSelfMenu(0)
			smallMenu(1)="��ʱ������,admin_tempvideo.asp||�������,admin_type.asp|���ݹ���,admin_video.asp?action=else|��������,admin_video.asp?action=add|��������,admin_video.asp?m_state=ok|�Ƽ�����,admin_video.asp?m_commend=ok|���ݻ���վ,admin_video.asp?action=recycle|ר�����,admin_topic.asp|��������,admin_gbook.asp?action=reporterror&where=reporterror|αԭ������,admin_pseudo.asp||���ŷ���,admin_newstype.asp|���Ź���,admin_news.asp|��������,admin_news.asp?action=add|���Ż���վ,admin_news.asp?action=recycle"
			smallMenu(2)="ģ�����,admin_template.asp?action=main|�����Զ���ģ��,admin_template.asp?action=custom||�Զ����ǩ,admin_selflabel.asp||��ǩ��,admin_labelguide.asp"
			smallMenu(3)="����ѡ��,admin_makehtml.asp?action=main||���ɰٶȵ�ͼ,admin_makehtml.asp?action=baidu|���ɹȸ��ͼ,admin_makehtml.asp?action=google|����RSS,admin_makehtml.asp?action=rss"
			smallMenu(4)="�ظ����ݼ��,admin_datarelate.asp?action=repeat|���������滻,admin_datarelate.asp?action=batch|ɾ��ָ����Դ,admin_datarelate.asp?action=delvideoform|�޸����ݸ�ʽ,admin_datarelate.asp?action=repairplaydata|�������õ����,admin_datarelate.asp?action=randomset||��ЧͼƬ���,admin_datarelate.asp?action=checkpic||�ڴ��������,admin_datarelate.asp?action=japan||SQL�߼�����,admin_datarelate.asp?action=sql||���ݿⱸ�ݡ�ѹ��,admin_database.asp"
			smallMenu(5)="������,admin_ads.asp?action=main|���ӹ��,admin_ads.asp?action=add||��������,admin_link.asp"
			smallMenu(6)="��Ƶ��Ŀ�б�,admin_collect.asp?action=main|������Ƶ��Ŀ,admin_collect.asp?action=wizard|��Ƶ����ת��,admin_collect.asp?action=customercls|��Ƶ��Ϣ����,admin_collect.asp?action=filters|��Ƶ�ɼ����ݿ�,admin_collect.asp?action=tempdatabase||������Ŀ�б�,admin_collectnews.asp?action=main|����������Ŀ,admin_collectnews.asp?action=wizard|���ŷ���ת��,admin_collectnews.asp?action=customercls|������Ϣ����,admin_collectnews.asp?action=filters|���Ųɼ����ݿ�,admin_collectnews.asp?action=tempdatabase"

			smallMenu(7)="���Թ���,admin_gbook.asp?action=comment&where=gbook|�ظ�����,../gbook.asp|��Ƶ���۹���,admin_comment.asp?action=comment&where=1|�������۹���,admin_comment.asp?action=comment&where=2|�õ�Ƭ����,admin_expand.asp||����˹��̳,http://www.maxcms.co||ģ������,http://www.maxcms.co/forum-36-1.html"
			smallMenu(8)="��վ����,admin_config.asp||����������,admin_player1.asp|������Դ����,admin_player.asp?action=boardsource||ϵͳ�˺Ź���,admin_manager.asp"
		case 1
			redim  smallMenu(0)
			smallMenu(0)="��̨��ҳ,index.asp?action=notice|��ݲ˵�,admin_selfmenu.asp|���ݹ���,admin_video.asp?action=else|��������,admin_video.asp?action=add|����ѡ��,admin_makehtml.asp?action=main|"&getSelfMenu(1)
	end select
	getSmallMenuInfo = smallMenu
End Function

Function getSelfMenu(level)
	dim xmlobj,selfMenuListNode,menuNodes,menuNodesLen,i,menuName,menuLink,menuStr,path:path=selfMenuXml
	set xmlobj = mainClassobj.createObject("MainClass.Xml")
	if level=1 then:path=customMenuXml:end if
	xmlobj.load path,"xmlfile"
	set selfMenuListNode=xmlobj.getNodes("maxcms2/menulist")(0)
	set menuNodes=selfMenuListNode.selectNodes("menu") : menuNodesLen=menuNodes.length
	for i=0 to menuNodesLen-1
		menuName=menuNodes(i).selectNodes("name")(0).text : menuLink=menuNodes(i).selectNodes("link")(0).text
		if not isNul(menuName) and not isNul(menuLink) then 
			if i<menuNodesLen-1  then menuStr=menuStr&menuName&","&menuLink&"|" else menuStr=menuStr&menuName&","&menuLink
		else
			if i<menuNodesLen-1  then menuStr=menuStr&"|" else menuStr=menuStr
		end if
	next
	set menuNodes=nothing : set selfMenuListNode=nothing : set xmlobj=nothing
	if not isNul(menuStr) then getSelfMenu="|"&menuStr
End Function

Function selfManageDir()
	dim dir
	if Request.ServerVariables("SERVER_PORT")<>"80" then
    	dir = "http://"&Request.ServerVariables("SERVER_NAME")& ":" & Request.ServerVariables("SERVER_PORT")& Request.ServerVariables("URL")
    else
    	dir = "http://"&Request.ServerVariables("SERVER_NAME")& Request.ServerVariables("URL")
	end if
	dir=left(dir,InstrRev(dir,"/")-1)
	dir=mid(dir,InstrRev(dir,"/")+1)&"/"
	selfManageDir=dir
End Function

Sub checkPower
	dim loginValidate,rsObj : loginValidate = "maxcms"
	err.clear
	on error resume next
	set rsObj=conn.db("select m_random,m_level from {pre}manager where m_username='"&replaceStr(rCookie("m_username"),"'","")&"'","execute")
	loginValidate = md5(getAgent&getIp&rsObj(0),32)
	if err then clearPower : die ""
	if rCookie("check"&rCookie("m_username"))<>loginValidate then clearPower : die ""
	checkManagerLevel rsObj(1)
	rsObj.close:set rsObj=nothing
End Sub

Sub checkManagerLevel(level)
	dim curUrl : curUrl=request.ServerVariables("URL")
	if instr(curUrl,"admin_video.asp")=0 and instr(curUrl,"index.asp")=0 and instr(curUrl,"admin_ajax.asp")=0 and instr(curUrl,"admin_webgather.asp")=0 and instr(curUrl,"maxcms_upload.asp")=0  and instr(curUrl,"m_ax_cm_s_fck_upload.asp")=0 and instr(curUrl,"admin_makehtml.asp")=0 and instr(curUrl,"admin_selfmenu.asp")=0 then
		if clng(level)<>0 then  alertMsg "û��Ȩ��","" : die "<script>top.location.href='index.asp';</script>"
	end if 
End Sub

Sub clearPower
	wCookie "check"&rCookie("m_username"),""
	wCookie "m_username",""
	wCookie "m_id",""
	wCookie "m_level",""
	session("loginflag")=""
	echo "<script>top.location.href='index.asp?action=login';</script>"
End Sub

Function checkField(fieldName,tableName)
	dim flag,sql,rsObj,i : flag=False : sql="select * from "&tableName 
	set rsObj=conn.db(sql,"execute")
	for i = 0 to rsObj.Fields.Count - 1
		if rsObj.Fields(i).Name=fieldName then
			flag=True : Exit For
		else
			flag=False
		end if
	next
	checkField=flag
End Function

Function gatherIntoLibTransfer(Byval data,Byval str,Byval typeset)
	dim transtr,str1,str2,str1Array,str2Array,m,n,j,k,x:str1=data:str2=str
	if  not isNul(str1) and not isNul(str2) then
		select case typeset
			case 0'���ܸ���
				str1Array=split(str1,"$$$"):str2Array=split(str2,"$$$"):m=ubound(str1Array):n=ubound(str2Array)
				for k=0 to n
					x=findIsExistFrom(str1Array,split(str2Array(k),"$$")(0))
					if isNum(x) then 
						str1Array(x)=str2Array(k)
					else
						transtr=transtr&str2Array(k)&"$$$"
					end if
				next
				for j=0 to m
					transtr=transtr&str1Array(j)&"$$$"
				next
				transtr = trimOuterStr(transtr,"$$$")
			case 1'׷��Ϊ��һ����Դ
				transtr=str&"$$$"&data
			case 2'׷��Ϊ���һ����Դ
				transtr=data&"$$$"&str
			case 3'��ȫ����
				transtr=str
		end select
	elseif  not isNul(str1) and isNul(str2) then 
		transtr=str1
	elseif isNul(str1) and not isNul(str2) then 
		transtr=str2
	end if
	gatherIntoLibTransfer=transtr
End Function

Function findIsExistFrom(array1,from)
	dim i,m:m=ubound(array1):findIsExistFrom=""
	for i=0 to m
		if trim(split(array1(i),"$$")(0))=trim(from) then
			findIsExistFrom=i:Exit Function		
		end if
	next
End Function

Function getReferedId(str)
	getReferedId = ""
	if instr(str,"��������")>0 then getReferedId = "hd_tudou": exit function
	if instr(str,"���˸���")>0 then getReferedId = "hd_iask": exit function
	if instr(str,"�Ѻ�����")>0 then getReferedId = "hd_sohu": exit function
	if instr(str,"���߸���")>0 then getReferedId = "hd_openv": exit function
	if instr(str,"56����")>0 then getReferedId = "hd_56": exit function
	if instr(str,"56")>0 then getReferedId = "56": exit function
	if instr(str,"�ſ�")>0 then getReferedId = "youku": exit function
	if instr(str,"����")>0 then getReferedId = "tudou": exit function
	if instr(str,"�Ѻ�")>0 then getReferedId = "sohu": exit function
	if instr(str,"����")>0 then getReferedId = "iask": exit function
	if instr(str,"���䷿")>0 then getReferedId = "6rooms": exit function
	if instr(str,"qq")>0 then getReferedId = "qq": exit function
	if instr(str,"youtube")>0 then getReferedId = "youtube": exit function
	if instr(str,"17173")>0 then getReferedId = "17173": exit function
	if instr(str,"ku6��Ƶ")>0 then getReferedId = "ku6": exit function
	if instr(str,"FLV")>0 then getReferedId = "flv": exit function
	if instr(str,"SWF")>0 then getReferedId = "swf": exit function
	if instr(str,"real")>0 then getReferedId = "real": exit function
	if instr(str,"media")>0 then getReferedId = "media": exit function
	if instr(str,"qvod")>0 then getReferedId = "qvod": exit function
	if instr(str,"ppstream")>0 then getReferedId = "pps": exit function
	if instr(str,"Ѹ������")>0 then getReferedId = "gvod": exit function
	if instr(str,"Զ�Ÿ���")>0 then getReferedId = "wp2008": exit function
	if instr(str,"xigua")>0 then getReferedId = "xigua": exit function
	if instr(str,"����Pvod")>0 then getReferedId = "pvod": exit function
	if instr(str,"����CC")>0 then getReferedId = "cc": exit function
	if instr(str,"����Ӱ��")>0 then getReferedId = "jjvod": exit function
	if instr(str,"pptv")>0 then getReferedId = "pptv": exit function
	if instr(str,"����")>0 then getReferedId = "qiyi": exit function
	if instr(str,"�ٶ�Ӱ��")>0 then getReferedId = "bdhd": exit function
	if instr(str,"����")>0 then getReferedId = "letv": exit function
        if instr(str,"cntv")>0 then getReferedId = "cntv": exit function
	if instr(str,"Ӱ���ȷ�")>0 then getReferedId = "xfplay": exit function
	if instr(str,"xfplay")>0 then getReferedId = "xfplay": exit function
	if instr(str,"����Ӱ��")>0 then getReferedId = "jjvod": exit function
	if instr(str,"jjvod")>0 then getReferedId = "jjvod": exit function
End Function

Function downSinglePic(picUrl,vid,vname,filePath,infotype)
	dim streamLen,spanstr,fileext
	if infotype="" then spanstr="" else spanstr="<br/>"
	on error resume next
	if isNul(picUrl) or instr(picUrl,"http://")=0 then echo "����<font color=red>"&vname&"</font>��ͼƬ·������1,�����Ƿ���Ч  "&spanstr : downSinglePic=false :Exit Function
	fileext=getFileFormat(filePath)
	if fileext="" then:fileext=".jpg":filePath=filePath&fileext:end if
	if fileext<>"" AND InStr("|.jpg|.gif|.png|.bmp|.jpeg|",LCase(fileext))>0 then
		dim imgStream : imgStream=getRemoteContent(picUrl,"body")
		dim createStreamFileFlag:createStreamFileFlag=createStreamFile(imgStream,filePath)
		if err or createStreamFileFlag=false then 
			if isNul(vid) then
				echo "����<font color=red>"&vname&"</font>��ͼƬ���ط�������3,�����Ƿ���Ч  "&spanstr:err.clear : downSinglePic=false
			else
				echo "����<font color=red>"&vname&"</font>��ͼƬ���ط�������4,idΪ<font color=red>"&vid&"</font>,�����Ƿ���Ч  "&spanstr: err.clear : downSinglePic=false
			end if
		else
			streamLen=lenB(imgStream)
			if streamLen<1024*2 then
				echo "����<font color=red>"&vname&"</font>��ͼƬ���ط�������5,�����Ƿ���Ч  "&spanstr:err.clear:downSinglePic=false
			else
				echo "����<font color=red>"&vname&"</font>��ͼƬ���سɹ�,��СΪ<font color=red>"&formatnumber(streamLen/1024,2)&"</font>KB <a target=_blank href="&filePath&">Ԥ��ͼƬ</a>  "&spanstr:downSinglePic=true
			end if
		end if
	else
			echo "����<font color=red>"&vname&"</font>��ͼƬ���ط�������6,ͼƬ��ʽ����  "&spanstr:err.clear:downSinglePic=false
	end if
End Function

Sub makeTypeOptionSelected(topId,separateStr,compareValue)
	Dim i,j,k,m,TL,selectedStr:TL=getTypeLists():j=getTypeindex("m_id"):k=getTypeindex("m_upid"):m=getTypeindex("m_name")
	for i=0 to UBound(TL,2)
		if ""&TL(k,i)=""&topId then
			if clng(topId)<>0 then span=span&separateStr
			if compareValue=TL(j,i) then selectedStr=" selected" else selectedStr=""
			echo "<option value='"&TL(j,i)&"' "&selectedStr&">"&span&"&nbsp;|��"&TL(m,i)&"</option>"
			makeTypeOptionSelected TL(j,i),separateStr,compareValue
		end if
	next
	if not isNul(span) then span = left(span,len(span)-len(separateStr))
End Sub

Sub makeNewsTypeOptionSelected(topId,separateStr,compareValue)
	Dim i,j,k,m,TL,selectedStr:TL=getNewsTypeLists():j=getTypeindex("m_id"):k=getTypeindex("m_upid"):m=getTypeindex("m_name")
	for i=0 to UBound(TL,2)
		if ""&TL(k,i)=""&topId then
			if clng(topId)<>0 then span=span&separateStr
			if compareValue=TL(j,i) then selectedStr=" selected" else selectedStr=""
			echo "<option value='"&TL(j,i)&"' "&selectedStr&">"&span&"&nbsp;|��"&TL(m,i)&"</option>"
			makeNewsTypeOptionSelected TL(j,i),separateStr,compareValue
		end if
	next
	if not isNul(span) then span = left(span,len(span)-len(separateStr))
End Sub

Function timeToStr(Byval t)
	t=Replace(Replace(Replace(Replace(t,"-",""),":","")," ",""),"/","") : timeToStr=t
End Function

Sub isCurrentDay(timeStr)
	if isNul(timeStr) then echo "":Exit Sub
	dim timeStr2 : timeStr2=date
	if instr(timeStr,timeStr2)>0 then  echo "<span style='color:red;font-size:10px'>"&timeStr&"</span>" else echo "<span style='font-size:10px'>"&timeStr&"</span>"
End Sub
%>