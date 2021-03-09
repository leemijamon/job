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

// datepicker
$(function(){
	var dateDay = $('.ui-datepicker-calendar tr td');

	dateDay.append('<div class=room_pay>가격</div>');
});