
	
	
	
		 

   $(document).ready(function () {	   
	   var url = window.location.href;
	   
	   if (!url.includes("searchKind=Rec")) {
		   
		   if ( $("#myBtn1").length) {
	       }else{
	    	   if('100'=='N05'){
	    		   $('body').append('<a href="#toptoptop123" id="myBtn1" class="bybtn_all_fc">Top</a>');
	    	   }else{
	    		   $('body').append('<a href="#toptoptop123" id="myBtn1" class="bybtn_all_top">Top</a>');   
	    	   }
		       
		       
		       $("#myBtn1").hide();
	       	   if ( $(".dire_buy").length) {
	   	    	   var px = $(".dire_buy");
	   	    	   var offsetp = px.offset();
	   	    	   $("#myBtn1").offset({top: offsetp.top -45});
	
	   	       }else{
	   	    	   var height = window.innerHeight ? window.innerHeight : $(window).height();
	   	    	   $("#myBtn1").offset({top: height -55});
	   	       }
	       }		   
		   
		   $('body, .goods_detail').on('touchmove', function(e) {
			   $("#myBtn1").show();
			  // var height = window.innerHeight ? window.innerHeight : $(window).height();	       
			  // $("#myBtn1").offset({top: height -50}).show();
	           //var p = $( "#myBtn1" );
	    	   //var offset = p.offset();
	    	   //console.log( $(this).scrollTop() +" left: " + offset.left + ", top: " + offset.top );
	    	   
		   });
		  
		   
		   $('#myBtn1').on('click touch', function(e) { 
			   
			   //$('body , .goods_detail').scrollTop(0);
			    //if('lcandkr'=="sharifs"){
				 // alert("왜 안되. body.	ㄷ  ");   
				   //$('html, body').animate({scrollTop: 0}, 2500); 
			   //}
			   // $('body').scrollTop(0);
			    if ( $(".dire_buy").length) {
			    	$('.goods_detail').scrollTop(0);
			    }
			    
			    $("#myBtn1").hide();
	 	   });
		 
		   if('100'=='J01'){
			   loadImg();
			   //setTimeout( loadImg, 1000);
		   }
	   } 
   });
   
   function loadImg() {
		
	    $.each($('img'), function() {
	       if ( $(this).attr('data-src') ) {
	       	var source = $(this).data('src');
	           $(this).attr('src', source);
	           $(this).removeAttr('data-src');
	       }
	    })
	 	 
   }
   
   /**
    * URI 인코딩 함수
    */
   function toEncodeURI(url) {
   	location.href = encodeURI(url);
   }

  
   




$(document).ready(function() {	
	$(document).on("click", '.foot_link a', function(e){
		e.preventDefault();
		var url = '/clause/popApplyClauseInfo?cmpyNo=100&clusDocNo='+$(this).prop("id")+'&agrPstnCd=60';
		$("#layerPopClause .popS1HeaderTit").text('');
		$("#layerPopClause").find('iframe').remove();
		var $frame = $("<iframe>").attr({ "src": url});
		$("#layerPopClause .iframe").append($frame);	
		$("#layerPopClause").show();
	});
});

/**
 * checkBox 저장
 * @return void
 */
$(document).ready(function(){
	
	$('#searchBtnbox').click(function(){
		//혜택 선택 
		$("#noCstDlvYn").val($("input:checkbox[name='etbs_noCstDlvYn']").is(":checked")?"Y":"");
		$("#saleProdYn").val($("input:checkbox[name='etbs_saleProdYn']").is(":checked")?"Y":"");
		$("#hitProdYn").val($("input:checkbox[name='etbs_hitProdYn']").is(":checked")?"Y":"");
		$("#bestProdYn").val($("input:checkbox[name='etbs_bestProdYn']").is(":checked")?"Y":"");
		$("#wpntUseYn").val($("input:checkbox[name='etbs_wpntUseYn']").is(":checked")?"Y":"");	
		
		var makeDiv ="";
		
	 	if($("input[id^=etbs_]:checked").length > 0 ){
	 		makeDiv +="<div class='sele_cond_bene'><h4 class='floa_left marg_righ20 marg_bott10'>혜택:</h4>";
		 	$("[id^=etbs_]").each(function(){
				if( $(this).prop("checked") ){
					makeDiv +="<span class='add_con' data-bene='"+$(this).val()+"'>"+$(this).siblings().text()+"</span>";
				}
			}); 
		 	makeDiv +="</div>";
	 	}
	 	
	 	if($(":radio[name=priceType]:checked").length > 0 ){
			var check =$(":radio[name=priceType]:checked").val();	
			makeDiv +="<div class='sele_cond_pric'><h4 class='floa_left marg_righ20 marg_bott10'>가격대 :</h4>";
			if(check == "searchText"){
				makeDiv +="<span class='add_con' data-radi_pric='self'>";
				makeDiv += $("#lowPrice").val()+ "~ "+ $("#highPrice").val() ;
				makeDiv += "</span> ";
			}else{
				makeDiv +="<span class='add_con' data-radi_pric='"+check+"'>"+$(":radio[name=priceType]:checked").siblings().text()+"</span> ";
			}
			makeDiv +="</div>";
		}
	 	
		$("#selectedGroupSpan").html("");
		$("#selectedGroup").append(makeDiv);
		
		$('input[id^=etbs_]').prop('checked',false);
		
		closePop('.pop_cate_deta_srch');	
	});
	
	box_srch_cond();
	box_srch_cond2();	
});




