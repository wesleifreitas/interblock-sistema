(function() {
    'use strict';

    angular.module('myApp').controller('BoletoDialogCtrl', BoletoDialogCtrl);

    BoletoDialogCtrl.$inject = ['config', 'boletoService', '$rootScope', '$scope', '$state', '$mdDialog',
        'pag_id'
    ];

    function BoletoDialogCtrl(config, boletoService, $rootScope, $scope, $state, $mdDialog,
        pag_id) {

        var vm = this;
        vm.init = init;
        vm.cancel = cancel;

        function init(event) {
            vm.loading = true;
            getData();
        }

        function getData() {
            boletoService.boleto(pag_id)
                .then(function success(response) {
                    console.info('getBlobByProtocolo', response);

                    var blob = toBinary(response.base64, 'application/pdf;base64');
                    var blobUrl = URL.createObjectURL(blob);

                    vm.pathPdf = 'pdf-viewer/web/viewer.cfm?file=' + blobUrl;
                    vm.loading = false;
                }, function error(error) {
                    vm.loading = false;
                    console.error(error);
                });
        }

        function cancel() {
            $mdDialog.cancel();
        }

        /**
         * Calcular a representação binária dos dados codificados em Base64 ou de um documento PDF
         * @param  {String} data        dados codificado em Base64
         * @param  {String} contentType natureza do arquivo http://www.freeformatter.com/mime-types-list.html
         * @param  {Number} sliceSize   tamanho
         * @return {String}             representação binária dos dados
         */
        function toBinary(data, contentType, sliceSize) {
            contentType = contentType || '';
            sliceSize = sliceSize || 512;

            /* jshint ignore:start */
            var byteCharacters = atob(data);
            var byteArrays = [];

            for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                var slice = byteCharacters.slice(offset, offset + sliceSize);

                var byteNumbers = new Array(slice.length);
                for (var i = 0; i < slice.length; i++) {
                    byteNumbers[i] = slice.charCodeAt(i);
                }

                var byteArray = new Uint8Array(byteNumbers);

                byteArrays.push(byteArray);
            }

            var blob = new Blob(byteArrays, {
                type: contentType
            });
            return blob;
            /* jshint ignore:end */
        }
    }
})();