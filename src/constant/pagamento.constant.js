(function() {
    'use strict';

    angular.module('myApp').constant('PAGAMENTO', {
        STATUS: [{
            id: 0,
            name: 'Aberto',
            class: 'aberto'
        }, {
            id: 1,
            name: 'Pago (Banco)',
            class: 'pago'
        }, {
            id: 2,
            name: 'Pago (Caixa)',
            class: 'pago'
        }, {
            id: 3,
            name: 'Pago (Depósito)',
            class: 'pago'
        }, {
            id: 4,
            name: 'Pago (Tranferência)',
            class: 'pago'
        }]
    });
})();