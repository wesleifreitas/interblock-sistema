(function() {
    'use strict';

    angular.module('myApp').filter('pagamentoStatus', pagamentoStatus);

    pagamentoStatus.$inject = ['PAGAMENTO'];
    /* @ngInject */
    function pagamentoStatus(PAGAMENTO) {
        return function(value) {
            for (var i = 0; i <= PAGAMENTO.STATUS.length - 1; i++) {
                if (PAGAMENTO.STATUS[i].id === value) {
                    return PAGAMENTO.STATUS[i].name;
                }
            }
            return '?';
        };
    }
})();