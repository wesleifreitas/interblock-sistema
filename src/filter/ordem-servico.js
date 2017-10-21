(function () {
    'use strict';

    angular.module('myApp').filter('osStatus', osStatus);

    osStatus.$inject = ['ORDEM_SERVICO'];
    /* @ngInject */
    function osStatus(ORDEM_SERVICO) {
        return function (value) {
            for (var i = 0; i <= ORDEM_SERVICO.STATUS.length - 1; i++) {
                if (ORDEM_SERVICO.STATUS[i].id === value) {
                    return ORDEM_SERVICO.STATUS[i].name;
                }
            }
            return '?';
        };
    }
})();