(function () {
    'use strict';

    angular
        .module('myApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('ordem-servico', getState());
    }

    function getState() {
        return {
            url: '/ordem-servico',
            templateUrl: 'partial/ordem-servico/ordem-servico.html',
            controller: 'OrdemServicoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();