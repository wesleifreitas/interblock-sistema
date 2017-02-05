(function() {
    'use strict';

    angular
        .module('myApp')
        .factory('pagamentoService', pagamentoService);

    pagamentoService.$inject = ['config', '$http', '$q', '$mdToast', '$timeout'];

    function pagamentoService(config, $http, $q, $mdToast, $timeout) {
        var service = {};

        service.get = get;
        service.getById = getById;
        service.create = create;
        service.update = update;
        service.remove = remove;
        service.removeById = removeById;

        return service;

        function get(params) {

            var req = $http({
                    url: config.REST_URL + '/example/',
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    params: params
                })
                .then(handleSuccess, handleError);

            return req;
        }

        function getById(id) {

            var req = $http({
                    url: config.REST_URL + '/example/' + id,
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError);

            return req;
        }

        function create(data) {

            var req = $http({
                    url: config.REST_URL + '/example/',
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    data: data
                })
                .then(handleSuccess, handleError);

            return req;
        }

        function update(id, data) {

            var req = $http({
                    url: config.REST_URL + '/example/' + id,
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    data: data
                })
                .then(handleSuccess, handleError);

            return req;
        }

        function remove(data) {
            var req = $http({
                    url: config.REST_URL + '/example/',
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    data: data
                })
                .then(handleSuccess, handleError);

            return req;
        }

        function removeById(id) {
            var req = $http({
                    url: config.REST_URL + '/example/' + id,
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError);

            return req;
        }

        // private functions

        function handleSuccess(response) {

            if (response.data.message && response.data.message !== '') {

                $timeout(function() {
                    $mdToast.show(
                        $mdToast.simple()
                        .textContent(response.data.message)
                        .position('bottom right')
                        .hideDelay(3500)
                    );
                }, 1000);

            }

            return response.data;
        }

        function handleError(response) {

            if (!angular.isObject(response.data) || !response.data.message) {
                return ($q.reject('Ocorreu um erro desconhecido.'));
            }

            return ($q.reject(response.data.message));
        }
    }

})();