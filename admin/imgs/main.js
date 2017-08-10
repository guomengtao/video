var ajax = new AJAX();ajax.setcharset("GBK");

function openUpdateWin(width, height,str){
	openWindow2(101,width,height,50)
	var msgDiv=$("msg")
	var bgDiv=$("bg")
	var iWidth = document.documentElement.scrollWidth
	var str="<div style='width:400px;'><div class='divboxtitle'><span onclick=\"closeWin();set($('update'),'<font color=red >版本暂未升级...</font>');\" ><img src='../pic/btn_close.gif'/></span>MaxCms4.0在线升级</div><div  class='divboxbody'>"+str+"<input type='button' value='进入升级页面' id='openwin' class='btn'/>&nbsp;&nbsp;&nbsp;&nbsp;<input id='closewin' type='button' value='取   消' name='button' class='btn'  /></div><div class='divboxbottom'>Power By Maxcms4.0</div></div>"
	msgDiv.style.cssText += "FONT-SIZE: 12px;top:100px;left:"+(iWidth-width)/2+"px;text-align:center;";
	set(msgDiv,str)
	$("closewin").onclick = function(){
		closeWin()
		set($("update"),"<font color='red'>版本暂未升级...</font>");
	}
	$("openwin").onclick = function(){
		closeWin()
		location.href='admin_update.asp';
	}
}
 
function checkNewVersionCallBack(obj){
	 
	if (obj.responseText == "False"){
		set($("update"),"<font color='red'>暂时没有可升级文件!</font>");
	}else{
		openUpdateWin(400, "auto",obj.responseText)	
	}
}

function checkNewVersion(){
	set($("update"),"<font color='red'>请稍等，正在检测新版本...</font>");
	var getUrl = "admin_update.asp?action=isNew";
	ajax.get(
		getUrl,
		checkNewVersionCallBack
	);	
}

function checkRepeat(){
	ajax.get(
		"admin_ajax.asp?action=checkrepeat&m_name="+$('m_name').value,
		function(obj){
			if (obj.responseText == "ok"){set($("m_name_ok"),"<img src='imgs/yes.gif' border=0></img>");}else{set($("m_name_ok"),"<img src='imgs/no.gif' border=0></img>");}
		}
	);	
}

function setVideoTopic(videoId,topicId){
	openWindow2(101,230,20,0)
	var msgDiv=$("msg")
	var topicTDObj = $("topic"+videoId);
	var topicTDTop = topicTDObj.offsetTop;
    var topicTDLeft = topicTDObj.offsetLeft;
    while (topicTDObj = topicTDObj.offsetParent){topicTDTop+=topicTDObj.offsetTop; topicTDLeft+=topicTDObj.offsetLeft;}
    msgDiv.style.cssText+="border:1px solid #55BBFF;background: #C1E7FF;padding:3px 0px 3px 4px;"
	msgDiv.style.top = (topicTDTop-1)+"px";
    msgDiv.style.left = (topicTDLeft-1)+"px"; 
	msgDiv.innerHTML="正在加载内容....";	
	ajax.get(
		"admin_ajax.asp?id="+videoId+"&action=select&topicid="+topicId, 
		function(obj) {
			msgDiv.innerHTML=obj.responseText;
		}
	);
}

function setVideoState(videoId){
	openWindow2(101,250,20,0)
	var msgDiv=$("msg")
	var topicTDObj = $("state"+videoId);
	var topicTDTop = topicTDObj.offsetTop;
    var topicTDLeft = topicTDObj.offsetLeft; 
    while (topicTDObj = topicTDObj.offsetParent){topicTDTop+=topicTDObj.offsetTop; topicTDLeft+=topicTDObj.offsetLeft;}
    msgDiv.style.cssText+="border:1px solid #55BBFF;background: #C1E7FF;padding:3px 0px 3px 4px;"
	msgDiv.style.top = (topicTDTop-1)+"px";
    msgDiv.style.left = (topicTDLeft-1)+"px"; 
	msgDiv.innerHTML="状态：连载到第<input type='text' size='5' id='series' name='series'>集<input type='button' value='确定' onclick='submitVideoState("+videoId+")' class='btn' /><input type='button' value='取消' onclick='closeWin()' class='btn' />";	
}

