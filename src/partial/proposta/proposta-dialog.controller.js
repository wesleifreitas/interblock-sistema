(function() {
    'use strict';

    angular.module('myApp').controller('PropostaDialogCtrl', PropostaDialogCtrl);

    PropostaDialogCtrl.$inject = ['config', 'pagamentoService', '$rootScope', '$scope', '$state', '$mdDialog',
        'dialogAction'
    ];

    function PropostaDialogCtrl(config, pagamentoService, $rootScope, $scope, $state, $mdDialog,
        dialogAction) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.filter.months = moment.months();
        vm.getData = getData;
        vm.proposta = {
            limit: 100,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.dialogAction = dialogAction;
        vm.quitar = quitar;
        vm.cancel = cancel;

        function init(event) {
            vm.filter.pag_data_vencimento_min_ano = moment().year();
            vm.filter.pag_data_vencimento_min_mes = moment().month();
            vm.filter.pag_data_vencimento_max_ano = moment().year();
            vm.filter.pag_data_vencimento_max_mes = moment().month();
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.proposta.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.proposta.page;
            vm.filter.limit = vm.proposta.limit;

            if (params.reset) {
                vm.proposta.data = [];
            }

            vm.proposta.promise = pagamentoService.getQuitacao(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.proposta.total = response.recordCount;
                    vm.proposta.data = vm.proposta.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function quitar(item) {
            console.info(item);
            vm.loading = true;

            pagamentoService.quitar(vm.filter, item)
                .then(function success(response) {
                    console.info('success', response);
                    $mdDialog.hide(item);
                }, function error(response) {
                    vm.loading = false;
                    console.error('error', response);
                });
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();