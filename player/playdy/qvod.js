function getxfdx(objName)
{
        try
		{
			if (document.getElementById)
			{
					return eval('document.getElementById("'+objName+'")');
			}
			else
			{
					return eval('document.all.'+objName);
			}
		}
		catch(e)
		{}
}

function startdrag()
{
	window.document.ondragstart = function(e){
		return false;
	}
}

var XfplayIEFF;
var isIE = true;
var Install = false;

function OnloadFun()
{
		var checkIEorFirefox = {}
		 if(window.ActiveXObject || window.ActiveXObject !== undefined){
			checkIEorFirefox.ie = "yes";
			XfplayIEFF = document.getElementById("QvodPlayer");
		 }else{
			 isIE = false;
			checkIEorFirefox.firefox = "yes";
			XfplayIEFF = document.getElementById("QvodPlayer2");

                         var $E = function(){var c=$E.caller; while(c.caller)c=c.caller; return c.arguments[0]};
			__defineGetter__("event", $E);
		 }

		if(!isIE)
		{
			if (navigator.plugins){
				for (i=0; i < navigator.plugins.length; i++ ) 
				{
					var n = navigator.plugins[i].name;
					if( navigator.plugins[n][0]['type'] == 'application/Qvod-plugin')
					{
						Install = true; break;
					}		
				} 
			}
			if(!Install)
			{
				XfplayIEFF.style.display='none';
				document.getElementById('xframe_mz').style.display='';
				document.getElementById('xframe_mz').src='http://error2.qvod.com/error4.htm';
			}
		}else{
			if(getxfdx('QvodPlayer2') != null)
				getxfdx('QvodPlayer2').style.display='none';
			if(XfplayIEFF != null && XfplayIEFF.style.display == 'none' && getxfdx('xframe_mz').style.display !='none')
			{}else{
				Install = true;
			}
		}

	   if(Install)
	   {
		startdrag();
	   }

}


//==========================================================
OnloadFun();