function submitVideoTopic(videoId){
	var topic = $("topicselect").value
	if (topic.length==0) {
		alert('请选择专题')
		return false
	}
	ajax.get(
		"admin_ajax.asp?id="+videoId+"&topic="+topic+"&action=submittopic", 
		function(obj) {
			if(obj.responseText == "submitok"){
				set($("topic"+videoId),"<font color='red'>"+$("topicselect").options[$("topicselect").selectedIndex].text+"</font>");
				closeWin();
			}else{
				set($("topic"+videoId),"<font color='red'>发生错误</font>");		
			}
		}
	);
}

function submitVideoState(videoId){
	var state = $("series").value
	if (isNaN(state)) {
		alert('集数为数字')
		return false
	}else if(state == 'undefined' || state == ''){
		alert('集数不能为空')
		return false
	}
	ajax.get(
		"admin_ajax.asp?id="+videoId+"&state="+state+"&action=submitstate", 
		function(obj) {
			if(obj.responseText == "submitok"){
				set($("state"+videoId),"<font color='red'>(连载到"+state+"集)</font>");
				closeWin();
			}else{
				set($("state"+videoId),"<font color='red'>发生错误</font>");		
			}
		}
	);
}

function selectPicLink(selectObj,str){
	var selectValue=selectObj.options[selectObj.selectedIndex].value
	if 	(selectValue==str)
		$("tr_m_pic").style.display=""
	else 
		$("tr_m_pic").style.display="none"
}

function openAdWin(divid,path,url){
	$(divid).style.display="block";
	selfLabelWindefault(divid);	
	$("adpath").value='<script type=\"text/javascript\" language=\"javascript" src=\"'+url+path.replace("../","")+'\"></script>';	
}

function openHtmlToJsWin(divid){
	$(divid).style.display="block";
	selfLabelWindefault(divid);	
}

function insertHtmlToJsWin(divid,divid2,divid3){
	hide(divid);
	$(divid2).value=$(divid3).value
}

function openSelfLabelWin(divid,id){
	$(divid).style.display="block";
	selfLabelWindefault(divid);	
	set($("labelcontent"),"代码加载中...");	
	ajax.get(
		"admin_ajax.asp?id="+id+"&action=getselflabel", 
		function(obj) {
			if(obj.responseText == "err"){
				set($("labelcontent"),"发生错误");	
			}else{
				set($("labelcontent"),obj.responseText);
			}
		}
	);
}

function selfLabelWindefault(divid){	
	$(divid).style.left=(document.documentElement.clientWidth-568)/2+"px"
	$(divid).style.top=(getScroll()+60)+"px"
}

function viewCurrentAdTr(id){
	var adtrObj=getElementsByName("tr","adtr")
	var n=adtrObj.length
	for (var i=0;i<=n-1;i++){
		adtrObj[i].className="";
	}
	$("adtr"+id).className="editlast";
}

function isExistUsername(id){
	var username=$("m_username").value
	if (username.length == 0){
		set($("checkmanagername"),"管理员名称不能为空");
		return false; 
	}
	ajax.get(
		"admin_ajax.asp?username="+username+"&action=checkuser&id="+id, 
		function(obj) {
			var value = obj.responseText
			if(value == "no"){
				set($("checkmanagername"),"发生错误");	
			}else{
				if (value == "1")
					set($("checkmanagername"),"已经存在此管理员，请更换名称");	
				else if (value == "0")
					set($("checkmanagername"),"恭喜，该用户名可用");	
			}
		}
	);
}

function selectDataBase(value){
	if (value==0){view("acc");hide("mssql")}
	if (value==1){hide("acc");view("mssql")}
}

function selectCache(value){
	if (value==1){view("cacheset");}
	if (value==0){hide("cacheset");}
}

function selectAlertWin(value){
	if (value==1){view("alertwinset");}
	if (value==0){hide("alertwinset");}
}

