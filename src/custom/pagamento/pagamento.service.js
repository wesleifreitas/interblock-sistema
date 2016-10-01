define(['../services/module'], function (services) {
    'use strict';

    services.factory('pagamentoService', pagamentoService);

    pagamentoService.$inject = ['pxConfig', 'pxArrayUtil'];

    function pagamentoService(pxConfig, pxArrayUtil) {

        var service = {};

        service.status = status;

        return service;

        /**
         * Status do pagamento
         * @param  {Boolean} showAll habilitar opção todos?
         * @return {Array}           opções de status
         */
        function status(showAll) {

            var arrayData = [];

            if (showAll) {
                arrayData = [{
                    name: 'Todos',
                    id: '%'
                }, {
                    name: 'Aberto',
                    id: 0
                }, {
                    name: 'Pago',
                    id: 1
                }];
            } else {
                arrayData = [{
                    name: 'Aberto',
                    id: 0
                }, {
                    name: 'Pago',
                    id: 1
                }];
            }

            return arrayData.sort(pxArrayUtil.sortOn('id'));
        }
    }
});
