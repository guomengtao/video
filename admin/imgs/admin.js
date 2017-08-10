function $(id){
	return document.getElementById(id)	
}

function focusLogin(){
	formsearch.input_name.focus();	
}

function changeMenu(key, url){
	if(key == 'index' && url == 'index.asp'){
		parent.location.href = 'index.asp';
		return false;
	}
	//左侧菜单切换操控
	for(var k in topMenus){
		if($('menu_' + topMenus[k])){
			$('menu_' + topMenus[k]).style.display = topMenus[k] == key ? '' : 'none';
		}
	}
	//上部菜单当前样式操控
	var lis = $('topmenu').getElementsByTagName('li');
	for(var i = 0; i < lis.length; i++){
		if(lis[i].className == 'navon') lis[i].className = '';
	}
	$('header_' + key).parentNode.parentNode.className = 'navon';
	//左侧菜当前链接显示操控
	if(url){
		parent.main.location = url;
		var hrefs = $('menu_' + key).getElementsByTagName('a');
		for(var j = 0; j < hrefs.length; j++){
			hrefs[j].className=hrefs[j].href.indexOf(url)!=-1? 'menucurr' : (hrefs[j].className == 'menucurr' ? '' : hrefs[j].className);
		}
	}
	return false;
}

function initMenu(menuContainerid){
	var key = '';
	var hrefs = $(menuContainerid).getElementsByTagName('a');
	for(var i = 0; i < hrefs.length; i++){			
		//初始化默认当前左链接
		if(menuContainerid == 'leftmenu' && !key && hrefs[i].href.indexOf("index.asp?action=notice")!=-1){
			key = hrefs[i].parentNode.parentNode.id.substr(5);
			hrefs[i].className = 'menucurr';
		}
		//左侧点击切换显示
		hrefs[i].onclick = function(){					
			var lis = $(menuContainerid).getElementsByTagName('li');
			for(var k = 0; k < lis.length; k++){
				lis[k].firstChild.className = '';
			}
			if(this.className == '') this.className = menuContainerid == 'leftmenu' ? 'menucurr' : 'bold';
		}
	}
	return key;
}