function selectWaterMark(value){
	if (value==1){view("watermarkfont");}
	if (value==0){hide("watermarkfont");}
}

function selecMakeMode(value){
	if (value=='dir1' || value=='dir3' || value=='dir5' || value=='dir7'){
		hide("dir2");view("dir1");
	}
	if (value=='dir2' || value=='dir4' || value=='dir6' || value=='dir8'){
		view("dir2");hide("dir1");
	}
}

function selecRunMode(value){
	if (value=='dynamic'){
		hide("static");view("dynamic");hide("forgedStatic");hide('ismakeplaytr');hide("dir2");hide("dir1");selectMakeplay();
	}
	if (value=='static'){
		view("static");hide("dynamic");hide("forgedStatic");view('ismakeplaytr');selecMakeMode($('makemode')[$('makemode').selectedIndex].value);selectMakeplay();
	}
	if (value=='forgedStatic'){
		hide("static");view("forgedStatic");hide("dynamic");hide('ismakeplaytr');hide("dir2");hide("dir1");selectMakeplay();
	}
}

function selecNewsMakeMode(value){
	if (value=='dir1' || value=='dir3' || value=='dir5' || value=='dir7'){
		hide("newsdir2");view("newsdir1");
	}
	if (value=='dir2' || value=='dir4' || value=='dir6' || value=='dir8'){
		view("newsdir2");hide("newsdir1");
	}
}

function selecNewsRunMode(value){
	if (value=='dynamic'){
		hide("newsstatic");view("newsdynamic");hide("newsforgedStatic");hide("newsdir2");hide("newsdir1");
	}
	if (value=='static'){
		view("newsstatic");hide("newsdynamic");hide("newsforgedStatic");selecNewsMakeMode($('newsmakemode')[$('newsmakemode').selectedIndex].value);
	}
	if (value=='forgedStatic'){
		hide("newsstatic");view("newsforgedStatic");hide("newsdynamic");hide("newsdir2");hide("newsdir1");
	}
}

function selectCacheSearch(v){
	$('CacheSearch').style.display=v=='1' ? '' : 'none';
}

function selectMakeplay(){
return;
	var y=$('ismakeplay'),v=y[y.selectedIndex].value,b=$('paramset2'),r=$('runmode'),x=r[r.selectedIndex].value;
	if(v=='3' && x=='static'){
		var a=$('paramset1');
		selectMakeplay.i = a.checked ? 1 : 2;
		a.checked=true;a.onclick();
		b.disabled=true;
	}else if (b.disabled){
		if(selectMakeplay.i==2){
			b.checked=true;b.onclick();
		}
		b.disabled=false;
	}
}

function onTxtChange(input){
	input.value=input.value.replace(/[^\w_]/ig,'');
}

function starView(level,vid){
	var i,j,htmlStr;
	var htmlStr=""
	if (level==0){level=0}
	if (level>0){htmlStr+="<img src='imgs/starno.gif' border='0' style='cursor:pointer;margin-left:2px;' title='取消推荐'  onclick='commendVideo("+vid+",0)'/>"}
	for (i=1;i<=level;i++){
		htmlStr+= "<img src='../pic/star0.gif' border='0' style='cursor:pointer;margin-left:2px;' onclick='commendVideo("+vid+","+i+")' title='推荐为"+i+"星级' id='star"+vid+"_"+i+"'  />"
	}
	for(j=level+1;j<=5;j++){
		htmlStr+= "<img src='../pic/star1.gif' border='0' style='cursor:pointer;margin-left:2px;' onclick='commendVideo("+vid+","+j+")' title='推荐为"+j+"星级' id='star"+vid+"_"+j+"' />"
	}
	set($('star'+vid),htmlStr)
}

function commendVideo(vid,commendid){
	ajax.get(
		"admin_ajax.asp?id="+vid+"&commendid="+commendid+"&action=commend", 
		function(obj){
			if(obj.responseText == "submitok"){
				starView(commendid,vid);
			}else{
				set($("star"+vid),"<font color='red'>发生错误</font>");		
			}
		}
	);
}

