<%
'******************************************************************************************
' Software name: Max(马克斯) Content Management System
' Version:4.0
' Web: http://www.maxcms.net
' Author: 石头(maxcms2008@qq.com),yuet,长明,酒瓶
' Copyright (C) 2005-2009 马克斯官方 版权所有
' 法律申明：MaxCMS程序所有代码100%原创、未引入任何网上代码,对一切抄袭行为、坚决严肃追究法律责任
'******************************************************************************************
dim err_dbconect,err_rsopen,err_cachename,err_cachevalue,err_stmobj,err_fsoobj,err_loadfile,err_replace,err_primarykey,err_table,err_writefile,err_createFolder,err_delFolder,err_delFile,err_notExistFolder,err_moveFolder,err_xmlHttp,err_xml,err_areaList,channellistInfo(1),searchlistInfo(1),pageRunStr(2),topicpageInfo(0),newspageInfo(0)
err_dbconect="数据库连接错误"
err_rsopen="执行SQL语句错误"
err_cachename="请设置缓存名称"
err_cachevalue="缓存值不存在"
err_stmobj="st"&"ream对象实例创建失败"
err_fsoobj="F"&"SO对象实例创建失败" 
err_loadfile="加载文件失败"
err_replace="字符串替换发生错误"
err_primarykey="数据列表未指定主键"
err_table="数据列表未指定表"
err_writefile="写入文件失败"
err_createFolder="创建文件夹失败"
err_delFolder="删除文件夹失败"
err_delFile="删除文件失败"
err_notExistFolder="文件夹不存在"
err_moveFolder="移动文件夹失败"
err_xmlHttp="您的服务器无法访问外网"
err_xml = "加载xml发生错误"
err_areaList="循环标签分类设置错误"
newspageInfo(0)="<font color='red'> 对不起，无任何新闻 </font>"
topicpageInfo(0)="<font color='red'> 对不起，该专题无记录任何记录 </font>"
channellistInfo(0)="<font color='red'> 对不起，该分类无记录任何记录 </font>":channellistInfo(1)="指定分类错误"
searchlistInfo(0)=" <div class='col-xs-12 col-md-12' ><div class='alert alert-warning'> 对不起，没有找到任何记录,<a target='_blank' href='gbook.asp?key=":searchlistInfo(1)="'><font color='red'><b>请您在此留言</b></font></a>，我们尽快为你添加喜欢的数据2018210787405</div></div>"
pageRunStr(0)="页面执行时间: ":pageRunStr(1)="秒&nbsp;":pageRunStr(2)="次数据查询"
%>