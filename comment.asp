<!--#include file="inc/config.asp"-->
<%
'******************************************************************************************
' Software name: Max(����˹) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: ʯͷ(maxcms2008@qq.com),yuet,����,��ƿ
' Copyright (C) 2005-2009 ����˹�ٷ� ��Ȩ����
' ����������MaxCMS�������д���100%ԭ����δ�����κ����ϴ���,��һ�г�Ϯ��Ϊ���������׷����������
'******************************************************************************************
response.Charset="gbk"

if commentStart= 0 then response.write("�Բ���������ʱ�ر�"):response.end
dim itype:itype=request("type")
if isNumeric(itype) then
	itype=Clng(itype)
else
	itype=1
end if
%>
<iframe width="100%" height="1" frameborder="0" scrolling="no" src="/<%=sitepath%>comment/index.html?id=<%=request("id")%>&type=<%=itype%>&title=" marginheight="0" marginwidth="0" name="comment" style="height: 791px;"></iframe>