function viewCurrentTopicTr(id){
	var topictrObj=getElementsByName("tr","topictr")
	var n=topictrObj.length
	for (var i=0;i<=n-1;i++){
		topictrObj[i].style.background="#ffffff";	
	}
	$("topictr"+id).style.background="#E7E7E7";
}

function openTopicDesWin(divid,id){
	selfLabelWindefault(divid);	
	view(divid)
	$("f_m_id").value=id
	set($("f_m_des"),"加载中...");	
	ajax.get(
		"admin_ajax.asp?id="+id+"&action=gettopicdes", 
		function(obj) {
			if(obj.responseText == "err"){
				set($("f_m_des"),"发生错误");	
			}else{
				set($("f_m_des"),obj.responseText);
			}
		}
	);
}

function submitTopicDes(divid){
	ajax.postf(
		$("f_des"),
		function(obj){if(obj.responseText=="ok"){hide(divid);alert('修改成功');}else{alert('发生错误');}}
	);
}

function gather(){
	var url=$("gatherurl").value
	if(url.length == 0) 
		return false
	else{
		view("loading")
		ajax.get(
			"admin_webgather.asp?url="+url+"&action=gather", 
			function(obj) {
				if(obj.responseText == "err"){
					$("gathercontent").value = "发生错误";	
				}else{
					$("gathercontent").value = obj.responseText;
				}
				hide("loading")
			}
		);
	}
}

function insertResult(i){
	var id=$("areaid").value
	$("m_playurl"+id).value += ($("m_playurl"+id).value!='' ? "\n" : '')+$("gathercontent").value
	$("gatherurl").value=''
	$("gathercontent").value=''
	$("areaid").value=i;
	hide('gathervideo')
}

function getReferedId(str){
	if(str.indexOf('土豆高清')>-1) return "hd_tudou"
	if(str.indexOf('新浪高清')>-1) return "hd_iask"
	if(str.indexOf('搜狐高清')>-1) return "hd_sohu"
	if(str.indexOf('天线高清')>-1) return "hd_openv"
	if(str.indexOf('56高清')>-1) return "hd_56"
	if(str.indexOf('56')>-1) return "56"
	if(str.indexOf('优酷')>-1) return "youku"
	if(str.indexOf('土豆')>-1) return "tudou"
	if(str.indexOf('搜狐')>-1) return "sohu"
	if(str.indexOf('新浪')>-1) return "iask"
	if(str.indexOf('六间房')>-1) return "6rooms"
	if(str.indexOf('qq')>-1) return "qq"
	if(str.indexOf('youtube')>-1) return "youtube"
	if(str.indexOf('17173')>-1) return "17173"
	if(str.indexOf('ku6视频')>-1) return "ku6"
	if(str.indexOf('FLV')>-1) return "flv"
	if(str.indexOf('SWF')>-1) return "swf"
	if(str.indexOf('real')>-1) return "real"
	if(str.indexOf('media')>-1) return "media"
	if(str.indexOf('qvod')>-1) return "qvod"
	if(str.indexOf('ppstream')>-1) return "pps"
	if(str.indexOf('迅播高清')>-1) return "gvod"
	if(str.indexOf('远古高清')>-1) return "wp2008"
	if(str.indexOf('播客CC')>-1) return "cc"
	if(str.indexOf('ppvod高清')>-1) return "ppvod"
	if(str.indexOf('xigua')>-1) return "xigua"
	if(str.indexOf('吉吉影音')>-1) return "jjvod"
	if(str.indexOf('pptv')>-1) return "pptv"
	if(str.indexOf('奇艺')>-1) return "qiyi"
	if(str.indexOf('百度影音')>-1) return "bdhd"
	if(str.indexOf('乐视')>-1) return "letv"
    if(str.indexOf('cntv')>-1) return "cntv"
	if(str.indexOf('xfplay')>-1) return "xfplay"
	if(str.indexOf('jjvod')>-1) return "jjvod"
	if(str.indexOf('影音先锋')>-1) return "xfplay"
	return ""
}

