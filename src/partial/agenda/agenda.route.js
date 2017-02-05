(function() {
    'use strict';

    angular
        .module('myApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('agenda', getState());
    }

    function getState() {
        return {
            url: '/agenda',
            templateUrl: 'partial/agenda/agenda.html',
            controller: 'AgendaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                date: new Date()
            },
            resolve: {
                agenda: agenda
            }
        };
    }

    agenda.$inject = ['$stateParams'];

    function agenda($stateParams) {
        return {};
    }
})();