var gulp = require('gulp');
//var clean = require('gulp-clean');
var gutil = require('gulp-util');
var jshint = require('gulp-jshint');
var uglify = require('gulp-uglify');
var cssmin = require('gulp-cssmin');
var rename = require('gulp-rename');
var replace = require('gulp-replace');
var watch = require('gulp-watch');

/*gulp.task('build-interblock-sistema-clean', function() {
	return gulp
		.src(['./release'])
		.pipe(clean({
			read: false,
			force: true
		}));
});*/

/*
gulp.task('jshint-js', function() {
	return gulp
		.src(['./js/*.js'])
		.pipe(jshint())
		.pipe(jshint.reporter('default'));
});
*/

gulp.task('build-interblock-sistema-js', function() {
	return gulp
		.src(['./src/js/*.js'])
		//.pipe(uglify())
		.pipe(gulp.dest('./release/js'));
});

gulp.task('build-interblock-sistema-lib-js', function() {
	return gulp
		.src([
			'./src/lib/**/*.min.js'
		])
		.pipe(gulp.dest('./release/lib'));
});

gulp.task('build-interblock-sistema-lib-css', function() {
	return gulp
		.src([
			'./src/lib/**/*.min.css'
		])
		.pipe(gulp.dest('./release/lib'));
});

gulp.task('build-interblock-sistema-bootstrap-css', function() {
	return gulp
		.src([
			'./src/lib/bootstrap/**/*.css'
		])
		.pipe(cssmin())
		.pipe(gulp.dest('./release/lib/bootstrap'));
});

gulp.task('build-interblock-sistema-lib-angular-i18n', function() {
	return gulp
		.src([
			'./src/lib/angular-i18n/angular-locale_pt-br.js'
		])
		.pipe(uglify())
		.pipe(gulp.dest('./release/lib/angular-i18n'));
});

gulp.task('build-interblock-sistema-lib-angular-ui-calendar', function() {
	return gulp
		.src([
			'./src/lib/angular-ui-calendar/**/*.js'
		])
		.pipe(uglify())
		.pipe(gulp.dest('./release/lib/angular-ui-calendar'));
});

gulp.task('build-interblock-sistema-lib-ui-calendar', function() {
	return gulp
		.src([
			'./src/lib/ui-calendar/src/**/*.js'
		])
		.pipe(uglify())
		.pipe(gulp.dest('./release/lib/ui-calendar/src'));
});

gulp.task('build-interblock-sistema-lib-px-project', function() {
	return gulp
		.src([
			'./src/lib/px-project/dist/system/**/*.js'
		])
		.pipe(uglify())
		.pipe(gulp.dest('./release/lib/px-project/dist/system'));
});

gulp.task('build-interblock-sistema-lib-px-project-rest', function() {
	return gulp
		.src([
			'./src/lib/px-project/dist/rest/*.cfm'
		])
		.pipe(gulp.dest('./release/lib/px-project/dist/rest'));
});

gulp.task('build-interblock-sistema-lib-px-project-css', function() {
	return gulp
		.src([
			'./src/lib/px-project/dist/system/**/*.css'
		])
		.pipe(cssmin())
		.pipe(gulp.dest('./release/lib/px-project/dist/system'));
});

gulp.task('build-interblock-sistema-lib-px-project-others', function() {
	return gulp
		.src([
			'./src/lib/px-project/dist/system/**/*.html',
			'./src/lib/px-project/dist/system/**/*.woff',
			'./src/lib/px-project/dist/system/**/*.ttf',
			'./src/lib/px-project/dist/system/**/*.cfm',
			'./src/lib/px-project/dist/system/**/*.cfc',
			'./src/lib/px-project/dist/system/**/*.cfc',
			'./src/lib/px-project/dist/system/**/*.gif',
			'./src/lib/px-project/dist/system/**/*.png'
		])
		.pipe(gulp.dest('./release/lib/px-project/dist/system'));
});

