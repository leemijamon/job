// bxslider
var bigSlider = $(".product_img").bxSlider({
		pager: false,
		controls: false,
		infiniteLoop:true
	});

var pagerSlider = $(".product_pager").bxSlider({
	minSlides: 5,
	maxSlides: 20,
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

$(function(){
	$("#datepicker").datepicker({
		beforeShowDay: selectDaysRest
	});
});

// accordion
$(function(){
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