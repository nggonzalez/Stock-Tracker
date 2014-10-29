var stockTrackerApp = angular.module('stockTrackerApp', ['ui.router',
  'ui.bootstrap', 'app', 'equity', 'offers', 'team']);

stockTrackerApp.config(['$stateProvider', '$urlRouterProvider',
  '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
      .state('equity', {
        controller: 'EquityCtrl',
        controllerAs: 'equity',
        url: '/equity',
        templateUrl: '/templates/equity'
      })
      .state('offers', {
        controller: 'OffersCtrl',
        url: '/offers',
        templateUrl: '/templates/offers'
      })
      .state('team', {
        controller: 'TeamCtrl',
        controllerAs: 'team',
        url: '/team',
        templateUrl: '/templates/team'
      });

    $locationProvider.html5Mode(true); // Allows # routing
    $urlRouterProvider.otherwise('/equity'); // Default route
  }]);
