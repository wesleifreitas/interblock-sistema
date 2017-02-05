(function() {
    'use strict';

    angular.module('myApp').controller('AgendaCtrl', AgendaCtrl);

    AgendaCtrl.$inject = ['$scope', '$filter', 'agenda', '$state'];

    function AgendaCtrl($scope, $filter, agenda, $state) {

        var vm = this;
        vm.init = init;
        vm.selectedDate = '';
        vm.prevMonth = prevMonth;
        vm.nextMonth = nextMonth;
        vm.agenda = agenda;
        vm.yearStart = agenda.year;
        vm.monthStart = agenda.month;
        vm.setDayContent = setDayContent;

        function init() {}

        function prevMonth(event) {
            agendaReload(event.year, event.month - 1);
        }

        function nextMonth(event) {
            agendaReload(event.year, event.month - 1);
        }

        function agendaReload(year, month) {
            var date = new Date(year, month, 1);
            $state.go('agenda', { date: date });
        }

        function setDayContent(date) {
            date = moment(date).format('YYYYMMDD');
        }
    }
})();