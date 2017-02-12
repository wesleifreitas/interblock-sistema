(function() {
    'use strict';

    angular.module('myApp').controller('PagamentoCtrl', PagamentoCtrl);

    PagamentoCtrl.$inject = ['config', 'pagamentoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function PagamentoCtrl(config, pagamentoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.moment = moment;
        vm.filter = {};
        vm.filter.months = moment.months();
        vm.getData = getData;
        //vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.pagamento = {
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
            vm.filter.ano = moment().year();
            vm.filter.mes = moment().month();
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.pagamento.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter.page = vm.pagamento.page;
            vm.filter.limit = vm.pagamento.limit;

            if (params.reset) {
                vm.pagamento.data = [];
            }

            vm.pagamento.promise = pagamentoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.pagamento.total = response.recordCount;
                    vm.pagamento.data = vm.pagamento.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        /*function create() {
            $state.go('pagamento-form');
        }*/

        function update(id) {
            $state.go('pagamento-form', { id: id });
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                pagamentoService.remove(vm.pagamento.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.pagamento.selected = [];
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