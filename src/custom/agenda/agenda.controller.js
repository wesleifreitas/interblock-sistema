define(['../controllers/module'], function(controllers) {
    'use strict';

    // Controller
    controllers.controller('AgendaCtrl', AgendaCtrl);

    AgendaCtrl.$inject = ['$scope', '$rootScope', '$compile', 'uiCalendarConfig', 'pxConfig', '$element', '$attrs', '$mdDialog'];

    function AgendaCtrl($scope, $rootScope, $compile, uiCalendarConfig, pxConfig, $element, $attrs, $mdDialog) {

        $scope.hello = 'Olá ' + $rootScope.globals.currentUser.usu_nome + ', veja seus próximos compromissos abaixo.'

        var date = new Date();
        var d = date.getDate();
        var m = date.getMonth();
        var y = date.getFullYear();

        $scope.changeTo = 'Hungarian';
        /* event source that pulls from google.com */
        $scope.eventSource = {
            /*
            url: "http://www.google.com/calendar/feeds/usa__en%40holiday.calendar.google.com/public/basic",
            className: 'gcal-event', // an option!
            currentTimezone: 'America/Chicago' // an option!
            */
        };
        /* event source that contains custom events on the scope */
        $scope.events = [{
            title: '1A',
            start: new Date(y, m, 1)
        }, {
            title: '1C',
            start: new Date(y, m, d - 5),
        }, {
            id: 999,
            title: '1B',
            start: new Date(y, m, d - 3, 16, 0),
            allDay: false
        }, {
            id: 999,
            title: '2B',
            start: new Date(y, m, d + 4, 16, 0),
            allDay: false
        }, {
            title: '3A',
            start: new Date(y, m, d + 1, 19, 0),
            end: new Date(y, m, d + 1, 22, 30),
            allDay: false
        }, {
            title: '2C',
            start: new Date(y, m, 28),
            end: new Date(y, m, 29),
            url: 'http://google.com/'
        }];
        /* event source that calls a function on every view switch */
        $scope.eventsF = function(start, end, timezone, callback) {
            var s = new Date(start).getTime() / 1000;
            var e = new Date(end).getTime() / 1000;
            var m = new Date(start).getMonth();
            var events = [{
                title: 'Feed Me ' + m,
                start: s + (50000),
                end: s + (100000),
                allDay: false,
                className: ['customFeed']
            }];
            callback(events);
        };

        $scope.calEventsExt = {
            color: '#f00',
            textColor: 'yellow',
            events: [{
                type: 'party',
                title: 'Lunch',
                start: new Date(y, m, d, 12, 0),
                end: new Date(y, m, d, 14, 0),
                allDay: false
            }, {
                type: 'party',
                title: 'Lunch 2',
                start: new Date(y, m, d, 12, 0),
                end: new Date(y, m, d, 14, 0),
                allDay: false
            }, {
                type: 'party',
                title: 'Click for Google',
                start: new Date(y, m, 28),
                end: new Date(y, m, 29),
                //url: 'http://google.com/'
            }]
        };
        /* alert on eventClick */
        $scope.alertOnEventClick = function(date, jsEvent, view) {
            $scope.alertMessage = (date.title + ' was clicked ');
        };
        /* alert on Drop */
        $scope.alertOnDrop = function(event, delta, revertFunc, jsEvent, ui, view) {
            $scope.alertMessage = ('Event Droped to make dayDelta ' + delta);
        };
        /* alert on Resize */
        $scope.alertOnResize = function(event, delta, revertFunc, jsEvent, ui, view) {
            $scope.alertMessage = ('Event Resized to make dayDelta ' + delta);
        };
        /* add and removes an event source of choice */
        $scope.addRemoveEventSource = function(sources, source) {
            var canAdd = 0;
            angular.forEach(sources, function(value, key) {
                if (sources[key] === source) {
                    sources.splice(key, 1);
                    canAdd = 1;
                }
            });
            if (canAdd === 0) {
                sources.push(source);
            }
        };
        /* add custom event*/
        $scope.addEvent = function() {
            $scope.events.push({
                title: 'Open Sesame',
                start: new Date(y, m, 28),
                end: new Date(y, m, 29),
                className: ['openSesame']
            });
        };
        /* remove event */
        $scope.remove = function(index) {
            $scope.events.splice(index, 1);
        };
        /* Change View */
        $scope.changeView = function(view, calendar) {
            uiCalendarConfig.calendars[calendar].fullCalendar('changeView', view);
        };
        /* Change View */
        $scope.renderCalender = function(calendar) {
            if (uiCalendarConfig.calendars[calendar]) {
                uiCalendarConfig.calendars[calendar].fullCalendar('render');
            }
        };
        /* Render Tooltip */
        $scope.eventRender = function(event, element, view) {
            element.attr({
                'tooltip': event.title,
                'tooltip-append-to-body': true
            });
            $compile(element)($scope);
        };
        /* config object */
        $scope.uiConfig = {
            calendar: {
                height: 450,
                editable: false,
                header: {
                    left: 'title',
                    center: '',
                    right: 'today prev,next'
                },
                monthNames: ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'],
                dayNames: ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"],
                dayNamesShort: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"],
                buttonText: {
                    today: 'Hoje'
                },
                eventClick: $scope.alertOnEventClick,
                eventDrop: $scope.alertOnDrop,
                eventResize: $scope.alertOnResize,
                eventRender: $scope.eventRender
            }
        };


        /* event sources array*/
        $scope.eventSources = [$scope.events, $scope.eventSource, $scope.eventsF];
        $scope.eventSources2 = [$scope.calEventsExt, $scope.eventsF, $scope.events];

        //$scope.changeLang();
    }
});