"use strict";

var gulp = require('gulp'); //gulp 모듈 불러오기


var concat = require('gulp-concat'); // concat 패키지 모듈 호출
// 상단에 작성한 task 실행


gulp.task('default', function () {
  console.log('gulp가 정상적으로 작동합니다.');
});