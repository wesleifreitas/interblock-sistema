(function () {
    'use strict';

    angular.module('myApp').controller('VeiculoDialogCtrl', VeiculoDialogCtrl);

    VeiculoDialogCtrl.$inject = ['config', 'veiculoService', '$rootScope', '$scope', '$state', '$mdDialog', 'locals'];

    function VeiculoDialogCtrl(config, veiculoService, $rootScope, $scope, $state, $mdDialog, locals) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.getData = getData;
        vm.veiculo = {
            limit: 5,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.itemClick = itemClick;
        vm.cancel = cancel;

        function init(event) {

            console.info('locals', locals);

            if (locals.cliente) {
                vm.filter.CLI_ID = locals.cliente.CLI_ID;
            }

            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.veiculo.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter.page = vm.veiculo.page;
            vm.filter.limit = vm.veiculo.limit;

            if (params.reset) {
                vm.veiculo.data = [];
            }

            vm.veiculo.promise = veiculoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.veiculo.total = response.recordCount;
                    vm.veiculo.data = vm.veiculo.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function itemClick(item) {
            $mdDialog.hide(item);
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();