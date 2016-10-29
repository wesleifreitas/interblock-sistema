define(['../controllers/module'], function(controllers) {
    'use strict';

    // Controller
    controllers.controller('PagamentoCtrl', PagamentoCtrl);

    PagamentoCtrl.$inject = ['pagamentoService', 'pxConfig', '$scope', '$element', '$attrs', '$mdDialog', 'pxDateUtil'];

    function PagamentoCtrl(pagamentoService, pxConfig, $scope, $element, $attrs, $mdDialog, pxDateUtil) {
        /**
         * Variável de controle de visualição do Filtro Avançado
         * @type {Boolean}
         */
        $scope.expand = false;
        /**
         * Realizar o efeito de expandir o Filtro Avançado
         * @return {Void}
         */
        $scope.showFilter = function() {
            var $header = $('#headerSearch');
            var $content = $header.next();
            $content.slideToggle(500, function() {});
            $scope.filterExpand = !$scope.filterExpand;
            $header.blur();
        };

        // Definir as opções de status
        $scope.dataStatus = {
            // Array: opções do select com opção 'Todos'
            optionsAll: pagamentoService.status(true),
            // Array: opções do select sem opção 'Todos'
            options: pagamentoService.status(false),
        };

        // Default de options para o filtro filtroStatus
        $scope.filtroStatus = $scope.dataStatus.optionsAll[1];

        // Definir as opções de meses
        $scope.dataMonths = {
            // Array: opções do select com opção 'Todos'
            optionsAll: pxDateUtil.months(true),
            // Array: opções do select sem opção 'Todos'
            options: pxDateUtil.months(false),
        };

        var now = moment();

        console.info()
            // Default de options para o filtro filtroStatus
        $scope.filtroVencimentoMes = $scope.dataMonths.optionsAll[parseInt(now.format('M'))];
        $scope.filtroVencimentoAno = now.format('YYYY');

        /**
         * Controle da listagem
         * Note que a propriedade 'control' da directive px-data-grid é igual a 'dgPagamento'
         * Exemplo: <px-data-grid px-control='dgPagamento'>
         * @type {Object}
         */
        $scope.dgPagamentoControl = {};

        /**
         * Configurações da listagem
         * - fields: Colunas da listagem
         * @type {Object}
         */
        $scope.dgPagamentoConfig = {
            schema: 'dbo',
            table: 'pagamento',
            view: 'vw_pagamento',
            orderBy: [{
                field: 'pag_data_vencimento',
                sort: 'asc'
            }],
            group: false,
            fields: [{
                pk: true,
                visible: false,
                title: 'id',
                field: 'pag_id',
                type: 'int'
            }, {
                visible: false,
                title: 'pag_data_vencimento_mes',
                field: 'pag_data_vencimento_mes',
                type: 'int',
                filter: 'filtroVencimentoMes',
                filterOperator: '=',
                filterOptions: {
                    field: 'pag_data_vencimento_mes',
                    selectedItem: 'id'
                }
            }, {
                visible: false,
                title: 'pag_data_vencimento_ano',
                field: 'pag_data_vencimento_ano',
                type: 'int',
                filter: 'filtroVencimentoAno',
                filterOperator: '='
            }, {
                title: 'Status',
                field: 'pag_status_label',
                type: 'bit',
                filter: 'filtroStatus',
                filterOperator: '=',
                filterOptions: {
                    field: 'pag_status',
                    selectedItem: 'id'
                }
            }, {
                title: 'Vencimento',
                field: 'pag_data_vencimento',
                type: 'date',
                moment: 'DD/MM/YYYY'
            }, {
                title: 'Cliente',
                field: 'cli_nome',
                type: 'string',
                filter: 'filtroCliente',
                filterOperator: '%LIKE%'
            }, {
                title: 'CPF',
                field: 'cli_cpfCnpj',
                type: 'int',
                stringMask: '###.###.###-##',
                filter: 'filtroCPF',
                filterOperator: '='
            }, {
                title: 'Proposta / Contrato',
                field: 'prop_numero',
                type: 'string',
                filter: 'filtroContrato',
                filterOperator: '='
            }, {
                title: 'Arquivo',
                field: 'cli_arquivo',
                type: 'string',
                filter: 'filtroArquivo',
                filterOperator: '='
            }, {
                title: 'Valor',
                field: 'pag_valor',
                type: 'decimal',
                numeral: '0,0.00'
            }, {
                title: 'Valor pago',
                field: 'pag_valor_pago',
                type: 'decimal',
                numeral: '0,0.00'
            }],
        };

        /**
         * Evento após listagem inicializar
         * @return {Void}
         */
        $scope.dgPagamentoInit = function() {

        };

        /**
         * Atualizar dados da listagem
         * @return {Void}
         */
        $scope.getData = function() {
            //Recuperar dados para a listagem
            $scope.dgPagamentoControl.getData();
        };

        /**
         * Remover itens da listagem
         * @return {Void}
         */
        $scope.remove = function() {
            // Remover itens (selecionados) da listagem
            $scope.dgPagamentoControl.remove();
        };

        // Listagem - End     

        $scope.formShow = 'default';
        // Inicializar título do formulário      
        $scope.formTitle = 'Formulário de Adicionar';
        /**
         * Alterar título do formulário
         */
        $scope.setFormTitle = function() {

            if ($scope.formShow === 'default') {
                if ($scope.formAction === 'insert') {
                    $scope.formTitle = 'Formulário de Adicionar';
                } else {
                    $scope.formTitle = 'Formulário de Pagamento';
                }
            } else if ($scope.formShow === 'exemplo2') {
                $scope.formTitle = 'Selecione uma categoria';
            }
        }


        formCtrl.$inject = ['$scope', '$mdDialog'];
        $scope.add = function(event) {
            $scope.formAction = 'insert';
            $scope.setFormTitle();

            $mdDialog.show({
                scope: $scope,
                preserveScope: true,
                controller: formCtrl,
                templateUrl: 'custom/pagamento/pagamento-form.html',
                parent: angular.element(document.body),
                targetEvent: event,
                clickOutsideToClose: false
            });
        };

        $scope.edit = function(event) {
            $scope.formAction = 'update';
            $scope.formItemEdit = event.itemEdit;
            $scope.setFormTitle();

            $mdDialog.show({
                scope: $scope,
                preserveScope: true,
                controller: formCtrl,
                templateUrl: 'custom/pagamento/pagamento-form.html',
                parent: angular.element(document.body),
                targetEvent: event,
                clickOutsideToClose: false
            });
        };
    }
    // Controller - filtro_exe2_id
    function filtro_exe2_id_ctrl($scope, $mdDialog) {
        $scope.callback = function(event) {
            $scope.filtro_exe2_id_searchControl.setValue(event.itemClick);
            $mdDialog.hide();
        };
    }
    // Controller - Formulário
    function formCtrl($scope, $mdDialog) {
        /**
         * Controle do formulário
         * Note que a propriedade 'control' da directive px-form é igual a 'formControl'
         * Exemplo: <px-form px-control='formControl'>
         * @type {Object}
         */
        $scope.formControl = {};

        // Controle do campo exe2_id
        $scope.exe2_id_searchControl = {};
        // Clicar no botão busca
        $scope.exe2_id_searchClick = function() {
            $scope.formShow = 'exemplo2';
            $scope.setFormTitle();
        };

        /**
         * Inicializa formulário
         * @return {Void}
         */
        $scope.formInit = function() {
            // Definir formulário default
            $scope.formShow = 'default';

            // Limpar formuário
            $scope.formControl.clean();

            // Configurar formulário
            $scope.formConfig = {
                schema: 'dbo',
                table: 'exemplo',
                view: 'vw_exemplo',
                fields: [{
                    pk: true,
                    field: 'exe_id',
                    type: 'string',
                    identity: true
                }, {
                    field: 'exe_checkbox',
                    type: 'bit',
                    element: 'exe_checkbox'
                }, {
                    field: 'exe_checkbox_char',
                    type: 'string',
                    element: 'exe_checkbox_char',
                    fieldValueOptions: {
                        checked: 'A',
                        unchecked: 'B'
                    }
                }, {
                    field: 'exe_nome',
                    type: 'string',
                    element: 'exe_nome',
                }, {
                    field: 'exe_cpf',
                    type: 'string',
                    element: 'exe_cpf'
                }, {
                    field: 'exe_telefone',
                    type: 'string',
                    element: 'exe_telefone'
                }, {
                    field: 'exe_cep',
                    type: 'string',
                    element: 'exe_cep'
                }, {
                    field: 'exe2_id',
                    type: 'string',
                    element: 'exe2_id',
                    fieldValueOptions: {
                        selectedItem: 'exe2_id',
                        labelField: 'exe2_categoria'
                    },
                }, {
                    field: 'exe_senha',
                    type: 'string',
                    element: 'exe_senha',
                    hash: true
                }, {
                    field: 'exe_senha_confirmar',
                    type: 'string',
                    element: 'exe_senha_confirmar',
                    select: false,
                    insert: false,
                    update: false
                }]
            }

            if ($scope.formAction == 'update') {
                $scope.formControl.select($scope.formItemEdit);
            }
        };

        /**
         * Inserir registro
         * @return {[type]} [description]
         */
        $scope.formInsert = function() {
            $scope.formControl.insert();
        };

        /**
         * Atualizar
         * @return {[type]} [description]
         */
        $scope.formUpdate = function(form) {
            $scope.formControl.update();
        };

        /**
         * Função callback do formulário
         * @param  {Object} event retorno do formulário
         * @return {Void}
         */
        $scope.formCallback = function(event) {
            if (event.action === 'select') {
                $scope.exe_senha_confirmar = event.qQuery[0].EXE_SENHA;
            } else if (event.action == 'insert' && !event.error) {
                // Adicionar registro na listagem
                $scope.dgPagamentoControl.addDataRow(event.data);
                $mdDialog.hide();
            } else if (event.action == 'update' && !event.error) {
                // Atualizar registro na listagem
                $scope.dgPagamentoControl.updateDataRow(event.data);
                $mdDialog.hide();
            }
        };

        /**
         * Fechar formulário
         * @return {Void}
         */
        $scope.formCancel = function() {
            if ($scope.formShow === 'default') {
                $mdDialog.cancel();
            } else {
                $scope.formShow = 'default';
            }
        };

        /**
         * Limpar formulário
         * @return {Void}
         */
        $scope.formClean = function() {
            // Limpar formuário
            $scope.formControl.clean();
        };

        // Controle da listagem no formulário
        $scope.dgPagamento2Control = {};

        /**
         * Inicializar listagem
         * @return {Void}
         */
        $scope.dgPagamento2Init = function() {
            /**
             * Configurações da listagem
             * - fields: Colunas da listagem
             * @type {Object}
             */
            $scope.dgPagamento2Config = {
                schema: 'dbo',
                table: 'exemplo2',
                group: false,
                fields: [{
                    pk: true,
                    title: 'id',
                    field: 'exe2_id',
                    type: 'int'
                }, {
                    title: 'Categoria',
                    field: 'exe2_categoria',
                    type: 'string',
                    filter: 'filtroCategoria',
                    filterOperator: '%LIKE%'
                }, {
                    title: 'Descrição',
                    field: 'exe2_descricao',
                    type: 'string'
                }],
            };
        };

        // Atualizar listagem do formulário
        $scope.getDataExemplo2 = function() {
            //Recuperar dados para a listagem
            $scope.dgPagamento2Control.getData();
        };

        // Evento itemClick
        $scope.dgPagamento2ItemClick = function(event) {
            $scope.formShow = 'default';
            $scope.exe2_id_searchControl.setValue(event.itemClick);
            $scope.setFormTitle();
        };
    }
});