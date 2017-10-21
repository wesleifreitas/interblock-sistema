(function () {
    'use strict';

    angular.module('myApp').controller('OrdemServicoCtrl', OrdemServicoCtrl);

    OrdemServicoCtrl.$inject = ['config', 'ordemServicoService', '$rootScope', '$scope', '$state', '$mdDialog',
        'ORDEM_SERVICO'];

    function OrdemServicoCtrl(config, ordemServicoService, $rootScope, $scope, $state, $mdDialog,
        ORDEM_SERVICO) {

        var vm = this;
        vm.init = init;
        vm.status = ORDEM_SERVICO.STATUS;
        vm.getData = getData;
        vm.showPdf = showPdf;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.ordemServico = {
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
            }

            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.ordemServico.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter.page = vm.ordemServico.page;
            vm.filter.limit = vm.ordemServico.limit;

            if (params.reset) {
                vm.ordemServico.data = [];
            }

            localStorage.setItem('filter', JSON.stringify(vm.filter));
            vm.ordemServico.promise = ordemServicoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);

                    for (var i = 0; i < response.query.length; i++) {
                        response.query[i].OS_DATA = new Date(response.query[i].OS_DATA);
                    }

                    vm.ordemServico.total = response.recordCount;
                    vm.ordemServico.data = vm.ordemServico.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function showPdf(item) {
            $mdDialog.show({
                locals: { os_id: item.OS_ID },
                preserveScope: true,
                controller: 'OrdemServicoDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'partial/ordem-servico/ordem-servico-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: false
            }).then(function (data) {
                //console.info(data);
            });
        }

        function create() {
            $state.go('ordem-servico-form');
        }

        function update(id) {
            $state.go('ordem-servico-form', { id: id });
        }

        function remove(event) {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function () {
                ordemServicoService.remove(vm.ordemServico.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.ordemServico.selected = [];
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function () {
                // cancel
            });
        }
    }
})();