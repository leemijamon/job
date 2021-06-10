<!--#include virtual="/_include/config.asp"-->
<!--#include virtual="/_include/header.asp"-->
<script type="text/javascript" src="/jscript/design.js"></script>
<!--#include virtual="/_include/topmenu.asp"-->
<!--#include virtual="/_lib/function.UserNavi.asp"-->
<!--#include virtual="/_lib/function.CategoryConfig.asp"-->
<!-- #include virtual="/common/popnotice_include.asp" -->
<link rel="stylesheet" href="/css/jquery-ui-select.css" />

<%
	imgPath=pathBanner_Sublist
	cate = checkNumeric(getRequest("cate", Null))

	list_cate=cate  ''' 상품리스트용 카테고리

	branduid = checkNumeric(getRequest("branduid", Null))
	'1 depth cate 추출
	sql = "select CATECode, Name, Depth from dbo.fnGetCateParent(?, ?) where Depth = 1"
	arrParams = Array( _
		Db.makeParam("@SiteID", advarWchar, adParamInput, 20, siteID), _
		Db.makeParam("@CateCode", adInteger, adParamInput, 4, cate) _
	)
	Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)
	If Not(Rs.eof Or Rs.bof) Then
		pcate = checkNumeric(Rs("CATECode"))
	Else
		pcate = 0
	End If
	Call closeRs(Rs)


	If listsize = "" Then listsize = 10
	If pStart = "" Then pStart = 0

	' 카테고리 배너
	sql = "SELECT ImgCateBanner, ImgCateBannerUrl FROM T_CATEGORY WHERE SiteID='"& siteID &"' AND CateCode IN(?, ?) ORDER BY Depth DESC "
	arrParams = Array(_
		Db.makeParam("@CateCode", adInteger, adParamInput, 4, cate), _
		Db.makeParam("@CateCode", adInteger, adParamInput, 4, pcate) _
	)
	arrListP = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLenP, Nothing)
	If IsArray(arrListP) Then
		imgCateBanner = ""
		For i=0 To listLenP
			If Trim(arrListP(0, i)) <> "" And imgCateBanner = "" Then
				imgCateBanner = Trim(arrListP(0, i))
				imgCateBannerUrl = Trim(arrListP(1, i))
			End If
		Next
	End If

	''20180405 joonyus 카테고리 환경설정 기능 추가/////////////////////''
	''카테고리 환경설정 초기화
	IsHidden="F"
	IsDisplayMain="F"
	Left_IsHidden="F"
	List_sort="new"
	Search_type="A"

	Slide_Banner_PC_IsDisplay="F"
	Slide_Banner_MoBile_IsDisplay="F"
	Bar_Banner_PC_IsDisplay="F"
	Bar_Banner_Mobile_IsDisplay="F"
	MD_Recomm_IsDisplay="F"
	Best_IsDisplay="F"
	DB_Day_PC_IsDisplay="F"
	DB_Day_Mobile_IsDisplay="F"
	MD_Recomm_IsDisplay_M="F"
	ODay_PC_IsDisplay="F"
	ODay_Mobile_IsDisplay="F"
	Left_Menu_IsDisplay="F"
	isSearch="T"


	'' 노출순서 초기화
	for i=1 to ubound(Sort_gubun_PC)
		Sort_Val_PC(i)=Sort_gubun_PC(i)
	next

	sql = "SELECT Name, Cms, CmsGonggu, CmsAuction, Sort, (SELECT ISNULL(MAX(Sort), 0) FROM T_CATEGORY WHERE Parent=C.Parent) AS MaxSort,inicial, CD_CTGY"
	sql = sql &",IsDisplayMain,Left_IsHidden,List_sort,Search_type,IsHidden,IsConfig_Etc,Parent,depth, IsSearch"
	sql = sql &" FROM T_CATEGORY AS C"
	sql = sql &" WHERE SiteID='"& siteID &"' AND CateCode=?"
	arrParams = Array(_
		Db.makeParam("@CateCode", adInteger, adParamInput, 4, cate) _
	)
	Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)
	flagRs = False
	If Not Rs.bof And Not Rs.eof Then
		flagRs = True
		Ori_CateName = Trim(Rs("Name"))
		editCms = Trim(Rs("Cms"))
		editCmsGonggu = Trim(Rs("CmsGonggu"))
		editCmsAuction = Trim(Rs("CmsAuction"))
		editSort = CLng(Rs("Sort"))
		editMaxSort = CLng(Rs("MaxSort"))
		inicial=Trim(Rs("inicial"))
		cateNaviCode = cate
		CD_CTGY = trim(Rs("CD_CTGY"))
		IsDisplayMain=null2blank(Rs("IsDisplayMain"))
		Left_IsHidden=null2blank(Rs("Left_IsHidden"))
		listsort=null2blank(Rs("List_sort"))
		Search_type=null2blank(Rs("Search_type"))
		IsHidden=null2blank(Rs("IsHidden"))
		IsConfig_Etc=null2blank(Rs("IsConfig_Etc"))
		Parent=checkNumeric(Rs("Parent"))
		depth=checkNumeric(Rs("depth"))
		search_depth=checkNumeric(Rs("depth"))
		isSearch=null2blank(Rs("IsSearch"))
		search_depth=search_depth+1
		if IsConfig_Etc="" then IsConfig_Etc="F"
		if Left_IsHidden="" then Left_IsHidden="F"
		if IsHidden="" then IsHidden="F"
		if listsort="" then listsort="sort"
		'정렬 인기상품순으로 강제고정
		listsort = "favorite"
		
		if Search_type="" then Search_type="A"
		
		If isSearch="" Then isSearch="T"
		if cfgPartnerID="mall3" then
			isSearch = "F"
		end if
			
	End If
	Call closeRs(Rs)



	''// 카테고리 환경설정 상위카테고리에 따를경우 카테고리코드 변경
	if IsConfig_Etc="F" then
	for i=1 to cfgCateDepth

		sql = "SELECT CateCode,Name, Cms, CmsGonggu, CmsAuction, Sort, (SELECT ISNULL(MAX(Sort), 0) FROM T_CATEGORY WHERE Parent=C.Parent) AS MaxSort,inicial, CD_CTGY"
		sql = sql &",IsDisplayMain,Left_IsHidden,List_sort,Search_type,IsHidden,IsConfig_Etc,Parent,IsSearch"
		sql = sql &" FROM T_CATEGORY AS C"
		sql = sql &" WHERE SiteID='"& siteID &"' AND CateCode=? "
		arrParams = Array(_
			Db.makeParam("@CateCode", adInteger, adParamInput, 4, Parent) _
		)

		Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)
		flagRs = False
		If Not Rs.bof And Not Rs.eof Then
			flagRs = True
			cate=Rs("CateCode")
			editName = Trim(Rs("Name"))
			editCms = Trim(Rs("Cms"))
			editCmsGonggu = Trim(Rs("CmsGonggu"))
			editCmsAuction = Trim(Rs("CmsAuction"))
			editSort = CLng(Rs("Sort"))
			editMaxSort = CLng(Rs("MaxSort"))
			inicial=Trim(Rs("inicial"))
			CD_CTGY = trim(Rs("CD_CTGY"))
			IsDisplayMain=null2blank(Rs("IsDisplayMain"))
			Left_IsHidden=null2blank(Rs("Left_IsHidden"))
			listsort=null2blank(Rs("List_sort"))
			Search_type=null2blank(Rs("Search_type"))
			IsHidden=null2blank(Rs("IsHidden"))
			IsConfig_Etc=null2blank(Rs("IsConfig_Etc"))
			Parent=checkNumeric(Rs("Parent"))
			isSearch=null2blank(Rs("IsSearch"))
			if IsConfig_Etc="" then IsConfig_Etc="F"
			if Left_IsHidden="" then Left_IsHidden="F"
			if IsHidden="" then IsHidden="F"
			if listsort="" then listsort="favorite"
			if Search_type="" then Search_type="A"
			
			If isSearch="" Then isSearch="T"
			if cfgPartnerID="mall3" then
				isSearch = "F"
			end if
		End If

		Call closeRs(Rs)
		if IsConfig_Etc="T" then
			exit for
		end if
	next
end If

sort_cate=cate   ''// 환경설정 및 노출순서용 카테고리

If Not flagRs Then mode = ""

sql = "SELECT CateCode, Slide_Banner_PC_IsDisplay, Slide_Banner_MoBile_IsDisplay, Bar_Banner_PC_IsDisplay, Bar_Banner_Mobile_IsDisplay, MD_Recomm_IsDisplay, Best_IsDisplay, DB_Day_PC_IsDisplay, DB_Day_Mobile_IsDisplay,MD_SubTitle,Best_SubTitle"
sql = sql &",MD_Recomm_IsDisplay_M,Best_IsDisplay_M,ODay_PC_IsDisplay,ODay_Mobile_IsDisplay"
sql = sql &",Left_Menu_IsDisplay"
sql = sql &" FROM T_CATEGORY_CONFIG "
sql = sql &" WHERE SiteID='"& siteID &"' AND CateCode=?"
arrParams = Array(_
	Db.makeParam("@CateCode", adInteger, adParamInput, 4, sort_cate) _
)
Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)
If Not Rs.bof And Not Rs.eof Then
	Slide_Banner_PC_IsDisplay=null2blank(Rs("Slide_Banner_PC_IsDisplay"))
	Slide_Banner_MoBile_IsDisplay=null2blank(Rs("Slide_Banner_MoBile_IsDisplay"))
	Bar_Banner_PC_IsDisplay=null2blank(Rs("Bar_Banner_PC_IsDisplay"))
	Bar_Banner_Mobile_IsDisplay=null2blank(Rs("Bar_Banner_Mobile_IsDisplay"))
	MD_Recomm_IsDisplay=null2blank(Rs("MD_Recomm_IsDisplay"))
	Best_IsDisplay=null2blank(Rs("Best_IsDisplay"))
	DB_Day_PC_IsDisplay=null2blank(Rs("DB_Day_PC_IsDisplay"))
	DB_Day_Mobile_IsDisplay=null2blank(Rs("DB_Day_Mobile_IsDisplay"))
	MD_SubTitle=null2blank(Rs("MD_SubTitle"))
	Best_SubTitle=null2blank(Rs("Best_SubTitle"))
	MD_Recomm_IsDisplay_M=null2blank(Rs("MD_Recomm_IsDisplay_M"))
	Best_IsDisplay_M=null2blank(Rs("Best_IsDisplay_M"))
	ODay_PC_IsDisplay=null2blank(Rs("ODay_PC_IsDisplay"))
	ODay_Mobile_IsDisplay=null2blank(Rs("ODay_Mobile_IsDisplay"))
	Left_Menu_IsDisplay=null2blank(Rs("Left_Menu_IsDisplay"))
	if MD_Recomm_IsDisplay_M="" then MD_Recomm_IsDisplay_M="F"
	if Best_IsDisplay_M="" then Best_IsDisplay_M="F"
	if ODay_Mobile_IsDisplay="" then ODay_Mobile_IsDisplay="F"
	if ODay_PC_IsDisplay="" then ODay_PC_IsDisplay="F"
	if Left_Menu_IsDisplay="" then Left_Menu_IsDisplay="F"
end if
Call closeRs(Rs)

''노출순서가져오기
sql = "select gubun from T_CATEGORY_CONFIG_SORT where siteID=? and catecode=? and IsMobile='F' order by sort asc"
arrParams = Array(_
	Db.makeParam("@SiteID", advarWchar, adParamInput, 20, siteID), _
	Db.makeParam("@CateCode", adInteger, adParamInput, 4, sort_cate) _
)
arrList = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLen, Nothing)
If isArray(arrList) Then
	For i = 0 To listLen
		Sort_Val_PC(i+1)=arrList(0,i)
	next
end if

'If branduid>0 Then
'	Search_type="B"
'End if

'카테고리 추가

	Const PAGE_CODE = "home"

	uid = checkNumeric(getRequest("uid", Null))

	pageSet_sort = checkNumeric(getRequest("pageSet_sort", Null))
	if pageSet_sort="" or pageSet_sort=0 then
		pageSet_sort = 1
	end if
	listSort = getRequest("listSort", Null)
	page = checkNumeric(getRequest("page", Null))
	'if page=0 then
	'	page=1
	'end if
	
	listSize = checkNumeric(getRequest("listSize", Null))
	if listSize=0 then
		listSize=10
	end if
	
	pstart = checkNumeric(getRequest("pstart", Null))
	
	'response.write "UID = " & uid & "<br>"
	'response.write "pageSet_sort = " & pageSet_sort & "<br>"
	'response.write "page = " & page & "<br>"
	'response.write "listSort = " & listSort & "<br>"
	'response.write "listSize = " & listSize

	' 카테고리 정보
	'sql = "SELECT Uid, Name, sort FROM T_EVENT_CATEGORY WHERE EventUid=? ORDER BY Sort ASC"
	

	SQL = "SELECT DEPTH FROM T_CATEGORY WHERE CATECODE='" & CATE & "'"
	PRESENT_DEPTH = CLng(Db.execRsData(sql, DB_CMDTYPE_TEXT, Null, Nothing))
	
	IF PRESENT_DEPTH>=2 THEN
		SQL = "SELECT PARENT FROM T_CATEGORY WHERE CATECODE=" & CATE
		PRE_MOTHER_CATE = CLng(Db.execRsData(sql, DB_CMDTYPE_TEXT, Null, Nothing))
	END IF
	MOTHER_CATE = CATE
	
	IF PRESENT_DEPTH=5 THEN
		SQL = "SELECT catecode, name, sort FROM T_CATEGORY "
		SQL = SQL & " WHERE CATECODE NOT IN (SELECT CATECODE FROM T_PARTNER_CATEGORY WHERE PARTNERID='" & cfgPartnerID & "')"
		SQL = SQL & " 	AND DEPTH=1 "
		'SQL = SQL & "   AND CATECODE>=25908"
		SQL = SQL & " ORDER BY SORT"
	ELSEIF PRESENT_DEPTH=1 OR PRESENT_DEPTH=2 THEN
		SQL = "SELECT CATECODE, NAME, SORT FROM FNGETCATECHILD('FAMILYMALL'," & MOTHER_CATE & ", " & PRESENT_DEPTH+1 & ") AS FG"
		SQL = SQL & " WHERE CATECODE!=" & MOTHER_CATE & " AND ISHIDDEN='F' "
		SQL = SQL & " AND (SELECT count(GoodsUid) FROM T_GOODS_CATEGORY AS GC(NOLOCK) JOIN fnGetCateChild('familymall', FG.CATECODE, 0) AS F ON GC.CateCode=F.CateCode)!=0 "
		SQL = SQL & " ORDER BY SORT"
	ELSEIF PRESENT_DEPTH=3 THEN
		SQL = "SELECT CATECODE, NAME, SORT FROM FNGETCATECHILD('FAMILYMALL'," & PRE_MOTHER_CATE & ", " & PRESENT_DEPTH & ") WHERE ISHIDDEN='F' ORDER BY SORT"
	END IF
	
	'response.write sql & "<br>"
	arrParams = Array( _
		Db.makeParam("@EventUid", adInteger, adParamInput, 4, uid) _
	)

	arrListC = Db.execRsList(sql, DB_CMDTYPE_TEXT, NULL, listLenC, Nothing)

	strCate = "" : strCateLen = 0

	If IsArray(arrListC) Then
		For i=0 To listLenC
			cateUid = arrListC(0, i)
			cateName = arrListC(1, i)
			cateSort = arrListC(2, i)

			if i=0 then strCate = "<tr>"

			if i>0 And (i mod 5)=0 then strCate = strCate &"</tr><tr>"

			'strCate = strCate & "<td><a href='#"& cateUid &"'><div class='txt'>"& cateName &"</div><i class='material-icons'>keyboard_arrow_right</i></a></td>"
			strCate = strCate & "<td><a href='lowestPrice.asp?uid=" & uid & "&pageSet_sort=" & cateSort & "'><div class='txt'>"& cateName &"</div><i class='material-icons'>keyboard_arrow_right</i></a></td>"

			if i=listLenC then strCate = strCate &"</tr>"

			strCateLen = strCateLen + Len(cateName)
			If strCateLen > 50 Then strCate = strCate &"<br>" : strCateLen = 0
		Next
	End If
%>

<!-- 상단 좌측메뉴 시작 -->
<%
if Left_Menu_IsDisplay="F" then%>
<!--#include virtual="/_include/left_none.asp"-->
<%else%>
<!--#include virtual="/_include/sublist_left_2.asp"-->
<%end If%>
<!-- 상단 좌측메뉴 끝 -->

<!--#include virtual="/_lib/function.Goods.asp"-->
<script type="text/javascript" src="/jscript/swiper.min.js"></script>
<link rel="stylesheet" type="text/css" href="/css/swiper.min.css" />

<style>
<% 
	'if SiteID = "familymall" and (cfgPartnerID=siteID or cfgPartnerID="DBMall") then
	'전체적용
%>

<% if SiteID = "familymall"  then%>
.smartSearch{margin-top:0;}
.sublistConWrap>div:not(.smartSearch):nth-of-type(2){/* padding:0 0 0 172px !important;margin-top:-7px !important;padding-top:0 !important;*/}
.sublistConWrap>div:nth-of-type(3){clear:both;}
.pdBtnBoxWrap li .pdBtnBox .btn{width:45px;height:45px;}
.pdBtnBoxWrap li .pdBtnBox .btn span, .pdBtnBoxWrap li .pdBtnBox .btn i{line-height:45px;}
.pdBtnBoxWrap li:hover .pdBtnBox{margin-top:-55px;}
/* .PageWrapSize{display:none !important;float:none !important;} */
.bodyWrap{position:relative;}
.LeftWrapSize{position:absolute;left:0;top:0;z-index:11;margin-top:61px !important; overflow:hidden; border-right:1px solid #ccc;}
.location+sublistConWrap{margin-top:0;}
.gallery_list ul li .txt .price_wrap .star_wrap {display:none;}

/* leftSlide */
.leftSlide{float:left;width:551px;height:306px;position:relative;}
.leftSlide .slCon{height:306px;box-sizing:border-box;}
.leftSlide .swiper-container{width:100%;}
.leftSlide .swiper-container .swiper-slide .slCon .image img{width:100%;height:100%;}
.leftSlide .swiper-container .swiper-slide .slCon .brand{font-size:15px;color:#555;letter-spacing:-.3px;font-weight:bold;padding:6px 0 11px}
.leftSlide .swiper-container .swiper-slide .slCon .tit{width:78%;margin:auto;overflow:hidden;text-overflow:ellipsis;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;word-wrap:break-word;line-height:16px;height:38px;}
.leftSlide .swiper-container .swiper-slide .slCon .tit span{font-size:15px;color:#555;letter-spacing:-.3px;}
.leftSlide .swiper-container .swiper-slide .slCon .price{padding-top:8px;}
.leftSlide .swiper-container .swiper-slide .slCon .price .orip .mkprc{font-size:15px;color:#9f9f9f;letter-spacing:-.2px;text-decoration:line-through;padding-right:5px;font-weight:bold;}
.leftSlide .swiper-container .swiper-slide .slCon .price .salep span{font-size:19px;color:#f34979;letter-spacing:-.2px;font-weight:bold;}
.leftSlide .swiper-container .swiper-slide .slCon .price .salep .mwon{font-size:16px;font-weight:normal;}
.leftSlide .swiper-button-prev,
.leftSlide .swiper-button-next{position:absolute;top:50%;margin-top:-30px;width:60px;height:60px;background:rgba(0,0,0,.4) url(/images/sl_lft2.png)no-repeat center/30%;text-indent:-9999px;}
.leftSlide .swiper-button-prev{left:0;}
.leftSlide .swiper-button-next{right:0;background-image:url(/images/sl_rgt2.png);}
.leftSlide .swiper-pagination{display:none;}
.leftSlide .swiper-pagination span {float:left;display:inline-block;color:#666;width:24px;height:24px;background:none;font-size:14px;line-height:24px;text-align:center;font-weight:700;border-radius:50%;opacity:1;}
.leftSlide .swiper-pagination-bullet-active {color:#fff !important;background:#2f3030 !important;}
.swiper-button-next.swiper-button-disabled,
.swiper-button-prev.swiper-button-disabled{display:none;}

/* rightSlide */
.rightSlide {position:absolute;left:551px;right:0;top:0;bottom:0;}
.rightSlide li{padding:134px 10px;margin-top:-10px;box-sizing:border-box;}
.rightSlide .swiper-container{height:500px;position:absolute;left:0;right:0;top:50%;margin-top:-250px;}
.rightSlide .swiper-slide .imageLayer{overflow:hidden;position:relative;}
.rightSlide .swiper-slide .imageLayer .pdImg{width:119.333px;margin-top:10px;}
.rightSlide .swiper-slide .imageLayer .pdImg2{width:120px; margin:20px auto 10px;}
.rightSlide .txtWrap{font-size:14px; padding:0 10px 10px;}
.rightSlide .paginationWrap{position:relative;text-align:center;padding-top:5px;margin-top:-36px;z-index:1;}
.rightSlide .swiper-pagination{position:static;}
.rightSlide .swiper-pagination-bullet{width:18px;height:18px;background:#999;border-radius:0;margin:0 2.5px;opacity:1;color:#fff;}
.rightSlide .swiper-pagination-bullet-active{background:<%=cfgColor1%>;}
.view_type_box{margin-top:30px;}
.MD_Recomm .pdBtnBoxWrap.wrap .liWrap:hover .pdBtnBox,
.Best .pdBtnBoxWrap.wrap .liWrap:hover .pdBtnBox{margin-top:-62px;}
/*.Slide_Banner_PC_S{padding-top:30px;}*/
.Best .swiper-container .swiper-slide,
.MD_Recomm .swiper-container .swiper-slide{width:354px;/*padding:0 10px;*/box-sizing:border-box;margin-right:19px;}
.slStyle1 .cont ul li{width:100%;}
.slStyle1 .cont ul li .liWrap{width:100%;overflow:hidden;}
.slStyle1 .pdBtnBoxWrap li .pdImg{width:100%;height:211.6px !important;}
.slStyle1 .pdBtnBoxWrap li .pdImg img{max-width:100%;}

/* 슬라이드 style */
.slStyle1{position:relative;}
.slStyle1 .swiper-wrapper{padding:0;}
.slStyle1 .pagination.swiper-pagination-bullets{width:auto;height:3px;text-align:center;z-index:10;padding:15px 0;}
.slStyle1 .swiper-pagination{position:absolute;top:-30px;right:0;}
.slStyle1 .swiper-pagination-bullet{display:inline-block;width:15px;height:15px;background:#c2c2c2;border-radius:50%;box-sizing:border-box;opacity:1;cursor:pointer;text-align:center;font-size:11px;margin:0 5px;vertical-align:top;}
.slStyle1 .swiper-pagination-bullet-active{background:#37bce8;}
<%end if%>
.gallery_list ul{width:100%;margin:0;}
.gallery_list ul li .txt .price_wrap .dis em{font-size:34px;}
/*.gallery_list ul li .txt{padding:5px 5px 10px;}*/
<%if Search_type="B" then%>
.smartSearch{border:none;margin-top:0;}
.smartSearch .location .cate_option{font-size:12px;height:24px;}
<%end if%>
.cateBox_wrap{padding-top:30px;}
.cateBox_wrap ul{overflow:hidden;width:100%;border-left:1px solid #b9b6b6;border-bottom:1px solid #b9b6b6;}
.cateBox_wrap ul li{float:left;font-size:12px;line-height:65px;border:solid #b9b6b6;border-width:1px 1px 0 0;width:19.88%;text-align:center;border-right:1px solid #b9b6b6;}
.cateBox_wrap ul li.on{background:#f1eded;}
.sub_banner{padding-bottom:30px;}
.sub_banner div {display:inline-block; border:1px solid #ddd; box-sizing:border-box;}
.sub_banner div.lft_bn{width:60%;height:320px;}
.sub_banner div.rgt_bn{width:39%;height:320px;}
.mid_banner {overflow:hidden; /*padding-top:30px;*/ padding:20px 0 25px}
.mid_banner .img{/*border:1px solid #ddd;*/ border:0px; width:auto;}
.mid_banner .img img{width:100%;}
.ssSection .btnSearch{display:inline-block;width:55px;height:30px;line-height:30px;text-align:center;vertical-align:top;background:#666;color:#fff;/* position:absolute;bottom:25px;left:100px; */cursor:pointer;}

/*슬라이드*/
.boxTwo { margin:0 auto; overflow:hidden;}
.boxTwo .box_inner{width:100%;margin:0 auto;overflow:hidden;border:1px solid #ddd;/* border-left:0; */box-sizing:border-box;position:relative; height:306px; overflow:hidden;}
.categ_link{display:inline-block;width:100%;margin-bottom:20px;border:1px solid #e5e5e5;box-sizing:border-box;}
.categ_link ul{}
.categ_link ul li{float:left;width:183px;height:42px;box-sizing:border-box;}
.categ_link ul li a{display:block;position:relative;line-height:40px;font-size:12px;color:#333;font-family: "돋움",Dotum,"돋움체",DotumChe;}
.categ_link ul li a:after{content:"";position:absolute;top:10px;right:0;width:1px;height:15px;background:#e5e5e5;}
.categ_link ul li a.active{color:#14afe5;font-weight:700;}
.categ_link ul li:nth-child(6) a:after{display:none;}
.categ_link ul li:last-child(8) a:after{display:none;}
.subli_tit{text-align:left;margin-bottom:20px;}
.subli_tit h1{font-size:18px;color:#010101;font-weight:500;}
.subli_tit h1 span{font-size:12px;color:#545454;margin-left:10px;font-family: "돋움",Dotum,"돋움체",DotumChe;}

.listStyle1 {overflow:hidden;}
.listStyle1 .cont ul{overflow:hidden;font-size:0;/*margin:-10px;*/}
.listStyle1 .cont ul li{display:inline-block;/*padding:10px;*/}
.listStyle1 .cont ul li .liWrap{position:relative;border:1px solid #e4e4e4;height:543px;box-sizing:border-box;}
.listStyle1 .cont ul li .liWrap:hover{border:1px solid #21b5e6;}
.listStyle1 .cont ul li img{width:100%;}
.listStyle1.r2 .cont ul li{width:50%;}
.listStyle1.r3 .cont ul li{width:33.333%;}
.listStyle1.r4 .cont ul li{width:25%;}

.mall_bgImg{height:355px;background-repeat:no-repeat;background-position:center;background-size:cover;}
.icoWrap{position:absolute;left:20px;bottom:20px;font-size:18px;}
.icoWrap img{width:auto;max-height:14px;padding-right:5px;}

.view_type_box .ui-selectmenu-button.ui-button{height:25px;width:100%;padding:0 10px;margin-top:0;box-sizing:border-box;border:1px solid #e1e2e4;outline:none;}
.view_type_box .ui-selectmenu-text{line-height:25px;color:#2d2d37;font-family: "돋움",Dotum,"돋움체",DotumChe;}
.view_type_box .ui-selectmenu-icon.ui-icon{background:url('/images/sub/pay_check.png') 20px 10px no-repeat;}

/* jquery ui select */
.ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus, .ui-button:hover, .ui-button:focus {border:1px solid #22B5E6;}
.ui-widget.ui-widget-content {border:1px solid #a8a8aa;}
.ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active, a.ui-button:active, .ui-button.ui-state-active:hover {background:none;border:1px solid #fff;}
.ui-menu .ui-menu-item-wrapper{font-size:12px;color:#a8a8aa;font-family: "돋움",Dotum,"돋움체",DotumChe;}
.ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active, a.ui-button:active, .ui-button.ui-state-active:hover .ui-menu .ui-menu-item-wrapper{color:#21b5e6;/*font-weight:700;*/}
</style>

<%
	If cfgImgColumnNum = "3" Then
		strImgColumnNum = "column3"
	ElseIf cfgImgColumnNum = "4" Then
		strImgColumnNum = "column4"
	ElseIf cfgImgColumnNum = "5" Then
		strImgColumnNum = "column5"
	Else
		strImgColumnNum = "column4"
	End If

	' 20170607 kyh, criteo 상품상세 스크립트 이메일 추출
	sqlCriteo = " SELECT Email FROM T_MEMBER WHERE SiteID = '"&siteID&"' AND UserID = '"&authUserID&"' "
	criteoEmail = Trim(Db.execRsData(sqlCriteo, DB_CMDTYPE_TEXT, Null, Nothing))
%>

<% If imgCateBanner <> "" Then %>
<!-- <div class="sublist_banner"> -->
<!-- 	<a href="<%=imgCateBannerUrl%>"><img src="<%=imgURL & pathLeftmenu &"/"& imgCateBanner%>" alt="서브메인 배너 이미지"></a> -->
<!-- </div> -->
<% End If %>

<%
	'2018-04-13 khs : 브랜드 타이틀 이미지 노출
	sql = "SELECT Name, MainImgBrand, Brand_Desc FROM T_BRAND WHERE SiteID='"& siteID &"' AND Uid=? AND IsConfirm='T'"
	arrParams = Array( _
		Db.makeParam("@Uid", adInteger, adParamInput, 4, branduid) _
	)
	Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)
	flagRs = False
	If Not Rs.bof And Not Rs.eof Then
		flagRs = True
		brandName = Trim(Rs("Name"))
		MainImgBrand = Trim(Rs("MainImgBrand"))
		Brand_Desc = Trim(Rs("Brand_Desc"))
		If MainimgBrand <> "" Then
			print "<div align=""left""><img src="""& imgURL & pathBrand &"/"& MainimgBrand &"""></div>"
		End If
		If (Brand_Desc<>"") Then
			print "<div align=""left"">"& text2Tag(Brand_Desc) &"</div>"
		End If

	End If
	Call closeRs(Rs)	
%>

<form method="post" name="Frm" id="Frm">
	<input type="hidden" id="pop" name="pop">
	<input type="hidden" id="pcate" name="pcate" value="<%=pcate%>">
	<input type="hidden" id="cate" name="cate" value="<%=list_cate%>">
	<input type="hidden" id="listsort" name="listsort" value="<%=listsort%>">
	<input type="hidden" id="listsize" name="listsize" value="<%=listsize%>">
	<input type="hidden" id="pStart" name="pStart" value="<%=pStart%>">
	<input type="hidden" id="branduid" name="branduid" value="<%=branduid%>">
	<input type="hidden" id="branduids" name="branduids" value="<%=branduid%>">
	<input type="hidden" id="searchcateuid" name="searchcateuid" >
	<input type="hidden" id="IsDelivery" name="IsDelivery" >
	<input type="hidden" id="IsCmoney" name="IsCmoney" >
</form>

<script>
//카테고리 클릭
$(document).ready(function(){
	$(".cateBox_wrap ul li").click(function(){
		$(this).toggleClass("on");
	})
});


$(window).load(function(){
	var swiper_newpd = new Swiper('.leftSlide .swiper-container', {
        pagination: '.leftSlide .swiper-pagination',
        paginationClickable: true,
        autoplay:3500,
        nextButton: '.leftSlide .swiper-button-next',
        prevButton: '.leftSlide .swiper-button-prev',
		autoplayDisableOnInteraction:false,
        //loop:true,
		autoHeight:true,
        paginationBulletRender: function (swiper, index, className) {
            return '<span class="' + className + '">' + (index + 1) + '</span>';
        }
    });
	var swiper_rightSlide = new Swiper('.rightSlide_slide .swiper-container', {
        pagination: '.rightSlide_slide .swiper-pagination',
        paginationClickable: true,
        autoplay: 2500,
        nextButton: '.rightSlide_slide .swiper-button-next',
        prevButton: '.rightSlide_slide .swiper-button-prev',
		autoplayDisableOnInteraction:false,
        //loop:true,
        paginationBulletRender: function (swiper, index, className) {
            return '<span class="' + className + '">' + (index + 1) + '</span>';
        }
    });
	var MD_RecommSl = new Swiper(".MD_Recomm  .swiper-container",{
		pagination:'.MD_Recomm .swiper-pagination',
		nextButton:'.MD_Recomm .swiper-button-next',
		prevButton:'.MD_Recomm .swiper-button-prev',
		paginationClickable:true,
		spaceBetween:19,
		//centeredSlides:true,
		slidesPerView:3,
		slidesPerGroup:3,
		//autoplay:4000,
		//loop:true,
		autoplayDisableOnInteraction:false
	});
	var BestSl = new Swiper(".Best .swiper-container",{
		pagination:'.Best .swiper-pagination',
		nextButton:'.Best .swiper-button-next',
		prevButton:'.Best .swiper-button-prev',
		paginationClickable:true,
		//spaceBetween:30,
		slidesPerView:"auto",
		slidesPerGroup:4,
		//centeredSlides:true,
		autoplay:3000,
		//loop:true,
		autoplayDisableOnInteraction:false
	});
})

</script>


<!-- 스마트검색 시작 -->

<!-- 현재위치 -->
<div class="location_categ">
	<span>
		<% 			
			Call makeUserNaviCate_NEW_2(CM_GDTYPE_NOR, list_cate, Null) 
		%>
	</span>
</div>
<!-- 현재위치 끝 -->

<!-- 상단메뉴 -->
<% If IsArray(arrListC) Then %>
<div class="categ_link">
	<ul>
		<!--<li><a href="lowestPrice.asp?uid=1951&pageSet_sort=2" class="active">신선/가공/건강식품</a></li>
		<li><a href="lowestPrice.asp?uid=1951&pageSet_sort=3">주방가전/생활가전</a></li>
		<li><a href="lowestPrice.asp?uid=1951&pageSet_sort=4">주방생활용품/가구</a></li>
		<li><a href="lowestPrice.asp?uid=1951&pageSet_sort=5">패션/잡화/뷰티</a></li>
		<li><a href="lowestPrice.asp?uid=1951&pageSet_sort=6">스포츠/아웃도어/캠핑</a></li>
		<li><a href="lowestPrice.asp?uid=1951&pageSet_sort=7">TV/PC/계절가전</a></li>
		<li><a href="lowestPrice.asp?uid=1951&pageSet_sort=8">레저/여행/건강</a></li>
		<li><a href="lowestPrice.asp?uid=1951&pageSet_sort=9">출산/유아동</a></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		-->
		
		<%
			If IsArray(arrListC) Then
				For i=0 To listLenC
		%>			
					<li><a href="sublist_2.asp?cate=<%=arrListC(0,i)%>&pageSet_sort=<%=arrListC(2,i)%>" <% if cate=arrListC(0,i) then %>class="active"<% end if %>><%=arrListC(1,i)%></a></li>
		<%
				Next
			end if
		%>

	</ul>
</div>
<% end if %>

<div class="sublistConWrap">

<div class="StartDiv_S">
</div>
<div class="StartDiv_E">
</div>



<!-- 슬라이드배너 시작  -->
<!--
<%if Slide_Banner_PC_IsDisplay="T" then%>
	<div class="boxTwo Slide_Banner_PC Slide_Banner_PC_S" style="display:block;">
		<div class="box_inner">
			<div class="leftSlide">
				<div class="swiper-container">
					<div class="swiper-wrapper">
					<%

	imgNo = 0
	arrListI=Null
	Link=""
	sql = "select Uid,CateCode, Img, Link, gubun, IsMobile From T_CATEGORY_CONFIG_IMAGE where siteID='"&siteID&"' And CateCode=? AND gubun=? AND IsMobile=?"
	arrParams = Array(_
		Db.makeParam("@CateCode", adInteger, adParamInput, 4, sort_cate), _
		Db.makeParam("@gubun", advarWchar, adParamInput, 50,"SPImgM"), _
		Db.makeParam("@IsMobile", advarWchar, adParamInput, 1, "F") _
	)
	arrListI = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLenI, Nothing)
	If IsArray(arrListI) Then
		For i=0 To listLenI
			imgUid = Trim(arrListI(0, i))
			imgFName = null2Blank(arrListI(2, i))
			Link = null2Blank(arrListI(3, i))
			a_link="javascript:;"
			if Link<>"" then
				a_link=Link
			end if
					%>
						<div class="swiper-slide">
							<div class="slCon cutImgBox">
								<div class="image"><a href="<%=a_link%>"><img src="/data/<%=SiteID%>/banner/<%=imgFName%>"></a></div>
							</div>
						</div>
<%
		next
	end if
%>
					</div>
				</div>
				<div class="swiper-pagination"></div>
				<div class="swiper-button-prev">이전</div>
				<div class="swiper-button-next">다음</div>


			</div>
			<div class="rightSlide rightSlide_slide pdStyle1 pdBtnBoxWrap">
				<div class="swiper-container">
					<div class="swiper-wrapper">
<%
sql = "select TC.guid,G.title,G.imgB, TB.Name from T_CATEGORY_CONFIG_GOODS (nolock) AS TC inner join V_GOODS (nolock) AS G ON TC.guid=G.Uid left join T_BRAND (nolock) TB ON G.brandUid = TB.uid where TC.siteID='"&siteID&"' AND gubun='SR'  AND CateCode=?"
arrParams = Array(_
	Db.makeParam("@CateCode", adInteger, adParamInput, 4, sort_cate) _
)
arrListG = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLenG, Nothing)
If IsArray(arrListG)  Then
	For i=0 To listLenG
		guid = Trim(arrListG(0, i))
		title = Trim(arrListG(1, i))
		imgB= Trim(arrListG(2, i))
		brandName = Trim(arrListG(3, i))
		call replacePathGoods("uid",guid)
		Call GetGoodsPriceInfo(guid,sort_cate,marketPrice, salePercent, salePrice,discountNum, saleTitle, minMemberPrice, maxMemberPrice, couponPrice, Cmoney, Price,tsDay, tsHour, tsMin, tsSec,isTimeSaleFlag,timetext,T_second,GuestPrice)

	sql = "select count(*) from T_GOODS_FAVORITE where goodsUid = ? and userID = ? and siteID = '"&siteID&"' "
	arrParams = Array( _
		Db.makeParam("@goodsUid", adInteger, adParamInput, 4, guid), _
		Db.makeParam("@userID", advarWchar, adParamInput, 50, authUserID) _
	)
	rsFlag = "favorite_border"
	rsFlagOnClass = ""
	If CInt(Db.execRsData(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)) > 0 Then
		rsFlag = "favorite"
		rsFlagOnClass = "on"
	End If

	goodsLink = "/product/content.asp?guid="& guid &"&cate="& gcate
%>
						<div class="swiper-slide">
							<div class="imageLayer">
								<li>
									<a href="<%=goodsLink%>" class="pdLink"></a>
									<div class="pdBtnBox">
										<a href="javascript:;" class="btn cart" onclick="go_cart('<%=guid%>')"><span class="material-icons">shopping_cart</span></a>
										<a href="javascript:;" class="btn wish" onclick="favorite_main('favorite_<%=guid%>','<%=guid%>')"><span class="material-icons <%=rsFlagOnClass%>" id="favorite_<%=guid%>"><%=rsFlag%></span></a>
										<a href="javascript:;" onclick="go_direct('<%=guid%>')" class="btn buy">
											<span class='material-icons'>credit_card</span>
										</a>
									</div>
									<div class="pdImg2">
										<a href="content.asp?guid=188086">
											<img src="<%=pathGoodsBig & imgB%>" width="100%">
										</a>
									</div>
									<div class="txtWrap">
										<div class="tit"><%=title%></div>
										<div class="priWrap2">
											<span class="dis2"><%if salePercent>0 then%><em><%=salePercent%></em>%<%end if%></span>
											<span class="price2">
												<span class="origp"><%if marketPrice>price then%><del><%=num2cur(marketPrice)%>원</del><%end if%></span>
												<span class="salep"><%=num2cur(price)%><span class="won">원</span></span>
											</span>
										</div>
									</div>
								</li>
							</div>
						</div>
<%
	next
end if
%>
					</div>
				</div>
				<div class="paginationWrap">
					<div class="swiper-pagination"></div>
				</div>
			</div>
		</div>
	</div>
<%end if%>
-->
<!-- 슬라이드 배너 끝  -->



<!-- DB days 시작  -->
<%if DB_Day_PC_IsDisplay="T" then%>
	<div class="listStyle1 r3 DB_Day_PC DB_Day_PC_S" style="display:block;">

		<h1 class="subli_tit">DB days <span>매일매일 바뀌는 새로운 혜택</span></h1>
		<div class="cont">
			<ul>
<%
	imgNo = 0
	arrListI=Null
	Link=""
	sql = "select Uid,CateCode, Img, Link, gubun, IsMobile From T_CATEGORY_CONFIG_IMAGE where siteID='"&siteID&"' And CateCode=? AND gubun=? AND IsMobile=?"
	arrParams = Array(_
		Db.makeParam("@CateCode", adInteger, adParamInput, 4, sort_cate), _
		Db.makeParam("@gubun", advarWchar, adParamInput, 50,"DPImg"), _
		Db.makeParam("@IsMobile", advarWchar, adParamInput, 1, "F") _
	)
	arrListI = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLenI, Nothing)

	If IsArray(arrListI) Then
		For i=0 To listLenI
			imgUid = Trim(arrListI(0, i))
			imgFName = null2Blank(arrListI(2, i))
			Link = null2Blank(arrListI(3, i))
			imgNo = imgNo + 1
			a_link="javascript:;"
			if Link<>"" then
				a_link=Link
			end if
%>
				<li>
					<a href="<%=a_link%>"><img src="<%=imgPath &"/"& imgFName%>" alt=""></a>
				</li>
<%
		next
	end if
%>
			</ul>
		</div>

	</div>
<%end if%>
<!-- DB days 끝  -->



<%'180618 add bhc start ----------------------------------------------------------------------------------%>
</div></div>
<div class="PageWrapSize">
<div class="sublistConWrap">
<%'180618 add bhc end -----------------------------------------------------------------------------------%>


<!-- BAR 배너 시작  -->
<%if Bar_Banner_PC_IsDisplay="T" then%>
	<div class="mid_banner Bar_Banner_PC Bar_Banner_PC_S" style="display:block;">
<%
	imgNo = 0
	arrListI=Null
	imgFName=""
	Link=""
	imgUid=0
	sql = "select Uid,CateCode, Img, Link, gubun, IsMobile From T_CATEGORY_CONFIG_IMAGE where siteID='"&siteID&"' And CateCode=? AND gubun=? AND IsMobile=?"
	arrParams = Array(_
		Db.makeParam("@CateCode", adInteger, adParamInput, 4, sort_cate), _
		Db.makeParam("@gubun", advarWchar, adParamInput, 50,"BarImgP"), _
		Db.makeParam("@IsMobile", advarWchar, adParamInput, 1, "F") _
	)
	Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)
	If Not Rs.bof And Not Rs.eof Then
		imgUid = Rs("Uid")
		imgFName = null2Blank(Rs("Img"))
		Link = null2Blank(Rs("Link"))
		a_link="javascript:;"
		if Link<>"" then
			a_link=Link
		end if
	End If
	Call closeRs(Rs)
	if imgFName<>"" then
%>
		<div class="img"><a href="<%=a_link%>"><img src="<%=imgPath &"/"& imgFName%>" /></a></div>
	<%end if%>
	</div>
<%end if%>
<!-- BAR 배너 끝  -->

<!-- MD추천 시작  -->
<%if MD_Recomm_IsDisplay="T" then%>
	<div class="listStyle1 MD_Recomm MD_Recomm_S" style="display:block;">
		<div class="subli_tit">
			<h1>가심비 보장<span>가격도 품질도 내 마음에 쏙! MD가 엄선한 가심비 보장 상품 </span></h1>
		</div>	
		<div class="slStyle1">
			<div class="swiper-container">
				<div class="swiper-wrapper">
				<%
				sql = "select TC.guid,G.title,G.imgB, TB.name from T_CATEGORY_CONFIG_GOODS (nolock) AS TC inner join V_GOODS (nolock) AS G ON TC.guid=G.Uid left join T_BRAND (nolock) TB ON G.brandUid = TB.uid where TC.siteID='"&siteID&"' AND gubun='MD'  AND CateCode=?"
				arrParams = Array(_
					Db.makeParam("@CateCode", adInteger, adParamInput, 4, sort_cate) _
				)
				'response.write sql
				arrListG = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLenG, Nothing)
				If IsArray(arrListG)  Then
					For i=0 To listLenG
						guid = Trim(arrListG(0, i))
						title = Trim(arrListG(1, i))
						imgB= Trim(arrListG(2, i))
						brandName = Trim(arrListG(3, i))
						call replacePathGoods("uid",guid)
						Call GetGoodsPriceInfo(guid,sort_cate,marketPrice, salePercent, salePrice,discountNum, saleTitle, minMemberPrice, maxMemberPrice, couponPrice, Cmoney, Price,tsDay, tsHour, tsMin, tsSec,isTimeSaleFlag,timetext,T_second,GuestPrice)

					sql = "select count(*) from T_GOODS_FAVORITE where goodsUid = ? and userID = ? and siteID = '"&siteID&"' "
					arrParams = Array( _
						Db.makeParam("@goodsUid", adInteger, adParamInput, 4, guid), _
						Db.makeParam("@userID", advarWchar, adParamInput, 50, authUserID) _
					)
					rsFlag = "favorite_border"
					rsFlagOnClass = ""
					'If CInt(Db.execRsData(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)) > 0 Then
					'	rsFlag = "favorite"
					'	rsFlagOnClass = "on"
					'End If

					goodsLink = "/product/content.asp?guid="& guid &"&cate="& gcate
				%>
					<div class="swiper-slide">
						<div class="cont pdStyle1 pdBtnBoxWrap wrap">
							<ul>
								<li>
									<div class="liWrap">
										<a href="<%=goodsLink%>" class="pdLink"></a>
										<!--
										<div class="pdBtnBox">
											<a href="javascript:;" class="btn cart" onclick="go_cart('<%=guid%>')"><span class="material-icons">shopping_cart</span></a>
											<a href="javascript:;" class="btn wish" onclick="favorite_main('favorite_<%=guid%>','<%=guid%>')"><span class="material-icons <%=rsFlagOnClass%>" id="favorite_<%=guid%>"><%=rsFlag%></span></a>
											<a href="javascript:;" onclick="go_direct('<%=guid%>')" class="btn buy">
												<span class='material-icons'>credit_card</span>
											</a>
										</div>
										-->
										<div class="mall_bgImg" style="background-image:url('<%=pathGoodsBig & imgB%>')"></div>
										<div class="txtWrap">
											<!--<div class="brand"><%=brandName%></div>-->
											<div class="tit">
												<dl>
													<dt><%=title%></dt>
													<dd><%if marketPrice>price then%><del class="marketprice"><%=num2cur(marketPrice)%></del><%end if%><span class="mwon">원
													<span></dd>
												</dl>
											</div>
											<div class="priWrap">
												<p>
													<span><%if salePercent>0 then%><%=salePercent%><%end if%><em class="m_per">%</em></span>
													<strong><%=num2cur(price)%><em class="won">원</em></strong>
												</p>
											</div>
										</div>
										<div class="icoWrap">아이콘영역</div>
									</div>
								</li>
							</ul>
						</div>
					</div>
				<%
					next
				end if
				%>
				</div> <!-- swiper-wrapper -->
				<!-- <div class="swiper-button-prev"></div>
				<div class="swiper-button-next"></div> -->
			</div> <!-- swiper-container -->
			<div class="swiper-pagination"></div>
		</div>

	</div>
<% response.Flush %>
<%end if%>
<!-- MD추천 끝  -->


<!-- BEST 시작  -->
<%if Best_IsDisplay="T" then%>
	<div class="listStyle1 Best Best_S" style="display:block;">

		<h1 class="subli_tit">베스트 <span>카테고리별 고객 인기상품을 한자리에~ 추천해 드립니다.</span></h1>
		<div class="slStyle1">
			<div class="swiper-container">
				<div class="swiper-wrapper">
				<%
				sql = "select TC.guid,G.title,G.imgB from T_CATEGORY_CONFIG_GOODS (nolock) AS TC inner join V_GOODS (nolock) AS G ON TC.guid=G.Uid where TC.siteID='"&siteID&"' AND gubun='BEST'  AND CateCode=?"
				arrParams = Array(_
					Db.makeParam("@CateCode", adInteger, adParamInput, 4, sort_cate) _
				)
				arrListG = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLenG, Nothing)
				If IsArray(arrListG)  Then
					For i=0 To listLenG
						guid = Trim(arrListG(0, i))
						title = Trim(arrListG(1, i))
						imgB= Trim(arrListG(2, i))
						call replacePathGoods("uid",guid)
						Call GetGoodsPriceInfo(guid,sort_cate,marketPrice, salePercent, salePrice,discountNum, saleTitle, minMemberPrice, maxMemberPrice, couponPrice, Cmoney, Price,tsDay, tsHour, tsMin, tsSec,isTimeSaleFlag,timetext,T_second,GuestPrice)

					sql = "select count(*) from T_GOODS_FAVORITE where goodsUid = ? and userID = ? and siteID = '"&siteID&"' "
					arrParams = Array( _
						Db.makeParam("@goodsUid", adInteger, adParamInput, 4, guid), _
						Db.makeParam("@userID", advarWchar, adParamInput, 50, authUserID) _
					)
					rsFlag = "favorite_border"
					rsFlagOnClass = ""
					If CInt(Db.execRsData(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)) > 0 Then
						rsFlag = "favorite"
						rsFlagOnClass = "on"
					End If

					goodsLink = "/product/content.asp?guid="& guid &"&cate="& gcate
				%>
					<div class="swiper-slide">
						<div class="cont pdStyle1 pdBtnBoxWrap wrap">
							<ul>
								<li>
									<div class="liWrap">
										<a href="<%=goodsLink%>" class="pdLink"></a>
										<div class="pdBtnBox">
											<a href="javascript:;" class="btn cart" onclick="go_cart('<%=guid%>')"><span class="material-icons">shopping_cart</span></a>
											<a href="javascript:;" class="btn wish" onclick="favorite_main('favorite_<%=guid%>','<%=guid%>')"><span class="material-icons <%=rsFlagOnClass%>" id="favorite_<%=guid%>"><%=rsFlag%></span></a>
											<a href="javascript:;" onclick="go_direct('<%=guid%>')" class="btn buy">
												<span class='material-icons'>credit_card</span>
											</a>
										</div>
										<div class="bgImg" style="background-image:url('<%=pathGoodsBig & imgB%>')"></div>
										<div class="txtWrap">
											<div class="brand"><%=brandName%></div>
											<div class="tit"><%=title%></div>
											<div class="priWrap">
												<span class="dis"><%if salePercent>0 then%><em><%=salePercent%></em>%<%end if%></span>
												<span class="price">
													<span class="origp"><%if marketPrice>price then%><del><%=num2cur(marketPrice)%>원</del><%end if%></span>
													<span class="salep"><%=num2cur(price)%><span class="won">원</span></span>
												</span>
											</div>
										</div>
									</div>
								</li>
							</ul>
						</div>
					</div>
					<%
						next
					end if
					%>
				</div> <!-- swiper-wrapper -->
				<!-- <div class="swiper-button-prev"></div>
				<div class="swiper-button-next"></div> -->
			</div> <!-- swiper-container -->
			<div class="swiper-pagination"></div>
		</div>

	</div>
<%end if%>
<!-- BEST 끝 -->

<!-- 오늘만 이가격 시작(숨김_2019)  -->
<%if ODay_PC_IsDisplay="FF" then%>
	<div class="listStyle1 ODay_S" id="ODay_content" style="display:block;">

	</div>
	<script src="/jscript/ImgBoxAlign.js"></script>
	<script>
		$("#ODay_content").load("ODay_Content.asp");
		$("#eventToday_list").load(function(){ImgBoxAlign()})
	</script>
<%else%>
	<div class="listStyle1 ODay_S"></div>
<%end if%>
<!-- 오늘만 이가격 끝  -->

<%
if Search_type="AA" then%>
<!-- 스마트검색 시작 -->
<div class="smartSearch Search Search_S" style="display:block; margin-bottom: 50px">

<%
	if isSearch = "T"  then  '''검색노출시

	'사이트 환경설정 > 스마트서치 - 브랜드영역 노출(S)
	If cfgisSearchBrand = "T" and Search_type="A"  Then
