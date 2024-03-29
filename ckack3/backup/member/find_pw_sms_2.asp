﻿<!--#include virtual="/_include/config.asp"-->
<!--#include virtual="/_include/authChkSSO.asp"-->
<!--#include virtual="/_include/header.asp"-->
<link rel="stylesheet" type="text/css" href="/css/common.css" /><!-- 레이아웃&공통 -->
<script type="text/javascript" src="/jscript/design.js"></script>
<script type="text/javascript" src="/jscript/2.0/member.js"></script>

<script type="text/javascript">
defineAjax();
</script>

<!--#include virtual="/_include/topmenu.asp"-->
<!--#include virtual="/_include/left_none.asp"-->

<style type="text/css">
	.container {display:table}
	.member_wrap {display:table-cell; margin: auto; vertical-align:middle; }
</style>

<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){

	$("input:text[numberOnly]").on("keyup", function() {
		$(this).val( $(this).val().replace(/[^0-9]/gi,"") );
	});

	$("#emailSel li").click(function(){
		$("#emailDomain").val($(this).data("value"));
	});

	$("#mobileSel li").click(function(){
		$("#mobile1").val($(this).data("value"));
	});

	setQuick();
	resetSelectEvent(); // 신규셀렉트 생성시 한번리셋
});

function cancel() {
	history.back();
}

function passChk() {

	var f = document.Frm;

	if (checkEmpty(f.name)) {
		alert("이름을 입력해 주세요.");
		f.name.focus();
		return;
	}

	if (checkEmpty(f.id)) {
		alert("아이디를 입력해 주세요.");
		f.id.focus();
		return;
	}
	
	for (i=1; i<=3; i++) {
		objItem = eval("f.mobile"+i);
		if (checkEmpty(objItem)) {
			alert("휴대전화를 입력해 주세요.");
			objItem.focus();
			return;
		}
	}

	if (checkEmpty(f.smsconfirm)) {
		alert("인증번호를 입력해 주세요.");
		f.smsconfirm.focus();
		return;
	}
	
	if ($('#certification').val() != '1'){
		alert('인증을 받아주세요.');
		return;
	}

	f.submit();
}

//function reset_domain(){
//	$("#emailDomain").val('');
//}
//-->
</SCRIPT>
<%'=Session("upass")%>

<form name="Frm" method="post" action="find_pw_modify_2.asp">
<input type="hidden" id="email" name="email" />
<input type="hidden" id="emailDomain" name="emailDomain" />
<input type="hidden" id="mobile1" name="mobile1">
<input type="hidden" id="certification" value="0"/>
	<section class="login-wrap">
		<article class="login-cont form-wrap">
			 <div class="login-copy">
				 <h3>패스워드 찾기</h3>
				 <p>가입 시 입력하신 휴대전화를 통해 비밀번호를 찾을 수 있습니다.</p>
			 </div>
			 <div class="input-check">
				<a href="./find_pw_mail_2.asp" class="label-link">이메일로 찾기</a>
				<a href="./find_pw_sms_2.asp" class="label-link on">휴대전화로 찾기</a>
			 </div>
			 <fieldset>
				 <legend>패스워드 찾기 - 휴대전화로 찾기</legend>
				 <div class="form-group search-inner">
					 <div class="form-cont">
						 <dl class="form-row">
							 <dt class="form-head"><label for="name">이름</label></dt>
							 <dd class="form-cell"><input type="text" name="name" id="name" class="form-input w100" title="홍길동"></dd>
						 </dl>
						 <dl class="form-row">
							 <dt class="form-head"><label for="id">아이디</label></dt>
							 <dd class="form-cell"><input type="text" name="id" id="id" class="form-input w100"></dd>
						 </dl>
						 <dl class="form-row">
							 <dt class="form-head"><label for="mobileSel">휴대전화</label></dt>
							 <dd class="form-cell">
								 <div class="inline-wrap phone">
									<!-- 셀렉트 -->
									<div class="select_option" style="width:73px;">
										<!-- 체크된 내용 -->
										<div class="active_cont">
											<span class="txt"></span>
										</div>
										<!-- 체크된 내용 끝 -->
										<!-- 셀렉트 리스트 -->
										<ul class="option_list" id="mobileSel">
											<%=makeListSel(CM_VOCAB_MOBILE, "", Null, Null, Null, "", Null)%>
										</ul>
										<!-- 셀렉트 리스트 끝 -->
									</div>
									<!-- 셀렉트 끝 -->
									<span style="display:inline-block;width:20px;color:#545454;font-size:12px;text-align:center;vertical-align:middle;">-</span>
									<input type="text" name="mobile2" style="width:73px;" numberOnly="true" maxlength="4" class="form-input"/>
									<span style="display:inline-block;width:20px;color:#545454;font-size:12px;text-align:center;vertical-align:middle;">-</span>
									<input type="text" name="mobile3" style="width:73px;" numberOnly="true" maxlength="4" class="form-input"/>
									<span class="post_btn" onClick="smsSend()">인증번호</span>
									<label class="displayCount notif" style="font-size:16px; margin-left:25px; display:none;">
										<span class="countTimeMinute">0</span>분
										<span class="countTimeSecond">0</span>초
									</label>
								 </div>
							 </dd>
						 </dl>
						 <dl class="form-row">
							 <dt class="form-head"><label for="smsconfirm">인증번호</label></dt>
							 <dd class="form-cell"><input type="text" name="smsconfirm" id="smsconfirm" class="form-input w100" placeholder="인증번호 6자리 숫자 입력"  onkeyup="cntCheck();"></dd>
						 </dl>
					 </div>
					 <div class="form-btn"><a href="javascript:passChk();" class="btn-middle bg-point">확인</a></div>
					 <div class="show-bottom" id="cert_ok01"><p>회원님의 아이디는 <span id="show-id">okitakyou</span> 입니다.</p></div>
				 </div>
			 </fieldset>
		</article>
	</section>
