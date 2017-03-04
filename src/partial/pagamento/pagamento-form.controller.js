(function() {
    'use strict';

    angular.module('myApp').controller('PagamentoFormCtrl', PagamentoFormCtrl);

    PagamentoFormCtrl.$inject = ['$scope', '$state', '$stateParams', '$mdDialog', 'pagamentoService',
        'getData', 'PAGAMENTO'
    ];

    function PagamentoFormCtrl($scope, $state, $stateParams, $mdDialog, pagamentoService,
        getData, PAGAMENTO) {

        var vm = this;
        vm.init = init;
        vm.pagamento = {};
        vm.status = PAGAMENTO.STATUS;
        vm.getData = getData;
        //vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.statusChange = statusChange;
        vm.dataPagoChange = dataPagoChange;
        vm.valorPagoChange = valorPagoChange;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.CLI_CPFCNPJ = String(vm.getData.CLI_CPFCNPJ);
                vm.getData.PAG_DATA_VENCIMENTO = new Date(vm.getData.PAG_DATA_VENCIMENTO);

                vm.getData.PAG_DATA_PAGO = (vm.getData.PAG_DATA_PAGO) ? new Date(vm.getData.PAG_DATA_PAGO) : null;
                vm.pagamento = vm.getData;
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

        function statusChange() {
            if (vm.pagamento.PAG_STATUS === 0) {
                vm.pagamento.PAG_DATA_PAGO = null;
                vm.pagamento.PAG_VALOR_JUROS = '0';
                vm.pagamento.PAG_VALOR_PAGO = '0';
                vm.pagamento.PAG_VALOR_PENDENTE = '0';
            } else if (!vm.getData.PAG_DATA_PAGO) {
                vm.getData.PAG_DATA_PAGO = new Date();
                dataPagoChange();
            }
        }

        function dataPagoChange() {

            // Data de pagamento válido?
            if (angular.isDate(vm.pagamento.PAG_DATA_PAGO)) {
                // Data de pagameto apés da de vencimento?
                if (moment(vm.pagamento.PAG_DATA_PAGO).isAfter(vm.pagamento.PAG_DATA_VENCIMENTO, 'day')) {
                    var diasATraso = moment(vm.pagamento.PAG_DATA_PAGO).diff(vm.pagamento.PAG_DATA_VENCIMENTO, 'days');

                    // juros = c*i*t (1% ao mês)
                    // t= dias de atraso (ex.:10 dias = 10/30 
                    // j = 9 * 0.01 * 10/30 = 0,66 
                    var valorJuros = vm.pagamento.PAG_VALOR * 0.01 * diasATraso / 30;
                    console.info('valorJuros', valorJuros);

                    // 2%
                    var multa = vm.pagamento.PAG_VALOR * 0.02;

                    vm.pagamento.PAG_VALOR_JUROS = vm.pagamento.PAG_VALOR + valorJuros + multa;
                } else {
                    vm.pagamento.PAG_VALOR_JUROS = vm.pagamento.PAG_VALOR;
                }
            }
        }

        function valorPagoChange() {
            if (angular.isNumber(vm.pagamento.PAG_VALOR_PAGO) && angular.isNumber(vm.pagamento.PAG_VALOR_JUROS)) {
                vm.pagamento.PAG_VALOR_PENDENTE = vm.pagamento.PAG_VALOR_JUROS - vm.pagamento.PAG_VALOR_PAGO;
            }
        }
    }
})();