(function() {
    'use strict';

    angular
        .module('myApp')
        .factory('boletoService', boletoService);

    boletoService.$inject = ['config', '$http', '$q', '$mdToast', '$timeout'];

    function boletoService(config, $http, $q, $mdToast, $timeout) {
        var service = {};

        service.boleto = boleto;

        return service;

        function boleto(id) {

            var req = $http({
                    url: config.REST_URL + '/boleto/' + id,
                    method: 'GET',
                    headers: {
                        'Authorization': '',
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError);

            return req;
        }

        // private functions

        function handleSuccess(response) {
            console.info('handleSuccess', response);
            if (response.data.message && response.data.message !== '') {

                $timeout(function() {
                    $mdToast.show(
                        $mdToast.simple()
                        .textContent(response.data.message)
                        .position('bottom right')
                        .hideDelay(3500)
                    );
                }, 500);
            }

            return response.data;
        }

        function handleError(response) {
            console.info('handleError', response);
            if (!angular.isObject(response.data) || !response.data.Message) {
                response.data.Message = 'Ops! Ocorreu um erro desconhecido';
            }

            $mdToast.show(
                $mdToast.simple()
                .textContent(response.data.Message)
                .action('Fechar')
                .highlightAction(true)
                .highlightClass('md-accent')
                .position('bottom right')
                .hideDelay(0)
                .theme('error-toast')
            );

            return ($q.reject(response.data.Message));
        }
    }

})();