gulp.task('build-interblock-sistema-lib-font-awesome-others', function() {
	return gulp
		.src([
			'./src/lib/font-awesome/**/*.ttf',
			'./src/lib/font-awesome/**/*.woff',
			'./src/lib/font-awesome/**/*.woff2'
		])
		.pipe(gulp.dest('./release/lib/font-awesome'));
});

gulp.task('build-interblock-sistema-lib-requirejs', function() {
	return gulp
		.src([
			'./src/lib/requirejs/**/*.js'
		])
		.pipe(uglify())
		.pipe(gulp.dest('./release/lib/requirejs'));
});

gulp.task('build-interblock-sistema-src-html', function() {
	return gulp
		.src([
			'./src/custom/**/*.html'
		])
		.pipe(gulp.dest('./release'));
});

gulp.task('build-interblock-sistema-src-js', function() {
	return gulp
		.src(['./src/custom/**/*.js'])
		//.pipe(uglify())
		.pipe(gulp.dest('./release'));
});

gulp.task('build-interblock-sistema-src-cf', function() {
	return gulp
		.src([
			'./src/custom/**/*.cfm',
			'./src/custom/**/*.cfc'
		])
		.pipe(gulp.dest('./release'));
});

gulp.task('build-interblock-sistema-src-css', function() {
	return gulp
		.src(['./src/custom/**/*.css'])
		.pipe(cssmin())
		.pipe(gulp.dest('./release'));
});

gulp.task('build-interblock-sistema-src-assets', function() {
	return gulp
		.src([
			'./src/custom/assets/**/*.svg',
			'./src/custom/assets/**/*.png'
		])
		.pipe(gulp.dest('./release/assets'));
});

gulp.task('build-interblock-sistema-root', function() {
	return gulp
		.src([
			'./src/*.html',
			'./src/*.cfc',
			'./src/*.cfm',
			'./src/*.ico'
		])
		.pipe(gulp.dest('./release'));
});

gulp.task('build-interblock-sistema-root-css', function() {
	return gulp
		.src([
			'./src/*.css',
		])
		.pipe(cssmin())
		.pipe(gulp.dest('./release'));
});

gulp.task('build-interblock-sistema-server', function() {
	return gulp
		.src([
			'./_server/*'
		])
		.pipe(gulp.dest('./release/_server'));
});

gulp.task('build-interblock-sistema-pdf-viewer', function() {
	return gulp
		.src([
			'./pdf-viewer/**/*'
		])
		.pipe(gulp.dest('./release/pdf-viewer'));
});

gulp.task('build-interblock-sistema-webservice', function() {
	return gulp
		.src([
			'./wsinterblock-sistema/**/*'
		])
		.pipe(gulp.dest('./release/wsinterblock-sistema'));
});

gulp.task('build-interblock-sistema-schedule', function() {
	return gulp
		.src([
			'./schedule/**/*'
		])
		.pipe(gulp.dest('./release/schedule'));
});


/*gulp.task('watch', function() {});*/
gulp.task('default', [
	'build-interblock-sistema'
]);


gulp.task('build-interblock-sistema', [
	'build-interblock-sistema-js',
	'build-interblock-sistema-lib-js',
	'build-interblock-sistema-lib-css',
	'build-interblock-sistema-bootstrap-css',
	'build-interblock-sistema-lib-angular-i18n',
	'build-interblock-sistema-lib-angular-ui-calendar',
	'build-interblock-sistema-lib-px-project',
	'build-interblock-sistema-lib-px-project-rest',
	'build-interblock-sistema-lib-px-project-css',
	'build-interblock-sistema-lib-px-project-others',
	'build-interblock-sistema-lib-font-awesome-others',
	'build-interblock-sistema-lib-requirejs',
	'build-interblock-sistema-lib-ui-calendar',
	'build-interblock-sistema-src-html',
	'build-interblock-sistema-src-js',
	'build-interblock-sistema-src-cf',
	'build-interblock-sistema-src-css',
	'build-interblock-sistema-src-assets',
	'build-interblock-sistema-server',
	'build-interblock-sistema-pdf-viewer',
	'build-interblock-sistema-webservice',
	'build-interblock-sistema-schedule',
	'build-interblock-sistema-root',
	'build-interblock-sistema-root-css',
]);