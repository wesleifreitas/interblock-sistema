(function () {
    'use strict';

    angular.module('myApp').controller('OrdemServicoFormCtrl', OrdemServicoFormCtrl);

    OrdemServicoFormCtrl.$inject = ['$scope', '$state', '$stateParams', '$mdDialog', '$filter', 'ordemServicoService',
        'getData', 'ORDEM_SERVICO'];

    function OrdemServicoFormCtrl($scope, $state, $stateParams, $mdDialog, $filter, ordemServicoService,
        getData, ORDEM_SERVICO) {

        var vm = this;
        vm.init = init;
        vm.ordemServico = {};
        vm.status = ORDEM_SERVICO.STATUS;
        vm.usuarioDialog = usuarioDialog;
        vm.clienteDialog = clienteDialog;
        vm.veiculoDialog = veiculoDialog;
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.ordemServico = vm.getData;

                console.info(vm.getData);

                vm.ordemServico.tecnico = {
                    ID: vm.getData.OS_TECNICO,
                    NOME: vm.getData.TECNICO_NOME
                };
                vm.ordemServico.cliente = {
                    CLI_ID: vm.getData.CLI_ID,
                    CLI_NOME: vm.getData.CLI_NOME
                };
                vm.ordemServico.veiculo = {
                    VEI_ID: vm.getData.VEI_ID,
                    VEI_INFO: vm.getData.VEI_INFO
                };
            } else {
                vm.action = 'create';

                //default
                vm.ordemServico.OS_NUMERO = 'Automático';
                vm.ordemServico.os_tel1 = '';
                vm.ordemServico.os_tel2 = '';
                vm.ordemServico.os_tel3 = '';
                vm.ordemServico.os_tel4 = '';
                vm.ordemServico.OS_STATUS = vm.status[0].id;
                vm.ordemServico.OS_OBJETIVO = '';
            }
        }

        function usuarioDialog(event) {
            $mdDialog.show({
                locals: {},
                preserveScope: true,
                controller: 'UsuarioDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'partial/usuario/usuario-dialog.html',
                parent: angular.element(document.body),
                targetEvent: event,
                clickOutsideToClose: true
            }).then(function (data) {

                vm.ordemServico.tecnico = {
                    ID: data.USU_ID,
                    NOME: data.USU_NOME
                };
            });
        }

        function clienteDialog(event) {
            $mdDialog.show({
                locals: {},
                preserveScope: true,
                controller: 'ClienteDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'partial/cliente/cliente-dialog.html',
                parent: angular.element(document.body),
                targetEvent: event,
                clickOutsideToClose: true
            }).then(function (data) {
                if (vm.ordemServico.cliente && data.CLI_ID !== vm.ordemServico.cliente.CLI_ID) {
                    vm.ordemServico.veiculo = {};
                }

                vm.ordemServico.cliente = {
                    CLI_ID: data.CLI_ID,
                    CLI_NOME: data.CLI_NOME
                };

                vm.ordemServico.OS_CEP = $filter('padLeft')(data.CLI_CEP, '00000000');
                vm.ordemServico.OS_ENDERECO = data.CLI_ENDERECO;
                vm.ordemServico.OS_NUMERO_ENDERECO = data.CLI_NUMERO;
                vm.ordemServico.OS_COMPLEMENTO = data.CLI_COMPLEMENTO;
                vm.ordemServico.OS_BAIRRO = data.CLI_BAIRRO;
                vm.ordemServico.OS_CIDADE = data.CLI_CIDADE;
                vm.ordemServico.OS_UF = data.CLI_UF;
                console.info(data);
                if (String(data.CLI_TEL1).length > 9) {
                    vm.ordemServico.OS_TEL1 = String(data.CLI_TEL1);
                } else {
                    vm.ordemServico.OS_TEL1 = '';
                }
                if (String(data.CLI_TEL2).length > 9) {
                    vm.ordemServico.OS_TEL2 = String(data.CLI_TEL2);
                } else {
                    vm.ordemServico.OS_TEL2 = '';
                }
                if (String(data.CLI_TEL3).length > 9) {
                    vm.ordemServico.OS_TEL3 = String(data.CLI_TEL3);
                } else {
                    vm.ordemServico.OS_TEL3 = '';
                }
                if (String(data.CLI_TEL4).length > 9) {
                    vm.ordemServico.OS_TEL4 = String(data.CLI_TEL4);
                } else {
                    vm.ordemServico.OS_TEL4 = '';
                }
            });
        }

        function veiculoDialog(event) {
            $mdDialog.show({
                locals: { cliente: vm.ordemServico.cliente },
                preserveScope: true,
                controller: 'VeiculoDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'partial/veiculo/veiculo-dialog.html',
                parent: angular.element(document.body),
                targetEvent: event,
                clickOutsideToClose: true
            }).then(function (data) {
                vm.ordemServico.veiculo = {
                    VEI_ID: data.VEI_ID,
                    VEI_INFO: data.VEI_INFO
                };
            });
        }

        function removeById(event) {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover este registro?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function () {
                ordemServicoService.removeById($stateParams.id)
                    .then(function success(response) {
                        if (response.success) {
                            console.info('success', response);
                            $state.go('ordem-servico');
                        } else {
                            console.warn('warn', response);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function () {
                // cancel
            });
        }

        function cancel() {
            $state.go('ordem-servico');
        }

        function save() {

            if ($stateParams.id) {
                //update
                ordemServicoService.update($stateParams.id, vm.ordemServico)
                    .then(function success(response) {
                        if (response.success) {
                            console.info('success', response);
                            $state.go('ordem-servico');
                        } else {
                            console.warn('warn', response);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                ordemServicoService.create(vm.ordemServico)
                    .then(function success(response) {
                        if (response.success) {
                            console.info('success', response);
                            $state.go('ordem-servico');
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