function repairUrl(i){
	var urlStr,urlArray,newStr,j,flagCount,fromText,t
	fromText=$("m_playfrom"+i).options[$("m_playfrom"+i).selectedIndex].value
	if (fromText.length==0){alert('请选择播放器类型');return false;}
	urlStr=$('m_playurl'+i).value
	if (urlStr.length==0){alert('请填写地址');return false;}
	if(navigator.userAgent.indexOf("Firefox")>0){urlArray=urlStr.split("\n");}else{urlArray=urlStr.split("\r\n");}
	newStr="";
	for(j=0;j<urlArray.length;j++){
		if(urlArray[j].length>0){
			t=urlArray[j].split('$'),flagCount=t.length-1
			switch(flagCount){
				case 0:
					urlArray[j]='第'+(j<9 ? '0' : '')+(j+1)+'集$'+urlArray[j]+'$'+getReferedId(fromText)
					break;
				case 1:
					urlArray[j]=urlArray[j]+'$'+getReferedId(fromText)
					break;
				case 2:
					if(t[2]==''){
						urlArray[j]=urlArray[j]+getReferedId(fromText)
					}
					break;
			}
			if(urlArray[j].indexOf('qvod://')!=-1){
				var t=urlArray[j].split("$");
				t[1]=t[1].replace(/[\u3016\u3010\u005b]\w+(\.\w+)*[\u005d\u3011\u3017]/ig,'').replace(/(qvod:\/\/\d+\|\w+\|)(.+)$/i,'$1['+(window.siteurl || document.domain)+']$2').replace(/(^\s*)|(\s*$)/ig,'');
				urlArray[j]=t.join("$");
			}
			newStr+=urlArray[j]+"\r\n";
		}
	}
	$('m_playurl'+i).value=trimOuterStr(newStr,"\r\n");
}

function repairUrl2(i){
	var urlStr,urlArray,newStr,j,flagCount,fromText
	fromText=$("m_downfrom"+i).options[$("m_downfrom"+i).selectedIndex].value
	if (fromText.length==0){alert('请选择下载类型');return false;}
	urlStr=$('m_downurl'+i).value
	if (urlStr.length==0){alert('请填写地址');return false;}
	if(navigator.userAgent.indexOf("Firefox")>0){urlArray=urlStr.split("\n");}else{urlArray=urlStr.split("\r\n");}
	newStr="";
	for(j=0;j<urlArray.length;j++){
		if(urlArray[j].length>0){
			flagCount=urlArray[j].split('$').length-1
			switch(flagCount){
				case 0:
					urlArray[j]='第'+(j<9 ? '0' : '')+(j+1)+'集$'+urlArray[j]+'$down'
					break;
				case 1:
					urlArray[j]=urlArray[j]+'$down'
					break;
				case 2:
					break;
			}
			newStr+=urlArray[j]+"\r\n";
		}
	}
	$('m_downurl'+i).value=trimOuterStr(newStr,"\r\n");
}

function expendPlayArea(i,optionStr,type){
	if(expendPlayArea.i===false){
		expendPlayArea.i=i
	}else{
		i=++expendPlayArea.i;
	}
	optionStr=unescape(optionStr)
	var n=i-1,m=i+1
	var sparkStr=(type==1)?"&nbsp;&nbsp;<font color='red'>＊</font>":""
	var sparkStr2=(type==1)?"<font color='blue' style='position:absolute;left: 510px;line-height:28px;white-space:nowrap'>地址单集格式： <font color='red'>标题$ID$来源</font>(多集换行隔开)</font>":""
	var area="<table width='100%' id='playfb"+i+"'><tr class='noborder-tb'><td align='right' height='22' width='70'>播放来源"+i+"：</td><td>"+sparkStr2+"<select id='m_playfrom"+i+"' name='m_playfrom'><option value=''>暂无数据"+i+"</option>"+optionStr+"</select>&nbsp;&nbsp;<input type='button' class='btn' value='WEB采集' onclick='viewGatherWin("+i+");selectTogg();'/>&nbsp;&nbsp;<img onclick=\"var tb=$('playfb"+i+"');tb.parentNode.removeChild(tb);\"  src='imgs/btn_dec.gif' class='pointer' alt='删除播放来源"+i+"' align='absmiddle' />&nbsp;&nbsp;<a href=\"javascript:moveTableUp($('playfb"+i+"'))\">上移</a>&nbsp;&nbsp;<a href=\"javascript:moveTableDown($('playfb"+i+"'))\">下移</a>"+sparkStr+"</td></tr><tr><td align='right' height='22'>数据地址"+i+"：<br/><input type='button' value='校正' title='校正右侧文本框中的数据格式' class='btn'  onclick='repairUrl("+i+")'/></td><td><textarea id='m_playurl"+i+"' name='m_playurl' rows='8' cols='100'></textarea>"+sparkStr+"</td></tr></table>"
	var _nextdiv=document.createElement("div");
	_nextdiv.innerHTML=area
	$('m_playarea').appendChild(_nextdiv.getElementsByTagName('table')[0]);
	_nextdiv=null;
}
expendPlayArea.i=false;

