var isMobile = (function checkMobile() {
	var pda_user_agent_list = new Array("2.0 MMP", "240320", "AvantGo", "BlackBerry", "Blazer",
		"Cellphone", "Danger", "DoCoMo", "Elaine/3.0", "EudoraWeb", "hiptop", "IEMobile", "KYOCERA/WX310K", "LG/U990",
		"MIDP-2.0", "MMEF20", "MOT-V", "NetFront", "Newt", "Nintendo Wii", "Nitro", "Nokia",
		"Opera Mini", "Opera Mobi",
		"Palm", "Playstation Portable", "portalmmm", "Proxinet", "ProxiNet",
		"SHARP-TQ-GX10", "Small", "SonyEricsson", "Symbian OS", "SymbianOS", "TS21i-10", "UP.Browser", "UP.Link",
		"Windows CE", "WinWAP", "Androi", "iPhone", "iPod", "iPad", "Windows Phone", "HTC");
	var pda_app_name_list = new Array("Microsoft Pocket Internet Explorer");

	var user_agent = navigator.userAgent.toString();
	for (var i = 0; i < pda_user_agent_list.length; i++) {
		if (user_agent.indexOf(pda_user_agent_list[i]) >= 0) {
			return true;
		}
	}
	var appName = navigator.appName.toString();
	for (var i = 0; i < pda_app_name_list.length; i++) {
		if (user_agent.indexOf(pda_app_name_list[i]) >= 0) {
			return true;
		}
	}

	return false;
})();

function tudouplayer(flashpath, videocode, returncode){
    var ios_url = "http://www.tudou.com/programs/view/html5embed.action?code=" + videocode;
    if(isMobile){
        var htmlcode = '<iframe width="100%" height="100%" frameborder="0" src="' + ios_url + '"></iframe>';
    }else{
        var htmlcode = '<object id="dm4399" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="820" height="460">\n\
                        <param name="movie" value="' + flashpath + '" />\n\
                        <param name="quality" value="high" />\n\
                        <param name="wmode" value="transparent" />\n\
                        <param name="allowfullscreen" value="true" />\n\
                        <param name="flashvars" value="isAutoPlay=true&autoPlay=true&withRecommendList=false" />\n\
                        <embed flashvars="isAutoPlay=true&autoPlay=true&withRecommendList=false" id="dm4399_em" name="dm4399" wmode="transparent" allowfullscreen="true" wmode="transparent" src="' + flashpath + '" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="820" height="460"></embed>\n\
                        </object>'
    }
    if(returncode){
        return htmlcode;
    }else{
        document.write(htmlcode);
    }
}