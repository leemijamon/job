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