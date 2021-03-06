(function() {
    'use strict';

    const PROJECT_NAME = 'myApp';

    angular
        .module(PROJECT_NAME, [
            'ui.router',
            'ngCookies',
            'ngMaterial',
            'ngMessages',
            'ui.utils.masks',
            'ui.mask',
            'idf.br-filters',
            'ng-currency',
            'md.data.table',
            'fixed.table.header',
            'angular-loading-bar',
            'ngMaterialSidemenu'
        ])
        .config(config)
        .run(run);

    angular
        .module(PROJECT_NAME)
        .factory('httpRequestInterceptor', function() {
            return {
                request: function(config) {
                    if (String(config.url).indexOf('interblock-sistema') > -1) {
                        config.headers['Authorization'] = '';
                        config.headers['Accept'] = 'application/json;odata=verbose';
                    } else {
                        delete config.headers['Authorization'];
                    }
                    return config;
                }
            };
        });

    var localUrl = 'http://localhost:8500';
    if (window.location.hostname !== 'localhost' && window.location.hostname !== 'http://127.0.0.1') {
        localUrl = window.location.origin;
    }

    // RESTful - Node.js
    // Registrar REST:
    // $ cd backend/node
    // $ node server.js

    // RESTful - ColdFusion
    // Registrar REST: http://localhost:8500/interblock-sistema/backend/cf/rest-init.cfm
    angular.module(PROJECT_NAME).constant('config', {
        PROJECT_ID: 0,
        'REST_URL': localUrl + '/rest/interblock-sistema',
    });

    config.$inject = ['$stateProvider', '$urlRouterProvider', '$mdThemingProvider', '$mdDateLocaleProvider',
        'cfpLoadingBarProvider', '$httpProvider'
    ];

    function config($stateProvider, $urlRouterProvider, $mdThemingProvider, $mdDateLocaleProvider,
        cfpLoadingBarProvider, $httpProvider) {

        $httpProvider.interceptors.push('httpRequestInterceptor');

        cfpLoadingBarProvider.includeSpinner = false;

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
            return date ? moment(date).format('L') : '';
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

            var filterLast = JSON.parse(localStorage.getItem('filter')) || {};

            if (!filterLast[toState.url.split('/')[1]]) {
                localStorage.removeItem('filter');
            }

            if (toState.name === 'login' || toState.name === 'register') {
                return;
            } else {
                var loggedIn = $rootScope.globals.currentUser;
                if (!loggedIn) {
                    $state.go('login');
                    localStorage.removeItem('filter');
                    event.preventDefault();
                } else if (toState.name === 'home') {
                    // redirecionar o primeiro state
                    $state.go('pagamento');
                    event.preventDefault();
                }
            }
        });
    }
})();