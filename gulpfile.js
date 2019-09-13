const gulp = require('gulp');

function web () {
  return gulp.src('./web/manifest.json')
    .pipe(gulp.dest('./build/web'));
}

exports.web = web;
