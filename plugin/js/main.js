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
$(function(){
	$('.acc_cont > li:eq(0) h3').addClass('on').next().slideDown();
	
	$('.acc_cont li h3').click(function(i){
		var drop_down = $(this).closest('li').find('p');
		
		$(this).closest('.acc_cont').find('p').not(drop_down).slideUp();
		
		if ($(this).hasClass('on')) {
			$(this).removeClass('on');
		} else {
			$(this).closest('.acc_cont').find('h3.on').removeClass('on');
			$(this).addClass('on');
		}
		
		drop_down.stop(false, true).slideToggle();
		
		i.preventDefault();
	});
});