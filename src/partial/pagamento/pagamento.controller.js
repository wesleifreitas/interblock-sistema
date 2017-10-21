(function () {
    'use strict';

    angular.module('myApp').controller('PagamentoCtrl', PagamentoCtrl);

    PagamentoCtrl.$inject = ['config', 'pagamentoService', '$rootScope', '$scope', '$state', '$mdDialog',
        '$timeout', 'PAGAMENTO'
    ];

    function PagamentoCtrl(config, pagamentoService, $rootScope, $scope, $state, $mdDialog,
        $timeout, PAGAMENTO) {

        var vm = this;
        vm.init = init;
        vm.moment = moment;
        vm.status = PAGAMENTO.STATUS;
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
        vm.quitar = quitar;
        vm.showPdf = showPdf;

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function () {
            console.info('broadcastTest!');
            //getData();
        });

        function init() {
            var filterLast = JSON.parse(localStorage.getItem('filter')) || {};

            if (filterLast[$state.current.url.split('/')[1]]) {
                vm.filter = filterLast;
            } else {
                vm.filter = {};
                vm.filter[$state.current.url.split('/')[1]] = true;
                vm.filter.months = moment.months();
                vm.filter.ano = vm.filter.ano || moment().year();
                vm.filter.mes = vm.filter.mes || moment().month();
            }

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

            localStorage.setItem('filter', JSON.stringify(vm.filter));

            vm.pagamento.promise = pagamentoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.pagamento.total = response.recordCount;

                    for (var i = 0; i <= response.query.length - 1; i++) {
                        response.query[i].PAG_DATA_VENCIMENTO = new Date(response.query[i].PAG_DATA_VENCIMENTO);
                    }

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

            $mdDialog.show(confirm).then(function () {
                pagamentoService.remove(vm.pagamento.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.pagamento.selected = [];
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function () {
                // cancel
            });
        }

        function quitar() {
            $timeout(function () {
                $mdDialog.show({
                    locals: { dialogAction: 'quitar' },
                    preserveScope: true,
                    controller: 'PropostaDialogCtrl',
                    controllerAs: 'vm',
                    templateUrl: 'partial/proposta/proposta-dialog.html',
                    parent: angular.element(document.body),
                    //targetEvent: event,
                    clickOutsideToClose: true
                }).then(function (data) {
                    //console.info(data);
                    getData({ reset: true });
                });
            }, 300);
        }

        function showPdf(item) {
            $mdDialog.show({
                locals: { pag_id: item.PAG_ID },
                preserveScope: true,
                controller: 'BoletoDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'partial/boleto/boleto-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function (data) {
                //console.info(data);
            });
        }
    }
})();