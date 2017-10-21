(function () {
    'use strict';

    angular.module('myApp').constant('ORDEM_SERVICO', {
        STATUS: [{
            id: 0,
            name: 'Aberta'
        }, {
            id: 1,
            name: 'Em execução'
        }, {
            id: 2,
            name: 'Finalizada'
        }, {
            id: 9,
            name: 'Cancelada'
        }]
    });
})();