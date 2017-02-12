(function() {
    'use strict';

    angular
        .module('myApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('pagamento-form', getState());
    }

    function getState() {
        return {
            url: '/pagamento/:id',
            templateUrl: 'partial/pagamento/pagamento-form.html',
            controller: 'PagamentoFormCtrl',
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

    getData.$inject = ['$state', '$stateParams', 'pagamentoService'];

    function getData($state, $stateParams, pagamentoService) {
        console.info('$stateParams', $stateParams);

        if ($stateParams.id) {
            return pagamentoService.getById($stateParams.id).then(success, error);
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