%>
	<div class="inWrap">
		<div id="subbrandList" class="ssSection"></div>
		<button id="btnBrandList" onclick="fnGetSmatrSearchBrandView()">＋</button>

		<div id="popBrandList"></div>
<%
	End If
	'사이트 환경설정 > 스마트서치 - 브랜드영역 노출(E)
%>




<%if Search_type="A" then%>
		<div id="subcateList"  class="ssSection">
		</div>
		<div id="subSearchForm"  class="ssSection">

		<div class="ssTitle">
			<span>가격</span>
		</div>
		<div class="ssCont">
			<input type="text" id="sprice" name="sprice" maxlength="8" placeholder="최저가" onkeyup="numberOnly(this)" onblur="numberOnly(this)" /><span class="tilde">~</span><input type="text" id="eprice" name="eprice" maxlength="8" placeholder="최고가" onkeyup="numberOnly(this)" onblur="numberOnly(this)" />
		</div>

<!-- 색상등록 시작 -->
<%
Color_Data=Get_Goods_Color("S",Null)
if Color_Data<>"N" then
%>
		<div class="color_list">
			<div class="ssTitle">
				<span>색상</span>
			</div>
			<div class="ssCont color">
				<ul>
					<%=Color_Data%>
				</ul>
			</div>
		</div>