</form>




<script>
	var timer;
	/* 휴대폰 인증 카운트 인증번호 전송 클릭 */
	function certificationCount(type){
		$('.smsSubmit').hide();
		$('.displayCount').show();

		$('input[name="mobile1"]').attr("readonly","readonly");
		$('input[name="mobile2"]').attr("readonly","readonly");
		$('input[name="mobile3"]').attr("readonly","readonly");

		var minute = 3;
		var second = 0;

		$(".countTimeMinute").html(minute);
		$(".countTimeSecond").html(second);

		timer = setInterval(function () {
			$(".countTimeMinute").html(minute);
			$(".countTimeSecond").html(second);

			if(second == 0 && minute == 0){	// 시간 끝나면 세션 종료
				var sessionEnd = '<% Session("upass") = "" %>';	// 세션 끝
				clearInterval(timer); /* 타이머 종료 */

				$('.displayCount').hide();	// 시간 hide
				$('.smsSubmit').show();

				$('input[name="mobile1"]').attr("readonly",false);
				$('input[name="mobile2"]').attr("readonly",false);
				$('input[name="mobile3"]').attr("readonly",false);
			}else{
				second--;

				// 분처리
				if(second < 0){
					minute--;
					second = 59;
				}
			}
		}, 1000); /* millisecond 단위의 인터벌 */
	};

	function cntCheck(){
		if (Number($('#smsconfirm').val().length) == 6){
			smsSendCheck();
		}
	}

	/* 인증번호 확인버튼 */
	function smsSendCheck(){
		var sValue = '';

		$.ajax({
			type:'post',
			url:'/common/ajax/exec_getIDSessionConfirm.asp',
			success:function(data){
				sValue = data;

				var tValue = $('#smsconfirm').val();	// 텍스트 값

				if (tValue == "")
				{
					alert('인증번호를 입력해주세요.');
					return false;
				}else if (sValue == tValue)
				{
					clearInterval(timer);		// 타이머 종료
					$('.displayCount').html("인증완료");
					$('#certification').val(1); // 인증확인
					$('#smsconfirm').attr("readonly","readonly");
				}else{
					alert('잘못된 인증번호 입니다.');
					$('#smsconfirm').val('');
					return false;
				}
			}
		});
	}

</script>

<!-- copyright -->
<!--푸터 링크없애기 위해서 /_include/copyright.asp 삭제-->
<!-- copyright -->
