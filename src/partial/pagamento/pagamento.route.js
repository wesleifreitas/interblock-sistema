(function() {
    'use strict';

    angular
        .module('myApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('pagamento', getState());
    }

    function getState() {
        return {
            url: '/pagamento',
            templateUrl: 'partial/pagamento/pagamento.html',
            controller: 'PagamentoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                id: null,
                filter: {}
            },
        };
    }
})();