<%end if%>
<!-- 색상등록 끝 -->

		<div class="ssTitle">
			<span>결과 내 재검색</span>
		</div>
		<div class="ssCont">
			<input type="text" id="sword" name="sword" style="width:286px; padding:0 10px; text-align:left;" />
			<button class="btn_kwdSC iconfont ftic-search" onclick="fnSubmit();"></button>
		</div>

	</div>


	<span class="btn_dtlSC">상세검색</span>

<%end if%>
</div>
<%end if%>
</div>
<%end if%>
<!-- 스마트검색 끝-->


</div>

<!-- 종합몰 검색 시작   -->
<!--검색속도 향상을 위해 비정규코드 Z (B->Z)로 변경(실행안됨) 2019.02.22-->
<%if Search_type="Z" Then ' 20180412 kyh isSearch 추가 %>

	<div id="subSearchForm"  class="ssSection Search Search_S" style="display:block;">
<%if isSearch = "T"  then %>
		<div class="det_filter cfix" id="det_filter" style="width:100%;">
			<div class="det_filter_wrap">
				<dl class="category extend" id="brdCnt">
					<dt>
						카테고리
					</dt>
					<dd>
						<ul class="brand extend">
<%
query= "select count(TC.GoodsUid) from V_GOODS (nolock) AS G INNER JOIN T_GOODS_CATEGORY (nolock) AS TC ON G.Uid=TC.GoodsUid and TC.sort=1 where   TC.IsTrash='F' and G.IsDisplay='T' AND G.IsOnlySearch = 'F'  AND G.SiteID='"& siteID &"' AND G.GoodsType in ('"& CM_GDTYPE_NOR &"', '"& CM_GDTYPE_MOBILEGIFT_CON &"', '"& CM_GDTYPE_MOBILEGIFT_SELF &"') AND G.State='"& CM_GDSTATE_NOR &"' AND G.IsDisplay='T' AND G.IsOnlySearch = 'F' AND TC.CateCode in (select catecode FROM   Fngetcatechild(?, ?, "&cfgCateDepth&") WHERE  IsHidden = 'F')"

		arrParams = Array(_
			Db.makeParam("@siteID", advarWchar, adParamInput, 20,siteID), _
			Db.makeParam("@CateCode", adInteger, adParamInput, 4, list_cate) _
		)
		GCNT = Db.execRsData(query, DB_CMDTYPE_TEXT, arrParams,Nothing)
