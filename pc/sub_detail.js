// bxslider - 숙소에 대한 간단정보와 함께 상단에 위치
$(document).ready(function(){
	var bigSlider = $(".product_img").bxSlider({
		pager: false,
		controls: false,
		infiniteLoop:true
	});

	var pagerSlider = $(".product_pager").bxSlider({
		minSlides: 1,
		maxSlides: 5,
		slideWidth: 100,
		moveSlides: 5,
		pager: false,
		infiniteLoop:true,
		nextText: "",
		prevText: ""
	});

	linkSliders(bigSlider,pagerSlider);

	if($(".product_pager a").length<4){
		$(".product_pager .bx-next").hide();
	}	

	function linkSliders(bigImage,pagerImage){
		$(".product_pager").on("click","a",function(event){
			event.preventDefault();
			var newIndex=$(this).attr("data-slide-index");
			bigImage.goToSlide(newIndex);
		});
	}
});

// 예약날짜 선택
$(document).ready(function(){
	$("#room_date").datepicker({ });

	var date_box = $("#room_date .ui-datepicker-calendar tbody td");

	date_box.prepend("<div class='date_default state_text01'>58,900</div>");
	date_box.prepend("<div class='state_icon state_btn01'>확정</div>");
	//date_box.prepend("<div class='state_icon state_btn02'>예약</div>");
	//date_box.prepend("<div class='state_icon state_btn03'>대기</div>");

	date_box.mouseover(function(){
		$(this).find('div.state_icon').css('display','block');
	});
	date_box.mouseleave(function(){
		$(this).find('div.state_icon').css('display','none');
	});
});

// bxslider - Tab Menu 안에 위치한 포토갤러리
$(document).ready(function(){
	var tabInSlider = $(".tab_product_img ul").bxSlider({
		pager: false,
		infiniteLoop:true,
		nextText: "<img src='images/big_arrow_right.png' alt='next button'>",
		prevText: "<img src='images/big_arrow_left.png' alt='prev button'>",
		onSlideBefore:function($slideElement, oldIndex, newIndex){
		changeRealThumb(tabInPager,newIndex);
		}
	}); 

	var tabInPager = $(".tab_product_pager div").bxSlider({
		pager: false,
		controls: false,
		infiniteLoop:true,
		minSlides: 1,
		maxSlides: 5,
		slideWidth: 125,
		moveSlides: 1,
		onSlideBefore:function($slideElement, oldIndex, newIndex){

		}
	});

	$(".tabbox ul li a").click(function(){
		// Tab Menu 변경시 bxslider가 'height:0' 방지
		tabInPager.reloadSlider();
		tabInSlider.reloadSlider();
	});

	tabInLinkSlider(tabInSlider,tabInPager);

	function tabInLinkSlider(tabInBig,tabInThumb){
		$(".tab_product_pager").on("click","a",function(event){
		event.preventDefault();
		var newIndex=$(this).attr("data-slideIndex");
			tabInBig.goToSlide(newIndex);
		});
	}

	function changeRealThumb(slider,newIndex){
		var tabInThumb=$(".tab_product_pager");

		if(slider.getSlideCount()-newIndex>=1)slider.goToSlide(newIndex);
		else slider.goToSlide(slider.getSlideCount()-1);
	}

});

// accordion
$(document).ready(function(){
	$('.room_info li').click(function(){
		var dropDown = $(this).closest('li').find('div');

		$('.room_info').find('li').each(function (i, v){
			$(this).find('span').removeClass('checked')
		});

		if ($(this).find('span').hasClass('checked')){
		} else {
			$(this).find('span').addClass('checked');
		}

		$(this).closest('.room_info').find('div').not(dropDown).slideUp();

		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			$(this).closest('.room_info').find('li.active').removeClass('active');
			$(this).addClass('active');
		}

		dropDown.stop(false, true).slideToggle();

		event.preventDefault();
	});
});

// Google Map
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