(function() {
    'use strict';

    angular.module('myApp').controller('GasClienteCtrl', GasClienteCtrl);

    GasClienteCtrl.$inject = ['config', 'gasClienteService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function GasClienteCtrl(config, gasClienteService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.filter = JSON.parse(localStorage.getItem('filter')) || {};
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.gasCliente = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function init() {
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.gasCliente.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.gasCliente.page;
            vm.filter.limit = vm.gasCliente.limit;

            if (params.reset) {
                vm.gasCliente.data = [];
            }

            localStorage.setItem('filter', JSON.stringify(vm.filter));
            vm.gasCliente.promise = gasClienteService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.gasCliente.total = response.recordCount;
                    vm.gasCliente.data = vm.gasCliente.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('gasCliente-form');
        }

        function update(id) {
            $state.go('gasCliente-form', { id: id });
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                gasClienteService.remove(vm.gasCliente.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.gasCliente.selected = [];
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }
    }
})();