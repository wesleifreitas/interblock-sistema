(function() {
    'use strict';

    angular.module('myApp').controller('PagamentoFormCtrl', PagamentoFormCtrl);

    PagamentoFormCtrl.$inject = ['$scope', '$state', '$stateParams', '$mdDialog', 'pagamentoService',
        'getData', 'EXAMPLE'
    ];

    function PagamentoFormCtrl($scope, $state, $stateParams, $mdDialog, pagamentoService,
        getData, EXAMPLE) {

        var vm = this;
        vm.init = init;
        vm.pagamento = {};
        vm.uf = EXAMPLE.UF;
        vm.getData = getData;
        //vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.pagamento = {
                    nome: vm.getData.CLI_NOME,
                    cpf: String(vm.getData.CLI_CPFCNPJ),
                    contrato: vm.getData.PROP_NUMERO,
                    arquivo: vm.getData.CLI_ARQUIVO
                };
            } else {
                vm.action = 'create';
            }
        }

        /*function removeById(event) {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover este registro?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                pagamentoService.removeById($stateParams.id)
                    .then(function success(response) {
                        if (response.success) {
                            console.info('success', response);
                            $state.go('pagamento');
                        } else {
                            console.warn('warn', response);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }*/

        function cancel() {
            $state.go('pagamento');
        }

        function save() {

            if ($stateParams.id) {
                //update
                pagamentoService.update($stateParams.id, vm.pagamento)
                    .then(function success(response) {
                        if (response.success) {
                            console.info('success', response);
                            $state.go('pagamento');
                        } else {
                            console.warn('warn', response);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                pagamentoService.create(vm.pagamento)
                    .then(function success(response) {
                        if (response.success) {
                            console.info('success', response);
                            $state.go('pagamento');
                        } else {
                            console.warn('warn', response);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();