%>
							<li onclick="load_cate_goods('<%=list_cate%>')" style="cursor:pointer;">전체상품보기(<%=GCNT%>)</li>
<%
arrListC=Null

sql = "select catecode,name from fnGetCateChild(?,?,"&search_depth&") where depth>"&search_depth-1&" and IsHidden='F'"
arrParams = Array(_
	Db.makeParam("@siteID", advarWchar, adParamInput, 20,siteID), _
	Db.makeParam("@CateCode", adInteger, adParamInput, 4, list_cate) _
)
arrListC = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLenC, Nothing)
If isArray(arrListC) Then
	For i = 0 To listLenC

		query= "select count(TC.GoodsUid) from V_GOODS (nolock) AS G INNER JOIN T_GOODS_CATEGORY (nolock) AS TC ON G.Uid=TC.GoodsUid and TC.sort=1 where   TC.IsTrash='F' and G.IsDisplay='T' AND G.IsOnlySearch = 'F'  AND G.SiteID='"& siteID &"' AND G.GoodsType in ('"& CM_GDTYPE_NOR &"', '"& CM_GDTYPE_MOBILEGIFT_CON &"', '"& CM_GDTYPE_MOBILEGIFT_SELF &"') AND G.State='"& CM_GDSTATE_NOR &"' AND G.IsDisplay='T' AND G.IsOnlySearch = 'F' AND TC.CateCode in (select catecode FROM   Fngetcatechild(?, ?, "&cfgCateDepth&") WHERE  IsHidden = 'F')"

		arrParams = Array(_
			Db.makeParam("@siteID", advarWchar, adParamInput, 20,siteID), _
			Db.makeParam("@CateCode", adInteger, adParamInput, 4, arrListC(0,i)) _
		)
		GCNT = Db.execRsData(query, DB_CMDTYPE_TEXT, arrParams,Nothing)
