//## 투숙일 선택
$(document).ready(function(){
	$("#room_order_date").datepicker();

	var date_box = $(".calendar-default .inner #room_order_date .ui-datepicker-calendar tbody td a.ui-state-default");

	date_box.prepend("<div class='day_state_text day_state_text01'>115,000</div>");
	date_box.prepend("<div class='day_state_btn day_state_btn01'>확정</div>");
	//date_box.prepend("<div class='day_state_btn day_state_btn02'>예약</div>");
	//date_box.prepend("<div class='day_state_btn day_state_btn03'>대기</div>");
	//date_box.prepend("<div class='day_state_btn day_state_btn04'>마감</div>");

});

/*
$(document).ready(function(){
	// 오늘날짜
	var date = new Date(); 
	var year = date.getFullYear();
 	var month = date.getMonth() + 1;
	var nowday= date.getDate();  
	
	if(month < 10){month = "0" + month;}
	if(nowday < 10){nowday = "0" + nowday;}

	var todayDate = year + "." + month + "." + nowday

	$('.room_order_day .today').text(todayDate);

	// 일주일 뒤
	var weekDate = date.getTime() + (6 * 24 * 60 * 60 * 1000);
	date.setTime(weekDate);
	var weekDay = date.getDate();

	if(weekDay < 10){weekDay = "0" + weekDay;}

	var oneWeek = month + "." + weekDay;

	$('.room_order_day .oneweek').text(oneWeek);

	// 오늘~일주일 나열
	var currentDay = new Date();  
	var theYear = currentDay.getFullYear();
	var theMonth = currentDay.getMonth();
	var theDate  = currentDay.getDate();
	var theDayOfWeek = currentDay.getDay();
	 
	var thisWeek = ""
	 
	for(var i=1; i<8; i++) {
		var resultDay = new Date(theYear, theMonth, theDate + (i - theDayOfWeek));
		var yyyy = resultDay.getFullYear();
		var mm = Number(resultDay.getMonth()) + 1;
		var dd = resultDay.getDate();
		var qq = resultDay.getDay();

		if(qq == 0) qq = "일"; 
		else if(qq == 1) qq = "월"; 
		else if(qq == 2) qq = "화"; 
		else if(qq == 3) qq = "수"; 
		else if(qq == 4) qq = "목"; 
		else if(qq == 5) qq = "금"; 
		else if(qq == 6) qq = "토"; 

		mm = String(mm).length === 1 ? '0' + mm : mm;
		dd = String(dd).length === 1 ? '0' + dd : dd;

		thisWeek = mm + '/' + dd + '(' + qq + ')';

		$('.room_order_date li:nth-child('+i+') .day_date').text(thisWeek);
	}
});
*/

//## Google Map
function initialize() {
	var Y_point			= 34.8435243;		// Y 좌표
	var X_point			= 128.7016137;		// X 좌표
	var zoomLevel		= 16;					// 지도의 확대 레벨 : 숫자가 클수록 확대정도가 큼
	var markerTitle		= "소노캄거제";		// 현재 위치 마커에 마우스를 오버을때 나타나는 정보
	var markerMaxWidth	= 300;			// 마커를 클릭했을때 나타나는 말풍선의 최대 크기
	var myLatlng = new google.maps.LatLng(Y_point, X_point);
	var mapOptions = {
		zoom: zoomLevel,
		center: myLatlng,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	}
	var map = new google.maps.Map(document.getElementById('map_view'), mapOptions);

	var marker = new google.maps.Marker({
		position: myLatlng,
		map: map,
		title: markerTitle
	});
}	