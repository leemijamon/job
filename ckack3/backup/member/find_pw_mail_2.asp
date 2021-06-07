<!--#include virtual="/_include/config.asp"-->
<!--#include virtual="/_include/authChkSSO.asp"-->
<!--#include virtual="/_include/header.asp"-->
<link rel="stylesheet" type="text/css" href="/css/common.css" /><!-- 레이아웃&공통 -->
<script type="text/javascript" src="/jscript/design.js"></script>
<script type="text/javascript" src="/jscript/SHA512.js"></script>


<SCRIPT LANGUAGE="JavaScript">


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

function submitChk() {
	var f = document.Frm;
	var emailID = f.emailID.value;
	var emailDomain = f.emailDomain.value;

	if(emailDomain != "") var email = emailID+"@"+emailDomain;
	else var email = emailID;

	if (checkEmpty(f.id)) {
		alert("아이디를 입력해 주세요.");
		f.id.focus();
		return;
	}

	if (checkEmpty(f.emailID)) {
		alert("이메일을 입력해 주세요.");
		f.emailID.focus();
		return;
	}


	if (checkEmpty(f.name)) {
		alert("이름을 입력해 주세요.");
		f.name.focus();
		return;
	}

	if (!checkEmail(email)) {
		alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
		f.emailID.focus();
		return;
	}

	rn = randNum().toUpperCase();
	f.defRn.value = rn;
	f.encRn.value = SHA512(rn);
	f.email.value=email;
	f.submit();
}

function cancel() {
	history.back();
}
function reset_domain(){
	$("#emailDomain").val('');
}
//-->
</SCRIPT>

<form name="Frm" method="post" action="find_pw_mailOK.asp">
<input type="hidden" id="eVer" name="eVer" value="2">
<input type="hidden" id="email" name="email">
<input type="hidden" id="emailDomain" name="emailDomain">
<input type="hidden" name="defRn">
<input type="hidden" name="encRn">
<section class="login-wrap">
	<article class="login-cont form-wrap">
		 <div class="login-copy">
			 <h3>패스워드 찾기</h3>
			 <p>가입 시 입력하신 이메일 주소를 통해 비밀번호를 찾을 수 있습니다.</p>
		 </div>
		 <div class="input-check">
			<a href="./find_pw_mail_2.asp" class="label-link on">이메일로 찾기</a>
			<a href="./find_pw_sms_2.asp" class="label-link">휴대전화로 찾기</a>
		 </div>
		 <fieldset>
			 <legend>패스워드 찾기 - 이메일로 찾기</legend>
			 <div class="form-group search-inner">
				 <div class="form-cont">
					 <dl class="form-row">
						 <dt class="form-head"><label for="name">이름</label></dt>
						 <dd class="form-cell"><input type="text" name="name" id="name" class="form-input w100" onkeydown="if(event.keyCode == 13){submitChk();}"></dd>
					 </dl>
					 <dl class="form-row">
						 <dt class="form-head"><label for="id">아이디</label></dt>
						 <dd class="form-cell"><input type="text" name="id" id="id" class="form-input w100"></dd>
					 </dl>
					 <dl class="form-row">
							 <dt class="form-head"><label for="emailID">이메일</label></dt>
							 <dd class="form-cell">
								 <div class="inline-wrap e-mail">
									 <input type="text" name="emailID"  class="form-input" style="width:210px;">

									 <span class="t-inline"></span>
									 <div class="select_option">
									     <div class="active_cont"><span class="txt">직접입력</span></div>
									     <ul class="option_list" id="emailSel"><%=makeListSel(CM_VOCAB_EMAIL, "", Null, Null, Null, "", Null)%></ul>
									 </div>
									 <!--<div class="right-btn"><button type="button" class="btn-input" onclick=";">인증번호</button></div>-->
								 </div>
							 </dd>
						 </dl>
					 <!--<dl class="form-row">
						 <dt class="form-head"><label for="emailID">이메일</label></dt>
						 <dd class="form-cell">
							 <div class="inline-wrap e-mail">
								<input type="text" id="emailID" name="emailID" class="form-input" />
								<span class="t-inline">@</span>
								<!-- 셀렉트 --
								<div class="select_option" style="width:120px;">
									<!-- 체크된 내용 --
									<div class="active_cont">
										<span class="txt">직접입력</span>
									</div>
									<!-- 체크된 내용 끝 --
									<!-- 셀렉트 리스트 --
									<ul class="option_list" id="emailSel">
										<li data-value=""><span class="txt" onclick="reset_domain();">직접입력</span></li>
										<%=makeListSel(CM_VOCAB_EMAIL, "", Null, Null, Null, "", Null)%>
									</ul>
									<!-- 셀렉트 리스트 끝 --
								</div>
								<!-- 셀렉트 끝 --
								<div class="right-btn"><button type="button" class="btn-input" onclick=";">인증번호</button></div>
						 </dd>
					 </dl>
					 <dl class="form-row">
						 <dt class="form-head"><label for="smsconfirm">인증번호</label></dt>
						 <dd class="form-cell"><input type="text" name="smsconfirm" id="smsconfirm" onkeyup="cntCheck();" maxlength="6" class="form-input w100" placeholder="인증번호 6자리 숫자 입력" disabled></dd>
					 </dl>-->
				 </div>
				 <div class="form-btn"><a href="javascript:submitChk();" class="btn-middle bg-point">확인</a></div>
				 <!--<div class="show-bottom" id="cert_ok01"><p>회원님의 아이디는 <span id="show-id">okitakyou</span> 입니다.</p></div>-->
			 </div>
		 </fieldset>
	</article>
</section>
</form>


<!-- copyright -->
<!--푸터 링크없애기 위해서 /_include/copyright.asp 삭제-->
<!-- copyright -->