%>
							<li onclick="load_cate_goods('<%=arrListC(0,i)%>')" style="cursor:pointer;"><%=arrListC(1,i)%>(<%=GCNT%>)</li>
<%
	next
end if
%>
						</ul>
					</dd>
				</dl>
<%
	sql = "select"
	sql = sql & " T1.Uid, T1.Name, T1.ImgBrand"
	sql = sql & " from T_BRAND T1"
	sql = sql & " 	inner join V_GOODS T2 on T1.Uid = T2.BrandUid and T2.SiteID = '"& siteID &"' AND T2.GoodsType='"& CM_GDTYPE_NOR &"' and T2.State = '"& CM_GDSTATE_NOR &"' and T2.IsDisplay='T' and T2.IsOnlySearch = 'F'"
	sql = sql & " 	inner join V_GOODS_CATEGORY T3 on T2.Uid = T3.GoodsUid and T3.IsTrash='F'"
	sql = sql & " where T1.IsConfirm = 'T' and T1.SiteID='"&siteID&"' and T3.CateCode in (select catecode FROM   Fngetcatechild(?, ?, "&cfgCateDepth&") WHERE  IsHidden = 'F')"
	sql = sql & " group by T1.Uid, T1.Name, T1.ImgBrand"
	sql = sql & " order by T1.Name asc"
	arrParams = Array(_
		Db.makeParam("@siteID", advarWchar, adParamInput, 20,siteID), _
		Db.makeParam("@CateCode", adInteger, adParamInput, 4, list_cate) _
	)

	arrList = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLen, Nothing)
