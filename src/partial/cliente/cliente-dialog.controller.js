(function () {
    'use strict';

    angular.module('myApp').controller('ClienteDialogCtrl', ClienteDialogCtrl);

    ClienteDialogCtrl.$inject = ['config', 'clienteService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ClienteDialogCtrl(config, clienteService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.cliente = {
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
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.cliente.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.cliente.page;
            vm.filter.limit = vm.cliente.limit;

            if (params.reset) {
                vm.cliente.data = [];
            }

            vm.cliente.promise = clienteService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.cliente.total = response.recordCount;
                    vm.cliente.data = vm.cliente.data.concat(response.query);
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