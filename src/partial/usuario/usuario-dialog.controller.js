(function () {
    'use strict';

    angular.module('myApp').controller('UsuarioDialogCtrl', UsuarioDialogCtrl);

    UsuarioDialogCtrl.$inject = ['config', 'usuarioService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function UsuarioDialogCtrl(config, usuarioService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.usuario = {
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
            vm.usuario.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.usuario.page;
            vm.filter.limit = vm.usuario.limit;

            if (params.reset) {
                vm.usuario.data = [];
            }

            vm.usuario.promise = usuarioService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.usuario.total = response.recordCount;
                    vm.usuario.data = vm.usuario.data.concat(response.query);
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