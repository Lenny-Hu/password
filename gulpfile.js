const gulp = require('gulp');

function web () {
  return gulp.src([
    './web/manifest.json',
    './web/scripts/**/*'
  ], {
    base: './web'
  })
    .pipe(gulp.dest('./build/web'));
}

exports.web = web;
