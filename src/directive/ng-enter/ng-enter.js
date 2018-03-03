(function () {
    'use strict';

    angular.module('myApp').directive('ngEnter', ngEnter);

    ngEnter.$inject = [];

    function ngEnter() {
        var directive = {
            link: link
        };
        return directive;

        function link(scope, element, attrs) {
            element.bind('keydown keypress', function (event) {
                if (event.which === 13) {
                    scope.$apply(function () {
                        scope.$eval(attrs.ngEnter);
                    });

                    event.preventDefault();
                }
            });
        }
    }
})();