function expendDownArea(i,optionStr,type){
	if(expendDownArea.i===false){
		expendDownArea.i=i
	}else{
		i=++expendDownArea.i;
	}
	optionStr=unescape(optionStr)
	var n=i-1,m=i+1
	var sparkStr=(type==1)?"&nbsp;&nbsp;<font color='blue' style='position:absolute;left: 400px;line-height:18px;white-space:nowrap'>地址单集格式：<font color='red'>下载名称$下载地址$down</font>(多集换行隔开)</font>":""
	var area="<table width='100%' id='downfb"+i+"'><tr><td align='right' height='22' width='70'>下载来源"+i+"：</td><td>"+sparkStr+"<select id='m_downfrom"+i+"' name='m_downfrom'><option value=''>暂无数据"+i+"</option>"+optionStr+"</select>&nbsp;&nbsp;<img onclick=\"var tb=$('downfb"+i+"');tb.parentNode.removeChild(tb);\"  src='imgs/btn_dec.gif' class='pointer' alt='删除下载来源"+i+"' align='absmiddle' />&nbsp;&nbsp;<a href=\"javascript:moveTableUp($('downfb"+i+"'))\">上移</a>&nbsp;&nbsp;<a href=\"javascript:moveTableDown($('downfb"+i+"'))\">下移</a></td></tr><tr><td align='right' height='22'>下载地址"+i+"：<br/><input type='button' value='校正' title='校正右侧文本框中的下载格式' class='btn'  onclick='repairUrl2("+i+")'/></td><td><textarea id='m_downurl"+i+"' name='m_downurl' rows='8' cols='100'></textarea></td></tr></table>";
	var _nextdiv=document.createElement("div");
	_nextdiv.innerHTML=area
	$('m_downarea').appendChild(_nextdiv.getElementsByTagName('table')[0]);
	_nextdiv=null;
}
expendDownArea.i=false;

function expendPlayerSkin(i){
	var str="皮肤"+(i+1)+" :背景颜色 #<input type='text' name='playerbgcolor'  alt='clrDlg0"+i+"' /> 文字颜色 #<input type='text' name='playerfontcolor'  alt='clrDlg1"+i+"' /><br><div id='addplayerskin"+i+"'><img  src='imgs/btn_add.gif' onclick='expendPlayerSkin("+(i+1)+")'  style='cursor:pointer'/></div>";
	var _nextdiv=document.createElement("div")
	set(_nextdiv,str)
	$('playerskindiv').appendChild(_nextdiv)
	if(i>0){hide("addplayerskin"+(i-1))}
}

function viewGatherWin(i){
	$('gathervideo').style.display='block';$("areaid").value=i;selfLabelWindefault('gathervideo');
}

function alertUpdatePic(){
	ajax.get(
		"admin_ajax.asp?action=updatepic", 
		function(obj) {
			if(obj.responseText > 0){
				view('updatepic');set($("updatepicnum"),obj.responseText)
			}
		}
	);
	floatBtttom("updatepic",500);
	}

