$(function(){
	var lastId,
		topMenu = $("#spy_menu"),
		topMenuHeight = topMenu.outerHeight()+15,
		
		menuItems = topMenu.find("a"),
		scrollItems = menuItems.map(function(){
			var item = $($(this).attr("href"));
			if (item.length) {
				return item;
			}
		});
		
		menuItems.click(function(e){
			var href = $(this).attr("href"),
				offsetTop = href === "#" ? 0 : $(href).offset().top-topMenuHeight+1;
			$(".onepage_wrap").stop().animate({
				scrollTop: offsetTop
			}, 300);
			
			e.preventDefault();
		});
		

});