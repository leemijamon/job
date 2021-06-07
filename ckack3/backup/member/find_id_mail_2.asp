<!--#include virtual="/_include/config.asp"-->
<!--#include virtual="/_include/authChkSSO.asp"-->
<!--#include virtual="/_include/header.asp"-->
<link rel="stylesheet" type="text/css" href="/css/common.css" /><!-- 레이아웃&공통 -->
<script type="text/javascript" src="/jscript/design.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--

$(document).ready(function(){

	$("input:text[numberOnly]").on("keyup", function() {
		$(this).val( $(this).val().replace(/[^0-9]/gi,"") );
	});

	$("#emailSel li").click(function(){
		$("#emailDomain").val($(this).data("value"));
	});

	setQuick();
	resetSelectEvent(); // 신규셀렉트 생성시 한번리셋
});


function mailChk() {
	var f = document.Frm;

	if (checkEmpty(f.name)) {
		alert("이름을 입력해 주세요.");
		f.name.focus();
		return;
	}

	if (checkEmpty(f.emailID)) {
		alert("아이디(이메일)을 입력해 주세요.");
		f.emailID.focus();
		return;
	}

	var email = f.emailID.value;
	if (!checkEmpty(f.emailDomain)) {
		email = f.emailID.value +"@"+ f.emailDomain.value;
	}

	if (!checkEmail(email)) {
		alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
		f.emailID.focus();
		return;
	}
	f.email.value = email;
		
	f.submit();
}

function cancel() {
	history.back();
}
//-->
</SCRIPT>


<form name="Frm" method="post" action="find_id_mailOk_2.asp">
	<section class="login-wrap">
		<article class="login-cont form-wrap">
			 <div class="login-copy">
				 <h3>아이디 찾기</h3>
				 <p>가입 시 입력하신 이메일 주소를 통해 아이디를 찾을 수 있습니다.</p>
			 </div>
			 <div class="input-check">
				<a href="./find_id_mail_2.asp" class="label-link on">이메일로 찾기</a>
				<a href="./find_id_sms_2.asp" class="label-link">휴대전화로 찾기</a>
			 </div>
			 <fieldset>
				 <legend>아이디 찾기-이메일로 찾기</legend>
				 <div class="form-group search-inner">
					 <div class="form-cont">
						 <dl class="form-row">
							 <dt class="form-head"><label for="name">이름</label></dt>
							 <dd class="form-cell"><input type="text" name="name" id="name" class="form-input w100" title="홍길동"></dd>
						 </dl>
						 <dl class="form-row">
							 <dt class="form-head"><label for="emailID">이메일</label></dt>
							 <dd class="form-cell">
								 <div class="inline-wrap e-mail">
									 <input type="text" name="emailID"  class="form-input" style="width:210px;">
									 <input type="hidden" id="emailDomain" name="emailDomain" />
									 <input type="hidden" id="email" name="email" />
									 <span class="t-inline"></span>
									 <div class="select_option">
									     <div class="active_cont"><span class="txt">직접입력</span></div>
									     <ul class="option_list" id="emailSel"><%=makeListSel(CM_VOCAB_EMAIL, "", Null, Null, Null, "", Null)%></ul>
									 </div>
									 <!--<div class="right-btn"><button type="button" class="btn-input" onclick=";">인증번호</button></div>-->
								 </div>
							 </dd>
						 </dl>
						 <!--
						 <dl class="form-row">
							 <dt class="form-head"><label for="cert_num">인증번호</label></dt>
							 <dd class="form-cell"><input type="text" name="cert_num" id="cert_num" class="form-input w100" placeholder="인증번호 6자리 숫자 입력" disabled></dd>
						 </dl>
						 -->
					 </div>
					 <div class="form-btn"><a href="javascript:mailChk();" class="btn-middle bg-point">확인</a></div>
					 <div class="show-bottom" id="cert_ok01" style="display:none;"><p>회원님의 아이디는 <span id="show-id">okitakyou</span> 입니다.</p></div>
				 </div>
			 </fieldset>
		</article>
	</section>
</form>

 <script>
	/*
	$(function(){
		$(".form-btn a").click(function(){
			$(".search-inner").removeClass("open");
			$(".login-wrap .show-bottom").slideToggle("show");
			$(".search-inner").removeClass("open");
		});
	});
	*/
 </script>





<!-- copyright -->
<!--푸터 링크없애기 위해서 /_include/copyright.asp 삭제-->
<!-- copyright -->

