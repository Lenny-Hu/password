/*
 * @Author: your name
 * @Date: 2019-10-29 10:44:03
 * @LastEditTime: 2019-10-29 11:21:14
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 */
const gulp = require('gulp');

function crx () {
  return gulp.src([
    './web/manifest.json'
  ], {
    base: './web'
  })
    .pipe(gulp.dest('./docs'))
    .pipe(gulp.dest('./build/web'));
}

function web () {
  return gulp.src([
    './build/web/**/*'
  ], {
    base: './build/web'
  })
    .pipe(gulp.dest('./docs'));
}

exports.web = web;
exports.crx = crx;
