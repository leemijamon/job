"use strict";

var gulp = require('gulp'); //gulp 모듈 불러오기


var nodemon = require('gulp-nodemon'); // 프로젝트 내의 파일에 변경사항이 있으면 서버 재시작


var browserSync = require('browser-sync'); // 소스가 변경되면 브라우저 새로고침 browser sync
// html 불러오기


gulp.task('html', function () {
  return gulp.src('./src' + '/*.html') // src 폴더의 파일들을 읽고, task 안의 내용들을 처리한다음 dist 폴더로 재생성
  .pipe(gulp.dest('./dist')).pipe(browserSync.reload({
    stream: true
  }));
}); // app.js 기반으로 서버 실행

gulp.task('nodemon', function (cd) {
  var started = false;
  return nodemon({
    script: 'app.js'
  }).on('start', function () {
    if (!started) {
      cd();
      started = true;
    }

    ;
  });
}); // browser-sync task에서 nodemon을 불러와 보다 위에 있으면 안됨

gulp.task('browser-sync', gulp.series('nodemon', function () {
  browserSync.init(null, {
    proxy: 'http://localhost:5020',
    port: 5022
  });
})); // src폴더에 있는 html 소스가 변경되는지 감시

gulp.task('watch', function () {
  gulp.watch('./src' + '/**/*.html', gulp.series(['html']));
}); // 상단에 작성한 task 실행

gulp.task('default', gulp.series(['html', 'browser-sync', 'watch']));