%>
				<dl class="brand" id="brdCnt">
					<dt>
						브랜드 (<span class="num"><%=listLen+1%></span>)
					</dt>
					<dd id="brand_dd" data-log-actionid-area="filter">
						<ul class="brand extend" id="areaBrandList">
<%
If isArray(arrList) Then
	For i = 0 To listLen
		brandUid = checkNumeric(arrList(0, i))
		brandName = null2Blank(arrList(1, i))
		imgBrand= null2Blank(arrList(2, i))

		If imgBrand <> "" Then
			ImgBrand =  imgURL & pathBrand &"/"& imgBrand
		Else
			ImgBrand = ""
		End If

		'sql = " SELECT Count(*) FROM V_GOODS (nolock) AS G WHERE Branduid='"&BrandUid&"' AND G.GoodsType in ('"& CM_GDTYPE_NOR &"', '"& CM_GDTYPE_MOBILEGIFT_CON &"', '"& CM_GDTYPE_MOBILEGIFT_SELF &"') AND G.State='"& CM_GDSTATE_NOR &"' AND G.IsDisplay='T' AND G.IsOnlySearch = 'F' "
		'#숫자가 상품리스트 검색결과와 틀려 수정함, jings3, 2018-04-13
		sql = "SELECT Count(*) FROM V_GOODS AS G(NOLOCK) INNER JOIN V_GOODS_CATEGORY AS C(NOLOCK) ON G.UID = C.GoodsUid WHERE G.Branduid='"& BrandUid &"' AND G.GoodsType in ('"& CM_GDTYPE_NOR &"', '"& CM_GDTYPE_MOBILEGIFT_CON &"', '"& CM_GDTYPE_MOBILEGIFT_SELF &"') AND G.State='"& CM_GDSTATE_NOR &"' AND G.IsDisplay='T' AND G.IsOnlySearch = 'F' AND C.IsHidden = 'F' AND C.CateCode IN (SELECT CateCode FROM Fngetcatechild('familymall', "& cate &", 4) ) "
		GoodsCnt = checkNumeric(Db.execRsData(sql, DB_CMDTYPE_TEXT, Null,Nothing))
%>

								<li class="" id="1111"><!-- checked 되면 .on 클래스 추가 -->
									<label for="brand<%=brandUid%>" style="background-image:url('<%=ImgBrand%>');" id="chk_brand">
										<input type="checkbox" id="brand<%=brandUid%>" name="bUid" value="<%=brandUid%>" onclick="branduid_search();">
										<span class="b_name"><%=brandName%></span>
										<span>(<%=num2cur(GoodsCnt)%>)</span>
									<span class="ico_chk"></span>
									<%if ImgBrand="" then%>
									<span class="brandnamearea"><%=brandName%></span>
									<%end if%>
									</label>
								</li>
<%
	next
