
//특정한 경우에는 내창 닫고 새윈도우만 열기
function fn_WinClose(url){
	if(url != ''){
		var iframe = document.createElement('iframe');
        iframe.style.display = 'none';
        iframe.src = '/member/logout';
        document.body.appendChild(iframe);
// 		$.post('/member/logout');
		parent.window.open("about:blank","_self").close();
		window.open(url, '_blank');
	}
}
//]]>


function openCommonPopup(pppExpPstnCd, spdpNo, dispCatNo) {
	var param = '';
	// *param*
	// pppExpPstnCd(10:메인, 20:카테고리, 30:주문서, 40:기획전, 50:로그인전)
	// spdpNo 기획전 번호(pppExpPstnCd : 40 일 때만)
	// dispCatNo 카테고리 번호(pppExpPstnCd : 20 일 때만)
	if (!!pppExpPstnCd) {param += 'pppExpPstnCd=' + pppExpPstnCd;}
	if (!!spdpNo) {
		if (param != '') { param += '&'; }
		param += 'spdpNo=' + spdpNo;
	}
	if (!!dispCatNo) {
		if (param != '') { param += '&'; }
		param += 'dispCatNo=' + dispCatNo;
	}
	if (pppExpPstnCd == '50') {
		var cmpyNo = etbs.param.getParam('cmpyNo');		
		if (!cmpyNo) { return; }
		if (param != '') { param += '&'; }
		param += 'cmpyNo=' + cmpyNo;
	}
	
	$.post('/popup/getPopupList', param, function(data){
		var pppList;
		if(data.resultMap != null)
		 pppList = data.resultMap.pppList;
		if (!!pppList) {
			var mbrNo = '우정훈';
			$.ajaxSetup({async: false});
			for (var i=0 ; i<pppList.length ; i++) {
				var pppInfo = pppList[i];
				
				//다시보지않기 팝업은 SKIP continue;
				var rvsPop = getCookie('rvsPop' + pppInfo.pppNo );
				if(rvsPop) continue;
				
				if (pppInfo.pppTpCd == '10') {// 팝업
					if (!!pppInfo.mbrConfUrl) {
						// 회원확인 URL
						if (mbrNo) {
							$.ajax({
								type : "POST",
								url : pppInfo.mbrConfUrl,
								dataType : "json",
								data : {'mbrNo' : mbrNo},
								error : function() {return;},
								success : function(data) {
									if (data.success) {
										etbs.wpopup({
											target : pppInfo.pppNo,
											name : pppInfo.pppNo,
											url : '/popup/popup/popWindowPopup',
											width : (!!pppInfo.pppWdtLnth ? pppInfo.pppWdtLnth : 300),
											height: (!!pppInfo.pppHgtLnth ? pppInfo.pppHgtLnth : 300) + (pppInfo.nvsExpYn == 'Y' ? 10 : 0),
											top: pppInfo.pppHgtCdnt,
											left: pppInfo.pppWdtCdnt,
											param : {pppNo : pppInfo.pppNo, pppExpPstnCd : pppExpPstnCd, cmpyNo : '100'}
										});
									}
								}
							});
						}
					}
					else {
						etbs.wpopup({
							target : pppInfo.pppNo,
							name : pppInfo.pppNo,
							url : '/popup/popup/popWindowPopup',
							width : (!!pppInfo.pppWdtLnth ? pppInfo.pppWdtLnth : 300),
							height: (!!pppInfo.pppHgtLnth ? pppInfo.pppHgtLnth : 300) + (pppInfo.nvsExpYn == 'Y' ? 10 : 0),
							top: pppInfo.pppHgtCdnt,
							left: pppInfo.pppWdtCdnt,
							param : {pppNo : pppInfo.pppNo, pppExpPstnCd : pppExpPstnCd, cmpyNo : '100'}
						});
					}
				}
				else if (pppInfo.pppTpCd == '20') {// 레이어
					if (!!pppInfo.mbrConfUrl) {
						// 회원확인 URL
						if (mbrNo) {
							$.ajax({
								type : "POST",
								url : pppInfo.mbrConfUrl,
								dataType : "json",
								data : {'mbrNo' : mbrNo},
								error : function() {return;},
								success : function(data) {
									if (data.success) {
										if (getCookiesForPopupLayer(pppInfo.pppNo) == false) {
											setCookiesForPopupLayer(pppInfo.pppNo, 'S', 4);
											$.post('/popup/popup/popLayerPopup', 'pppNo=' + pppInfo.pppNo + '&pppExpPstnCd=' + pppExpPstnCd + '&cmpyNo=' + '100', function(data) {
												$('body').append(data);
												var idx = data.indexOf('callPopupLayer');
												window[data.substr(idx, 20)]();
											});
										}
									}
								}
							});
						}
					}
					else {
						if (getCookiesForPopupLayer(pppInfo.pppNo) == false) {
							setCookiesForPopupLayer(pppInfo.pppNo, 'S', 4);
							$.post('/popup/popup/popLayerPopup', 'pppNo=' + pppInfo.pppNo + '&pppExpPstnCd=' + pppExpPstnCd + '&popupCnt=' + i + '&cmpyNo=' + '100', function(data) {
								$('body').append(data);
								var idx = data.indexOf('callPopupLayer');
								window[data.substr(idx, 20)]();
							});
						}
					}
				}
			}
			$.ajaxSetup({async: true});
		}
	});
}

