
/* ���������� ��ʼ by-QQ 8314806 */

var xWidth = 700;   // ���������
var xHeight = 520;  // �������߶�
var xShowList = 0;  // 1Ϊ��ʾ�����б�,0Ϊ����ʾ�����б�
var xADtime = 8;    // 
var xADurl = "/js/loading.html";    //

/* ���������� ���� */
function getHtmlParas(str){
         var ss = window.location.href;
         var sid = ss.split("-");
         var n = sid.length;
         var vid = sid[n-1].split(".")[0];
         var pid = sid[n-2];
         var sArr = new Array(pid,vid);
         return sArr;
}

function viewplay(pid,vid){
         document.write('<'+'iframe'+' src="'+sitePath+'/player/player.html" id="xplayer" width="'+xWidth+'" height="'+xHeight+'" scrolling="no" frameborder="0"'+'>'+'<'+'/iframe'+'>');
}