function floatBtttom(id,retime) {
	$(id).style.top = (document.documentElement.scrollTop-0+document.documentElement.clientHeight-$(id).clientHeight)+"px";
	timer = setTimeout("floatBtttom('"+id+"',"+retime+");",retime);
}

function isViewState(){
	if ($("m_statebox").checked){$("m_statespan").style.display="inline";}	else{hide("m_statespan");$("m_state").value='';}
}

function clearCache(){
	set($("upcacheresult"),'加载中...')
	ajax.get(
		"admin_ajax.asp?action=restartcache", 
		function(obj) {
			if(obj.responseText == 'ok'){
				set($("upcacheresult"),'缓存更新成功')
			}else{
				set($("upcacheresult"),'缓存更新失败')
			}
		}
	);	
}

function htmlToJs(htmlinput,jsinput){
	$(jsinput).value="document.writeln(\""+$(htmlinput).value.replace(/\\/g,"\\\\").replace(/\//g,"\\/").replace(/\'/g,"\\\'").replace(/\"/g,"\\\"").split('\r\n').join("\");\ndocument.writeln(\"")+"\")"
} 

function jstohtml(jsinput,htmlinput){
	$(htmlinput).value=$(jsinput).value.replace(/document.writeln\("/g,"").replace(/document.write\("/g,"").replace(/"\);/g,"").replace(/\\\"/g,"\"").replace(/\\\'/g,"\'").replace(/\\\//g,"\/").replace(/\\\\/g,"\\").replace(/document.writeln\('/g,"").replace(/"\)/g,"").replace(/'\);/g,"").replace(/'\)/g,"")
}

function trimOuterStr(str,outerstr){
	var len1
	len1=outerstr.length;
	if(str.substr(0,len1)==outerstr){str=str.substr(len1)}
	if(str.substr(str.length-len1)==outerstr){str=str.substr(0,str.length-len1)}
	return str
}

function reverseOrder(){
	if($('gathercontent').value==""){alert("没有地址内容");return;}
	if(navigator.userAgent.indexOf("Firefox")>0){var listArray=$('gathercontent').value.split("\n");}else{var listArray=$('gathercontent').value.split("\r\n");}
	var newStr="";
	for(var i=listArray.length-1;i>=0;i--){
			newStr+=listArray[i]+"\r\n";
	}
	$('gathercontent').value=trimOuterStr(newStr,"\r\n");
}

function replaceStr(){
	var contentObj=$('gathercontent'),str="gi";
	if(contentObj.value==""){alert("没有地址内容");return;}
	var replace1=$("replace1").value,replace2=$("replace2").value;
	var content=contentObj.value;
	var reg=new RegExp(replace1,str);
	contentObj.value=content.replace(reg,replace2);	
}

function changeRowColor(tableId,trClass,n)
{
	var rows_changeColor = document.getElementById(tableId).getElementsByTagName('TR');
	for(var i=n;i<rows_changeColor.length;i++){
	rows_changeColor[i].onmouseover = function(){this.className=trClass;}
	rows_changeColor[i].onmouseout = function(){this.className="";}
	}

}

function viewComMakeOps(){view('tr_make_all');view('tr_make_type');view('tr_make_content');hide('tr_make_zt');hide('tr_make_self');$("makeHtmlTab").getElementsByTagName("li")[0].className="hover";$("makeHtmlTab").getElementsByTagName("li")[1].className="";}

function viewSpeMakeOps(){hide('tr_make_all');hide('tr_make_type');hide('tr_make_content');view('tr_make_zt');view('tr_make_self');$("makeHtmlTab").getElementsByTagName("li")[1].className="hover";$("makeHtmlTab").getElementsByTagName("li")[0].className="";}

function moveTableUp(o){
	if(!!o.previousSibling){
		o.parentNode.insertBefore(o,o.previousSibling);
	}
}
function moveTableDown(o){
	if(!!o.nextSibling){
		o.parentNode.insertBefore(o.nextSibling,o);
	}
}

function view(id){
	$(id).style.display='';
}
function hide(id){
	$(id).style.display='none';
}