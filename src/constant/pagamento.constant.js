(function() {
    'use strict';

    angular.module('myApp').constant('PAGAMENTO', {
        STATUS: [{
            id: 0,
            name: 'Aberto'
        }, {
            id: 1,
            name: 'Pago (Banco)'
        }, {
            id: 2,
            name: 'Pago (Caixa)'
        }, {
            id: 3,
            name: 'Pago (Depósito)'
        }, {
            id: 4,
            name: 'Pago (Tranferência)'
        }]
    });
})();