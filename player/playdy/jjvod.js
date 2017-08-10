var zhuangtai;
zhuangtai = 1;
function jjvodstatus(offest){
	var playerS = document.getElementById('jjvodPlayer');
    if(playerS.PlayState==3){
         document.getElementById('jjad').style.display='none';
         zhuangtai = 3;
    }else if(playerS.PlayState==2||playerS.PlayState==4){//暂停和缓冲
         document.getElementById('jjad').style.display='block';
         zhuangtai = 4;
   	//}else if(playerS.PlayState==12){//播放完成
		//  if(jjvod_nextpage!=''){
		//	window.document.location.href=jjvod_nextpage;
		 // }
		}else  if(playerS.PlayState==12&&zhuangtai>1){
		   if(jjvod_nextpage!=''){
		 	  top.location.href=jjvod_nextpage;
		   }
	  }
}



//调用JJVOD代码
function addJJVod(){
if(!!window.ActiveXObject || "ActiveXObject" in window){
		document.write("<div style='position:relative'>");
		document.write('<div id="jjad" style="position:absolute; z-index:1001"><iframe marginWidth="0" id="wdqad" name="wdqad" marginHeight="0" src="'+jjvod_ad+'" frameBorder="0" width="'+jjvod_w+'" scrolling="no" height="390"></iframe></div>');
		document.write("<object classid='clsid:C56A576C-CC4F-4414-8CB1-9AAC2F535837' width='"+jjvod_w+"' height='"+jjvod_h+"' id='jjvodPlayer' name='jjvodPlayer' onerror=\"document.getElementById('jjvodPlayer').style.display='none';document.getElementById('jjad').style.display='block';document.getElementById('wdqad').src='"+jjvod_install+"';\"><PARAM NAME='URL' VALUE='"+jjvod_url+"'><PARAM NAME='WEB_URL' VALUE='"+jjvod_weburl+"'><param name='Autoplay' value='1'></object>");
		document.write("</div>");
		var ver = chkJJActivexVer();
		setInterval('jjvodstatus()','1000');

}else{
	if (navigator.plugins) {
		var install = false;
		for (var i=0;i<navigator.plugins.length;i++) {
			if(navigator.plugins[i].name == 'JJvod Plugin'){
				install = true;break;
			}
		}
		
		if(install){//已安装
			document.write('<div style="width:'+jjvod_w+'px; height:'+jjvod_h+'px;overflow:hidden;position:relative">');
			document.write('<div id="jjad" style="position:absolute;z-index:2;top:0px;left:0px"><iframe border="0" src="'+jjvod_ad+'" marginWidth="0" frameSpacing="0" marginHeight="0" frameBorder="0" noResize scrolling="no" width="'+jjvod_w+'" height="410" vspale="0"></iframe></div>');
			document.write('<object id="jjvodPlayer" name="jjvodPlayer" TYPE="application/x-itst-activex" ALIGN="baseline" BORDER="0" WIDTH="'+jjvod_w+'" HEIGHT="'+jjvod_h+'" progid="WEBPLAYER.WebPlayerCtrl.2" param_URL="'+jjvod_url+'" param_WEB_URL="'+jjvod_weburl+'"></object>');
			document.write("</div>");
			setInterval('jjvodstatus()','1000');
		}else{
			document.write('<div id="jjad"><iframe border="0" src="'+jjvod_install+'" marginWidth="0" frameSpacing="0" marginHeight="0" frameBorder="0" noResize scrolling="no" width="'+jjvod_w+'" height="410" vspale="0"></iframe></div>');
		}
	}
}
}

function killErrors(){return true;}
window.onerror = killErrors;

addJJVod();

function chkJJActivexVer(){
	var playerS = document.getElementById('jjvodPlayer');
	if(playerS.GetVer&&typeof(playerS.GetVer)=="number"){
		return ;
	}else{//老版本
		var play = checkPlugins('WEBPLAYER.WebPlayerCtrl.1');
		if(play){
			if(confirm("请下载升级最新吉吉影音播放器，以便更流畅播放影片！")){
				window.location.href="http://dl.jijivod.com/JJPlayer_"+jjvod_c+".exe";
			}else{
				return false;
			}
		}
	}
}

function checkPlugins(activexObjectName) {
	var np = navigator.plugins;	
	if (np && np.length)// 针对于FF等非IE.
	{
		for(var i = 0; i < np.length; i ++) {
			if(np[i].name.indexOf(activexObjectName)!= -1)
			{
				return true;
			}
		}
	}
	else if (window.ActiveXObject)// 针对于IE
	{
		try {
			new ActiveXObject(activexObjectName);
			return true;
		}
		catch (e) {
			return false;
		}
	}
	return false;
}

function jjplay_prev(){
	if(jjvod_prevpage!=""){
		window.document.location.href = jjvod_prevpage;
	}else{
		alert("没有上一集可播放的地址了！");	
		return false;
	}
}

function jjplay_next(){
	if(jjvod_nextpage!=""){
		window.document.location.href = jjvod_nextpage;
	}else{
		alert("没有下一集可播放的地址了！");	
		return false;
	}
}

var EventUtil =
	{
	    addHandler: function (element, type, handler) {
	        if (element.addEventListener) {
	            element.addEventListener(type, handler, false);
	        }
	        else {
	            element.attachEvent("on" + type, handler);
	        }
	    },

	    removeHandler: function (element, type, handler) {
	        if (element.removeEventListener) {
	            element.removeEventListener(type, handler, false);
	        }
	        else {
	            element.detachEvent("on" + type, handler);
	        }
	    }
	};    
var unloadhandler = function () {
	var playerS = document.getElementById('jjvodPlayer');
        if (playerS != null) {
            playerS.Close();
            playerS = null;
        }
}

var beforeunloadhandler = function () { 
  /* var n = window.event.screenX - window.screenLeft;    
   var b = n > document.documentElement.scrollWidth-20;    
    if(b && window.event.clientY < 0 || window.event.altKey)    
    {    
         alert("是关闭而非刷新");    
         window.event.returnValue = ""; //这里可以放置你想做的操作代码    
   }*/
   var playerS = document.getElementById('jjvodPlayer');
   if (playerS != null) {
       playerS.Close();
       playerS = null;
   }
}  
//EventUtil.addHandler(window, "unload", unloadhandler);
EventUtil.addHandler(window, "beforeunload", beforeunloadhandler);