end if
%>

						</ul>
					</dd>
				</dl>
				<dl class="benefitNdeliver" id="brdCnt">
					<dt>
						혜택/배송
					</dt>
					<dd id="brand_dd" data-log-actionid-area="filter">
						<ul class="brand extend">
							<li><label><input type="checkbox" name="Delivery" id="" onclick="CheckDelivey();"><span class="ico_chk"></span> 무료배송</label></li>
							<li><label><input type="checkbox" name="Cmoney" id="" onclick="CheckCmoney();"><span class="ico_chk"></span> 적립금</label></li>
						</ul>
					</dd>
				</dl>
			</div>
			<div class="reSearch">
				<div class="prcWrap">
					<span class="tit">가격</span>
					<span class="ssCont">
						<input type="text" id="sprice" name="sprice" maxlength="8" placeholder="최소금액" onkeyup="numberOnly(this)" onblur="numberOnly(this)" /><span class="tilde">~</span><input type="text" id="eprice" name="eprice" maxlength="8" placeholder="최대금액" onkeyup="numberOnly(this)" onblur="numberOnly(this)" />
					</span>
				</div>
				<fieldset>
					<span class="tit">결과 내 재검색</span>
					<div class="box_select">
						<select name="search_gubun" id="search_gubun">
							<option value="T">포함단어</option>
							<option value="F">제외단어</option>
						</select>
					</div>
					<input type="text" name="sword" id="sword" placeholder="결과 내 재검색">
					<span class="btnSearch" onclick="getSubList();">검색</span>
				</fieldset>
			</div>
<%end if%>
		</div>
<%end if%>
<!-- 종합몰 검색 끝  -->

<script type="text/javascript">
<!--
$(document).ready(function(){
	var cate = $("#cate").val();
	fnGetSmatrSearchTopMenu(cate);

	getSubList();

	//정렬방식
	$("#listsort a").click(function(){
		$(this).parents().find("a").removeClass("active");
		$(this).addClass("active");
	});
});

function fnSubmit(){

	getSubList();

	//정렬방식
	$("#listsort a").click(function(){
		$(this).parents().find("a").removeClass("active");
		$(this).addClass("active");
	});
}

function sortChg(type){
	$("#listsort").val(type);
	getSubList();
}

function menuChg(e, c){
	var t = $(e).attr("class");
	var p = $(e).attr("data-parent");

	var o = "";
	if (t != "on")
	{
		o = "on"
	} else {
		o = "on"
		c = p;
	}
	fnGetSmatrSearchTopMenu(c, o);

	$("#pcate").val(p);
	$("#cate").val(c);
	$("#pStart").val(0);

	getSubList();

	$(".paging a").each(function(){
		if ($(this).attr("href") == undefined){
			$(this).addClass("on")
		}else{
			$(this).removeClass("on")
		}
	});
}

//리스트 출력
function getSubList(){
	var cate = $("#cate").val();
	var listsort = $("#listsort").val();
	var listsize = $("#listsize").val();
	var pStart = $("#pStart").val();
	var branduid = $("#branduid").val();

	var sprice = $("#sprice").val();
	var eprice = $("#eprice").val();
	var sword = $("#sword").val();
	var search_gubun=$("#search_gubun").val();
	var IsCmoney=$("#IsCmoney").val();
	var IsDelivery=$("#IsDelivery").val();
	var searchcateuid="";
	var coloruid="";
	$( "input[name=search_cate]:checked" ).each(function() {
			var search_cate=$(this).val();
			searchcateuid+=search_cate+",";
	  });

		//20180112 joonyus 색상검색추가
	  $( "input[name=Color_Uid]:checked" ).each(function() {
			var color_uid=$(this).val();
			coloruid+=color_uid+",";
	  });


	$.ajax({
		type : "POST",
		dataType : "text",
		async	: false,
		data : {cate:cate, listsort:listsort, listsize:listsize, pStart:pStart, branduid:branduid, sprice:sprice, eprice:eprice, sword:sword,searchcateuid:searchcateuid,coloruid:coloruid,search_gubun:search_gubun,IsDelivery:IsDelivery,IsCmoney:IsCmoney} ,
		url  : "./ajaxSubList_2.asp",
		success : function(data) {
			var flag = false;
			try {
				if(data !=""){
					var arrData = data.split("||");
					$(".gallery_list ul").html(arrData[0]);
					$(".paging_box").html(arrData[1]);
					$(".total_cont em").html(arrData[2]);
					//$( 'html, body' ).animate( { scrollTop : 0 }, 400 );
					ajaxAfter();

					//var imgwidthlist = $('.gallery_list ul li a.pdImg').width()
					//$('.gallery_list ul li a.pdImg').height(imgwidthlist);
				}
			} catch(e) {
				alert("error - " + e.description);
			}
		}
	});
}

//페이지 호출
function paging(pageName, pStart){
	$("#"+pageName).val(pStart);
	getSubList();
	var viewHeight = $('.gallery_list').offset().top;
	$( 'html, body' ).animate( { scrollTop : viewHeight }, 400 );
}

////20170707 joonyus 페이지 바로가기 추가
function direct_paging(size){
	var target=$("#d_page").val();
	if(target!=""){
		var target_page=size*(target-1);
		paging('pStart',target_page);
	}else{
		alert("이동할 페이지번호를 입력하세요.");
		$("#d_page").focus();
	}
}

//리스트 출력
function fnGetSmatrSearchTopMenu(cate, onoff){
	if (!cate)
	{
		cate = 0;
	}
	if (!onoff)
	{
		onoff = "on";
	}

	$.ajax({
		type : "POST",
		dataType : "text",
		data : {cate:cate, onoff:onoff},
		url  : "/common/ajax/exec_getSmartSearch.asp",
		success : function(data) {
			if(data !=""){
				if (data == "FAIL3")
				{
					alert("카테고리 기본정보가 없습니다.");
					return false;
				} else if (data == "FAIL")
				{
					alert("카테고리 정보가 없습니다.");
					return false;
				} else if (data == "FAIL2")
				{
					alert("카테고리 depth 정보가 없습니다.");
					return false;
				} else {
					$("#subcateList").html(data);
				}
			}
		}
	});
}

function load_cate_goods(cate){
	$("#cate").val(cate);
	//getSubList();
	location.href="/product/sublist.asp?cate="+cate
}

function branduid_search(){
	var buid;
	var searchbranduid="";
	$( "input[name=bUid]:checked" ).each(function() {
			var search_brand=$(this).val();

			searchbranduid+=search_brand+",";
	  });
	  $("#branduid").val(searchbranduid);
	  getSubList();
}

function CheckDelivey(){
	var result=$("input:checkbox[name='Delivery']").is(":checked");
	if (result){
		$("#IsDelivery").val("T");
	}else{
		$("#IsDelivery").val("F");
	}
	 getSubList();
}

function CheckCmoney(){
	var result=$("input:checkbox[name='Cmoney']").is(":checked");
	if (result){
		$("#IsCmoney").val("T");
	}else{
		$("#IsCmoney").val("F");
	}
	 getSubList();
}
//-->
</script>

<%if Search_type="A" then%>
<script type="text/javascript">

//상세검색 펼침/접기
$(".btn_dtlSC").click(function(){
	if($(this).hasClass("on"))
	{
		$(this).text("상세검색").removeClass("on");
		$("#subSearchForm").stop(true,true).slideUp("fast");
	}
	else
	{
		$(this).text("접기").addClass("on");
		$("#subSearchForm").stop(true,true).slideDown("fast");
	}
});

</script>
<%end if%>
<!-- 스마트검색 끝 -->
<%
	'브랜드 영역 사용여부
	If CM_SMARTSEARCH_USEYN = "T" and Search_type="A"  Then
%>
<script type="text/javascript">
<!--
///////////////////////////
//본페이지 브랜드 관련함수
///////////////////////////

$(document).ready(function(){
	var cate = $("#cate").val();
	fnGetBrandList();
});

function brandChg(e){
	var t = $(e).attr("class");

	if (t == "on")
	{
		$(e).removeClass("on");
	} else {
		$(e).addClass("on");
	}

	$("#pop").val("");

	fnSubmitBrand();

	var b = parseInt($("#branduids").val(), 10);

	if (b==0)
	{
		fnGetBrandList();

		fnSetBrandListLimit();
	}
}

function fnSubmitBrand(){
	fnGetBrandUid();

	getSubList();

	$(".paging a").each(function(){
		if ($(this).attr("href") == undefined){
			$(this).addClass("on")
		}else{
			$(this).removeClass("on")
		}
	});
}

function fnGetBrandUid(){
	var branduids = "";
	$("#subbrandList").find(".ssCont a").each(function(){
		var t = $(this).attr("class");
		var v = parseInt($(this).attr("data-branduid"), 10);

		if (t == "on")
		{
			branduids = branduids + v +",";
		}
	});

	if (branduids != "")
	{
		$("#branduids").val(branduids);
		$("#branduid").val(branduids);
	} else {
		$("#branduids").val(0);
		$("#branduid").val(0);
	}
}

function fnGetBrandList(){
	var cate = $("#cate").val();
	var branduids = $("#branduids").val();
	var pcate = parseInt($("#pcate").val(), 10);
	if (pcate > 0)
	{
		cate = pcate;
	}

	$.ajax({
		type : "POST",
		dataType : "text",
		data : {cate:cate, brand:branduids} ,
		url  : "/common/ajax/exec_getSmartSearchBrandList.asp",
		success : function(data) {
			if(data != ""){
				$("#subbrandList").html(data);
				fnSetBrandListLimit();			//브랜드목록보기 버튼 제한
			}
		}
	});
}

function fnSetBrandListLimit(){
	var c = $("#subbrandList").find(".ssCont a").length;
	var p = $("#pop").val();

	//버튼 보여줌
	$("#btnBrandList").show();

	if (c > 7)
	{
		if (p == "pop" )
		{
			$("#subbrandList").height("auto");
		} else {
			$("#subbrandList").height("");
		}
	}
}
//-->
</script>
<script type="text/javascript">
<!--
///////////////////////////
//레이어 브랜드 관련 함수
///////////////////////////

//레이어 브랜드 목록 보기
function fnGetSmatrSearchBrandView(){
	var cate = $("#cate").val();
	var branduids = $("#branduids").val();
	var pcate = parseInt($("#pcate").val(), 10);
	if (pcate > 0)
	{
		cate = pcate;
	}

	$.ajax({
		type : "POST",
		dataType : "text",
		data : {cate:cate, brand:branduids} ,
		url  : "/product/ajax/pop_brandList.asp",
		success : function(data) {
			if(data != ""){
				$("#popBrandList").html(data);
				showPop("#popBrandList","");
			}

			fnResetSmartSearchBrand();
		}
	});
}

