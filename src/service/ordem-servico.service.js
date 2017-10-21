(function () {
    'use strict';

    angular
        .module('myApp')
        .factory('ordemServicoService', ordemServicoService);

    ordemServicoService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function ordemServicoService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.get = get;
        service.getById = getById;
        service.create = create;
        service.update = update;
        service.remove = remove;
        service.removeById = removeById;
        service.pdf = pdf;

        return service;

        function get(params) {

            var req = $http({
                url: config.REST_URL + '/ordem-servico/',
                method: 'GET',
                headers: {
                    'Authorization': '',
                    'Content-Type': 'application/json'
                },
                params: params
            })
                .then(handleSuccess, handleError);

            return req;
        }

        function getById(id) {

            var req = $http({
                url: config.REST_URL + '/ordem-servico/' + id,
                method: 'GET',
                headers: {
                    'Authorization': '',
                    'Content-Type': 'application/json'
                }
            })
                .then(handleSuccess, handleError);

            return req;
        }

        function create(data) {

            var req = $http({
                url: config.REST_URL + '/ordem-servico/',
                method: 'POST',
                headers: {
                    'Authorization': '',
                    'Content-Type': 'application/json'
                },
                data: data
            })
                .then(handleSuccess, handleError);

            return req;
        }

        function update(id, data) {

            var req = $http({
                url: config.REST_URL + '/ordem-servico/' + id,
                method: 'PUT',
                headers: {
                    'Authorization': '',
                    'Content-Type': 'application/json'
                },
                data: data
            })
                .then(handleSuccess, handleError);

            return req;
        }

        function remove(data) {
            var req = $http({
                url: config.REST_URL + '/ordem-servico/',
                method: 'DELETE',
                headers: {
                    'Authorization': '',
                    'Content-Type': 'application/json'
                },
                data: data
            })
                .then(handleSuccess, handleError);

            return req;
        }

        function removeById(id) {
            var req = $http({
                url: config.REST_URL + '/ordem-servico/' + id,
                method: 'DELETE',
                headers: {
                    'Authorization': '',
                    'Content-Type': 'application/json'
                }
            })
                .then(handleSuccess, handleError);

            return req;
        }

        function pdf(id) {

            var req = $http({
                url: config.REST_URL + '/ordem-servico/pdf/' + id,
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

                toastService.message(response);

            }

            return response.data;
        }

        function handleError(response) {
            console.error('handleError', response);
            if (!angular.isObject(response.data) || !response.data.Message) {
                response.data.Message = 'Ops! Ocorreu um erro desconhecido';
            }

            toastService.message(response);

            return ($q.reject(response.data.Message));
        }
    }

})();