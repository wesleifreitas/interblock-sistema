(function() {
    'use strict';

    const PROJECT_NAME = 'myApp';

    angular
        .module(PROJECT_NAME, [
            'ui.router',
            'ngCookies',
            'ngMaterial',
            'ngMessages',
            'ngSanitize',
            'ui.utils.masks',
            'ui.mask',
            'pxConfig',
            'px-data-grid',
            'md.data.table',
            'materialCalendar'
        ])
        .config(config)
        .run(run);

    angular.module(PROJECT_NAME).constant('config', {
        // RESTful - ColdFusion
        // Registrar REST: http://localhost:8500/interblock-sistema/backend/cf/restInit.cfm
        'REST_URL': window.location.origin + '/rest/interblock-sistema',

        // RESTful - Node.js        
        // Registrar REST: backend\node> node server.js
        //'REST_URL': 'http://localhost:8080/interblock-sistema',
    });

    config.$inject = ['$stateProvider', '$urlRouterProvider', '$mdThemingProvider', '$mdDateLocaleProvider'];

    function config($stateProvider, $urlRouterProvider, $mdThemingProvider, $mdDateLocaleProvider) {
        $urlRouterProvider.otherwise(function($injector) {
            var $state = $injector.get('$state');
            $state.go('login');
        });

        $mdThemingProvider.theme('default')
            .primaryPalette('light-blue')
            .accentPalette('blue-grey');

        moment.locale('pt-BR');

        // https://material.angularjs.org/latest/api/service/$mdDateLocaleProvider
        $mdDateLocaleProvider.months = ['janeiro',
            'fevereiro',
            'março',
            'abril',
            'maio',
            'junho',
            'julho',
            'agosto',
            'setembro',
            'outubro',
            'novembro',
            'dezembro'
        ];
        $mdDateLocaleProvider.shortMonths = ['jan.',
            'fev',
            'mar',
            'abr',
            'maio',
            'jun',
            'jul',
            'ago',
            'set',
            'out',
            'nov',
            'dez'
        ];
        $mdDateLocaleProvider.parseDate = function(dateString) {
            var m = moment(dateString, 'L', true);
            return m.isValid() ? m.toDate() : new Date(NaN);
        };
        $mdDateLocaleProvider.formatDate = function(date) {
            if (moment(date).format('L') === 'Invalid date') {
                return '';
            } else {
                return moment(date).format('L');
            }
        };
    }

    run.$inject = ['$rootScope', '$state', '$cookies', '$http'];

    function run($rootScope, $state, $cookies, $http) {

        // keep user logged in after page refresh
        $rootScope.globals = $cookies.getObject('globals') || {};
        if ($rootScope.globals.currentUser) {
            $http.defaults.headers.common['Authorization'] = 'Basic ' + $rootScope.globals.currentUser.authdata; // jshint ignore:line
        }

        $rootScope.$on('$stateChangeStart', function(event, toState, toParams) {
            if (toState.name === 'login' || toState.name === 'register') {
                return;
            } else {
                var loggedIn = $rootScope.globals.currentUser;
                if (!loggedIn) {
                    $state.go('login');
                    event.preventDefault();
                } else if (toState.name === 'home') {
                    // Redirecionar o primeiro state
                    $state.go('agenda');
                    event.preventDefault();
                }
            }
        });
    }
})();