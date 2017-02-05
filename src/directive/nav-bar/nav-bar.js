(function() {
    'use strict';

    angular.module('myApp').directive('navBar', navBar);

    navBar.$inject = ['$compile'];

    function navBar($compile) {
        var directive = {
            restrict: 'E',
            transclude: true,
            scope: {
                title: '@'
            },
            link: link,
            controller: controller
        };
        return directive;

        function link(scope, element, attrs, ngModel) {
            var watchNavBarHtml = scope.$watch('navBarHtml', function(newValue, oldValue) {
                if (newValue !== oldValue) {
                    element.html(scope.navBarHtml);
                    $compile(element.contents())(scope);
                    watchNavBarHtml();
                }
            });
        }

        controller.$inject = ['config', '$scope', '$http', '$rootScope', '$state'];

        function controller(config, $scope, $http, $rootScope, $state) {

            $scope.getNavBar = function() {
                var params = {};
                params.user = $rootScope.globals.currentUser.userid;

                $http({
                    method: 'GET',
                    url: config.REST_URL + '/navBar',
                    params: params
                }).then(function success(response) {
                    //console.info(response);
                    $scope.navBarHtml = response.data.navBar;
                }, function error(response) {
                    console.error(response);
                });
            };

            $scope.showView = function(view) {

                var params = {
                    menu: view
                };

                $http({
                    method: 'GET',
                    url: config.REST_URL + '/navBar/view',
                    params: params
                }).then(function success(response) {
                    console.info(response);

                    var state = '404';
                    if (response.status === 200 && response.data.query) {
                        state = response.data.query[0].COM_VIEW;
                        $state.go(state);
                    }

                }, function error(response) {
                    console.error(response);
                });
            };

            $scope.isMobile = function() {
                var userAgent = navigator.userAgent.toLowerCase();
                if (userAgent.search(/(android|avantgo|blackberry|bolt|boost|cricket|docomo|fone|hiptop|mini|mobi|palm|phone|pie|tablet|up\.browser|up\.link|webos|wos)/i) != -1) { // jshint ignore:line
                    return true;
                } else {
                    return false;
                }
            };

            // Inicializar menu
            $scope.getNavBar();
        }
    }
})();