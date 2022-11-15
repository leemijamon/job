const express = require('express'); // express 외부 모듈 불러오기
const app = express(); // 변수 생성

app.set('views', `${__dirname}/project/dist/`); // 화면은 dist 폴더에 있는 파일을 보도록
app.engine('html', require('ejs').renderFile); // ejs 엔진을 이용하여 html 렌더링
app.set('view engine', 'html');

// dist 폴더를 기본으로 하며, 그 안의 index 파일을 기본으로 띄우기
app.use('', express.static(`${__dirname}/project/dist/`))
app.get( '/' , ( req , res ) => {
	res.render( 'index' , {}) ;
});

// 설정한 포트로 서버 띄우기, 서버가 정상작동하면 포트명 알림
const server = app.listen( 5020, () => {
    console.log( 'Express listening on port : ' + server.address().port );
})