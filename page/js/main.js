// Tab Menu
$(function(){	
	$('.tab_cont > div').hide();
	$('.tab_cont > div:first-child').show();
	
	$('.tab_menu li a').click(function(e){
		e.preventDefault();
		var tab_id = $(this).attr('href');
		$('.tab_menu li').removeClass('on');
		$(this).parent().addClass('on');
		$('.tab_cont > div:visible').hide();
		$(tab_id).show();
	});
});

// Accordion Menu