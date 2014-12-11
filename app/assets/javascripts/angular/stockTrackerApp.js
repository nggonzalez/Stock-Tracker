var stockTrackerApp = angular.module('stockTrackerApp', ['ui.router',
  'ui.bootstrap', 'app', 'equity', 'offers', 'team', 'logout', 'mentor',
  'alertsService']);

stockTrackerApp.config(['$stateProvider', '$urlRouterProvider',
  '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
      .state('logout', {
        url: '/logout',
        controller: 'LogoutCtrl'
      })
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
      })
      // .state('mentor', {
      //   controller: 'MentorCtrl',
      //   controllerAs: 'mentor',
      //   url: '/mentor',
      //   templateUrl: '/templates/mentor'
      // })
      .state('mentorGroups', {
        controller: 'GroupsCtrl',
        controllerAs: 'groups',
        url: '/mentor/groups',
        templateUrl: '/templates/mentor.groups'
      })
      .state('mentorProfessor', {
        controller: 'ProfessorCtrl',
        controllerAs: 'prof',
        url: '/mentor/prof',
        templateUrl: '/templates/mentor.prof'
      });

    $locationProvider.html5Mode(true); // Allows # routing
    $urlRouterProvider.otherwise('/equity'); // Default route
  }]);

stockTrackerApp.run(['$rootScope', 'Alerts', function ($rootScope, Alerts) {
  $rootScope.alert = Alerts;
}]);
