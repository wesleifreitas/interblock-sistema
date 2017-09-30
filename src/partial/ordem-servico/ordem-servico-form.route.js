(function () {
    'use strict';

    angular
        .module('myApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('ordem-servico-form', getState());
    }

    function getState() {
        return {
            url: '/ordem-servico/:id',
            templateUrl: 'partial/ordem-servico/ordem-servico-form.html',
            controller: 'OrdemServicoFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'ordemServicoService'];

    function getData($state, $stateParams, ordemServicoService) {
        console.info('$stateParams', $stateParams);

        if ($stateParams.id) {
            return ordemServicoService.getById($stateParams.id).then(success, error);
        } else {
            return {};
        }

        function success(response) {
            console.info(response);
            if (response.query.length === 0) {
                $state.go('404');
            } else {
                return response.query[0];
            }
        }

        function error(response) {
            return response;
        }
    }
})();