var CURRENT_PRODUCTLIST_DIV = "";

$(document).ready(function(){
	
	// 상품 더보기 버튼 클릭 
	$('#dispCatProdDetailBtn').click(function(){
		
		var curPage = $("#currentPage").val();
		var totalCount = $("#totalCount").val();
		var pageCount = $("#pageCount").val();

		if(totalCount <= curPage * pageCount){
	 		return;
	 	}
		$("#currentPage").val(++curPage);
		
		goSearch('add');
		
	});
	
	//전체삭제 
	$("#all_dele").on("click", "a", function(e){			
		$('.sele_regi_area .con_area *').remove();
		var makeDiv ="<div class=\"mt10\"><span class=\"txt2_4 c5 sele_regi_blan_msg\" id=\"selectedGroupSpan\">원하는 검색조건을 선택해 주세요.</span>";		 	
		$("#selectedGroup").append(makeDiv);
		
		$("#highPrice").val(0);
		$("#lowPriice").val(0);
	});
	
	$.fn.digits = function(){ 
	    return this.each(function(){ 
	        $(this).text( $(this).text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") ); 
	    });
	}
	
	//조회버튼 
	$('#searchBtn').click(function(){		
		goSearch('new');		
	});
});
	
	//상세검색 레이어 호출 
function popSearchProduct(){		
	$("#selectedGroupSpan").remove();
	$('.sele_regi_area .con_area *').remove();
		
	openPop('.pop_cate_deta_srch');
}
	
	//검색정렬 소팅 
function sortSel(sortType){
	$("#sort").val(sortType);	
	$("#currentPage").val(1);
		
		//검색엔진 조회 
	goSearch('new');
}
	
	/**
	 * 찜목록 추가 팝업 열기
	 * @return void
	 */
function openWishlistPopup(prodNo){
	$('#prodNo').val(prodNo);
		
	var now = new Date();
	var oneYearLater = new Date();
	oneYearLater.setFullYear(oneYearLater.getFullYear() + 1);
	$('#wishPeriod').text(now.format('( yyyy - MM - dd ~ ') + oneYearLater.format('yyyy - MM - dd )')); // ( 2017 – 01 – 23 ~ 2018 – 01 – 22 )
	openPop('#pop_scrab');
}
	
	//더보기 버튼 제어 
function detailBtnStyle(){
			
	if($("#currentPage").val() == ''){
		$("#currentPage").val(1);
	}
	var curPage = $("#currentPage").val();
	var totalCount = $("#totalCount").val();
	var pageCount = $("#pageCount").val();
	
	if(totalCount <= curPage * pageCount){
		$("#dispCatProdDetailBtn").hide();	// 더보기 버튼 숨기기
	}else{
		$("#dispCatProdDetailBtn").show();
	}	
}
	
function clickCategory(catNm) {
	var rootCatNm = $('#cate_layer .popS1HeaderTit').text();
	callAnalytics(rootCatNm, '메뉴', catNm);
		//console.log('rootCatNm is '+rootCatNm);
}
$(document).ready(function(){
	
	$(".prd_sec02 .sub_cate li").click(function(){
		$(this).siblings().removeClass("on");
		$(this).addClass("on");
		var list_num = $(this).index()+1;
		$(".prd_sec02 .mdRecomUl").siblings().removeClass("on");
		$(".prd_sec02 .mdRecomUl.list0"+list_num+"").addClass("on");
	});
	$(".prd_sec03 .sub_cate li").click(function(){
		$(this).siblings().removeClass("on");
		$(this).addClass("on");
		var list_num = $(this).index()+1;
		$(".prd_sec03 .mdRecomUl").siblings().removeClass("on");
		$(".prd_sec03 .mdRecomUl.list0"+list_num+"").addClass("on");
	});
	$(".cate_list li").click(function(){
		$(this).siblings().removeClass("on");
		$(this).addClass("on");
	});
	
	
	
	
	
	
});