//레이어 브랜드 클릭에 따른 처리
function fnResetSmartSearchBrand(){
	$("#popBrand").find(".ssCont a").click(function(){
		var t = $(this).attr("class");

		if (t == "on")
		{
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});
}

//브랜드 선택없이 레이어 닫기
function fnClosePopBrandList(){
	$(".layer_pop").fadeOut("fast");
	$(".mask").hide();
}

//레이어 브랜드uid 추출
function fnGetBrandUid2(){
	var branduids = "";
	$("#popBrandList").find(".ssCont a").each(function(){
		var t = $(this).attr("class");
		var v = parseInt($(this).attr("data-branduid"), 10);

		if (t == "on")
		{
			branduids = branduids + v +",";
		}
	});

	if (branduids != "")
	{
		$("#branduids").val(branduids);
		$("#branduid").val(branduids);
	} else {
		$("#branduids").val(0);
		$("#branduid").val(0);
	}
}

function fnGetBrandList2(){
	var cate = $("#cate").val();
	var branduids = $("#branduids").val();
	var p = "pop";
	$("#pop").val(p);

	$.ajax({
		type : "POST",
		dataType : "text",
		data : {cate:cate, brand:branduids, p:p} ,
		url  : "/common/ajax/exec_getSmartSearchBrandList.asp",
		success : function(data) {
			if(data != ""){
				$("#subbrandList").html(data);
				fnSetBrandListLimit();			//브랜드목록보기 버튼 제한
			}
		}
	});
}

//브랜드 레이어에서 확인 클릭시 동작
function fnSetSmartSearchBrand(){

	fnClosePopBrandList();

	fnGetBrandUid2();

	fnGetBrandList2();

	fnSetBrandListLimit();

	getSubList();
}

//-->
</script>
<%
	End If
%>


<!-- familymall 만 적용 180416--><!-- 4.25icw주석 -->
<%'if siteID<>"familymall" then%>
<!-- 순서컨트롤 -->
<div class="view_type_box">
	<p class="total_cont">총 <em>0</em>개의 상품이 있습니다.</p>
	<!-- 셀렉트 -->
	<select class="select_fild opacity" id="viewCount">
		<option value="10" selected>10줄</option>
		<option value="20">20줄</option>
		<option value="40">40줄</option>
		<!--<option value="80">80줄</option>-->
	</select>
	<!-- 셀렉트 끝 -->
<%
	'''//20171117 joonyus 서비스상품추가로 인해 상품테이블명 변경하는 작업
	sql = " SELECT count(*) FROM T_CONFIG_ADDON WHERE siteID=? and serviceType='servicegoods' and isUse='T' "
	arrParams = Array( _
		Db.makeParam("@siteID", adVarchar, adParamInput, 20, siteID) _
	)
	servicegoodsTypeCnt = checkNumeric(Db.execRsData(sql, DB_CMDTYPE_TEXT, arrParams,Nothing))

	GoodsTable="T_SEARCH_CATEGORY"
	GoodsTable_Goods="T_SEARCH_GOODS"

	if servicegoodsTypeCnt>0 then
		GoodsTable="T_SERVICEGOODS_SEARCH_CATEGORY"
		GoodsTable_Goods="T_SERVICEGOODS_SEARCH_GOODS"
	end if
	'''//20171117 joonyus 서비스상품추가로 인해 상품테이블명 변경하는 작업///////////////

sql = "select count(*) from "&GoodsTable&" where siteID='"&siteID&"' and IsUse='T' and  depth=1"
filterCnt = checkNumeric(Db.execRsData(sql, DB_CMDTYPE_TEXT, Null,Nothing))

sql = "select COUNT(*) from "& GoodsTable_Goods &" AS TSG inner join dbo.T_GOODS_CATEGORY AS TC on TSG.guid=TC.GoodsUid where tsg.siteID='"&siteID&"' and tc.CateCode in(select CateCode from fnGetCateChild(?,?,3))"
arrParamsC = Array( _
	Db.makeParam("@siteID", adVarchar, adParamInput, 20, siteID), _
	Db.makeParam("@cate", adInteger, adParamInput, 4, cate) _
)
filterGoodsCnt= checkNumeric(Db.execRsData(sql, DB_CMDTYPE_TEXT, arrParamsC,Nothing))


filterFlag=true
if filterCnt=0 or filterGoodsCnt=0 then
	filterFlag=false
end if
%>

	<div class="view_type opacity" id="listsort">
		<%if filterFlag=true then%>
		<a href="javascript:;" class="btn-xs b-filter openLayerFix"><i class="material-icons">filter</i></a>
		<%end if%>
		<a href="javascript:sortChg('favorite');" class="active">인기상품순</a>
		<a href="javascript:sortChg('new');">신상품순</a>
		<a href="javascript:sortChg('low');">낮은가격순</a>
		<a href="javascript:sortChg('high');">높은가격순</a>
		<a href="javascript:sortChg('opinion');">상품평점순</a>
<%'180727 add bhc : 판매수량순%>
	</div>
</div>
<div class="layerFix L-filter" style="display:none">
	<div class="layerBg L-filter"></div>
	<div class="layerConWrap L-filter">
		<div class="secTop">
			<a href="javascript:;" class="btnClLyr L-filter">X</a>
			<div class="tit">쇼핑몰 필터</div>
		</div>
		<div class="secMid">
			<ul>
<%
sql = "select uid, cate_name, depth from "&GoodsTable&" where siteID='"&siteID&"' and IsUse='T' and  depth=1 order by uid asc"
arrParams = Null
arrList = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLen, Nothing)
If isArray(arrList) Then
	for i=0 to listLen
%>
				<li>
					<div class="tit"><%=arrList(1,i)%></div>
					<div class="con">
					<%
						parent_cate=arrList(0,i)
						query ="select uid, cate_name, depth from "&GoodsTable&" where  siteID='"&siteID&"' and depth=2 and parent_cate=? order by uid asc"
						arrParams = Array( _
							Db.makeParam("@parent_cate", adBigInt, adParamInput, 8, parent_cate) _
						)
						arrListS = Db.execRsList(query, DB_CMDTYPE_TEXT, arrParams, listLenS, Nothing)
						If isArray(arrListS) Then
							for s=0 to listLenS
					%>
						<label><input type="checkbox" name="search_cate" value="<%=arrListS(0,s)%>" id=""><%=arrListS(1,s)%></label>
					<%
							next
						end if
					%>
					</div>
				</li>
<%
	next
end if
%>
			</ul>
		</div>
		<div class="secBot sitebg2">
			<a href="javascript:;" class="btnCp clLyr" onclick="getSubList();">선택 완료</a>
		</div>
	</div>
</div>
<%'end if%><!-- 4.25icw주석 -->
<!-- familymall 만 적용 끝-->
<!-- 순서컨트롤 끝 -->

<!-- 갤러리 제품리스트 -->
<div class="gallery_list <%=strImgColumnNum%> pdBtnBoxWrap wrap">
	<ul>
	</ul>
</div>
<!-- 갤러리 제품리스트 끝 -->

<!-- //20170720 joonyus 장바구니,바로구매 레이어  -->
<!--#include virtual="/common/goods_cart_layer.asp"-->
<!-- //20170720 joonyus 장바구니,바로구매 레이어  ///-->

<!-- 흰색배경 페이징 -->
<div class="paging_box">
</div>
<!-- 흰색배경 페이징 끝 -->

<!-- 노출순서 바꾸기 시작 -->
<!-------  20180425 joonyus 순서사용안함
<script>
$(document).ready(function(){
	<%
	pre_class="StartDiv"
	for i=1 to ubound(Sort_gubun_PC)
	%>
	//	$(".<%=Sort_Val_PC(i)%>_S").insertAfter(".<%=pre_class%>_S");
		$(".<%=Sort_Val_PC(i)%>_S").css("display","block");
	<%
		pre_class=Sort_Val_PC(i)
	next
	%>
	$(".view_type_box").insertAfter(".StartDiv_E");
	$(".gallery_list").insertAfter(".view_type_box");
	$(".paging_box").insertAfter(".gallery_list");

});
</script>
-------->
<!-- 노출순서 바꾸기 끝 -->

<% ' 20170607 kyh, criteo 상품리스트 스크립트 (S) %>
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
<script type="text/javascript" src="/jscript/criteoMD5.js"></script>
<script type="text/javascript">
	function ajaxAfter(){
		var goodsCode1 = $('#goodsCode1').val();
		var goodsCode2 = $('#goodsCode2').val();
		var goodsCode3 = $('#goodsCode3').val();
		window.criteo_q = window.criteo_q || [];
		var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
		var criteoEmail = criteoMd5("<%=criteoEmail%>");
		window.criteo_q = window.criteo_q || [];
		window.criteo_q.push(
			{ event: "setAccount", account: '<%=cfgAccountKey%>' },
			{ event: "setEmail", email: criteoEmail },
			{ event: "setSiteType", type: deviceType },
			{ event: "viewList", item:[goodsCode1 , goodsCode2 , goodsCode3]}
		);
	}
</script>
<% ' 20170607 kyh, criteo 상품리스트 스크립트 (E) %>

<script type="text/javascript" src="/jscript/layer.js"></script>
<!-- copyright -->
<!--#include virtual="/_include/copyright.asp"-->
<!-- copyright -->
<script>

	$("#viewCount").change(function(){
		$("#listsize").val($(this).val());
		getSubList();
		$(".select_fild").selectmenu("refresh");
	});



	//첫로딩시 페이지 마지막에 한번 진행할것
	$(".select_fild").selectmenu({
		change: function(){
			$(this).change();
		}
	});

	layerFix(2);
	(function(){
		var swc=$(".L-filter input[type=checkbox]")
		var swr=$(".L-filter input[type=radio]")
		swc.click(function(){
			if($(this).is(":checked")){
				$(this).closest("label").addClass("on")
			}else{
				$(this).closest("label").removeClass("on")
			}
		})
		swr.click(function(){
			swr.each(function(){
				$(this).closest("label").removeClass("on")
			})
			$(this).closest("label").addClass("on")
		})
	})();


	function filter_Icon_view(val){
		$(".layerBtn").css("display",val);
	}

	$("#areaBrandList li input[type=checkbox]").click(function(){
		//console.log($(this))
		if($(this).is(":checked")){
			$(this).closest("label").addClass("on")
		}else{
			$(this).closest("label").removeClass("on")
		}
	})


</script>

