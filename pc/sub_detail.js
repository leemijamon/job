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

//