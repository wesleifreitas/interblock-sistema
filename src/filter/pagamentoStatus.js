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

    angular.module('myApp').filter('pagamentoStatusClass', pagamentoStatusClass);

    pagamentoStatusClass.$inject = ['PAGAMENTO'];
    /* @ngInject */
    function pagamentoStatusClass(PAGAMENTO) {
        return function(value) {
            for (var i = 0; i <= PAGAMENTO.STATUS.length - 1; i++) {
                if (PAGAMENTO.STATUS[i].id === value) {
                    return PAGAMENTO.STATUS[i].class;
                }
            }
            return '?';
        };
    }
})();