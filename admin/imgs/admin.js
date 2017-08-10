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
	//���˵��л��ٿ�
	for(var k in topMenus){
		if($('menu_' + topMenus[k])){
			$('menu_' + topMenus[k]).style.display = topMenus[k] == key ? '' : 'none';
		}
	}
	//�ϲ��˵���ǰ��ʽ�ٿ�
	var lis = $('topmenu').getElementsByTagName('li');
	for(var i = 0; i < lis.length; i++){
		if(lis[i].className == 'navon') lis[i].className = '';
	}
	$('header_' + key).parentNode.parentNode.className = 'navon';
	//���˵�ǰ������ʾ�ٿ�
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
		//��ʼ��Ĭ�ϵ�ǰ������
		if(menuContainerid == 'leftmenu' && !key && hrefs[i].href.indexOf("index.asp?action=notice")!=-1){
			key = hrefs[i].parentNode.parentNode.id.substr(5);
			hrefs[i].className = 'menucurr';
		}
		//������л���ʾ
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