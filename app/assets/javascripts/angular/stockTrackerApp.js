var stockTrackerApp = angular.module('stockTrackerApp', ['ui.router',
  'ui.bootstrap', 'app', 'equity', 'offers', 'team', 'logout', 'faq', 'mentor',
  'invest', 'valuations', 'alertsService', 'reportDirective']);

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
      .state('faq', {
        controller: 'FaqCtrl',
        url: '/faq',
        templateUrl: '/templates/faq'
      })
      .state('team', {
        controller: 'TeamCtrl',
        controllerAs: 'team',
        url: '/team',
        templateUrl: '/templates/team'
      })
      .state('invest', {
        controller: 'InvestCtrl',
        controllerAs: 'invest',
        url: '/invest',
        templateUrl: '/templates/invest'
      })
      .state('mentorGroups', {
        controller: 'GroupsCtrl',
        controllerAs: 'groups',
        url: '/mentor/groups',
        templateUrl: '/templates/mentor.groups'
      })
      .state('mentorFaq', {
        controller: 'MentorFaqCtrl',
        controllerAs: 'faqCtrl',
        url: '/mentor/faq',
        templateUrl: '/templates/faq'
      })
      .state('mentorValuation', {
        controller: 'MentorValuationCtrl',
        url: '/mentor/valuation',
        templateUrl: '/templates/mentor.valuation'
      })
      .state('mentorProfessor', {
        controller: 'ProfessorCtrl',
        controllerAs: 'prof',
        url: '/mentor/all',
        templateUrl: '/templates/mentor.prof'
      })
      .state('mentorCSV', {
        controller: 'MentorCSVCtrl',
        url: '/mentor/csv',
        templateUrl: '/templates/mentor.csv'
      });

    $locationProvider.html5Mode(true); // Allows # routing
    $urlRouterProvider.otherwise('/equity'); // Default route
  }]);

stockTrackerApp.run(['$rootScope', 'Alerts', function ($rootScope, Alerts) {
  $rootScope.alert = Alerts;
}]);
