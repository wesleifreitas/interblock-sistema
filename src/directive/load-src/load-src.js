(function () {
    'use strict';

    angular.module('myApp').directive('loadSrc', loadSrc);

    loadSrc.$inject = ['$timeout'];

    function loadSrc($timeout) {
        var directive = {
            scope: {
                loadSrc: '=loadSrc',
                sleep: '@sleep'
            },
            link: link
        };
        return directive;

        function link(scope, element, attrs) {

            scope.sleep = scope.sleep || 0;

            scope.$watch('loadSrc', function (newValue, oldValue) {
                $timeout(function () {
                    attrs.$set('src', newValue);
                }, scope.sleep);
            });
        }
    }
})();