function getCookie(name) {
	var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
	return value? value[2] : null;
}


//쿠키에 임시로 담아서 팝업 비교 용도 (이유 : iframe 이슈. mainChild와 main에서 띄우는 팝업이 개별이라 생길수 있는 중복 팝업 예방)
function setCookiesForPopupLayer(popName, dateType, expDays) {
	var todayDate = new Date();
	if (dateType == 'D') {
		todayDate.setDate(todayDate.getDate() + expDays);
	} else if (dateType == 'H') {
		todayDate.setHours(todayDate.getHours() + expDays);
	} else if (dateType == 'M') {
		todayDate.setMinutes(todayDate.getMinutes() + expDays);
	} else if (dateType == 'S') {
		todayDate.setSeconds(todayDate.getSeconds() + expDays);
	} else { // 없으면 디폴트 날짜
		todayDate.setDate(todayDate.getDate() + expDays);
	}
	document.cookie = popName+"="+escape("done")+"; path=/; expires="+todayDate.toGMTString()+";";
}

//쿠키에 임시로 담아서 팝업 비교 용도 (이유 : iframe 이슈. mainChild와 main에서 띄우는 팝업이 개별이라 생길수 있는 중복 팝업 예방)
function getCookiesForPopupLayer(popName) {
	var pop = false;
	var sPoint, ePoint;
	for (var s = 0; s <= document.cookie.length; s++) {
		sPoint = s;
		ePoint = sPoint+popName.length;
		if (document.cookie.substring(sPoint, ePoint) == popName) {
			pop = true;
			break;
		}
	}
	
	if (true == pop) {
		sPoint = ePoint+1;
		ePoint = document.cookie.indexOf(';', sPoint);
		if (ePoint < sPoint) {
			ePoint = document.cookie.length;
		}
		return document.cookie.substring(sPoint, ePoint);
	}
	return false;
}


// 상단 스크롤시 고정 
$(document).ready(function() {


	// 가정친화 서브메인 메인 슬라이드 배너
	$(".mid_slider li").hover(function(){
		
		$(this).find("span").show();
		$(this).find("p").show();
		},function(){
			$(this).find("p").hide();
			$(this).find("span").hide();
		});

	

});




$(document).ready(function() {
	
	$(".mid_slider ul li").hover(function(){
		
		$(this).find("span").show();
		$(this).find("p").show();
		},function(){
			$(this).find("p").hide();
			$(this).find("span").hide();
	});	
	$(".bx-controls-direction a, .menu_text button").each(function(){
		$(this).text("");
		
	});
	
	
	$(".good-list li .title").each(function(){
		
		var totalByte = 0;
		
		var wordSize = $(this).find("p").text();
		for(var i=0 ; i < wordSize.length; i++){
			
			var currentByte = wordSize.charCodeAt(i);

			if(currentByte > 128){
				totalByte +=32;
			}else if(currentByte >=65 && currentByte <= 90){
				totalByte+=22;
			}else if(currentByte >=48 && currentByte <= 57){
				totalByte+=20; //기준 (29-2 base 2=40,'...'=33) 2줄이상일경우  + 40
			}else {
				totalByte+=11;
			};
			
			if(totalByte > 1120){
				
				$(this).find("p").text(wordSize.slice(0,i)+"...");
				return
			};
		
		};	
		
		
	});
	$(".prdmore").click(function(){
			var test= $(window).scrollTop();
			
			$(".sec04 .good-list").find("li:last-child").after("<li>1</li><li>2</li><li>3</li>");
			
			$(window).scrollTop(test);
	});
	

});


	