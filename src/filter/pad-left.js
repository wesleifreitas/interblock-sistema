(function () {
    'use strict';

    angular.module('myApp').filter('padLeft', padLeft);

    padLeft.$inject = [];

    function padLeft() {
        return function (value, pad) {
            return (pad + value).slice(-pad.length);
        };
    }
})();